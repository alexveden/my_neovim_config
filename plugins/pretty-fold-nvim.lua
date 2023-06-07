return {
    {
        'anuvyklack/pretty-fold.nvim',
        lazy = true,
        enabled = true,
        config = function(_, _)
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
