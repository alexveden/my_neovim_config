local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

return {
  { -- override nvim-cmp plugin
    "hrsh7th/nvim-cmp",
    -- enabled = false,
    -- override the options table that is used in the `require("cmp").setup()` call
    dependencies = { "L3MON4D3/LuaSnip", "L3MON4D3/cmp-luasnip-choice" },
    opts = function(_, opts)
      local cmp = require "cmp"
      local ls = require "luasnip"
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      -- modify the mapping part of the table
      opts.mapping["<C-PageUp>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" })
      opts.mapping["<C-PageDown>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" })

      -- Prevent jumps on Tab (annoying when python indent)
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        fallback()
        -- if cmp.visible() then
        --   cmp.confirm({ select = true })
        -- else
        -- end
      end, {
        "i",
        "s",
      })
      opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        fallback()
        -- if cmp.visible() then
        --   cmp.confirm({ select = true })
        -- else
        -- end
      end, {
        "i",
        "s",
      })

      opts.mapping["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if ls.expandable() then
            ls.expand()
          else
            cmp.confirm {
              select = true,
            }
          end
        elseif ls.in_snippet() or ls.choice_active() then
          ls.unlink_current()
          vim.api.nvim_input "<esc><cr>"
        else
          fallback()
        end
      end, { "i", "c", "s", "n" })

      opts.mapping["<Down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "c" })

      opts.mapping["<Up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "c" })

      opts.snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      }

      opts.sorting = {
        priority_weight = 1.0,
        comparators = {
          -- compare.score_offset, -- not good at all
          cmp.config.compare.recently_used,
          cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
          cmp.config.compare.locality,
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
        { name = "luasnip_choice", priority = 1500 }, --- FIX: not working!
        { name = "luasnip", priority = 1000 },
        { name = "nvim_lsp", priority = 999 },
        { name = "buffer", priority = 500, option = {
          keyword_pattern = [[\k\+]],
        } },
        { name = "path", priority = 250 },
      }
      -- Set configuration for specific filetype.
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "luasnip", priority = 500 },
        }, {
          { name = "buffer", priority = 1000 },
        }),
      })
      -- return the new table to be used
      return opts
    end,
  },
}
