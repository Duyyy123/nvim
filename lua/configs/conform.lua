local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        go = { "goimports-reviser" },
        zsh = { "beautysh" },
        python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_format" }
            else
                return { "blacked-client", "isort", "black" }
            end
        end,
        cs = { "csharpier" },
        -- r = { "styler" },
        -- ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
    },
    formatters = {
        csharpier = {
            command = "dotnet-csharpier",
            args = { "--write-stdout" },
        },
        styler = {
            command = "R",
            args = {
                "--slave",
                "-e",
                [[
                    file <- commandArgs(trailingOnly = TRUE)[1]
                    if (grepl("\\.R$|\\.Rmd$|\\.qmd$|\\.Rnw$|\\.r$", file)) {
                        styler::style_file(file, indentation = 2)
                    } else {
                        stop("File is not a valid R script.")
                    }
                ]],
            },
            stdin = true,
        },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

require("conform").setup(options)
