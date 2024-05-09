local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

function module.Initialize()
	for _, folder in ipairs(ReplicatedStorage.Remotes.Tool:GetChildren()) do
		if not folder:IsA("Folder") then
			continue
		end

		for _, remote in ipairs(folder:GetChildren()) do
			remote.OnServerEvent:Connect(function(player, ...)
				local toolName = folder.Name
				local eventName = remote.Name
				local onCooldown = _G.ToolsManager.playerCooldowns[player][eventName]

				if not _G.ToolsManager.playerTools[player][toolName] then
					return
				end

				if onCooldown ~= nil and onCooldown then
					return
				end

				_G[toolName .. "Manager"].handleRemote[eventName](player, remote, ...)
			end)
		end
	end
end

return module
