local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local env = getgenv()

local oldGui = playerGui:FindFirstChild("FleecingGUI")

-- Full cleanup when re-running (same as CLEAR)
if type(env.FleecingClearData) == "function" then
    pcall(env.FleecingClearData)
end

env.FleecingStopRequested = true
env.FleecingLogicStopRequested = true

if type(env.FleecingLogicStop) == "function" then
    pcall(env.FleecingLogicStop)
end

env.FleecingGUIBridge = nil
env.FleecingClearData = nil
env.FleecingLoopTrades = false

if oldGui then
    oldGui:Destroy()
end

env.FleecingStopRequested = false
env.FleecingLogicStopRequested = false

-- Session lock (stops spam race)
env.FleecingGUISession = (env.FleecingGUISession or 0) + 1
local myGuiSession = env.FleecingGUISession
local acceptingData = false

-------------------------------------------------
-- CONFIG / JSON PERSISTENCE
-------------------------------------------------
local CONFIG_FILE = "FleecingConfig.json"
local markedUsers = {}
local fleecingEnabled = false
local loopTradesEnabled = false
local minimized = false
local currentSection = "Main"
local destroyed = false
local dragging = false
local dragStart
local startPosition
local imageCounter = 0
local helpOpen = false
local settingsOpen = false
local isTrading = false
local loopRunning = false

local function saveConfig()
    local data = {
        loopTrades = loopTradesEnabled,
        markedUsers = markedUsers
    }
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if success and type(writefile) == "function" then
        pcall(function()
            writefile(CONFIG_FILE, encoded)
        end)
    end
end

local function loadConfig()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return
    end
    local exists = false
    pcall(function()
        exists = isfile(CONFIG_FILE)
    end)
    if not exists then return end

    local success, content = pcall(function()
        return readfile(CONFIG_FILE)
    end)
    if not success or type(content) ~= "string" or content == "" then return end

    local ok, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if not ok or type(data) ~= "table" then return end

    if type(data.loopTrades) == "boolean" then
        loopTradesEnabled = data.loopTrades
    end
    if type(data.markedUsers) == "table" then
        markedUsers = data.markedUsers
    end
end

loadConfig()

-------------------------------------------------
-- GUI CREATION
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FleecingGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 999999
gui.Parent = playerGui

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(0, 444, 0, 364)
shadow.Position = UDim2.new(0.5, -222, 0.5, -182)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.65
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
shadow.Parent = gui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 428, 0, 348)
frame.Position = UDim2.new(0.5, -214, 0.5, -174)
frame.BackgroundColor3 = Color3.fromRGB(30, 34, 32)
frame.BorderSizePixel = 0
frame.ZIndex = 2
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(86, 101, 93)
frameStroke.Thickness = 1
frameStroke.Transparency = 0.15
frameStroke.Parent = frame

local topBar = Instance.new("Frame")
topBar.Name = "TitleBar"
topBar.Size = UDim2.new(1, 0, 0, 62)
topBar.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
topBar.BorderSizePixel = 0
topBar.ZIndex = 3
topBar.Parent = frame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 14)
topBarCorner.Parent = topBar

local topBarBottom = Instance.new("Frame")
topBarBottom.Size = UDim2.new(1, 0, 0, 16)
topBarBottom.Position = UDim2.new(0, 0, 1, -16)
topBarBottom.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
topBarBottom.BorderSizePixel = 0
topBarBottom.ZIndex = 3
topBarBottom.Parent = topBar

local accent = Instance.new("Frame")
accent.Size = UDim2.new(0, 4, 0, 28)
accent.Position = UDim2.new(0, 18, 0, 17)
accent.BackgroundColor3 = Color3.fromRGB(119, 183, 145)
accent.BorderSizePixel = 0
accent.ZIndex = 5
accent.Parent = frame

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 3)
accentCorner.Parent = accent

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -190, 0, 24)
title.Position = UDim2.new(0, 31, 0, 11)
title.BackgroundTransparency = 1
title.Text = "Fleecing Tool"
title.TextColor3 = Color3.fromRGB(240, 244, 242)
title.TextSize = 17
title.Font = Enum.Font.GothamMedium
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 5
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -190, 0, 18)
subtitle.Position = UDim2.new(0, 31, 0, 33)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Ready to fleece the right way, created by Sam"
subtitle.TextColor3 = Color3.fromRGB(151, 162, 156)
subtitle.TextSize = 11
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 5
subtitle.Parent = frame

local settingsBtn = Instance.new("TextButton")
settingsBtn.Name = "Settings"
settingsBtn.Size = UDim2.new(0, 34, 0, 34)
settingsBtn.Position = UDim2.new(1, -129, 0, 14)
settingsBtn.BackgroundColor3 = Color3.fromRGB(48, 54, 51)
settingsBtn.BorderSizePixel = 0
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = Color3.fromRGB(194, 202, 198)
settingsBtn.TextSize = 16
settingsBtn.Font = Enum.Font.GothamMedium
settingsBtn.AutoButtonColor = false
settingsBtn.Active = true
settingsBtn.Selectable = true
settingsBtn.ZIndex = 20
settingsBtn.Visible = false
settingsBtn.Parent = frame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 9)
settingsCorner.Parent = settingsBtn

local minimize = Instance.new("TextButton")
minimize.Name = "Minimize"
minimize.Size = UDim2.new(0, 34, 0, 34)
minimize.Position = UDim2.new(1, -88, 0, 14)
minimize.BackgroundColor3 = Color3.fromRGB(48, 54, 51)
minimize.BorderSizePixel = 0
minimize.Text = "−"
minimize.TextColor3 = Color3.fromRGB(194, 202, 198)
minimize.TextSize = 20
minimize.Font = Enum.Font.GothamMedium
minimize.AutoButtonColor = false
minimize.Active = true
minimize.Selectable = true
minimize.ZIndex = 20
minimize.Parent = frame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 9)
minimizeCorner.Parent = minimize

local exit = Instance.new("TextButton")
exit.Name = "Close"
exit.Size = UDim2.new(0, 34, 0, 34)
exit.Position = UDim2.new(1, -47, 0, 14)
exit.BackgroundColor3 = Color3.fromRGB(48, 54, 51)
exit.BorderSizePixel = 0
exit.Text = "×"
exit.TextColor3 = Color3.fromRGB(194, 202, 198)
exit.TextSize = 21
exit.Font = Enum.Font.Gotham
exit.AutoButtonColor = false
exit.Active = true
exit.Selectable = true
exit.ZIndex = 20
exit.Parent = frame

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 9)
exitCorner.Parent = exit

local statusCard = Instance.new("Frame")
statusCard.Name = "StatusCard"
statusCard.Size = UDim2.new(1, -148, 0, 51)
statusCard.Position = UDim2.new(0, 16, 0, 76)
statusCard.BackgroundColor3 = Color3.fromRGB(37, 43, 40)
statusCard.BorderSizePixel = 0
statusCard.ZIndex = 4
statusCard.Parent = frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 9)
statusCorner.Parent = statusCard

local statusIndicator = Instance.new("Frame")
statusIndicator.Size = UDim2.new(0, 7, 0, 7)
statusIndicator.Position = UDim2.new(0, 15, 0, 15)
statusIndicator.BackgroundColor3 = Color3.fromRGB(116, 126, 121)
statusIndicator.BorderSizePixel = 0
statusIndicator.ZIndex = 6
statusIndicator.Parent = statusCard

local statusIndicatorCorner = Instance.new("UICorner")
statusIndicatorCorner.CornerRadius = UDim.new(1, 0)
statusIndicatorCorner.Parent = statusIndicator

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -45, 0, 19)
status.Position = UDim2.new(0, 33, 0, 8)
status.BackgroundTransparency = 1
status.Text = "Fleecing Disabled"
status.TextColor3 = Color3.fromRGB(218, 224, 221)
status.TextSize = 12
status.Font = Enum.Font.GothamMedium
status.TextXAlignment = Enum.TextXAlignment.Left
status.ZIndex = 6
status.Parent = statusCard

