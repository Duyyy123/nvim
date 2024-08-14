local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        zsh = { "beautysh" },
        python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_format" }
            else
                return { "isort", "black" }
            end
        end,
        -- ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

require("conform").setup(options)
