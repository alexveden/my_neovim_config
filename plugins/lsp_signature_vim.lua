return {
    {
        "ray-x/lsp_signature.nvim",
        --
        -- enabled = false,
        event = "BufRead",
        tag = "v0.2.0",
        config = function(_, _)
            require("lsp_signature").setup({
                bind = true,
                hint_prefix = "󱧢 ", --""🐼 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
                toggle_key = '<C-q>', -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
                toggle_key_flip_floatwin_setting = true, -- true: toggle float setting after toggle key pressed
            })
        end,
    },
}
