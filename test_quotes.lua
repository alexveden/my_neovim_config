require('text_objects')

local strings = {
    [[wo|rld]],
    [[|world]],
    [[world|]],
    [[|"world"]],
    [["|world"]],
    [["|world]],
    [["wor|ld"]],
    [["world|"]],
    [[              "world"                |]],
    [[              "wor|ld"]],
    [[  |              "world's inner quote"]],
    [[hello "world"|]],  -- world
    [[h|ello "world"]],  -- world
    [[|print('hello'), f("world")]], -- hello
    [[print('hello'), f("world"|)]], -- world
    [[print('hel|lo'), f("world")]], -- hello
    [[print('hello')|, f("world")]], -- hello
    [[|s = f"my composite {d['key']}"]], -- my composite {d['key']}
    [[s = f"my composite {d['key'] | }"]], -- my composite {d['key']}
    [[s = f"my composite {d[|'key']}"]], -- key
    [[s = f"my composite {d['|key']}"]], -- key
    [[s = f"my composite {d['k|ey']}"]], -- key
    [[s = f"my composite {d['key|']}"]], -- key
    [[s = r"my composite {d['key'|]}"]], -- key
    [[s = f"my composite {d['|']}"]], -- key
    [[s |= f""]], -- ''
    [[print("""'hello'""")|, f("world")]], -- WEIRD
    [[s |= f"my composite\" {d['key']}"]], -- my composite {d['key']} 
}


for _,s in pairs(strings) do
    local c = string.find(s, '|')
    assert(c, 'no current cursor')
    local line = s:sub(1, c-1) .. s:sub(c+1)
    if c >= #line then
        c = #line 
    end
    local lstart, lend = match_string(line, c, true)
    local lstarta, lenda = match_string(line, c, false)
    if lstart then
        local matched = line:sub(lstart, lend)
        print(string.format("[%s] c=%s -> quotes inner `%s`", s, c, matched))
        matched = line:sub(lstarta, lenda)
        print(string.format("[%s] c=%s -> quotes outer `%s`", s, c, matched))
    else
        print(string.format("[%s] c=%s -> quotes no match", s, c))
    end

    
end


