return {
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
