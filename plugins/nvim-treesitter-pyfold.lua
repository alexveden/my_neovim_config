return {
    -- Disable UFO folding plugin (AstronVim 3.0 default)
    { "kevinhwang91/nvim-ufo", enabled = false },
    {
        enabled = true,
        dir = '/home/ubertrader/code/nvim-treesitter-pyfold',
        -- 'eddiebergman/nvim-treesitter-pyfold',
        --
        event = "BufEnter *.py,*.pyx,*.pxd",

        dependencies = "nvim-treesitter/nvim-treesitter",
        --
        config = function(_, _)
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldlevelstart = 1

            require('nvim-treesitter.configs').setup {
                pyfold = {
                    enable = true,
                    custom_foldtext = true, -- Sets provided foldtext on window where module is active
                }
            }
        end,
    }
}
