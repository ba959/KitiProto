local Players, UIS, RS, TS, Lighting, SoundService, VU, TPS, HS, Stats, MPS, InsertService
local LP, Cam, PGUI

local function safe(pcallFn, name)
	local ok, err = pcall(pcallFn)
	if not ok then
		warn("[KITI] " .. (name or "error") .. ": " .. tostring(err))
	end
	return ok, err
end

safe(function()
	Players = game:GetService("Players")
	UIS = game:GetService("UserInputService")
	RS = game:GetService("RunService")
	TS = game:GetService("TweenService")
	Lighting = game:GetService("Lighting")
	SoundService = game:GetService("SoundService")
	VU = game:GetService("VirtualUser")
	TPS = game:GetService("TeleportService")
	HS = game:GetService("HttpService")
	Stats = game:GetService("Stats")
	MPS = game:GetService("MarketplaceService")
	InsertService = game:GetService("InsertService")
end, "services")

safe(function()
	LP = Players.LocalPlayer
	Cam = workSpace.CurrentCamera
	PGUI = LP:WaitForChild("PlayerGui")
end, "player")

local env = (getgenv and getgenv()) or _G

for _, g in ipairs(PGUI:GetChildren()) do
	if g.Name == "KitiProtoV4" then g:Destroy() end
end

print("[KITI] init ok, player=" .. tostring(LP and LP.Name))
local mainOK, mainErr = pcall(function()


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

local sndHover = new("Sound", { SoundID = "rbxassetid://6895079852", Volume = 0.25, Parent = SoundService })
local sndClick = new("Sound", { SoundID = "rbxassetid://6895079853", Volume = 0.35, Parent = SoundService })
local sndOpen = new("Sound", { SoundID = "rbxassetid://6895079851", Volume = 0.4, Parent = SoundService })
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

local shadow = new("Frame", { Size = UDim2.fromOffset(WIN_W + 8, WIN_H + 8), Position = UDim2.new(0.5, -WIN_W / 2 - 4, 0.5, -WIN_H / 2 + 6), BackgroundColor3 = Color3.fromRGB(8, 10, 16), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 0, Parent = sg })
corner(shadow, 18)

local win = new("Frame", { Size = UDim2.fromOffset(WIN_W, WIN_H), Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2), BackgroundColor3 = T.bg, BackgroundTransparency = 0.08, BorderSizePixel = 0, Active = true, Draggable = true, ClipsDescendants = true, ZIndex = 1, Parent = sg })
corner(win, 18)
local winStroke = stroke(win, T.accent1, 1.4, 0.5)

local topbar = new("Frame", { Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = T.card, BackgroundTransparency = 0.04, BorderSizePixel = 0, ZIndex = 2, Parent = win })
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

local tabbar = new("ScrollingFrame", { Size = UDim2.new(1, -32, 0, 40), Position = UDim2.fromOffset(16, 62), BackgroundColor3 = T.card, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 2, Parent = win, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollingEnabled = true })
corner(tabbar, 12)
new("UIListLayout", { Parent = tabbar, Padding = UDim.new(0, 4), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.CEnter, SortOrder = Enum.SortOrder.LayoutOrder })
new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = tabbar })

local content = new("Frame", { Size = UDim2.new(1, -32, 1, -122), Position = UDim2.fromOffset(16, 110), BackgroundColor3 = T.card, BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 2, Parent = win })
corner(content, 14)

local shine = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(200, 210, 255), BackgroundTransparency = 0.94, BorderSizePixel = 0, ZIndex = 50, Parent = win })
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
				local g = t.btn:FindFirstChilDOFClass("UIGradient")
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
		TS:Create(b, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(255, 105, 180), Size = UDim2.new(1, 0, 0, 42) }):Play()
		task.delay(0.18, function()
			TS:Create(b, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), { BackgroundColor3 = T.element, Size = UDim2.new(1, 0, 0, 38) }):Play()
		end)
		local ok, err = pcall(cb)
		if not ok then notify("Ошибка", tostring(err), 5) end
	end)
	b:SetAttribute("kw", string.lower(text))
	return b
end

