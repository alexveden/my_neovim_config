--[
-- Use the w, e, b motions like a spider. Move by subwords and skip insignificant punctuation.
--Lua implementation of CamelCaseMotion, with extra consideration of punctuation.
--Works in normal, visual, and operator-pending mode. Supports counts and dot-repeat.
--
--]
return {
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    enabled = true,
    event = "BufEnter",
    config = function()
      require("spider").setup {
        skipInsignificantPunctuation = true,
      }

      -- NOTE: key bindings moved to init.lua autocmd
    end,
  },
}
