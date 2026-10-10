local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VU = game:GetService("VirtualUser")
local TPS = game:GetService("TeleportService")
local HS = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local MPS = game:GetService("MarketplaceService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local PGUI = LP:WaitForChild("PlayerGui")
local env = (getgenv and getgenv()) or _G

for _, g in ipairs(PGUI:GetChildren()) do
	if g.Name == "KitiProtoV2" then g:Destroy() end
end

local Theme = {
	bg = Color3.fromRGB(14, 14, 19),
	bg2 = Color3.fromRGB(21, 21, 29),
	header1 = Color3.fromRGB(120, 55, 205),
	header2 = Color3.fromRGB(55, 110, 225),
	accent = Color3.fromRGB(175, 115, 255),
	text = Color3.fromRGB(236, 236, 246),
	sub = Color3.fromRGB(150, 150, 168),
	element = Color3.fromRGB(32, 32, 42),
	hover = Color3.fromRGB(46, 46, 60),
	off = Color3.fromRGB(58, 58, 72),
	on = Color3.fromRGB(150, 90, 235),
}

local function new(class, props, children)
	local o = Instance.new(class)
	if props then
		for k, v in pairs(props) do o[k] = v end
	end
	if children then
		for _, c in ipairs(children) do c.Parent = o end
	end
	return o
end

local function corner(par, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = par })
end

local sg = new("ScreenGui", {
	Name = "KitiProtoV2",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 2147483647,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = PGUI,
})

local notifHolder = new("Frame", {
	Name = "Notifs", Parent = sg, BackgroundTransparency = 1,
	Size = UDim2.new(0, 280, 0, 600), Position = UDim2.new(1, -292, 0, 14),
})
new("UIListLayout", { Parent = notifHolder, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right })

