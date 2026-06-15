-- Hill Climb HUD: distance, best distance, fuel bar, speed, and a mobile
-- friendly respawn button. Listens to the server's UpdateHUD event.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local updateHUD = remotes:WaitForChild("UpdateHUD")
local respawnEvent = remotes:WaitForChild("Respawn")

local best = 0

----------------------------------------------------------------------
-- Build the GUI
----------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "HillClimbHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function label(parent, size, pos, text, textSize, color)
	local l = Instance.new("TextLabel")
	l.Size = size
	l.Position = pos
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextScaled = false
	l.TextSize = textSize
	l.Font = Enum.Font.GothamBold
	l.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	l.TextStrokeTransparency = 0.4
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

-- distance panel (top left)
local distLabel = label(
	gui,
	UDim2.fromOffset(360, 44),
	UDim2.fromOffset(20, 16),
	"0 m",
	36
)

local bestLabel = label(
	gui,
	UDim2.fromOffset(360, 26),
	UDim2.fromOffset(20, 60),
	"Best: 0 m",
	20,
	Color3.fromRGB(255, 215, 0)
)

local speedLabel = label(
	gui,
	UDim2.fromOffset(360, 24),
	UDim2.fromOffset(20, 88),
	"Speed: 0",
	18,
	Color3.fromRGB(180, 220, 255)
)

-- fuel bar (top right)
local fuelBg = Instance.new("Frame")
fuelBg.Size = UDim2.fromOffset(240, 26)
fuelBg.Position = UDim2.new(1, -260, 0, 22)
fuelBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
fuelBg.BackgroundTransparency = 0.25
fuelBg.BorderSizePixel = 0
fuelBg.Parent = gui
local fuelCorner = Instance.new("UICorner")
fuelCorner.CornerRadius = UDim.new(0, 6)
fuelCorner.Parent = fuelBg

local fuelFill = Instance.new("Frame")
fuelFill.Size = UDim2.fromScale(1, 1)
fuelFill.BackgroundColor3 = Color3.fromRGB(70, 200, 90)
fuelFill.BorderSizePixel = 0
fuelFill.Parent = fuelBg
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 6)
fillCorner.Parent = fuelFill

local fuelText = label(
	fuelBg,
	UDim2.fromScale(1, 1),
	UDim2.fromScale(0, 0),
	"FUEL",
	16
)
fuelText.TextXAlignment = Enum.TextXAlignment.Center

-- hint (bottom center)
local hint = label(
	gui,
	UDim2.fromOffset(600, 24),
	UDim2.new(0.5, -300, 1, -40),
	"W / Up = gas    S / Down = reverse    R = respawn",
	18
)
hint.TextXAlignment = Enum.TextXAlignment.Center

-- respawn button (bottom right, handy on mobile)
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.fromOffset(150, 50)
respawnBtn.Position = UDim2.new(1, -170, 1, -70)
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
respawnBtn.Text = "RESPAWN (R)"
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextSize = 18
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.Parent = gui
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = respawnBtn
respawnBtn.Activated:Connect(function()
	respawnEvent:FireServer()
end)

----------------------------------------------------------------------
-- Update from server
----------------------------------------------------------------------
updateHUD.OnClientEvent:Connect(function(state)
	distLabel.Text = string.format("%d m", state.distance)
	if state.distance > best then
		best = state.distance
		bestLabel.Text = string.format("Best: %d m", best)
	end
	speedLabel.Text = string.format("Speed: %d", state.speed)

	local ratio = math.clamp(state.fuel / state.maxFuel, 0, 1)
	fuelFill.Size = UDim2.fromScale(ratio, 1)
	fuelText.Text = string.format("FUEL  %d", state.fuel)
	if ratio > 0.5 then
		fuelFill.BackgroundColor3 = Color3.fromRGB(70, 200, 90)
	elseif ratio > 0.2 then
		fuelFill.BackgroundColor3 = Color3.fromRGB(230, 190, 60)
	else
		fuelFill.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	end
end)
