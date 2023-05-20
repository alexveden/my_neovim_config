return {
{
  "folke/which-key.nvim",
  config = function(plugin, opts)
    require "plugins.configs.which-key"(plugin, opts) -- include the default astronvim config that calls the setup call
    -- Add bindings which show up as group name
    local wk = require "which-key"
    wk.register({
      z = { name = "Toolz" },
    }, { mode = "n", prefix = "<leader>" })
    wk.register({
      z = { name = "Toolz" },
    }, { mode = "v", prefix = "<leader>" })
  end,
},
}