local togglesByID = {}

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
	local obj = { Set = function(v, quiet) on = v; paint(true); if not quiet then pcall(cb, on) end end }
	togglesById[text] = obj
	return obj
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
	local Head = new("TextButton", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, Text = "", Parent = row })
	new("TextLabel", { Size = UDim2.new(1, -170, 0, 38), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1, Text = text, TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = Head })
	local cur = new("TextLabel", { Size = UDim2.fromOffset(120, 38), Position = UDim2.new(1, -160, 0, 0), BackgroundTransparency = 1, Text = def or (options[1] or "-"), TextColor3 = T.accent1, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = Head })
	local arrow = new("TextLabel", { Size = UDim2.fromOffset(20, 38), Position = UDim2.new(1, -28, 0, 0), BackgroundTransparency = 1, Text = "v", TextColor3 = T.sub, Font = Enum.Font.GothamBold, TextSize = 13, Parent = Head })
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
	Head.MouseEnter:Connect(function() hoverSnd() end)
	Head.MouseButton1Click:Connect(function()
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
	box.FocusLost:Connect(function(Enter) if Enter then clickSnd(); pcall(cb, box.Text) end end)
	return box
end

local function getChar() return LP.Character end
local function getHRP() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = LP.Character; return c and c:FindFirstChilDOFClass("Humanoid") end
local function hrpOf(p) local c = p and p.Character; return c and c:FindFirstChild("HumanoidRootPart") end

local S = {
	Speed = 16, jump = 50, menuKey = Enum.KeyCode.RightControl,
	Fly = false, FlySpeed = 60, Noclip = false, infJump = false, antiAfk = false,
	Fullbright = false, clockLock = false, clock = 14,
	fog = false, fogEnd = 350, fogColor = Color3.fromRGB(255, 255, 255),
	haze = false, hazeVal = 0.3,
	beauty = false, sat = 0.15, bloomI = 0.9, sunraysOn = true, DOFOn = false,
	rainbow = false, trail = false, fire = false, godMode = false, autoRESPawn = false, freeze = false,
	ESPNames = false, ESPHighlight = false, ESPRole = true, xray = false, rainbowESP = false, ESPInfo = false,
	rainbowWorld = false, drunk = false, soundID = 0,
	Aimbot = false, AimAlways = false, AimKey = Enum.KeyCode.E, AimFOV = 150, AimPart = "Head", AimSmooth = 0.5,
	TRIGger = false, TRIGgerKey = Enum.KeyCode.Q, hitbox = false, hitboxSize = 6,
	autoClick = false, autoClickDelay = 0.1,
	FOV = 70, thirdPerson = false, camMin = 0.5, camMax = 12,
	clickTp = false, HUD = true, Watermark = true, crosshair = false, HUDExtra = true,
	antiFling = false, charSpin = false, infiniteYield = false, jumpGlitch = false,
	Skeleton = false, healthbar = false, chams = false, bulletTracer = false, teamCheck = false,
	petCount = 3, petShape = "Ball", petSize = 1, petTrail = false, petFollow = true, petHue = 0.65, petESP = false,
	theme = "dark", rainbowUI = false, binds = {}, menuOpacity = 0.9, menuScale = 1, glow = false, smoothGui = true,
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
	if not S.ESPRole then return Color3.fromRGB(255, 80, 80) end
	local r = roleOf(p)
	if r == "MURDERER" then return Color3.fromRGB(240, 70, 70) end
	if r == "SHERIFF" then return Color3.fromRGB(70, 150, 255) end
	return Color3.fromRGB(70, 220, 120)
end

local function findTarget()
	local cEnter = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
	local best, bestD, bestPos = nil, S.AimFOV, nil
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local hum = p.Character:FindFirstChilDOFClass("Humanoid")
			local part = p.Character:FindFirstChild(S.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
			if hum and hum.Health > 0 and part then
				local sp, on = Cam:WorldToViewportPoint(part.Position)
				if on then
					local d = (Vector2.new(sp.X, sp.Y) - cEnter).Magnitude
					if d < bestD then bestD = d; best = p; bestPos = part.Position end
				end
			end
		end
	end
	return best, bestPos
end

local atmosphere = nil
local ColorCorr = nil
local bloom = nil
local DOF = nil
local sunrays = nil

local function ensureEffects()
	if not atmosphere then atmosphere = new("Atmosphere", { Parent = Lighting }) end
	if not ColorCorr then ColorCorr = new("ColorCorrectionEffect", { Parent = Lighting }) end
	if not bloom then bloom = new("bloomEffect", { Parent = Lighting }) end
	if not DOF then DOF = new("DepthOfFieldEffect", { Parent = Lighting }) end
	if not sunrays then sunrays = new("SunRaysEffect", { Parent = Lighting }) end
end

local SKY_FACES = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" }
local SKY_SETS = {
	["Космос"] = { 159454299, 159454296, 159454293, 159454286, 159454300, 159454288 },
	["Галактика"] = { 159454299, 159454299, 159454299, 159454299, 159454299, 159454299 },
}

local function getSky()
	local sky = Lighting:FindFirstChilDOFClass("Sky")
	if not sky then sky = new("Sky", { Parent = Lighting }) end
	return sky
end

local function applySkySet(set)
	local sky = getSky()
	sky.SkyboxOrientation = Vector3.new(0, 0, 0)
	for i = 1, 6 do
		local ID = set[i]
		pcall(function() sky[SKY_FACES[i]] = "rbxassetid://" .. tostring(id) end)
	end
	return sky
end

local function clearSky()
	local sky = Lighting:FindFirstChilDOFClass("Sky")
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
		ColorCorr.TintColor = Color3.fromRGB(255, 255, 255); ColorCorr.Saturation = 0
	elseif mode == "Закат" then
		clearSky()
		Lighting.ClockTime = 17.4; Lighting.Brightness = 1.8
		Lighting.Ambient = Color3.fromRGB(150, 110, 95); Lighting.OutdoorAmbient = Color3.fromRGB(210, 130, 95)
		Lighting.FogColor = Color3.fromRGB(255, 170, 120); Lighting.FogEnd = 900
		atmosphere.Color = Color3.fromRGB(255, 190, 150); atmosphere.Density = 0.28
		ColorCorr.TintColor = Color3.fromRGB(255, 225, 200); ColorCorr.Saturation = 0.12
	elseif mode == "Ночь" then
		clearSky()
		Lighting.ClockTime = 0; Lighting.Brightness = 0.8
		Lighting.Ambient = Color3.fromRGB(55, 60, 95); Lighting.OutdoorAmbient = Color3.fromRGB(40, 45, 80)
		ColorCorr.TintColor = Color3.fromRGB(200, 210, 255); ColorCorr.Saturation = 0
	elseif mode == "Космос" then
		local sky = applySkySet(SKY_SETS["Космос"])
		sky.StarCount = 0; sky.CelestialBodiesShown = false
		Lighting.ClockTime = 0; Lighting.Brightness = 0.4
		Lighting.Ambient = Color3.fromRGB(40, 40, 70); Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 60)
		ColorCorr.TintColor = Color3.fromRGB(190, 200, 255); ColorCorr.Saturation = 0.2
		Lighting.ExposureCompensation = 0.2
	elseif mode == "Галактика" then
		local sky = applySkySet(SKY_SETS["Галактика"])
		sky.StarCount = 0; sky.CelestialBodiesShown = false
		Lighting.ClockTime = 0; Lighting.Brightness = 0.5
		Lighting.Ambient = Color3.fromRGB(50, 45, 85); Lighting.OutdoorAmbient = Color3.fromRGB(45, 40, 90)
		ColorCorr.TintColor = Color3.fromRGB(210, 190, 255); ColorCorr.Saturation = 0.25
	elseif mode == "Неон" then
		clearSky()
		Lighting.ClockTime = 2; Lighting.Brightness = 2.2
		Lighting.Ambient = Color3.fromRGB(60, 40, 90); Lighting.OutdoorAmbient = Color3.fromRGB(50, 30, 80)
		Lighting.FogColor = Color3.fromRGB(120, 60, 200); Lighting.FogEnd = 450
		atmosphere.Color = Color3.fromRGB(150, 80, 255); atmosphere.Density = 0.35
		ColorCorr.TintColor = Color3.fromRGB(200, 150, 255); ColorCorr.Saturation = 0.4
	end
	notify("Небо", mode, 2)
end

local mov = addTab("Движение", "➤")
addSection(mov, "Скорость")
addSlider(mov, "WalkSpeed", 16, 500, 16, function(v) S.Speed = v end)
addSlider(mov, "JumpPower", 50, 500, 50, function(v) S.jump = v; local h = getHum(); if h then h.UseJumpPower = true; h.JumpPower = v end end)
addToggle(mov, "Бесконечный прыжок", false, function(on) S.infJump = on end)
addDivider(mov)
addSection(mov, "Полёт")
addToggle(mov, "Fly", false, function(on)
	S.Fly = on
	if not on then
		local hrp = getHRP()
		if hrp then
			local bv = hrp:FindFirstChild("KitiFly"); if bv then bv:Destroy() end
			local bg = hrp:FindFirstChild("KitiGyro"); if bg then bg:Destroy() end
		end
	end
	notify("Fly", on and "включён" or "выключен", 2)
end)
addSlider(mov, "Fly Speed", 10, 500, 60, function(v) S.FlySpeed = v end)
addDivider(mov)
addSection(mov, "Прочее")
addToggle(mov, "Noclip (сквозь стены)", false, function(on) S.Noclip = on end)
addToggle(mov, "Anti-AFK", false, function(on) S.antiAfk = on end)
addToggle(mov, "Click TP (лкм)", false, function(on) S.clickTp = on; notify("Click TP", on and "вкл" or "выкл", 2) end)
addButton(mov, "Reset персонажа", function() local h = getHum(); if h then h.Health = 0 end end)
addDivider(mov)
addSection(mov, "телепорт")
addBox(mov, "X (число) + Enter", function(t) S.tpX = tonumber(t) end)
addBox(mov, "Y (число) + Enter", function(t) S.tpY = tonumber(t) end)
addBox(mov, "Z (число) + Enter", function(t) S.tpZ = tonumber(t) end)
addButton(mov, "📍 телепорт по координатам", function()
	local hrp = getHRP()
	if hrp and S.tpX and S.tpY and S.tpZ then hrp.CFrame = CFrame.new(S.tpX, S.tpY, S.tpZ); notify("телепорт", "готово", 2)
	else notify("телепорт", "введи X, Y и Z", 3) end
end)
addButton(mov, "⬆ Вверх на 50", function() local hrp = getHRP(); if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0) end end)
addButton(mov, "⬇ Вниз на 50", function() local hrp = getHRP(); if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0, 50, 0) end end)
addDivider(mov)
addSection(mov, "Дополнительно")
addToggle(mov, "❄ Заморозить себя", false, function(on) S.freeze = on; local hrp = getHRP(); if hrp then hrp.Anchored = on end end)
addToggle(mov, "♻ Авто-респавн", false, function(on) S.autoRESPawn = on; Players.RESPawnTime = on and 0 or 5 end)
addToggle(mov, "🛡 God Mode (клиент)", false, function(on)
	S.godMode = on
	local h = getHum()
	if h and on then h.MaxHealth = 9e9; h.Health = 9e9 end
end)
addSlider(mov, "Гравитация мира", 0, 300, 196, function(v) workSpace.Gravity = v end)
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
		local sky = Lighting:FindFirstChilDOFClass("Sky")
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
addButton(vis, "Туман: Белый", function() S.fogColor = Color3.fromRGB(255, 255, 255) end)
addButton(vis, "Туман: Синий", function() S.fogColor = Color3.fromRGB(90, 130, 220) end)
addButton(vis, "Туман: фиолетовый", function() S.fogColor = Color3.fromRGB(150, 80, 220) end)
addButton(vis, "Туман: Зелёный", function() S.fogColor = Color3.fromRGB(70, 200, 120) end)
addButton(vis, "Туман: чёрный", function() S.fogColor = Color3.fromRGB(0, 0, 0) end)
addToggle(vis, "Дымка (атмосфера)", false, function(on) S.haze = on end)
addSlider(vis, "Плотность дымки", 0, 1, 0.3, function(v) S.hazeVal = v end, 2)
addDivider(vis)
addSection(vis, "Освещение")
addToggle(vis, "Fullbright", false, function(on)
	S.Fullbright = on
	if on then
		Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(160, 160, 160); Lighting.FogEnd = 100000
	else
		Lighting.Brightness = 2; Lighting.GlobalShadows = true
	end
end)
addToggle(vis, "Зафиксировать Время суток", false, function(on) S.clockLock = on; if on then Lighting.ClockTime = S.clock end end)
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
	local c = getChar(); local h = c and c:FindFirstChilDOFClass("Humanoid")
	if h then h.BodyWidthScale = 0.4; h.BodyHeightScale = 0.4; h.BodyDepthScale = 0.4; h.HeadScale = 0.6 end
end)
addButton(me, "🦖 Гигант", function()
	local c = getChar(); local h = c and c:FindFirstChilDOFClass("Humanoid")
	if h then h.BodyWidthScale = 2.5; h.BodyHeightScale = 2.5; h.BodyDepthScale = 2.5; h.HeadScale = 2 end
end)
addButton(me, "↩ Обычный размер", function()
	local c = getChar(); local h = c and c:FindFirstChilDOFClass("Humanoid")
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
	local c = getChar(); local h = c and c:FindFirstChilDOFClass("Humanoid")
	if best and best.Character and h and c then
		local bh = best.Character:FindFirstChilDOFClass("Humanoid")
		if bh then
			h.BodyWidthScale = bh.BodyWidthScale; h.BodyHeightScale = bh.BodyHeightScale
			h.BodyDepthScale = bh.BodyDepthScale; h.HeadScale = bh.HeadScale
		end
		for _, d in ipairs(best.Character:GetDescendants()) do
			if d:IsA("Accessory") or d:IsA("Accoutrement") then
				local cl = d:Clone(); cl.Parent = c
				local ap = cl:FindFirstChildWhichIsA("BasePart")
				local Head = c:FindFirstChild("Head")
				if ap and Head then
					local w = new("WeldConstraint", { Parent = ap }); w.Part0 = Head; w.Part1 = ap; ap.CFrame = Head.CFrame
				end
			end
		end
		notify("Персонаж", "скопировано с " .. best.Name, 2)
	else
		notify("Персонаж", "игроки рядом не найдены", 3)
	end
end)
addButton(me, "💃 Танец", function()
	local c = getChar(); local h = c and c:FindFirstChilDOFClass("Humanoid")
	if h then
		local a = new("Animation", { AnimationID = "rbxassetid://507771019", Parent = h })
		local t = h:FindFirstChilDOFClass("Animator"); if not t then t = new("Animator", { Parent = h }) end
		pcall(function() t:LoadAnimation(a):Play() end)
	end
end)
addToggle(me, "🌈 РАдужный персонаж", false, function(on) S.rainbow = on end)
addToggle(me, "✨ Шлейф частиц", false, function(on) S.trail = on end)
addToggle(me, "🔥 Огонь на персонаже", false, function(on) S.fire = on end)
addDivider(me)
addSection(me, "Шляпа / аксессуар")
addToggle(me, "🎩 Копировать шапки с игрока", false, function(on)
	S.CopyHats = on
	if not on then
		local c = getChar()
		if c then for _, d in ipairs(c:GetChildren()) do if d:IsA("Accessory") or d:IsA("Hat") then d:Destroy() end end end
	end
end)
addButton(me, "НАдеть аксессуар по ID", function()
	local c = getChar(); local Head = c and c:FindFirstChild("Head")
	if not Head then return end
	local ok, model = pcall(function() return InsertService:LoadAsset(S.hatId or 0) end)
	if ok and model then
		local hat = model:GetChildren()[1]
		if hat then
			hat.Parent = Head
			local att = hat:FindFirstChilDOFClass("Attachment") or hat:FindFirstChild("HatAttachment")
			local weld = new("WeldConstraint", { Parent = hat })
			weld.Part0 = Head
			weld.Part1 = hat:IsA("BasePart") and hat or hat:FindFirstChildWhichIsA("BasePart")
			notify("Шляпа", "нАдета", 3)
		end
	else
		notify("Шляпа", "не удалось (нужен ID и права)", 4)
	end
end)
addBox(me, "ID аксессуара (число) + Enter", function(txt) S.hatID = tonumber(txt:gsub("%D", "")) or 0; notify("Шляпа", "ID = " .. tostring(S.hatId), 2) end)
addDivider(me)
addSection(me, "Быстрые пресеты аксессуаров")
for _, hat in ipairs({ { "Dominus", 11502881681 }, { "Crown", 13890882624 }, { "Top Hat", 11500276914 }, { "Wings", 11501051981 }, { "Halo", 11501006121 } }) do
	addButton(me, "🎩 " .. hat[1], function()
		local c = getChar(); local Head = c and c:FindFirstChild("Head")
		if not Head then return end
		local ok, model = pcall(function() return InsertService:LoadAsset(hat[2]) end)
		if ok and model then
			local hatM = model:GetChildren()[1]
			if hatM then
				hatM.Parent = Head
				local att = hatM:FindFirstChilDOFClass("Attachment") or hatM:FindFirstChild("HatAttachment")
				local weld = new("WeldConstraint", { Parent = hatM })
				weld.Part0 = Head
				weld.Part1 = hatM:IsA("BasePart") and hatM or hatM:FindFirstChildWhichIsA("BasePart")
				notify("Шляпа", hat[1] .. " нАдета", 3)
			end
		else
			notify("Шляпа", "не удалось (нужен ID и права)", 4)
		end
	end)
