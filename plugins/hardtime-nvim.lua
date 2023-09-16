-- lazy.nvim
return {
  {
    "m4xshen/hardtime.nvim",
    lazy = true,
    enabled = true,
    event = "BufEnter",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      local opts = {
        max_time = 1000,
        max_count = 3,
        disable_mouse = false,
        hint = true,
        notification = true,
        allow_different_key = false,
        enabled = true,
        resetting_keys = {
          ["1"] = { "n", "x" },
          ["2"] = { "n", "x" },
          ["3"] = { "n", "x" },
          ["4"] = { "n", "x" },
          ["5"] = { "n", "x" },
          ["6"] = { "n", "x" },
          ["7"] = { "n", "x" },
          ["8"] = { "n", "x" },
          ["9"] = { "n", "x" },
          ["c"] = { "n" },
          ["C"] = { "n" },
          ["d"] = { "n" },
          ["x"] = { "n" },
          ["X"] = { "n" },
          ["y"] = { "n" },
          ["Y"] = { "n" },
          ["p"] = { "n" },
          ["P"] = { "n" },
        },
        restriction_mode = "block", -- block or hint
        restricted_keys = {
          ["h"] = { "n", "x" },
          ["j"] = { "n", "x" },
          ["k"] = { "n", "x" },
          ["l"] = { "n", "x" },
          ["-"] = { "n", "x" },
          ["+"] = { "n", "x" },
          ["gj"] = { "n", "x" },
          ["gk"] = { "n", "x" },
          ["<CR>"] = { "n", "x" },
          ["<C-M>"] = { "n", "x" },
          ["<C-N>"] = { "n", "x" },
          ["<C-P>"] = { "n", "x" },
          ["<Up>"] = { "n", "x" },
          ["<Down>"] = { "n", "x" },
          ["<Left>"] = { "n", "x" },
          ["<Right>"] = { "n", "x" },
        },
        disabled_keys = {
          ["<Up>"] = {},
          ["<Down>"] = {},
          ["<Left>"] = {},
          ["<Right>"] = {},
        },
        disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "neo-tree", 'help' },
      }
    require("hardtime").setup(opts)
    end,
  },
}
