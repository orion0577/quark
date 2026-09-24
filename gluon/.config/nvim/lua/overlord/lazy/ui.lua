return {
  -- Keybind hint popup
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup {
        delay = 0,
        icons = {
          mappings = vim.g.have_nerd_font,
          keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-…> ',
            M = '<M-…> ',
            D = '<D-…> ',
            S = '<S-…> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            ScrollWheelDown = '<ScrollWheelDown> ',
            ScrollWheelUp = '<ScrollWheelUp> ',
            NL = '<NL> ',
            BS = '<BS> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
          },
        },

        spec = {
          { '<leader>s', group = '[S]earch' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },
      }
    end,
  },

  -- mini.nvim
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.icons').setup()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'

      statusline.setup {
        use_icons = vim.g.have_nerd_font,
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Alpha dashboard
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
      local startify = require 'alpha.themes.startify'

      startify.file_icons.provider = 'devicons'

      require('alpha').setup(startify.config)
    end,
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          diagnostics = 'nvim_lsp',
          offsets = {
            {
              filetype = 'snacks_layout_box',
              text = 'Explorer',
            },
          },
          separator_style = 'slant',
          always_show_bufferline = true,
          enforce_regular_tabs = true,
        },

        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
          },

          indicator_selected = {
            bold = true,
          },
        },
      }

      vim.keymap.set(
        'n',
        '<S-l>',
        '<cmd>BufferLineCycleNext<CR>',
        { desc = 'Next buffer' }
      )

      vim.keymap.set(
        'n',
        '<S-h>',
        '<cmd>BufferLineCyclePrev<CR>',
        { desc = 'Prev buffer' }
      )

      vim.keymap.set(
        'n',
        '<leader>d',
        '<cmd>bdelete<CR>',
        { desc = 'Close buffer' }
      )
    end,
  },

  -- Trouble
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    config = function()
      require('trouble').setup {}

      vim.keymap.set(
        'n',
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<CR>',
        { desc = 'Diagnostics (Trouble)' }
      )

      vim.keymap.set(
        'n',
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
        { desc = 'Buffer Diagnostics' }
      )

      vim.keymap.set(
        'n',
        '<leader>cs',
        '<cmd>Trouble symbols toggle<CR>',
        { desc = 'Symbols (Trouble)' }
      )
    end,
  },

  -- Aerial
  {
    'stevearc/aerial.nvim',
    event = 'VeryLazy',
    config = function()
      require('aerial').setup {}

      vim.keymap.set(
        'n',
        '<leader>v',
        '<cmd>AerialToggle!<CR>',
        { desc = 'Toggle outline [V]iew' }
      )
    end,
  },

  -- Oil
  {
    'stevearc/oil.nvim',
    lazy = false,
    config = function()
      local oil = require 'oil'

      oil.setup {
        columns = { 'icon' },

        keymaps = {
          ['<C-l>'] = false,
          ['<C-j>'] = false,
          ['<M-h>'] = 'actions.select_split',
          ['q'] = 'actions.close',
          ['<Esc>'] = 'actions.close',
        },

        view_options = {
          show_hidden = true,
        },
      }

      vim.keymap.set(
        'n',
        '-',
        oil.open,
        { desc = 'Open parent directory (oil)' }
      )

      vim.keymap.set(
        'n',
        '<leader>o',
        oil.toggle_float,
        { desc = 'Toggle oil float' }
      )
    end,
  },

  -- ToggleTerm
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      '<C-`>',
    },
    config = function()
      require('toggleterm').setup {
        size = 15,
        direction = 'horizontal',
        shade_terminals = true,
      }

      vim.keymap.set('n', '<C-`>', function()
        local dir = vim.fn.expand '%:p:h'

        if dir == '' or vim.fn.isdirectory(dir) == 0 then
          local cwd = vim.uv.cwd()
          dir = cwd or '.'
        end

        vim.cmd('ToggleTerm dir=' .. vim.fn.fnameescape(dir))
      end, {
        desc = 'Toggle terminal (buffer directory)',
      })
    end,
  },
}
