return {
  {
    'christoomey/vim-tmux-navigator', -- Seamless TMUX splits navigation
    -- overrides `require("mason-lspconfig").setup(...)`
    lazy = false,
    -- opts = function(_, opts)
    --   -- add more things to the ensure_installed table protecting against community packs modifying it
    --   -- opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
    --   --   -- "lua_ls",
    --   -- })
    -- end,
  },
}
