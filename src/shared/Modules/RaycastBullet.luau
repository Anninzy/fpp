return function(character, direction)
	local headPosition = character.Head.Position

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { character }

	return workspace:Raycast(headPosition, direction, raycastParams)
end
