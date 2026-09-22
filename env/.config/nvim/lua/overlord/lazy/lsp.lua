return {
  -- LSP configuration
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Mason
      {
        'mason-org/mason.nvim',
        version = 'main',
        config = function()
          require('mason').setup()
        end,
      },

      -- Install Mason packages automatically
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
      },

      -- LSP progress notifications
      {
        'j-hui/fidget.nvim',
        version = 'main',
        config = function()
          require('fidget').setup()
        end,
      },

      -- Formatting
      {
        'stevearc/conform.nvim',
        config = function()
          require('conform').setup {
            notify_on_error = false,

            format_on_save = function(bufnr)
              local disable_filetypes = {
                c = true,
                cpp = true,
              }

              if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
              end

              return {
                timeout_ms = 500,
                lsp_format = 'fallback',
              }
            end,

            formatters_by_ft = {
              lua = { 'stylua' },

              -- python = { 'isort', 'black' },
              -- javascript = {
              --   'prettierd',
              --   'prettier',
              --   stop_after_first = true,
              -- },
            },
          }

          vim.keymap.set('', '<leader>=', function()
            require('conform').format {
              async = true,
              lsp_format = 'fallback',
            }
          end, {
            desc = '[F]ormat buffer',
          })
        end,
      },
    },

    config = function()
      -- LSP servers
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- LSP server name -> Mason package name
      local lsp_to_mason = {
        lua_ls = 'lua-language-server',
      }

      local ensure_installed = vim.tbl_keys(servers)

      for i, name in ipairs(ensure_installed) do
        if lsp_to_mason[name] then
          ensure_installed[i] = lsp_to_mason[name]
        end
      end

      vim.list_extend(ensure_installed, {
        'stylua',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      -- Blink capabilities
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Configure and enable LSP servers
      for name, cfg in pairs(servers) do
        local server = vim.tbl_deep_extend(
          'force',
          {},
          cfg
        )

        server.capabilities = vim.tbl_deep_extend(
          'force',
          {},
          capabilities,
          server.capabilities or {}
        )

        vim.lsp.config[name] = server
        vim.lsp.enable(name)
      end

      -- LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup(
          'lsp-attach',
          { clear = true }
        ),

        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'

            vim.keymap.set(
              mode,
              keys,
              func,
              {
                buffer = event.buf,
                desc = 'LSP: ' .. desc,
              }
            )
          end

          map(
            'grn',
            vim.lsp.buf.rename,
            '[R]e[n]ame'
          )

          map(
            'gra',
            vim.lsp.buf.code_action,
            '[G]oto Code [A]ction',
            { 'n', 'x' }
          )

          map(
            'grr',
            function()
              require('snacks').picker.lsp_references()
            end,
            '[G]oto [R]eferences'
          )

          map(
            'gri',
            function()
              require('snacks').picker.lsp_implementations()
            end,
            '[G]oto [I]mplementation'
          )

          map(
            'grd',
            function()
              require('snacks').picker.lsp_definitions()
            end,
            '[G]oto [D]efinition'
          )

          map(
            'grD',
            vim.lsp.buf.declaration,
            '[G]oto [D]eclaration'
          )

          map(
            'gO',
            function()
              require('snacks').picker.lsp_symbols()
            end,
            'Open Document Symbols'
          )

          map(
            'gW',
            function()
              require('snacks').picker.lsp_workspace_symbols()
            end,
            'Open Workspace Symbols'
          )

          map(
            'grt',
            function()
              require('snacks').picker.lsp_type_definitions()
            end,
            '[G]oto [T]ype Definition'
          )

          -- Document highlighting
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer
          ---@return boolean
          local function client_supports_method(
            client,
            method,
            bufnr
          )
            return client:supports_method(
              method,
              bufnr
            )
          end

          local client = vim.lsp.get_client_by_id(
            event.data.client_id
          )

          if client
            and client_supports_method(
              client,
              vim.lsp.protocol.Methods
                .textDocument_documentHighlight,
              event.buf
            )
          then
            local hl_group = vim.api.nvim_create_augroup(
              'lsp-highlight',
              { clear = false }
            )

            vim.api.nvim_create_autocmd(
              { 'CursorHold', 'CursorHoldI' },
              {
                buffer = event.buf,
                group = hl_group,
                callback = vim.lsp.buf.document_highlight,
              }
            )

            vim.api.nvim_create_autocmd(
              { 'CursorMoved', 'CursorMovedI' },
              {
                buffer = event.buf,
                group = hl_group,
                callback = vim.lsp.buf.clear_references,
              }
            )

            vim.api.nvim_create_autocmd(
              'LspDetach',
              {
                group = vim.api.nvim_create_augroup(
                  'lsp-detach',
                  { clear = true }
                ),

                callback = function(event2)
                  vim.lsp.buf.clear_references()

                  vim.api.nvim_clear_autocmds {
                    group = 'lsp-highlight',
                    buffer = event2.buf,
                  }
                end,
              }
            )
          end
        end,
      })

      -- Diagnostics
      vim.diagnostic.config {
        severity_sort = true,

        float = {
          border = 'rounded',
          source = 'if_many',
        },

        underline = {
          severity = vim.diagnostic.severity.ERROR,
        },

        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},

        virtual_text = {
          source = 'if_many',
          spacing = 2,

          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      }
    end,
  },
}
