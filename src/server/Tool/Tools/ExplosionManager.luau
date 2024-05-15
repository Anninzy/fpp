local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local explosionPositions = {}
local module = {}

module.handleRemote = {
	["BeginChant"] = function(firingPlayer, remote)
		-- TODO: Add disrupt/silence ability (e.g. getting shot) to stop chant
		remote:FireAllClients(firingPlayer)
	end,

	["SetExplosionLocation"] = function(firingPlayer, remote, explosionPosition)
		explosionPositions[firingPlayer] = explosionPosition
		remote:FireAllClients(firingPlayer, explosionPosition)
	end,

	["ChantComplete"] = function(firingPlayer, remote)
		coroutine.wrap(function()
			-- TODO: Verify chant is legit
			local explosionPosition = explosionPositions[firingPlayer]
			local overlapParams = OverlapParams.new()
			local overlapParamsFilter = {}

			remote:FireAllClients(firingPlayer, explosionPosition)

			for _, player in ipairs(Players:GetPlayers()) do
				table.insert(overlapParamsFilter, player.Character.HumanoidRootPart)
			end
			overlapParams.FilterType = Enum.RaycastFilterType.Include
			overlapParams.FilterDescendantsInstances = overlapParamsFilter

			task.wait(ReplicatedStorage.Values.SecondsUntilExplosionAfterChantComplete.Value)

			for _, humanoidRootPart in ipairs(workspace:GetPartBoundsInRadius(explosionPosition, 500, overlapParams)) do
				local humanoid = humanoidRootPart.Parent.Humanoid
				humanoid:TakeDamage(humanoid.Health)
			end
		end)
	end,

	["ChantCancel"] = function(firingPlayer, remote)
		remote:FireAllClients(firingPlayer)
	end,
}

return module