local statusDescription = Instance.new("TextLabel")
statusDescription.Size = UDim2.new(1, -45, 0, 17)
statusDescription.Position = UDim2.new(0, 33, 0, 27)
statusDescription.BackgroundTransparency = 1
statusDescription.Text = "Ready"
statusDescription.TextColor3 = Color3.fromRGB(145, 155, 150)
statusDescription.TextSize = 10
statusDescription.Font = Enum.Font.Gotham
statusDescription.TextXAlignment = Enum.TextXAlignment.Left
statusDescription.ZIndex = 6
statusDescription.Parent = statusCard

local sidePanel = Instance.new("Frame")
sidePanel.Name = "SideActions"
sidePanel.Size = UDim2.new(0, 116, 0, 51)
sidePanel.Position = UDim2.new(1, -132, 0, 76)
sidePanel.BackgroundColor3 = Color3.fromRGB(37, 43, 40)
sidePanel.BorderSizePixel = 0
sidePanel.ZIndex = 4
sidePanel.Parent = frame

local sidePanelCorner = Instance.new("UICorner")
sidePanelCorner.CornerRadius = UDim.new(0, 9)
sidePanelCorner.Parent = sidePanel

local sideLabel = Instance.new("TextLabel")
sideLabel.Size = UDim2.new(1, -16, 0, 12)
sideLabel.Position = UDim2.new(0, 8, 0, 5)
sideLabel.BackgroundTransparency = 1
sideLabel.Text = "ACTIONS"
sideLabel.TextColor3 = Color3.fromRGB(120, 132, 125)
sideLabel.TextSize = 8
sideLabel.Font = Enum.Font.GothamMedium
sideLabel.TextXAlignment = Enum.TextXAlignment.Center
sideLabel.ZIndex = 6
sideLabel.Parent = sidePanel

local helpButton = Instance.new("TextButton")
helpButton.Name = "Help"
helpButton.Size = UDim2.new(0, 45, 0, 24)
helpButton.Position = UDim2.new(0, 8, 0, 22)
helpButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
helpButton.BorderSizePixel = 0
helpButton.Text = "HELP"
helpButton.TextColor3 = Color3.fromRGB(231, 242, 235)
helpButton.TextSize = 8
helpButton.Font = Enum.Font.GothamMedium
helpButton.AutoButtonColor = false
helpButton.Active = true
helpButton.Selectable = true
helpButton.ZIndex = 20
helpButton.Parent = sidePanel

local helpCorner = Instance.new("UICorner")
helpCorner.CornerRadius = UDim.new(0, 6)
helpCorner.Parent = helpButton

local clearButton = Instance.new("TextButton")
clearButton.Name = "ClearData"
clearButton.Size = UDim2.new(0, 55, 0, 24)
clearButton.Position = UDim2.new(0, 59, 0, 22)
clearButton.BackgroundColor3 = Color3.fromRGB(55, 63, 59)
clearButton.BorderSizePixel = 0
clearButton.Text = "CLEAR"
clearButton.TextColor3 = Color3.fromRGB(207, 215, 211)
clearButton.TextSize = 8
clearButton.Font = Enum.Font.GothamMedium
clearButton.AutoButtonColor = false
clearButton.Active = true
clearButton.Selectable = true
clearButton.ZIndex = 20
clearButton.Parent = sidePanel

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearButton

local toggle = Instance.new("TextButton")
toggle.Name = "StartFleecing"
toggle.Size = UDim2.new(0, 198, 0, 39)
toggle.Position = UDim2.new(0, 16, 0, 137)
toggle.BackgroundColor3 = Color3.fromRGB(61, 72, 66)
toggle.BorderSizePixel = 0
toggle.Text = "START FLEECING"
toggle.TextColor3 = Color3.fromRGB(237, 243, 239)
toggle.TextSize = 11
toggle.Font = Enum.Font.GothamMedium
toggle.AutoButtonColor = false
toggle.Active = true
toggle.Selectable = true
toggle.ZIndex = 6
toggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 9)
toggleCorner.Parent = toggle

local loopTrades = Instance.new("TextButton")
loopTrades.Name = "LoopTrades"
loopTrades.Size = UDim2.new(0, 198, 0, 39)
loopTrades.Position = UDim2.new(0, 222, 0, 137)
loopTrades.BackgroundColor3 = Color3.fromRGB(43, 49, 46)
loopTrades.BorderSizePixel = 0
loopTrades.Text = "LOOP TRADES"
loopTrades.TextColor3 = Color3.fromRGB(207, 215, 211)
loopTrades.TextSize = 11
loopTrades.Font = Enum.Font.GothamMedium
loopTrades.AutoButtonColor = false
loopTrades.Active = true
loopTrades.Selectable = true
loopTrades.ZIndex = 6
loopTrades.Parent = frame

local loopTradesCorner = Instance.new("UICorner")
loopTradesCorner.CornerRadius = UDim.new(0, 9)
loopTradesCorner.Parent = loopTrades

local sectionLabel = Instance.new("TextLabel")
sectionLabel.Size = UDim2.new(1, -32, 0, 15)
sectionLabel.Position = UDim2.new(0, 16, 0, 185)
sectionLabel.BackgroundTransparency = 1
sectionLabel.Text = "SECTIONS"
sectionLabel.TextColor3 = Color3.fromRGB(120, 132, 125)
sectionLabel.TextSize = 9
sectionLabel.Font = Enum.Font.GothamMedium
sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
sectionLabel.ZIndex = 6
sectionLabel.Parent = frame

local mainButton = Instance.new("TextButton")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(0.5, -20, 0, 39)
mainButton.Position = UDim2.new(0, 16, 0, 205)
mainButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
mainButton.BorderSizePixel = 0
mainButton.Text = "MAIN"
mainButton.TextColor3 = Color3.fromRGB(231, 242, 235)
mainButton.TextSize = 10
mainButton.Font = Enum.Font.GothamMedium
mainButton.AutoButtonColor = false
mainButton.Active = true
mainButton.Selectable = true
mainButton.ZIndex = 6
mainButton.Parent = frame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 9)
mainCorner.Parent = mainButton

local logsButton = Instance.new("TextButton")
logsButton.Name = "LogsButton"
logsButton.Size = UDim2.new(0.5, -20, 0, 39)
logsButton.Position = UDim2.new(0.5, 4, 0, 205)
logsButton.BackgroundColor3 = Color3.fromRGB(43, 49, 46)
logsButton.BorderSizePixel = 0
logsButton.Text = "LOGS"
logsButton.TextColor3 = Color3.fromRGB(207, 215, 211)
logsButton.TextSize = 10
logsButton.Font = Enum.Font.GothamMedium
logsButton.AutoButtonColor = false
logsButton.Active = true
logsButton.Selectable = true
logsButton.ZIndex = 6
logsButton.Parent = frame

local logsCorner = Instance.new("UICorner")
logsCorner.CornerRadius = UDim.new(0, 9)
logsCorner.Parent = logsButton

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -32, 0, 112)
content.Position = UDim2.new(0, 16, 0, 252)
content.BackgroundColor3 = Color3.fromRGB(37, 43, 40)
content.BorderSizePixel = 0
content.ZIndex = 4
content.Parent = frame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 9)
contentCorner.Parent = content

local mainContent = Instance.new("ScrollingFrame")
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1, 0, 1, 0)
mainContent.BackgroundTransparency = 1
mainContent.BorderSizePixel = 0
mainContent.ScrollBarThickness = 5
mainContent.ScrollBarImageColor3 = Color3.fromRGB(91, 108, 99)
mainContent.ScrollBarImageTransparency = 0.15
mainContent.ScrollingDirection = Enum.ScrollingDirection.Y
mainContent.CanvasSize = UDim2.new(0, 0, 0, 0)
mainContent.CanvasPosition = Vector2.new(0, 0)
mainContent.Visible = true
mainContent.ZIndex = 5
mainContent.Parent = content

local mainEmpty = Instance.new("TextLabel")
mainEmpty.Name = "Empty"
mainEmpty.Size = UDim2.new(1, -20, 0, 24)
mainEmpty.Position = UDim2.new(0, 10, 0.5, -12)
mainEmpty.BackgroundTransparency = 1
mainEmpty.Text = "Waiting for online Roblox users..."
mainEmpty.TextColor3 = Color3.fromRGB(145, 155, 150)
mainEmpty.TextSize = 11
mainEmpty.Font = Enum.Font.Gotham
mainEmpty.TextXAlignment = Enum.TextXAlignment.Center
mainEmpty.ZIndex = 6
mainEmpty.Parent = mainContent

