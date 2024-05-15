local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

function module.Initialize()
	local ViewModelController = _G.ViewModelController
	local toolsRemotes = ReplicatedStorage.Remotes.Tool
	local ownedTools = {}
	local equippedSlot = nil

	local function viewModelSwapTool()
		ViewModelController.swapTool(ownedTools[equippedSlot])
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end

		if not equippedSlot then
			return
		end

		local action = if input.KeyCode == Enum.KeyCode.Unknown then input.UserInputType else input.KeyCode
		local actionFunction = _G[ownedTools[equippedSlot] .. "Controller"][action]

		if not actionFunction then
			return
		end

		actionFunction()
	end)

	UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseWheel then
			return
		end

		if #ownedTools == 0 then
			return
		end

		if ViewModelController.animationTracks["Swap"].IsPlaying then
			return
		end

		local lastSlot = #ownedTools

		if input.Position.Z > 0 then -- Scroll up
			equippedSlot = if equippedSlot - 1 == 0 then lastSlot else equippedSlot - 1
		else -- Scroll down
			equippedSlot = if equippedSlot + 1 > lastSlot then 1 else equippedSlot + 1
		end

		viewModelSwapTool()
	end)

	toolsRemotes.AddTool.OnClientEvent:Connect(function(toolName)
		table.insert(ownedTools, toolName)
	end)

	toolsRemotes.ForceEquip.OnClientEvent:Connect(function(toolName)
		equippedSlot = table.find(ownedTools, toolName)
		viewModelSwapTool()
	end)
end

return module
