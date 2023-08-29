
--love.filesystem.setRequirePath("/KriosCodec")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

function table.print(t,showIndexes)
    for k,v in ipairs(t) do
        if showIndexes then print(k,v)
        else print(v) end
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

    --Loading Comments
    local single_line_comments,multiline_comments = {},{}

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
            print(string.sub(txt,buffer , v-3), --[[ string.sub( txt , ( string.find(txt,"\n",v - 2) or #txt - 2 ) + 1 , ( string.find(txt,"\n",v - 2) or #txt - 2 ) + 1)  ,]]"\n---------")--string.find(txt,"\n",v - 2) + 1))
            file = file.."\n"..string.sub(txt,buffer , v - 3)--string.find(txt,"\n",v - 2) + 1)
            buffer = (string.find(txt,"\n",v - 2) or #txt - 2) + 1

            if maxChar < v then maxChar = v end
            --print("N",v,string.sub(txt,v,v),#txt)
        elseif type(v) == "table" then
            --file = file..string.sub(txt,v[2],#txt) --(string.sub(txt,0,v[1]-3) .. string.sub(txt,v[2],-1))
            --file = file..string.sub(txt,buffer,#txt)

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
    end

    local assembly = {}
    for k,v in ipairs(keywords) do
        
    end


    --table.print(keywords,true)

end

function love.keyreleased(key)
    if key == "escape" then love.event.quit() end
end

parser((io.open("KriosCodec/example1.krios","r")):read("a"))

