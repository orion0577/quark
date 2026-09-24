
local map = vim.keymap.set
local opts = { silent = true }

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")


-- greatest remap ever
map('v', 'p', '"_dP', { silent = true, desc = 'Paste without overwriting clipboard' })-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])



vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ bufnr = 0 })
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


map('n', '<S-q>', '<cmd>bdelete!<CR>', { silent = true, desc = 'Close buffer' })

map('n', '<Leader>1', '1gt', { silent = true, desc = 'Go to tab 1' })
map('n', '<Leader>2', '2gt', { silent = true, desc = 'Go to tab 2' })
map('n', '<Leader>3', '3gt', { silent = true, desc = 'Go to tab 3' })
map('n', '<Leader>4', '4gt', { silent = true, desc = 'Go to tab 4' })
map('n', '<Leader>5', '5gt', { silent = true, desc = 'Go to tab 5' })
map('n', '<Leader>t', '<cmd>tabnew<CR>', { silent = true, desc = 'New tab' })
map('n', '<A-q>', '<cmd>tabclose<CR>', { silent = true, desc = 'Close tab' })

map('n', '<leader>p', '<cmd>PasteImage<CR>', { silent = true, desc = '[P]aste image from clipboard' })

map('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sc', function() Snacks.picker.commands() end, { desc = '[S]earch [C]ommands' })
map('n', '<leader>sb', function() Snacks.picker.builtin() end, { desc = '[S]earch [B]uiltins' })
map('n', '<leader>sf', function() Snacks.picker.files() end, { desc = '[S]earch [F]iles' })
map('n', '<leader>fe', function() Snacks.explorer.open() end, { desc = '[F]iles [E]xplorer open tree' })
map('n', '<leader>ff', function() Snacks.picker.smart() end, { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', function() Snacks.picker.pickers() end, { desc = '[S]earch [S]elect Snacks' })
map({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
map('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
map('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = '[S]earch [P]rojects' })
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', function() Snacks.picker.recent() end, { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })
map('n', '<leader>/', function() Snacks.picker.lines {} end, { desc = '[/] Fuzzily search in current buffer' })
map('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = '[S]earch [/] in Open Files' })
map('n', '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
map('n', '<C-\\>', function() Snacks.zen() end, { desc = 'Toggle [Z]en mode' })
