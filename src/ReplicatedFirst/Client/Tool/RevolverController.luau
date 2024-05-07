local module = {}

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local camera = workspace.CurrentCamera
local terrain = workspace.Terrain
local revolverAssetsFolder = ReplicatedStorage.Assets.Tools.Revolver

local localCharacter

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local function raycastBeam(origin, direction)
	local raycastResult = workspace:Raycast(origin, direction, raycastParams)
	local muzzleAttachment = camera.ViewModel.Handle.Frame.Muzzle

	local beamAttachment0 = Instance.new("Attachment")
	beamAttachment0.WorldPosition = muzzleAttachment.WorldPosition
	beamAttachment0.Parent = terrain

	local beamAttachment1 = Instance.new("Attachment")
	if raycastResult then
		beamAttachment1.WorldPosition = raycastResult.Position
	else
		beamAttachment1.WorldPosition = muzzleAttachment.WorldPosition + direction
	end
	beamAttachment1.Parent = terrain

	local bulletTrail = revolverAssetsFolder.BulletTrail:Clone()
	bulletTrail.Attachment0 = beamAttachment0
	bulletTrail.Attachment1 = beamAttachment1
	bulletTrail.Parent = terrain
	
	muzzleAttachment.MuzzleFlash:Emit(1)
	TweenService:Create(bulletTrail, TweenInfo.new(0.1), {Width0 = 0, Width1 = 0}):Play()
	Debris:AddItem(beamAttachment0, 0.1)
	Debris:AddItem(beamAttachment1, 0.1)
	Debris:AddItem(bulletTrail, 0.1)
	
	if not raycastResult then
		return
	end

	local raycastResultInstance = raycastResult.Instance

	if not raycastResultInstance:FindFirstAncestor("Attackable") then
		return
	end

	local humanoid = raycastResultInstance.Parent:FindFirstChildWhichIsA("Humanoid")

	if raycastResultInstance.Name == "Hitbox" and not humanoid then
		print("It's a fucking coin!")
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
	else
		ReplicatedStorage.Remotes.Tool.Revolver.ShotHit:FireServer(humanoid)
	end
end

Players.LocalPlayer.CharacterAdded:Connect(function(character)
	localCharacter = character
	raycastParams.FilterDescendantsInstances = {localCharacter}
end)

function module.ShootGun()
	local mouseLocation = UserInputService:GetMouseLocation()
	local unitRay = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y, 0)
	raycastBeam(unitRay.Origin, unitRay.Direction * 100)
end

function module.TossCoin()
	local humanoidRootPart = localCharacter.HumanoidRootPart
	local humanoidRootPartCFrame = humanoidRootPart.CFrame
	local lookVector = humanoidRootPartCFrame.LookVector

	local coinModel = ReplicatedStorage.Assets.Tools.Revolver.Coin:Clone()
	coinModel:PivotTo(humanoidRootPartCFrame * CFrame.Angles(math.rad(90), 0, math.rad(90)) + lookVector * 1.5)
	coinModel.Parent = workspace.Attackable
	Debris:AddItem(coinModel, 5)

	coinModel.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 120, 0) + lookVector * 90 + humanoidRootPart.AssemblyLinearVelocity * 5
end

return module
