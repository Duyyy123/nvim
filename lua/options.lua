require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

vim.o.shell = "/bin/zsh"

-- Fold config
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "1"

-- Set tab width to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-- Optional: Set auto-indenting
vim.opt.autoindent = true
vim.opt.smartindent = true

local function CompileAndExcuteRusCCpp()
    -- Get the full file path and the file path without extension
    local full_path = vim.fn.expand "%:."
    local path_without_ext = vim.fn.expand "%:.:r"
    local file_ext = vim.fn.expand "%:e"
    local buffer_dir = vim.fn.expand "%:h"
    local pwd = vim.fn.getcwd()
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

    -- Find which type of file of buffer
    local compile_type
    if file_ext == "c" then
        compile_type = "gcc"
    elseif file_ext == "cpp" then
        compile_type = "g++"
    elseif file_ext == "rs" then
        compile_type = "rustc"
    end
    -- Path to current buffer
    local current_buffer_dir = vim.fn.expand "%:p:r"

    -- Path to access binary file
    local run_binary = "./" .. relative_path(pwd, current_buffer_dir)

    -- Compile and run command on buffer file
    local compile_command = compile_type
        .. " "
        .. full_path
        .. " -o "
        .. path_without_ext
        .. " && "
        .. run_binary
        .. "\n"

    -- Find the nearest Cargo.toml file
    local bin_name = nil
    local cargo_toml_path = nil
    if vim.fn.filereadable(vim.fn.fnamemodify(buffer_dir, ":h") .. "/Cargo.toml") == 1 then
        cargo_toml_path = vim.fn.fnamemodify(buffer_dir, ":h") .. "/Cargo.toml"
    elseif vim.fn.filereadable(vim.fn.fnamemodify(buffer_dir, ":h:h") .. "/Cargo.toml") == 1 then
        cargo_toml_path = vim.fn.fnamemodify(buffer_dir, ":h:h") .. "/Cargo.toml"
        bin_name = vim.fn.fnamemodify(buffer_dir, ":t")
    end

    -- Change command to run project instead of source code in rust
    if file_ext == "rs" and cargo_toml_path ~= nil and bin_name ~= nil then
        compile_command = "cargo run --manifest-path=" .. cargo_toml_path .. " --bin " .. bin_name .. "\n"
    elseif file_ext == "rs" and cargo_toml_path ~= nil then
        compile_command = "cargo run --manifest-path=" .. cargo_toml_path .. "\n"
    end

    -- -- Check if NvChad terminal already exists
    -- local term_exists = false
    -- for _, win in pairs(vim.api.nvim_list_wins()) do
    --     local buf = vim.api.nvim_win_get_buf(win)
    --     local buf_name = vim.api.nvim_buf_get_name(buf)
    --
    --     -- Check if it's a terminal buffer
    --     if buf_name:match "term://" then
    --         local job_id = vim.b[buf].terminal_job_id
    --         -- Check if the job is not running
    --         if job_id and vim.fn.jobwait({ job_id }, 0)[1] ~= -1 then
    --             term_exists = true
    --             vim.api.nvim_set_current_win(win) -- Focus on terminal that is not running
    --             break
    --         end
    --     end
    -- end
    --
    -- -- If terminal does not exist, open a new one
    -- if not term_exists then
    --     -- Open a new NvChad terminal in a split
    --     require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
    --     -- Wait a bit for the terminal to be ready
    --     vim.defer_fn(function()
    --         -- Send the compile and run command and execute it
    --         vim.api.nvim_chan_send(vim.b.terminal_job_id, compile_command)
    --
    --         -- Move cursor to the buffer window
    --         vim.cmd "wincmd j"
    --     end, 100)
    -- else
    --     -- If terminal exists, just send the compile and run command
    --     vim.fn.chansend(vim.b.terminal_job_id, compile_command)
    --     -- Move cursor to the buffer window
    --     vim.cmd "wincmd j"
    -- end

    -- Check if NvChad terminal already exists
    local term_exists = false
    local valid_job_id = nil -- To store a valid terminal job ID

    for _, win in pairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)

        -- Check if it's a terminal buffer
        if buf_name:match "term://" then
            local job_id = vim.b[buf].terminal_job_id
            -- Check if the job is NOT running (jobwait returns a non-negative number)
            -- if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
            -- The terminal is running, so skip focusing it
            -- else
            -- Terminal is not running, focus on it
            term_exists = true
            valid_job_id = job_id -- Store the valid job ID to use later
            vim.api.nvim_set_current_win(win)
            break
            -- end
        end
    end

    -- If terminal does not exist, open a new one
    if not term_exists then
        -- Open a new NvChad terminal in a split
        require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }

        -- Wait a bit for the terminal to be ready
        vim.defer_fn(function()
            -- Use the valid terminal job ID to send the compile command
            valid_job_id = vim.b.terminal_job_id -- Update valid job_id from the new terminal
            -- valid_job_id = vim.b[vim.api.nvim_get_current_buf()].terminal_job_id
            if valid_job_id then
                vim.api.nvim_chan_send(valid_job_id, compile_command)
            else
                print "Error: Terminal job ID is invalid"
            end

            -- Move cursor to the buffer window
            vim.cmd "wincmd j"
        end, 100)
    else
        -- vim.cmd ""
        -- If terminal exists, send the compile and run command
        if valid_job_id then
            vim.fn.chansend(valid_job_id, compile_command)
        else
            print "Error: No valid terminal job ID found"
        end

        -- Move cursor to the buffer window
        vim.cmd "wincmd j"
    end
