-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true,         -- sets vim.opt.number
    spell = true,         -- sets vim.opt.spell
    spelllang = "en,ru",  -- vim.opt.spelllang
    spelloptions = "camel,noplainbuffer",  -- vim.opt.spelllang
    signcolumn = "auto",   -- sets vim.opt.signcolumn to auto
    wrap = false,          -- sets vim.opt.wrap
    tabstop = 4,           -- Tab ident width
    shiftwidth = 4,        -- Ident width when >>
    expandtab = true,      -- Convert tab to spaces
    smarttab = true,
    guicursor = "i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150",
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    foldlevelstart = 99,
    colorcolumn = "89",
  },
  g = {
    mapleader = " ",                 -- sets vim.g.mapleader
    autoformat_enabled = false,      -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true,              -- enable completion at start
    autopairs_enabled = true,        -- enable autopairs at start
    diagnostics_mode = 3,            -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true,            -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    max_file = { size = 1024 * 300, lines = 10000 }, -- set global limits for large files (prevents TreeSitter highlighting!)
  },
}
-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end
