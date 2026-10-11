local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local PGUI = LP:WaitForChild("PlayerGui")

for _, g in ipairs(PGUI:GetChildren()) do
	if g.Name == "KitiProtoV6" then g:Destroy() end
end

local T = {
	bg = Color3.fromRGB(15, 16, 26),
	card = Color3.fromRGB(22, 24, 38),
	element = Color3.fromRGB(32, 36, 54),
	hover = Color3.fromRGB(45, 50, 72),
	text = Color3.fromRGB(235, 238, 250),
	sub = Color3.fromRGB(140, 145, 180),
	accent1 = Color3.fromRGB(126, 108, 255),
	accent2 = Color3.fromRGB(86, 198, 255),
	off = Color3.fromRGB(50, 54, 72),
}

local function new(class, props)
	local o = Instance.new(class)
	if props then for k, v in pairs(props) do o[k] = v end end
	return o
end

local function corner(par, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r or 10), Parent = par })
end

local sg = new("ScreenGui", {
	Name = "KitiProtoV6", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 2147483647, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PGUI,
})

local function notify(title, text)
	local holder = new("Frame", { Size = UDim2.new(0, 280, 0, 50), Position = UDim2.new(1, -290, 0, 10), BackgroundColor3 = T.card, BackgroundTransparency = 0.1, Parent = sg })
	corner(holder, 12)
	new("TextLabel", { Size = UDim2.new(1, -16, 0, 20), Position = UDim2.fromOffset(12, 6), BackgroundTransparency = 1, Text = title, TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder })
	new("TextLabel", { Size = UDim2.new(1, -16, 0, 16), Position = UDim2.fromOffset(12, 26), BackgroundTransparency = 1, Text = text, TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder })
	TS:Create(holder, TweenInfo.new(0.25), { BackgroundTransparency = 0.1 }):Play()
	task.delay(3, function()
		TS:Create(holder, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		task.wait(0.35)
		holder:Destroy()
	end)
end

local win = new("Frame", {
	Size = UDim2.fromOffset(640, 420), Position = UDim2.new(0.5, -320, 0.5, -210),
	BackgroundColor3 = T.bg, BackgroundTransparency = 0.05,
	BorderSizePixel = 0, Active = true, Draggable = true, ClipsDescendants = true,
	ZIndex = 10, Parent = sg,
})
corner(win, 16)
new("UIStroke", { Color = T.accent1, Thickness = 1, Transparency = 0.5, Parent = win })

local topbar = new("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = T.card, BackgroundTransparency = 0.1, ZIndex = 11, Parent = win })
local logoF = new("Frame", { Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(14, 9), BackgroundColor3 = T.accent1, ZIndex = 12, Parent = topbar })
corner(logoF, 9)
new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "K", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBlack, TextSize = 16, ZIndex = 13, Parent = logoF })
new("TextLabel", { Size = UDim2.new(0, 250, 0, 18), Position = UDim2.fromOffset(54, 8), BackgroundTransparency = 1, Text = "KITI · PROTO", TextColor3 = T.text, Font = Enum.Font.GothamBlack, TextSize = 17, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12, Parent = topbar })
new("TextLabel", { Size = UDim2.new(0, 250, 0, 14), Position = UDim2.fromOffset(54, 28), BackgroundTransparency = 1, Text = "universal hub · " .. LP.Name, TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12, Parent = topbar })

local pages = {}
local current

local function addTab(name)
	local btn = new("TextButton", { Size = UDim2.new(0, 80, 0, 30), BackgroundColor3 = T.element, BackgroundTransparency = 1, Text = name, TextColor3 = T.sub, Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, ZIndex = 12, Parent = win })
	corner(btn)
	local page = new("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScrollBarThickness = 3, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 12, Parent = win })
	new("UIListLayout", { Parent = page, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
	new("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = page })
	local tab = { btn = btn, page = page }
	pages[#pages + 1] = tab
	local function select()
		for _, t in ipairs(pages) do
			local on = (t == tab)
			t.page.Visible = on
			t.btn.BackgroundTransparency = on and 0 or 1
			t.btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or T.sub
			if on then t.btn.BackgroundColor3 = T.accent1 end
		end
	end
	btn.MouseButton1Click:Connect(function()
		current = tab
		select()
	end)
	if not current then current = tab; select() end
	return page
end

local function addButton(page, text, cb)
	local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = T.element, Text = "  " .. text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 13, Parent = page })
	corner(b)
	b.MouseEnter:Connect(function() TS:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = T.hover }):Play() end)
	b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.element }):Play() end)
	b.MouseButton1Click:Connect(function()
		TS:Create(b, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(255, 105, 180), Size = UDim2.new(1, 0, 0, 40) }):Play()
		task.delay(0.18, function() TS:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundColor3 = T.element, Size = UDim2.new(1, 0, 0, 36) }):Play() end)
		pcall(cb)
	end)
	return b
