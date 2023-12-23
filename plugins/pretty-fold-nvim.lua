return {
  {
    -- "anuvyklack/pretty-fold.nvim",
    "alexveden/pretty-fold.nvim",
    -- dir="/home/ubertrader/cloud/code/pretty-fold.nvim",
    lazy = true,
    enabled = true,
    event = "BufEnter",
    config = function(_, _)
      -- Saving folds!
      local save_fold_group = vim.api.nvim_create_augroup("save_fold_group", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
        pattern = "*.*",
        group = save_fold_group,
        command = "mkview",
      })
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "*.*",
        group = save_fold_group,
        command = "silent! loadview",
      })

      --
      -- Customize language folds
      --
      --
      vim.treesitter.query.set(
        "c",
        "folds",
        [[
          [
           (switch_statement)
           (case_statement)
           (comment)
          ] @fold
          (function_definition
            type: (type_identifier)  @fold
          )
          (function_definition
            body: (compound_statement)  @fold
          )
          ]]
      )

      vim.treesitter.query.set(
        "cpp",
        "folds",
        [[
          [
           (switch_statement)
           (case_statement)
           (comment)
           (function_definition)
          ] @fold
          ]]
      )

      require("pretty-fold").setup {
        ft_ignore = { "python" },
        keep_indentation = true,
        fill_char = " ",
        -- List of patterns that will be removed from content foldtext section.
        -- process_comment_signs = "delete",
        process_comment_signs = false,
        add_close_pattern = true, -- true, 'last_line' or false
        --add_close_pattern = 'last_line',
        comment_signs = {
          "/**", -- C++ Doxygen comments
        },
        stop_words = {
          -- ╟─ "*" ──╭───────╮── "@brief" ──╭───────╮──╢
          --          ╰─ WSP ─╯              ╰─ WSP ─╯
          -- "%*%s*@brief%s*",
          "@brief%s*",
        },
        sections = {
          left = {
            "",
            "content",
          },
          right = {
            "━━━━━━━━━━━━┫ ",
            "number_of_folded_lines",
            ": ",
            "percentage",
            " ┣━━",
          },
        },
      }
    end,
  },
}
