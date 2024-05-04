return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = vim.fn.has "win32" == 0
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "BufEnter",
    config = function()
      local ls = require "luasnip"
      local types = require "luasnip.util.types"

      -- vim.api.nvim_exec("hi LuasnipInsertNodePassive cterm=underline gui=underline", true)

      local opts = {
        history = true,
        delete_check_events = "TextChanged",
        region_check_events = "CursorMoved",
        ext_opts = {
          [types.insertNode] = {
            -- active = { hl_group = "@text.uri" },
            -- visited = {  hl_group = "@comment" },
            passive = { hl_group = "@text.uri" },
            snippet_passive = { hl_group = "@comment" },
          },
          [types.choiceNode] = {
            active = { hl_group = "@type", virt_text = { { "<- choose option", "@type" } } },
            unvisited = { hl_group = "@type" },
          },
          [types.snippet] = {
            passive = { hl_group = "@comment", virt_text = { { " 󰘦 ", "@type" } } },
            snippet_passive = { hl_group = "@comment", virt_text = { { " 󰘦 ", "@type" } } },
          },
        },
        -- treesitter-hl has 100, use something higher (default is 200).
        ext_base_prio = 300,
        -- minimal increase in priority.
        ext_prio_increase = 1,
      }
      ls.config.setup(opts)

      -- Loading friendly-snippets (exclude generic ones)
      require("luasnip.loaders.from_vscode").load {
        exclude = { "all" }, -- exclude generic 'all' snippets (e.g. lorem, dateYMD)
      }

      -- My custom snippets
      require("luasnip.loaders.from_lua").load { paths = "snippets" }

      -- Mapping
      vim.keymap.set({ "i", "v" }, "<Tab>", function()
        if not ls.in_snippet() then
          vim.api.nvim_input("<tab>")
        else
          if ls.jumpable(1) then
            ls.jump(1)
          else
            ls.unlink_current()
            vim.api.nvim_input("<esc>")
          end
        end
      end)

      vim.keymap.set({ "i", "v" }, "<S-Tab>", function()
        if not ls.in_snippet() then
          vim.api.nvim_input("<S-tab>")
        else
          if ls.jumpable(-1) then ls.jump(-1) end
        end
      end)

      vim.keymap.set({ "i", "v" }, "<Right>", function()
        if ls.in_snippet() then
          if ls.jumpable(1) then
            ls.jump(1)
          else
            -- Next right press when sniped finalized leads to snippet committing
            -- without commit it's possible to roll back to normal mode, and goto
            -- insert mode later (snippet fields will be active)
            ls.unlink_current()
            vim.api.nvim_input("<esc>")
          vim.cmd "norm! l"
          end
        else
          vim.cmd "norm! l"
        end
      end)

      -- NOTE: glitchy <CR> handling, moved to nvim-cmp.lua!
      -- vim.keymap.set({ "i", "v" }, "<CR>", function()
      --   print("luasnip-cr")
      --
      --   if ls.in_snippet() or ls.choice_active() then
      --     ls.unlink_current()
      --     -- vim.cmd "norm"
      --     vim.api.nvim_input("<esc><cr>")
      --   else
      --     -- print("norm")
      --     -- vim.cmd "norm! <ESC>"
      --     vim.cmd "norm! <CR>"
      --   end
      -- end)

      vim.keymap.set({ "i", "v" }, "<Left>", function()
        if ls.in_snippet() then
          if ls.jumpable(-1) then ls.jump(-1) end
        else
          vim.cmd "norm! h"
        end
      end)

      vim.keymap.set({ "i", "v" }, "<Up>", function()
        --if not ls.in_snippet() then
        if not ls.locally_jumpable(1) then
          vim.cmd "norm! k"
        else
          if ls.choice_active() then ls.change_choice(1) end
        end
      end)

      vim.keymap.set({ "i", "v" }, "<Down>", function()
        --if not ls.in_snippet() then
        if not ls.locally_jumpable(1) then
          vim.cmd "norm! j"
        else
          if ls.choice_active() then ls.change_choice(-1) end
        end
      end)

    end,
  },
}
