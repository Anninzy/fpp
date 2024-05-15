return function(raycastResult)
	if not raycastResult then
		return
	end

	local raycastResultInstance = raycastResult.Instance

	if not raycastResultInstance:FindFirstAncestor("Attackable") then
		return
	end

	local humanoid = raycastResultInstance.Parent:FindFirstChildWhichIsA("Humanoid")

	if raycastResultInstance.Name == "Hitbox" and not humanoid then
		--local targets = workspace.Attackable:GetChildren()
		--local closest = {
		--	[targets[1]] = (targets[1].PrimaryPart.Position - position).Magnitude
		--}

		--for _, target in ipairs(targets) do
		--	local distance = (target.Position - position).Magnitude
		--	local closest = {next(closest)}

		--	if distance < closest[2] then
		--		closest[target] = distance
		--	end
		--end
	end
end