local logsContent = Instance.new("ScrollingFrame")
logsContent.Name = "LogsContent"
logsContent.Size = UDim2.new(1, 0, 1, 0)
logsContent.BackgroundTransparency = 1
logsContent.BorderSizePixel = 0
logsContent.ScrollBarThickness = 5
logsContent.ScrollBarImageColor3 = Color3.fromRGB(91, 108, 99)
logsContent.ScrollBarImageTransparency = 0.15
logsContent.ScrollingDirection = Enum.ScrollingDirection.Y
logsContent.CanvasSize = UDim2.new(0, 0, 0, 0)
logsContent.Visible = false
logsContent.ZIndex = 5
logsContent.Parent = content

local logsEmpty = Instance.new("TextLabel")
logsEmpty.Name = "Empty"
logsEmpty.Size = UDim2.new(1, -20, 0, 24)
logsEmpty.Position = UDim2.new(0, 10, 0.5, -12)
logsEmpty.BackgroundTransparency = 1
logsEmpty.Text = "No logs yet."
logsEmpty.TextColor3 = Color3.fromRGB(145, 155, 150)
logsEmpty.TextSize = 11
logsEmpty.Font = Enum.Font.Gotham
logsEmpty.TextXAlignment = Enum.TextXAlignment.Center
logsEmpty.ZIndex = 6
logsEmpty.Parent = logsContent

-------------------------------------------------
-- HELP FRAME
-------------------------------------------------
local helpShadow = Instance.new("Frame")
helpShadow.Name = "HelpShadow"
helpShadow.Size = UDim2.new(0, 416, 0, 316)
helpShadow.Position = UDim2.new(0.5, -208, 0.5, -158)
helpShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
helpShadow.BackgroundTransparency = 0.65
helpShadow.BorderSizePixel = 0
helpShadow.Visible = false
helpShadow.ZIndex = 50
helpShadow.Parent = gui

local helpShadowCorner = Instance.new("UICorner")
helpShadowCorner.CornerRadius = UDim.new(0, 16)
helpShadowCorner.Parent = helpShadow

local helpFrame = Instance.new("Frame")
helpFrame.Name = "HelpFrame"
helpFrame.Size = UDim2.new(0, 400, 0, 300)
helpFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
helpFrame.BackgroundColor3 = Color3.fromRGB(30, 34, 32)
helpFrame.BorderSizePixel = 0
helpFrame.Visible = false
helpFrame.ZIndex = 51
helpFrame.Parent = gui

local helpFrameCorner = Instance.new("UICorner")
helpFrameCorner.CornerRadius = UDim.new(0, 14)
helpFrameCorner.Parent = helpFrame

local helpFrameStroke = Instance.new("UIStroke")
helpFrameStroke.Color = Color3.fromRGB(86, 101, 93)
helpFrameStroke.Thickness = 1
helpFrameStroke.Transparency = 0.15
helpFrameStroke.Parent = helpFrame

local helpTopBar = Instance.new("Frame")
helpTopBar.Name = "TitleBar"
helpTopBar.Size = UDim2.new(1, 0, 0, 62)
helpTopBar.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
helpTopBar.BorderSizePixel = 0
helpTopBar.ZIndex = 52
helpTopBar.Parent = helpFrame

local helpTopCorner = Instance.new("UICorner")
helpTopCorner.CornerRadius = UDim.new(0, 14)
helpTopCorner.Parent = helpTopBar

local helpTopBottom = Instance.new("Frame")
helpTopBottom.Size = UDim2.new(1, 0, 0, 16)
helpTopBottom.Position = UDim2.new(0, 0, 1, -16)
helpTopBottom.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
helpTopBottom.BorderSizePixel = 0
helpTopBottom.ZIndex = 52
helpTopBottom.Parent = helpTopBar

local helpAccent = Instance.new("Frame")
helpAccent.Size = UDim2.new(0, 4, 0, 28)
helpAccent.Position = UDim2.new(0, 18, 0, 17)
helpAccent.BackgroundColor3 = Color3.fromRGB(119, 183, 145)
helpAccent.BorderSizePixel = 0
helpAccent.ZIndex = 54
helpAccent.Parent = helpFrame

local helpAccentCorner = Instance.new("UICorner")
helpAccentCorner.CornerRadius = UDim.new(0, 3)
helpAccentCorner.Parent = helpAccent

local helpTitle = Instance.new("TextLabel")
helpTitle.Size = UDim2.new(1, -100, 0, 24)
helpTitle.Position = UDim2.new(0, 31, 0, 11)
helpTitle.BackgroundTransparency = 1
helpTitle.Text = "Fleecing Tool Help"
helpTitle.TextColor3 = Color3.fromRGB(240, 244, 242)
helpTitle.TextSize = 17
helpTitle.Font = Enum.Font.GothamMedium
helpTitle.TextXAlignment = Enum.TextXAlignment.Left
helpTitle.ZIndex = 54
helpTitle.Parent = helpFrame

local helpSubtitle = Instance.new("TextLabel")
helpSubtitle.Size = UDim2.new(1, -100, 0, 18)
helpSubtitle.Position = UDim2.new(0, 31, 0, 33)
helpSubtitle.BackgroundTransparency = 1
helpSubtitle.Text = "Quick guide"
helpSubtitle.TextColor3 = Color3.fromRGB(151, 162, 156)
helpSubtitle.TextSize = 11
helpSubtitle.Font = Enum.Font.Gotham
helpSubtitle.TextXAlignment = Enum.TextXAlignment.Left
helpSubtitle.ZIndex = 54
helpSubtitle.Parent = helpFrame

local helpClose = Instance.new("TextButton")
helpClose.Name = "Close"
helpClose.Size = UDim2.new(0, 34, 0, 34)
helpClose.Position = UDim2.new(1, -47, 0, 14)
helpClose.BackgroundColor3 = Color3.fromRGB(48, 54, 51)
helpClose.BorderSizePixel = 0
helpClose.Text = "×"
helpClose.TextColor3 = Color3.fromRGB(194, 202, 198)
helpClose.TextSize = 21
helpClose.Font = Enum.Font.Gotham
helpClose.AutoButtonColor = false
helpClose.Active = true
helpClose.Selectable = true
helpClose.ZIndex = 60
helpClose.Parent = helpFrame

local helpCloseCorner = Instance.new("UICorner")
helpCloseCorner.CornerRadius = UDim.new(0, 9)
helpCloseCorner.Parent = helpClose

local helpContent = Instance.new("ScrollingFrame")
helpContent.Name = "HelpContent"
helpContent.Size = UDim2.new(1, -32, 1, -78)
helpContent.Position = UDim2.new(0, 16, 0, 70)
helpContent.BackgroundColor3 = Color3.fromRGB(37, 43, 40)
helpContent.BorderSizePixel = 0
helpContent.ScrollBarThickness = 5
helpContent.ScrollBarImageColor3 = Color3.fromRGB(91, 108, 99)
helpContent.ScrollBarImageTransparency = 0.15
helpContent.CanvasSize = UDim2.new(0, 0, 0, 0)
helpContent.ZIndex = 53
helpContent.Parent = helpFrame

local helpContentCorner = Instance.new("UICorner")
helpContentCorner.CornerRadius = UDim.new(0, 9)
helpContentCorner.Parent = helpContent

