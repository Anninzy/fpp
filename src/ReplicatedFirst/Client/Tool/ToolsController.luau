local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local toolsRemotes = ReplicatedStorage.Remotes.Tool

local toolsOwned = {}
local equippedSlot = nil

local function equipTool()	
	_G.ViewModelController.swapTool(toolsOwned[equippedSlot])
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	
	if not equippedSlot then
		return
	end

	local equippedTool = toolsOwned[equippedSlot]
	local KeyCode = input.KeyCode
	local E = Enum.KeyCode.E

	if equippedTool == "Revolver" then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			_G.RevolverController.ShootGun()
		elseif KeyCode == E then
			_G.RevolverController.TossCoin()
		end
	elseif equippedTool == "Explosion" then
		if KeyCode == E then
			_G.ChantController.BeginChant()
		end
	end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseWheel then
		return
	end

	if #toolsOwned == 0 then
		return
	end
	
	if _G.ViewModelController.animationTracks["Swap"].IsPlaying then
		return
	end

	if input.Position.Z > 0 then
		if equippedSlot - 1 == 0 then
			equippedSlot = #toolsOwned
		else
			equippedSlot -= 1
		end
	else
		if equippedSlot + 1 > #toolsOwned then
			equippedSlot = 1
		else
			equippedSlot += 1
		end
	end

	equipTool()
end)

toolsRemotes.ForceEquip.OnClientEvent:Connect(function(toolName)
	equippedSlot = table.find(toolsOwned, toolName)
	equipTool()
end)

toolsRemotes.AddTool.OnClientEvent:Connect(function(toolName)
	table.insert(toolsOwned, toolName)
end)

return nil
