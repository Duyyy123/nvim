require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map({ "i" }, "jk", "<C-\\><C-n>", { silent = true })
map("v", "`", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <CR>")
map({ "n", "v", "t" }, "<leader>bd", "<cmd> bd! <CR>")
map("v", "<leader>e", "y:=<C-R>0<ENTER>", { noremap = true, silent = true })
map("n", "<A-k>", ":cd-<CR>")
map("n", "<C-S-r>", ":b#<CR>")

-- Mapping the function to a key (for example <leader>cd)
map("n", "<leader>cd", "<cmd>ChangeDirectory<CR>", { desc = "Change Directory", noremap = true, silent = true })
map("n", "<leader>rr", "<cmd>CompileAndExcute<CR>", { desc = "Run C, CPP, Rust, Java" })
map("n", "<leader>lg", "<cmd>ToggleLazyGit<CR>", { desc = "Toggle lazygit", noremap = true, silent = true })
map(
    "n",
    "<leader>fe",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    { desc = "View full error", noremap = true, silent = true }
)