local helpText = Instance.new("TextLabel")
helpText.Name = "HelpText"
helpText.Size = UDim2.new(1, -20, 0, 210)
helpText.Position = UDim2.new(0, 10, 0, 10)
helpText.BackgroundTransparency = 1
helpText.Text = "Welcome to the Fleecing Tool.\n\nSTART FLEECING\nEnables or disables the main system.\n\nLOOP TRADES\nWhen both Fleecing + Loop Trades are on: trades newest user first, then continuously cycles oldest → newest. State is saved.\n\nMARK FLEECE BUTTON\nMarks a user so they are skipped by auto-trade and loop. Marked users are grayed out and TRADE is hidden. Saved permanently until unmarked.\n\nSETTINGS (⚙)\nAppears when you have marked users. Lets you unmark them.\n\nCLEAR DATA\nRemoves currently displayed users (does not unmark them).\n\nMAIN / LOGS\nSwitch between tracked users and event logs."
helpText.TextColor3 = Color3.fromRGB(205, 216, 209)
helpText.TextSize = 11
helpText.Font = Enum.Font.Gotham
helpText.TextXAlignment = Enum.TextXAlignment.Left
helpText.TextYAlignment = Enum.TextYAlignment.Top
helpText.TextWrapped = true
helpText.ZIndex = 54
helpText.Parent = helpContent

helpContent.CanvasSize = UDim2.new(0, 0, 0, 230)

-------------------------------------------------
-- SETTINGS FRAME
-------------------------------------------------
local settingsShadow = Instance.new("Frame")
settingsShadow.Name = "SettingsShadow"
settingsShadow.Size = UDim2.new(0, 416, 0, 316)
settingsShadow.Position = UDim2.new(0.5, -208, 0.5, -158)
settingsShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
settingsShadow.BackgroundTransparency = 0.65
settingsShadow.BorderSizePixel = 0
settingsShadow.Visible = false
settingsShadow.ZIndex = 50
settingsShadow.Parent = gui

local settingsShadowCorner = Instance.new("UICorner")
settingsShadowCorner.CornerRadius = UDim.new(0, 16)
settingsShadowCorner.Parent = settingsShadow

local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "SettingsFrame"
settingsFrame.Size = UDim2.new(0, 400, 0, 300)
settingsFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
settingsFrame.BackgroundColor3 = Color3.fromRGB(30, 34, 32)
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
settingsFrame.ZIndex = 51
settingsFrame.Parent = gui

local settingsFrameCorner = Instance.new("UICorner")
settingsFrameCorner.CornerRadius = UDim.new(0, 14)
settingsFrameCorner.Parent = settingsFrame

local settingsFrameStroke = Instance.new("UIStroke")
settingsFrameStroke.Color = Color3.fromRGB(86, 101, 93)
settingsFrameStroke.Thickness = 1
settingsFrameStroke.Transparency = 0.15
settingsFrameStroke.Parent = settingsFrame

local settingsTopBar = Instance.new("Frame")
settingsTopBar.Name = "TitleBar"
settingsTopBar.Size = UDim2.new(1, 0, 0, 62)
settingsTopBar.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
settingsTopBar.BorderSizePixel = 0
settingsTopBar.ZIndex = 52
settingsTopBar.Parent = settingsFrame

local settingsTopCorner = Instance.new("UICorner")
settingsTopCorner.CornerRadius = UDim.new(0, 14)
settingsTopCorner.Parent = settingsTopBar

local settingsTopBottom = Instance.new("Frame")
settingsTopBottom.Size = UDim2.new(1, 0, 0, 16)
settingsTopBottom.Position = UDim2.new(0, 0, 1, -16)
settingsTopBottom.BackgroundColor3 = Color3.fromRGB(35, 40, 38)
settingsTopBottom.BorderSizePixel = 0
settingsTopBottom.ZIndex = 52
settingsTopBottom.Parent = settingsTopBar

local settingsAccent = Instance.new("Frame")
settingsAccent.Size = UDim2.new(0, 4, 0, 28)
settingsAccent.Position = UDim2.new(0, 18, 0, 17)
settingsAccent.BackgroundColor3 = Color3.fromRGB(119, 183, 145)
settingsAccent.BorderSizePixel = 0
settingsAccent.ZIndex = 54
settingsAccent.Parent = settingsFrame

local settingsAccentCorner = Instance.new("UICorner")
settingsAccentCorner.CornerRadius = UDim.new(0, 3)
settingsAccentCorner.Parent = settingsAccent

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, -100, 0, 24)
settingsTitle.Position = UDim2.new(0, 31, 0, 11)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Marked Users"
settingsTitle.TextColor3 = Color3.fromRGB(240, 244, 242)
settingsTitle.TextSize = 17
settingsTitle.Font = Enum.Font.GothamMedium
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.ZIndex = 54
settingsTitle.Parent = settingsFrame

local settingsSubtitle = Instance.new("TextLabel")
settingsSubtitle.Size = UDim2.new(1, -100, 0, 18)
settingsSubtitle.Position = UDim2.new(0, 31, 0, 33)
settingsSubtitle.BackgroundTransparency = 1
settingsSubtitle.Text = "Unmark to restore TRADE button"
settingsSubtitle.TextColor3 = Color3.fromRGB(151, 162, 156)
settingsSubtitle.TextSize = 11
settingsSubtitle.Font = Enum.Font.Gotham
settingsSubtitle.TextXAlignment = Enum.TextXAlignment.Left
settingsSubtitle.ZIndex = 54
settingsSubtitle.Parent = settingsFrame

local settingsClose = Instance.new("TextButton")
settingsClose.Name = "Close"
settingsClose.Size = UDim2.new(0, 34, 0, 34)
settingsClose.Position = UDim2.new(1, -47, 0, 14)
settingsClose.BackgroundColor3 = Color3.fromRGB(48, 54, 51)
settingsClose.BorderSizePixel = 0
settingsClose.Text = "×"
settingsClose.TextColor3 = Color3.fromRGB(194, 202, 198)
settingsClose.TextSize = 21
settingsClose.Font = Enum.Font.Gotham
settingsClose.AutoButtonColor = false
settingsClose.Active = true
settingsClose.Selectable = true
settingsClose.ZIndex = 60
settingsClose.Parent = settingsFrame

local settingsCloseCorner = Instance.new("UICorner")
settingsCloseCorner.CornerRadius = UDim.new(0, 9)
settingsCloseCorner.Parent = settingsClose

local settingsContent = Instance.new("ScrollingFrame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, -32, 1, -78)
settingsContent.Position = UDim2.new(0, 16, 0, 70)
settingsContent.BackgroundColor3 = Color3.fromRGB(37, 43, 40)
settingsContent.BorderSizePixel = 0
settingsContent.ScrollBarThickness = 5
settingsContent.ScrollBarImageColor3 = Color3.fromRGB(91, 108, 99)
settingsContent.ScrollBarImageTransparency = 0.15
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsContent.ZIndex = 53
settingsContent.Parent = settingsFrame

local settingsContentCorner = Instance.new("UICorner")
settingsContentCorner.CornerRadius = UDim.new(0, 9)
settingsContentCorner.Parent = settingsContent

local settingsEmpty = Instance.new("TextLabel")
settingsEmpty.Name = "Empty"
settingsEmpty.Size = UDim2.new(1, -20, 0, 24)
settingsEmpty.Position = UDim2.new(0, 10, 0.5, -12)
settingsEmpty.BackgroundTransparency = 1
settingsEmpty.Text = "No marked users"
settingsEmpty.TextColor3 = Color3.fromRGB(145, 155, 150)
settingsEmpty.TextSize = 11
settingsEmpty.Font = Enum.Font.Gotham
settingsEmpty.TextXAlignment = Enum.TextXAlignment.Center
settingsEmpty.ZIndex = 54
settingsEmpty.Parent = settingsContent

-------------------------------------------------
-- HELPER FUNCTIONS
-------------------------------------------------
local function updateToggle()
    if fleecingEnabled then
        toggle.Text = "STOP FLEECING"
        toggle.BackgroundColor3 = Color3.fromRGB(76, 122, 94)
        status.Text = "Fleecing Enabled"
        status.TextColor3 = Color3.fromRGB(132, 205, 158)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(116, 190, 142)
        statusDescription.Text = "Waiting for trade data"
        statusDescription.TextColor3 = Color3.fromRGB(122, 180, 140)
    else
        toggle.Text = "START FLEECING"
        toggle.BackgroundColor3 = Color3.fromRGB(61, 72, 66)
        status.Text = "Fleecing Disabled"
        status.TextColor3 = Color3.fromRGB(218, 224, 221)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(116, 126, 121)
        statusDescription.Text = "Ready"
        statusDescription.TextColor3 = Color3.fromRGB(145, 155, 150)
    end
end

local function updateLoopTrades()
    if loopTradesEnabled then
        loopTrades.Text = "LOOP TRADES: ON"
        if fleecingEnabled then
            loopTrades.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
            loopTrades.TextColor3 = Color3.fromRGB(231, 242, 235)
        else
            loopTrades.BackgroundColor3 = Color3.fromRGB(55, 63, 59)
            loopTrades.TextColor3 = Color3.fromRGB(145, 155, 150)
        end
    else
        loopTrades.Text = "LOOP TRADES"
        loopTrades.BackgroundColor3 = Color3.fromRGB(43, 49, 46)
        loopTrades.TextColor3 = Color3.fromRGB(207, 215, 211)
    end
end

local function updateSection()
    if currentSection == "Main" then
        mainContent.Visible = true
        logsContent.Visible = false
        mainButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
        mainButton.TextColor3 = Color3.fromRGB(231, 242, 235)
        logsButton.BackgroundColor3 = Color3.fromRGB(43, 49, 46)
        logsButton.TextColor3 = Color3.fromRGB(207, 215, 211)
    else
        mainContent.Visible = false
        logsContent.Visible = true
        mainButton.BackgroundColor3 = Color3.fromRGB(43, 49, 46)
        mainButton.TextColor3 = Color3.fromRGB(207, 215, 211)
        logsButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
        logsButton.TextColor3 = Color3.fromRGB(231, 242, 235)
    end
end

local function updateUserPositions()
    if destroyed or not mainContent.Parent then return end

    local entries = {}
    for _, child in ipairs(mainContent:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1, 5) == "User_" then
            table.insert(entries, child)
        end
    end

    table.sort(entries, function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)

    local entryHeight = 60
    local topPadding = 5

    for index, entry in ipairs(entries) do
        entry.Position = UDim2.new(0, 8, 0, topPadding + ((index - 1) * entryHeight))
    end

    local totalHeight = topPadding + (#entries * entryHeight) + 5
    mainContent.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, mainContent.AbsoluteSize.Y))

    task.defer(function()
        if destroyed or not mainContent.Parent then return end
        local maximumCanvasPosition = math.max(0, mainContent.AbsoluteCanvasSize.Y - mainContent.AbsoluteSize.Y)
        mainContent.CanvasPosition = Vector2.new(0, maximumCanvasPosition)
    end)
