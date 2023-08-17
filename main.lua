local function parser(txt)
    for l in string.gmatch(txt, "%\n") do
        io.write(l)
    end
end

io.output("outpout")

parser((io.open("main.lua","r")):read("a"))
while true do
    os.time()
end