
local local_path = love.filesystem.getSource()

local utils = {
    b = function(txt,state,_i)
        if string.sub(txt,_i,_i + 1) == "\\|" then
            state[2] = "ci"
            state[3] = _i
        elseif string.sub(txt,_i,_i + 1) == "\\*" then
            state[2] = "cm"
            state[3] = _i
        elseif string.sub(txt,_i,_i+5) == "local " then
            state[2] = "wl1"
            state[3] = _i + 5
        end

        return state,_i
    end,
    ci = function(txt,state,_i)
        if string.sub(txt,_i,_i) == "\n" then
            state[2] = "b"
        end

        return state,_i
    end,
    cm = function(txt,state,_i)
        if string.sub(txt,_i,_i+1) == "\\*" then
            state[2] = "b"
            _i =_i+1
        end

        return state,_i
    end,
    wl1 = function(txt,state,_i)
        local a = string.sub(txt,_i,_i)
        
        if string.sub(txt,_i,_i) == "=" then
            state[5] = string.sub(txt,state[3],_i - 1)
            state[3] = _i + 1
            _i=_i+1
            state[2] = "wl2"
        end

        --[[if a == "\"" or a == "'" then
            state[2] = "wl1s"
            state[3] = _i
        elseif tostring(tonumber(a)) == a then
            state[2] = "wl1i"
            _i = _i - 1
            state[3] = _i
        end]]

        return state,_i
    end,

    --[[wl1i = function(txt,state,_i)
        if tostring(tonumber(string.sub(txt,_i,_i))) == string.sub(txt,_i,_i) then
            state[5] = string.sub(txt,state[3],_i - 1)
            state[3] = _i + 1
            state[2] = "wl2"
        end

        return state,_i
    end,
    wl1s = function(txt,state,_i)
        if string.sub(txt,_i,_i) == "=" then
            state[5] = string.sub(txt,state[3],_i - 1)
            state[3] = _i + 1
            _i=_i+1
            state[2] = "wl2"
        end

        return state,_i
    end,]]

    wl2 = function(txt,state,_i)
        local a = string.sub(txt,_i,_i)
        if a == "\"" or a == "'" then
            state[2] = "wl2s"
        elseif tostring(tonumber(a)) == a then
            state[2] = "wl2i"
            --_i = _i - 1
        end

        return state,_i
    end,

    wl2i = function(txt,state,_i)
        if tostring(tonumber(string.sub(txt,_i,_i))) == string.sub(txt,_i,_i) then
            state[6] = string.sub(txt,state[3],_i - 1)
            state[3] = _i + 1
            state[2] = "b"
        end

        return state,_i
    end,
    
    wl2s = function(txt,state,_i)
        if string.sub(txt,_i,_i) == "=" then
            state[5] = string.sub(txt,state[3],_i - 1)
            state[3] = _i + 1
            state[2] = "b"
        end

        return state,_i
    end,


null = function(txt,state,_i)


        return state,_i
    end,
}

--love.filesystem.setRequirePath("/KriosCodec")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

function table.print(t,showIndexes,singleLine)
    if singleLine then
        print("{ "..table.concat(t," , ").." }")
    else
        for k,v in ipairs(t) do
            if showIndexes then print(k,v)
            else print(v) end
        end
    end
end

