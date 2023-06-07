function empty_i()
    --
    -- Text object maps all white spaces after line until next line
    --  (preserves identation of the last line)
    --
    local blank_line_pattern = '^%s*$'
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')
    local direction = 0
    if string.match(vim.fn.getline(line):sub(1, col), blank_line_pattern) then
        -- When the cursor placed at identation of the new line, go upwards
        direction = -1
    elseif string.match(vim.fn.getline(line):sub(col), blank_line_pattern) then
        -- Go downwards
        direction = 0
    else
        -- Cusor must be places at the end or the begining of the blank string
        return
    end

    -- Finding previous non-blank line and move cursor there
    local prev_non_blank = vim.fn.prevnonblank(line + direction)
    local next_non_blank = vim.fn.nextnonblank(line + 1 + direction)
    if next_non_blank == 0 or prev_non_blank == next_non_blank then
        -- Next line is EOF
        return
    end

    vim.fn.cursor(prev_non_blank, 1)

    -- Go down from prev non plan line
    vim.cmd('normal! j')
    -- Start by row selection
    vim.cmd('normal! V')
    -- Go down to next non blank line (1 col)
    vim.fn.cursor(next_non_blank-1, 1)
end



function empty_a()
    --
    -- Text object maps all white spaces after line until next line
    --   merges deleted spaces w text, example 
    --   Given
    --   foo(arg1, arg2,|  <- dai here
    --     arg3) => foo(arg1, arg2, arg3)
    --
    --  (useful for deleting redundant whitespaces in Python)
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')
    local direction = 0
    local extra_space = ""

    local line_text = vim.fn.getline(line)
    
    if #line_text == 1 and string.match(line_text, "^[^%s]$") then
        -- Line of only one char, impossible to decide direction
        return
    end

    if string.match(line_text:sub(1, col), "^%s*$") or string.match(line_text:sub(1, col), "^%s*[^%s]?$") then
        -- When the cursor placed at identation of the new line, go upwards
        direction = -1
    elseif  string.match(line_text:sub(col), "^[^%s]?%s*$") then
        -- Go downwards
        direction = 0
    else
        -- Cusor must be places at the end or the begining of the blank string
        return
    end

    -- Finding previous non-blank line and move cursor there
    local prev_non_blank = vim.fn.prevnonblank(line + direction)
    local next_non_blank = vim.fn.nextnonblank(line + 1 + direction)
    if next_non_blank == 0 then
        -- Next line is EOF
        return
    end

    vim.fn.cursor(prev_non_blank, 1)

    -- Goto last non white char, move right
    vim.cmd('normal! g_l')
    -- Place extra space after the line end
    if string.match(vim.fn.getline(vim.fn.line('.')), "^.*[^%s]$") then
        -- When last char is non space we need 2 spaces 
        vim.cmd('normal! a  ')
    else
        vim.cmd('normal! a ')
    end
    -- Start selection
    vim.cmd('normal! v')
    -- Go down to next non blank line (1 col)
    vim.fn.cursor(next_non_blank, 1)
    -- First non whitespace char, and exclude it from selection
    vim.cmd('normal! ^h')

     if string.match(vim.fn.getline(vim.fn.line('.')), "^[^%s]+") then
        -- Line is not indented, exclude selection
        vim.cmd('normal! k$')
        return
    end


end

