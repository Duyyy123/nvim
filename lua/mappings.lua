require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map({ "t", "i" }, "jk", "<C-\\><C-n>", { silent = true })
map("v", "`", "<ESC>")
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <CR>")
map("t", "<ESC>", "<C-\\><C-n>", { silent = true })
map("n", "<C-M>", ":cd %:h<CR>")
map("v", "<leader>e", "y:=<C-R>0<ENTER>", { noremap = true, silent = true })
map("n", "<A-k>", ":cd-<CR>")
map("n", "<C-S-r>", ":b#<CR>")
map("n", "<leader>rr", function()
    -- Get the full file path and the file path without extension
    local full_path = vim.fn.expand "%:."
    local path_without_ext = vim.fn.expand "%:.:r"
    local file_ext = vim.fn.expand "%:e"
    local buffer_dir = vim.fn.expand "%:h"
    local pwd = vim.fn.getcwd()
    -- Function to find the nearest Cargo.toml file
    local function find_cargo_toml(start_dir)
        local current_dir = start_dir
        while current_dir ~= "/" do
            -- Convert to absolute path
            -- local absolute_path = vim.fn.resolve(current_dir .. "/Cargo.toml")
            if vim.fn.filereadable(current_dir .. "/Cargo.toml") == 1 then
                return current_dir .. "/Cargo.toml"
            end
            -- Move one level up
            local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
            current_dir = parent_dir
        end
        return nil
    end

    -- Find the nearest Cargo.toml file
    local cargo_toml_path
    if vim.fn.filereadable(vim.fn.fnamemodify(buffer_dir, ":h") .. "/Cargo.toml") == 1 then
        cargo_toml_path = vim.fn.fnamemodify(buffer_dir, ":h") .. "/Cargo.toml"
    end

    -- Find which type of file of buffer
    local compile_type
    if file_ext == "c" then
        compile_type = "gcc"
    elseif file_ext == "cpp" then
        compile_type = "g++"
    elseif file_ext == "rs" then
        compile_type = "rustc"
    end

    -- Path to access binary file
    local run_binary = "./" .. path_without_ext

    -- Function to find relative path of 2 directory
    local function relative_path(dir1, dir2)
        -- Split the paths into components
        local function split_path(path)
            local components = {}
            for component in string.gmatch(path, "[^/]+") do
                table.insert(components, component)
            end
            return components
        end

        local components1 = split_path(dir1)
        local components2 = split_path(dir2)

        -- Find the common prefix
        local i = 1
        while i <= #components1 and i <= #components2 and components1[i] == components2[i] do
            i = i + 1
        end

        -- Calculate how many steps to go back from dir1 to the common prefix
        local back_steps = #components1 - i + 1

        -- Build the relative path
        local result = {}
        for _ = 1, back_steps do
            table.insert(result, "..")
        end

        for j = i, #components2 do
            table.insert(result, components2[j])
        end

        return table.concat(result, "/")
    end
    local current_buffer_dir = vim.fn.expand "%:p:r"
    run_binary = "./" .. relative_path(pwd, current_buffer_dir)

    -- Compile and run command on buffer file
    local compile_command = compile_type
        .. " "
        .. full_path
        .. " -o "
        .. path_without_ext
        .. " && "
        .. run_binary
        .. "\n"
    -- change command to run project instead of source code in rust
    if file_ext == "rs" and cargo_toml_path ~= nil then
        compile_command = "cargo run --manifest-path=" .. cargo_toml_path .. "\n"
    end

    -- Check if NvChad terminal already exists
    local term_exists = false
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match "term://" then
            term_exists = true
            vim.api.nvim_set_current_win(win) -- Focus on existing terminal
            break
        end
    end

    -- If terminal does not exist, open a new one
    if not term_exists then
        -- Open a new NvChad terminal in a split
        require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }

        -- Wait a bit for the terminal to be ready
        vim.defer_fn(function()
            -- Send the compile and run command and execute it
            vim.api.nvim_chan_send(vim.b.terminal_job_id, compile_command)

            -- Move cursor to the buffer window
            vim.cmd "wincmd k"
        end, 100)
    else
        -- If terminal exists, just send the compile and run command
        vim.fn.chansend(vim.b.terminal_job_id, compile_command)
        -- Move cursor to the buffer window
        vim.cmd "wincmd k"
    end
end, { desc = "Run C, CPP, Rust" })

-- 1 + 2 + 3
