local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local hudGui = Players.LocalPlayer.PlayerGui:WaitForChild("HUD")
local crosshairLabel = hudGui.Crosshair
local freeCursorButton = hudGui.FreeCursor
local module = {}

function module.unlockCursor() end

function module.enableCursor(icon)
	crosshairLabel.Visible = false
	freeCursorButton.Visible = true
	UserInputService.MouseIconEnabled = true
	UserInputService.MouseIcon = icon
end

function module.disableCursor()
	crosshairLabel.Visible = true
	freeCursorButton.Visible = false
	UserInputService.MouseIconEnabled = false
	UserInputService.MouseIcon = ""
end

module.disableCursor()

return module
