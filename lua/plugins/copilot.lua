-- Copilot
return {
    "github/copilot.nvim",
    url = "git@github.com:github/copilot.vim.git",
    config = function()
        -- Set Copilot accept suggestion key to "l"
        vim.g.copilot_no_tab_map = true
        vim.api.nvim_set_keymap("i", "l", 'copilot#Accept("l")', { silent = true, expr = true, noremap = true })
    end,
    lazy = false,
}
