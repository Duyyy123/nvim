-- Competitive programming helper
return {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    -- cmd = { "CompetiTest" },
    config = function()
        require("competitest").setup {
            testcases = {
                ui = {
                    interface = "split", -- Split layout for test cases and outputs
                    split = "horizontal", -- Horizontal split layout
                    position = "right", -- Right position of the splits
                },
            },
            split = {
                vertical = {
                    enabled = true, -- Enable vertical split for the test case view
                    size = 40, -- Adjust the width for the split layout
                },
            },
        }
    end,
    lazy = false,
}
