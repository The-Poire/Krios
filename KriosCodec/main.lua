
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

local function parser(txt)

    local initial_file_size = #txt

    --Loading Comments
    local single_line_comments,multiline_comments = {},{}

        --single line comments
        for l in string.gmatch(txt, "\\[|]+()") do
            print(l)
            single_line_comments[#single_line_comments+1] = l
        end

        --multi-line comments
        for l in string.gmatch(txt, "\\[*]+()") do
            --print(-l)
            if type(multiline_comments[#multiline_comments]) ~= "table" and multiline_comments[#multiline_comments] ~= nil and multiline_comments[#multiline_comments] < 0 then
                multiline_comments[#multiline_comments] = {-multiline_comments[#multiline_comments],l}
            else
                multiline_comments[#multiline_comments+1] = -l
            end
        end
        --print(#comments,comments[#comments][1],comments[#comments][2])
    table.merge(single_line_comments,multiline_comments)

    -- setting up comment clean file
    local lastChar,last_lenght = 0,0
    for i,v in ipairs(single_line_comments) do
        last_lenght = #txt
        if type(v) == "number" then
            txt = string.sub(txt,string.find(txt,"\n",v) + lastChar,-1)
            lastChar = last_lenght - #txt
        elseif type(v) == "table" then
            lastChar = initial_file_size - #txt
            --print(v[1],v[2],string.sub(txt,0,v[1]-2) .. string.sub(txt,v[2]+2,-1))
            txt = string.sub(txt,0,v[1]-3 - lastChar) .. string.sub(txt,v[2] - lastChar,-1)
        end
        print(txt,"\n-----------\n\n")
    end

    print(txt,"\n\n-------\n")

    --Spliting keywords
    local keywords = {}
    for k in txt:gmatch("%S+") do
        keywords[#keywords+1] = k
    end

    for k,v in ipairs(keywords) do
        
    end


    table.print(keywords,true)

end

function love.keyreleased(key)
    if key == "escape" then love.event.quit() end
end

parser((io.open("KriosCodec/example1.krios","r")):read("a"))

