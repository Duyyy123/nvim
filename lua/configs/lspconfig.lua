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
lspconfig.tsserver.setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
}

-- C plus plus
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp" },
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
-- Python
lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
}
