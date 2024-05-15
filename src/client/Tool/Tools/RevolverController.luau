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

local function createShotVisuals(muzzleAttachment, endPosition)
	local terrain = workspace.Terrain

	local beamAttachment0 = Instance.new("Attachment")
	beamAttachment0.WorldPosition = muzzleAttachment.WorldPosition
	beamAttachment0.Parent = terrain

	local beamAttachment1 = Instance.new("Attachment")
	beamAttachment1.WorldPosition = endPosition
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

local function createCoinVisuals(humanoidRootPartCFrame, humanoidRootPartAssemblyLinearVelocity)
	local lookVector = humanoidRootPartCFrame.LookVector

	local coinModel = assetsFolder.Coin:Clone()
	coinModel:PivotTo(humanoidRootPartCFrame * CFrame.Angles(math.rad(90), 0, math.rad(90)) + lookVector * 1.5)
	coinModel.Parent = workspace.Attackable
	coinModel.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 120, 0)
		+ lookVector * 90
		+ humanoidRootPartAssemblyLinearVelocity * 5

	Debris:AddItem(coinModel, 5)
end

module[Enum.UserInputType.MouseButton1] = function()
	local camera = workspace.CurrentCamera
	local character = Players.LocalPlayer.Character
	local mouseLocation = UserInputService:GetMouseLocation()
	local direction = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y).Direction * 100
	local raycastResult = ReplicatedStorage.Modules.RaycastBullet(character, direction)
	local muzzleAttachment = camera.ViewModel.Handle.Frame.Muzzle
	local endPosition = if raycastResult then raycastResult.Position else muzzleAttachment

	gunShotRemote:FireServer(character, direction)
	createShotVisuals(muzzleAttachment, endPosition)
end

module[Enum.UserInputType.MouseButton2] = function()
	local humanoidRootPart = Players.LocalPlayer.Character.HumanoidRootPart
	local humanoidRootPartCFrame = humanoidRootPart.CFrame
	local humanoidRootPartAssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity

	tossCoinRemote:FireServer(humanoidRootPartCFrame, humanoidRootPartAssemblyLinearVelocity)
	createCoinVisuals(humanoidRootPartCFrame, humanoidRootPartAssemblyLinearVelocity)
end

-- TODO: Implement after client-server ViewModel sync is implemented.
-- gunShotRemote.OnClientEvent:Connect(function(muzzleAttachment, endPosition, direction)
-- 	createShotVisuals(muzzleAttachment, endPosition)
-- end)

tossCoinRemote.OnClientEvent:Connect(
	function(firingPlayer, humanoidRootPartCFrame, humanoidRootPartAssemblyLinearVelocity)
		-- TODO: Play animation on firingPlayer
		createCoinVisuals(humanoidRootPartCFrame, humanoidRootPartAssemblyLinearVelocity)
	end
)

return module