end
vim.api.nvim_create_user_command("CompileAndExcuteRusCCpp", CompileAndExcuteRusCCpp, {})

local function ChangeDirectory()
    local current_file = vim.api.nvim_buf_get_name(0) -- Get the current buffer's file name
    local current_dir = vim.fn.fnamemodify(current_file, ":p:h") -- Get the directory of the current buffer
    local is_rust_file = vim.fn.expand "%:e" == "rs" -- Check if the current file is a Rust file
    local cargo_toml_dir = nil
    local max_depth = 2 -- Set the maximum number of folders to traverse

    -- If it's a Rust file, look for Cargo.toml, but only traverse up to 2 folders
    if is_rust_file then
        local dir = current_dir
        for _ = 0, max_depth do
            if vim.fn.filereadable(dir .. "/Cargo.toml") == 1 then
                cargo_toml_dir = dir
                break
            end
            -- Move one directory up
            local parent_dir = vim.fn.fnamemodify(dir, ":h")
            if parent_dir == dir then
                break
            end -- Stop if we've reached the root directory
            dir = parent_dir
        end
    end

    -- If Cargo.toml is found, change to that directory
    if cargo_toml_dir then
        vim.cmd("cd " .. cargo_toml_dir)
        print("Changed directory to Cargo.toml directory: " .. cargo_toml_dir)
    else
        -- Otherwise, fallback to changing to the directory of the current buffer
        vim.cmd("cd " .. current_dir)
        print("Changed directory to buffer directory: " .. current_dir)
    end
end
vim.api.nvim_create_user_command("ChangeDirectory", ChangeDirectory, {})

local lazygit = nil
local function ToggleLazyGit()
    if not lazygit then
        lazygit = require("toggleterm.terminal").Terminal:new {
            cmd = "lazygit",
            hidden = true,
        }
    end
    lazygit:toggle()
end
vim.api.nvim_create_user_command("ToggleLazyGit", ToggleLazyGit, {})

-- Signal variable for auto-session activity
local auto_session_active = false

-- Set up auto-session hooks
vim.api.nvim_create_autocmd("User", {
    pattern = "AutoSessionRestorePre",
    callback = function()
        auto_session_active = true
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "AutoSessionRestorePost",
    callback = function()
        auto_session_active = false
    end,
})

-- Modify FocusGained and BufEnter autocmds
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    callback = function()
        if not auto_session_active then
            vim.cmd "checktime"
        end
    end,
})
