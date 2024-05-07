local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local toolsRemotes = ReplicatedStorage.Remotes.Tool

local playerTools = {}

local function addTool(player, toolName)
	playerTools[player][toolName] = true
	toolsRemotes.AddTool:FireClient(player, toolName)
end

Players.PlayerAdded:Connect(function(player)
	playerTools[player] = {}

	--TEMP
	addTool(player, "Explosion")
	addTool(player, "Revolver")
	player.CharacterAdded:Wait()
	toolsRemotes.ForceEquip:FireClient(player, "Revolver")
	--TEMP
end)

return nil
