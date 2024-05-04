return {
  "L3MON4D3/cmp-luasnip-choice",
  lazy = true,
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  event = "BufEnter",

  config = function()
    require("cmp_luasnip_choice").setup {
      auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
    }
  end,
}
