local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

return {
{ -- override nvim-cmp plugin
      "hrsh7th/nvim-cmp",
      -- enabled = false,
      -- override the options table that is used in the `require("cmp").setup()` call
      opts = function(_, opts)
        -- opts parameter is the default options table
        -- the function is lazy loaded so cmp is able to be required
        local cmp = require "cmp"
        -- modify the mapping part of the table
        opts.mapping['<C-PageUp>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" })
        opts.mapping['<C-PageDown>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" })
        
        -- Prevent jumps on Tab (annoying when python indent)
        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
                    local luasnip = require("luasnip")
                    if luasnip.in_snippet() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                })


        opts.sorting = {
                priority_weight = 1.0,
                comparators = {
                    -- compare.score_offset, -- not good at all
                    cmp.config.compare.locality,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                    cmp.config.compare.offset,
                    cmp.config.compare.order,
                    -- cmp.config.compare.scopes, -- what?
                    -- cmp.config.compare.sort_text,
                    -- cmp.config.compare.exact,
                    -- cmp.config.compare.kind,
                    -- cmp.config.compare.length, -- useless
                },
            }

        opts.sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }
        -- return the new table to be used
        return opts
      end,
    },
}
