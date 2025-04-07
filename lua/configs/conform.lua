local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        go = { "goimports-reviser" },
        sql = { "sql-formatter" },
        zsh = { "beautysh" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_format" }
            else
                return { "blacked-client", "isort", "black" }
            end
        end,
        cs = { "csharpier" },
        ["_"] = { "trim_whitespace" },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 5000,
        lsp_fallback = true,
    },
    formatters = {
        prettier = {
            command = "prettier",
            args = {
                "--stdin-filepath",
                "$FILENAME",
                "--tab-width",
                "4",
                "--use-tabs",
                "false",
            },
        },
    },
}

require("conform").setup(options)