function namepart(around)
    --
    -- Text object for capturing partial variables
    -- snake_case_python_*variables*
    -- Class*Name*OrSomething
    -- MY_*CONSTANT*
    --
    local col = vim.fn.col('.')
    local line = vim.fn.line('.')
    local line_text = vim.fn.getline(line)
    local col_start = col

    -- By default: if we at upper case letter seek for lower case
    local end_pat = "%l+"
    local c = line_text:sub(col, col)
    if c:match("%l+") or c:match("%d+")  then
        -- if lower case letter seek for a first upper case
        end_pat ="%u+"
    end

    while col > 0 do
        c = line_text:sub(col, col)
        if not c:match("%w+") then
            -- Break at first non alphanumeric
            break
        end
        if  c:match(end_pat) then
            if end_pat == "%u+" then
                col = col - 1
            end
            break
        end
        col = col - 1
    end

    col = col + 1
    vim.fn.cursor(line, col)
    vim.cmd('normal! v')
    vim.cmd('normal! l')
    col = col + 1
    col_start = col
    local last_col = vim.fn.col('$')

    while col < last_col-1 do
        -- print(line_text:sub(col, col))
        c = line_text:sub(col, col)
        if (c:match(end_pat) and col-col_start == 0) then
            -- Border case when cursor at the start of the Upper*Case part, and the next letter is lower
            end_pat = "%u+"
        elseif not c:match("%w+") or c:match(end_pat)  then
            if not around or c ~= '_' then
                vim.cmd('normal! h')
            end
            break
        end
        -- Increase selection
        vim.cmd('normal! l')
        col = col + 1
    end
end

local brackets = {
    ['('] = ')',
    ['{'] = '}',
    ['['] = ']',
    ['"'] = '"',
    ["'"] = "'",
}
function match_brackets(current_brackets, ch, match_last)
    local is_match_last = match_last or false
    if brackets[ch] ~= nil then
        -- Opening bracket
        if #current_brackets > 0 and current_brackets[#current_brackets] == brackets[ch] then
            -- closing char pop
            table.remove(current_brackets)
            --current_brackets.pop()
        else
            if #current_brackets == 0 or (current_brackets[#current_brackets] ~= '"' and current_brackets[#current_brackets] ~= "'") then
                -- Opening bracket or char, but ignore everythin in quotes!
                -- current_brackets.append(ch)
                table.insert(current_brackets, ch)
            end
        end
    else
        if #current_brackets > 0 and ch == brackets[current_brackets[#current_brackets]] then
            table.remove(current_brackets)
            -- current_brackets.pop()
            -- Include last bracket to the result
            if not is_match_last then
                return false
            end
        end
    end
    return #current_brackets == 0
end

function argument_sub_a(line_text, col)
    local ch = ''
    local last_col = #line_text
    local start_col = col
    local args_col = -1

    local start_chars = {
        [','] = true, 
        ['('] = true, 
        ['['] = true, 
        ['{'] = true}

    while col > 0 do --: # Lua todo: change to > 0
        -- Finding closest function call
        ch = line_text:sub(col, col)
        if args_col == -1 and start_chars[ch] then
            args_col = col
        end
        col = col - 1
    end
    if args_col == -1 then
        -- No previous function call found, try to forward looking
        col = start_col
        while col <= last_col do
            -- Finding closest function call
            ch = line_text:sub(col, col)
            if ch == '(' then
                args_col = col
                break
            end
            col = col + 1
        end
    end
    if args_col == -1 then
        -- Nothing found
        return 0, 0
    end

    col = args_col + 1
    while col < last_col do
        ch = line_text:sub(col, col)
        if ch ~= ' ' then
            break
        end
        col = col + 1
    end

    local current_brackets = {} --   # Lua table, stack
    local start_col = col


    while col <= last_col do
        ch = line_text:sub(col, col)
        if match_brackets(current_brackets, ch) then
            if ch == ',' or ch == ')' then
                if ch == ',' then
                    col = col + 1
                end
                break
            end
        end

        col = col + 1
    end

    if #current_brackets == 0 then
        -- All good argument found
        return start_col, col-1
    else
        -- Error or invalid sequence
        return 0, 0
    end
end


