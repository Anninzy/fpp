local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players")

local FREEZE_ACTION = "freezeMovement"
local FORMAT_STRING = '<stroke color="#000000" joins="round" thickness="25"><font color="#ffffff">%s</font>%s</stroke>'
local QUOTE_1 = [[
Darkness blacker than black and darker than dark,
I beseech thee, combine with my deep crimson.
The time of awakening cometh.
Justice, fallen upon the infallible boundary,
appear now as an intangible distortions!
I desire for my torrent of power a destructive force:
a destructive force without equal!
Return all creation to cinders,
and come frome the abyss!
Explosion!
]]
local QUOTE_2 = [[
Oh, blackness shrouded in light,
Frenzied blaze clad in night,
In the name of the crimson demons,
let the collapse of thine origin manifest.
Summon before me the root of thy power hidden within the lands
of the kingdom of demise!
Explosion!
]]
local QUOTE_3 = [[
Crimson-black blaze, king of myriad worlds,
though I promulgate the laws of nature,
I am the alias of destruction incarnate
in accordance with the principles of all creation.
Let the hammer of eternity descend unto me!
Explosion!
]]
local QUOTE_4 = [[
By my efflux of deep crimson,
topple this white world!
]]
local FLUENCY_MAP = {
	[1] = QUOTE_1,
	[2] = QUOTE_2,
	[3] = QUOTE_3,
	[4] = QUOTE_4,
}
local INFINITE_TWEEN_INFO = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)

local module = {}
local ongoingExplosions = {}
local fluency = 4
local localPlayer = Player.LocalPlayer
local remotesFolder = ReplicatedStorage.Remotes.Tool.Explosion
local explosionColorCorrection = Lighting.ExplosionColorCorrection
local explosionGui = localPlayer.PlayerGui:WaitForChild("ExplosionChant")
local revealFrame = explosionGui.Reveal
local textCaptureBox = explosionGui.TextCapture
local quoteLabel = revealFrame.Quote

local function removeChantSpinner(player)
	local chantSpinnerPart = workspace["MagicCircle" .. player.Name]
	TweenService:Create(
		chantSpinnerPart.PointLight,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
		{ Brightness = 0 }
	):Play()
	local shrinkTween = TweenService:Create(
		chantSpinnerPart,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
		{ Size = Vector3.new(0, 0, 0) }
	)
	shrinkTween:Play()
	shrinkTween.Completed:Wait()
	chantSpinnerPart:Destroy()
end

function module.BeginChant()
	remotesFolder.BeginChant:FireServer()

	ContextActionService:BindAction(FREEZE_ACTION, function()
		return Enum.ContextActionResult.Sink
	end, false, unpack(Enum.PlayerActions:GetEnumItems()))

	local explosionPosition
	local function getExplosionPosition()
		_G.MouseController.enableCursor("rbxasset://textures/Cursors/Gamepad/PointerOver.png")
		local input, _gameProcessedEvent = UserInputService.InputBegan:Wait()

		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			getExplosionPosition()
			return
		end

		local mouseLocation = UserInputService:GetMouseLocation()
		local unitRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y, 0)
		local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500)

		if raycastResult == nil then
			getExplosionPosition()
			return
		end

		_G.MouseController.disableCursor()
		explosionPosition = raycastResult.Position
		remotesFolder.SetExplosionLocation:FireServer(explosionPosition)
	end
	getExplosionPosition()

	local quote = FLUENCY_MAP[fluency]
	local currentQuoteCharacter = 1
	local currentSentenceCharacter = 1

	local sentences = string.split(quote, "\n")
	local currentSentence = 1
	for i, sentence in ipairs(sentences) do
		if sentence ~= "" then
			continue
		end

		table.remove(sentences, i)
	end

	local function scramble()
		local sentence = sentences[currentSentence]

		local characters = {}
		for position = 1, #sentence do
			characters[position] = string.sub(sentence, position, position)
		end

		for i = 1, 20, 1 do
			Random.new():Shuffle(characters)
			quoteLabel.Text = string.format(FORMAT_STRING, "", table.concat(characters))
			task.wait(0.03)
		end

		quoteLabel.Text = string.format(FORMAT_STRING, "", sentence)
	end

	quoteLabel.Size = UDim2.new(1, 0, 0, explosionGui.AbsoluteSize.Y * 0.04)
	coroutine.wrap(scramble)()
	TweenService:Create(revealFrame, TweenInfo.new(1, Enum.EasingStyle.Cubic), { Size = UDim2.new(1, 0, 0.1, 0) })
		:Play()

	local focusLostConnection
	local textChangedConnection

	local function closePopup()
		focusLostConnection:Disconnect()
		textChangedConnection:Disconnect()
		ContextActionService:UnbindAction(FREEZE_ACTION)
		TweenService:Create(revealFrame, TweenInfo.new(1, Enum.EasingStyle.Cubic), { Size = UDim2.new(1, 0, 0, 0) })
			:Play()
	end

	focusLostConnection = textCaptureBox.FocusLost:Connect(function()
		remotesFolder.CancelChant:FireServer()
		closePopup()
	end)

	textChangedConnection = textCaptureBox:GetPropertyChangedSignal("Text"):Connect(function()
		if textCaptureBox.Text == "" then
			return
		end
		local inputtedCharacter = textCaptureBox.Text
		textCaptureBox.Text = ""

		local requiredCharacter = string.sub(quote, currentQuoteCharacter, currentQuoteCharacter)
		if requiredCharacter == "\n" then
			requiredCharacter = " "
		end

		if inputtedCharacter ~= requiredCharacter then
			return
		end
		currentQuoteCharacter += 1

		local sentence = sentences[currentSentence]
		quoteLabel.Text = string.format(
			FORMAT_STRING,
			string.sub(sentence, 1, currentSentenceCharacter),
			string.sub(sentence, currentSentenceCharacter + 1, -1)
		)

		if currentSentenceCharacter ~= #sentence then
			currentSentenceCharacter += 1
			return
		end

		if currentQuoteCharacter == #quote then
			remotesFolder.ChantComplete:FireServer(explosionPosition)
			closePopup()
			textCaptureBox:ReleaseFocus()
		else
			currentSentenceCharacter = 1
			currentSentence += 1
			currentQuoteCharacter += 1
			scramble()
		end
	end)

	textCaptureBox:CaptureFocus()
