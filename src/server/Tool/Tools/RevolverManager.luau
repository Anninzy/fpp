local module = {}

function module.Initialize()
	local RemotesManager = _G.RemotesManager

	module.handleRemote = {
		["GunShot"] = function(firingPlayer, remote, headPosition, direction)
			-- TODO: Verify if raycast is legit and deal damage. Do this by sending client info (mouse, character, ricochets, hit locations, and calculate with error margin
			-- TODO: Determine if direct hit, ricochet, or miss

			-- RemotesManager.FireAllClientsExcludeFiringPlayer(firingPlayer, remote)
			-- TODO: Implement after client-server ViewModel sync is implemented.

			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = { firingPlayer.Character }
			local raycastResult = workspace:Raycast(headPosition, direction, raycastParams)
		end,

		["TossCoin"] = function(firingPlayer, remote, humanoidRootPartCFrame, humanoidRootPartAssemblyLinearVelocity)
			RemotesManager.FireAllClientsExcludeFiringPlayer(
				firingPlayer,
				remote,
				humanoidRootPartCFrame,
				humanoidRootPartAssemblyLinearVelocity
			)
		end,
	}
end

return module
