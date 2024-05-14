local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage.Remotes.Tool
local playerTools = {}
local playerCooldowns = {}
local module = {}

local function addTool(player, toolName)
	playerTools[player][toolName] = true
	remotesFolder.AddTool:FireClient(player, toolName)
end

function module.hasTool(player, toolName)
	return if playerTools[player][toolName] then true else false
end

function module.onCooldown(player, eventName)
	return if playerCooldowns[player][eventName] then true else false
end

Players.PlayerAdded:Connect(coroutine.wrap(function(player)
	playerTools[player] = {}
	playerCooldowns[player] = {}

	--TEMP
	addTool(player, "Explosion")
	addTool(player, "Revolver")
	task.wait(0.5)
	remotesFolder.ForceEquip:FireClient(player, "Revolver")
	--TEMP
end))

return module