end

remotesFolder.BeginChant.OnClientEvent:Connect(function(player)
	local magicCirclePart = ReplicatedStorage.Assets.Tools.Explosion.MagicCircle:Clone()
	magicCirclePart.Name = "MagicCircle" .. player.Name
	magicCirclePart.Position = player.Character.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
	magicCirclePart.Parent = workspace

	TweenService:Create(
		magicCirclePart.PointLight,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
		{ Brightness = 40 }
	):Play()
	TweenService:Create(magicCirclePart, INFINITE_TWEEN_INFO, { Orientation = Vector3.new(0, 360, 0) }):Play()
	TweenService:Create(
		magicCirclePart,
		TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
		{ Size = Vector3.new(5, 0, 5) }
	):Play()
end)

remotesFolder.CancelChant.OnClientEvent:Connect(removeChantSpinner)

remotesFolder.SetExplosionLocation.OnClientEvent:Connect(function(player, explosionPosition)
	local explosionModel = ReplicatedStorage.Assets.Tools.Explosion.Explosion:Clone()

	for _, ringPart in ipairs(explosionModel.Rings:GetChildren()) do
		local originalSize = ringPart.Size
		ringPart.Size = Vector3.new(0, 0, 0)
		TweenService:Create(ringPart, TweenInfo.new(2), { Size = originalSize }):Play()
		TweenService:Create(ringPart, INFINITE_TWEEN_INFO, { Orientation = Vector3.new(0, 360, 0) }):Play()
	end

	TweenService:Create(Lighting, TweenInfo.new(1), { ClockTime = 0 }):Play()

	explosionModel:PivotTo(
		CFrame.new(explosionPosition + Vector3.new(0, explosionModel.Beam.Size.X / 2, 0))
			* explosionModel.PrimaryPart.CFrame.Rotation
	)
	explosionModel.Parent = workspace

	ongoingExplosions[player] = explosionModel
end)

remotesFolder.ChantComplete.OnClientEvent:Connect(function(player, explosionPosition)
	removeChantSpinner(player)

	local explosionModel = ongoingExplosions[player]
	local beamPart = explosionModel.Beam
	local ballPart = explosionModel.Ball
	local impactGui = localPlayer.PlayerGui.ExplosionImpactFrame

	beamPart.Size = Vector3.new(2000, 200, 200)
	beamPart.Position = beamPart.Position * Vector3.new(1, 2, 1)

	explosionColorCorrection.Enabled = true
	impactGui.Enabled = true
	impactGui.Size = UDim2.new(1000, 0, 50, 0)
	local impactTween = TweenService:Create(
		impactGui,
		TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, true),
		{ Size = UDim2.new(1000, 0, 1000, 0) }
	)
	impactTween:Play()
	impactTween.Completed:Wait()

	coroutine.wrap(function()
		local startTime = os.clock()

		local function randomOffset()
			return math.random(-50, 50)
				/ ((player.Character.HumanoidRootPart.Position - ballPart.Position).Magnitude / 10)
		end

		repeat
			player.Character.Humanoid.CameraOffset = Vector3.new(randomOffset(), randomOffset(), randomOffset())
			task.wait()
		until os.clock() - startTime >= 5 --until final tween is over

		player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
	end)()

	ballPart.Impact.Enabled = false
	explosionColorCorrection.Enabled = false

	TweenService:Create(
		beamPart,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{ Size = Vector3.new(2000, 0, 0) }
	):Play()
	for _, ringPart in ipairs(explosionModel.Rings:GetChildren()) do
		TweenService:Create(
			ringPart,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ Size = Vector3.new(0, 0, 0) }
		):Play()
	end

	local ballEnlargeTween = TweenService:Create(ballPart, TweenInfo.new(5), { Size = Vector3.new(1000, 1000, 1000) })
	ballEnlargeTween:Play()
	ballEnlargeTween.Completed:Wait()
	local ballShrinkTween =
		TweenService:Create(ballPart, TweenInfo.new(1), { Size = Vector3.new(1200, 1200, 1200), Transparency = 1 })
	ballShrinkTween:Play()
	ballShrinkTween.Completed:Wait()

	TweenService:Create(Lighting, TweenInfo.new(1), { ClockTime = 12 }):Play()
	explosionModel:Destroy()
end)

return module
