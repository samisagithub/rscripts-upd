local HttpService = game:GetService("HttpService")

local env = getgenv()

if env.FleecingLogicSocket then
    pcall(function()
        env.FleecingLogicSocket:Close()
    end)

    env.FleecingLogicSocket = nil
end

env.FleecingLogicStopRequested = false
env.FleecingLogicRunning = true

local websocketLibrary = WebSocket or websocket

if not websocketLibrary then
    env.FleecingLogicRunning = false
    warn("WebSocket API was not found.")
    return
end

if type(websocketLibrary.connect) ~= "function" then
    env.FleecingLogicRunning = false
    warn("WebSocket connect function was not found.")
    return
end

local success, socket = pcall(function()
    return websocketLibrary.connect("ws://127.0.0.1:8085/")
end)

if not success or not socket then
    env.FleecingLogicRunning = false
    warn("Failed to connect to ws://127.0.0.1:8085/")
    return
end

env.FleecingLogicSocket = socket

if env.FleecingLogicStopRequested then
    pcall(function()
        socket:Close()
    end)

    env.FleecingLogicSocket = nil
    env.FleecingLogicRunning = false
    return
end

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

if socket.OnMessage then
    socket.OnMessage:Connect(function(message)
        if env.FleecingLogicStopRequested then
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
            pcall(function()
                bridge.Receive(data)
            end)
        end
    end)
end

if socket.OnClose then
    socket.OnClose:Connect(function()
        if env.FleecingLogicSocket == socket then
            env.FleecingLogicSocket = nil
        end

        env.FleecingLogicRunning = false

        local bridge = env.FleecingGUIBridge

        if bridge and bridge.Ready and type(bridge.Receive) == "function" then
            pcall(function()
                bridge.Receive({
                    type = "connection",
                    connected = false
                })
            end)
        end
    end)
end

local bridge = env.FleecingGUIBridge

if bridge and bridge.Ready and type(bridge.Receive) == "function" then
    pcall(function()
        bridge.Receive({
            type = "connection",
            connected = true
        })
    end)
end

env.FleecingLogicStop = stopLogic
