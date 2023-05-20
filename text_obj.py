import re




brackets = {
    '(': ')',
    '[': ']',
    '{': '}',
    '"': '"',
    "'": "'",
}
def match_brackets(current_brackets: list, ch):
    if ch in brackets:
        # Opening bracket
        if len(current_brackets) > 0 and current_brackets[-1] == brackets[ch]:
            # closing char pop
            current_brackets.pop()
        else:
            if len(current_brackets) == 0 or (current_brackets[-1] != '"' and current_brackets[-1] != "'"):
                # Opening bracket or char, but ignore everythin in quotes!
                current_brackets.append(ch)
    else:
        if len(current_brackets) > 0 and ch == brackets[current_brackets[-1]]:
            current_brackets.pop()
            # Include last bracket to the result
            return False
    
    return len(current_brackets) == 0


def text_obj_argument_a(line_text, col):
    ch = ''
    last_col = len(line_text)

    while col >= 0: # Lua todo: change to > 0
        ch = line_text[col]
        if ch in [',', '(', '[', '{']:
            break
        col = col -1 

    col = col + 1
    while col < last_col:
        ch = line_text[col]
        if ch != ' ':
            break
        col = col + 1

    result = []
    current_brackets = []  # Lua table, stack
    while col < last_col:
        ch = line_text[col]
        if match_brackets(current_brackets, ch):
            if ch == ',' or ch == ')':
                if ch == ',':
                    result.append(ch)
                break

        result.append(ch)
        col = col + 1

    if len(current_brackets) == 0: 
        return ''.join(result)
    else:
        # Invalid bracket combination abort
        print(current_brackets)
        print("".join(result))
        return ''

def text_obj_argument_i(line_text, col):
    obj_a = text_obj_argument_a(line_text, col)
    if obj_a:
        col = last_col = len(obj_a)-1
        while col > 0: # TODO: lua adj
            ch = obj_a[col]
            if ch != ' ' and ch != ',':
                break
            col = col - 1
        clean_text = obj_a[0:col+1] # TODO: lua index
        sep = ''

        if re.match(r"^'.*'\s*:\s*.*", clean_text):
            sep = ':'
        elif re.match(r'^".*"\s*:\s*.*', clean_text):
            sep = ':'
        elif re.match(r'^\w+\s*=\s*.*', clean_text):
            sep = '='

        if sep:
            i = clean_text.index(sep)  # lua sting.find
            return clean_text[i+1:].strip() # lua sting.sub
            # Lua trim s:match( "^%s*(.-)%s*$" )
        else:
            return clean_text


    return obj_a


def test_text_obj(func, line_text, col, expected):
    result = func(line_text, col)
    if result != expected:
        print(f'{func.__name__} [FAIL] {line_text}   ->   "{result}"')
        print(f'       {" "*col}^  Expected: "{expected}"')
        assert False
    else:
        print(f'{func.__name__} [PASS] {line_text[0:col+1]}|{line_text[col+1:]} -> "{expected}"')

def test_text_obj_a(line_text, col, expected):
    test_text_obj(text_obj_argument_a, line_text, col, expected)

def test_text_obj_i(line_text, col, expected):
    test_text_obj(text_obj_argument_i, line_text, col, expected)

if __name__ == '__main__':
    test_text_obj_a("f(a,b,c)", 1, 'a,')
    test_text_obj_a("f( a,b,c)", 1, 'a,')
    test_text_obj_a("f(a,b,c)", 2, 'a,')
    test_text_obj_a("f(a,b,c)", 3, 'b,')
    test_text_obj_a("f(a,b,", 3, 'b,')
    test_text_obj_a("f(a,b,c)", 5, 'c')
    test_text_obj_a("f(a,b,c )", 5, 'c ')
    test_text_obj_a("f(a,b,c)", 6, 'c')
    test_text_obj_a("f(a,b,c)", 7, 'c')
    test_text_obj_a("  a,b,c)", 1, 'a,')
    test_text_obj_a("f(a,  b,c)", 3, 'b,')
    test_text_obj_a("  a='',b,c)", 1, "a='',")
    test_text_obj_a("  a='',", 1, "a='',")
    test_text_obj_a("  a=',',b,c)", 1, "a=',',")
    test_text_obj_a("f(  foo(a,b),b,c)", 1, "foo(a,b),")
    test_text_obj_a("f(a,  [1, 2, 3] ,c)", 3, '[1, 2, 3] ,')
    test_text_obj_a("f(a,  [1, 2, 3] ,c)", 6, '1,')
    test_text_obj_a("f(a,  {1, 2, 3} ,c)", 5, '{1, 2, 3} ,')
    test_text_obj_a("f(a,  (1, 2, 3) ,c)", 5, '(1, 2, 3) ,')
    test_text_obj_a("f(a,f'{b}',c)", 4, "f'{b}',")
    test_text_obj_a("""f(a,f'{b["my"]}',c)""", 4, """f'{b["my"]}',""")
    test_text_obj_a("f(a, (f'{b}') if True else [1, 2, 3], c)", 4, "(f'{b}') if True else [1, 2, 3],")
    test_text_obj_a("  a='[[,',b,c)", 1, "a='[[,',")
    test_text_obj_a("""  a='"',b,c)""", 1, """a='"',""")
    test_text_obj_a("f(  foo(int(a),sqrt(b)),b,c)", 1, "foo(int(a),sqrt(b)),")
    test_text_obj_a("f(a,  [1, 2, ,c)", 5, '')
    test_text_obj_a("{ 'b': 2, c: 4}", 5, "'b': 2,")
    test_text_obj_a("    'b': 2, c: 4}", 0, "'b': 2,")
    #test_text_obj_a("f(a, ,c)", 3, ',') # TODO: decide!
    test_text_obj_i("f(a,b,c)", 1, 'a')
    test_text_obj_i("f(a   ,b,c)", 1, 'a')
    test_text_obj_i("f(a,b,c   )", 7, 'c')
    test_text_obj_i("  'a': test", 7, 'test')
    test_text_obj_i("""  "a": test2  """, 7, 'test2')
    test_text_obj_i("f(a,b,c = [1,2,3]  )", 7, '[1,2,3]')

