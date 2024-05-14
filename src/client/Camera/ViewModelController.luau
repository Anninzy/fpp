local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local assetsFolder = ReplicatedStorage.Assets
local animationsFolder = assetsFolder.Animations
local camera = workspace.CurrentCamera
local viewModel = assetsFolder.ViewModel:Clone()
local module = {}

viewModel.Parent = camera
module.animationTracks = {}

--TEMP
local AnimationClipProvider = game:GetService("AnimationClipProvider")
local animationIds = {
	["Idle"] = AnimationClipProvider:RegisterAnimationClip(animationsFolder.Idle),
	["Swap"] = AnimationClipProvider:RegisterAnimationClip(animationsFolder.Swap),
}
--TEMP

for name, id in pairs(animationIds) do
	local animation = Instance.new("Animation")

	animation.AnimationId = id
	module.animationTracks[name] = viewModel.AnimationController.Animator:LoadAnimation(animation)
end

module.animationTracks["Idle"]:Play()

RunService.RenderStepped:Connect(function(_deltaTime)
	viewModel:PivotTo(camera.CFrame)
end)

module.swapTool = coroutine.wrap(function(toolName)
	local tool = assetsFolder.Tools[toolName].Handle:Clone()
	local oldTool = viewModel:FindFirstChild("Handle")

	module.animationTracks["Swap"]:Play()
	module.animationTracks["Swap"]:GetMarkerReachedSignal("HandHidden"):Wait()

	if oldTool then
		oldTool:Destroy()
	end

	tool.RightArm.Part0 = viewModel.RightArm
	tool.Parent = viewModel
end)

return module