end

local function updateLogPositions()
    if destroyed or not logsContent.Parent then return end

    local logs = {}
    for _, child in ipairs(logsContent:GetChildren()) do
        if child:IsA("TextLabel") and child ~= logsEmpty then
            table.insert(logs, child)
        end
    end

    table.sort(logs, function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)

    for index, log in ipairs(logs) do
        log.Position = UDim2.new(0, 10, 0, (index - 1) * 18)
    end

    local totalHeight = (#logs * 18) + 5
    logsContent.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, logsContent.AbsoluteSize.Y))
end

local function createLog(text)
    if destroyed or type(text) ~= "string" then return end

    local log = Instance.new("TextLabel")
    log.Name = "Log_" .. tostring(os.clock())
    log.Size = UDim2.new(1, -20, 0, 18)
    log.Position = UDim2.new(0, 10, 0, 0)
    log.BackgroundTransparency = 1
    log.Text = os.date("%H:%M:%S") .. "  " .. text
    log.TextColor3 = Color3.fromRGB(180, 190, 184)
    log.TextSize = 9
    log.Font = Enum.Font.Gotham
    log.TextXAlignment = Enum.TextXAlignment.Left
    log.TextTruncate = Enum.TextTruncate.AtEnd
    log.ZIndex = 7
    log.LayoutOrder = #logsContent:GetChildren()
    log.Parent = logsContent

    logsEmpty.Visible = false
end

local function clearCurrentData()
    if destroyed then return end

    local users = {}
    for _, child in ipairs(mainContent:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1, 5) == "User_" then
            table.insert(users, child)
        end
    end

    for _, entry in ipairs(users) do
        entry:Destroy()
    end

    local logs = {}
    for _, child in ipairs(logsContent:GetChildren()) do
        if child:IsA("TextLabel") and child ~= logsEmpty then
            table.insert(logs, child)
        end
    end

    for _, log in ipairs(logs) do
        log:Destroy()
    end

    mainEmpty.Visible = true
    logsEmpty.Visible = true
    mainContent.CanvasPosition = Vector2.new(0, 0)
    mainContent.CanvasSize = UDim2.new(0, 0, 0, mainContent.AbsoluteSize.Y)
    logsContent.CanvasPosition = Vector2.new(0, 0)
    logsContent.CanvasSize = UDim2.new(0, 0, 0, logsContent.AbsoluteSize.Y)

    createLog("Current user data cleared")
    updateLogPositions()
    updateUserPositions()
end

local function loadImage(imageObject, imageUrl)
    if destroyed or not imageObject or not imageObject.Parent then return end
    if type(imageUrl) ~= "string" or imageUrl == "" then return end

    if imageUrl:match("^rbxassetid://") or imageUrl:match("^rbxthumb://") then
        imageObject.Image = imageUrl
        return
    end

    task.spawn(function()
        imageCounter += 1
        local id = imageCounter
        local extension = ".png"
        local lowerUrl = imageUrl:lower()

        if lowerUrl:find("%.jpg") or lowerUrl:find("%.jpeg") then
            extension = ".jpg"
        elseif lowerUrl:find("%.webp") then
            extension = ".webp"
        end

        local fileName = "FleecingImage_" .. tostring(id) .. extension

        local requestSuccess, body = pcall(function()
            return game:HttpGet(imageUrl)
        end)

        if destroyed or not imageObject.Parent then return end
        if not requestSuccess or type(body) ~= "string" or body == "" then return end
        if type(writefile) ~= "function" then return end

        local writeSuccess = pcall(function()
            writefile(fileName, body)
        end)
        if not writeSuccess then return end
        if destroyed or not imageObject.Parent then return end

        local assetFunction = (type(getcustomasset) == "function" and getcustomasset)
            or (type(getsynasset) == "function" and getsynasset)

        if not assetFunction then return end

        local assetSuccess, asset = pcall(function()
            return assetFunction(fileName)
        end)

        if destroyed or not imageObject.Parent then return end
        if assetSuccess and type(asset) == "string" and asset ~= "" then
            imageObject.Image = asset
        end
    end)
end

local function SendInvite(targetUsername)
    if not targetUsername or targetUsername == "" then
        return false, "Invalid username provided"
    end

    local LocalPlayer = game:GetService("Players").LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local PlayersSection = PlayerGui
        :WaitForChild("TradePlayerList")
        :WaitForChild("TradePlayerList")
        :WaitForChild("Sections")
        :WaitForChild("Players")

    local SearchBox = PlayersSection:WaitForChild("SearchFrame"):WaitForChild("SearchBox")

    SearchBox:CaptureFocus()
    SearchBox.Text = targetUsername
    task.wait(0.3)
    firesignal(SearchBox.FocusLost, true)

    local List = PlayersSection:WaitForChild("List")
    local targetButton = nil

    local timeout = 0
    while not targetButton and timeout < 50 do
        for _, child in ipairs(List:GetChildren()) do
            if child.Name:lower():match("^" .. targetUsername:lower() .. "_") then
                targetButton = child
                break
            end
        end
        if not targetButton then
            task.wait(0.2)
            timeout += 1
        end
    end

    if not targetButton then
        return false
    end

    local sendButton = targetButton:WaitForChild("Fill"):WaitForChild("Send")
    task.wait(0.3)

    local fired = false

    for _, signal in pairs({"Activated", "MouseButton1Click", "MouseButton1Down"}) do
        if fired then break end
        local success, connections = pcall(function() return getconnections(sendButton[signal]) end)
        if success and #connections > 0 then
            connections[1]:Fire()
            fired = true
        end
    end

    if not fired then
        for _, signal in pairs({"Activated", "MouseButton1Click"}) do
            if fired then break end
            local fill = sendButton.Parent
            local success, connections = pcall(function() return getconnections(fill[signal]) end)
            if success and #connections > 0 then
                connections[1]:Fire()
                fired = true
            end
        end
    end

    return fired