function namepart_a()
    --
    -- Selects a partial name of a statement
    --   foo.!b*ar!   <- van 
    --   foo.!b*ar['some test']!   <- van 
    --   foo.!b*ar['some test']!.another_call(a, b)   <- van 
    --   foo.bar['some test'].!an*other_call(a, b)!   <- van
    --   foo.*!zoo!.mock
    --   var =* !test!.foo
    --       foo.array[!*0!]
    --       foo.!arr*ay[0]!
    local col = vim.fn.col('.')
    local line = vim.fn.line('.')
    local line_text = vim.fn.getline(line)
    local last_col = vim.fn.col('$')

    local start_chars = {
        [','] = true,
        ['('] = true,
        [' '] = true,
        ['='] = true,
        ['.'] = true,
        ['['] = true,
        [':'] = true,
        ['{'] = true}
    local end_chars = {
        [','] = true,
        [')'] = true,
        [' '] = true,
        ['='] = true,
        ['\n'] = true,
        ['\t'] = true,
        ['\r'] = true,
        ['.'] = true,
        [']'] = true,
        [':'] = true,
        ['}'] = true}
    local ch = ''
    -- Find start of the statement
    local current_brackets = {} --   # Lua table, stack
    local open_bracket = ''
    local current_col = col
    while col > 0 do
        ch =line_text:sub(col, col)
        if col == current_col then
            if ch == "]" or ch == '[' then
                open_bracket = "["
            elseif ch == ")" or ch == '(' then
                open_bracket = "("
            elseif ch == "}" or ch == '{' then
                open_bracket = "{"
            end
        end

        if open_bracket ~= '' then
            if ch == open_bracket then
                break
            end
        else
            if start_chars[ch] then
                --open_bracket = ch
                break
            end
        end
        col = col - 1
    end
    
    local start_adj = 0
    if open_bracket ~= '' then
        if not match_brackets(current_brackets, open_bracket, true) then
            -- Bracket is other unmached symbol, just skip
            start_adj = -1
        end
        col = col + 1
    else
        col = col + 1
    end

    -- -- skip spaces
    if #current_brackets == 0 then
        --col = col + 1
        while col <= last_col do
            ch = line_text:sub(col, col)
            if ch ~= ' ' then
                break
            end
            col = col + 1
        end
    end

    --local current_brackets = {} --   # Lua table, stack
    local col_start = col + start_adj

    while col < last_col do
        ch = line_text:sub(col, col)
        if match_brackets(current_brackets, ch, false) then
            if end_chars[ch] then
                break
            end
        end

        col = col + 1
    end
    -- print(line_text:sub( col_start, col ))
    -- print(#current_brackets)

    if #current_brackets > 0 then
        -- Inconsistent / multiline object
        return
    end

    vim.fn.cursor(line, col_start)
    vim.cmd('normal! v')
    while col_start < col-1 do
        -- Increase selection
        vim.cmd('normal! l')
        col_start = col_start + 1
    end
end

function argument_sub_i(line_text, col)
    local c_start, c_end = argument_sub_a(line_text, col)
    if c_end == 0 then
        -- Error
        return 0, 0
    end
    -- Strip spaces and comma from the end
    col = c_end
    local ch = ''
    while col > c_start do
        ch = line_text:sub(col, col)
        if ch ~= ' ' and ch ~= ',' then
            break
        end
        col = col - 1
    end
    c_end = col

    local clean_text = line_text:sub(c_start, col)
    local sep = ''
    --
    -- if clean_text:match("^'.*'%s*:%s*.*") then
    --     sep = ':'
    -- elseif clean_text:match('^".*"%s*:%s*.*') then
    --     sep = ':'
    -- elseif clean_text:match('^[%w_]+%s*=%s*.*') then
    --     sep = '='
    -- end

    if sep ~= "" then
        local i, _ = clean_text:find(sep)
        i = i + 1
        -- Clean separator spaces between kwargs
        while i < #clean_text do
            ch = clean_text:sub(i,i)
            if ch ~= ' ' then
                break
            end
            i = i + 1
        end
        return c_start+i-1, c_end 
    else
        return c_start, c_end
    end
end

function argument_i()
    local col = vim.fn.col('.')
    local line = vim.fn.line('.')
    local line_text = vim.fn.getline(line)


    local c_start, c_end = argument_sub_i(line_text, col)
    if c_end == 0 then
        -- Error
        return
    end

    vim.fn.cursor(line, c_start)
    vim.cmd('normal! v')

    while c_start < c_end do
        vim.cmd('normal! l') -- Increase selection
        c_start = c_start + 1
    end
end

function argument_a()
    local col = vim.fn.col('.')
    local line = vim.fn.line('.')
    local line_text = vim.fn.getline(line)


    local c_start, c_end = argument_sub_a(line_text, col)
    if c_end == 0 then
        -- Error
        return
    end


    vim.fn.cursor(line, c_start)
    vim.cmd('normal! v')

    while c_start < c_end do
        vim.cmd('normal! l') -- Increase selection
        c_start = c_start + 1
    end
end

function argument_next()
    local col = vim.fn.col('.')
    local line = vim.fn.line('.')
    local line_text = vim.fn.getline(line)


    local c_start, c_end = argument_sub_a(line_text, col)
    if c_end == 0 then
        -- Error
        return
    end

    if col >= c_start then
        c_start, c_end = argument_sub_a(line_text, c_end)
        if c_end == 0 then
            -- Error
            return
        end
    end
    if col == c_start then
        -- Already at the final position try to cycle
        c_start, c_end = argument_sub_a(line_text, 1)
        if c_end == 0 then
            -- Error (possibly no functions)
            return
        end
    end

    --
    vim.fn.cursor(line, c_start)
end

function code_key(around)
    --
    -- Gets full line key, works with dictionaries(new line), and variables (new line)
    --
    --

    local col = 1 --vim.fn.col('_')
    local col_last = vim.fn.col('$')
    local line = vim.fn.line('.')
    local line_text = vim.fn.getline(line)
    local sep = ''
    local divisor = ''

    if line_text:match("^%s*{?%s*'.*'%s*:%s*.*") then
        divisor = "'"
        sep = ':'
    elseif line_text:match('^%s*{?%s*".*"%s*:%s*.*') then
        sep = ':'
        divisor = '"'
    elseif line_text:match('^%s*[%w_.]+%s*=%s*.*') then
        sep = '='
        divisor = ' '
    else
        local col_current = vim.fn.col('.')

        local c_start, c_end = argument_sub_a(line_text, col_current)
        if c_end == 0 or line_text:sub(c_start, c_end):find('=') == nil then
            -- Error
            return
        end
        sep = '='
        divisor = ' '
        col = c_start
    end

    local ch = ''
    -- Find start of the key argument
    while col < col_last do
        ch = line_text:sub(col, col)
        if ch ~= ' ' and ch ~= '{' and ch ~= divisor then
            if sep == ':' and around then
                col = col - 1
            end
            break
        end
        col = col + 1
    end

    vim.fn.cursor(line, col)
    vim.cmd('normal! v')
    while col < col_last do
        ch = line_text:sub(col, col)
        if ch == sep then
            break
        end
        vim.cmd('normal! l')
        col = col + 1
    end

    if not around then
        col = col - 1
        while col > 0 do
            ch = line_text:sub(col, col)
            if (sep == '=' and ch ~= ' ') or (sep == ':' and ch == divisor) then
                vim.cmd('normal! h') -- Shrink selection
                if sep == ':' then
                    vim.cmd('normal! h') -- Shrink selection
                end
                break
            end
            vim.cmd('normal! h') -- Shrink selection
            col = col - 1
        end
    end
end


function code_value(around)
    --
    -- Gets full line value, 
    -- works with dictionaries(new line), 
    -- variables (new line)
    -- functions kwargs (at argument position)
    --

    local col = 1 --vim.fn.col('_')
    local col_last = vim.fn.col('$')
    local line = vim.fn.line('.')
    local line_last = vim.fn.line('$')
    local line_text = vim.fn.getline(line)
    local sep = ''
    local is_argument = false

    if line_text:match("^%s*{?%s*'.*'%s*:%s*.*") then
        sep = ':'
    elseif line_text:match('^%s*{?%s*".*"%s*:%s*.*') then
        sep = ':'
    elseif line_text:match('^%s*[%w_.]+%s*=%s*.*') then
        sep = '='
    else
        local col_current = vim.fn.col('.')

        local c_start, c_end = argument_sub_a(line_text, col_current)
        if c_end == 0 then
            -- Error
            return
        end
        sep = '='
        col = c_start
        col_last = c_end
        if line_text:sub(c_end, c_end) == ',' then
            col_last = col_last - 1
        end
        line_last = line
        is_argument = true
    end

    local ch = ''
    local sep_found = false
    local char_found = false
    -- Find start of the key argument
    while col <= col_last do
        ch = line_text:sub(col, col)
        if sep_found and ch ~= ' ' then
            char_found = true
            break

        end
        col = col + 1
        if ch == sep then
            sep_found = true
        end
    end

    if not char_found then
        -- Empty value at all
        return
    end
    
    vim.fn.cursor(line, col)
    vim.cmd('normal! v')
    local current_brackets = {} --   # Lua table, stack
    local is_multiline = false
    local comment_col = 0

    while line <= line_last do
        line_text = vim.fn.getline(line)
        if not is_argument then
            col_last = #line_text
        end

        while col <= col_last do
            ch = line_text:sub(col, col)
            match_brackets(current_brackets, ch)
            if ch == '#' and comment_col == 0 then
                comment_col = col
            end

            if is_multiline and #current_brackets == 0 then
                -- print(ch)
                --vim.cmd('normal! h')
                -- print(vim.inspect(current_brackets))
                break
            end
            if comment_col == 0 then
                vim.cmd('normal! l')
            end
            col = col + 1
        end
        -- print(vim.inspect(current_brackets))

        if #current_brackets == 0 then
            break
        end
        is_multiline = true
        comment_col = 0
        col = 1
        line = line + 1
        vim.fn.cursor(line, col)
    end
    if not is_multiline then
        vim.cmd('normal! h')
    else
        if around then
            if (col < col_last) then
                ch = line_text:sub(col+1, col+1)
                if ch == ',' or ch == ' ' then
                    vim.cmd('normal! l')
                end
            end
        end
    end

    -- remove redundant spaces
    --
    if not around then
        if comment_col > 0 then
            col = comment_col
        end
        if not is_multiline then
           col = col - 1  
        end

        while col > 0 do
            ch = line_text:sub(col, col)
            if ch ~= ' ' and ch ~= ',' then
                break
            end
            vim.cmd('normal! h') -- Shrink selection
            col = col - 1
        end
    end
end

function map_text_objects()
    for _,mode in ipairs({ 'x', 'o' }) do
        vim.api.nvim_set_keymap(mode, "ae", ':<c-u>lua empty_a()<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap(mode, "ie", ':<c-u>lua empty_i()<cr>', { noremap = true, silent = true })
        -- -- Replacing snake_caseVariables
        vim.api.nvim_set_keymap(mode, "in", ':<c-u>lua namepart(false)<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap(mode, "an", ':<c-u>lua namepart_a()<cr>', { noremap = true, silent = true })
        -- Argument text object
        vim.api.nvim_set_keymap(mode, "aa", ':<c-u>lua argument_a()<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap(mode, "ia", ':<c-u>lua argument_i()<cr>', { noremap = true, silent = true })
        
        -- Getting key of key=value or "key':value pair
        vim.api.nvim_set_keymap(mode, "ik", ':<c-u>lua code_key(false)<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap(mode, "ak", ':<c-u>lua code_key(true)<cr>', { noremap = true, silent = true })
        
        -- Getting value of key=value or "key':value pair (multiline!)
        vim.api.nvim_set_keymap(mode, "iv", ':<c-u>lua code_value(false)<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap(mode, "av", ':<c-u>lua code_value(true)<cr>', { noremap = true, silent = true })
    end
    -- local chars = { '_', '.', ':', ',', ';', '|', '/', '\\', '*', '+', '%', '`', '?' }
    -- for _,char in ipairs(chars) do
    --     for _,mode in ipairs({ 'x', 'o' }) do
    --         vim.api.nvim_set_keymap(mode, "i" .. char, string.format(':<C-u>normal! T%svt%s<CR>', char, char, char), { noremap = true, silent = true })
    --         vim.api.nvim_set_keymap(mode, "a" .. char, string.format(':<C-u>normal! F%svf%s<CR>', char, char, char), { noremap = true, silent = true })
    --     end
    -- end
end

return {
    map_text_objects = map_text_objects,
}
