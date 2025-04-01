-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local util = require "lspconfig/util"
local lspconfig = require "lspconfig"
local servers = { "html", "cssls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    }
end

-- typescript
lspconfig.ts_ls.setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
}
-- SQL
-- lspconfig.sqls.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
-- }

-- C plus plus
lspconfig.clangd.setup {
    -- root_dir = util.root_pattern("compile_commands.json", "CMakeLists.txt", ".clangd"),
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp" },
}

-- R language
lspconfig.r_language_server.setup {
    lazy = false,
    cmd = { "R", "--slave", "-e", "languageserver::run()" },
    filetypes = { "r", "rmd" }, -- Add any other filetypes if needed
    root_dir = lspconfig.util.root_pattern(".git", "."),
    settings = {
        r = {
            lsp = {
                diagnostics = true, -- Enable diagnostics
                server_capabilities = {
                    definitionProvider = true,
                },
            },
        },
    },
    on_attach = function(client, bufnr)
        -- Set 4-space indentation for R files
        vim.bo[bufnr].shiftwidth = 4
        vim.bo[bufnr].tabstop = 4
        vim.bo[bufnr].expandtab = true -- Convert tabs to spaces

        -- Call your on_attach function if it’s defined
        if on_attach then
            on_attach(client, bufnr)
        end
    end,
    capabilities = capabilities,
}
-- Go
lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
            },
        },
    },
}
-- Rust
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,

    autostart = true,
    root_dir = util.root_pattern "Cargo.toml",
    filetypes = { "rust" },
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                allFeatures = true,
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
}
-- Java
lspconfig.jdtls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "java" },
}
-- Python
-- Helper function to check for virtual environment
local function find_nearest_venv_path(start_path)
    local uv = vim.loop
    local function is_venv(path)
        return uv.fs_stat(path .. "/bin/python") ~= nil
    end

    -- Function to get the parent directory
    local function get_parent_dir(path)
        return vim.fn.fnamemodify(path, ":h") -- Get parent directory
    end

    local dir = start_path
    while dir ~= "/" do -- Stop when we reach root
        -- Check for virtual environments (e.g., "env", "venv", or others)
        local venv_path = dir .. "/env" -- Change to your naming convention, e.g., env, venv
        if is_venv(venv_path) then
            return venv_path .. "/bin/python"
        end

        -- Check for Conda environment by looking for 'conda-meta'
        venv_path = dir .. "conda-meta"
        if is_venv(venv_path) then
            return venv_path .. "/bin/python"
        end

        dir = get_parent_dir(dir) -- Move to the parent directory
    end
end
lspconfig.pyright.setup {
    on_attach = function(client, bufnr)
        -- Find nearest virtual environment
        local buf_path = vim.api.nvim_buf_get_name(bufnr) -- Get the full path of the current buffer
        local venv_python = find_nearest_venv_path(buf_path)

        if venv_python then
            client.config.settings.python.pythonPath = venv_python
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        else
            print "No virtual environment found, using global Python"
        end
    end,
    capabilities = capabilities,
    filetypes = { "python" },
}

-- Unity
lspconfig.omnisharp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "OmniSharp",
        "-z",
        "--hostPID",
        tostring(vim.fn.getpid()),
        "DotNet:enablePackageRestore=false",
        "--encoding",
        "utf-8",
        "--languageserver",
        "FormattingOptions:EnableEditorConfigSupport=true",
        "Sdk:IncludePrereleases=true",
    },
    -- cmd = { "omnisharp", "-z", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
}