end

local function isMarked(username)
    return markedUsers[username] == true
end

local function applyMarkedStyle(entry, marked)
    if not entry or not entry.Parent then return end

    local tradeButton = entry:FindFirstChild("TradeButton")
    local mfButton = entry:FindFirstChild("MFButton")

    if marked then
        entry.BackgroundColor3 = Color3.fromRGB(32, 36, 34)
        if tradeButton then
            tradeButton.Visible = false
        end
        if mfButton then
            mfButton.Text = "Unmark"
            mfButton.BackgroundColor3 = Color3.fromRGB(90, 55, 55)
        end
    else
        entry.BackgroundColor3 = Color3.fromRGB(43, 50, 46)
        if tradeButton then
            tradeButton.Visible = true
            tradeButton.Text = "TRADE"
            tradeButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
            tradeButton.Active = true
        end
        if mfButton then
            mfButton.Text = "Mark fleece"
            mfButton.BackgroundColor3 = Color3.fromRGB(70, 80, 75)
        end
    end
end

local function updateSettingsButtonVisibility()
    local count = 0
    for _ in pairs(markedUsers) do
        count += 1
    end
    settingsBtn.Visible = count > 0
end

local function refreshSettingsList()
    for _, child in ipairs(settingsContent:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1, 7) == "Marked_" then
            child:Destroy()
        end
    end

    local list = {}
    for name, _ in pairs(markedUsers) do
        table.insert(list, name)
    end
    table.sort(list)

    if #list == 0 then
        settingsEmpty.Visible = true
        settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsContent.AbsoluteSize.Y)
        return
    end

    settingsEmpty.Visible = false

    for i, username in ipairs(list) do
        local row = Instance.new("Frame")
        row.Name = "Marked_" .. username
        row.Size = UDim2.new(1, -16, 0, 36)
        row.Position = UDim2.new(0, 8, 0, 8 + (i - 1) * 42)
        row.BackgroundColor3 = Color3.fromRGB(43, 50, 46)
        row.BorderSizePixel = 0
        row.ZIndex = 54
        row.Parent = settingsContent

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -90, 1, 0)
        nameLabel.Position = UDim2.new(0, 12, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = username
        nameLabel.TextColor3 = Color3.fromRGB(214, 225, 218)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 55
        nameLabel.Parent = row

        local unmarkBtn = Instance.new("TextButton")
        unmarkBtn.Name = "Unmark"
        unmarkBtn.Size = UDim2.new(0, 70, 0, 26)
        unmarkBtn.Position = UDim2.new(1, -78, 0.5, -13)
        unmarkBtn.BackgroundColor3 = Color3.fromRGB(90, 55, 55)
        unmarkBtn.BorderSizePixel = 0
        unmarkBtn.Text = "UNMARK"
        unmarkBtn.TextColor3 = Color3.fromRGB(231, 242, 235)
        unmarkBtn.TextSize = 10
        unmarkBtn.Font = Enum.Font.GothamMedium
        unmarkBtn.AutoButtonColor = false
        unmarkBtn.ZIndex = 55
        unmarkBtn.Parent = row

        local unmarkCorner = Instance.new("UICorner")
        unmarkCorner.CornerRadius = UDim.new(0, 5)
        unmarkCorner.Parent = unmarkBtn

        unmarkBtn.MouseButton1Click:Connect(function()
            if destroyed then return end
            markedUsers[username] = nil
            saveConfig()
            updateSettingsButtonVisibility()

            local liveEntry = mainContent:FindFirstChild("User_" .. username)
            if liveEntry then
                applyMarkedStyle(liveEntry, false)
            end

            refreshSettingsList()
            createLog("Unmarked: " .. username)
            updateLogPositions()
        end)
    end

    settingsContent.CanvasSize = UDim2.new(0, 0, 0, 8 + #list * 42 + 8)
end

local function performTrade(username, tradeButton)
    if isTrading or destroyed then return end
    if isMarked(username) then return end
    if not tradeButton or not tradeButton.Parent then return end

    isTrading = true
    tradeButton.Active = false
    tradeButton.Text = "SENDING..."
    tradeButton.BackgroundColor3 = Color3.fromRGB(50, 75, 60)

    task.spawn(function()
        local success = SendInvite(username)

        if not destroyed and tradeButton.Parent then
            if success then
                tradeButton.Text = "SENT!"
                tradeButton.BackgroundColor3 = Color3.fromRGB(46, 117, 74)
            else
                tradeButton.Text = "FAILED"
                tradeButton.BackgroundColor3 = Color3.fromRGB(138, 48, 48)
            end

            task.wait(2)

            if not destroyed and tradeButton.Parent and not isMarked(username) then
                tradeButton.Active = true
                tradeButton.Text = "TRADE"
                tradeButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
            end
        end

        isTrading = false
    end)
end

local function createUserEntry(username)
    if destroyed or type(username) ~= "string" or username == "" then return end

    local existing = mainContent:FindFirstChild("User_" .. username)
    if existing then return existing end

    local entry = Instance.new("Frame")
    entry.Name = "User_" .. username
    entry.Size = UDim2.new(1, -18, 0, 54)
    entry.Position = UDim2.new(0, 8, 0, 0)
    entry.BackgroundColor3 = Color3.fromRGB(43, 50, 46)
    entry.BorderSizePixel = 0
    entry.ZIndex = 7
    entry.LayoutOrder = #mainContent:GetChildren()
    entry.Parent = mainContent

    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 7)
    entryCorner.Parent = entry

    local profileImage = Instance.new("ImageLabel")
    profileImage.Name = "ProfilePicture"
    profileImage.Size = UDim2.new(0, 36, 0, 36)
    profileImage.Position = UDim2.new(0, 7, 0, 9)
    profileImage.BackgroundColor3 = Color3.fromRGB(48, 55, 51)
    profileImage.BorderSizePixel = 0
    profileImage.Image = ""
    profileImage.ZIndex = 8
    profileImage.Parent = entry

    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(1, 0)
    imageCorner.Parent = profileImage

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "Username"
    usernameLabel.Size = UDim2.new(1, -200, 0, 18)
    usernameLabel.Position = UDim2.new(0, 51, 0, 5)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = username
    usernameLabel.TextColor3 = Color3.fromRGB(214, 225, 218)
    usernameLabel.TextSize = 10
    usernameLabel.Font = Enum.Font.GothamMedium
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.TextYAlignment = Enum.TextYAlignment.Center
    usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    usernameLabel.ZIndex = 8
    usernameLabel.Parent = entry

    local brainrotImage = Instance.new("ImageLabel")
    brainrotImage.Name = "BrainrotImage"
    brainrotImage.Size = UDim2.new(0, 30, 0, 30)
    brainrotImage.Position = UDim2.new(0, 51, 0, 24)
    brainrotImage.BackgroundColor3 = Color3.fromRGB(48, 55, 51)
    brainrotImage.BorderSizePixel = 0
    brainrotImage.Image = ""
    brainrotImage.ZIndex = 8
    brainrotImage.Parent = entry

    local brainrotCorner = Instance.new("UICorner")
    brainrotCorner.CornerRadius = UDim.new(0, 6)
    brainrotCorner.Parent = brainrotImage

    local brainrotLabel = Instance.new("TextLabel")
    brainrotLabel.Name = "Brainrot"
    brainrotLabel.Size = UDim2.new(1, -200, 0, 30)
    brainrotLabel.Position = UDim2.new(0, 88, 0, 24)
    brainrotLabel.BackgroundTransparency = 1
    brainrotLabel.Text = "No brainrot detected"
    brainrotLabel.TextColor3 = Color3.fromRGB(170, 181, 175)
    brainrotLabel.TextSize = 9
    brainrotLabel.Font = Enum.Font.Gotham
    brainrotLabel.TextXAlignment = Enum.TextXAlignment.Left
    brainrotLabel.TextYAlignment = Enum.TextYAlignment.Center
    brainrotLabel.TextTruncate = Enum.TextTruncate.AtEnd
    brainrotLabel.ZIndex = 8
    brainrotLabel.Parent = entry

    local tradeButton = Instance.new("TextButton")
    tradeButton.Name = "TradeButton"
    tradeButton.Size = UDim2.new(0, 52, 0, 24)
    tradeButton.Position = UDim2.new(1, -145, 0.5, -12)
    tradeButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
    tradeButton.BorderSizePixel = 0
    tradeButton.Text = "TRADE"
    tradeButton.TextColor3 = Color3.fromRGB(231, 242, 235)
    tradeButton.TextSize = 9
    tradeButton.Font = Enum.Font.GothamMedium
    tradeButton.AutoButtonColor = false
    tradeButton.Active = true
    tradeButton.Selectable = true
    tradeButton.ZIndex = 10
    tradeButton.Parent = entry

    local tradeCorner = Instance.new("UICorner")
    tradeCorner.CornerRadius = UDim.new(0, 6)
    tradeCorner.Parent = tradeButton

    local mfButton = Instance.new("TextButton")
    mfButton.Name = "MFButton"
    mfButton.Size = UDim2.new(0, 85, 0, 24)
    mfButton.Position = UDim2.new(1, -90, 0.5, -12)
    mfButton.BackgroundColor3 = Color3.fromRGB(70, 80, 75)
    mfButton.BorderSizePixel = 0
    mfButton.Text = "Mark fleece"
    mfButton.TextColor3 = Color3.fromRGB(231, 242, 235)
    mfButton.TextSize = 9
    mfButton.Font = Enum.Font.GothamMedium
    mfButton.AutoButtonColor = false
    mfButton.Active = true
    mfButton.Selectable = true
    mfButton.ZIndex = 10
    mfButton.Parent = entry

    local mfCorner = Instance.new("UICorner")
    mfCorner.CornerRadius = UDim.new(0, 6)
    mfCorner.Parent = mfButton

    tradeButton.MouseEnter:Connect(function()
        if not destroyed and tradeButton.Text == "TRADE" and tradeButton.Visible then
            tradeButton.BackgroundColor3 = Color3.fromRGB(82, 126, 98)
        end
    end)

    tradeButton.MouseLeave:Connect(function()
        if not destroyed and tradeButton.Text == "TRADE" and tradeButton.Visible then
            tradeButton.BackgroundColor3 = Color3.fromRGB(67, 105, 82)
        end
    end)

    tradeButton.MouseButton1Click:Connect(function()
        if destroyed then return end
        performTrade(username, tradeButton)
    end)

    mfButton.MouseButton1Click:Connect(function()
        if destroyed then return end

        if isMarked(username) then
            markedUsers[username] = nil
            applyMarkedStyle(entry, false)
            createLog("Unmarked: " .. username)
        else
            markedUsers[username] = true
            applyMarkedStyle(entry, true)
            createLog("Marked (Mark fleece): " .. username)
        end

        saveConfig()
        updateSettingsButtonVisibility()
        updateLogPositions()
    end)

    if isMarked(username) then
        applyMarkedStyle(entry, true)
    end

    task.spawn(function()
        local userIdSuccess, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(username)
        end)

        if destroyed or not entry.Parent then return end
        if not userIdSuccess or type(userId) ~= "number" then return end

        local thumbnailSuccess, contentUrl = pcall(function()
            return Players:GetUserThumbnailAsync(
                userId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size48x48
            )
        end)

        if destroyed or not entry.Parent then return end
        if thumbnailSuccess and type(contentUrl) == "string" then
            profileImage.Image = contentUrl
        end
    end)

    return entry
