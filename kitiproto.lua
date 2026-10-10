local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local VU = game:GetService("VirtualUser")
local TPS = game:GetService("TeleportService")
local HS = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local MPS = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local PGUI = LP:WaitForChild("PlayerGui")
local env = (getgenv and getgenv()) or _G

for _, g in ipairs(PGUI:GetChildren()) do
	if g.Name == "KitiProtoV4" then g:Destroy() end
end

local T = {
	bg = Color3.fromRGB(244, 245, 251),
	card = Color3.fromRGB(255, 255, 255),
	panel = Color3.fromRGB(238, 240, 249),
	element = Color3.fromRGB(233, 236, 247),
	hover = Color3.fromRGB(220, 224, 240),
	text = Color3.fromRGB(28, 30, 46),
	sub = Color3.fromRGB(124, 128, 152),
	accent1 = Color3.fromRGB(126, 108, 255),
	accent2 = Color3.fromRGB(86, 198, 255),
	accent3 = Color3.fromRGB(255, 138, 214),
	off = Color3.fromRGB(203, 207, 224),
}

local function new(class, props, children)
	local o = Instance.new(class)
	if props then for k, v in pairs(props) do o[k] = v end end
	if children then for _, c in ipairs(children) do c.Parent = o end end
	return o
end

local function corner(par, r)
	return new("UICorner", { CornerRadius = r and UDim.new(0, r) or UDim.new(1, 0), Parent = par })
end

local function stroke(par, col, th, tr)
	return new("UIStroke", { Color = col or T.off, Thickness = th or 1, Transparency = tr or 0.4, Parent = par })
end

local function grad(par, c1, c2, rot)
	return new("UIGradient", { Color = ColorSequence.new(c1, c2), Rotation = rot or 0, Parent = par })
end

local sg = new("ScreenGui", {
	Name = "KitiProtoV4", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 2147483647, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PGUI,
})

local cfg = { sounds = true }

local sndHover = new("Sound", { SoundId = "rbxassetid://6895079852", Volume = 0.25, Parent = SoundService })
local sndClick = new("Sound", { SoundId = "rbxassetid://6895079853", Volume = 0.35, Parent = SoundService })
local sndOpen = new("Sound", { SoundId = "rbxassetid://6895079851", Volume = 0.4, Parent = SoundService })
local function playSnd(s)
	if not cfg.sounds then return end
	pcall(function() s.TimePosition = 0; s:Play() end)
end

local function clickSnd() playSnd(sndClick) end
local function hoverSnd() playSnd(sndHover) end

local notifHolder = new("Frame", { Name = "Notifs", Parent = sg, BackgroundTransparency = 1, Size = UDim2.new(0, 300, 0, 620), Position = UDim2.new(1, -314, 0, 14) })
new("UIListLayout", { Parent = notifHolder, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right })

local function notify(title, text, dur)
	dur = dur or 4
	local f = new("Frame", { Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = T.card, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = notifHolder })
	corner(f)
	local st = stroke(f, T.accent1, 1.2, 1)
	local bar = new("Frame", { Size = UDim2.new(0, 4, 1, -14), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0, Parent = f })
	corner(bar, 2)
	grad(bar, T.accent1, T.accent2, 90)
	local tl = new("TextLabel", { Size = UDim2.new(1, -24, 0, 20), Position = UDim2.fromOffset(16, 8), BackgroundTransparency = 1, Text = title, TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = f })
	local bl = new("TextLabel", { Size = UDim2.new(1, -24, 0, 18), Position = UDim2.fromOffset(16, 30), BackgroundTransparency = 1, Text = text, TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = f })
	playSnd(sndOpen)
	TS:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Quint), { BackgroundTransparency = 0 }):Play()
	TS:Create(st, TweenInfo.new(0.25), { Transparency = 0.55 }):Play()
	TS:Create(tl, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	TS:Create(bl, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	task.delay(dur, function()
		TS:Create(f, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		TS:Create(tl, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		TS:Create(bl, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		task.wait(0.32)
		f:Destroy()
	end)
end

local WIN_W, WIN_H = 700, 460

local shadow = new("Frame", { Size = UDim2.fromOffset(WIN_W + 8, WIN_H + 8), Position = UDim2.new(0.5, -WIN_W / 2 - 4, 0.5, -WIN_H / 2 + 6), BackgroundColor3 = Color3.fromRGB(150, 160, 200), BackgroundTransparency = 0.75, BorderSizePixel = 0, ZIndex = 0, Parent = sg })
corner(shadow, 18)

local win = new("Frame", { Size = UDim2.fromOffset(WIN_W, WIN_H), Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2), BackgroundColor3 = T.bg, BorderSizePixel = 0, Active = true, Draggable = true, ClipsDescendants = true, ZIndex = 1, Parent = sg })
corner(win, 18)
local winStroke = stroke(win, T.accent1, 1.4, 0.5)

local topbar = new("Frame", { Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = T.card, BorderSizePixel = 0, ZIndex = 2, Parent = win })
local logo = new("Frame", { Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(16, 10), BorderSizePixel = 0, ZIndex = 3, Parent = topbar })
corner(logo)
grad(logo, T.accent1, T.accent2, 30)
new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "K", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBlack, TextSize = 18, ZIndex = 4, Parent = logo })

local title = new("TextLabel", { Size = UDim2.new(0, 320, 0, 20), Position = UDim2.fromOffset(60, 9), BackgroundTransparency = 1, Text = "KITI · PROTO", TextColor3 = T.text, Font = Enum.Font.GothamBlack, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = topbar })
local subtitle = new("TextLabel", { Size = UDim2.new(0, 320, 0, 15), Position = UDim2.fromOffset(60, 30), BackgroundTransparency = 1, Text = "tablet edition · " .. LP.Name, TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = topbar })

local function topBtn(text, xoff, cb)
	local b = new("TextButton", { Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, xoff, 0.5, -15), BackgroundColor3 = T.element, Text = text, TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, ZIndex = 3, Parent = topbar })
	corner(b)
	b.MouseEnter:Connect(function() hoverSnd(); TS:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = T.hover }):Play() end)
	b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = T.element }):Play() end)
	b.MouseButton1Click:Connect(function() clickSnd(); pcall(cb) end)
	return b
end

local tabbar = new("ScrollingFrame", { Size = UDim2.new(1, -32, 0, 40), Position = UDim2.fromOffset(16, 62), BackgroundColor3 = T.card, BorderSizePixel = 0, ZIndex = 2, Parent = win, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollingEnabled = true })
corner(tabbar, 12)
new("UIListLayout", { Parent = tabbar, Padding = UDim.new(0, 4), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder })
new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = tabbar })

local content = new("Frame", { Size = UDim2.new(1, -32, 1, -122), Position = UDim2.fromOffset(16, 110), BackgroundColor3 = T.card, BorderSizePixel = 0, ZIndex = 2, Parent = win })
corner(content, 14)

local shine = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 50, Parent = win })
corner(shine, 18)
local shineGrad = new("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 0.85), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.55, 0.85), NumberSequenceKeypoint.new(1, 1) }), Rotation = 20, Parent = shine })

local pages = {}
local current

local function addTab(name, icon)
	local btn = new("TextButton", { Size = UDim2.new(0, 92, 0, 34), BackgroundColor3 = T.element, BackgroundTransparency = 1, Text = (icon and icon .. " " or "") .. name, TextColor3 = T.sub, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, Parent = tabbar })
	corner(btn)
	local page = new("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = content })
	new("UIListLayout", { Parent = page, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
	new("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), PaddingBottom = UDim.new(0, 14), Parent = page })
	local tab = { btn = btn, page = page }
	pages[#pages + 1] = tab
	local function select()
		for _, t in ipairs(pages) do
			local on = (t == tab)
			t.page.Visible = on
			t.btn.BackgroundTransparency = on and 0 or 1
			t.btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or T.sub
			if on then
				t.btn.BackgroundColor3 = T.accent1
				local g = t.btn:FindFirstChildOfClass("UIGradient")
				if not g then g = grad(t.btn, T.accent1, T.accent2, 30) end
			end
		end
	end
	btn.MouseEnter:Connect(function() if current ~= tab then hoverSnd() end end)
	btn.MouseButton1Click:Connect(function()
		current = tab
		clickSnd()
		select()
	end)
	if not current then current = tab; select() end
	return page
end

local searchBox = new("TextBox", { Size = UDim2.fromOffset(180, 32), Position = UDim2.new(1, -292, 0.5, -16), BackgroundColor3 = T.element, PlaceholderText = "поиск функций...", PlaceholderColor3 = T.sub, Text = "", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = false, ZIndex = 3, Parent = topbar })
corner(searchBox)
new("UIPadding", { PaddingLeft = UDim.new(0, 14), Parent = searchBox })

local function applySearch(q)
	q = string.lower(q or "")
	for _, t in ipairs(pages) do
		for _, el in ipairs(t.page:GetChildren()) do
			if el:GetAttribute("isSec") then
				el.Visible = true
			elseif el:GetAttribute("kw") ~= nil then
				el.Visible = (q == "" or string.find(el:GetAttribute("kw"), q, 1, true) ~= nil)
			end
		end
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function() applySearch(searchBox.Text) end)

local function addSection(page, text)
	local el = new("TextLabel", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = string.upper(text), TextColor3 = T.accent1, Font = Enum.Font.GothamBlack, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = page })
	el:SetAttribute("isSec", true)
	return el
end

local function addDivider(page)
	local el = new("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = T.off, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = page })
	el:SetAttribute("kw", "")
	return el
end

local function addButton(page, text, cb)
	local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.element, Text = "  " .. text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = page })
	corner(b)
	b.MouseEnter:Connect(function() hoverSnd(); TS:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Quint), { BackgroundColor3 = T.hover }):Play() end)
	b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = T.element }):Play() end)
	b.MouseButton1Click:Connect(function()
		clickSnd()
		TS:Create(b, TweenInfo.new(0.08), { BackgroundColor3 = T.accent1 }):Play()
		task.delay(0.1, function() TS:Create(b, TweenInfo.new(0.2), { BackgroundColor3 = T.hover }):Play() end)
		local ok, err = pcall(cb)
		if not ok then notify("Ошибка", tostring(err), 5) end
	end)
	b:SetAttribute("kw", string.lower(text))
	return b