end

local function addToggle(page, text, def, cb)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = T.element, ZIndex = 13, Parent = page })
	corner(row)
	new("TextLabel", { Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(12, 0), BackgroundTransparency = 1, Text = text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
	local track = new("Frame", { Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10), BackgroundColor3 = T.off, ZIndex = 14, Parent = row })
	corner(track)
	local knob = new("Frame", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 15, Parent = track })
	corner(knob)
	local on = def or false
	local function paint()
		knob.Position = on and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
		track.BackgroundColor3 = on and T.accent1 or T.off
	end
	paint()
	local hit = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 16, Parent = row })
	hit.MouseButton1Click:Connect(function()
		on = not on
		paint()
		pcall(cb, on)
	end)
	return { Set = function(v) on = v; paint() end, Get = function() return on end }
end

local function addSlider(page, text, mn, mx, def, cb)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = T.element, ZIndex = 13, Parent = page })
	corner(row)
	new("TextLabel", { Size = UDim2.new(1, -80, 0, 20), Position = UDim2.fromOffset(12, 4), BackgroundTransparency = 1, Text = text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
	local vlab = new("TextLabel", { Size = UDim2.fromOffset(60, 20), Position = UDim2.new(1, -70, 0, 4), BackgroundTransparency = 1, Text = tostring(def), TextColor3 = T.accent1, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = row })
	local track = new("TextButton", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 30), BackgroundColor3 = T.off, Text = "", AutoButtonColor = false, ZIndex = 14, Parent = row })
	corner(track)
	local fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = T.accent1, ZIndex = 15, Parent = track })
	corner(fill)
	local val = def
	local function upd()
		local a = (val - mn) / (mx - mn)
		fill.Size = UDim2.new(a, 0, 1, 0)
		vlab.Text = tostring(math.floor(val))
	end
	upd()
	local dragging = false
	local function setX(px)
		local a = math.clamp((px - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		val = mn + (mx - mn) * a
		upd()
		pcall(cb, val)
	end
	track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; setX(i.Position.X) end end)
	UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then setX(i.Position.X) end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	return { Set = function(v) val = math.clamp(v, mn, mx); upd() end }
end

local function getChar() return LP.Character end
local function getHRP() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end

local mov = addTab("Движение")
addSlider(mov, "WalkSpeed", 16, 200, 16, function(v) local h = getHum(); if h then h.WalkSpeed = v end end)
addSlider(mov, "JumpPower", 50, 300, 50, function(v) local h = getHum(); if h then h.UseJumpPower = true; h.JumpPower = v end end)
addToggle(mov, "Fly", false, function(on)
	if not on then
		local hrp = getHRP()
		if hrp then
			local bv = hrp:FindFirstChild("KitiFly"); if bv then bv:Destroy() end
			local bg = hrp:FindFirstChild("KitiGyro"); if bg then bg:Destroy() end
		end
	end
end)
addButton(mov, "Вверх на 50", function() local hrp = getHRP(); if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0) end end)
addButton(mov, "Вниз на 50", function() local hrp = getHRP(); if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0, 50, 0) end end)

RS.RenderStepped:Connect(function()
	local hrp = getHRP()
	if hrp and hrp:FindFirstChild("KitiFly") then
		local bv = hrp:FindFirstChild("KitiFly")
		local bg = hrp:FindFirstChild("KitiGyro")
		if bv and bg then
			bg.CFrame = Cam.CFrame
			local dir = Vector3.new()
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
			if dir.Magnitude > 0 then bv.Velocity = dir.Unit * 60 else bv.Velocity = Vector3.new(0, 0, 0) end
		end
	end
end)

