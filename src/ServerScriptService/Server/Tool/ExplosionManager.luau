local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local explosionRemotes = ReplicatedStorage.Remotes.Weapons.Explosion
local chantBeginRemote = explosionRemotes.ChantBegin
local chantCancelRemote = explosionRemotes.ChantCancel
local chantCompleteRemote = explosionRemotes.ChantComplete

--TODO: Verify if player has Staff through WeaponsManager
--TODO: Add disrupt/silence ability (e.g. getting shot) to stop chant

chantBeginRemote.OnServerEvent:Connect(function(player)
    chantBeginRemote:FireAllClients(player)
end)

chantCancelRemote.OnServerEvent:Connect(function(player)
    chantCancelRemote:FireAllClients(player)
end)

chantCompleteRemote.OnServerEvent:Connect(function(player, explosionPosition)
    --TODO: Verify chant is legit
    chantCompleteRemote:FireAllClients(player, explosionPosition)
    
    local filter = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(filter, player.Character.HumanoidRootPart)
    end
    
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Include
    overlapParams.FilterDescendantsInstances = filter
    
    coroutine.wrap(function()
        task.wait(3)

        for _, humanoidRootPart in ipairs(workspace:GetPartBoundsInRadius(explosionPosition, 500, overlapParams)) do
            local humanoid = humanoidRootPart.Parent.Humanoid
            humanoid:TakeDamage(humanoid.Health)
        end
    end)()
end)

return nil
