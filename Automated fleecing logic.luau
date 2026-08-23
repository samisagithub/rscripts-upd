local HttpService = game:GetService("HttpService")

local env = getgenv()

if env.FleecingLogicSocket then
    pcall(function()
        env.FleecingLogicSocket:Close()
    end)

    env.FleecingLogicSocket = nil
end

env.FleecingLogicStopRequested = false
env.FleecingLogicRunning = false

local websocketApi = WebSocket

if not websocketApi then
    websocketApi = websocket
end

if not websocketApi then
    warn("WebSocket API was not found.")
    return
end

if type(websocketApi.connect) ~= "function" then
    warn("WebSocket.connect was not found.")
    return
end

local success, socket = pcall(function()
    return websocketApi.connect("ws://127.0.0.1:8085/")
end)

if not success then
    warn("WebSocket connection error:", socket)
    return
end

if not socket then
    warn("WebSocket connection returned no socket.")
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

env.FleecingLogicStop = stopLogic

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

        if not decodeSuccess then
            warn("Failed to decode WebSocket message:", data)
            return
        end

        if type(data) ~= "table" then
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
