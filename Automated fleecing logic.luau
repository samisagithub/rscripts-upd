local HttpService = game:GetService("HttpService")

local env = getgenv()

-- Hard stop any previous logic instance
if type(env.FleecingLogicStop) == "function" then
    pcall(env.FleecingLogicStop)
end

if env.FleecingLogicSocket then
    pcall(function()
        env.FleecingLogicSocket:Close()
    end)
    env.FleecingLogicSocket = nil
end

env.FleecingLogicStopRequested = true
env.FleecingLogicRunning = false

task.wait(0.45)

env.FleecingLogicStopRequested = false

if not WebSocket then
    warn("Volt WebSocket API was not found.")
    return
end

if type(WebSocket.connect) ~= "function" then
    warn("WebSocket.connect was not found.")
    return
end

env.FleecingLogicSession = (env.FleecingLogicSession or 0) + 1
local mySession = env.FleecingLogicSession

local success, socket = pcall(function()
    return WebSocket.connect("ws://78.154.103.12:15977/")
end)

if not success or not socket then
    warn("WebSocket connection failed.")
    return
end

if env.FleecingLogicSession ~= mySession then
    pcall(function()
        socket:Close()
    end)
    return
end

env.FleecingLogicSocket = socket
env.FleecingLogicRunning = true

local function stopLogic()
    env.FleecingLogicStopRequested = true
    env.FleecingLogicRunning = false

    if env.FleecingLogicSocket == socket then
        env.FleecingLogicSocket = nil
    end

    pcall(function()
        socket:Close()
    end)
end

local function receiveData(message)
    if env.FleecingLogicStopRequested then
        return
    end
    if env.FleecingLogicSession ~= mySession then
        return
    end

    if type(message) ~= "string" then
        return
    end

    local decodeSuccess, data = pcall(function()
        return HttpService:JSONDecode(message)
    end)

    if not decodeSuccess or type(data) ~= "table" then
        return
    end

    local bridge = env.FleecingGUIBridge

    if bridge and bridge.Ready and type(bridge.Receive) == "function" then
        if bridge.Session == nil or bridge.Session == env.FleecingGUISession then
            pcall(function()
                bridge.Receive(data)
            end)
        end
    end
end

if socket.OnMessage then
    socket.OnMessage:Connect(receiveData)
end

if socket.OnClose then
    socket.OnClose:Connect(function()
        if env.FleecingLogicSession ~= mySession then
            return
        end

        if env.FleecingLogicSocket == socket then
            env.FleecingLogicSocket = nil
        end

        env.FleecingLogicRunning = false

        local bridge = env.FleecingGUIBridge

        if bridge and bridge.Ready and type(bridge.Receive) == "function" then
            if bridge.Session == nil or bridge.Session == env.FleecingGUISession then
                pcall(function()
                    bridge.Receive({
                        type = "connection",
                        connected = false
                    })
                end)
            end
        end
    end)
end

local bridge = env.FleecingGUIBridge

if bridge and bridge.Ready and type(bridge.Receive) == "function" then
    if bridge.Session == nil or bridge.Session == env.FleecingGUISession then
        pcall(function()
            bridge.Receive({
                type = "connection",
                connected = true
            })
        end)
    end
end

env.FleecingLogicStop = stopLogic

print("Fleecing Logic WebSocket connected. Session:", mySession)
