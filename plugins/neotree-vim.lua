return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, config)
        config["close_if_last_window"] = true;
        config["filesystem"]["follow_current_file"]["enabled"] = false;
        return config;
  end,
}
