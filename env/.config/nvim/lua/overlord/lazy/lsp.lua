local root_files = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
}

return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "stevearc/conform.nvim",

        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",

        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        "j-hui/fidget.nvim",
    },


    config = function()

        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")


        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )


        -- formatter
        require("conform").setup({
            formatters_by_ft = {}
        })


        -- UI
        require("fidget").setup({})
        require("mason").setup()


        -- LSP servers
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "qmlls",
            },

            handlers = {

                function(server)
                    require("lspconfig")[server].setup({
                        capabilities = capabilities,
                    })
                end,


                lua_ls = function()

                    require("lspconfig").lua_ls.setup({

                        capabilities = capabilities,

                        root_dir = require("lspconfig").util.root_pattern(
                            unpack(root_files)
                        ),

                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = {
                                        "vim",
                                    },
                                },

                                workspace = {
                                    checkThirdParty = false,
                                },

                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })

                end,
            },
        })



        -- completion
        cmp.setup({

            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },


            mapping = cmp.mapping.preset.insert({

                ["<C-n>"] = cmp.mapping.select_next_item(),

                ["<C-p>"] = cmp.mapping.select_prev_item(),

                ["<C-Space>"] = cmp.mapping.complete(),


                ["<Tab>"] = cmp.mapping(function(fallback)

                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end

                end, { "i", "s" }),


                ["<S-Tab>"] = cmp.mapping(function(fallback)

                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end

                end, { "i", "s" }),
            }),



            sources = {

                { name = "nvim_lsp" },

                { name = "luasnip" },

                -- ~/.config/foo completion
                { name = "path" },

                { name = "buffer" },

            },
        })



        -- diagnostics
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            severity_sort = true,

            float = {
                border = "rounded",
            },
        })


    end,
}
