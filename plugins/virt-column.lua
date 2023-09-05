return {
    {
        "lukas-reineke/virt-column.nvim",
        -- lazy = false,
        event = "BufRead",
        opts = function(_, _)
            require("virt-column").setup()
        end,
    },
}
