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

-- serveral mapping for Competitest.nvim plugin:
-- run
-- show_ui
-- add_testcase
-- run_no_compile
-- edit_testcase x(number of the testcase need to editt)
-- delete_testcase x(number of the testcase need to delete)
-- convert (auto, files_to_single_file, single_file_to_files)
-- receive (testcase, problem, contest)
map("n", "<leader>cct", "<cmd>CompetiTest run<CR>", { desc = "Run test" })
map("n", "<leader>ccs", "<cmd>CompetiTest show_ui<CR>", { desc = "Show UI" })
map("n", "<leader>cca", "<cmd>CompetiTest add_testcase<CR>", { desc = "Add testcase" })
map("n", "<leader>ccr", "<cmd>CompetiTest run_no_compile<CR>", { desc = "Run without compile" })
map("n", "<leader>cce", "<cmd>EditTestcase<CR>", { desc = "Edit testcase" })
map("n", "<leader>ccd", "<cmd>DeleteTestcase<CR>", { desc = "Delete testcase" })
-- 1 is auto, 2 is files_to_single_file, 3 is single_file_to_files
map("n", "<leader>ccc", "<cmd>ConvertFileTestcase<CR>", { desc = "Convert" })
-- 1 is testcase, 2 is problem, 3 is contest
map("n", "<leader>ccv", "<cmd>ReceivedCompetiTest<CR>", { desc = "Receive" })
