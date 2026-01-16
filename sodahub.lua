-- Script Hub UI: Fly, Fly Speed, Infinite Jump
-- LocalScript / Executor

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- ========== UI ==========
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SimpleHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.25, 0.35)
frame.Position = UDim2.fromScale(0.375, 0.325)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.15)
title.BackgroundTransparency = 1
title.Text = "SCRIPT HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local function button(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9, 0.15)
	b.Position = UDim2.fromScale(0.05, y)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local flyBtn = button("Fly: OFF", 0.2)
local jumpBtn = button("Inf Jump: OFF", 0.38)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.fromScale(0.9, 0.1)
speedLabel.Position = UDim2.fromScale(0.05, 0.56)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Fly Speed: 50"

local speedSlider = Instance.new("TextButton", frame)
speedSlider.Size = UDim2.fromScale(0.9, 0.12)
speedSlider.Position = UDim2.fromScale(0.05, 0.68)
speedSlider.Text = "Drag"
speedSlider.TextScaled = true
speedSlider.Font = Enum.Font.Gotham
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedSlider.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedSlider)

-- ========== FLY ==========
local flying = false
local flySpeed = 50
local bg, bv

local function startFly()
	flying = true
	hum.PlatformStand = true

	bg = Instance.new("BodyGyro", hrp)
	bg.P = 9e4
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

	bv = Instance.new("BodyVelocity", hrp)
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
end

local function stopFly()
	flying = false
	hum.PlatformStand = false
	if bg then bg:Destroy() end
	if bv then bv:Destroy() end
end

RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera
		bg.CFrame = cam.CFrame

		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= cam.CFrame.UpVector end

		bv.Velocity = move * flySpeed
	end
end)

flyBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		flyBtn.Text = "Fly: OFF"
	else
		startFly()
		flyBtn.Text = "Fly: ON"
	end
end)

-- ========== INFINITE JUMP ==========
local infJump = false

jumpBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	jumpBtn.Text = infJump and "Inf Jump: ON" or "Inf Jump: OFF"
end)

UIS.JumpRequest:Connect(function()
	if infJump then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- ========== SPEED SLIDER ==========
local dragging = false

speedSlider.MouseButton1Down:Connect(function()
	dragging = true
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local x = math.clamp((i.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
		flySpeed = math.floor(20 + (x * 180))
		speedLabel.Text = "Fly Speed: " .. flySpeed
	end
end)