end

local function setBrainrot(username, brainrot, imageUrl, ogType)
    if destroyed then return end
    if type(username) ~= "string" or username == "" then return end
    if type(brainrot) ~= "string" or brainrot == "" then return end

    local entry = createUserEntry(username)
    if not entry then return end

    local brainrotImage = entry:FindFirstChild("BrainrotImage")
    local brainrotLabel = entry:FindFirstChild("Brainrot")

    if brainrotImage and brainrotImage:IsA("ImageLabel") then
        if type(imageUrl) == "string" and imageUrl ~= "" then
            loadImage(brainrotImage, imageUrl)
        end
    end

    if brainrotLabel and brainrotLabel:IsA("TextLabel") then
        if type(ogType) == "string" and ogType ~= "" then
            brainrotLabel.Text = brainrot .. "  [" .. ogType .. "]"
        else
            brainrotLabel.Text = brainrot
        end
        brainrotLabel.TextColor3 = Color3.fromRGB(214, 225, 218)
    end

    mainEmpty.Visible = false
    updateUserPositions()
end

local function removeBrainrot(username)
    if destroyed then return end
    if type(username) ~= "string" or username == "" then return end

    local entry = mainContent:FindFirstChild("User_" .. username)
    if not entry then return end

    local brainrotImage = entry:FindFirstChild("BrainrotImage")
    local brainrotLabel = entry:FindFirstChild("Brainrot")

    if brainrotImage and brainrotImage:IsA("ImageLabel") then
        brainrotImage.Image = ""
    end

    if brainrotLabel and brainrotLabel:IsA("TextLabel") then
        brainrotLabel.Text = "No brainrot detected"
        brainrotLabel.TextColor3 = Color3.fromRGB(170, 181, 175)
    end
end

local function setMinimized(state)
    minimized = state

    if minimized then
        frame.Size = UDim2.new(0, 428, 0, 62)
        shadow.Size = UDim2.new(0, 444, 0, 78)
        statusCard.Visible = false
        sidePanel.Visible = false
        toggle.Visible = false
        loopTrades.Visible = false
        sectionLabel.Visible = false
        mainButton.Visible = false
        logsButton.Visible = false
        content.Visible = false
        minimize.Text = "+"
    else
        frame.Size = UDim2.new(0, 428, 0, 348)
        shadow.Size = UDim2.new(0, 444, 0, 364)
        statusCard.Visible = true
        sidePanel.Visible = true
        toggle.Visible = true
        loopTrades.Visible = true
        sectionLabel.Visible = true
        mainButton.Visible = true
        logsButton.Visible = true
        content.Visible = true
        minimize.Text = "−"
    end
end

local function isInside(guiObject, position)
    if not guiObject or not guiObject.Parent or not guiObject.Visible then return false end
    local absolutePosition = guiObject.AbsolutePosition
    local absoluteSize = guiObject.AbsoluteSize
    return position.X >= absolutePosition.X
        and position.X <= absolutePosition.X + absoluteSize.X
        and position.Y >= absolutePosition.Y
        and position.Y <= absolutePosition.Y + absoluteSize.Y
end

local function beginDrag(input)
    if destroyed then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    dragging = true
    dragStart = input.Position
    startPosition = frame.Position
end

local function endDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end

local function destroyGUI()
    if destroyed then return end
    destroyed = true
    acceptingData = false
    dragging = false
    loopTradesEnabled = false
    fleecingEnabled = false

    -- bump session so any late packets are ignored
    env.FleecingGUISession = (env.FleecingGUISession or 0) + 1

    -- Same as CLEAR: wipe users + logs before destroying
    pcall(function()
        for _, child in ipairs(mainContent:GetChildren()) do
            if child:IsA("Frame") and child.Name:sub(1, 5) == "User_" then
                child:Destroy()
            end
        end
        for _, child in ipairs(logsContent:GetChildren()) do
            if child:IsA("TextLabel") and child ~= logsEmpty then
                child:Destroy()
            end
        end
    end)

    env.FleecingStopRequested = true
    env.FleecingLogicStopRequested = true
    env.FleecingLoopTrades = false

    if type(env.FleecingLogicStop) == "function" then
        pcall(env.FleecingLogicStop)
    end

    env.FleecingGUIBridge = nil
    env.FleecingClearData = nil

    if gui and gui.Parent then
        gui:Destroy()
    end
end

