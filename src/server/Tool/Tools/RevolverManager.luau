local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage.Remotes.Tool.Revolver
-- local shotHitRemote = remotesFolder.ShotHit
-- local shotNotHitRemote = remotesFolder.ShotNotHit
local tossCoinRemote = remotesFolder.TossCoin

local module = {}
module.handleRemote = {
	["GunShot"] = function(player, remote, hit, ricochetCoins)
		-- TODO: Verify if player has Revolver through ToolsManager
		-- TODO: Verify if raycast is legit and deal damage. Do this by sending
		-- client info (mouse, character, ricochets, hit locations, and calculate
		-- with error margin
		remote:FireAllClients(player, hit, ricochetCoins)

		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then -- The last hit could be a coin due to lack of target.
			humanoid:TakeDamage(10)
		end
	end,
}

-- shotHitRemote.OnServerEvent:Connect(function(player, hit, ricochetCoins) end)

-- shotNotHitRemote.OnServerEvent:Connect(function(player, shotDirection)
-- 	-- TODO: Verify if player has Revolver through ToolsManager
-- 	-- TODO: Verify CD
-- 	shotNotHitRemote:FireAllClients(player, shotDirection)
-- end)

tossCoinRemote.OnServerEvent:Connect(function(player)
	-- TODO: Verify if player has Revolver through ToolsManager
	-- TODO: Verify CD
	tossCoinRemote:FireAllClients(player)
end)

return module