function table.merge(t1,t2,mode)
    mode = mode or "concat"
    if mode == "concat" then
        for k, v in ipairs(t2) do
            t1[#t1+1] = v
        end
    elseif mode == "une-by-one"  then
        for k, v in ipairs(t2) do
            table.insert(t1,k,v)
        end
    end
end

local function comp(a,b)
    --[[if type(a) == "table" then
        if type(b) == "table" then return a[1]<b[2] end
        return false
    end
    if type(b) == "table" then
        if type(a) == "table" then return a[1]<b[2] end
        return false
    end]]
    if type(a) == "table" then a = a[1] end
    if type(b) == "table" then b = b[1] end
    return a<b
end

local function parser(txt)

    local initial_file_size = #txt
    local state = {0,"b",0,0,"",""}
    local assembly,buffer = {},{}

    local _i = 0
    while true do
        --if state[2] == nil then
            state[4] = _i
        --end
        state,_i = utils[state[2]](txt,state,_i)
        print(string.sub(txt,state[3],_i - 1))
        --[[if state[2] == "wl2" and string.sub(txt,_i,_i) == "\n" then
            state[6] = string.sub(txt,state[3],_i - 1)
            state[2] = "b"
        end

        if state[2] == "cm" and string.sub(txt,_i,_i+1) == "\\*" then
            state[2] = "b"
            _i = _i + 1
        end]]


        if _i >= initial_file_size then break end

        --print(string.sub(txt,_i,_i+4))
        table.print(state,false,true)

        _i = _i + 1
    end

    --Loading Comments
    --[====[local single_line_comments,multiline_comments = {},{}

        --single line comments
        for v in string.gmatch(txt, "\\[|]+()") do
            print(v,string.sub(txt,v,v))
            single_line_comments[#single_line_comments+1] = v
        end

        --multi-line comments
        for v in string.gmatch(txt, "\\[*]+()") do
            --print(-l)
            if type(multiline_comments[#multiline_comments]) ~= "table" and multiline_comments[#multiline_comments] ~= nil and multiline_comments[#multiline_comments] < 0 then
                multiline_comments[#multiline_comments] = {-multiline_comments[#multiline_comments],v}
            else
                multiline_comments[#multiline_comments+1] = -v
            end
        end
        --print(#comments,comments[#comments][1],comments[#comments][2])

        --sorting table
        table.merge(single_line_comments,multiline_comments)
        --single_line_comments = multiline_comments
        table.sort(single_line_comments,comp)

        local buffer,_i = single_line_comments,0
        for k,v in ipairs(single_line_comments) do
            if type(v) == "table" and single_line_comments[k + 1] > v[1] and single_line_comments[k + 1] < v[2] then
                table.remove(buffer,k-_i + 1)
                _i = _i + 1
            end
        end
        single_line_comments = buffer

        --table.sort(multiline_comments,comp)
        --multiline_comments = nil
        print("---------------------")
        table.print(single_line_comments)
        print("---------------------")
        --table.print(multiline_comments)
        --print("---------------------")

    -- setting up comment clean file
    local file,buffer,maxChar = "",0,0
    for i, v in ipairs(single_line_comments) do
        if type(v) == "number" then
            --print(string.sub(txt,buffer , v-3),string.sub(txt,(string.find(txt,"\n",v - 2) or #txt - 2) + 1))-- --[[ string.sub( txt , ( string.find(txt,"\n",v - 2) or #txt - 2 ) + 1 , ( string.find(txt,"\n",v - 2) or #txt - 2 ) + 1)  ,]]"\n---------")--string.find(txt,"\n",v - 2) + 1))
            file = file.."\n"..string.sub(txt,buffer , v - 3)--string.find(txt,"\n",v - 2) + 1)
            buffer = (string.find(txt,"\n",v - 2) or #txt - 2) + 1

            if maxChar < v then maxChar = v end
            --print("N",v,string.sub(txt,v,v),#txt)
        elseif type(v) == "table" then
            --file = file..string.sub(txt,v[2],#txt) --(string.sub(txt,0,v[1]-3) .. string.sub(txt,v[2],-1))
            --file = file..string.sub(txt,buffer,#txt)
            file=file..string.sub(txt,buffer,v[1]-3)
            if maxChar < v[2] then maxChar = v[2] end
            buffer = v[2]
            --print("T",maxChar,string.sub(txt,maxChar,maxChar),#txt)
        end
        --print(file,"\n-----",i,v,string.sub(txt,v,v),"-----")
    end
    file = file.."\n"..string.sub(txt,buffer - 1,#txt)
    --print(file,"\n-----")
    txt = file
    --print("\n-------------------\n\n",txt)

    --[[local lastChar,last_lenght = 0,0
    for i,v in ipairs(single_line_comments) do
        if type(v) == "number" then
            --print(single_line_comments[i] - 2)
            print(v - 3,string.find(txt,"\n",v - 2) + 1,"\n-------")
            --txt = string.sub(txt,string.find(txt,"\n",v + 2) -i + 1,-1)-- + lastChar,-1)
            txt = string.sub(txt,0,v - 3)..string.sub(txt,string.find(txt,"\n",v - 2) + 1 - lastChar)
        elseif type(v) == "table" then
            lastChar = initial_file_size - #txt
            --print(v[1],v[2],string.sub(txt,0,v[1]-2) .. string.sub(txt,v[2]+2,-1))
            txt = string.sub(txt,0,v[1]-3 - lastChar) .. string.sub(txt,v[2] - lastChar,-1)
        end
        print(txt,"\n-----------\n\n")
    end]]

    print(txt,"\n\n-------\n")

    --Spliting keywords
    local keywords = {}
    local _i = {}
    for k in txt:gmatch("[^\n]+") do
        keywords[#keywords+1] = k.." ;"
    end

    _i = keywords
    _i = table.concat(_i,"\n")
    keywords = {}
    for k in _i:gmatch("%S+") do
        keywords[#keywords+1] = k
    end

    _i = 1
    for k in txt:gmatch("%\n+()") do
        --keywords[_i] = k.." "..keywords[_i]
        --print(txt)
        if string.sub(txt,k,k) == "\n" then
            table.insert(keywords,_i,";")
            --print(keywords[_i],_i,string.sub(txt,k,k),k)
        end
        _i = _i + 2
    end]====]


    --[[for k,v in ipairs(keywords) do
        --ASSEMBLY_OPERATIONS["_"..v]
        if nil then
        elseif v = then
        elseif tostring(tonumber(v)) == v then
            buffer[2] = tonumber(v)
            print(k,v)
        elseif v == "local" then
            buffer = {"local"}
        end
    end]]


    --table.print(keywords,true)

end

function love.keyreleased(key)
    if key == "escape" then love.event.quit() end
end

require(local_path.."/testing.lua")

--parser((io.open("KriosCodec/example1.krios","r")):read("a"))