local function notify(title, text, dur)
	dur = dur or 4
	local f = new("Frame", {
		Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = Theme.bg2,
		BackgroundTransparency = 1, BorderSizePixel = 0, Parent = notifHolder,
	})
	corner(f, 9)
	local st = new("UIStroke", { Color = Theme.accent, Transparency = 1, Thickness = 1.4, Parent = f })
	new("Frame", { Size = UDim2.new(0, 4, 1, -12), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.accent, BorderSizePixel = 0, Parent = f })
	local tl = new("TextLabel", { Size = UDim2.new(1, -22, 0, 20), Position = UDim2.fromOffset(14, 8), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = f })
	local bl = new("TextLabel", { Size = UDim2.new(1, -22, 0, 18), Position = UDim2.fromOffset(14, 29), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.sub, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = f })
	TS:Create(f, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
	TS:Create(st, TweenInfo.new(0.25), { Transparency = 0.35 }):Play()
	TS:Create(tl, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	TS:Create(bl, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	task.delay(dur, function()
		TS:Create(f, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		TS:Create(st, TweenInfo.new(0.3), { Transparency = 1 }):Play()
		TS:Create(tl, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		TS:Create(bl, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		task.wait(0.32)
		f:Destroy()
	end)
end

local WIN_W, WIN_H = 640, 420
local win = new("Frame", {
	Size = UDim2.fromOffset(WIN_W, WIN_H),
	Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2),
	BackgroundColor3 = Theme.bg, BorderSizePixel = 0, Active = true,
	Draggable = true, ClipsDescendants = true, Parent = sg,
})
corner(win, 12)
local winStroke = new("UIStroke", { Color = Theme.accent, Thickness = 1.5, Transparency = 0.35, Parent = win })

local header = new("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = win })
local hGrad = new("UIGradient", { Color = ColorSequence.new(Theme.header1, Theme.header2), Rotation = 20, Parent = header })
new("Frame", { Size = UDim2.new(0, 6, 1, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.55, BorderSizePixel = 0, Parent = header })

local logo = new("Frame", { Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(14, 9), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = header })
corner(logo, 13)
new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "K", TextColor3 = Theme.header1, Font = Enum.Font.GothamBlack, TextSize = 16, Parent = logo })

local title = new("TextLabel", { Size = UDim2.new(0, 300, 0, 20), Position = UDim2.fromOffset(50, 6), BackgroundTransparency = 1, Text = "KITI · PROTO  V2", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBlack, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
local subtitle = new("TextLabel", { Size = UDim2.new(0, 300, 0, 14), Position = UDim2.fromOffset(50, 25), BackgroundTransparency = 1, Text = "universal hub · " .. LP.Name, TextColor3 = Color3.fromRGB(235, 225, 255), Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = header })

local function headerBtn(text, xoff, cb)
	local b = new("TextButton", { Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, xoff, 0.5, -13), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.82, Text = text, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, Parent = header })
	corner(b, 7)
	b.MouseEnter:Connect(function() TS:Create(b, TweenInfo.new(0.12), { BackgroundTransparency = 0.55 }):Play() end)
	b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.12), { BackgroundTransparency = 0.82 }):Play() end)
	b.MouseButton1Click:Connect(function() pcall(cb) end)
	return b
end

local body = new("Frame", { Size = UDim2.new(1, 0, 1, -44), Position = UDim2.fromOffset(0, 44), BackgroundTransparency = 1, Parent = win })
local sidebar = new("Frame", { Size = UDim2.new(0, 154, 1, 0), BackgroundColor3 = Theme.bg2, BorderSizePixel = 0, Parent = body })
new("UIListLayout", { Parent = sidebar, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
new("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10), Parent = sidebar })
local content = new("Frame", { Size = UDim2.new(1, -154, 1, 0), Position = UDim2.fromOffset(154, 0), BackgroundTransparency = 1, Parent = body })

local searchRows = {}
local function regSearch(frame, name)
	searchRows[#searchRows + 1] = { frame = frame, name = string.lower(name) }
end

local search = new("TextBox", { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.element, PlaceholderText = "поиск...", PlaceholderColor3 = Theme.sub, Text = "", TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = sidebar })
corner(search, 7)
new("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = search })
search:GetPropertyChangedSignal("Text"):Connect(function()
	local txt = string.lower(search.Text)
	for _, r in ipairs(searchRows) do
		r.frame.Visible = (txt == "" or string.find(r.name, txt, 1, true) ~= nil)
	end
end)

local tabs = {}
local function addTab(name, symbol)
	local btn = new("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.on, BackgroundTransparency = 1, Text = "   " .. (symbol and (symbol .. "  ") or "") .. name, TextColor3 = Theme.sub, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = sidebar })
	corner(btn, 7)
	local ind = new("Frame", { Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.accent, BorderSizePixel = 0, Visible = false, Parent = btn })
	corner(ind, 2)
	local page = new("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = content })
	new("UIListLayout", { Parent = page, Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder })
	new("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 14), PaddingBottom = UDim.new(0, 12), Parent = page })
	local tab = { btn = btn, page = page, ind = ind }
	tabs[#tabs + 1] = tab
	local function select()
		for _, t in ipairs(tabs) do
			local on = (t == tab)
			t.page.Visible = on
			t.ind.Visible = on
			t.btn.TextColor3 = on and Theme.text or Theme.sub
			t.btn.BackgroundTransparency = on and 0.45 or 1
		end
	end
	btn.MouseButton1Click:Connect(select)
	if #tabs == 1 then select() end
	return page
end

local function addSection(page, text)
	local l = new("TextLabel", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = string.upper(text), TextColor3 = Theme.accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = page })
	regSearch(l, text)
	return l
end

local function addDivider(page)
	return new("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.fromRGB(48, 48, 60), BorderSizePixel = 0, Parent = page })
end

local function addButton(page, text, cb, spr)
	local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.element, Text = "  " .. text, TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = page })
	corner(b, 7)
	if spr then new("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = b }) end
	b.MouseEnter:Connect(function() TS:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = Theme.hover }):Play() end)
	b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = Theme.element }):Play() end)
	b.MouseButton1Click:Connect(function()
		local ok, err = pcall(cb)
		if not ok then notify("Ошибка", tostring(err), 5) end
	end)
	regSearch(b, text)
	return b
end

local function addToggle(page, text, def, cb)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.element, Parent = page })
	corner(row, 7)
	new("TextLabel", { Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(12, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
	local track = new("Frame", { Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10), BackgroundColor3 = Theme.off, BorderSizePixel = 0, Parent = row })
	corner(track, 10)
	local knob = new("Frame", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.fromRGB(235, 235, 245), BorderSizePixel = 0, Parent = track })
	corner(knob, 8)
	local on = def or false
	local function paint(anim)
		local gp = on and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
		local gc = on and Theme.on or Theme.off
		if anim then
			TS:Create(knob, TweenInfo.new(0.15), { Position = gp }):Play()
			TS:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = gc }):Play()
		else
			knob.Position = gp
			track.BackgroundColor3 = gc
		end
	end
	paint(false)
	local hit = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = row })
	hit.MouseButton1Click:Connect(function()
		on = not on
		paint(true)
		local ok, err = pcall(cb, on)
		if not ok then notify("Ошибка", tostring(err), 5) end
	end)
	regSearch(row, text)
	return { Set = function(v, quiet)
		on = v
		paint(true)
		if not quiet then pcall(cb, on) end
	end }
end

local function addSlider(page, text, mn, mx, def, cb, dec)
	dec = dec or 0
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Theme.element, Parent = page })
	corner(row, 7)
	new("TextLabel", { Size = UDim2.new(1, -90, 0, 20), Position = UDim2.fromOffset(12, 4), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
	local vlab = new("TextLabel", { Size = UDim2.fromOffset(70, 20), Position = UDim2.new(1, -82, 0, 4), BackgroundTransparency = 1, Text = tostring(def), TextColor3 = Theme.accent, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = row })
	local track = new("TextButton", { Size = UDim2.new(1, -24, 0, 8), Position = UDim2.new(0, 12, 0, 30), BackgroundColor3 = Color3.fromRGB(54, 54, 68), Text = "", AutoButtonColor = false, Parent = row })
	corner(track, 4)
	local fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.accent, BorderSizePixel = 0, Active = false, Parent = track })
	corner(fill, 4)
	local dot = new("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Active = false, Parent = track })
	corner(dot, 7)
	local val = def
	local function upd()
		local a = (val - mn) / (mx - mn)
		fill.Size = UDim2.new(a, 0, 1, 0)
		dot.Position = UDim2.new(a, 0, 0.5, 0)
		vlab.Text = (dec > 0) and string.format("%." .. dec .. "f", val) or tostring(math.floor(val))
	end
	local dragging = false
	local function setX(px)
		local a = math.clamp((px - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		val = mn + (mx - mn) * a
		if dec == 0 then val = math.floor(val) end
		upd()
		pcall(cb, val)
	end
	upd()
	track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; setX(i.Position.X) end end)
	UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then setX(i.Position.X) end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	regSearch(row, text)
	return { Set = function(v, quiet)
		val = math.clamp(v, mn, mx)
		upd()
		if not quiet then pcall(cb, val) end
	end }
end

local function addDropdown(page, text, options, def, cb)
	local IH = 28
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.element, Parent = page })
	corner(row, 7)
	local head = new("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, Text = "", Parent = row })
	new("TextLabel", { Size = UDim2.new(1, -150, 0, 32), Position = UDim2.fromOffset(12, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = head })
	local cur = new("TextLabel", { Size = UDim2.fromOffset(110, 32), Position = UDim2.new(1, -150, 0, 0), BackgroundTransparency = 1, Text = def or (options[1] or "-"), TextColor3 = Theme.accent, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = head })
	local arrow = new("TextLabel", { Size = UDim2.fromOffset(20, 32), Position = UDim2.new(1, -26, 0, 0), BackgroundTransparency = 1, Text = "v", TextColor3 = Theme.sub, Font = Enum.Font.GothamBold, TextSize = 13, Parent = head })
	local open = false
	local opts = {}
	for i, opt in ipairs(options) do
		local ob = new("TextButton", { Size = UDim2.new(1, -20, 0, IH - 2), Position = UDim2.fromOffset(10, 32 + (i - 1) * IH), BackgroundColor3 = Theme.bg2, Text = "  " .. opt, TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, AutoButtonColor = false, Parent = row })
		corner(ob, 5)
		opts[i] = ob
		ob.MouseEnter:Connect(function() ob.BackgroundColor3 = Theme.hover end)
		ob.MouseLeave:Connect(function() ob.BackgroundColor3 = Theme.bg2 end)
		ob.MouseButton1Click:Connect(function()
			cur.Text = opt
			for _, o in ipairs(opts) do o.Visible = false end
			open = false
			arrow.Text = "v"
			row.Size = UDim2.new(1, 0, 0, 32)
			pcall(cb, opt)
		end)
	end
	head.MouseButton1Click:Connect(function()
		open = not open
		for _, o in ipairs(opts) do o.Visible = open end
		arrow.Text = open and "^" or "v"
		row.Size = UDim2.new(1, 0, 0, open and (32 + #options * IH) or 32)
	end)
	regSearch(row, text)
	return { Set = function(v) cur.Text = v end }
end

local function addBox(page, placeholder, cb)
	local box = new("TextBox", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.element, PlaceholderText = placeholder, PlaceholderColor3 = Theme.sub, Text = "", TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = false, Parent = page })
	corner(box, 7)
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = box })
	box.FocusLost:Connect(function(enter) if enter then pcall(cb, box.Text) end end)
	regSearch(box, placeholder)
	return box
end

local function getChar() return LP.Character end
local function getHRP() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function hrpOf(p) local c = p and p.Character; return c and c:FindFirstChild("HumanoidRootPart") end

local S = {
	speed = 16, jump = 50, menuKey = Enum.KeyCode.RightControl,
	fly = false, flySpeed = 60, flyMode = "Камера",
	noclip = false, infJump = false, antiAfk = false, jumpBoost = false,
	fullbright = false, clock = 14, nofog = false, retime = false,
	espNames = false, espBox = false, espTracer = false, espHighlight = false, espRole = true,
	aimbot = false, aimAlways = false, aimKey = Enum.KeyCode.E, aimFov = 150, aimPart = "Head", aimSmooth = 0.5,
	trigger = false, triggerKey = Enum.KeyCode.Q,
	hitbox = false, hitboxSize = 6,
	clickTp = false, hud = true, crosshair = false, watermark = true,
}

local DrawingLib = Drawing
local visuals = {}

local function clearVisual(v)
	if v.box then v.box:Remove() end
	if v.tracer then v.tracer:Remove() end
end

local function w2s(pos)
	local sp, on = Cam:WorldToViewportPoint(pos)
	if not on then return nil end
	return Vector2.new(sp.X, sp.Y), sp.Z
end

Players.PlayerRemoving:Connect(function(p)
	if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
end)

local function roleOf(p)
	local char = p.Character
	local function scan(cont)
		if not cont then return nil end
		for _, t in ipairs(cont:GetChildren()) do
			if t:IsA("Tool") then
				local n = string.lower(t.Name)
				if string.find(n, "knife", 1, true) then return "MURDERER" end
				if string.find(n, "gun", 1, true) or string.find(n, "revolver", 1, true) then return "SHERIFF" end
			end
		end
		return nil
	end
	return scan(char) or scan(p:FindFirstChild("Backpack")) or "INNOCENT"
end

local function roleColor(p)
	if not S.espRole then return Color3.fromRGB(255, 80, 80) end
	local r = roleOf(p)
	if r == "MURDERER" then return Color3.fromRGB(255, 60, 60) end
	if r == "SHERIFF" then return Color3.fromRGB(70, 150, 255) end
	return Color3.fromRGB(90, 255, 120)
end

local function findTarget()
	local center = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
	local best, bestD, bestPos = nil, S.aimFov, nil
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local part = p.Character:FindFirstChild(S.aimPart) or p.Character:FindFirstChild("HumanoidRootPart")
			if hum and hum.Health > 0 and part then
				local sp, on = Cam:WorldToViewportPoint(part.Position)
				if on then
					local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
					if d < bestD then bestD = d; best = p; bestPos = part.Position end
				end
			end
		end
	end
	return best, bestPos
end

local mov = addTab("Movement", ">")
addSection(mov, "Скорость")
addSlider(mov, "WalkSpeed", 16, 500, 16, function(v) S.speed = v end)
addSlider(mov, "JumpPower", 50, 500, 50, function(v)
	S.jump = v
	local h = getHum(); if h then h.UseJumpPower = true; h.JumpPower = v end
end)
addToggle(mov, "Бесконечный прыжок", false, function(on) S.infJump = on end)
addDivider(mov)
addSection(mov, "Полёт")
addToggle(mov, "Fly", false, function(on)
	S.fly = on
	if not on then
		local hrp = getHRP()
		if hrp then
			local bv = hrp:FindFirstChild("KitiFly"); if bv then bv:Destroy() end
			local bg = hrp:FindFirstChild("KitiGyro"); if bg then bg:Destroy() end
		end
	end
	notify("Fly", on and "включён" or "выключен", 2)
end)
addSlider(mov, "Fly speed", 10, 500, 60, function(v) S.flySpeed = v end)
addDropdown(mov, "Режим полёта", { "Камера", "Вертолёт" }, "Камера", function(v) S.flyMode = v end)
addDivider(mov)
addSection(mov, "Прочее")
addToggle(mov, "Noclip (сквозь стены)", false, function(on) S.noclip = on end)
addToggle(mov, "Anti-AFK", false, function(on) S.antiAfk = on end)
addToggle(mov, "Click TP (лкм)", false, function(on) S.clickTp = on; notify("Click TP", on and "включён" or "выключен", 2) end)
addButton(mov, "Reset персонажа", function() local h = getHum(); if h then h.Health = 0 end end)

local vis = addTab("Visuals", "*")
addSection(vis, "Освещение")
addToggle(vis, "Fullbright", false, function(on)
	S.fullbright = on
	if on then
		Lighting.Brightness = 3; Lighting.ClockTime = 14
		Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(150, 150, 150)
	else
		Lighting.Brightness = 2; Lighting.GlobalShadows = true
		Lighting.Ambient = Color3.fromRGB(70, 70, 70)
	end
end)
addToggle(vis, "Убрать туман", false, function(on)
	S.nofog = on
	Lighting.FogEnd = on and 100000 or 1000
end)
addSlider(vis, "Время суток", 0, 24, 14, function(v)
	S.clock = v
	if S.retime then Lighting.ClockTime = v end
end, 1)
addToggle(vis, "Управление временем", false, function(on) S.retime = on end)
addDivider(vis)
addSection(vis, "Игроки (ESP)")
addToggle(vis, "ESP имена", false, function(on) S.espNames = on end)
addToggle(vis, "ESP боксы", false, function(on)
	if on and not DrawingLib then notify("ESP", "Drawing недоступен в экзекьюторе", 5); return end
	S.espBox = on
end)
addToggle(vis, "ESP трассеры", false, function(on)
	if on and not DrawingLib then notify("ESP", "Drawing недоступен в экзекьюторе", 5); return end
	S.espTracer = on
end)
addToggle(vis, "ESP подсветка (Highlight)", false, function(on) S.espHighlight = on end)
addToggle(vis, "Цвет по роли MM2", true, function(on) S.espRole = on end)
addDivider(vis)
addSection(vis, "HUD")
addToggle(vis, "Watermark", true, function(on) S.watermark = on end)
addToggle(vis, "HUD (FPS / ping / коорд.)", true, function(on) S.hud = on end)
addToggle(vis, "Прицел (crosshair)", false, function(on) S.crosshair = on end)

local cmb = addTab("Combat", "+")
addSection(cmb, "Aimbot")
addToggle(cmb, "Aimbot", false, function(on) S.aimbot = on end)
addToggle(cmb, "Всегда целиться (без клавиши)", false, function(on) S.aimAlways = on end)
addSlider(cmb, "FOV", 20, 400, 150, function(v) S.aimFov = v end)
addSlider(cmb, "Плавность", 0, 1, 0.5, function(v) S.aimSmooth = v end, 2)
addDropdown(cmb, "Часть тела", { "Head", "HumanoidRootPart", "UpperTorso" }, "Head", function(v) S.aimPart = v end)
addDivider(cmb)
addSection(cmb, "Триггер")
addToggle(cmb, "Triggerbot (tool:Activate)", false, function(on) S.trigger = on end)
addDivider(cmb)
addSection(cmb, "Хитбоксы")
addToggle(cmb, "Расширить хитбоксы", false, function(on)
	S.hitbox = on
	if not on then
		for _, p in ipairs(Players:GetPlayers()) do
			local hrp = hrpOf(p)
			if hrp then hrp.Size = Vector3.new(2, 2, 1) end
		end
	end
end)
addSlider(cmb, "Размер хитбокса", 2, 15, 6, function(v) S.hitboxSize = v end)

local plr = addTab("Players", "#")
addSection(plr, "Список игроков")
local plist = new("Frame", { Size = UDim2.new(1, 0, 0, 220), BackgroundTransparency = 1, Parent = plr })
new("UIListLayout", { Parent = plist, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
task.spawn(function()
	while true do
		pcall(function()
			for _, c in ipairs(plist:GetChildren()) do
				if c:IsA("TextButton") then c:Destroy() end
			end
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LP then
					local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Theme.element, Text = "  " .. p.Name, TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = plist })
					corner(b, 6)
					b.MouseButton1Click:Connect(function()
						local a = getHRP(); local t = hrpOf(p)
						if a and t then a.CFrame = t.CFrame * CFrame.new(0, 0, 3) end
					end)
				end
			end
		end)
		task.wait(3)
	end
end)
addButton(plr, "Teleport к ближайшему", function()
	local best, bd = nil, 1e9
	local a = getHRP()
	if not a then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			local t = hrpOf(p)
			if t then
				local d = (t.Position - a.Position).Magnitude
				if d < bd then bd = d; best = t end
			end
		end
	end
	if best then a.CFrame = best.CFrame * CFrame.new(0, 0, 3) end
end)
addToggle(plr, "Невидимость (локально)", false, function(on)
	local c = getChar()
	if c then
		for _, d in ipairs(c:GetDescendants()) do
			if d:IsA("BasePart") or d:IsA("Decal") then
				d.LocalTransparencyModifier = on and 1 or 0
			end
		end
	end
end)

local mm2 = addTab("MM2", "!")
addSection(mm2, "Роли")
addButton(mm2, "Показать роли в чат (F9)", function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then print(p.Name .. " => " .. roleOf(p)) end
	end
	notify("MM2", "роли выведены в консоль (F9)", 3)
end)
addToggle(mm2, "Role ESP (цвет по роли)", false, function(on) S.espNames = on or S.espNames; S.espRole = true; S.espHighlight = on end)
addDivider(mm2)
addSection(mm2, "Трюки")
addButton(mm2, "TP к ближайшему (раунд)", function()
	local best, bd = nil, 1e9
	local a = getHRP()
	if not a then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			local t = hrpOf(p)
			if t then local d = (t.Position - a.Position).Magnitude; if d < bd then bd = d; best = t end end
		end
	end
	if best then a.CFrame = best.CFrame * CFrame.new(0, 0, 3) end
end)

local srv = addTab("Server", "$")
addSection(srv, "Сервер")
addButton(srv, "Rejoin", function()
	notify("Server", "переподключение...", 3)
	TPS:Teleport(game.PlaceId, LP)
end)
addButton(srv, "Server hop", function()
	local ok = pcall(function()
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		local data = HS:JSONDecode(game:HttpGet(url))
		for _, s in ipairs(data.data) do
			if s.playing < s.maxPlayers and s.id ~= game.JobId then
				TPS:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
				return
			end
		end
	end)
	if not ok then notify("Server", "server hop недоступен (HTTP)", 5) end
end)
addButton(srv, "Скопировать Job ID", function()
	if setclipboard then setclipboard(game.JobId); notify("Server", "Job ID скопирован", 3)
	else notify("Server", "setclipboard недоступен", 4) end
end)
addButton(srv, "Скопировать ID игры", function()
	if setclipboard then setclipboard(tostring(game.PlaceId)); notify("Server", "PlaceId скопирован", 3)
	else notify("Server", "setclipboard недоступен", 4) end
end)
addDivider(srv)
addSection(srv, "Скрипты (быстрая загрузка)")
local function loadUrl(url, name)
	task.spawn(function()
		notify("Загрузка", name or url, 3)
		local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
		if not ok then notify("Ошибка", tostring(err), 5) end
	end)
end
addButton(srv, "Infinite Yield (admin)", function() loadUrl("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", "IY") end)
addButton(srv, "Dex Explorer", function() loadUrl("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua", "Dex") end)
addButton(srv, "Vertex (MM2)", function() loadUrl("https://raw.smokingscripts.org/vertex.lua", "Vertex") end)
addButton(srv, "RewHub (MM2)", function() loadUrl("https://raw.githubusercontent.com/ScriptsForMM2RewHub/RewHub/refs/heads/main/LoaderRewHub.lua", "RewHub") end)
addButton(srv, "MoonWare (MM2)", function() loadUrl("https://raw.githubusercontent.com/littl3prince/Moon/main/Moon_V1", "Moon") end)
addBox(srv, "вставь raw URL скрипта + Enter", function(url) if url ~= "" then loadUrl(url) end end)

local set = addTab("Settings", "%")
addSection(set, "Интерфейс")
addButton(set, "Клавиша меню: RightControl", function()
	notify("Клавиша", "нажми любую клавишу...", 2)
	local conn
	conn = UIS.InputBegan:Connect(function(i, gp)
		if gp then return end
		if i.UserInputType == Enum.UserInputType.Keyboard then
			S.menuKey = i.KeyCode
			notify("Клавиша", "теперь: " .. i.KeyCode.Name, 2)
			conn:Disconnect()
		end
	end)
end)
addSection(set, "Тема")
local function applyAccent(c)
	Theme.accent = c
	winStroke.Color = c
	hGrad.Color = ColorSequence.new(c, Theme.header2)
	notify("Тема", "цвет применён", 2)
end
addButton(set, "Фиолетовая (по умолчанию)", function() applyAccent(Color3.fromRGB(175, 115, 255)) end)
addButton(set, "Голубая", function() applyAccent(Color3.fromRGB(80, 170, 255)) end)
addButton(set, "Розовая", function() applyAccent(Color3.fromRGB(255, 95, 180)) end)
addButton(set, "Зелёная", function() applyAccent(Color3.fromRGB(80, 230, 140)) end)
addDivider(set)
addSection(set, "Инфо")
new("TextLabel", { Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, Text = "KITI PROTO V2\nuniversal hub\nby request", TextColor3 = Theme.sub, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = set })

local watermark = new("TextLabel", {
	Name = "WM", Parent = sg, BackgroundTransparency = 1,
	Size = UDim2.new(0, 300, 0, 20), Position = UDim2.fromOffset(14, 10),
	Text = "KITI · PROTO V2", TextColor3 = Theme.accent,
	Font = Enum.Font.GothamBlack, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
	TextStrokeTransparency = 0.6, TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
})

local hud = new("Frame", {
	Name = "HUD", Parent = sg, BackgroundColor3 = Theme.bg2,
	BackgroundTransparency = 1, Size = UDim2.fromOffset(200, 82),
	Position = UDim2.new(0, 14, 0, 38), BorderSizePixel = 0,
})
corner(hud, 9)
local hudStroke = new("UIStroke", { Color = Theme.accent, Transparency = 0.4, Parent = hud })
local hudList = new("UIListLayout", { Parent = hud, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
new("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 12), Parent = hud })
local hudTitle = new("TextLabel", { Size = UDim2.new(1, -12, 0, 16), BackgroundTransparency = 1, Text = "HUD", TextColor3 = Theme.accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudFps = new("TextLabel", { Size = UDim2.new(1, -12, 0, 15), BackgroundTransparency = 1, Text = "FPS: -", TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudPing = new("TextLabel", { Size = UDim2.new(1, -12, 0, 15), BackgroundTransparency = 1, Text = "Ping: -", TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudPos = new("TextLabel", { Size = UDim2.new(1, -12, 0, 15), BackgroundTransparency = 1, Text = "Pos: -", TextColor3 = Theme.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })

task.spawn(function()
	local placeName = "game " .. tostring(game.PlaceId)
	pcall(function() placeName = MPS:GetProductInfo(game.PlaceId).Name end)
	subtitle.Text = placeName .. "  ·  " .. LP.Name
end)

local frames = 0
task.spawn(function()
	while true do
		task.wait(1)
		if S.hud then
			hudFps.Text = "FPS: " .. frames
			local ping = 0
			pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			hudPing.Text = "Ping: " .. ping .. " ms"
			local hrp = getHRP()
			if hrp then
				hudPos.Text = string.format("Pos: %d, %d, %d", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
			end
		end
		frames = 0
	end
end)

task.spawn(function()
	while true do
		task.wait(0.2)
		pcall(function() hGrad.Rotation = (hGrad.Rotation + 3) % 360 end)
	end
end)

local cross = DrawingLib and DrawingLib.new and DrawingLib.new("Circle") or nil
if cross then
	cross.Filled = false
	cross.Thickness = 1.5
	cross.Color = Color3.fromRGB(255, 255, 255)
	cross.Transparency = 0.3
	cross.Visible = false
end
local fovCircle = DrawingLib and DrawingLib.new and DrawingLib.new("Circle") or nil
if fovCircle then
	fovCircle.Filled = false
	fovCircle.Thickness = 1.5
	fovCircle.Color = Theme.accent
	fovCircle.Transparency = 0.4
	fovCircle.Visible = false
end

local flyConn = RS.RenderStepped:Connect(function()
	frames = frames + 1
	local ok, err = pcall(function()
		local center = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)

		if S.hud ~= hud.Visible then hud.Visible = S.hud end
		if S.watermark ~= watermark.Visible then watermark.Visible = S.watermark end

		if cross then
			cross.Position = center
			cross.Radius = 6
			cross.Visible = S.crosshair
		end
		if fovCircle then
			fovCircle.Position = center
			fovCircle.Radius = S.aimFov
			fovCircle.Visible = S.aimbot
		end

		if S.noclip then
			local c = getChar()
			if c then
				for _, d in ipairs(c:GetDescendants()) do
					if d:IsA("BasePart") then d.CanCollide = false end
				end
			end
		end

		if S.hitbox then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LP then
					local hrp = hrpOf(p)
					if hrp and hrp.Size ~= Vector3.new(S.hitboxSize, S.hitboxSize, S.hitboxSize) then
						hrp.Size = Vector3.new(S.hitboxSize, S.hitboxSize, S.hitboxSize)
					end
				end
			end
		end

		local hum = getHum()
		if hum then
			if hum.WalkSpeed ~= S.speed then hum.WalkSpeed = S.speed end
		end

		if S.aimbot then
			local firing = S.aimAlways or UIS:IsKeyDown(S.aimKey)
			if firing then
				local _, tpos = findTarget()
				if tpos then
					local goal = CFrame.new(Cam.CFrame.Position, tpos)
					if S.aimSmooth <= 0.01 then
						Cam.CFrame = goal
					else
						Cam.CFrame = Cam.CFrame:Lerp(goal, 1 - S.aimSmooth)
					end
				end
			end
		end

		if S.trigger then
			local firing = UIS:IsKeyDown(S.triggerKey)
			if firing then
				local best = findTarget()
				if best then
					local c = getChar()
					local tool = c and c:FindFirstChildOfClass("Tool")
					if tool then pcall(function() tool:Activate() end) end
				end
			end
		end

		if S.espNames or S.espBox or S.espTracer or S.espHighlight then
			for _, p in ipairs(Players:GetPlayers()) do
				local c = p.Character
				local head = c and c:FindFirstChild("Head")
				local hrp = c and c:FindFirstChild("HumanoidRootPart")
				local alive = c and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").Health > 0

				if p ~= LP and head and hrp and alive then
					local col = roleColor(p)

					if S.espNames then
						local tag = head:FindFirstChild("KitiName")
						if not tag then
							tag = Instance.new("BillboardGui")
							tag.Name = "KitiName"
							tag.Size = UDim2.fromOffset(220, 40)
							tag.StudsOffset = Vector3.new(0, 2.6, 0)
							tag.AlwaysOnTop = true
							tag.Parent = head
							local lbl = Instance.new("TextLabel")
							lbl.Name = "L"
							lbl.Size = UDim2.fromScale(1, 1)
							lbl.BackgroundTransparency = 1
							lbl.Font = Enum.Font.GothamBold
							lbl.TextSize = 13
							lbl.TextStrokeTransparency = 0
							lbl.Parent = tag
						end
						local lbl = tag:FindFirstChild("L")
						lbl.Text = p.Name .. " [" .. roleOf(p) .. "]"
						lbl.TextColor3 = col
					else
						local tag = head:FindFirstChild("KitiName")
						if tag then tag:Destroy() end
					end

					if S.espHighlight then
						local hl = c:FindFirstChild("KitiHL")
						if not hl then
							hl = Instance.new("Highlight")
							hl.Name = "KitiHL"
							hl.FillTransparency = 0.6
							hl.OutlineTransparency = 0
							hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							hl.Parent = c
						end
						hl.FillColor = col
						hl.OutlineColor = col
					else
						local hl = c:FindFirstChild("KitiHL")
						if hl then hl:Destroy() end
					end

					if DrawingLib then
						local v = visuals[p]
						if not v then
							v = { box = DrawingLib.new("Square"), tracer = DrawingLib.new("Line") }
							v.box.Thickness = 1.5
							v.box.Filled = false
							v.tracer.Thickness = 1.5
							visuals[p] = v
						end
						v.box.Transparency = 0.2
						v.tracer.Transparency = 0.4
						v.box.Color = col
						v.tracer.Color = col

						local top = w2s(head.Position + Vector3.new(0, 0.7, 0))
						local bot = w2s(hrp.Position - Vector3.new(0, 3, 0))
						if top and bot and S.espBox then
							local h = math.abs(bot.Y - top.Y)
							local w = h * 0.55
							v.box.Position = Vector2.new(top.X - w / 2, math.min(top.Y, bot.Y))
							v.box.Size = Vector2.new(w, h)
							v.box.Visible = true
						else
							v.box.Visible = false
						end
						if top and S.espTracer then
							v.tracer.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y)
							v.tracer.To = Vector2.new(top.X, top.Y)
							v.tracer.Visible = true
						else
							v.tracer.Visible = false
						end
					end
				else
					if head then
						local tag = head:FindFirstChild("KitiName")
						if tag then tag:Destroy() end
					end
					if c then
						local hl = c:FindFirstChild("KitiHL")
						if hl then hl:Destroy() end
					end
					if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
				end
			end
		else
			for _, p in ipairs(Players:GetPlayers()) do
				local c = p.Character
				if c then
					local hl = c:FindFirstChild("KitiHL")
					if hl then hl:Destroy() end
					local head = c:FindFirstChild("Head")
					if head then local tag = head:FindFirstChild("KitiName"); if tag then tag:Destroy() end end
				end
				if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
			end
		end

		if S.fly then
			local hrp = getHRP()
			if hrp then
				if not hrp:FindFirstChild("KitiFly") then
					local bv = Instance.new("BodyVelocity"); bv.Name = "KitiFly"; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5); bv.Parent = hrp
					local bg = Instance.new("BodyGyro"); bg.Name = "KitiGyro"; bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5); bg.P = 3000; bg.Parent = hrp
				end
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
					if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
					if dir.Magnitude > 0 then bv.Velocity = dir.Unit * S.flySpeed else bv.Velocity = Vector3.new(0, 0, 0) end
				end
			end
		end
	end)
end)

UIS.JumpRequest:Connect(function()
	if S.infJump then
		local h = getHum()
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

LP.Idled:Connect(function()
	if S.antiAfk then
		VU:Button2Down(Vector2.new(0, 0), Cam.CFrame)
		task.wait(1)
		VU:Button2Up(Vector2.new(0, 0), Cam.CFrame)
	end
end)

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == S.menuKey and i.UserInputType == Enum.UserInputType.Keyboard then
		win.Visible = not win.Visible
	end
	if S.clickTp and i.UserInputType == Enum.UserInputType.MouseButton1 then
		local unitRay = Cam:ViewportPointToRay(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
		local ray = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
		local hit = workspace:FindPartOnRay(ray, LP.Character)
		local hrp = getHRP()
		if hit and hrp then hrp.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0)) end
	end
end)

headerBtn("–", -72, function()
	local collapsed = win.Size.Y.Offset <= 46
	TS:Create(win, TweenInfo.new(0.25), { Size = collapsed and UDim2.fromOffset(WIN_W, WIN_H) or UDim2.fromOffset(WIN_W, 44) }):Play()
	body.Visible = collapsed
end)
headerBtn("×", -40, function()
	sg:Destroy()
	print("[KITI-PROTO] closed")
end)

notify("KITI PROTO V2", "загружен. Клавиша меню: " .. S.menuKey.Name, 5)
print("[KITI-PROTO] V2 loaded")
