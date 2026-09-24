require("overlord")
vim.o.termguicolors = false

--require("overlord.lazy")
require("mason").setup()
--require("plugin.cmp").setup()
--require("plugin.lsp").setup()
require("overlord.remap")

require("overlord.set")
vim.o.clipboard = "unnamedplus"


-- Set the colorscheme first
ColorMyPencils()

-- Force statusline transparency
vim.cmd [[
  hi StatusLine guibg=NONE ctermbg=NONE
  hi StatusLineNC guibg=NONE ctermbg=NONE
]]