end

local function addToggle(page, text, def, cb)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.element, Parent = page })
	corner(row)
	row:SetAttribute("kw", string.lower(text))
	new("TextLabel", { Size = UDim2.new(1, -80, 1, 0), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1, Text = text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
	local track = new("Frame", { Size = UDim2.fromOffset(44, 22), Position = UDim2.new(1, -58, 0.5, -11), BackgroundColor3 = T.off, BorderSizePixel = 0, Parent = row })
	corner(track)
	local fillg = grad(track, T.accent1, T.accent2, 20)
	fillg.Enabled = false
	local knob = new("Frame", { Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = track })
	corner(knob)
	local on = def or false
	local function paint(anim)
		local gp = on and UDim2.fromOffset(24, 2) or UDim2.fromOffset(2, 2)
		if anim then
			TS:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Position = gp }):Play()
		else
			knob.Position = gp
		end
		fillg.Enabled = on
		track.BackgroundColor3 = on and T.accent1 or T.off
	end
	paint(false)
	local hit = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = row })
	hit.MouseEnter:Connect(function() hoverSnd() end)
	hit.MouseButton1Click:Connect(function()
		on = not on
		clickSnd()
		paint(true)
		local ok, err = pcall(cb, on)
		if not ok then notify("Ошибка", tostring(err), 5) end
	end)
	return { Set = function(v, quiet) on = v; paint(true); if not quiet then pcall(cb, on) end end }
end

local function addSlider(page, text, mn, mx, def, cb, dec)
	dec = dec or 0
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = T.element, Parent = page })
	corner(row)
	row:SetAttribute("kw", string.lower(text))
	new("TextLabel", { Size = UDim2.new(1, -100, 0, 22), Position = UDim2.fromOffset(14, 6), BackgroundTransparency = 1, Text = text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
	local vlab = new("TextLabel", { Size = UDim2.fromOffset(80, 22), Position = UDim2.new(1, -94, 0, 6), BackgroundTransparency = 1, Text = tostring(def), TextColor3 = T.accent1, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = row })
	local track = new("TextButton", { Size = UDim2.new(1, -28, 0, 8), Position = UDim2.new(0, 14, 0, 36), BackgroundColor3 = T.off, Text = "", AutoButtonColor = false, Parent = row })
	corner(track)
	local fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0, Active = false, Parent = track })
	corner(fill)
	grad(fill, T.accent1, T.accent2, 0)
	local dot = new("Frame", { Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Active = false, Parent = track })
	corner(dot)
	stroke(dot, T.accent1, 1, 0.2)
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
	return { Set = function(v, quiet) val = math.clamp(v, mn, mx); upd(); if not quiet then pcall(cb, val) end end }
end

local function addDropdown(page, text, options, def, cb)
	local IH = 30
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.element, Parent = page })
	corner(row)
	row:SetAttribute("kw", string.lower(text))
	local head = new("TextButton", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, Text = "", Parent = row })
	new("TextLabel", { Size = UDim2.new(1, -170, 0, 38), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1, Text = text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = head })
	local cur = new("TextLabel", { Size = UDim2.fromOffset(120, 38), Position = UDim2.new(1, -160, 0, 0), BackgroundTransparency = 1, Text = def or (options[1] or "-"), TextColor3 = T.accent1, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = head })
	local arrow = new("TextLabel", { Size = UDim2.fromOffset(20, 38), Position = UDim2.new(1, -28, 0, 0), BackgroundTransparency = 1, Text = "v", TextColor3 = T.sub, Font = Enum.Font.GothamBold, TextSize = 13, Parent = head })
	local open = false
	local opts = {}
	for i, opt in ipairs(options) do
		local ob = new("TextButton", { Size = UDim2.new(1, -24, 0, IH - 2), Position = UDim2.fromOffset(12, 38 + (i - 1) * IH), BackgroundColor3 = T.panel, Text = "  " .. opt, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, AutoButtonColor = false, Parent = row })
		corner(ob)
		opts[i] = ob
		ob.MouseEnter:Connect(function() hoverSnd(); ob.BackgroundColor3 = T.hover end)
		ob.MouseLeave:Connect(function() ob.BackgroundColor3 = T.panel end)
		ob.MouseButton1Click:Connect(function()
			clickSnd(); cur.Text = opt
			for _, o in ipairs(opts) do o.Visible = false end
			open = false; arrow.Text = "v"; row.Size = UDim2.new(1, 0, 0, 38)
			pcall(cb, opt)
		end)
	end
	head.MouseEnter:Connect(function() hoverSnd() end)
	head.MouseButton1Click:Connect(function()
		clickSnd(); open = not open
		for _, o in ipairs(opts) do o.Visible = open end
		arrow.Text = open and "^" or "v"
		row.Size = UDim2.new(1, 0, 0, open and (38 + #options * IH) or 38)
	end)
	return { Set = function(v) cur.Text = v end }
end

local function addBox(page, placeholder, cb)
	local box = new("TextBox", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = T.element, PlaceholderText = placeholder, PlaceholderColor3 = T.sub, Text = "", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = false, Parent = page })
	corner(box)
	box:SetAttribute("kw", string.lower(placeholder))
	new("UIPadding", { PaddingLeft = UDim.new(0, 12), Parent = box })
	box.FocusLost:Connect(function(enter) if enter then clickSnd(); pcall(cb, box.Text) end end)
	return box
end

local function getChar() return LP.Character end
local function getHRP() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function hrpOf(p) local c = p and p.Character; return c and c:FindFirstChild("HumanoidRootPart") end

local S = {
	speed = 16, jump = 50, menuKey = Enum.KeyCode.RightControl,
	fly = false, flySpeed = 60, noclip = false, infJump = false, antiAfk = false,
	fullbright = false, clockLock = false, clock = 14,
	fog = false, fogEnd = 350, fogColor = Color3.fromRGB(255, 255, 255),
	haze = false, hazeVal = 0.3,
	beauty = false, sat = 0.15, bloomI = 0.9, sunraysOn = true, dofOn = false,
	rainbow = false, trail = false, fire = false, godMode = false, autoRespawn = false, freeze = false,
	espNames = false, espHighlight = false, espRole = true, xray = false, rainbowEsp = false, espInfo = false,
	rainbowWorld = false, drunk = false, soundId = 0,
	aimbot = false, aimAlways = false, aimKey = Enum.KeyCode.E, aimFov = 150, aimPart = "Head", aimSmooth = 0.5,
	trigger = false, triggerKey = Enum.KeyCode.Q, hitbox = false, hitboxSize = 6,
	autoClick = false, autoClickDelay = 0.1,
	fov = 70, thirdPerson = false, camMin = 0.5, camMax = 12,
	clickTp = false, hud = true, watermark = true, crosshair = false, hudExtra = true,
}

local DrawingLib = Drawing
local visuals = {}

local function clearVisual(v)
	if v.box then v.box:Remove() end
	if v.tracer then v.tracer:Remove() end
end

Players.PlayerRemoving:Connect(function(p)
	if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
end)

local function w2s(pos)
	local sp, on = Cam:WorldToViewportPoint(pos)
	if not on then return nil end
	return Vector2.new(sp.X, sp.Y), sp.Z
end

local function roleOf(p)
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
	return scan(p.Character) or scan(p:FindFirstChild("Backpack")) or "INNOCENT"
end

local function roleColor(p)
	if not S.espRole then return Color3.fromRGB(255, 80, 80) end
	local r = roleOf(p)
	if r == "MURDERER" then return Color3.fromRGB(240, 70, 70) end
	if r == "SHERIFF" then return Color3.fromRGB(70, 150, 255) end
	return Color3.fromRGB(70, 220, 120)
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

local atmosphere = nil
local colorCorr = nil
local bloom = nil
local dof = nil
local sunrays = nil

local function ensureEffects()
	if not atmosphere then atmosphere = new("Atmosphere", { Parent = Lighting }) end
	if not colorCorr then colorCorr = new("ColorCorrectionEffect", { Parent = Lighting }) end
	if not bloom then bloom = new("BloomEffect", { Parent = Lighting }) end
	if not dof then dof = new("DepthOfFieldEffect", { Parent = Lighting }) end
	if not sunrays then sunrays = new("SunRaysEffect", { Parent = Lighting }) end
end

local SKY_FACES = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" }
local SKY_SETS = {
	["Космос"] = { 159454299, 159454296, 159454293, 159454286, 159454300, 159454288 },
	["Галактика"] = { 159454299, 159454299, 159454299, 159454299, 159454299, 159454299 },
}

local function getSky()
	local sky = Lighting:FindFirstChildOfClass("Sky")
	if not sky then sky = new("Sky", { Parent = Lighting }) end
	return sky
end

local function applySkySet(set)
	local sky = getSky()
	sky.SkyboxOrientation = Vector3.new(0, 0, 0)
	for i = 1, 6 do
		local id = set[i]
		pcall(function() sky[SKY_FACES[i]] = "rbxassetid://" .. tostring(id) end)
	end
	return sky
end

local function clearSky()
	local sky = Lighting:FindFirstChildOfClass("Sky")
	if sky then sky:Destroy() end
end

local function setMood(mode)
	ensureEffects()
	atmosphere.Density = 0; atmosphere.Haze = 0; atmosphere.Glare = 0
	Lighting.FogStart = 0; Lighting.FogEnd = 100000
	if mode == "День" then
		clearSky()
		Lighting.ClockTime = 14; Lighting.Brightness = 2.2
		Lighting.Ambient = Color3.fromRGB(140, 140, 140); Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
		colorCorr.TintColor = Color3.fromRGB(255, 255, 255); colorCorr.Saturation = 0
	elseif mode == "Закат" then
		clearSky()
		Lighting.ClockTime = 17.4; Lighting.Brightness = 1.8
		Lighting.Ambient = Color3.fromRGB(150, 110, 95); Lighting.OutdoorAmbient = Color3.fromRGB(210, 130, 95)
		Lighting.FogColor = Color3.fromRGB(255, 170, 120); Lighting.FogEnd = 900
		atmosphere.Color = Color3.fromRGB(255, 190, 150); atmosphere.Density = 0.28
		colorCorr.TintColor = Color3.fromRGB(255, 225, 200); colorCorr.Saturation = 0.12
	elseif mode == "Ночь" then
		clearSky()
		Lighting.ClockTime = 0; Lighting.Brightness = 0.8
		Lighting.Ambient = Color3.fromRGB(55, 60, 95); Lighting.OutdoorAmbient = Color3.fromRGB(40, 45, 80)
		colorCorr.TintColor = Color3.fromRGB(200, 210, 255); colorCorr.Saturation = 0
	elseif mode == "Космос" then
		local sky = applySkySet(SKY_SETS["Космос"])
		sky.StarCount = 0; sky.CelestialBodiesShown = false
		Lighting.ClockTime = 0; Lighting.Brightness = 0.4
		Lighting.Ambient = Color3.fromRGB(40, 40, 70); Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 60)
		colorCorr.TintColor = Color3.fromRGB(190, 200, 255); colorCorr.Saturation = 0.2
		Lighting.ExposureCompensation = 0.2
	elseif mode == "Галактика" then
		local sky = applySkySet(SKY_SETS["Галактика"])
		sky.StarCount = 0; sky.CelestialBodiesShown = false
		Lighting.ClockTime = 0; Lighting.Brightness = 0.5
		Lighting.Ambient = Color3.fromRGB(50, 45, 85); Lighting.OutdoorAmbient = Color3.fromRGB(45, 40, 90)
		colorCorr.TintColor = Color3.fromRGB(210, 190, 255); colorCorr.Saturation = 0.25
	elseif mode == "Неон" then
		clearSky()
		Lighting.ClockTime = 2; Lighting.Brightness = 2.2
		Lighting.Ambient = Color3.fromRGB(60, 40, 90); Lighting.OutdoorAmbient = Color3.fromRGB(50, 30, 80)
		Lighting.FogColor = Color3.fromRGB(120, 60, 200); Lighting.FogEnd = 450
		atmosphere.Color = Color3.fromRGB(150, 80, 255); atmosphere.Density = 0.35
		colorCorr.TintColor = Color3.fromRGB(200, 150, 255); colorCorr.Saturation = 0.4
	end
	notify("Небо", mode, 2)
