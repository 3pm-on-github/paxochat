-- https://github.com/eletrixtime/paxochat
-- Code is bad i know, this is just a PoC

local backend_url_file = storage:file("server.link", READ)

backend_url_file:open()
backend_url = backend_url_file:readAll()
backend_url_file:close()

id = 0

MESSAGES_list = {}

function contient(tab, element)
    for _, v in ipairs(tab) do
        if v == element then
            return true
        end
    end
    return false
end


function appendMessage(msg, list,you)
            local bull = gui:box(list, 0, 0, 184, 30)
            
            local label = gui:label(bull, 0, 0, 184, 0)
            label:setHorizontalAlignment(CENTER_ALIGNMENT)
            label:setText(msg)
            label:setFontSize(18)

            local labelHeight = label:getTextHeight() + 8

            label:setHeight(labelHeight)

            local canva = gui:canvas(bull, 0, labelHeight, 68, 1)
            canva:fillRect(0, 0, 68, 1, COLOR_DARK)
            canva:setX(57)

            if(you == true) then
               bull:setX(96)
            end
            bull:setHeight(labelHeight + 9)
end
function NETWORK_call_recived_message(status,data)
    
    print(status)
    print(data)
    if data == "NO-MESSAGE" then
        print("ignored")
        return
    end
    if contient(MESSAGES_list,data) then
        return ""
    end
    table.insert(MESSAGES_list,data)
    appendMessage(data,list,false)
end
function receive_msg()
    local http_client = network:createHttpClient()
        http_client:get(backend_url.."/api/last?ex_id="..id, {
                    on_complete = NETWORK_call_recived_message
     })
end

function SCREEN_chat_ui()
    local win = gui:window()
    list = gui:vlist(win, 20, 76, 280, 320)

    local add = gui:box(win, 250, 410, 40, 40)
    add:setBackgroundColor(COLOR_DARK)
    add:setRadius(20)
        
        

    add:onClick(function ()
        number = "chat" -- wtf ?
        gui:keyboard("Message au " .. number, "",
            function (msg) 
                if(msg ~= "") then
                    NETWORK_send_message(msg)

                    appendMessage("You: "..msg, list,true)
                end
            end)
    end)

    gui:setWindow(win)
    appendMessage("[SYS] Welcome back PaxoUser"..id,list)
    time:setInterval(receive_msg, 1000)
end

function NETWORK_send_message(msg)
    local http_client = network:createHttpClient()
        http_client:get(backend_url.."/api/send?id="..id.."&text="..msg, {
                    on_complete = NETWORK_call_send_message
        })
end

function NETWORK_call_api_complete(status,data)
    print("[paxochat/NETWORK_call_api_complete@6] : API replied")
    id = data
    print(id)
end

function run()
    local winrun = gui:window()
    gui:setWindow(winrun)

    local label = gui:label(winrun, 10, 10, 300, 40)
    label:setText("PaxoChat")
    label:setFontSize(24)
    label:setHorizontalAlignment(CENTER_ALIGNMENT)

    local http_client = network:createHttpClient()
        http_client:get(backend_url.."/api/ping", {
            on_complete = NETWORK_call_api_complete
    })
    SCREEN_chat_ui()
end