end
addDivider(me)
addSection(me, "Камера")
addSlider(me, "FOV (обзор)", 40, 120, 70, function(v) S.FOV = v; Cam.FielDOFView = v end)
addSlider(me, "Мин. зум", 0.5, 30, 0.5, function(v) S.camMin = v; LP.CameraMinZoomDistance = v end, 1)
addSlider(me, "Макс. зум (отдаление)", 4, 120, 12, function(v) S.camMax = v; LP.CameraMaxZoomDistance = v end, 1)
addToggle(me, "От первого лица", false, function(on)
	LP.CameraMode = on and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
	notify("Камера", on and "1-е лицо" or "3-е лицо", 2)
end)

S.particleEnabled = false; S.particleColor = Color3.fromRGB(80, 170, 255)
S.particleSize = 1.5; S.particleTransparency = 0.2; S.particlESPeed = 1
S.particleLifetime = 1.2; S.particleRate = 25; S.particlESPread = 360
S.particleRotation = 0; S.particleOffset = Vector3.new(0, 2, 0)
S.particleLighting = true; S.particleEmit = true; S.particleBlend = false
S.particleEmitHead = true; S.particleEmitTorso = true

local particleHead = nil
local particleTorso = nil
local function updateParticles()
	if S.particleEnabled then
		local c = getChar()
		if not c then return end
		local Head = c:FindFirstChild("Head")
		local Torso = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
		if S.particleEmitHead and Head then
			if not particleHead then
				particleHead = Instance.new("ParticleEmitter")
				particleHead.Name = "KitiParticleHead"
				particleHead.Texture = "rbxassetid://258128463"
				particleHead.LightEmission = 1
				particleHead.LightInfluence = S.particleLighting and 0 or 1
				particleHead.BlendMode = S.particleBlend and Enum.ParticleBlendMode.Additive or Enum.ParticleBlendMode.AlphaBlend
				particleHead.Parent = Head
			end
			particleHead.Color = ColorSequence.new(S.particleColor)
			particleHead.Size = NumberSequence.new(S.particleSize)
			particleHead.Transparency = NumberSequence.new(S.particleTransparency)
			particleHead.Speed = NumberRange.new(S.particlESPeed * 2, S.particlESPeed * 3)
			particleHead.Lifetime = NumberRange.new(S.particleLifetime * 0.7, S.particleLifetime)
			particleHead.Rate = S.particleRate
			particleHead.SpreadAngle = Vector2.new(S.particlESPread, S.particlESPread)
			particleHead.Rotation = NumberRange.new(S.particleRotation, S.particleRotation + 10)
			particleHead.Offset = S.particleOffset
			particleHead.EmissionDirection = Enum.NormalId.Top
			particleHead.Enabled = S.particleEmit
		else
			if particleHead then particleHead:Destroy() particleHead = nil end
		end
		if S.particleEmitTorso and Torso then
			if not particleTorso then
				particleTorso = Instance.new("ParticleEmitter")
				particleTorso.Name = "KitiParticleTorso"
				particleTorso.Texture = "rbxassetid://258128463"
				particleTorso.LightEmission = 1
				particleTorso.LightInfluence = S.particleLighting and 0 or 1
				particleTorso.BlendMode = S.particleBlend and Enum.ParticleBlendMode.Additive or Enum.ParticleBlendMode.AlphaBlend
				particleTorso.Parent = Torso
			end
			particleTorso.Color = ColorSequence.new(S.particleColor)
			particleTorso.Size = NumberSequence.new(S.particleSize * 0.8)
			particleTorso.Transparency = NumberSequence.new(S.particleTransparency)
			particleTorso.Speed = NumberRange.new(S.particlESPeed, S.particlESPeed * 2)
			particleTorso.Lifetime = NumberRange.new(S.particleLifetime * 0.5, S.particleLifetime)
			particleTorso.Rate = S.particleRate * 0.5
			particleTorso.SpreadAngle = Vector2.new(S.particlESPread, S.particlESPread)
			particleTorso.Rotation = NumberRange.new(S.particleRotation, S.particleRotation + 10)
			particleTorso.Offset = S.particleOffset
			particleTorso.EmissionDirection = Enum.NormalId.Front
			particleTorso.Enabled = S.particleEmit
		else
			if particleTorso then particleTorso:Destroy() particleTorso = nil end
		end
	else
		if particleHead then particleHead:Destroy() particleHead = nil end
		if particleTorso then particleTorso:Destroy() particleTorso = nil end
	end
end

local pTab = addTab("Particles", "?")
addSection(pTab, "Tool / Enabled")
addToggle(pTab, "Tool / Enabled", false, function(on)
	S.particleEnabled = on
	updateParticles()
	notify("Particles", on and "········" or "·········", 2)
end)
addDivider(pTab)
addSection(pTab, "Color")
addButton(pTab, "?? ···· ······", function()
	local Colors = {
		{ "·····", Color3.fromRGB(80, 170, 255) },
		{ "··········", Color3.fromRGB(180, 90, 255) },
		{ "·······", Color3.fromRGB(255, 105, 180) },
		{ "······", Color3.fromRGB(80, 255, 120) },
		{ "·········", Color3.fromRGB(255, 160, 60) },
		{ "·····", Color3.fromRGB(255, 255, 255) },
		{ "······", nil },
	}
	local idx = 1
	local idx2 = 0
	while true do
		idx2 = idx2 + 1
		if idx2 > #Colors then idx2 = 1 end
		S.particleColor = Colors[idx2][2] or Color3.fromHSV(tick() % 1, 1, 1)
		updateParticles()
		notify("Particles", "····: " .. Colors[idx2][1], 2)
		task.wait(1.5)
		if not S.particleEnabled then break end
	end
end)
addDivider(pTab)
addSection(pTab, "Size / Transparency / Speed / Lifetime")
addSlider(pTab, "Size", 0.1, 8, 1.5, function(v) S.particleSize = v; updateParticles() end, 2)
addSlider(pTab, "Transparency", 0, 1, 0.2, function(v) S.particleTransparency = v; updateParticles() end, 2)
addSlider(pTab, "Speed", 0.1, 10, 1, function(v) S.particlESPeed = v; updateParticles() end, 2)
addSlider(pTab, "Lifetime", 0.1, 5, 1.2, function(v) S.particleLifetime = v; updateParticles() end, 2)
addDivider(pTab)
addSection(pTab, "Rate / Spread / Rotation / Offset")
addSlider(pTab, "Rate", 1, 100, 25, function(v) S.particleRate = v; updateParticles() end)
addSlider(pTab, "Spread", 0, 360, 360, function(v) S.particlESPread = v; updateParticles() end)
addSlider(pTab, "Rotation", 0, 360, 0, function(v) S.particleRotation = v; updateParticles() end)
addSlider(pTab, "Offset Y", -5, 10, 2, function(v) S.particleOffset = Vector3.new(0, v, 0); updateParticles() end, 1)
addDivider(pTab)
addSection(pTab, "Lighting / Emit / Blend")
addToggle(pTab, "Lighting", true, function(on) S.particleLighting = on; updateParticles() end)
addToggle(pTab, "Emit", true, function(on) S.particleEmit = on; updateParticles() end)
addToggle(pTab, "Blend (Additive)", false, function(on) S.particleBlend = on; updateParticles() end)
addDivider(pTab)
addSection(pTab, "····· ········ (Emitters)")
addToggle(pTab, "Head (······)", true, function(on) S.particleEmitHead = on; updateParticles() end)
addToggle(pTab, "Torso (····)", true, function(on) S.particleEmitTorso = on; updateParticles() end)

task.spawn(function()
	while true do
		task.wait(0.15)
		pcall(updateParticles)
	end
end)

local petsTab = addTab("Питомцы", "🐾")
addSection(petsTab, "Питомцы")
addToggle(petsTab, "🐾 Включить питомцев", false, function(on)
	S.pets = on
	if on then spawnPets() else clearPets() end
	notify("Питомцы", on and "включены" or "выключены", 2)
end)
addSlider(petsTab, "Кол-во питомцев", 1, 10, 3, function(v) S.petCount = v; if S.pets then spawnPets() end end)
addSlider(petsTab, "Размер питомца", 0.5, 5, 1, function(v) S.petSize = v; if S.pets then spawnPets() end end, 1)
addSlider(petsTab, "Дистанция следования", 2, 20, 6, function(v) S.petFollowDist = v end, 1)
addToggle(petsTab, "🌈 РАдужные Питомцы", false, function(on) S.petRainbow = on end)
addToggle(petsTab, "➿ Следовать за игроком", true, function(on) S.petFollow = on end)
addButton(petsTab, "🐾 Заспавнить питомцев", function() spawnPets(); notify("Питомцы", "заспавнены", 2) end)
addButton(petsTab, "🧹 Убрать питомцев", function() clearPets(); notify("Питомцы", "убраны", 2) end)

