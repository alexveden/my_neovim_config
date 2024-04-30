return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "astrodark",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 5000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
      "lua_ls",
    },
    config = {
      ltex = {
        -- ltex-ls LSP server for Markdown and latex for spelling
        -- settings params: https://valentjn.github.io/ltex/settings.html
        enabled = true,
        language = "ru-RU",
      },
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              -- runtime = {
              --   "/usr/local/share/lua/5.3/?.lua",
              -- },
              library = {
                "/usr/local/share/lua/5.3",
              },
            },
          },
        },
      },
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Preventing insert mode cursor changing colors depending on code colorins
    vim.api.nvim_exec("hi iCursor guifg=#282c34 guibg=white", true)

    -- Folded text highlighting
    vim.api.nvim_exec("hi Folded guifg=#ffffff", true)

    -- Installing basic text objectss + key bindings!
    require("user.text_objects").map_text_objects()

    local function escape(str)
      -- You need to escape these characters to work correctly
      local escape_chars = [[;,."|\]]
      return vim.fn.escape(str, escape_chars)
    end

    -- Recommended to use lua template string
    local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
    local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
    local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
    local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

    vim.opt.langmap = vim.fn.join({
      -- | `to` should be first     | `from` should be second
      escape(ru_shift)
        .. ";"
        .. escape(en_shift),
      escape(ru) .. ";" .. escape(en),
    }, ",")

    --
    -- Special settings for code-related stuff
    --
    vim.api.nvim_create_augroup("Code", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.bo.filetype == "markdown" then return end
        -- Motions as by pythonCamelCase_some_snake_case
        vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
        vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
        vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
        vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })

        -- Special zem mode with twilight off
        vim.keymap.set(
          "n",
          "<leader>jj",
          function() require("zen-mode").toggle { plugins = { twilight = { enabled = false } } } end,
          { desc = "ZenMode twilight" }
        )
        -- markdown preview
        -- vim.keymap.del({ "n", "o", "x" }, "<leader>jm", {silent = true})
      end,
      group = "Code",
    })

    --
    -- Special settings for Markdown
    --
    vim.api.nvim_create_augroup("Markdown", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.bo.filetype ~= "markdown" then return end

        -- Reset default w-e-b keys behavior
        vim.keymap.del({ "n", "o", "x" }, "w")
        vim.keymap.del({ "n", "o", "x" }, "e")
        vim.keymap.del({ "n", "o", "x" }, "b")
        vim.keymap.del({ "n", "o", "x" }, "ge")

        -- Soft wrap in zen mode
        vim.g["pencil#wrapModeDefault"] = "soft"
        -- vim.g["pencil#conceallevel "] = 1
        vim.cmd "let g:pencil#conceallevel = 0"
        vim.cmd "SoftPencil" -- enable soft wrapping handling

        vim.keymap.set(
          "n",
          "<leader>jj",
          function() require("zen-mode").toggle { plugins = { twilight = { enabled = true } } } end,
          { desc = "ZenMode twilight" }
        )
        vim.keymap.set("n", "<leader>jm", function()
          vim.cmd "MarkdownPreview"
        end, { desc = "Markdown Preview" })
      end,
      group = "Markdown",
    })
  end,
}