end

local mov = addTab("Движение", "➤")
addSection(mov, "Скорость")
addSlider(mov, "WalkSpeed", 16, 500, 16, function(v) S.speed = v end)
addSlider(mov, "JumpPower", 50, 500, 50, function(v) S.jump = v; local h = getHum(); if h then h.UseJumpPower = true; h.JumpPower = v end end)
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
addDivider(mov)
addSection(mov, "Прочее")
addToggle(mov, "Noclip (сквозь стены)", false, function(on) S.noclip = on end)
addToggle(mov, "Anti-AFK", false, function(on) S.antiAfk = on end)
addToggle(mov, "Click TP (лкм)", false, function(on) S.clickTp = on; notify("Click TP", on and "вкл" or "выкл", 2) end)
addButton(mov, "Reset персонажа", function() local h = getHum(); if h then h.Health = 0 end end)
addDivider(mov)
addSection(mov, "Телепорт")
addBox(mov, "X (число) + Enter", function(t) S.tpX = tonumber(t) end)
addBox(mov, "Y (число) + Enter", function(t) S.tpY = tonumber(t) end)
addBox(mov, "Z (число) + Enter", function(t) S.tpZ = tonumber(t) end)
addButton(mov, "📍 Телепорт по координатам", function()
	local hrp = getHRP()
	if hrp and S.tpX and S.tpY and S.tpZ then hrp.CFrame = CFrame.new(S.tpX, S.tpY, S.tpZ); notify("Телепорт", "готово", 2)
	else notify("Телепорт", "введи X, Y и Z", 3) end
end)
addButton(mov, "⬆ Вверх на 50", function() local hrp = getHRP(); if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0) end end)
addButton(mov, "⬇ Вниз на 50", function() local hrp = getHRP(); if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0, 50, 0) end end)
addDivider(mov)
addSection(mov, "Дополнительно")
addToggle(mov, "❄ Заморозить себя", false, function(on) S.freeze = on; local hrp = getHRP(); if hrp then hrp.Anchored = on end end)
addToggle(mov, "♻ Авто-респавн", false, function(on) S.autoRespawn = on; Players.RespawnTime = on and 0 or 5 end)
addToggle(mov, "🛡 God Mode (клиент)", false, function(on)
	S.godMode = on
	local h = getHum()
	if h and on then h.MaxHealth = 9e9; h.Health = 9e9 end
end)
addSlider(mov, "Гравитация мира", 0, 300, 196, function(v) workspace.Gravity = v end)
addSlider(mov, "Высота бедра (HipHeight)", 0, 20, 2, function(v) local h = getHum(); if h then h.HipHeight = v end end, 1)

local vis = addTab("Мир", "◍")
addSection(vis, "Небо")
addButton(vis, "☀ День", function() setMood("День") end)
addButton(vis, "🌅 Закат", function() setMood("Закат") end)
addButton(vis, "🌙 Ночь", function() setMood("Ночь") end)
addButton(vis, "🌌 Космос", function() setMood("Космос") end)
addButton(vis, "🪐 Галактика", function() setMood("Галактика") end)
addButton(vis, "🟣 Неон", function() setMood("Неон") end)
addButton(vis, "↩ Сбросить небо", function() clearSky(); notify("Небо", "сброшено", 2) end)
addBox(vis, "Skybox ID (текстура на все стороны) + Enter", function(id)
	if id ~= "" then
		local url = "rbxassetid://" .. id:gsub("%D", "")
		local sky = Lighting:FindFirstChildOfClass("Sky")
		if not sky then sky = new("Sky", { Parent = Lighting }) end
		for _, prop in ipairs({ "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" }) do
			pcall(function() sky[prop] = url end)
		end
		notify("Скайбокс", "применён " .. url, 3)
	end
end)
addDivider(vis)
addSection(vis, "Туман")
addToggle(vis, "Туман вкл/выкл", false, function(on)
	S.fog = on
	if not on then Lighting.FogStart = 0; Lighting.FogEnd = 100000 end
	notify("Туман", on and "включён" or "выключен", 2)
end)
addSlider(vis, "Плотность (меньше = гуще)", 20, 5000, 350, function(v) S.fogEnd = v end)
addButton(vis, "Туман: белый", function() S.fogColor = Color3.fromRGB(255, 255, 255) end)
addButton(vis, "Туман: синий", function() S.fogColor = Color3.fromRGB(90, 130, 220) end)
addButton(vis, "Туман: фиолетовый", function() S.fogColor = Color3.fromRGB(150, 80, 220) end)
addButton(vis, "Туман: зелёный", function() S.fogColor = Color3.fromRGB(70, 200, 120) end)
addButton(vis, "Туман: чёрный", function() S.fogColor = Color3.fromRGB(0, 0, 0) end)
addToggle(vis, "Дымка (атмосфера)", false, function(on) S.haze = on end)
addSlider(vis, "Плотность дымки", 0, 1, 0.3, function(v) S.hazeVal = v end, 2)
addDivider(vis)
addSection(vis, "Освещение")
addToggle(vis, "Fullbright", false, function(on)
	S.fullbright = on
	if on then
		Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(160, 160, 160); Lighting.FogEnd = 100000
	else
		Lighting.Brightness = 2; Lighting.GlobalShadows = true
	end
end)
addToggle(vis, "Зафиксировать время суток", false, function(on) S.clockLock = on; if on then Lighting.ClockTime = S.clock end end)
addSlider(vis, "Время суток", 0, 24, 14, function(v) S.clock = v; if S.clockLock then Lighting.ClockTime = v end end, 1)