local cmb = addTab("Бой", "✦")
addSection(cmb, "Aimbot")
addToggle(cmb, "Aimbot", false, function(on) S.Aimbot = on end)
addToggle(cmb, "Всегда целиться", false, function(on) S.AimAlways = on end)
addSlider(cmb, "FOV", 20, 400, 150, function(v) S.AimFOV = v end)
addSlider(cmb, "Плавность", 0, 1, 0.5, function(v) S.AimSmooth = v end, 2)
addDropdown(cmb, "Часть тела", { "Head", "HumanoidRootPart", "UpperTorso" }, "Head", function(v) S.AimPart = v end)
addDivider(cmb)
addSection(cmb, "Триггер и хитбоксы")
addToggle(cmb, "TRIGgerbot", false, function(on) S.TRIGger = on end)
addToggle(cmb, "Расширить хитбоксы", false, function(on)
	S.hitbox = on
	if not on then for _, p in ipairs(Players:GetPlayers()) do local hrp = hrpOf(p); if hrp then hrp.Size = Vector3.new(2, 2, 1) end end end
end)
addSlider(cmb, "Размер хитбокса", 2, 15, 6, function(v) S.hitboxSize = v end)
addDivider(cmb)
addSection(cmb, "Авто-кликер")
addToggle(cmb, "Авто-клик (левая кнопка)", false, function(on) S.autoClick = on end)
addSlider(cmb, "ЗАдержка (сек)", 0.01, 1, 0.1, function(v) S.autoClickDelay = v end, 2)

local vis2 = addTab("Визуал", "◎")
addSection(vis2, "Подсветка игроков")
addToggle(vis2, "ESP имена", false, function(on) S.ESPNames = on end)
addToggle(vis2, "ESP: HP и дистанция", false, function(on) S.ESPInfo = on end)
addToggle(vis2, "ESP подсветка", false, function(on) S.ESPHighlight = on end)
addToggle(vis2, "Цвет по роли (MM2)", true, function(on) S.ESPRole = on end)
addToggle(vis2, "ESP боксы", false, function(on)
	if on and not DrawingLib then notify("ESP", "Drawing недоступен", 5); return end
	S.ESPBox = on
end)
addToggle(vis2, "ESP трассеры", false, function(on)
	if on and not DrawingLib then notify("ESP", "Drawing недоступен", 5); return end
	S.ESPTracer = on
end)
addDivider(vis2)
addSection(vis2, "HUD")
addToggle(vis2, "Watermark", true, function(on) S.Watermark = on end)
addToggle(vis2, "HUD (FPS/ping/коорд.)", true, function(on) S.HUD = on end)
addToggle(vis2, "Прицел (crosshair)", false, function(on) S.crosshair = on end)
addDivider(vis2)
addSection(vis2, "Мир и HUD")
addToggle(vis2, "🌈 РАдужный ESP", false, function(on) S.rainbowESP = on end)
addToggle(vis2, "X-Ray (прозрачные стены)", false, function(on)
	S.xray = on
	if not on then
		pcall(function()
			for _, d in ipairs(workSpace:GetDescendants()) do
				if d:IsA("BasePart") then
					local o = d:GetAttribute("KitiOrigT")
					if o ~= nil then d.Transparency = o; d:SetAttribute("KitiOrigT", nil) end
				end
			end
		end)
	end
	notify("X-Ray", on and "включён" or "выключен", 2)
end)
addToggle(vis2, "HUD: время и игроки", true, function(on) S.HUDExtra = on end)

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
			local a = Lighting:FindFirstChilDOFClass("Atmosphere"); if a then a.Density = 0 end
			local b = Lighting:FindFirstChilDOFClass("bloomEffect"); if b then b.Intensity = 0 end
			local dd = Lighting:FindFirstChilDOFClass("DepthOfFieldEffect"); if dd then dd.FarIntensity = 0; dd.NearIntensity = 0 end
			local s = Lighting:FindFirstChilDOFClass("SunRaysEffect"); if s then s.Intensity = 0 end
		end)
	end
	notify("Красота", on and "включена" or "выключена", 2)
end)
addSlider(perf, "Насыщенность", 0, 1, 0.15, function(v) S.sat = v end, 2)
addSlider(perf, "Свечение (bloom)", 0, 3, 0.9, function(v) S.bloomI = v end, 2)
addToggle(perf, "Лучи солнца", true, function(on) S.sunraysOn = on end)
addToggle(perf, "Глубина резкости (DOF)", false, function(on) S.DOFOn = on end)
addButton(perf, "↩ Сбросить эффекты", function()
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Atmosphere") or v:IsA("bloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then v:Destroy() end
	end
	atmosphere, ColorCorr, bloom, DOF, sunrays = nil, nil, nil, nil, nil
	Lighting.EnvironmentDiffuseScale = 1; Lighting.EnvironmentSpecularScale = 1; Lighting.ExposureCompensation = 0
	notify("Эффекты", "сброшены", 2)
end)

local mg = addTab("Танчики", "🚀")
addSection(mg, "Мини-игра: Танчики")
local info = new("TextLabel", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "Управление: W/A/S/D — движение, Space — выстрел. Уничтожай врагов!", TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = mg })
local field = new("Frame", { Size = UDim2.fromOffset(560, 250), BackgroundColor3 = Color3.fromRGB(16, 18, 28), BorderSizePixel = 0, ClipsDescendants = true, Parent = mg })
corner(field, 12)
local scoreLbl = new("TextLabel", { Size = UDim2.fromOffset(200, 24), Position = UDim2.fromOffset(12, 6), BackgroundTransparency = 1, Text = "Счёт: 0", TextColor3 = Color3.fromRGB(140, 255, 200), Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 20, Parent = field })
local HPLbl = new("TextLabel", { Size = UDim2.fromOffset(200, 24), Position = UDim2.new(1, -212, 0, 6), BackgroundTransparency = 1, Text = "HP: 100", TextColor3 = Color3.fromRGB(255, 140, 140), Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 20, Parent = field })
local overLbl = new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBlack, TextSize = 30, ZIndex = 40, Visible = false, Parent = field })

local tank = { x = 280, y = 210, r = 13, cd = 0 }
local tankBody = new("Frame", { Size = UDim2.fromOffset(26, 26), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(90, 200, 255), BorderSizePixel = 0, ZIndex = 10, Parent = field })
corner(tankBody)
local tankBarrel = new("Frame", { Size = UDim2.fromOffset(4, 16), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(200, 240, 255), BorderSizePixel = 0, ZIndex = 11, Parent = tankBody })

local enemies = {}
local bullets = {}
local score = 0
local HP = 100
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
	score = 0; HP = 100; spawnTimer = 0
	tank.x, tank.y = 280, 210
	scoreLbl.Text = "Счёт: 0"; HPLbl.Text = "HP: 100"; overLbl.Text = ""
	scoreLbl.Visible = true; HPLbl.Visible = true; overLbl.Visible = false
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
						HP = HP - 20
						HPLbl.Text = "HP: " .. math.max(0, HP)
						dead = true
						if HP <= 0 then
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

addButton(mg, "▶ запустить игру", function() startTanks() end)
addButton(mg, "■ Стоп", function() stopTanks() end)

local plr = addTab("Игроки", "👥")
addSection(plr, "онлайн-игроки")
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
				if hrp and thrp then hrp.CFrame = thrp.CFrame + Vector3.new(0, 3, 0); notify("телепорт", "к " .. p.Name, 2) end
			end)
			local sp = new("TextButton", { Size = UDim2.fromOffset(70, 30), Position = UDim2.new(1, -140, 0.5, -15), BackgroundColor3 = T.element, Text = "Следить", TextColor3 = T.text, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, Parent = rowP })
			corner(sp)
			sp.MouseButton1Click:Connect(function()
				local hum = p.Character and p.Character:FindFirstChilDOFClass("Humanoid")
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
local bgm = new("Sound", { SoundID = "rbxassetid://0", Volume = 2, Looped = false, Parent = SoundService })
addSection(mus, "Плеер (слышишь только ты)")
addBox(mus, "Sound ID + Enter", function(t) S.soundID = tonumber(t:gsub("%D", "")) or 0; notify("Звук", "ID = " .. tostring(S.soundId), 2) end)
addButton(mus, "▶ Играть", function()
	if not S.soundId or S.soundID == 0 then notify("Звук", "введи ID", 3); return end
	bgm.SoundID = "rbxassetid://" .. S.soundId
	pcall(function() bgm:Play() end)
end)
addButton(mus, "⏹ Стоп", function() pcall(function() bgm:Stop() end) end)
addSlider(mus, "Громкость", 0, 10, 2, function(v) bgm.Volume = v end, 1)
addToggle(mus, "Зациклить", false, function(on) bgm.Looped = on end)
addDivider(mus)
addSection(mus, "Быстрые треки")
for _, tr in ipairs({ { "Roblox default", 9046141279 }, { "Among Us drip", 6584745192 }, { "Elevator music", 6756055776 } }) do
	addButton(mus, "🎵 " .. tr[1], function()
		S.soundID = tr[2]
		bgm.SoundID = "rbxassetid://" .. tr[2]
		bgm.Looped = true
		pcall(function() bgm:Play() end)
		notify("Звук", tr[1], 2)
	end)
end

local map = addTab("Карта", "🗺")
addSection(map, "Minimap")
local mm = new("Frame", { Size = UDim2.fromOffset(380, 280), BackgroundColor3 = T.card, Parent = map })
corner(mm)
new("UIListLayout", { Parent = mm, FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 6) })
new("TextLabel", { Size = UDim2.new(1, -20, 0, 22), Position = UDim2.fromOffset(10, 6), BackgroundTransparency = 1, Text = "Простая мини-карта (только ты)", TextColor3 = T.sub, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = mm })
local mmCan = new("Frame", { Size = UDim2.new(1, -20, 1, -36), Position = UDim2.fromOffset(10, 30), BackgroundColor3 = Color3.fromRGB(240, 242, 252), ClipsDescendants = true, Parent = mm })
corner(mmCan)
new("UIStroke", { Color = T.accent1, Thickness = 1, Transparency = 0.6, Parent = mmCan })
local mmYou = new("Frame", { Size = UDim2.fromOffset(8, 8), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(86, 198, 255), BorderSizePixel = 0, ZIndex = 10, Parent = mmCan })
corner(mmYou)

