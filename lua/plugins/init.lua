return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- uncomment for format on save
        config = function()
            require "configs.conform"
        end,
    },
    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require "configs.lspconfig"
        end,
        lazy = false,
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- java
                "jdtls",
                -- "java-language-server",
                -- lua
                "lua-language-server",
                "stylua",
                -- c/cpp
                "clangd",
                "clang-format",
                -- rust
                "rust-analyzer",
                "bacon-ls",
                -- python
                "debugpy",
                "pyright",
                "ruff",
                -- c_sharp
                "csharpier",
                "netcoredbg",
                -- DAP
                "codelldb",
                -- linter
                "codespell",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "java",
                "vim",
                "lua",
                "vimdoc",
                "cpp",
                "c",
                "c_sharp",
                "python",
                "rust",
                "markdown",
                "markdown_inline",
                "r",
                "rnoweb",
                "yaml",
            },
            highlight = { enable = true },
        },
    },

    { "MunifTanjim/nui.nvim", lazy = true },
    { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
    -- Copilot
    {
        "github/copilot.nvim",
        url = "git@github.com:github/copilot.vim.git",
        config = function()
            -- Set Copilot accept suggestion key to "l"
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "l", 'copilot#Accept("l")', { silent = true, expr = true, noremap = true })
        end,
        lazy = false,
    },
    -- R language setup
    {
        "R-nvim/R.nvim",
        -- Only required if you also set defaults.lazy = true
        lazy = false,
        -- R.nvim is still young and we may make some breaking changes from time
        -- to time. For now we recommend pinning to the latest minor version
        -- like so:
        version = "~0.1.0",
        -- config = function()
        --     -- Create a table with the options to be passed to setup()
        --     local opts = {
        --         hook = {
        --             on_filetype = function()
        --                 vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
        --                 vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
        --             end,
        --         },
        --         R_args = { "--quiet", "--no-save" },
        --         min_editor_width = 72,
        --         rconsole_width = 78,
        --         objbr_mappings = { -- Object browser keymap
        --             c = "class", -- Call R functions
        --             ["<localleader>gg"] = "head({object}, n = 15)", -- Use {object} notation to write arbitrary R code.
        --             v = function()
        --                 -- Run lua functions
        --                 require("r.browser").toggle_view()
        --             end,
        --         },
        --         disable_cmds = {
        --             "RClearConsole",
        --             "RCustomStart",
        --             "RSPlot",
        --             "RSaveClose",
        --         },
        --     }
        --     -- Check if the environment variable "R_AUTO_START" exists.
        --     -- If using fish shell, you could put in your config.fish:
        --     -- alias r "R_AUTO_START=true nvim"
        --     if vim.env.R_AUTO_START == "true" then
        --         opts.auto_start = "on startup"
        --         opts.objbr_auto_start = true
        --     end
        --     require("r").setup(opts)
        -- end,
    },
    {
        "R-nvim/cmp-r",
        -- {
        --     "hrsh7th/nvim-cmp",
        --     config = function()
        --         require("cmp").setup { sources = { { name = "cmp_r" } } }
        --         require("cmp_r").setup {}
        --     end,
        -- },
    },

    -- image viewing
    -- {
    --     "vhyrro/luarocks.nvim",
    --     priority = 1001, -- this plugin needs to run before anything else
    --     opts = {
    --         rocks = { "magick" },
    --     },
    --     lazy = false,
    -- },
    {
        "3rd/image.nvim",
        config = function()
            -- default config
            require("image").setup {
                backend = "kitty",
                integrations = {
                    markdown = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
                        resolve_image_path = function(document_path, image_path, fallback)
                            -- document_path is the path to the file that contains the image
                            -- image_path is the potentially relative path to the image. for
                            -- markdown it's `![](this text)`

                            -- you can call the fallback function to get the default behavior
                            return fallback(document_path, image_path)
                        end,
                    },
                    neorg = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        filetypes = { "norg" },
                    },
                    html = {
                        enabled = true,
                    },
                    css = {
                        enabled = false,
                    },
                },
                max_width = nil,
                max_height = nil,
                max_width_window_percentage = nil,
                max_height_window_percentage = 50,
                window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
                window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
                editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
                tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
                hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
            }
        end,
        lazy = false,
    },

    -- markdown preview
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
        lazy = false,
    },

    -- Competitive programming helper
    {
        "xeluxee/competitest.nvim",
        dependencies = "MunifTanjim/nui.nvim",
        -- cmd = { "CompetiTest" },
        config = function()
            require("competitest").setup {
                testcases = {
                    ui = {
                        interface = "split", -- Split layout for test cases and outputs
                        split = "horizontal", -- Horizontal split layout
                        position = "right", -- Right position of the splits
                    },
                },
                split = {
                    vertical = {
                        enabled = true, -- Enable vertical split for the test case view
                        size = 40, -- Adjust the width for the split layout
                    },
                },
            }
        end,
        lazy = false,
    },

    -- Session handle
    {
        "rmagatti/auto-session",
        lazy = false,
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            -- Will use Telescope if installed or a vim.ui.select picker otherwise
            { "<leader>wS", "<cmd>SessionSearch<CR>", desc = "Session search" },
            { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
            { "<leader>wA", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
        },

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            -- ⚠️ This will only work if Telescope.nvim is installed
            -- The following are already the default values, no need to provide them if these are already the settings you want.
            session_lens = {
                -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
                load_on_setup = true,
                previewer = false,
                mappings = {
                    -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                    delete_session = { "i", "<C-D>" },
                    alternate_session = { "i", "<C-S>" },
                },
                -- Can also set some Telescope picker options
                theme_conf = {
                    border = true,
                    -- layout_config = {
                    --   width = 0.8, -- Can set width and height as percent of window
                    --   height = 0.5,
                    -- },
                },
            },
        },
        config = function()
            require("auto-session").setup {
                enabled = true, -- Enables/disables auto creating, saving and restoring
                root_dir = vim.fn.stdpath "data" .. "/sessions/", -- Root dir where sessions will be stored
                auto_save = true, -- Enables/disables auto saving session on exit
                auto_restore = true, -- Enables/disables auto restoring session on start
                auto_create = true, -- Enables/disables auto creating new session files. Can take a function that should return true/false if a new session file should be created or not
                suppressed_dirs = nil, -- Suppress session restore/create in certain directories
                allowed_dirs = nil, -- Allow session restore/create in certain directories
                auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
                use_git_branch = false, -- Include git branch name in session name
                lazy_support = true, -- Automatically detect if Lazy.nvim is being used and wait until Lazy is done to make sure session is restored correctly. Does nothing if Lazy isn't being used. Can be disabled if a problem is suspected or for debugging
                bypass_save_filetypes = nil, -- List of file types to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
                close_unsupported_windows = true, -- Close windows that aren't backed by normal file before autosaving a session
                args_allow_single_directory = true, -- Follow normal session save/load logic if launched with a single directory as the only argument
                args_allow_files_auto_save = false, -- Allow saving a session even when launched with a file argument (or multiple files/dirs). It does not load any existing session first. While you can just set this to true, you probably want to set it to a function that decides when to save a session when launched with file args. See documentation for more detail
                continue_restore_on_error = true, -- Keep loading the session even if there's an error
                cwd_change_handling = false, -- Follow cwd changes, saving a session before change and restoring after
                log_level = "error", -- Sets the log level of the plugin (debug, info, warn, error).

                session_lens = {
                    load_on_setup = true, -- Initialize on startup (requires Telescope)
                    theme_conf = { -- Pass through for Telescope theme options
                        -- layout_config = { -- As one example, can change width/height of picker
                        --   width = 0.8,    -- percent of window
                        --   height = 0.5,
                        -- },
                    },
                    previewer = false, -- File preview for session picker

                    mappings = {
                        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                        delete_session = { "i", "<C-D>" },
                        alternate_session = { "i", "<C-S>" },
                    },

                    session_control = {
                        control_dir = vim.fn.stdpath "data" .. "/auto_session/", -- Auto session control dir, for control files, like alternating between two sessions with session-lens
                        control_filename = "session_control.json", -- File name of the session control file
                    },
                },
            }
        end,
    },

    -- Toggle terminal
    {
        "akinsho/toggleterm.nvim",
        config = true,
        cmd = "ToggleTerm",
        keys = { { "<F2>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" } },
        opts = {
            open_mapping = [[<F2>]],
            direction = "float",
            shade_filetypes = {},
            hide_numbers = true,
            insert_mappings = true,
            terminal_mappings = true,
            start_in_insert = true,
            close_on_exit = true,
        },
    },

    -- Testing
    { "nvim-neotest/nvim-nio" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "alfaix/neotest-gtest",
            -- "antoinemadec/FixCursorHold.nvim",
            -- "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            -- Can be a list of adapters like what neotest expects,
            -- or a list of adapter names,
            -- or a table of adapter names, mapped to adapter configs.
            -- The adapter will then be automatically loaded with the config.
            -- Example for loading neotest-golang with a custom config
            adapters = {
                -- ["neotest-golang"] = {
                --     go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
                --     dap_go_enabled = true,
                -- },
                ["neotest-rust"] = {
                    args = { "--no-capture" },
                },
            },
            status = { virtual_text = true },
            output = { open_on_run = true },
            quickfix = {
                open = function()
                    if vim.has "trouble.nvim" then
                        require("trouble").open { mode = "quickfix", focus = false }
                    else
                        vim.cmd "copen"
                    end
                end,
            },
        },
        config = function(_, opts)
            local neotest_ns = vim.api.nvim_create_namespace "neotest"
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- Replace newline and tab characters with space for more compact diagnostics
                        local message =
                            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, neotest_ns)

            if vim.has "trouble.nvim" then
                opts.consumers = opts.consumers or {}
                -- Refresh and auto close trouble after running tests
                ---@type neotest.Consumer
                opts.consumers.trouble = function(client)
                    client.listeners.results = function(adapter_id, results, partial)
                        if partial then
                            return
                        end
                        local tree = assert(client:get_position(nil, { adapter = adapter_id }))

                        local failed = 0
                        for pos_id, result in pairs(results) do
                            if result.status == "failed" and tree:get_key(pos_id) then
                                failed = failed + 1
                            end
                        end
                        vim.schedule(function()
                            local trouble = require "trouble"
                            if trouble.is_open() then
                                trouble.refresh()
                                if failed == 0 then
                                    trouble.close()
                                end
                            end
                        end)
                        return {}
                    end
                end
            end

            if opts.adapters then
                local adapters = {}
                for name, config in pairs(opts.adapters or {}) do
                    if type(name) == "number" then
                        if type(config) == "string" then
                            config = require(config)
                        end
                        adapters[#adapters + 1] = config
                    elseif config ~= false then
                        local adapter = require(name)
                        if type(config) == "table" and not vim.tbl_isempty(config) then
                            local meta = getmetatable(adapter)
                            if adapter.setup then
                                adapter.setup(config)
                            elseif adapter.adapter then
                                adapter.adapter(config)
                                adapter = adapter.adapter
                            elseif meta and meta.__call then
                                adapter(config)
                            else
                                error("Adapter " .. name .. " does not support setup")
                            end
                        end
                        adapters[#adapters + 1] = adapter
                    end
                end
                opts.adapters = adapters
            end

            require("neotest").setup(opts)
        end,
        -- stylua: ignore
        keys = {
            {"<leader>t", "", desc = "+test"},
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
            { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
            { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
            { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
            { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
        },
    },

    -- debugger
    {
        "rcarriga/nvim-dap-ui",
        -- event = "VeryLazy",
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle {}
                end,
                desc = "Dap UI",
            },
            {
                "<leader>de",
                function()
                    require("dapui").eval()
                end,
                desc = "Eval",
                mode = { "n", "v" },
            },
        },
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        -- event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {},
        },
    },
    {
        "mfussenegger/nvim-dap",
        recommended = true,

        dependencies = {
            "rcarriga/nvim-dap-ui",
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
        },

        -- stylua: ignore
        keys = {
            { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<leader>dj", function() require("dap").down() end, desc = "Down" },
            { "<leader>dk", function() require("dap").up() end, desc = "Up" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
            { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<leader>ds", function() require("dap").session() end, desc = "Session" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
            { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
        },
        config = function()
            local dap = require "dap"
            -- gdb debugger
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-i", "dap" },
            }
            -- codelldb debugger
            dap.adapters.codelldb = {
                type = "server",
                host = "127.0.0.1",
                port = "1300",
                executable = {
                    command = "codelldb",
                    args = { "--port", "1300" },
                    -- On windows you may have to uncomment this:
                    -- detached = false,
                },
            }
            dap.configurations.rust = {
                {
                    name = "Run executable (Codelldb)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Run executable with arguments (Codelldb)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    args = function()
                        local args_str = vim.fn.input {
                            prompt = "Arguments: ",
                        }
                        return vim.split(args_str, " +")
                    end,

                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Run executable (GDB)",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    -- stopOnEntry = false,
                    stopAtBeginningOfMainSubprogram = true,
                },
                {
                    name = "Run executable with arguments (GDB)",
                    type = "gdb",
                    request = "launch",
                    -- This requires special handling of 'run_last', see
                    -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
                    program = function()
                        local path = vim.fn.input {
                            prompt = "Path to executable: ",
                            default = vim.fn.getcwd() .. "/",
                            completion = "file",
                        }

                        return (path and path ~= "") and path or dap.ABORT
                    end,
                    args = function()
                        local args_str = vim.fn.input {
                            prompt = "Arguments: ",
                        }
                        return vim.split(args_str, " +")
                    end,
                    stopAtBeginningOfMainSubprogram = true,
                },
                {
                    name = "Attach to process (GDB)",
                    type = "gdb",
                    request = "attach",
                    processId = require("dap.utils").pick_process,
                    stopAtBeginningOfMainSubprogram = true,
                },
            }
            dap.configurations.c = dap.configurations.rust
            dap.configurations.cpp = dap.configurations.rust

            -- -- python debugger
            -- dap.adapters.python = function(cb, config)
            --     if config.request == "attach" then
            --         ---@diagnostic disable-next-line: undefined-field
            --         local port = (config.connect or config).port
            --         ---@diagnostic disable-next-line: undefined-field
            --         local host = (config.connect or config).host or "127.0.0.1"
            --         cb {
            --             type = "server",
            --             port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            --             host = host,
            --             options = {
            --                 source_filetype = "python",
            --             },
            --         }
            --     else
            --         cb {
            --             type = "executable",
            --             command = "./.local/share/nvim/mason/packages/debugpy/venv/bin/python",
            --             args = { "-m", "debugpy.adapter" },
            --             options = {
            --                 source_filetype = "python",
            --             },
            --         }
            --     end
            -- end
            -- --python
            -- dap.configurations.python = {
            --     {
            --         -- The first three options are required by nvim-dap
            --         type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
            --         request = "launch",
            --         name = "Launch file",
            --
            --         -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
            --
            --         program = "${file}", -- This configuration will launch the current file if used.
            --         pythonPath = function()
            --             -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            --             -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            --             -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            --             local cwd = vim.fn.getcwd()
            --             if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            --                 return cwd .. "/venv/bin/python"
            --             elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            --                 return cwd .. "/.venv/bin/python"
            --             else
            --                 return "/usr/bin/python"
            --             end
            --         end,
            --     },
            -- }
            -- rust
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        -- stylua: ignore
        keys = {
            { "<leader>dyf", function() require("dap-python").test_method() end, desc = "Python test method" },
            { "<leader>dyf", function() require("dap-python").test_class() end, desc = "Python test class" },
            { "<leader>dys", function() require("dap-python").debug_selection() end, desc = "Python debug selection" },
        },
        config = function()
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },
}
