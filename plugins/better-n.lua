return {
  {
    "jonatan-branting/nvim-better-n",
    lazy = true,
    enabled = false,
    event = "BufEnter",
    config = function()
      require("better-n").setup {
        callbacks = {
          mapping_executed = function(_mode, _key)
            -- Clear highlighting, indicating that `n` will not goto the next
            -- highlighted search-term
            vim.cmd [[ nohl ]]
          end,
        },
        mappings = {
          -- I want `n` to always go forward, and `<s-n>` to always go backwards
          -- ["#"] = { previous = "n", next = "<s-n>" },
          --
          -- -- Setting `cmdline = true` ensures that `n` will only be
          -- -- overwritten if the search command is succesfully executed
          -- ["*"] = {previous = "<s-n>", next = "n"},
          --
          -- ["#"] = {previous = "<s-n>", next = "n"},
          -- ["f"] = {previous = ",", next = ";"},
          -- ["t"] = {previous = ",", next = ";"},
          -- ["F"] = {previous = ",", next = ";"},
          -- ["T"] = {previous = ",", next = ";"},
          ["f"] = {cmdline = true},
          ["t"] = {cmdline = true},
          ["F"] = {cmdline = true},
          ["T"] = {cmdline = true},
          --
          ["/"] = {previous = "<s-n>", next = "n", cmdline = true},
          ["?"] = {previous = "<s-n>", next = "n", cmdline = true},
          -- ["/"] = {cmdline = true},
          -- ["?"] = {cmdline = true},

          -- spell
          ["]s"] = {previous = "[s", next = "]s"},
          ["[s"] = {previous = "[s", next = "]s"},
          -- diagnostic
          ["]d"] = {previous = "[d", next = "]d"},
          ["[d"] = {previous = "[d", next = "]d"},
          -- function
          ["]f"] = {previous = "[f", next = "]f"},
          ["[f"] = {previous = "[f", next = "]f"},
          -- git hunk
          ["]g"] = {previous = "[g", next = "]g"},
          ["[g"] = {previous = "[g", next = "]g"},
          -- next fold
          -- ["z<Up>"] = {previous = "zk", next = "zj"},
          -- ["z<Down>"] = {previous = "zk", next = "zj"},
        },
      }

      -- You will have to rebind `n` yourself
      vim.keymap.set("n", "n", require("better-n").n, { nowait = true })
      vim.keymap.set("n", "<s-n>", require("better-n").shift_n, { nowait = true })
    end,
  },
}
