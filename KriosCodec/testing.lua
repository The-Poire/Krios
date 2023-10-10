local char = ""

for i = 0,255 do
    char = string.char(i)
    assert(char == tostring(tonumber(a)), char,tonumber(char))
end