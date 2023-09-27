return {
    {
        'anuvyklack/pretty-fold.nvim',
        lazy = true,
        enabled = true,
        event = "BufEnter", 
        config = function(_, _)
            -- Saving folds!
            --augroup remember_folds
            --   autocmd!
            --   autocmd BufWinLeave * mkview
            --   autocmd BufWinEnter * silent! loadview
            -- augroup END
            local save_fold_group = vim.api.nvim_create_augroup('save_fold_group', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
              pattern = '*.*',
              group = save_fold_group,
              command = 'mkview',
            })
            vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
              pattern = '*.*',
              group = save_fold_group,
              command = 'silent! loadview',
            })
            -- 

            require('pretty-fold').setup({
                ft_ignore = { 'python' },
                keep_indentation = true,
                fill_char = ' ',
                sections = {
                    left = {
                        '', 'content',
                    },
                    right = {
                        '━━━━━━━━━━━━┫ ', 'number_of_folded_lines', ': ', 'percentage',
                        ' ┣━━',
                    }
                }
            })
        end
    },
}
