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
                "vim",
                "lua",
                "vimdoc",
                "cpp",
                "c",
                "rust",
                "java",
                "python",
                "markdown",
                "markdown_inline",
                "yaml",
            },
            highlight = { enable = true },
        },
    },
}
