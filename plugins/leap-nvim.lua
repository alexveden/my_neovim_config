--[
--Leap is a general-purpose motion plugin for Neovim, building and improving primarily
--on vim-sneak, with the ultimate goal of establishing a new standard interface for
--moving around in the visible area in Vim-like modal editors. It aims to be consistent,
--reliable, needs zero configuration, and tries to get out of your way as much as possible.
--]
return {
  {
    "https://github.com/ggandor/leap.nvim",
    lazy = false,
    enabled = true,
    config = function()
      -- require("leap").leap { target_windows = { vim.fn.win_getid() } }
      local leap = require "leap"
      leap.opts.safe_labels = {}
      leap.opts.highlight_unlabeled_phase_one_targets = true
      leap.opts.substitute_chars = {
        [" "] = "␣",
        ['\r'] = '¬',
      }
      leap.opts.equivalence_classes = {
        " \t\r\n",
        --'[{(<',
        --']})>',
        { '"', "'", "`" },
      }
      -- Small fix of no highlight of first selection by leap
      vim.api.nvim_exec("hi Cursor guifg=#282c34 guibg=#e5c07b", true)

      -- Preventing insert mode cursor changing colors depending on code colorins
      vim.api.nvim_exec("hi iCursor guifg=#282c34 guibg=white", true)

      -- Folded text highlighting
      vim.api.nvim_exec("hi Folded guifg=#ffffff", true)

      vim.keymap.set(
        { "n", "o", "x" },
        "s",
        "<cmd>lua require('leap').leap { target_windows = { vim.fn.win_getid() } }<CR>",
        { desc = "Spider-w" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "gs",
        "<cmd>lua require('leap').leap { target_windows = vim.tbl_filter(function (win) return vim.api.nvim_win_get_config(win).focusable end, vim.api.nvim_tabpage_list_wins(0))}<CR>",
        { desc = "Spider-w" }
      )
    end,
  },
}
