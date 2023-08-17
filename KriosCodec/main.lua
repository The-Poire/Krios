
--love.filesystem.setRequirePath("/KriosCodec")

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
  end

local function parser(txt)

local initial_file_size = #txt

    --Loading Comments
    local comments = {}
        --single line comments
        for l in string.gmatch(txt, "\\\\+()") do
            print(l)
            comments[#comments+1] = l
        end

        --multi-line comments
        for l in string.gmatch(txt, "\\[*]+()") do
            --print(-l)
            if type(comments[#comments]) ~= "table" and comments[#comments] < 0 then
                comments[#comments] = {-comments[#comments],l}
            else
                comments[#comments+1] = -l
            end
        end
        --print(#comments,comments[#comments][1],comments[#comments][2])
    
    -- setting up clean file
    local lastChar,last_lenght = 0,0
    for i,v in ipairs(comments) do
        last_lenght = #txt
        if type(v) == "number" then
            txt = string.sub(txt,string.find(txt,"\n",v-2) - lastChar,-1)
            lastChar = last_lenght - v - 2
        elseif type(v) == "table" then
            lastChar = initial_file_size - #txt
            --print(v[1],v[2],string.sub(txt,0,v[1]-2) .. string.sub(txt,v[2]+2,-1))
            txt = string.sub(txt,0,v[1]-3 - lastChar) .. string.sub(txt,v[2] - lastChar,-1)
        end

    end
    print(txt)
end

function love.keyreleased(key)
    if key == "escape" then love.event.quit() end
end

parser((io.open("KriosCodec/example1.krios","r")):read("a"))

