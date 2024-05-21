local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage.Remotes.Tool
local playerTools = {}
local playerCooldowns = {}
local module = {}

local function addTool(player, toolName)
	table.insert(playerTools[player], toolName)
	remotesFolder.AddTool:FireClient(player, toolName)
end

function module.hasTool(player, toolName)
	return if table.find(playerTools[player], toolName) then true else false
end

function module.onCooldown(player, eventName)
	return if table.find(playerCooldowns[player], eventName) then true else false
end

Players.PlayerAdded:Connect(function(player)
	coroutine.wrap(function()
		playerTools[player] = {}
		playerCooldowns[player] = {}

		--TEMP
		addTool(player, "Explosion")
		addTool(player, "Revolver")
		remotesFolder.ForceEquip:FireClient(player, "Revolver")
		--TEMP
	end)()
end)

return module
