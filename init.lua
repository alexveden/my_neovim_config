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
      "cyright",
    },
    config = {
      cyright = {
        cmd = {
          "node",
          "/home/ubertrader/cloud/code/vs-code-cython/cyright/packages/pyright/langserver.index.js",
          "--stdio",
        },
        -- cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { "pyrex" },
        root_dir = function(fname)
          -- print("cyright: " .. fname)
          local _root = require("lspconfig").util.find_git_ancestor(fname)
          vim.lsp.set_log_level "trace"
          -- print("root: " .. _root)
          return _root
        end,
        -- root_dir = function(fname) assert(false) end,
        settings = {},
      },
      ltex = {
        -- ltex-ls LSP server for Markdown and latex for spelling
        -- settings params: https://valentjn.github.io/ltex/settings.html
        enabled = true,
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

    -- require('langmapper').automapping({ global = true, buffer = true })
  end,
}
