return {
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
  },
  config = function()
    local telescope_actions = require('telescope.actions')

    require("telescope").setup({
        defaults = {
            dynamic_preview_title = true,
            --path_display = { shorten = { len = 2 } }
            path_display = { "smart" },
            mappings = {
                i = {
                    ["<PageUp"] = false,
                    ["<PageDown"] = false,
                    ["<C-Up>"] = telescope_actions.cycle_history_prev,
                    ["<C-Down>"] = telescope_actions.cycle_history_next,

                    ["<C-PageUp>"] = telescope_actions.preview_scrolling_up,
                    ["<C-PageDown>"] = telescope_actions.preview_scrolling_down,
                },
            },
        },
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
      },
    })
    require("telescope").load_extension("undo")
    -- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
  end,
},
}
