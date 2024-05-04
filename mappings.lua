-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<Home>"] = { "^", desc = 'Jump to first non-blank char' },
    ["<End>"] = { "g_", desc = 'Jump to last non-blank char' },
    -- C-PageUp / C-PageDown -- remapped to fold jumps
    -- ["<C-PageUp>"] = { "<C-u>zz", desc = "PageUp center" },
    -- ["<C-PageDown>"] = { "<C-d>zz", desc = "PageDown center" },
    ["<PageUp>"] = { "10k", desc = "Jump 5 up" },
    ["<PageDown>"] = { "10j", desc = "Jump 5 down" },
    -- ["<PageUp>"] = { "<C-u>zz", desc = "PageUp center" },
    -- ["<PageDown>"] = { "<C-d>zz", desc = "PageDown center" },
    --["n"] = {"nzz", desc = 'Next search + center'},
    --["N"] = {"Nzz", desc = 'Next search + center'},
    ["<leader>gl"] = { "<cmd>Git blame<cr>", desc = "Git linewise blame" },
    ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
    ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
    ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
    ["<leader>bo"] = { '<cmd>%bd|e#|bd#<cr><cr>', desc = "Close other tabs" },
    -- ["<leader>bu"] = { '<cmd>MundoToggle<cr>', desc = "Buffer undo tree" },
    ["<leader>bu"] = { '<cmd>Telescope undo<cr>', desc = "Buffer undo tree" },
    -- ["<leader>lc"] = { '<cmd>call Autoflake()<cr>', desc = "Clean PyImports" },
    ["<leader>lp"] = { '<cmd>Docstring<cr>', desc = 'PyDocString Gen' },
    ["<leader>fs"] = { '<cmd>Telescope luasnip<cr>', desc = 'Find all snippets' },
    -- ["<leader>sm"] = { function() require("telescope.builtin").man_pages({ sections = { "ALL" } }) end, desc = "Search man" },
    -- Disable Force close buffer! No save, no undo history!
    ["<leader>C"] = false,

    -- quick save
    ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
    -- ["<C-Right>"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
    -- ["<C-Left>"] = { "<cmd>bprev<cr>", desc = "Prev buffer" },
    ["<C-Right>"] = { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
    ["<C-Left>"] = { function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer" },

    -- Shift + Arrow selection (+ seamless TMUX panes!)
    -- ["<S-Up>"] = { "<C-W>k", desc = 'Split move up' },
    -- ["<S-Down>"] = { "<C-W>j", desc = 'Split move down' },
    -- ["<S-Left>"] = { "<C-W>h", desc = 'Split move left' },
    -- ["<S-Right>"] = { "<C-W>l", desc = 'Split move right' },
    ["<S-Up>"] = { ":<C-U>TmuxNavigateUp<cr>", desc = 'Split move up' },
    ["<S-Down>"] = { ":<C-U>TmuxNavigateDown<cr>", desc = 'Split move down' },
    ["<S-Left>"] = { ":<C-U>TmuxNavigateLeft<cr>", desc = 'Split move left' },
    ["<S-Right>"] = { ":<C-U>TmuxNavigateRight<cr>", desc = 'Split move right' },
    -- Reserved for TMUX window navigation
    ["<S-Home>"] = { '<Nop>' },
    ["<S-End>"] = { '<Nop>' },

    -- Make mouse scroll slower because I have already 3x speed!
    ["<ScrollWheelUp>"] = { '<C-Y>' },
    ["<ScrollWheelDown>"] = { '<C-E>' },

    -- Move lines of code
    ["<C-Up>"] = { "<cmd>m .-2<CR>==", desc = "Move line Up" },
    ["<C-Down>"] = { "<cmd>m .+1<CR>==", desc = "Move line Down" },

    -- My pycharm mimics
    -- ["<C-q>"] = false,
    ["<C-q>"] = { function () require('lsp_signature').toggle_float_win() end, desc = 'Select right' },
    ["<C-d>"] = {
      function()
        local aerial_avail, _ = pcall(require, "aerial")
        if aerial_avail then
          require("telescope").extensions.aerial.aerial()
        else
          require("telescope.builtin").lsp_document_symbols()
        end
      end,
      desc = "Search symbols",
    },
    -- Comment with Ctrl+/
    ["<C-_>"] = { function() require("Comment.api").toggle.linewise.current() end,
      desc = "Comment line" },

    -- Code navigation
    -- IMPORTANT: Ctrl-i is a terminal TAB, no way to remap properly
    --           use ctrl-u to goto between jumps, ctrl+o remains the same
    ["<C-Home>"] = { "<tab>", desc = 'Jump previous' },
    ["<C-End>"] = { "<C-o>", desc = 'Jump next' },
    --["<C-u>"] = { "<tab>", desc = 'Jump previous' },

    --Code idents single line
    ["<Tab>"] = { ">>", desc = "Indent left" },
    ["<S-Tab>"] = { "<<", desc = "Indent right" }, -- Shift + Arrow selection
    ['<leader>jr'] = { ":.,$s/<C-R><C-W>/<C-R><C-W>/gc<Left><Left><Left>", desc = 'Replace current word' },
    ['<leader>jf'] = { ':lua require("user.text_objects").f_string_prepend()<CR>', desc = 'Adds f- prefix into string beginning' },
    ['<leader>jz'] = { "zfif", desc = 'Fold current fuction' },
    ['<leader>jp'] = { "`[v`]", desc = 'Select pasted text' },
    ['<leader>jd'] = { ":lua require('neogen').generate()<CR>", desc = 'Generates docstrind' },

    -- TODO Search
    ['<leader>ft'] = { ":TodoTelescope keywords=TODO,FIX,BUG,FIXME<CR>", desc = 'Find TODOs' },
    ['<C-j>'] = { '<Nop>' },
    ['<C-l>'] = { '<Nop>' },
    ['J'] = { '<Nop>' },
    ['K'] = { '<Nop>' },
    ['L'] = { '<Nop>' },
    ['H'] = { '<Nop>' },
    ['<C-u>'] = { '<Nop>' },
    ['<C-o>'] = { '<Nop>' },
    ['<C-h>'] = { '<Nop>' },
    ['<C-y>'] = { '<Nop>' },
    ['G'] = { 'Gzz' },
    ['za'] = { 'zazz' },
    ['zc'] = { 'zczz' },
    ['zm'] = { 'zmzz' },

    -- FOLDING shortcut
    ['zz'] = { 'zazz' },
    ['z`'] = { '<cmd>set foldlevel=0<CR>' },
    ['z1'] = { '<cmd>set foldlevel=1<CR>' },
    ['z2'] = { '<cmd>set foldlevel=2<CR>' },
    ['z3'] = { '<cmd>set foldlevel=3<CR>' },
    ["<C-PageUp>"] = { "zk", desc = "Prev fold up" },
    ["<C-PageDown>"] = { "zj", desc = "Next fold down" },
    -- ["z<Up>"] = { "zk", desc = 'Prev fold up' },
    -- ["z<Down>"] = { "zj", desc = 'Next fold down' },
    --['U'] = {'<Nop>'},
    --['O'] = {'<Nop>'},
    ["&"] = {
      "<esc><cmd>lua argument_next()<cr>",  -- see my text_objects.lua
      desc = "Goto next argument",
    },
    -- Debugger
    --
  -- ["<F6>"] = { function() require("dap").pause() end, desc = "Debugger: Pause" }
  ["<F6>"] = { function() require("dap").step_over() end, desc = "Debugger: Step Over" },
  ["<F7>"] = { function() require("dap").step_into() end, desc = "Debugger: Step Into" },
  ["<leader>du"] = { function() require("dap").up() end, desc = "Debugger: Stack Up" },
  ["<leader>dd"] = { function() require("dap").down() end, desc = "Debugger: Stack Down" },
  ["<leader>dD"] = { function() require("dapui").toggle() end, desc = "Toggle Debugger UI" }

  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  i = {
    -- Shift+Arrows selection
    ["<S-Up>"] = { "<Esc>V<Up>", desc = 'Select up' },
    ["<S-Down>"] = { "<Esc>V<Down>", desc = 'Select down' },
    -- ["<S-Left>"] = { "<Esc>v<Left>", desc = 'Select left' },
    -- ["<S-Right>"] = { "<Esc>v<Right>", desc = 'Select right' },
    ["<Home>"] = { "<Esc>^i", desc = 'Jump first valid text' },
    ["<End>"] = { "<Esc>g_a", desc = 'Jump last valid text' },
    --["<C-q>"] = { vim.lsp.buf.signature_help, desc = 'Select right' },
    -- ["<S-Home>"] = { "<Esc>v^", desc = 'Select to a beginning' },
    -- ["<S-End>"] = { "<Esc>v$", desc = 'Select to an end' },
    ["<C-s>"] = { "<Esc>:w!<cr>", desc = "Save File" }, -- change description but the same command

    ['<C-j>'] = { '<Nop>' },
    ['<C-l>'] = { '<Nop>' },

  },
  v = {
    -- Visual mode
    ["<Tab>"] = { ">gv", desc = "Indent left" },
    ["<S-Tab>"] = { "<gv", desc = "Indent right" }, -- Shift + Arrow selection
    --["<S-Up>"] = { "5k", desc = 'Select up' },
    --["<S-Down>"] = { "5j", desc = 'Select down' },
    ["<S-Up>"] = { "<Up>", desc = 'Select up' },
    ["<S-Down>"] = { "<Down>", desc = 'Select down' },
    ["<S-Left>"] = { "<Left>", desc = 'Select left' },
    ["<S-Right>"] = { "<Right>", desc = 'Select right' },
    -- Replace PgUp/Dn
    ["<C-PageUp>"] = { "<C-u>", desc = "PageUp center" },
    ["<C-PageDown>"] = { "<C-d>", desc = "PageDown center" },
    ["<PageUp>"] = { "10k", desc = "Jump 5 up" },
    ["<PageDown>"] = { "10j", desc = "Jump 5 down" },
    -- Move lines
    ["<C-Up>"] = { ":m '<-2<CR><CR>gv=gv", desc = "Move Block Up" },
    ["<C-Down>"] = { ":m '>+1<CR><CR>gv=gv", desc = "Move Block Down" },

    ['<leader>zr'] = { "y:.,$s/<C-R>\"/<C-R>\"/gc<Left><Left><Left>", desc = 'Replace current word' },
    ['<leader>zf'] = { "y/<C-R>\"<CR>", desc = 'Find selected text' },

    -- Comment with Ctrl+/
    ["<C-_>"] = {
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      desc = "Toggle comment line",
    },
    ['<C-j>'] = { '<Nop>' },
    ['<C-l>'] = { '<Nop>' },
    ['J'] = { '<Nop>' },
    ['L'] = { '<Nop>' },
  }
}
