---@module  Snippet common utils


--- Returns hint overlay text for a snippet node
local hint = function(text)
	return {
        node_ext_opts = { active = { virt_text = { { text, "@annotation" } } } },
      }
end

local buffnmatch = function(pattern)
    -- fn - currently open file name without extension
    local fn = vim.fn.expand("%:t")

    return string.gmatch(fn, pattern)
end

return {
    hint = hint,
    buffnmatch = buffnmatch,
}
