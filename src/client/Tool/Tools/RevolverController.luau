local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local assetsFolder = ReplicatedStorage.Assets.Tools.Revolver
local remotesFolder = ReplicatedStorage.Remotes.Tool.Revolver
local gunShotRemote = remotesFolder.GunShot
local tossCoinRemote = remotesFolder.TossCoin
local module = {}

local function createShotVisuals(muzzleAttachment, endPosition, direction)
	local terrain = workspace.Terrain

	local beamAttachment0 = Instance.new("Attachment")
	beamAttachment0.WorldPosition = muzzleAttachment.WorldPosition
	beamAttachment0.Parent = terrain

	local beamAttachment1 = Instance.new("Attachment")
	beamAttachment1.WorldPosition = if endPosition then endPosition else muzzleAttachment.WorldPosition + direction
	beamAttachment1.Parent = terrain

	local bulletTrail = assetsFolder.BulletTrail:Clone()
	bulletTrail.Attachment0 = beamAttachment0
	bulletTrail.Attachment1 = beamAttachment1
	bulletTrail.Parent = terrain

	muzzleAttachment.MuzzleFlash:Emit(1)
	TweenService:Create(bulletTrail, TweenInfo.new(0.1), { Width0 = 0, Width1 = 0 }):Play()
	Debris:AddItem(beamAttachment0, 0.1)
	Debris:AddItem(beamAttachment1, 0.1)
	Debris:AddItem(bulletTrail, 0.1)
end

module[Enum.UserInputType.MouseButton1] = function()
	local camera = workspace.CurrentCamera
	local character = Players.LocalPlayer.Character

	local headPosition = character.Head.Position
	local mouseLocation = UserInputService:GetMouseLocation()
	local direction = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y).Direction * 100
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { character }
	local raycastResult = workspace:Raycast(headPosition, direction, raycastParams)
	local endPosition = if raycastResult then raycastResult.Position else nil

	gunShotRemote:FireServer(headPosition, direction)
	createShotVisuals(camera.ViewModel.Handle.Frame.Muzzle, endPosition, direction)

	-- if not raycastResult then
	-- 	return
	-- end

	-- local raycastResultInstance = raycastResult.Instance

	-- if not raycastResultInstance:FindFirstAncestor("Attackable") then
	-- 	return
	-- end

	-- local humanoid = raycastResultInstance.Parent:FindFirstChildWhichIsA("Humanoid")

	-- if raycastResultInstance.Name == "Hitbox" and not humanoid then
	-- 	print("Hit coin")
	-- 	--local targets = workspace.Attackable:GetChildren()
	-- 	--local closest = {
	-- 	--	[targets[1]] = (targets[1].PrimaryPart.Position - position).Magnitude
	-- 	--}

	-- 	--for _, target in ipairs(targets) do
	-- 	--	local distance = (target.Position - position).Magnitude
	-- 	--	local closest = {next(closest)}

	-- 	--	if distance < closest[2] then
	-- 	--		closest[target] = distance
	-- 	--	end
	-- 	--end
	-- else
	-- 	ReplicatedStorage.Remotes.Tool.Revolver.ShotHit:FireServer(humanoid)
	-- end
end

module[Enum.UserInputType.MouseButton2] = function()
	local humanoidRootPart = Players.LocalPlayer.Character.HumanoidRootPart
	local humanoidRootPartCFrame = humanoidRootPart.CFrame
	local lookVector = humanoidRootPartCFrame.LookVector

	tossCoinRemote:FireServer(humanoidRootPartCFrame, humanoidRootPart.AssemblyLinearVelocity)

	local coinModel = assetsFolder.Coin:Clone()
	coinModel:PivotTo(humanoidRootPartCFrame * CFrame.Angles(math.rad(90), 0, math.rad(90)) + lookVector * 1.5)
	coinModel.Parent = workspace.Attackable
	coinModel.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 120, 0)
		+ lookVector * 90
		+ humanoidRootPart.AssemblyLinearVelocity * 5

	Debris:AddItem(coinModel, 5)
end

gunShotRemote.OnClientEvent:Connect(function(firingPlayer)
	createShotVisuals(muzzleAttachment, endPosition, direction)
end)

tossCoinRemote.OnClientEvent:Connect(function(firingPlayer) end)

return module