local me = addTab("Персонаж", "☺")
addSection(me, "Внешность")
addButton(me, "🩷 Сделать неоновым", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Material = Enum.Material.Neon end
	end
	notify("Персонаж", "материал: Neon", 2)
end)
addButton(me, "💠 Стеклянный", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Material = Enum.Material.Glass; d.Transparency = 0.5 end
	end
	notify("Персонаж", "материал: Glass", 2)
end)
addButton(me, "✨ ForceField", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Material = Enum.Material.ForceField end
	end
	notify("Персонаж", "материал: ForceField", 2)
end)
addButton(me, "🌫 Убрать эффекты материала", function()
	local c = getChar(); if not c then return end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") then d.Material = Enum.Material.Plastic end
	end
end)
addButton(me, "🔴 Красный", function() local c = getChar(); if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Color = Color3.fromRGB(230, 60, 60) end end end end)
addButton(me, "🔵 Синий", function() local c = getChar(); if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Color = Color3.fromRGB(60, 120, 255) end end end end)
addButton(me, "🟢 Зелёный", function() local c = getChar(); if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Color = Color3.fromRGB(70, 220, 120) end end end end)
addButton(me, "⚪ Белый", function() local c = getChar(); if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Color = Color3.fromRGB(240, 240, 245) end end end end)
addDivider(me)
addSection(me, "Размер и вид")
addButton(me, "🐜 Крошка", function()
	local c = getChar(); local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then h.BodyWidthScale = 0.4; h.BodyHeightScale = 0.4; h.BodyDepthScale = 0.4; h.HeadScale = 0.6 end
end)
addButton(me, "🦖 Гигант", function()
	local c = getChar(); local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then h.BodyWidthScale = 2.5; h.BodyHeightScale = 2.5; h.BodyDepthScale = 2.5; h.HeadScale = 2 end
end)
addButton(me, "↩ Обычный размер", function()
	local c = getChar(); local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then h.BodyWidthScale = 1; h.BodyHeightScale = 1; h.BodyDepthScale = 1; h.HeadScale = 1 end
end)
addButton(me, "🧹 Убрать все аксессуары", function()
	local c = getChar()
	if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("Accessory") or d:IsA("Accoutrement") or d:IsA("Hat") then d:Destroy() end end end
	notify("Персонаж", "аксессуары убраны", 2)
end)
addButton(me, "👯 Копировать внешность ближайшего", function()
	local best, bd
	local myhrp = getHRP()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local phrp = p.Character:FindFirstChild("HumanoidRootPart")
			if myhrp and phrp then
				local d = (myhrp.Position - phrp.Position).Magnitude
				if not bd or d < bd then bd = d; best = p end
			end
		end
	end
	local c = getChar(); local h = c and c:FindFirstChildOfClass("Humanoid")
	if best and best.Character and h and c then
		local bh = best.Character:FindFirstChildOfClass("Humanoid")
		if bh then
			h.BodyWidthScale = bh.BodyWidthScale; h.BodyHeightScale = bh.BodyHeightScale
			h.BodyDepthScale = bh.BodyDepthScale; h.HeadScale = bh.HeadScale
		end
		for _, d in ipairs(best.Character:GetDescendants()) do
			if d:IsA("Accessory") or d:IsA("Accoutrement") then
				local cl = d:Clone(); cl.Parent = c
				local ap = cl:FindFirstChildWhichIsA("BasePart")
				local head = c:FindFirstChild("Head")
				if ap and head then
					local w = new("WeldConstraint", { Parent = ap }); w.Part0 = head; w.Part1 = ap; ap.CFrame = head.CFrame
				end
			end
		end
		notify("Персонаж", "скопировано с " .. best.Name, 2)
	else
		notify("Персонаж", "игроки рядом не найдены", 3)
	end
end)
addButton(me, "💃 Танец", function()
	local c = getChar(); local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then
		local a = new("Animation", { AnimationId = "rbxassetid://507771019", Parent = h })
		local t = h:FindFirstChildOfClass("Animator"); if not t then t = new("Animator", { Parent = h }) end
		pcall(function() t:LoadAnimation(a):Play() end)
	end
end)
addToggle(me, "🌈 Радужный персонаж", false, function(on) S.rainbow = on end)
addToggle(me, "✨ Шлейф частиц", false, function(on) S.trail = on end)
addToggle(me, "🔥 Огонь на персонаже", false, function(on) S.fire = on end)
addDivider(me)
addSection(me, "Шляпа / аксессуар")
addToggle(me, "🎩 Копировать шапки с игрока", false, function(on)
	S.copyHats = on
	if not on then
		local c = getChar()
		if c then for _, d in ipairs(c:GetChildren()) do if d:IsA("Accessory") or d:IsA("Hat") then d:Destroy() end end end
	end
end)
addButton(me, "Надеть аксессуар по ID", function()
	local c = getChar(); local head = c and c:FindFirstChild("Head")
	if not head then return end
	local ok, model = pcall(function() return InsertService:LoadAsset(S.hatId or 0) end)
	if ok and model then
		local hat = model:GetChildren()[1]
		if hat then
			hat.Parent = head
			local att = hat:FindFirstChildOfClass("Attachment") or hat:FindFirstChild("HatAttachment")
			local weld = new("WeldConstraint", { Parent = hat })
			weld.Part0 = head
			weld.Part1 = hat:IsA("BasePart") and hat or hat:FindFirstChildWhichIsA("BasePart")
			notify("Шляпа", "надета", 3)
		end
	else
		notify("Шляпа", "не удалось (нужен ID и права)", 4)
	end
end)
addBox(me, "ID аксессуара (число) + Enter", function(txt) S.hatId = tonumber(txt:gsub("%D", "")) or 0; notify("Шляпа", "ID = " .. tostring(S.hatId), 2) end)
addDivider(me)
addSection(me, "Камера")
addSlider(me, "FOV (обзор)", 40, 120, 70, function(v) S.fov = v; Cam.FieldOfView = v end)
addSlider(me, "Мин. зум", 0.5, 30, 0.5, function(v) S.camMin = v; LP.CameraMinZoomDistance = v end, 1)
addSlider(me, "Макс. зум (отдаление)", 4, 120, 12, function(v) S.camMax = v; LP.CameraMaxZoomDistance = v end, 1)
addToggle(me, "От первого лица", false, function(on)
	LP.CameraMode = on and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
	notify("Камера", on and "1-е лицо" or "3-е лицо", 2)
end)

local cmb = addTab("Бой", "✦")
addSection(cmb, "Aimbot")
addToggle(cmb, "Aimbot", false, function(on) S.aimbot = on end)
addToggle(cmb, "Всегда целиться", false, function(on) S.aimAlways = on end)
addSlider(cmb, "FOV", 20, 400, 150, function(v) S.aimFov = v end)
addSlider(cmb, "Плавность", 0, 1, 0.5, function(v) S.aimSmooth = v end, 2)
addDropdown(cmb, "Часть тела", { "Head", "HumanoidRootPart", "UpperTorso" }, "Head", function(v) S.aimPart = v end)
addDivider(cmb)
addSection(cmb, "Триггер и хитбоксы")
addToggle(cmb, "Triggerbot", false, function(on) S.trigger = on end)
addToggle(cmb, "Расширить хитбоксы", false, function(on)
	S.hitbox = on
	if not on then for _, p in ipairs(Players:GetPlayers()) do local hrp = hrpOf(p); if hrp then hrp.Size = Vector3.new(2, 2, 1) end end end
end)
addSlider(cmb, "Размер хитбокса", 2, 15, 6, function(v) S.hitboxSize = v end)
addDivider(cmb)
addSection(cmb, "Авто-кликер")
addToggle(cmb, "Авто-клик (левая кнопка)", false, function(on) S.autoClick = on end)
addSlider(cmb, "Задержка (сек)", 0.01, 1, 0.1, function(v) S.autoClickDelay = v end, 2)

local vis2 = addTab("Визуал", "◎")
addSection(vis2, "Подсветка игроков")
addToggle(vis2, "ESP имена", false, function(on) S.espNames = on end)
addToggle(vis2, "ESP: HP и дистанция", false, function(on) S.espInfo = on end)
addToggle(vis2, "ESP подсветка", false, function(on) S.espHighlight = on end)
addToggle(vis2, "Цвет по роли (MM2)", true, function(on) S.espRole = on end)
addToggle(vis2, "ESP боксы", false, function(on)
	if on and not DrawingLib then notify("ESP", "Drawing недоступен", 5); return end
	S.espBox = on
end)
addToggle(vis2, "ESP трассеры", false, function(on)
	if on and not DrawingLib then notify("ESP", "Drawing недоступен", 5); return end
	S.espTracer = on
end)
addDivider(vis2)
addSection(vis2, "HUD")
addToggle(vis2, "Watermark", true, function(on) S.watermark = on end)
addToggle(vis2, "HUD (FPS/ping/коорд.)", true, function(on) S.hud = on end)
addToggle(vis2, "Прицел (crosshair)", false, function(on) S.crosshair = on end)
addDivider(vis2)
addSection(vis2, "Мир и HUD")
addToggle(vis2, "🌈 Радужный ESP", false, function(on) S.rainbowEsp = on end)
addToggle(vis2, "X-Ray (прозрачные стены)", false, function(on)
	S.xray = on
	if not on then
		pcall(function()
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("BasePart") then
					local o = d:GetAttribute("KitiOrigT")
					if o ~= nil then d.Transparency = o; d:SetAttribute("KitiOrigT", nil) end
				end
			end
		end)
	end
	notify("X-Ray", on and "включён" or "выключен", 2)
end)
addToggle(vis2, "HUD: время и игроки", true, function(on) S.hudExtra = on end)