local function startLoopTrades()
    if loopRunning then return end
    loopRunning = true

    task.spawn(function()
        while loopTradesEnabled and fleecingEnabled and not destroyed do
            local entries = {}
            for _, child in ipairs(mainContent:GetChildren()) do
                if child:IsA("Frame") and child.Name:sub(1, 5) == "User_" then
                    local uname = child.Name:sub(6)
                    if not isMarked(uname) then
                        table.insert(entries, child)
                    end
                end
            end

            table.sort(entries, function(a, b)
                return a.LayoutOrder < b.LayoutOrder
            end)

            for _, entry in ipairs(entries) do
                if not (loopTradesEnabled and fleecingEnabled) or destroyed then break end

                local username = entry.Name:sub(6)
                if isMarked(username) then continue end

                local tradeButton = entry:FindFirstChild("TradeButton")
                if tradeButton and tradeButton.Visible then
                    performTrade(username, tradeButton)
                    while isTrading and not destroyed do
                        task.wait(0.1)
                    end
                    task.wait(0.8)
                end
            end

            task.wait(1.5)
        end

        loopRunning = false
    end)
end

-------------------------------------------------
-- INPUT / BUTTONS
-------------------------------------------------
topBar.InputBegan:Connect(function(input)
    if destroyed then return end
    if isInside(exit, input.Position)
        or isInside(minimize, input.Position)
        or isInside(settingsBtn, input.Position) then
        return
    end
    beginDrag(input)
end)

frame.InputBegan:Connect(function(input)
    if destroyed then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end

    if isInside(exit, input.Position)
        or isInside(minimize, input.Position)
        or isInside(settingsBtn, input.Position)
        or isInside(toggle, input.Position)
        or isInside(loopTrades, input.Position)
        or isInside(mainButton, input.Position)
        or isInside(logsButton, input.Position)
        or isInside(clearButton, input.Position)
        or isInside(helpButton, input.Position)
        or isInside(content, input.Position) then
        return
    end
    beginDrag(input)
end)

UserInputService.InputEnded:Connect(endDrag)

UserInputService.InputChanged:Connect(function(input)
    if destroyed then return end
    if dragging then
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
        shadow.Position = UDim2.new(
            frame.Position.X.Scale,
            frame.Position.X.Offset - 8,
            frame.Position.Y.Scale,
            frame.Position.Y.Offset + 8
        )
    end
end)

exit.MouseButton1Click:Connect(function()
    destroyGUI()
end)

toggle.MouseButton1Click:Connect(function()
    if destroyed then return end

    fleecingEnabled = not fleecingEnabled
    updateToggle()
    updateLoopTrades()

    if fleecingEnabled and loopTradesEnabled then
        startLoopTrades()
    end
end)

loopTrades.MouseButton1Click:Connect(function()
    if destroyed then return end
    if not fleecingEnabled then return end

    loopTradesEnabled = not loopTradesEnabled
    updateLoopTrades()
    saveConfig()

    if loopTradesEnabled then
        createLog("Trade loop enabled")
        startLoopTrades()
    else
        createLog("Trade loop disabled")
    end
    updateLogPositions()
end)

mainButton.MouseButton1Click:Connect(function()
    if destroyed then return end
    currentSection = "Main"
    updateSection()
end)

logsButton.MouseButton1Click:Connect(function()
    if destroyed then return end
    currentSection = "Logs"
    updateSection()
end)

minimize.MouseButton1Click:Connect(function()
    if destroyed then return end
    setMinimized(not minimized)
end)

clearButton.MouseButton1Click:Connect(function()
    clearCurrentData()
end)

helpButton.MouseButton1Click:Connect(function()
    if destroyed then return end

    if settingsOpen then
        settingsOpen = false
        settingsShadow.Visible = false
        settingsFrame.Visible = false
    end

    helpOpen = true
    helpFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    helpShadow.Position = UDim2.new(0.5, -208, 0.5, -158)
    helpShadow.Visible = true
    helpFrame.Visible = true
end)

helpClose.MouseButton1Click:Connect(function()
    if destroyed then return end
    helpOpen = false
    helpShadow.Visible = false
    helpFrame.Visible = false
end)

settingsBtn.MouseButton1Click:Connect(function()
    if destroyed then return end

    if helpOpen then
        helpOpen = false
        helpShadow.Visible = false
        helpFrame.Visible = false
    end

    settingsOpen = true
    refreshSettingsList()
    settingsFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    settingsShadow.Position = UDim2.new(0.5, -208, 0.5, -158)
    settingsShadow.Visible = true
    settingsFrame.Visible = true
end)

settingsClose.MouseButton1Click:Connect(function()
    if destroyed then return end
    settingsOpen = false
    settingsShadow.Visible = false
    settingsFrame.Visible = false
end)

-------------------------------------------------
-- BRIDGE
-------------------------------------------------
env.FleecingGUIBridge = {
    Ready = true,
    Session = myGuiSession,

    Receive = function(data)
        if destroyed then return end
        if not acceptingData then return end
        if env.FleecingGUISession ~= myGuiSession then return end
        if type(data) ~= "table" then return end

        if data.type == "connection" then
            if data.connected then
                status.Text = "Feed Connected"
                status.TextColor3 = Color3.fromRGB(132, 205, 158)
                statusIndicator.BackgroundColor3 = Color3.fromRGB(116, 190, 142)
                statusDescription.Text = "Receiving Discord data"
                statusDescription.TextColor3 = Color3.fromRGB(122, 180, 140)
            else
                status.Text = "Feed Disconnected"
                status.TextColor3 = Color3.fromRGB(218, 224, 221)
                statusIndicator.BackgroundColor3 = Color3.fromRGB(116, 126, 121)
                statusDescription.Text = "Waiting for C# bridge"
                statusDescription.TextColor3 = Color3.fromRGB(145, 155, 150)
            end
            return
        end

        if data.type == "user_online" then
            if type(data.username) ~= "string" or data.username == "" then return end

            local alreadyHad = mainContent:FindFirstChild("User_" .. data.username) ~= nil

            mainEmpty.Visible = false
            local entry = createUserEntry(data.username)
            updateUserPositions()

            if fleecingEnabled and entry and not isMarked(data.username) then
                local tradeButton = entry:FindFirstChild("TradeButton")
                if tradeButton and tradeButton.Visible then
                    performTrade(data.username, tradeButton)
                end
            end

            if not alreadyHad then
                createLog("Online: " .. data.username)
                updateLogPositions()
            end
            return
        end

        if data.type == "user_offline" then
            if type(data.username) ~= "string" or data.username == "" then return end

            local entry = mainContent:FindFirstChild("User_" .. data.username)
            if entry then
                entry:Destroy()
            end

            local hasUsers = false
            for _, child in ipairs(mainContent:GetChildren()) do
                if child:IsA("Frame") and child.Name:sub(1, 5) == "User_" then
                    hasUsers = true
                    break
                end
            end

            mainEmpty.Visible = not hasUsers
            updateUserPositions()
            createLog("Offline: " .. data.username)
            updateLogPositions()
            return
        end

        if data.type == "brainrot" then
            setBrainrot(data.username, data.brainrot, data.imageUrl, data.ogType)
            createLog("Brainrot: " .. tostring(data.username) .. " -> " .. tostring(data.brainrot) .. " [" .. tostring(data.ogType) .. "]")
            updateLogPositions()
            return
        end

        if data.type == "brainrot_removed" then
            removeBrainrot(data.username)
            createLog("Brainrot removed: " .. tostring(data.username) .. " -> " .. tostring(data.brainrot))
            updateLogPositions()
            return
        end

        if data.type == "log" then
            if type(data.message) ~= "string" then return end
            createLog(data.message)
            updateLogPositions()
        end
    end
}

env.FleecingClearData = clearCurrentData
env.FleecingLoopTrades = loopTradesEnabled
env.FleecingLogicStopRequested = false

updateToggle()
updateLoopTrades()
updateSection()
updateSettingsButtonVisibility()

-- Make sure any previous logic is fully dead before connecting again
env.FleecingLogicStopRequested = true
if type(env.FleecingLogicStop) == "function" then
    pcall(env.FleecingLogicStop)
end
task.wait(0.4)
env.FleecingLogicStopRequested = false

-- Now accept data for this session only
acceptingData = true

if not env.FleecingLogicRunning then
    task.spawn(function()
        local success, result = pcall(function()
            return loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/samisagithub/rscripts-upd/main/Automated%20fleecing%20logic.luau"
                )
            )()
        end)

        if not success then
            env.FleecingLogicRunning = false
            warn("Failed to load Automated fleecing logic:", result)
        end
    end)
end
