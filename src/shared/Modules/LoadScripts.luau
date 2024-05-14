return function(requiringScript)
	for _, moduleScript in ipairs(requiringScript:GetDescendants()) do
		if not moduleScript:IsA("ModuleScript") then
			continue
		end

		_G[moduleScript.Name] = require(moduleScript)
	end

	for _name, module in pairs(_G) do
		if module.Initialize == nil then
			continue
		end

		module.Initialize()
	end
end
