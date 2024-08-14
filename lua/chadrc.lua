-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

--@type ChadrcConfig
local M = {}

M.ui = {
    theme = "bearded-arc",

    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    },
}
M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = {
            "<cmd> DapToggleBreakpoint <CR>",
            "Add breakpoint at line",
        },
        ["<leader>dr"] = {
            "<cmd> DapContinue <CR>",
            "Start or continue the debugger",
        },
    },
}
return M
