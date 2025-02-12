loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
local players = game:GetService("Players")
local player = players.LocalPlayer
local rootPart = player.Character:WaitForChild("HumanoidRootPart")
local tpInterval = 0.001
local TeleportEnabled = false

local Settings = {
	50, -- Min
	150 -- Max
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScreenGui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local TP = Instance.new("TextButton")
TP.Name = "TP"
TP.Position = UDim2.new(0.5, 0, 0.2, 0)
TP.Size = UDim2.new(0, 225, 0, 60)
TP.BackgroundColor3 = Color3.new(1, 0.345098, 0.345098)
TP.BackgroundTransparency = 0.5
TP.BorderSizePixel = 0
TP.BorderColor3 = Color3.new(0, 0, 0)
TP.AnchorPoint = Vector2.new(0.5, 0.5)
TP.Transparency = 0.5
TP.Text = "Teleport : OFF"
TP.TextColor3 = Color3.new(1, 1, 1)
TP.TextSize = 25
TP.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TP.TextScaled = true
TP.TextWrapped = true
TP.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = TP

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Thickness = 4
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = TP

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Thickness = 3
UIStroke2.LineJoinMode = Enum.LineJoinMode.Miter
UIStroke2.Parent = TP

local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
UITextSizeConstraint.Name = "UITextSizeConstraint"
UITextSizeConstraint.MaxTextSize = 40
UITextSizeConstraint.Parent = TP

local Interval = Instance.new("TextBox")
Interval.Name = "Interval"
Interval.Position = UDim2.new(0.5, 0, 0.3, 0)
Interval.Size = UDim2.new(0, 200, 0, 50)
Interval.BackgroundColor3 = Color3.new(1, 1, 1)
Interval.BorderSizePixel = 0
Interval.BorderColor3 = Color3.new(0, 0, 0)
Interval.AnchorPoint = Vector2.new(0.5, 0.5)
Interval.Text = ""
Interval.TextColor3 = Color3.new(1, 1, 1)
Interval.TextSize = 14
Interval.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Interval.TextScaled = true
Interval.TextWrapped = true
Interval.PlaceholderText = "Tp Interval"
Interval.PlaceholderColor3 = Color3.new(1, 1, 1)
Interval.Parent = ScreenGui

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(0, 12)
UICorner2.Parent = Interval

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Thickness = 4
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke3.Parent = Interval

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Thickness = 3
UIStroke4.LineJoinMode = Enum.LineJoinMode.Miter
UIStroke4.Parent = Interval

local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")
UITextSizeConstraint2.Name = "UITextSizeConstraint"
UITextSizeConstraint2.MaxTextSize = 20
UITextSizeConstraint2.Parent = Interval

local red = Color3.fromRGB(255, 88, 88)
local green = Color3.fromRGB(88, 255, 88)

local function updgui(status)
	if TP then
		if status then
			TP.Text = "Teleport: ON"
			TP.BackgroundColor3 = green
		else
			TP.Text = "Teleport: OFF"
			TP.BackgroundColor3 = red
		end
	end
end


local function updateInterval()
	if Interval then
		local newInterval = tonumber(Interval.Text)
		if newInterval and newInterval > 0 then
			tpInterval = newInterval
			print("New Teleport Interval:", tpInterval)
		else
			print("Invalid interval. Please enter a valid number.")
		end
	end
end

if Interval then
	Interval.FocusLost:Connect(updateInterval)
end

-- Function to check if the player is dead
local function isPlayerDead()
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			return true
		end
	end
	return false
end

local function startTeleporting()
	-- Teleport Loop (Slower)
	while TeleportEnabled do
		if isPlayerDead() then
			TeleportEnabled = false -- Disable teleporting if dead
			updgui(TeleportEnabled)
			print("Teleport stopped due to death!")
			break
		end

		local randomPlayer = players:GetPlayers()[math.random(1, #players:GetPlayers())]
		if randomPlayer ~= player and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local targetPosition = randomPlayer.Character.HumanoidRootPart.Position
			local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

			if rootPart then
				rootPart.CFrame = CFrame.new(targetPosition)
				print("Teleported!")
			end
		end
		wait(tpInterval)
	end
end

local function startRotating()
	-- Rotation Loop (Faster)
	while TeleportEnabled do
		if isPlayerDead() then
			print("Rotation stopped due to death!")
			break
		end

		local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			local targetCFrame = rootPart.CFrame * CFrame.Angles(
				math.rad(math.random(Settings[1], Settings[2])),  -- X-axis rotation
				math.rad(math.random(Settings[1], Settings[2])),  -- Y-axis rotation
				0  -- Z-axis (unchanged)
			)
			rootPart.CFrame = targetCFrame
			print("Rotating...")
		end
		wait(0.01)
	end
end

-- Start/stop teleport and rotation loops on toggle
TP.Activated:Connect(function()
	TeleportEnabled = not TeleportEnabled
	updgui(TeleportEnabled)
	print("TeleportEnabled:", TeleportEnabled)

	-- Start teleporting and rotating when enabled
	if TeleportEnabled then
		task.spawn(startTeleporting)
		task.spawn(startRotating)
	end
end)
