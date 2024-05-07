local ReplicatedStorage = game:GetService('ReplicatedStorage')

ReplicatedStorage.Remotes.Weapons.Revolver.Hit.OnServerEvent:Connect(function(player, hitHumanoid)
    hitHumanoid:TakeDamage(10)
end)

--TODO: Verify if player has Revolver through WeaponsManager
--TODO: Verify if raycast (direct shot and coin redirect) is legit and deal damage. Do this by sending client info (mouse location, character location, hit location, etc. and calculate (with error margin) here)

return nil
