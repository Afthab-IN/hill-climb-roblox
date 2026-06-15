-- Keyboard respawn. Throttle and steering are handled automatically by the
-- VehicleSeat (W/S, arrow keys, and the on screen mobile control).

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local respawnEvent = remotes:WaitForChild("Respawn")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if input.KeyCode == Enum.KeyCode.R then
		respawnEvent:FireServer()
	end
end)
