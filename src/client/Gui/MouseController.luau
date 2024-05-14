local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local module = {}

function module.toggleCursor(icon)
	local hudGui = Players.LocalPlayer.PlayerGui:WaitForChild("HUD")
	local showCursor = if icon then true else false

	hudGui.Crosshair.Visible = not showCursor
	hudGui.FreeCursor.Visible = showCursor
	UserInputService.MouseIconEnabled = showCursor

	if not icon then
		return
	end

	UserInputService.MouseIcon = icon
end

module.toggleCursor()

return module
