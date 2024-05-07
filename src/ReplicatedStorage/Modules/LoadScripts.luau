return function(requiringScript)
    for _, instance in ipairs(requiringScript:GetDescendants()) do
		if not instance:IsA("ModuleScript") then
            continue
        end

        _G[instance.Name] = require(instance)
    end
    
    for _name, module in pairs(_G) do
        if module.Initialize == nil then
            continue
        end

        module.Initialize()
    end
end
