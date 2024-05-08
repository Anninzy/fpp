local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage.Remotes.Tool
local module = {}
module.playerTools = {}
module.playerCooldowns = {}

local function addTool(player, toolName)
	module.playerTools[player][toolName] = true
	remotesFolder.AddTool:FireClient(player, toolName)
end

Players.PlayerAdded:Connect(function(player)
	module.playerTools[player] = {}
	module.playerCooldowns[player] = {}

	--TEMP
	addTool(player, "Explosion")
	addTool(player, "Revolver")
	task.wait(0.5)
	remotesFolder.ForceEquip:FireClient(player, "Revolver")
	--TEMP
end)

return module
