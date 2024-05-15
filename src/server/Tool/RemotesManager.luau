local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local module = {}

function module.Initialize()
	for _, folder in ipairs(ReplicatedStorage.Remotes.Tool:GetChildren()) do
		if not folder:IsA("Folder") then
			continue
		end

		for _, remote in ipairs(folder:GetChildren()) do
			remote.OnServerEvent:Connect(function(firingPlayer, ...)
				local ToolsManager = _G.ToolsManager
				local toolName = folder.Name
				local eventName = remote.Name

				if not ToolsManager.hasTool(firingPlayer, toolName) then
					return
				end

				if ToolsManager.onCooldown(firingPlayer, eventName) then
					return
				end

				_G[toolName .. "Manager"].handleRemote[eventName](firingPlayer, remote, ...)
			end)
		end
	end
end

function module.FireAllClientsExcludeFiringPlayer(firingPlayer, remote, ...)
	for _, player in ipairs(Players:GetPlayers()) do
		if firingPlayer then
			continue
		end

		remote:FireClient(player, ...)
	end
end

return module