local perf = addTab("Бусты", "⚡")
addSection(perf, "Производительность")
addButton(perf, "⚡ Boost FPS (убрать тени/эффекты)", function()
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 100000
		for _, v in ipairs(Lighting:GetChildren()) do
			if v:IsA("PostEffect") or v:IsA("Atmosphere") then v.Enabled = false end
		end
	end)
	local c = getChar()
	if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.CastShadow = false end end end
	notify("FPS", "оптимизация включена", 3)
end)
addDivider(perf)
addSection(perf, "Красота (кинематограф)")
addToggle(perf, "✨ Boost красоты", false, function(on)
	S.beauty = on
	if not on then
		pcall(function()
			local a = Lighting:FindFirstChildOfClass("Atmosphere"); if a then a.Density = 0 end
			local b = Lighting:FindFirstChildOfClass("BloomEffect"); if b then b.Intensity = 0 end
			local dd = Lighting:FindFirstChildOfClass("DepthOfFieldEffect"); if dd then dd.FarIntensity = 0; dd.NearIntensity = 0 end
			local s = Lighting:FindFirstChildOfClass("SunRaysEffect"); if s then s.Intensity = 0 end
		end)
	end
	notify("Красота", on and "включена" or "выключена", 2)
end)
addSlider(perf, "Насыщенность", 0, 1, 0.15, function(v) S.sat = v end, 2)
addSlider(perf, "Свечение (bloom)", 0, 3, 0.9, function(v) S.bloomI = v end, 2)
addToggle(perf, "Лучи солнца", true, function(on) S.sunraysOn = on end)
addToggle(perf, "Глубина резкости (DOF)", false, function(on) S.dofOn = on end)
addButton(perf, "↩ Сбросить эффекты", function()
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then v:Destroy() end
	end
	atmosphere, colorCorr, bloom, dof, sunrays = nil, nil, nil, nil, nil
	Lighting.EnvironmentDiffuseScale = 1; Lighting.EnvironmentSpecularScale = 1; Lighting.ExposureCompensation = 0
	notify("Эффекты", "сброшены", 2)
end)

local mg = addTab("Танчики", "🚀")
addSection(mg, "Мини-игра: ТАНЧИКИ")
local info = new("TextLabel", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "Управление: W/A/S/D — движение, Space — выстрел. Уничтожай врагов!", TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = mg })
local field = new("Frame", { Size = UDim2.fromOffset(560, 250), BackgroundColor3 = Color3.fromRGB(16, 18, 28), BorderSizePixel = 0, ClipsDescendants = true, Parent = mg })
corner(field, 12)
local scoreLbl = new("TextLabel", { Size = UDim2.fromOffset(200, 24), Position = UDim2.fromOffset(12, 6), BackgroundTransparency = 1, Text = "Счёт: 0", TextColor3 = Color3.fromRGB(140, 255, 200), Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 20, Parent = field })
local hpLbl = new("TextLabel", { Size = UDim2.fromOffset(200, 24), Position = UDim2.new(1, -212, 0, 6), BackgroundTransparency = 1, Text = "HP: 100", TextColor3 = Color3.fromRGB(255, 140, 140), Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 20, Parent = field })
local overLbl = new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBlack, TextSize = 30, ZIndex = 40, Visible = false, Parent = field })

local tank = { x = 280, y = 210, r = 13, cd = 0 }
local tankBody = new("Frame", { Size = UDim2.fromOffset(26, 26), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(90, 200, 255), BorderSizePixel = 0, ZIndex = 10, Parent = field })
corner(tankBody)
local tankBarrel = new("Frame", { Size = UDim2.fromOffset(4, 16), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(200, 240, 255), BorderSizePixel = 0, ZIndex = 11, Parent = tankBody })

local enemies = {}
local bullets = {}
local score = 0
local hp = 100
local mgActive = false
local mgConn = nil
local spawnTimer = 0

local mgState = { running = false }

local function clearField()
	for _, e in ipairs(enemies) do e.f:Destroy() end
	for _, b in ipairs(bullets) do b.f:Destroy() end
	enemies = {}; bullets = {}
end

