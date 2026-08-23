local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local env = getgenv()

local oldDiagnostic = playerGui:FindFirstChild("FleecingLogicDiagnostic")
if oldDiagnostic then
    oldDiagnostic:Destroy()
end

local diagnosticGui = Instance.new("ScreenGui")
diagnosticGui.Name = "FleecingLogicDiagnostic"
diagnosticGui.ResetOnSpawn = false
diagnosticGui.IgnoreGuiInset = true
diagnosticGui.DisplayOrder = 1000000
diagnosticGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 190)
frame.Position = UDim2.new(0.5, -180, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(28, 32, 30)
frame.BorderSizePixel = 0
frame.Parent = diagnosticGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Fleecing Logic Diagnostic"
title.TextColor3 = Color3.fromRGB(235, 240, 237)
title.TextSize = 15
title.Font = Enum.Font.GothamMedium
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 28)
status.Position = UDim2.new(0, 15, 0, 45)
status.BackgroundColor3 = Color3.fromRGB(55, 95, 70)
status.BorderSizePixel = 0
status.Text = "SCRIPT IS RUNNING"
status.TextColor3 = Color3.fromRGB(220, 245, 228)
status.TextSize = 12
status.Font = Enum.Font.GothamMedium
status.Parent = frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 7)
statusCorner.Parent = status

local connection = Instance.new("TextLabel")
connection.Size = UDim2.new(1, -30, 0, 24)
connection.Position = UDim2.new(0, 15, 0, 82)
connection.BackgroundTransparency = 1
connection.Text = "WebSocket: NOT CONNECTED"
connection.TextColor3 = Color3.fromRGB(200, 205, 202)
connection.TextSize = 11
connection.Font = Enum.Font.Gotham
connection.TextXAlignment = Enum.TextXAlignment.Left
connection.Parent = frame

local lastMessage = Instance.new("TextLabel")
lastMessage.Size = UDim2.new(1, -30, 0, 40)
lastMessage.Position = UDim2.new(0, 15, 0, 110)
lastMessage.BackgroundTransparency = 1
lastMessage.Text = "Last message: None"
lastMessage.TextColor3 = Color3.fromRGB(170, 180, 174)
lastMessage.TextSize = 10
lastMessage.Font = Enum.Font.Gotham
lastMessage.TextWrapped = true
lastMessage.TextXAlignment = Enum.TextXAlignment.Left
lastMessage.TextYAlignment = Enum.TextYAlignment.Top
lastMessage.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -32, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(55, 60, 57)
close.BorderSizePixel = 0
close.Text = "×"
close.TextColor3 = Color3.fromRGB(230, 235, 232)
close.TextSize = 16
close.Font = Enum.Font.Gotham
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    diagnosticGui:Destroy()
end)

local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - dragStart

    frame.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

local function setConnection(text, color)
    connection.Text = "WebSocket: " .. text
    connection.TextColor3 = color
end

local function setLastMessage(text)
    lastMessage.Text = "Last message: " .. tostring(text)
end

setLastMessage("Logic script loaded successfully.")

task.wait()

local websocketLibrary = WebSocket or websocket

if not websocketLibrary then
    setConnection(
        "API NOT FOUND",
        Color3.fromRGB(220, 120, 120)
    )

    setLastMessage("WebSocket/WebSocket API was not found.")
    return
end

if type(websocketLibrary.connect) ~= "function" then
    setConnection(
        "CONNECT FUNCTION NOT FOUND",
        Color3.fromRGB(220, 120, 120)
    )

    setLastMessage("websocket.connect is unavailable.")
    return
end

setLastMessage("WebSocket API found.")

local success, socket = pcall(function()
    return websocketLibrary.connect("ws://127.0.0.1:8085/")
end)

if not success or not socket then
    setConnection(
        "CONNECTION FAILED",
        Color3.fromRGB(220, 120, 120)
    )

    setLastMessage("Could not connect to ws://127.0.0.1:8085/")
    return
end

setConnection(
    "CONNECTED",
    Color3.fromRGB(120, 210, 150)
)

setLastMessage("Connected to C# bridge.")

if socket.OnMessage then
    socket.OnMessage:Connect(function(message)
        setLastMessage(message)

        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(message)
        end)

        if not decodeSuccess then
            return
        end

        if type(data) ~= "table" then
            return
        end

        if data.type == "user_online" and type(data.username) == "string" then
            setLastMessage("USER ONLINE: " .. data.username)
        elseif data.type == "user_offline" and type(data.username) == "string" then
            setLastMessage("USER OFFLINE: " .. data.username)
        end
    end)
else
    setConnection(
        "ONMESSAGE UNAVAILABLE",
        Color3.fromRGB(220, 120, 120)
    )

    setLastMessage("Socket exists, but OnMessage is unavailable.")
end

if socket.OnClose then
    socket.OnClose:Connect(function()
        setConnection(
            "DISCONNECTED",
            Color3.fromRGB(220, 170, 100)
        )

        setLastMessage("C# bridge connection closed.")
    end)
end

env.FleecingLogicRunning = true
