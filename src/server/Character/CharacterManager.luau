local Players = game:GetService("Players")

-- TODO: Sync viewmodel

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character.Parent = workspace.Attackable
	end)
end)

return nil