local function startTanks()
	if mgState.running then return end
	mgState.running = true
	clearField()
	score = 0; hp = 100; spawnTimer = 0
	tank.x, tank.y = 280, 210
	scoreLbl.Text = "Счёт: 0"; hpLbl.Text = "HP: 100"; overLbl.Text = ""
	scoreLbl.Visible = true; hpLbl.Visible = true; overLbl.Visible = false
	mgConn = RS.Heartbeat:Connect(function(dt)
		if not mgState.running then return end
		pcall(function()
			local sp = 190
			if UIS:IsKeyDown(Enum.KeyCode.W) then tank.y = math.max(16, tank.y - sp * dt) end
			if UIS:IsKeyDown(Enum.KeyCode.S) then tank.y = math.min(234, tank.y + sp * dt) end
			if UIS:IsKeyDown(Enum.KeyCode.A) then tank.x = math.max(16, tank.x - sp * dt) end
			if UIS:IsKeyDown(Enum.KeyCode.D) then tank.x = math.min(544, tank.x + sp * dt) end
			tank.cd = tank.cd - dt
			if UIS:IsKeyDown(Enum.KeyCode.Space) and tank.cd <= 0 then
				tank.cd = 0.22
				local b = new("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(160, 230, 255), BorderSizePixel = 0, ZIndex = 9, Parent = field })
				corner(b)
				table.insert(bullets, { f = b, x = tank.x, y = tank.y - 16, dx = 0, dy = -420, friendly = true })
			end
			tankBody.Position = UDim2.fromOffset(tank.x, tank.y)

			spawnTimer = spawnTimer - dt
			if spawnTimer <= 0 then
				spawnTimer = math.max(0.7, 2.2 - score * 0.05)
				local ex, ey
				local side = math.random(1, 3)
				if side == 1 then ex = 20; ey = math.random(20, 230)
				elseif side == 2 then ex = 540; ey = math.random(20, 230)
				else ex = math.random(20, 540); ey = 20 end
				local f = new("Frame", { Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(255, 90, 90), BorderSizePixel = 0, ZIndex = 10, Parent = field })
				corner(f)
				table.insert(enemies, { f = f, x = ex, y = ey, cd = math.random(10, 20) / 10 })
			end

			for i = #enemies, 1, -1 do
				local e = enemies[i]
				local dx, dy = tank.x - e.x, tank.y - e.y
				local d = math.sqrt(dx * dx + dy * dy)
				if d > 1 then
					local spd = 42 + score * 1.5
					e.x = e.x + dx / d * spd * dt
					e.y = e.y + dy / d * spd * dt
				end
				e.f.Position = UDim2.fromOffset(e.x, e.y)
				e.cd = e.cd - dt
				if e.cd <= 0 then
					e.cd = math.max(0.6, 1.6 - score * 0.03)
					local bx, by = tank.x - e.x, tank.y - e.y
					local bd = math.sqrt(bx * bx + by * by)
					if bd > 1 then
						local b = new("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(255, 200, 90), BorderSizePixel = 0, ZIndex = 9, Parent = field })
						corner(b)
						table.insert(bullets, { f = b, x = e.x, y = e.y, dx = bx / bd * 260, dy = by / bd * 260, friendly = false })
					end
				end
			end

			for i = #bullets, 1, -1 do
				local b = bullets[i]
				b.x = b.x + b.dx * dt
				b.y = b.y + b.dy * dt
				b.f.Position = UDim2.fromOffset(b.x, b.y)
				local dead = false
				if b.y < -10 or b.y > 260 or b.x < -10 or b.x > 570 then dead = true end
				if not dead and b.friendly then
					for j = #enemies, 1, -1 do
						local e = enemies[j]
						local dx, dy = e.x - b.x, e.y - b.y
						if dx * dx + dy * dy < 15 * 15 then
							e.f:Destroy(); table.remove(enemies, j)
							score = score + 1
							scoreLbl.Text = "Счёт: " .. score
							dead = true; break
						end
					end
				elseif not dead then
					local dx, dy = tank.x - b.x, tank.y - b.y
					if dx * dx + dy * dy < 15 * 15 then
						hp = hp - 20
						hpLbl.Text = "HP: " .. math.max(0, hp)
						dead = true
						if hp <= 0 then
							mgState.running = false
							overLbl.Text = "ИГРА ОКОНЧЕНА\nСчёт: " .. score
							overLbl.Visible = true
						end
					end
				end
				if dead then b.f:Destroy(); table.remove(bullets, i) end
			end
		end)
	end)
	notify("Танчики", "игра началась", 2)
end

local function stopTanks()
	mgState.running = false
	if mgConn then mgConn:Disconnect(); mgConn = nil end
	clearField()
	overLbl.Text = ""; overLbl.Visible = false
	notify("Танчики", "остановлено", 2)
end

addButton(mg, "▶ Запустить игру", function() startTanks() end)
addButton(mg, "■ Стоп", function() stopTanks() end)

local plr = addTab("Игроки", "👥")
addSection(plr, "Онлайн-игроки")
local plrBox = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = plr })
new("UIListLayout", { Parent = plrBox, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

local function buildPlayers()
	for _, c in ipairs(plrBox:GetChildren()) do if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end end
	local any = false
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			any = true
			local rowP = new("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = T.element, Parent = plrBox })
			corner(rowP)
			new("TextLabel", { Size = UDim2.new(1, -250, 1, 0), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1, Text = p.Name, TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = rowP })
			local tp = new("TextButton", { Size = UDim2.fromOffset(66, 30), Position = UDim2.new(1, -212, 0.5, -15), BackgroundColor3 = T.accent1, Text = "ТП", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, Parent = rowP })
			corner(tp)
			tp.MouseButton1Click:Connect(function()
				local hrp = getHRP(); local thrp = hrpOf(p)
				if hrp and thrp then hrp.CFrame = thrp.CFrame + Vector3.new(0, 3, 0); notify("Телепорт", "к " .. p.Name, 2) end
			end)
			local sp = new("TextButton", { Size = UDim2.fromOffset(70, 30), Position = UDim2.new(1, -140, 0.5, -15), BackgroundColor3 = T.element, Text = "Следить", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, Parent = rowP })
			corner(sp)
			sp.MouseButton1Click:Connect(function()
				local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
				if hum then Cam.CameraSubject = hum; notify("Камера", "слежу за " .. p.Name, 2) end
			end)
			local cp = new("TextButton", { Size = UDim2.fromOffset(52, 30), Position = UDim2.new(1, -64, 0.5, -15), BackgroundColor3 = T.element, Text = "Copy", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, Parent = rowP })
			corner(cp)
			cp.MouseButton1Click:Connect(function() if setclipboard then setclipboard(p.Name); notify("Буфер", "ник скопирован", 2) end end)
		end
	end
	if not any then
		new("TextLabel", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "других игроков нет", TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 13, Parent = plrBox })
	end
end

task.spawn(function()
	while true do
		task.wait(1.5)
		pcall(buildPlayers)
	end
end)

local mus = addTab("Звук", "🎵")
local bgm = new("Sound", { SoundId = "rbxassetid://0", Volume = 2, Looped = false, Parent = SoundService })
addSection(mus, "Плеер (слышишь только ты)")
addBox(mus, "Sound ID + Enter", function(t) S.soundId = tonumber(t:gsub("%D", "")) or 0; notify("Звук", "ID = " .. tostring(S.soundId), 2) end)
addButton(mus, "▶ Играть", function()
	if not S.soundId or S.soundId == 0 then notify("Звук", "введи ID", 3); return end
	bgm.SoundId = "rbxassetid://" .. S.soundId
	pcall(function() bgm:Play() end)
end)
addButton(mus, "⏹ Стоп", function() pcall(function() bgm:Stop() end) end)
addSlider(mus, "Громкость", 0, 10, 2, function(v) bgm.Volume = v end, 1)
addToggle(mus, "Зациклить", false, function(on) bgm.Looped = on end)
addDivider(mus)
addSection(mus, "Быстрые треки")
for _, tr in ipairs({ { "Roblox default", 9046141279 }, { "Among Us drip", 6584745192 }, { "Elevator music", 6756055776 } }) do
	addButton(mus, "🎵 " .. tr[1], function()
		S.soundId = tr[2]
		bgm.SoundId = "rbxassetid://" .. tr[2]
		bgm.Looped = true
		pcall(function() bgm:Play() end)
		notify("Звук", tr[1], 2)
	end)
end

local fun = addTab("Фан", "🎉")
addSection(fun, "Приколы")
addToggle(fun, "🌈 Радужный мир", false, function(on) S.rainbowWorld = on end)
addToggle(fun, "🍺 Пьяная камера", false, function(on) S.drunk = on end)
addToggle(fun, "🕳 Тёмный космос-мир", false, function(on)
	local h = getHum()
	if on then
		Lighting.Ambient = Color3.fromRGB(0, 0, 0); Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0); Lighting.Brightness = 0
	else
		Lighting.Ambient = Color3.fromRGB(140, 140, 140); Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150); Lighting.Brightness = 2
	end
end)
addButton(fun, "🎊 Конфетти", function()
	local hrp = getHRP()
	if not hrp then return end
	for _ = 1, 30 do
		local p = new("Part", { Size = Vector3.new(0.35, 0.35, 0.35), Anchored = true, CanCollide = false, Color = Color3.fromHSV(math.random(), 1, 1), Material = Enum.Material.Neon, Parent = workspace })
		p.CFrame = hrp.CFrame * CFrame.new(math.random(-6, 6), math.random(2, 8), math.random(-6, 6))
		new("BodyVelocity", { Velocity = Vector3.new(math.random(-15, 15), math.random(12, 26), math.random(-15, 15)), MaxForce = Vector3.new(1e5, 1e5, 1e5), Parent = p })
		task.delay(3, function() p:Destroy() end)
	end
end)
addButton(fun, "🎈 Спавн шара", function()
	local hrp = getHRP()
	if hrp then
		local p = new("Part", { Shape = Enum.PartType.Ball, Size = Vector3.new(3, 3, 3), Anchored = true, CanCollide = false, Material = Enum.Material.Neon, Color = Color3.fromHSV(math.random(), 1, 1), Parent = workspace })
		p.CFrame = hrp.CFrame * CFrame.new(0, 5, -6)
	end
end)
addButton(fun, "📸 Мем-текст над головой", function()
	local head = getChar() and getChar():FindFirstChild("Head")
	if not head then return end
	if head:FindFirstChild("MemeTag") then head.MemeTag:Destroy() end
	local bb = new("BillboardGui", { Name = "MemeTag", Size = UDim2.fromOffset(260, 60), StudsOffset = Vector3.new(0, 3.6, 0), AlwaysOnTop = true, Parent = head })
	new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "Я ТУТ ГЛАВНЫЙ 😎", TextScaled = true, Font = Enum.Font.GothamBlack, TextColor3 = Color3.fromRGB(255, 255, 0), TextStrokeTransparency = 0, Parent = bb })
end)

local games = addTab("Игры", "🌐")

local GAMES = {
	{ "Blox Fruits", 2753915549 },
	{ "Brookhaven RP", 4924922222 },
	{ "Murder Mystery 2", 142823291 },
	{ "Adopt Me!", 920587237 },
	{ "DOORS", 6516141723 },
	{ "Arsenal", 286090429 },
	{ "Jailbreak", 606849621 },
	{ "BedWars", 6872274481 },
	{ "Blade Ball", 13772394625 },
	{ "Da Hood", 2788229376 },
	{ "Piggy", 4623386862 },
	{ "Pet Simulator 99", 8737899170 },
}

local function teleportGame(placeId, name)
	notify("Телепорт", "заходим в " .. name .. "...", 4)
	task.spawn(function()
		local ok, err = pcall(function() TPS:Teleport(placeId, LP) end)
		if not ok then notify("Телепорт", "не удалось: " .. tostring(err), 5) end
	end)
end

local gamesWin
local function openGames()
	if gamesWin and gamesWin.Parent then gamesWin.Visible = not gamesWin.Visible; return end
	gamesWin = new("Frame", { Size = UDim2.fromOffset(430, 360), Position = UDim2.new(0.5, -215, 0.5, -180), BackgroundColor3 = T.bg, BorderSizePixel = 0, Active = true, Draggable = true, ClipsDescendants = true, ZIndex = 60, Parent = sg })
	corner(gamesWin, 16)
	stroke(gamesWin, T.accent1, 1.4, 0.4)
	local gtop = new("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = T.card, BorderSizePixel = 0, ZIndex = 61, Parent = gamesWin })
	new("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(16, 0), BackgroundTransparency = 1, Text = "🌐 Игры — телепорт", TextColor3 = T.text, Font = Enum.Font.GothamBlack, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 62, Parent = gtop })
	local gclose = new("TextButton", { Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -40, 0.5, -15), BackgroundColor3 = T.element, Text = "×", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, ZIndex = 62, Parent = gtop })
	corner(gclose)
	gclose.MouseButton1Click:Connect(function() clickSnd(); gamesWin.Visible = false end)
	local gscroll = new("ScrollingFrame", { Size = UDim2.new(1, -20, 1, -58), Position = UDim2.fromOffset(10, 52), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 62, Parent = gamesWin })
	new("UIListLayout", { Parent = gscroll, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
	for _, g in ipairs(GAMES) do
		local b = new("TextButton", { Size = UDim2.new(1, -8, 0, 40), BackgroundColor3 = T.element, Text = "  🎮  " .. g[1], TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 62, Parent = gscroll })
		corner(b)
		b.MouseEnter:Connect(function() hoverSnd(); TS:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = T.hover }):Play() end)
		b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = T.element }):Play() end)
		b.MouseButton1Click:Connect(function() clickSnd(); teleportGame(g[2], g[1]) end)
	end
	playSnd(sndOpen)
end

addSection(games, "Быстрый телепорт")
addButton(games, "🌐 Открыть окно игр", function() openGames() end)
addDivider(games)
addSection(games, "Все игры")
for _, g in ipairs(GAMES) do
	addButton(games, "🎮 " .. g[1], function() teleportGame(g[2], g[1]) end)
end

local srv = addTab("Сервер", "⇄")
addSection(srv, "Действия")
addButton(srv, "Rejoin", function() notify("Server", "переподключение...", 3); TPS:Teleport(game.PlaceId, LP) end)
addButton(srv, "Server hop", function()
	local ok = pcall(function()
		local data = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
		for _, s in ipairs(data.data) do
			if s.playing < s.maxPlayers and s.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, s.id, LP); return end
		end
	end)
	if not ok then notify("Server", "server hop недоступен (HTTP)", 5) end