task.spawn(function()
	while true do
		task.wait(0.15)
		local hrp = getHRP()
		if hrp then
			local c = mmCan.AbsoluteSize
			mmYou.Position = UDim2.new(0.5, 0, 0.5, 0)
		end
	end
end)

local fun = addTab("Фан", "🎉")
addSection(fun, "Приколы")
addToggle(fun, "🌈 РАдужный мир", false, function(on) S.rainbowWorld = on end)
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
		local p = new("Part", { Size = Vector3.new(0.35, 0.35, 0.35), Anchored = true, CanCollide = false, Color = Color3.fromHSV(math.random(), 1, 1), Material = Enum.Material.Neon, Parent = workSpace })
		p.CFrame = hrp.CFrame * CFrame.new(math.random(-6, 6), math.random(2, 8), math.random(-6, 6))
		new("BodyVelocity", { Velocity = Vector3.new(math.random(-15, 15), math.random(12, 26), math.random(-15, 15)), MaxForce = Vector3.new(1e5, 1e5, 1e5), Parent = p })
		task.delay(3, function() p:Destroy() end)
	end
end)
addButton(fun, "🎈 Спавн шара", function()
	local hrp = getHRP()
	if hrp then
		local p = new("Part", { Shape = Enum.PartType.Ball, Size = Vector3.new(3, 3, 3), Anchored = true, CanCollide = false, Material = Enum.Material.Neon, Color = Color3.fromHSV(math.random(), 1, 1), Parent = workSpace })
		p.CFrame = hrp.CFrame * CFrame.new(0, 5, -6)
	end
end)
addButton(fun, "📸 Мем-текст нАд головой", function()
	local Head = getChar() and getChar():FindFirstChild("Head")
	if not Head then return end
	if Head:FindFirstChild("MemeTag") then Head.MemeTag:Destroy() end
	local bb = new("BillboardGui", { Name = "MemeTag", Size = UDim2.fromOffset(260, 60), StudsOffset = Vector3.new(0, 3.6, 0), AlwaysOnTop = true, Parent = Head })
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
	notify("телепорт", "заходим в " .. name .. "...", 4)
	task.spawn(function()
		local ok, err = pcall(function() TPS:Teleport(placeId, LP) end)
		if not ok then notify("телепорт", "не удалось: " .. tostring(err), 5) end
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
	if not ok then notify("Server", "Server hop недоступен (HTTP)", 5) end
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
	if h then h.WalkSpeed = S.Speed; h.UseJumpPower = true; h.JumpPower = S.jump end
	Cam.FielDOFView = S.FOV
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

local Watermark = new("TextLabel", { Name = "WM", Parent = sg, BackgroundTransparency = 1, Size = UDim2.new(0, 320, 0, 22), Position = UDim2.fromOffset(14, 10), Text = "KITI · PROTO | RightShift - hide", TextColor3 = T.accent1, Font = Enum.Font.GothamBlack, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 0.7, TextStrokeColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 100 })

local HUD = new("Frame", { Name = "HUD", Parent = sg, BackgroundColor3 = T.card, BackgroundTransparency = 0.15, Size = UDim2.fromOffset(210, 122), Position = UDim2.new(0, 14, 0, 40), BorderSizePixel = 0, ZIndex = 90 })
corner(HUD, 12)
stroke(HUD, T.accent1, 1.2, 0.5)
new("UIListLayout", { Parent = HUD, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder })
new("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 14), Parent = HUD })
new("TextLabel", { Size = UDim2.new(1, -14, 0, 16), BackgroundTransparency = 1, Text = "KITI HUD", TextColor3 = T.accent1, Font = Enum.Font.GothamBlack, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = HUD })
local HUDFps = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "FPS: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = HUD })
local HUDPing = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Ping: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = HUD })
local HUDPos = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Pos: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = HUD })
local HUDTime = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Time: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = HUD })
local HUDPl = new("TextLabel", { Size = UDim2.new(1, -14, 0, 15), BackgroundTransparency = 1, Text = "Players: -", TextColor3 = T.text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = HUD })

task.spawn(function()
	local pname = "game " .. tostring(game.PlaceId)
	pcall(function() pname = MPS:GetProductInfo(game.PlaceId).Name end)
	subtitle.Text = pname .. "  ·  " .. LP.Name
end)

local frames = 0
task.spawn(function()
	while true do
		task.wait(1)
		if S.HUD then
			HUDFps.Text = "FPS: " .. frames
			local ping = 0
			pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			HUDPing.Text = "Ping: " .. ping .. " ms"
			local hrp = getHRP()
			if hrp then HUDPos.Text = string.format("Pos: %d, %d, %d", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) end
			if S.HUDExtra then
				HUDTime.Visible = true; HUDPl.Visible = true
				HUDTime.Text = string.format("Time: %02d:%02d", math.floor(Lighting.ClockTime) % 24, math.floor((Lighting.ClockTime % 1) * 60))
				HUDPl.Text = "Players: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers
			else
				HUDTime.Visible = false; HUDPl.Visible = false
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
					ColorCorr.Saturation = S.sat; ColorCorr.Contrast = 0.08
					bloom.Intensity = S.bloomI; bloom.Size = 24; bloom.Threshold = 0.9
					sunrays.Intensity = S.sunraysOn and 0.1 or 0; sunrays.Spread = 1
					if S.DOFOn then
						DOF.FarIntensity = 0.18; DOF.FocusDistance = 40; DOF.InFocusRadius = 25; DOF.NearIntensity = 0.12
					else DOF.FarIntensity = 0; DOF.NearIntensity = 0 end
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
				ensureEffects(); ColorCorr.TintColor = cc
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
				for _, d in ipairs(workSpace:GetDescendants()) do
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
				else VU:Button1Down(Vector2.new(0, 0), workSpace.CurrentCamera.CFrame); task.wait(0.02); VU:Button1Up(Vector2.new(0, 0), workSpace.CurrentCamera.CFrame) end
			end)
			task.wait(S.autoClickDelay)
		else
			task.wait(0.1)
		end
	end
end)

local cross = DrawingLib and DrawingLib.new and DrawingLib.new("Circle") or nil
if cross then cross.Filled = false; cross.Thickness = 1.5; cross.Color = Color3.fromRGB(255, 255, 255); cross.Transparency = 0.3; cross.Visible = false end
local FOVCircle = DrawingLib and DrawingLib.new and DrawingLib.new("Circle") or nil
if FOVCircle then FOVCircle.Filled = false; FOVCircle.Thickness = 1.5; FOVCircle.Color = T.accent1; FOVCircle.Transparency = 0.4; FOVCircle.Visible = false end

