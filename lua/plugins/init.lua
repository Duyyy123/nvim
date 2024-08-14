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
    },
    --
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- lua
                "lua-language-server",
                "stylua",
                -- c/cpp
                "clangd",
                "clang-format",
                -- rust
                "rust-analyzer",
                "bacon-ls",
                -- "rustfmt",
                -- python
                "debugpy",
                "pyright",
                "ruff",
                -- DAP
                "codespell",
                --
                "codelldb",
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "vimdoc",
                "cpp",
                "c",
                "python",
                "rust",
            },
        },
    },
    -- debugger
    {
        "nvim-neotest/nvim-nio",
    },
    {
        "nvim-neotest/neotest",
        dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "alfaix/neotest-gtest" },
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
    -- markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