local vis = addTab("Мир")
addButton(vis, "День", function()
	Lighting.ClockTime = 14; Lighting.Brightness = 2
	Lighting.Ambient = Color3.fromRGB(140, 140, 140); Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
end)
addButton(vis, "Закат", function()
	Lighting.ClockTime = 17.4; Lighting.Brightness = 1.8
	Lighting.Ambient = Color3.fromRGB(150, 110, 95); Lighting.OutdoorAmbient = Color3.fromRGB(210, 130, 95)
end)
addButton(vis, "Ночь", function()
	Lighting.ClockTime = 0; Lighting.Brightness = 0.8
	Lighting.Ambient = Color3.fromRGB(55, 60, 95); Lighting.OutdoorAmbient = Color3.fromRGB(40, 45, 80)
end)
addButton(vis, "Космос", function()
	Lighting.ClockTime = 0; Lighting.Brightness = 0.4
	Lighting.Ambient = Color3.fromRGB(40, 40, 70); Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 60)
	local sky = Lighting:FindFirstChildOfClass("Sky")
	if not sky then sky = Instance.new("Sky") sky.Parent = Lighting end
	sky.SkyboxBk = "rbxassetid://159454299"
	sky.SkyboxDn = "rbxassetid://159454296"
	sky.SkyboxFt = "rbxassetid://159454293"
	sky.SkyboxLf = "rbxassetid://159454286"
	sky.SkyboxRt = "rbxassetid://159454300"
	sky.SkyboxUp = "rbxassetid://159454288"
	sky.StarCount = 0
	sky.CelestialBodiesShown = false
end)
addButton(vis, "Fullbright", function()
	Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
	Lighting.Ambient = Color3.fromRGB(160, 160, 160); Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
end)

local me = addTab("Персонаж")
addButton(me, "Неон", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Material = Enum.Material.Neon end
	end
end)
addButton(me, "Стекло", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Material = Enum.Material.Glass; d.Transparency = 0.5 end
	end
end)
addButton(me, "ForceField", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Material = Enum.Material.ForceField end
	end
end)
addButton(me, "Красный", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Color = Color3.fromRGB(230, 60, 60) end
	end
end)
addButton(me, "Синий", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Color = Color3.fromRGB(60, 120, 255) end
	end
end)
addButton(me, "Зелёный", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Color = Color3.fromRGB(70, 220, 120) end
	end
end)

local cmb = addTab("Бой")
addToggle(cmb, "Aimbot (E)", false, function(on) S_aimbot = on end)
addSlider(cmb, "FOV аимбота", 20, 400, 150, function(v) S_aimfov = v end)
addToggle(cmb, "Triggerbot (Q)", false, function(on) S_trigger = on end)
addToggle(cmb, "Авто-клик", false, function(on) S_autoclick = on end)

local S_aimbot = false
local S_aimfov = 150
local S_trigger = false
local S_autoclick = false

RS.RenderStepped:Connect(function()
	if S_aimbot and UIS:IsKeyDown(Enum.KeyCode.E) then
		local best, bestD = nil, S_aimfov
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LP and p.Character then
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				local head = p.Character:FindFirstChild("Head")
				if hum and hum.Health > 0 and head then
					local sp, on = Cam:WorldToViewportPoint(head.Position)
					if on then
						local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)).Magnitude
						if d < bestD then bestD = d; best = head end
					end
				end
			end
		end
		if best then
			Cam.CFrame = CFrame.new(Cam.CFrame.Position, best.Position)
		end
	end
end)

local hud = addTab("Визуал")
addToggle(hud, "Fullbright", false, function(on)
	if on then
		Lighting.Brightness = 3; Lighting.GlobalShadows = false
	else
		Lighting.Brightness = 2; Lighting.GlobalShadows = true
	end
end)
addButton(hud, "Радужный мир", function()
	Lighting.Ambient = Color3.fromHSV(tick() % 1, 1, 1)
	Lighting.OutdoorAmbient = Color3.fromHSV(tick() % 1, 1, 1)
end)
addButton(hud, "Пьяная камера", function()
	local h = getHum()
	if h then h.CameraOffset = Vector3.new(math.sin(tick() * 3) * 2, math.cos(tick() * 2) * 1, 0) end
end)

local fun = addTab("Фан")
addButton(fun, "Конфетти", function()
	local hrp = getHRP()
	if not hrp then return end
	for _ = 1, 20 do
		local p = new("Part", { Size = Vector3.new(0.3, 0.3, 0.3), Anchored = true, CanCollide = false, Color = Color3.fromHSV(math.random(), 1, 1), Material = Enum.Material.Neon, Parent = workspace })
		p.CFrame = hrp.CFrame * CFrame.new(math.random(-5, 5), math.random(2, 6), math.random(-5, 5))
		task.delay(2, function() p:Destroy() end)
	end
end)

local closeBtn = new("TextButton", { Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, -36, 0.5, -14), BackgroundColor3 = T.element, Text = "×", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, ZIndex = 20, Parent = win })
corner(closeBtn, 8)
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightControl or i.KeyCode == Enum.KeyCode.RightShift then
		win.Visible = not win.Visible
	end
end)

notify("KITI · PROTO", "Загружено. RightControl/RightShift — меню", 5)