RS.RenderStepped:Connect(function(dt)
	frames = frames + 1
	local ok = pcall(function()
		local cEnter = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
		HUD.Visible = S.HUD
		Watermark.Visible = S.Watermark
		if cross then cross.Position = cEnter; cross.Radius = 6; cross.Visible = S.crosshair end
		if FOVCircle then FOVCircle.Position = cEnter; FOVCircle.Radius = S.AimFOV; FOVCircle.Visible = S.Aimbot end

		if S.Noclip then
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
		if hum and hum.WalkSpeed ~= S.Speed then hum.WalkSpeed = S.Speed end

		if S.CopyHats then
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
									local HP0 = cl:IsA("BasePart") and cl or cl:FindFirstChildWhichIsA("BasePart")
									if HP0 then
										local weld = new("WeldConstraint", { Parent = HP0 })
										weld.Part0 = myHead; weld.Part1 = HP0
										HP0.CFrame = myHead.CFrame
									end
								end
							end
						end
					end
				end
			end
		end

		if S.clockLock then Lighting.ClockTime = S.clock end

		if S.Aimbot then
			local firing = S.AimAlways or UIS:IsKeyDown(S.AimKey)
			if firing then
				local _, tpos = findTarget()
				if tpos then
					local goal = CFrame.new(Cam.CFrame.Position, tpos)
					if S.AimSmooth <= 0.01 then Cam.CFrame = goal else Cam.CFrame = Cam.CFrame:Lerp(goal, 1 - S.AimSmooth) end
				end
			end
		end

		if S.TRIGger and UIS:IsKeyDown(S.TRIGgerKey) then
			if findTarget() then
				local c = getChar()
				local tool = c and c:FindFirstChilDOFClass("Tool")
				if tool then pcall(function() tool:Activate() end) end
			end
		end

		if S.ESPNames or S.ESPBox or S.ESPTracer or S.ESPHighlight then
			for _, p in ipairs(Players:GetPlayers()) do
				local c = p.Character
				local Head = c and c:FindFirstChild("Head")
				local hrp = c and c:FindFirstChild("HumanoidRootPart")
				local hum2 = c and c:FindFirstChilDOFClass("Humanoid")
				if p ~= LP and Head and hrp and hum2 and hum2.Health > 0 then
					local col = S.rainbowESP and Color3.fromHSV(tick() % 1, 1, 1) or roleColor(p)
					if S.ESPNames then
						local tag = Head:FindFirstChild("KitiName")
						if not tag then
							tag = new("BillboardGui", { Name = "KitiName", Size = UDim2.fromOffset(220, 40), StudsOffset = Vector3.new(0, 2.6, 0), AlwaysOnTop = true, Parent = Head })
							new("TextLabel", { Name = "L", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 13, TextStrokeTransparency = 0, Parent = tag })
						end
						local lbl = tag:FindFirstChild("L")
						local info
						if S.ESPInfo then
							local myhrp = getHRP()
							local d = myhrp and math.floor((myhrp.Position - hrp.Position).Magnitude) or 0
							info = " [" .. roleOf(p) .. "] " .. math.floor(hum2.Health) .. "HP " .. d .. "m"
						else
							info = " [" .. roleOf(p) .. "]"
						end
						lbl.Text = p.Name .. info
						lbl.TextColor3 = col
					else
						local tag = Head:FindFirstChild("KitiName"); if tag then tag:Destroy() end
					end
					if S.ESPHighlight then
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
						local top = w2s(Head.Position + Vector3.new(0, 0.7, 0))
						local bot = w2s(hrp.Position - Vector3.new(0, 3, 0))
						if top and bot and S.ESPBox then
							local h = math.abs(bot.Y - top.Y); local w = h * 0.55
							v.box.Position = Vector2.new(top.X - w / 2, math.min(top.Y, bot.Y)); v.box.Size = Vector2.new(w, h); v.box.Visible = true
						else v.box.Visible = false end
						if top and S.ESPTracer then
							v.tracer.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y); v.tracer.To = Vector2.new(top.X, top.Y); v.tracer.Visible = true
						else v.tracer.Visible = false end
					end
				else
					if Head then local tag = Head:FindFirstChild("KitiName"); if tag then tag:Destroy() end end
					if c then local hl = c:FindFirstChild("KitiHL"); if hl then hl:Destroy() end end
					if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
				end
			end
		else
			for _, p in ipairs(Players:GetPlayers()) do
				local c = p.Character
				if c then
					local hl = c:FindFirstChild("KitiHL"); if hl then hl:Destroy() end
					local Head = c:FindFirstChild("Head"); if Head then local tag = Head:FindFirstChild("KitiName"); if tag then tag:Destroy() end end
				end
				if visuals[p] then clearVisual(visuals[p]); visuals[p] = nil end
			end
		end

		if S.Fly then
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
					if dir.Magnitude > 0 then bv.Velocity = dir.Unit * S.FlySpeed else bv.Velocity = Vector3.new(0, 0, 0) end
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
	if i.UserInputType == Enum.UserInputType.Keyboard then
		if i.KeyCode == S.menuKey then
			win.Visible = not win.Visible
			if gamesWin then gamesWin.Visible = win.Visible and gamesWin.Visible end
		end
		if i.KeyCode == Enum.KeyCode.RightShift then
			win.Visible = not win.Visible
		end
	end
	if S.clickTp and i.UserInputType == Enum.UserInputType.MouseButton1 then
		local ok = pcall(function()
			local unitRay = Cam:ViewportPointToRay(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
			local ray = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
			local hit = workSpace:FindPartOnRay(ray, LP.Character)
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
topBtn("◈", -110, function()
	TS:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
	task.delay(0.45, function()
		win.Visible = false
		notify("KITI", "Меню скрыто. Нажми " .. S.menuKey.Name .. " или RightShift чтобы открыть", 4)
	end)
end)
topBtn("×", -42, function()
	sg:Destroy()
	print("[KITI-PROTO] V6 closed")
end)

notify("KITI · PROTO", "tablet edition загружен. Меню: " .. S.menuKey.Name .. " | скрыть: RightShift", 5)
print("[KITI-PROTO] V6 loaded")


S.particleEnabled = false; S.particleColor = Color3.fromRGB(80, 170, 255)
S.particleSize = 1.5; S.particleTransparency = 0.2; S.particlESPeed = 1
S.particleLifetime = 1.2; S.particleRate = 25; S.particlESPread = 360
S.particleRotation = 0; S.particleOffset = Vector3.new(0, 2, 0)
S.particleLighting = true; S.particleEmit = true; S.particleBlend = false
S.particleEmitHead = true; S.particleEmitTorso = true

local particleHead = nil
local particleTorso = nil
local function updateParticles()
	if S.particleEnabled then
		local c = getChar()
		if not c then return end
		local Head = c:FindFirstChild("Head")
		local Torso = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
		if S.particleEmitHead and Head then
			if not particleHead then
				particleHead = Instance.new("ParticleEmitter")
				particleHead.Name = "KitiParticleHead"
				particleHead.Texture = "rbxassetid://258128463"
				particleHead.LightEmission = 1
				particleHead.LightInfluence = S.particleLighting and 0 or 1
				particleHead.BlendMode = S.particleBlend and Enum.ParticleBlendMode.Additive or Enum.ParticleBlendMode.AlphaBlend
				particleHead.Parent = Head
			end
			particleHead.Color = ColorSequence.new(S.particleColor)
			particleHead.Size = NumberSequence.new(S.particleSize)
			particleHead.Transparency = NumberSequence.new(S.particleTransparency)
			particleHead.Speed = NumberRange.new(S.particlESPeed * 2, S.particlESPeed * 3)
			particleHead.Lifetime = NumberRange.new(S.particleLifetime * 0.7, S.particleLifetime)
			particleHead.Rate = S.particleRate
			particleHead.SpreadAngle = Vector2.new(S.particlESPread, S.particlESPread)
			particleHead.Rotation = NumberRange.new(S.particleRotation, S.particleRotation + 10)
			particleHead.Offset = S.particleOffset
			particleHead.EmissionDirection = Enum.NormalId.Top
			particleHead.Enabled = S.particleEmit
		else
			if particleHead then particleHead:Destroy() particleHead = nil end
		end
		if S.particleEmitTorso and Torso then
			if not particleTorso then
				particleTorso = Instance.new("ParticleEmitter")
				particleTorso.Name = "KitiParticleTorso"
				particleTorso.Texture = "rbxassetid://258128463"
				particleTorso.LightEmission = 1
				particleTorso.LightInfluence = S.particleLighting and 0 or 1
				particleTorso.BlendMode = S.particleBlend and Enum.ParticleBlendMode.Additive or Enum.ParticleBlendMode.AlphaBlend
				particleTorso.Parent = Torso
			end
			particleTorso.Color = ColorSequence.new(S.particleColor)
			particleTorso.Size = NumberSequence.new(S.particleSize * 0.8)
			particleTorso.Transparency = NumberSequence.new(S.particleTransparency)
			particleTorso.Speed = NumberRange.new(S.particlESPeed, S.particlESPeed * 2)
			particleTorso.Lifetime = NumberRange.new(S.particleLifetime * 0.5, S.particleLifetime)
			particleTorso.Rate = S.particleRate * 0.5
			particleTorso.SpreadAngle = Vector2.new(S.particlESPread, S.particlESPread)
			particleTorso.Rotation = NumberRange.new(S.particleRotation, S.particleRotation + 10)
			particleTorso.Offset = S.particleOffset
			particleTorso.EmissionDirection = Enum.NormalId.Front
			particleTorso.Enabled = S.particleEmit
		else
			if particleTorso then particleTorso:Destroy() particleTorso = nil end
		end
	else
		if particleHead then particleHead:Destroy() particleHead = nil end
		if particleTorso then particleTorso:Destroy() particleTorso = nil end
	end
end

local pTab = addTab("Particles", "?")
addSection(pTab, "Tool / Enabled")
addToggle(pTab, "Tool / Enabled", false, function(on)
	S.particleEnabled = on
	updateParticles()
	notify("Particles", on and "········" or "·········", 2)
end)
addDivider(pTab)
addSection(pTab, "Color")
addButton(pTab, "?? ···· ······", function()
	local Colors = {
		{ "·····", Color3.fromRGB(80, 170, 255) },
		{ "··········", Color3.fromRGB(180, 90, 255) },
		{ "·······", Color3.fromRGB(255, 105, 180) },
		{ "······", Color3.fromRGB(80, 255, 120) },
		{ "·········", Color3.fromRGB(255, 160, 60) },
		{ "·····", Color3.fromRGB(255, 255, 255) },
		{ "······", nil },
	}
	local idx = 1
	local idx2 = 0
	while true do
		idx2 = idx2 + 1
		if idx2 > #Colors then idx2 = 1 end
		S.particleColor = Colors[idx2][2] or Color3.fromHSV(tick() % 1, 1, 1)
		updateParticles()
		notify("Particles", "····: " .. Colors[idx2][1], 2)
		task.wait(1.5)
		if not S.particleEnabled then break end
	end
end)
addDivider(pTab)
addSection(pTab, "Size / Transparency / Speed / Lifetime")
addSlider(pTab, "Size", 0.1, 8, 1.5, function(v) S.particleSize = v; updateParticles() end, 2)
addSlider(pTab, "Transparency", 0, 1, 0.2, function(v) S.particleTransparency = v; updateParticles() end, 2)
addSlider(pTab, "Speed", 0.1, 10, 1, function(v) S.particlESPeed = v; updateParticles() end, 2)
addSlider(pTab, "Lifetime", 0.1, 5, 1.2, function(v) S.particleLifetime = v; updateParticles() end, 2)
addDivider(pTab)
addSection(pTab, "Rate / Spread / Rotation / Offset")
addSlider(pTab, "Rate", 1, 100, 25, function(v) S.particleRate = v; updateParticles() end)
addSlider(pTab, "Spread", 0, 360, 360, function(v) S.particlESPread = v; updateParticles() end)
addSlider(pTab, "Rotation", 0, 360, 0, function(v) S.particleRotation = v; updateParticles() end)
addSlider(pTab, "Offset Y", -5, 10, 2, function(v) S.particleOffset = Vector3.new(0, v, 0); updateParticles() end, 1)
addDivider(pTab)
addSection(pTab, "Lighting / Emit / Blend")
addToggle(pTab, "Lighting", true, function(on) S.particleLighting = on; updateParticles() end)
addToggle(pTab, "Emit", true, function(on) S.particleEmit = on; updateParticles() end)
addToggle(pTab, "Blend (Additive)", false, function(on) S.particleBlend = on; updateParticles() end)
addDivider(pTab)
addSection(pTab, "····· ········ (Emitters)")
addToggle(pTab, "Head (······)", true, function(on) S.particleEmitHead = on; updateParticles() end)
addToggle(pTab, "Torso (····)", true, function(on) S.particleEmitTorso = on; updateParticles() end)

task.spawn(function()
	while true do
		task.wait(0.15)
		pcall(updateParticles)
	end
end)

local petsTab = addTab("·······", "??")
addSection(petsTab, "·······")
addToggle(petsTab, "?? ········ ········", false, function(on)
	S.pets = on
	if on then spawnPets() else clearPets() end
	notify("·······", on and "········" or "·········", 2)
end)
addSlider(petsTab, "···-·· ········", 1, 10, 3, function(v) S.petCount = v; if S.pets then spawnPets() end end)
addSlider(petsTab, "······ ·······", 0.5, 5, 1, function(v) S.petSize = v; if S.pets then spawnPets() end end, 1)
addSlider(petsTab, "········· ··········", 2, 20, 6, function(v) S.petFollowDist = v end, 1)
addToggle(petsTab, "?? ········ ·······", false, function(on) S.petRainbow = on end)
addToggle(petsTab, "? ········· ·· ·······", true, function(on) S.petFollow = on end)
addButton(petsTab, "?? ·········· ········", function() spawnPets(); notify("·······", "··········", 2) end)
addButton(petsTab, "?? ······ ········", function() clearPets(); notify("·······", "······", 2) end)

-- KITI PROTO V6 ADDON: REAL VISUALS + PETS + UTILITIES
local function getChar() return game.Players.LocalPlayer.Character end
local function getHRP() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=getChar(); return c and c:FindFirstChilDOFClass("Humanoid") end

S.skel = false; S.HPbar = false; S.chams = false; S.btrac = false; S.team = true; S.pets = false
S.petModel = "Ball"; S.petCount = 3; S.petSize = 1; S.petColor = Color3.fromRGB(126,108,255); S.petRainbow = false; S.petFollowDist = 6
S.theme = "dark"; S.rainbowUI = false; S.spin = false; S.spinSpeed = 15; S.antifling = false; S.Aimvis = false; S.arrows = false; S.atmos = false; S.atmosdens = 0.25
S.tracersAll = false; S.box3d = false; S.name3d = false; S.outline = false

local pets = {}
local function clearPets()
	for _,p in ipairs(pets) do p:Destroy() end pets = {}
end

local function spawnPets()
	clearPets()
	local hrp = getHRP()
	if not S.pets or not hrp then return end
	for i=1, S.petCount do
		local part = Instance.new("Part")
		part.Shape = Enum.PartType.Ball
		part.Size = Vector3.new(S.petSize, S.petSize, S.petSize)
		part.Material = Enum.Material.Neon
		part.Color = S.petRainbow and Color3.fromHSV(tick()%1,1,1) or S.petColor
		part.CanCollide = false
		part.Anchored = false
		part.Parent = workSpace
		local bp = Instance.new("BodyPosition", part)
		bp.MaxForce = Vector3.new(1e5,1e5,1e5)
		local bg = Instance.new("BodyGyro", part)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
		bg.P = 3000
		table.insert(pets, part)
		task.delay(i*0.01, function()
			if part.Parent and hrp.Parent then part.CFrame = hrp.CFrame*CFrame.new(math.sin(i)*S.petFollowDist, 3, math.cos(i)*S.petFollowDist) end
		end)
	end
end

local themes = {
	light = {bg=Color3.fromRGB(244,245,251), card=Color3.fromRGB(255,255,255), text=Color3.fromRGB(28,30,46), sub=Color3.fromRGB(124,128,152), accent1=Color3.fromRGB(126,108,255), accent2=Color3.fromRGB(86,198,255)},
	dark  = {bg=Color3.fromRGB(14,15,22),  card=Color3.fromRGB(20,22,32),  text=Color3.fromRGB(240,242,255), sub=Color3.fromRGB(150,155,190), accent1=Color3.fromRGB(140,120,255), accent2=Color3.fromRGB(95,205,255)},
	neon  = {bg=Color3.fromRGB(10,8,20),   card=Color3.fromRGB(16,12,32),  text=Color3.fromRGB(250,248,255), sub=Color3.fromRGB(190,170,255), accent1=Color3.fromRGB(180,90,255),  accent2=Color3.fromRGB(90,210,255)},
	amoled= {bg=Color3.fromRGB(0,0,0),     card=Color3.fromRGB(10,10,12),  text=Color3.fromRGB(235,235,240), sub=Color3.fromRGB(160,160,170), accent1=Color3.fromRGB(160,130,255), accent2=Color3.fromRGB(100,210,255)},
}
local function applyTheme()
	local t = themes[S.theme]
	if not t then return end
	T.bg=T.bg; T.card=t.card; T.text=t.text; T.sub=t.sub; T.accent1=t.accent1; T.accent2=t.accent2
end

local hellTab = addTab("··", "??")
addSection(hellTab, "········ ···")
addButton(hellTab, "?? ········ ··", function()
	Lighting.Ambient = Color3.fromRGB(60, 20, 20)
	Lighting.OutdoorAmbient = Color3.fromRGB(80, 30, 30)
	Lighting.Brightness = 0.8
	Lighting.ClockTime = 0
	Lighting.FogColor = Color3.fromRGB(120, 40, 40)
	Lighting.FogEnd = 800
	Lighting.FogStart = 0
	local sky = Lighting:FindFirstChilDOFClass("Sky")
	if not sky then sky = Instance.new("Sky") sky.Parent = Lighting end
	sky.SkyboxBk = "rbxassetid://159454299"
	sky.SkyboxDn = "rbxassetid://159454296"
	sky.SkyboxFt = "rbxassetid://159454293"
	sky.SkyboxLf = "rbxassetid://159454286"
	sky.SkyboxRt = "rbxassetid://159454300"
	sky.SkyboxUp = "rbxassetid://159454288"
	sky.StarCount = 0
	sky.CelestialBodiesShown = false
	for _, d in ipairs(workSpace:GetDescendants()) do
		if d:IsA("BasePart") and d.Anchored and d.Size.Y > 50 then
			d.Color = Color3.fromRGB(60, 30, 30)
			d.Material = Enum.Material.Slate
		end
	end
	local portal = Instance.new("Part")
	portal.Shape = Enum.PartType.Ball
	portal.Size = Vector3.new(30, 30, 30)
	portal.Position = Vector3.new(0, 50, -200)
	portal.Anchored = true
	portal.CanCollide = false
	portal.Material = Enum.Material.Neon
	portal.Color = Color3.fromRGB(40, 10, 10)
	portal.Parent = workSpace
	local ring = Instance.new("Part")
	ring.Shape = Enum.PartType.Cylinder
	ring.Size = Vector3.new(2, 40, 40)
	ring.CFrame = portal.CFrame * CFrame.Angles(0, 0, math.rad(90))
	ring.Anchored = true
	ring.CanCollide = false
	ring.Material = Enum.Material.Neon
	ring.Color = Color3.fromRGB(180, 90, 255)
	ring.Parent = workSpace
	local pe = Instance.new("ParticleEmitter", ring)
	pe.Texture = "rbxassetid://258128463"
	pe.Rate = 80
	pe.Lifetime = NumberRange.new(0.5, 1.5)
	pe.Speed = NumberRange.new(5, 15)
	pe.SpreadAngle = Vector2.new(360, 360)
	pe.Color = ColorSequence.new(Color3.fromRGB(180, 90, 255))
	pe.Size = NumberSequence.new(1)
	pe.LightEmission = 1
	task.spawn(function()
		while ring.Parent do
			ring.CFrame = ring.CFrame * CFrame.Angles(0, math.rad(1), 0)
			task.wait(0.03)
		end
	end)
	notify("··", "········ ··· ·······", 3)
end)
addButton(hellTab, "? ······· ···", function()
	Lighting.Ambient = Color3.fromRGB(140, 140, 140)
	Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	clearSky()
	notify("··", "······· ···", 2)
end)

local topBar = new("Frame", { Size = UDim2.fromOffset(220, 36), Position = UDim2.new(1, -230, 0, 8), BackgroundColor3 = Color3.fromRGB(20, 22, 32), BackgroundTransparency = 0.15, BorderSizePixel = 0, Active = true, Draggable = true, ZIndex = 60, Parent = sg })
corner(topBar, 12)
stroke(topBar, Color3.fromRGB(126, 108, 255), 1, 0.5)

local function topToggle(label, state, cb)
	local t = new("TextButton", { Size = UDim2.fromOffset(50, 24), Position = UDim2.fromOffset(8, 6), BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 90), Text = label, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 10, AutoButtonColor = false, ZIndex = 61, Parent = topBar })
	corner(t, 6)
	t.MouseButton1Click:Connect(function()
		state = not state
		t.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 90)
		t.Text = label .. (state and " ON" or " OFF")
		cb(state)
	end)
	t.Text = label .. (state and " ON" or " OFF")
	return t
end

local AimBtn = topToggle("Aim", false, function(on) togglesById["Aimbot"]:Set(on) end)
AimBtn.Position = UDim2.fromOffset(8, 6)
local ESPBtn = topToggle("ESP", false, function(on) togglesById["ESP ·····"]:Set(on) end)
ESPBtn.Position = UDim2.fromOffset(64, 6)
local TRIGBtn = topToggle("TRIG", false, function(on) togglesById["TRIGgerbot"]:Set(on) end)
TRIGBtn.Position = UDim2.fromOffset(120, 6)
local gearBtn = new("TextButton", { Size = UDim2.fromOffset(36, 24), Position = UDim2.new(1, -42, 0, 6), BackgroundColor3 = Color3.fromRGB(126, 108, 255), Text = "?", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, ZIndex = 61, Parent = topBar })
corner(gearBtn, 8)
gearBtn.MouseButton1Click:Connect(function() clickSnd(); win.Visible = not win.Visible end)

local recLbl = new("TextLabel", { Size = UDim2.new(0, 160, 0, 20), Position = UDim2.new(1, -180, 0, 48), BackgroundTransparency = 1, Text = "? Recording has started", TextColor3 = Color3.fromRGB(255, 80, 80), Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 60, Parent = sg })

local SideBar = new("Frame", { Size = UDim2.fromOffset(44, 300), Position = UDim2.new(0, 8, 0.5, -150), BackgroundColor3 = Color3.fromRGB(20, 22, 32), BackgroundTransparency = 0.1, BorderSizePixel = 0, Active = true, Draggable = true, ZIndex = 55, Parent = sg })
corner(SideBar, 14)
stroke(SideBar, Color3.fromRGB(126, 108, 255), 1, 0.5)
local statueBtn = new("TextButton", { Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0.5, -16, 16), BackgroundColor3 = Color3.fromRGB(126, 108, 255), Text = "??", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, ZIndex = 56, Parent = SideBar })
corner(statueBtn, 10)
statueBtn.MouseButton1Click:Connect(function() clickSnd(); notify("SideBar", "·······", 2) end)
local globeBtn = new("TextButton", { Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0.5, -16, 60), BackgroundColor3 = Color3.fromRGB(80, 80, 90), Text = "??", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, ZIndex = 56, Parent = SideBar })
corner(globeBtn, 10)
globeBtn.MouseButton1Click:Connect(function() clickSnd(); hellTab.btn.MouseButton1Click:Fire() end)
local skullBtn = new("TextButton", { Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0.5, -16, 104), BackgroundColor3 = Color3.fromRGB(80, 80, 90), Text = "??", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, ZIndex = 56, Parent = SideBar })
corner(skullBtn, 10)
skullBtn.MouseButton1Click:Connect(function() clickSnd(); notify("SideBar", "··", 2) end)

