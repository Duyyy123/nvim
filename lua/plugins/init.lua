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
    -- Outmeal
    -- return {
    --     "dustinblackman/oatmeal.nvim",
    --     cmd = { "Oatmeal" },
    --     keys = {
    --         { "<leader>om", mode = "n", desc = "Start Oatmeal session" },
    --     },
    --     opts = {
    --         backend = "ollama",
    --         model = "codellama:lastest",
    --     },
    -- }
}
