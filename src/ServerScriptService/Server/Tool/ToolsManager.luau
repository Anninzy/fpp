local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local toolsRemotes = ReplicatedStorage.Remotes.Tool

Players.PlayerAdded:Connect(function(player)
	toolsRemotes.AddTool:FireClient(player, "Explosion")
	toolsRemotes.AddTool:FireClient(player, "Revolver")
	
	player.CharacterAdded:Wait()
	toolsRemotes.ForceEquip:FireClient(player, "Revolver")
end)

return nil