local avatarImg = new("ImageLabel", { Size = UDim2.fromOffset(64, 64), Position = UDim2.new(1, -74, 1, -74), BackgroundColor3 = Color3.fromRGB(20, 22, 32), BorderSizePixel = 0, Image = "rbxassetid://6764432320", ZIndex = 58, Parent = sg })
corner(avatarImg, 12)
new("UIStroke", { Color = Color3.fromRGB(126, 108, 255), Thickness = 1, Parent = avatarImg })

local SkeletonConn = nil
local function drawSkeleton(p, col)
	local c = p.Character
	if not c then return end
	local hrp = c:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
	local joints = {}
	for _, n in ipairs(parts) do
		local pr = c:FindFirstChild(n)
		if pr then joints[n] = pr end
	end
	local v = visuals[p]
	if not v.bones then
		v.bones = {}
		for i = 1, 15 do
			v.bones[i] = DrawingLib and DrawingLib.new("Line") or nil
			if v.bones[i] then v.bones[i].Thickness = 1 v.bones[i].Transparency = 0.4 end
		end
	end
	local segs = {}
	local function seg(a, b)
		if joints[a] and joints[b] then table.insert(segs, {joints[a], joints[b]}) end
	end
	seg("Head", "UpperTorso") seg("Head", "Torso")
	seg("UpperTorso", "LowerTorso") seg("Torso", "LowerTorso")
	seg("UpperTorso", "LeftUpperArm") seg("UpperTorso", "RightUpperArm")
	seg("LeftUpperArm", "LeftLowerArm") seg("LeftLowerArm", "LeftHand")
	seg("RightUpperArm", "RightLowerArm") seg("RightLowerArm", "RightHand")
	seg("LowerTorso", "LeftUpperLeg") seg("LowerTorso", "RightUpperLeg")
	seg("LeftUpperLeg", "LeftLowerLeg") seg("LeftLowerLeg", "LeftFoot")
	seg("RightUpperLeg", "RightLowerLeg") seg("RightLowerLeg", "RightFoot")
	for i, s in ipairs(segs) do
		if i <= #v.bones then
			local line = v.bones[i]
			local a = w2s(s[1].Position)
			local b = w2s(s[2].Position)
			if a and b then
				line.From = Vector2.new(a.X, a.Y)
				line.To = Vector2.new(b.X, b.Y)
				line.Color = col
				line.Visible = true
			else line.Visible = false end
		end
	end
	for i = #segs + 1, #v.bones do v.bones[i].Visible = false end
