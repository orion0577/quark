return {
	-- Grammarly LSP
	{
		"emacs-grammarly/lsp-grammarly",
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lint = require("lint")

			local lint_augroup = vim.api.nvim_create_augroup("lint", {
				clear = true,
			})

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					if vim.bo.modifiable then
						lint.try_lint()
					end
				end,
			})
		end,
	},

	-- Edit files as sudo
	{
		"lambdalisue/suda.vim",
		cmd = {
			"SudaRead",
			"SudaWrite",
		},
	},

	{
		-- Paste images from clipboard into Markdown
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		config = function()
			local year = os.date("%Y")

			require("img-clip").setup({
				default = {
					dir_path = "/home/orion/personal/Journal/images/" .. year .. "/",

					extension = "webp",

					process_cmd = "/usr/bin/cwebp -quiet -q 80 -o - -- - 2>/dev/null",

					template = "![$FILE_NAME_NO_EXT](images/" .. year .. "/$FILE_NAME)",

					relative_template_path = false,
				},

				filetypes = {
					markdown = {
						template = "![$FILE_NAME_NO_EXT](images/" .. year .. "/$FILE_NAME)",
					},
				},
			})
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "quarto" },
		opts = {},
	},

	-- Highlight hex/RGB/HSL colors
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
			})
		end,
	},

	-- Auto-save
	{
		"Pocco81/auto-save.nvim",
		event = { "InsertLeave", "TextChanged" },
		config = function()
			require("auto-save").setup({})
		end,
	},
}
