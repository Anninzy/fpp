local module = {}

module.handleRemote = {
	["GunShot"] = function(player, remote, hit, ricochetCoins)
		-- TODO: Verify if raycast is legit and deal damage. Do this by sending client info (mouse, character, ricochets, hit locations, and calculate with error margin
		-- TODO: Determine if direct hit, ricochet, or miss
		local humanoid = hit.Parent:FindFirstChild("Humanoid")

		remote:FireAllClients(player, hit, ricochetCoins)

		if humanoid then -- The last hit could be a coin due to lack of target.
			humanoid:TakeDamage(10)
		end
	end,

	["TossCoin"] = function(player, remote)
		remote:FireAllClients(player)
	end,
}

return module