end

task.spawn(function()
	while true do
		task.wait(0.12)
		pcall(function()
			if S.skel then
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= LP and p.Character then
						local hum = p.Character:FindFirstChilDOFClass("Humanoid")
						if hum and hum.Health > 0 then
							drawSkeleton(p, S.rainbowESP and Color3.fromHSV(tick() % 1, 1, 1) or roleColor(p))
						end
					end
				end
			end
		end)
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		pcall(function()
			if S.pets then
				local hrp=getHRP(); if hrp then
					for i,v in ipairs(pets) do
						if v.Parent then
							local bp=v:FindFirstChilDOFClass("BodyPosition")
							if bp then bp.Position = hrp.Position + Vector3.new(math.sin(tick()*2 + i)*S.petFollowDist, math.sin(tick()+i)*2+4, math.cos(tick()*2 + i)*S.petFollowDist) end
							if S.petRainbow then v.Color = Color3.fromHSV(tick()%1,1,1) end
						end
					end
				else clearPets() end
			else clearPets() end
			if S.spin then
				local hrp=getHRP(); if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed), 0) end
			end
			if S.antifling then
				local hrp=getHRP(); local bv=hrp and hrp:FindFirstChilDOFClass("BodyVelocity"); if bv and bv.Velocity.Magnitude>80 then bv.Velocity=Vector3.new(0,0,0); bv.MaxForce=Vector3.new(0,0,0); task.wait(); if bv.Parent then bv.MaxForce=Vector3.new(1e5,1e5,1e5) end end
			end
		end)
	end
end)
end)
if not mainOK then
  warn('[KITI] MAIN ERROR: ' .. tostring(mainErr))
  print('[KITI] MAIN ERROR: ' .. tostring(mainErr))
end

local menuSettingsTab = addTab("Настройки меню", "🎨")
addSection(menuSettingsTab, "Тема и прозрачность")
addDropdown(menuSettingsTab, "Тема", { "dark", "light", "neon", "amoled" }, "dark", function(v) S.theme = v; applyTheme() end)
addSlider(menuSettingsTab, "Прозрачность меню", 0, 0.5, 0.08, function(v) win.BackgroundTransparency = v end, 2)
addSlider(menuSettingsTab, "Размер меню", 0.7, 1.3, 1, function(v) win.Size = UDim2.fromOffset(WIN_W * v, WIN_H * v) end, 2)
addToggle(menuSettingsTab, "Свечение вокруг меню", false, function(on) S.glow = on end)
addToggle(menuSettingsTab, "Плавные анимации", true, function(on) S.smoothGui = on end)
addDivider(menuSettingsTab)
addSection(menuSettingsTab, "Быстрые действия")
addButton(menuSettingsTab, "🔄 Перезагрузить скрипт", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ba959/KitiProto/main/kitiproto.lua"))() end)
addButton(menuSettingsTab, "📋 Скопировать loadstring", function() if setclipboard then setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/ba959/KitiProto/main/kitiproto.lua'))()") notify("Буфер", "loadstring скопирован", 2) end end)
addButton(menuSettingsTab, "🗑 Удалить меню", function() sg:Destroy() end)

local shooterTab = addTab("Шутер", "🔫")
addSection(shooterTab, "Аимбот")
addToggle(shooterTab, "Aimbot", false, function(on) S.aimbot = on end)
addToggle(shooterTab, "Всегда целиться", false, function(on) S.aimAlways = on end)
addSlider(shooterTab, "FOV аимбота", 20, 400, 150, function(v) S.aimFov = v end)
addSlider(shooterTab, "Плавность", 0, 1, 0.5, function(v) S.aimSmooth = v end, 2)
addDropdown(shooterTab, "Часть тела", { "Head", "HumanoidRootPart", "UpperTorso" }, "Head", function(v) S.aimPart = v end)
addDivider(shooterTab)
addSection(shooterTab, "Триггер и хитбоксы")
addToggle(shooterTab, "Triggerbot", false, function(on) S.trigger = on end)
addToggle(shooterTab, "Расширить хитбоксы", false, function(on) S.hitbox = on end)
addSlider(shooterTab, "Размер хитбокса", 2, 15, 6, function(v) S.hitboxSize = v end)
addDivider(shooterTab)
addSection(shooterTab, "Авто-кликер")
addToggle(shooterTab, "Авто-клик", false, function(on) S.autoClick = on end)
addSlider(shooterTab, "Задержка (сек)", 0.01, 1, 0.1, function(v) S.autoClickDelay = v end, 2)
addDivider(shooterTab)
addSection(shooterTab, "Дополнительно")
addToggle(shooterTab, "Бесконечный прыжок", false, function(on) S.infJump = on end)
addToggle(shooterTab, "Noclip", false, function(on) S.noclip = on end)
addToggle(shooterTab, "Fly", false, function(on) S.fly = on end)
addSlider(shooterTab, "Fly speed", 10, 500, 60, function(v) S.flySpeed = v end)
addSlider(shooterTab, "WalkSpeed", 16, 500, 16, function(v) S.speed = v end)

local topBar2 = new("Frame", { Size = UDim2.fromOffset(260, 36), Position = UDim2.new(1, -270, 0, 8), BackgroundColor3 = Color3.fromRGB(18, 20, 30), BackgroundTransparency = 0.1, BorderSizePixel = 0, Active = true, Draggable = true, ZIndex = 60, Parent = sg })
corner(topBar2, 12)
stroke(topBar2, Color3.fromRGB(126, 108, 255), 1, 0.5)
local function topToggle2(label, state, cb)
	local t = new("TextButton", { Size = UDim2.fromOffset(56, 24), Position = UDim2.fromOffset(8, 6), BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 62, 78), Text = label, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 9, AutoButtonColor = false, ZIndex = 61, Parent = topBar2 })
	corner(t, 6)
	t.MouseButton1Click:Connect(function()
		state = not state
		t.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 62, 78)
		cb(state)
	end)
	t.Text = label
	return t
end
local aimBtn2 = topToggle2("Aim", false, function(on) togglesById["Aimbot"]:Set(on) end)
aimBtn2.Position = UDim2.fromOffset(8, 6)
local espBtn2 = topToggle2("ESP", false, function(on) togglesById["ESP имена"]:Set(on) end)
espBtn2.Position = UDim2.fromOffset(70, 6)
local trigBtn2 = topToggle2("TRIG", false, function(on) togglesById["Triggerbot"]:Set(on) end)
trigBtn2.Position = UDim2.fromOffset(132, 6)
local gearBtn2 = new("TextButton", { Size = UDim2.fromOffset(36, 24), Position = UDim2.new(1, -42, 0, 6), BackgroundColor3 = Color3.fromRGB(126, 108, 255), Text = "⚙", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, ZIndex = 61, Parent = topBar2 })
corner(gearBtn2, 8)
gearBtn2.MouseButton1Click:Connect(function() clickSnd(); win.Visible = not win.Visible end)

local tanksTab = addTab("Танчики", "🚀")
addSection(tanksTab, "Мини-игра: ТАНЧИКИ")
addButton(tanksTab, "▶ Запустить игру", function() startTanks() end)
addButton(tanksTab, "■ Стоп", function() stopTanks() end)
addDivider(tanksTab)
addSection(tanksTab, "Улучшения")
addToggle(tanksTab, "Бесконечные патроны", false, function(on) S.infAmmo = on end)
addToggle(tanksTab, "Быстрый огонь", false, function(on) S.fastFire = on end)
addToggle(tanksTab, "Двойной урон", false, function(on) S.doubleDmg = on end)
addSlider(tanksTab, "Скорость танка", 50, 400, 190, function(v) S.tankSpeed = v end)
addSlider(tanksTab, "Урон врагов", 5, 50, 20, function(v) S.enemyDmg = v end)
