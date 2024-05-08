local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage.Remotes.Tool.Explosion
local beginChantRemote = remotesFolder.BeginChant
local cancelChantRemote = remotesFolder.CancelChant
local chantCompleteRemote = remotesFolder.ChantComplete

local module = {}
module.handleRemote = {
	["BeginChant"] = function(player, remote, explosionPosition)
		-- TODO: Verify if player has Staff through WeaponsManager
	-- TODO: Add disrupt/silence ability (e.g. getting shot) to stop chant
		remote:FireAllClients(player, explosionPosition)
	end,
}

beginChantRemote.OnServerEvent:Connect(function(player)
	-- TODO: Verify if player has Staff through WeaponsManager
	-- TODO: Add disrupt/silence ability (e.g. getting shot) to stop chant
	beginChantRemote:FireAllClients(player)
end)

cancelChantRemote.OnServerEvent:Connect(function(player)
	cancelChantRemote:FireAllClients(player)
end)

chantCompleteRemote.OnServerEvent:Connect(function(player, explosionPosition)
	-- TODO: Verify chant is legit
	chantCompleteRemote:FireAllClients(player, explosionPosition)

	coroutine.wrap(function()
		local overlapParamsFilter = {}
		for _, player in ipairs(Players:GetPlayers()) do
			table.insert(overlapParamsFilter, player.Character.HumanoidRootPart)
		end

		local overlapParams = OverlapParams.new()
		overlapParams.FilterType = Enum.RaycastFilterType.Include
		overlapParams.FilterDescendantsInstances = overlapParamsFilter

		task.wait(3)

		for _, humanoidRootPart in ipairs(workspace:GetPartBoundsInRadius(explosionPosition, 500, overlapParams)) do
			local humanoid = humanoidRootPart.Parent.Humanoid
			humanoid:TakeDamage(humanoid.Health)
		end
	end)()
end)

return module