end)
addButton(srv, "Скопировать Job ID", function() if setclipboard then setclipboard(game.JobId); notify("Server", "скопировано", 3) else notify("Server", "нет setclipboard", 4) end end)
addButton(srv, "Скопировать ID игры", function() if setclipboard then setclipboard(tostring(game.PlaceId)); notify("Server", "скопировано", 3) else notify("Server", "нет setclipboard", 4) end end)
addDivider(srv)
addSection(srv, "Свой скрипт")
addBox(srv, "raw URL скрипта + Enter", function(url) if url ~= "" then task.spawn(function() local ok, err = pcall(function() loadstring(game:HttpGet(url))() end); if not ok then notify("Ошибка", tostring(err), 5) end end) end end)

local util = addTab("Утилиты", "🛠")
addSection(util, "Инфо")
addButton(util, "👥 Кол-во игроков", function()
	notify("Сервер", "онлайн: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers, 4)
end)
addButton(util, "📏 Расстояние до ближайшего", function()
	local myhrp = getHRP(); local best, bd
	if myhrp then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LP then
				local hrp = hrpOf(p)
				if hrp then local d = (myhrp.Position - hrp.Position).Magnitude; if not bd or d < bd then bd = d; best = p end end
			end
		end
	end
	if best then notify("Ближайший", best.Name .. " — " .. math.floor(bd) .. " studs", 4) else notify("Ближайший", "не найдено", 3) end
end)
addButton(util, "📋 Скопировать мой ник", function() if setclipboard then setclipboard(LP.Name); notify("Буфер", "скопировано", 2) else notify("Буфер", "нет setclipboard", 3) end end)
addButton(util, "📋 Скопировать позицию", function()
	local hrp = getHRP()
	if hrp and setclipboard then setclipboard(string.format("%.1f %.1f %.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)); notify("Буфер", "позиция скопирована", 2) end
end)
addDivider(util)
addSection(util, "Разное")
addBox(util, "raw URL + Enter — запустить", function(url) if url ~= "" then task.spawn(function() local ok, err = pcall(function() loadstring(game:HttpGet(url))() end); if not ok then notify("Ошибка", tostring(err), 5) end end) end end)
addButton(util, "🔄 Переподключиться", function() TPS:Teleport(game.PlaceId, LP) end)

local st = addTab("Настройки", "⚙")
addSection(st, "Интерфейс")
addToggle(st, "Звуки меню", true, function(on) cfg.sounds = on end)
addButton(st, "Клавиша меню: " .. S.menuKey.Name, function()
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
addToggle(st, "Свернуть в иконку", false, function(on)
	if on then
		win.Size = UDim2.fromOffset(90, 40)
		content.Visible = false; tabbar.Visible = false
	else
		win.Size = UDim2.fromOffset(WIN_W, WIN_H)
		content.Visible = true; tabbar.Visible = true
	end
end)
addDivider(st)
addSection(st, "Инфо")
new("TextLabel", { Size = UDim2.new(1, 0, 0, 70), BackgroundTransparency = 1, Text = "KITI · PROTO — tablet edition\nуниверсальный хаб · V4\nсделано по запросу", TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = st })
addDivider(st)
addSection(st, "Конфиг")
local function applyAll()
	local h = getHum()
	if h then h.WalkSpeed = S.speed; h.UseJumpPower = true; h.JumpPower = S.jump end
	Cam.FieldOfView = S.fov
	if S.fog then Lighting.FogStart = 0; Lighting.FogEnd = S.fogEnd; Lighting.FogColor = S.fogColor else Lighting.FogEnd = 100000 end
end
addButton(st, "💾 Сохранить настройки", function()
	if not writefile then notify("Конфиг", "нет writefile", 3); return end
	local out = {}
	for k, v in pairs(S) do
		local t = type(v)
		if t == "number" or t == "boolean" or t == "string" then out[k] = v end
	end
	local ok = pcall(function() writefile("kitiproto.json", HS:JSONEncode(out)) end)
	notify("Конфиг", ok and "сохранено" or "ошибка записи", 2)
end)
addButton(st, "📂 Загрузить настройки", function()
	if not (readfile and isfile and isfile("kitiproto.json")) then notify("Конфиг", "нет файла", 3); return end
	local ok, data = pcall(function() return HS:JSONDecode(readfile("kitiproto.json")) end)
	if ok and type(data) == "table" then
		for k, v in pairs(data) do
			local t = type(v)
			if t == "number" or t == "boolean" or t == "string" then S[k] = v end
		end
		applyAll()
		notify("Конфиг", "загружено", 2)
	else
		notify("Конфиг", "ошибка чтения", 3)
	end
end)

local watermark = new("TextLabel", { Name = "WM", Parent = sg, BackgroundTransparency = 1, Size = UDim2.new(0, 320, 0, 22), Position = UDim2.fromOffset(14, 10), Text = "KITI · PROTO", TextColor3 = T.accent1, Font = Enum.Font.GothamBlack, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 0.7, TextStrokeColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 100 })

local hud = new("Frame", { Name = "HUD", Parent = sg, BackgroundColor3 = T.card, BackgroundTransparency = 0.15, Size = UDim2.fromOffset(210, 122), Position = UDim2.new(0, 14, 0, 40), BorderSizePixel = 0, ZIndex = 90 })
corner(hud, 12)
stroke(hud, T.accent1, 1.2, 0.5)
new("UIListLayout", { Parent = hud, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder })
new("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 14), Parent = hud })
new("TextLabel", { Size = UDim2.new(1, -14, 0, 16), BackgroundTransparency = 1, Text = "KITI HUD", TextColor3 = T.accent1, Font = Enum.Font.GothamBlack, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudFps = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "FPS: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudPing = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Ping: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudPos = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Pos: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudTime = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Time: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })
local hudPl = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Players: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = hud })

task.spawn(function()
	local pname = "game " .. tostring(game.PlaceId)
	pcall(function() pname = MPS:GetProductInfo(game.PlaceId).Name end)
	subtitle.Text = pname .. "  ·  " .. LP.Name
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
			if hrp then hudPos.Text = string.format("Pos: %d, %d, %d", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) end
			if S.hudExtra then
				hudTime.Visible = true; hudPl.Visible = true
				hudTime.Text = string.format("Time: %02d:%02d", math.floor(Lighting.ClockTime) % 24, math.floor((Lighting.ClockTime % 1) * 60))
				hudPl.Text = "Players: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers
			else
				hudTime.Visible = false; hudPl.Visible = false
			end
		end
		frames = 0
	end
end)

task.spawn(function()
	while true do
		task.wait(0.03)
		pcall(function() shineGrad.Offset = Vector2.new((shineGrad.Offset.X + 0.01) % 3, 0) end)
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		pcall(function()
			if S.fog then
				Lighting.FogStart = 0; Lighting.FogEnd = S.fogEnd; Lighting.FogColor = S.fogColor
			end
			if S.beauty or S.haze then
				ensureEffects()
				atmosphere.Density = S.haze and S.hazeVal or 0.25
				if S.beauty then
					atmosphere.Color = Color3.fromRGB(200, 210, 255); atmosphere.Decay = Color3.fromRGB(120, 140, 200)
					atmosphere.Haze = 1.2; atmosphere.Glare = 0.15
					colorCorr.Saturation = S.sat; colorCorr.Contrast = 0.08
					bloom.Intensity = S.bloomI; bloom.Size = 24; bloom.Threshold = 0.9
					sunrays.Intensity = S.sunraysOn and 0.1 or 0; sunrays.Spread = 1
					if S.dofOn then
						dof.FarIntensity = 0.18; dof.FocusDistance = 40; dof.InFocusRadius = 25; dof.NearIntensity = 0.12
					else dof.FarIntensity = 0; dof.NearIntensity = 0 end
					Lighting.EnvironmentDiffuseScale = 0.4; Lighting.EnvironmentSpecularScale = 0.5
				else
					atmosphere.Color = S.fogColor
				end
			end
			local c = getChar()
			if S.rainbow and c then
				local col = Color3.fromHSV(tick() % 1, 1, 1)
				for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Color = col end end
			end
			if S.godMode then
				local h = getHum()
				if h then h.MaxHealth = 9e9; h.Health = 9e9 end
			end
			if S.rainbowWorld then
				local cc = Color3.fromHSV(tick() % 1, 1, 1)
				Lighting.Ambient = cc; Lighting.OutdoorAmbient = cc
				ensureEffects(); colorCorr.TintColor = cc
			end
			local hh = getHum()
			if hh then
				if S.drunk then hh.CameraOffset = Vector3.new(math.sin(tick() * 3) * 1.5, math.cos(tick() * 2) * 1, 0)
				else hh.CameraOffset = Vector3.new(0, 0, 0) end
			end
			local hrp = getHRP()
			if hrp then
				if S.fire and not hrp:FindFirstChild("KitiFire") then
					new("Fire", { Name = "KitiFire", Size = 8, Heat = 12, Color = Color3.fromRGB(255, 150, 40), SecondaryColor = Color3.fromRGB(255, 60, 20), Parent = hrp })
				elseif not S.fire and hrp:FindFirstChild("KitiFire") then
					hrp:FindFirstChild("KitiFire"):Destroy()
				end
				if S.trail and not hrp:FindFirstChild("KitiA0") then
					local a0 = new("Attachment", { Name = "KitiA0", Position = Vector3.new(-0.6, 0, 0), Parent = hrp })
					local a1 = new("Attachment", { Name = "KitiA1", Position = Vector3.new(0.6, 0, 0), Parent = hrp })
					local tr = new("Trail", { Name = "KitiTrailFx", Attachment0 = a0, Attachment1 = a1, Lifetime = 0.45, LightEmission = 1, Parent = hrp })
					tr.Color = ColorSequence.new(Color3.fromRGB(126, 108, 255), Color3.fromRGB(86, 198, 255))
				elseif not S.trail and hrp:FindFirstChild("KitiTrailFx") then
					hrp:FindFirstChild("KitiTrailFx"):Destroy()
					local a0 = hrp:FindFirstChild("KitiA0"); if a0 then a0:Destroy() end
					local a1 = hrp:FindFirstChild("KitiA1"); if a1 then a1:Destroy() end
				end
			end
		end)
	end
end)

task.spawn(function()
	while true do
		task.wait(2)
		if S.xray then
			pcall(function()
				local mychar = LP.Character
				for _, d in ipairs(workspace:GetDescendants()) do
					if d:IsA("BasePart") and not (mychar and d:IsDescendantOf(mychar)) then
						if d:GetAttribute("KitiOrigT") == nil then d:SetAttribute("KitiOrigT", d.Transparency) end
						d.Transparency = 0.65
					end
				end
			end)
		end
	end
end)

task.spawn(function()
	while true do
		if S.autoClick then
			pcall(function()
				if mouse1click then mouse1click()
				else VU:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame); task.wait(0.02); VU:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) end
			end)
			task.wait(S.autoClickDelay)
		else
			task.wait(0.1)
		end
	end
end)

local cross = DrawingLib and DrawingLib.new and DrawingLib.new("Circle") or nil
if cross then cross.Filled = false; cross.Thickness = 1.5; cross.Color = Color3.fromRGB(255, 255, 255); cross.Transparency = 0.3; cross.Visible = false end
local fovCircle = DrawingLib and DrawingLib.new and DrawingLib.new("Circle") or nil
if fovCircle then fovCircle.Filled = false; fovCircle.Thickness = 1.5; fovCircle.Color = T.accent1; fovCircle.Transparency = 0.4; fovCircle.Visible = false end

RS.RenderStepped:Connect(function(dt)
	frames = frames + 1
	local ok = pcall(function()
		local center = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
		hud.Visible = S.hud
		watermark.Visible = S.watermark
		if cross then cross.Position = center; cross.Radius = 6; cross.Visible = S.crosshair end
		if fovCircle then fovCircle.Position = center; fovCircle.Radius = S.aimFov; fovCircle.Visible = S.aimbot end

		if S.noclip then
			local c = getChar()
			if c then for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.CanCollide = false end end end
		end

		if S.hitbox then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LP then
					local hrp = hrpOf(p)
					if hrp then hrp.Size = Vector3.new(S.hitboxSize, S.hitboxSize, S.hitboxSize) end
				end
			end
		end

		local hum = getHum()
		if hum and hum.WalkSpeed ~= S.speed then hum.WalkSpeed = S.speed end

		if S.copyHats then
			local myHead = getChar() and getChar():FindFirstChild("Head")
			if myHead then
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= LP then
						local oh = p.Character and p.Character:FindFirstChild("Head")
						if oh then
							for _, acc in ipairs(oh:GetChildren()) do
								if (acc:IsA("Accessory") or acc:IsA("Hat")) and not myHead:FindFirstChild(acc.Name) then
									local cl = acc:Clone()
									cl.Parent = myHead
									local hp0 = cl:IsA("BasePart") and cl or cl:FindFirstChildWhichIsA("BasePart")
									if hp0 then
										local weld = new("WeldConstraint", { Parent = hp0 })
										weld.Part0 = myHead; weld.Part1 = hp0
										hp0.CFrame = myHead.CFrame
									end
								end
							end
						end
					end
				end
			end
		end

		if S.clockLock then Lighting.ClockTime = S.clock end

		if S.aimbot then
			local firing = S.aimAlways or UIS:IsKeyDown(S.aimKey)
			if firing then
				local _, tpos = findTarget()
				if tpos then
					local goal = CFrame.new(Cam.CFrame.Position, tpos)
					if S.aimSmooth <= 0.01 then Cam.CFrame = goal else Cam.CFrame = Cam.CFrame:Lerp(goal, 1 - S.aimSmooth) end
				end
			end
		end

		if S.trigger and UIS:IsKeyDown(S.triggerKey) then
			if findTarget() then
				local c = getChar()
				local tool = c and c:FindFirstChildOfClass("Tool")
				if tool then pcall(function() tool:Activate() end) end
			end
		end

		if S.espNames or S.espBox or S.espTracer or S.espHighlight then
			for _, p in ipairs(Players:GetPlayers()) do
				local c = p.Character
				local head = c and c:FindFirstChild("Head")
				local hrp = c and c:FindFirstChild("HumanoidRootPart")
				local hum2 = c and c:FindFirstChildOfClass("Humanoid")
				if p ~= LP and head and hrp and hum2 and hum2.Health > 0 then
					local col = S.rainbowEsp and Color3.fromHSV(tick() % 1, 1, 1) or roleColor(p)
					if S.espNames then
						local tag = head:FindFirstChild("KitiName")
						if not tag then
							tag = new("BillboardGui", { Name = "KitiName", Size = UDim2.fromOffset(220, 40), StudsOffset = Vector3.new(0, 2.6, 0), AlwaysOnTop = true, Parent = head })
							new("TextLabel", { Name = "L", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 13, TextStrokeTransparency = 0, Parent = tag })
						end
						local lbl = tag:FindFirstChild("L")
						local info
						if S.espInfo then
							local myhrp = getHRP()
							local d = myhrp and math.floor((myhrp.Position - hrp.Position).Magnitude) or 0
							info = " [" .. roleOf(p) .. "] " .. math.floor(hum2.Health) .. "hp " .. d .. "m"
						else
							info = " [" .. roleOf(p) .. "]"
						end
						lbl.Text = p.Name .. info
						lbl.TextColor3 = col
					else
						local tag = head:FindFirstChild("KitiName"); if tag then tag:Destroy() end
					end
					if S.espHighlight then
						local hl = c:FindFirstChild("KitiHL")
						if not hl then hl = new("Highlight", { Name = "KitiHL", FillTransparency = 0.6, OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = c }) end
						hl.FillColor = col; hl.OutlineColor = col
					else
						local hl = c:FindFirstChild("KitiHL"); if hl then hl:Destroy() end
					end
					if DrawingLib then
						local v = visuals[p]
						if not v then v = { box = DrawingLib.new("Square"), tracer = DrawingLib.new("Line") }; v.box.Thickness = 1.5; v.box.Filled = false; v.tracer.Thickness = 1.5; visuals[p] = v end
						v.box.Transparency = 0.2; v.tracer.Transparency = 0.4; v.box.Color = col; v.tracer.Color = col
						local top = w2s(head.Position + Vector3.new(0, 0.7, 0))
						local bot = w2s(hrp.Position - Vector3.new(0, 3, 0))
						if top and bot and S.espBox then
							local h = math.abs(bot.Y - top.Y); local w = h * 0.55
							v.box.Position = Vector2.new(top.X - w / 2, math.min(top.Y, bot.Y)); v.box.Size = Vector2.new(w, h); v.box.Visible = true
						else v.box.Visible = false end
						if top and S.espTracer then
							v.tracer.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y); v.tracer.To = Vector2.new(top.X, top.Y); v.tracer.Visible = true
						else v.tracer.Visible = false end
					end
				else
					if head then local tag = head:FindFirstChild("KitiName"); if tag then tag:Destroy() end end
					if c then local hl = c:FindFirstChild("KitiHL"); if hl then hl:Destroy() end end
					if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
				end
			end
		else
			for _, p in ipairs(Players:GetPlayers()) do
				local c = p.Character
				if c then
					local hl = c:FindFirstChild("KitiHL"); if hl then hl:Destroy() end
					local head = c:FindFirstChild("Head"); if head then local tag = head:FindFirstChild("KitiName"); if tag then tag:Destroy() end end
				end
				if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
			end
		end

		if S.fly then
			local hrp = getHRP()
			if hrp then
				if not hrp:FindFirstChild("KitiFly") then
					new("BodyVelocity", { Name = "KitiFly", MaxForce = Vector3.new(1e5, 1e5, 1e5), Parent = hrp })
					new("BodyGyro", { Name = "KitiGyro", MaxTorque = Vector3.new(1e5, 1e5, 1e5), P = 3000, Parent = hrp })
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
		if gamesWin then gamesWin.Visible = win.Visible and gamesWin.Visible end
	end
	if S.clickTp and i.UserInputType == Enum.UserInputType.MouseButton1 then
		local ok = pcall(function()
			local unitRay = Cam:ViewportPointToRay(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
			local ray = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
			local hit = workspace:FindPartOnRay(ray, LP.Character)
			local hrp = getHRP()
			if hit and hrp then hrp.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0)) end
		end)
	end
end)

topBtn("–", -76, function()
	local collapsed = win.Size.Y.Offset <= 100
	win.Size = collapsed and UDim2.fromOffset(WIN_W, WIN_H) or UDim2.fromOffset(WIN_W, 54)
	content.Visible = collapsed
	tabbar.Visible = collapsed
end)
topBtn("×", -42, function()
	sg:Destroy()
	print("[KITI-PROTO] V4 closed")
end)

notify("KITI · PROTO", "tablet edition загружен. Меню: " .. S.menuKey.Name, 5)
print("[KITI-PROTO] V4 loaded")
