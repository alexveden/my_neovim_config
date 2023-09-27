--[
-- Use the w, e, b motions like a spider. Move by subwords and skip insignificant punctuation.
--Lua implementation of CamelCaseMotion, with extra consideration of punctuation.
--Works in normal, visual, and operator-pending mode. Supports counts and dot-repeat.
--
--]
return {
  {
    "chrisgrieser/nvim-spider",
    lazy = false,
    enabled = true,
    config = function()
      require("spider").setup {
        skipInsignificantPunctuation = true,
      }
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    end,
  },
}
