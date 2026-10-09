--!strict
-- NEXUS ULTIMATE: standalone safe client edition.
-- Put this LocalScript in StarterPlayer > StarterPlayerScripts.
-- It needs no assets, Remotes, or external modules.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("NexusUltimateOneFile")
if oldGui then oldGui:Destroy() end

local themes = {
	NexusDark = {background = Color3.fromRGB(8, 11, 19), surface = Color3.fromRGB(18, 25, 39), raised = Color3.fromRGB(29, 39, 58), text = Color3.fromRGB(240, 246, 255), muted = Color3.fromRGB(154, 170, 197), accent = Color3.fromRGB(72, 159, 255), accent2 = Color3.fromRGB(144, 93, 255), border = Color3.fromRGB(59, 80, 113), success = Color3.fromRGB(71, 213, 152), warning = Color3.fromRGB(255, 187, 73)},
	VioletPulse = {background = Color3.fromRGB(15, 9, 24), surface = Color3.fromRGB(29, 18, 45), raised = Color3.fromRGB(49, 31, 71), text = Color3.fromRGB(248, 242, 255), muted = Color3.fromRGB(191, 169, 216), accent = Color3.fromRGB(180, 105, 255), accent2 = Color3.fromRGB(75, 180, 255), border = Color3.fromRGB(96, 65, 125), success = Color3.fromRGB(87, 224, 168), warning = Color3.fromRGB(255, 195, 89)},
	ArcticBlue = {background = Color3.fromRGB(7, 17, 28), surface = Color3.fromRGB(13, 31, 47), raised = Color3.fromRGB(20, 48, 69), text = Color3.fromRGB(236, 250, 255), muted = Color3.fromRGB(153, 189, 205), accent = Color3.fromRGB(75, 202, 255), accent2 = Color3.fromRGB(68, 126, 255), border = Color3.fromRGB(56, 100, 126), success = Color3.fromRGB(75, 224, 181), warning = Color3.fromRGB(255, 200, 94)},
}
local themeName = "NexusDark"
local theme = themes[themeName]

local gui = Instance.new("ScreenGui")
gui.Name = "NexusUltimateOneFile"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function corner(parent: Instance, radius: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
end

local function tween(object: Instance, time: number, properties: {[string]: any})
	local result = TweenService:Create(object, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
	result:Play()
	return result
end

local function mark(object: Instance, role: string)
	object:SetAttribute("NexusRole", role)
	if role == "background" and object:IsA("GuiObject") then object.BackgroundColor3 = theme.background
	elseif role == "surface" and object:IsA("GuiObject") then object.BackgroundColor3 = theme.surface
	elseif role == "raised" and object:IsA("GuiObject") then object.BackgroundColor3 = theme.raised
	elseif role == "accent" and object:IsA("GuiObject") then object.BackgroundColor3 = theme.accent
	elseif role == "text" and object:IsA("TextLabel") then object.TextColor3 = theme.text
	elseif role == "muted" and object:IsA("TextLabel") then object.TextColor3 = theme.muted
	elseif role == "success" and object:IsA("TextLabel") then object.TextColor3 = theme.success
	elseif role == "border" and object:IsA("UIStroke") then object.Color = theme.border
	end
end

local function restyle(root: Instance)
	local rootRole = root:GetAttribute("NexusRole")
	if typeof(rootRole) == "string" then mark(root, rootRole) end
	for _, object in ipairs(root:GetDescendants()) do
		local role = object:GetAttribute("NexusRole")
		if typeof(role) == "string" then mark(object, role) end
	end
end

local function label(parent: Instance, text: string, size: number, role: string): TextLabel
	local result = Instance.new("TextLabel")
	result.BackgroundTransparency = 1
	result.Font = Enum.Font.Gotham
	result.Text = text
	result.TextSize = size
	result.TextXAlignment = Enum.TextXAlignment.Left
	result.TextYAlignment = Enum.TextYAlignment.Center
	result.RichText = true
	result.AutomaticSize = Enum.AutomaticSize.Y
	result.Size = UDim2.new(1, 0, 0, size + 10)
	mark(result, role)
	result.Parent = parent
	return result
end

local function button(parent: Instance, text: string, primary: boolean): TextButton
	local result = Instance.new("TextButton")
	result.AutoButtonColor = false
	result.Text = text
	result.Font = Enum.Font.GothamSemibold
	result.TextSize = 12
	result.Size = UDim2.fromOffset(132, 36)
	result.BorderSizePixel = 0
	mark(result, primary and "accent" or "raised")
	corner(result, 9)
	result.TextColor3 = theme.text
	result.MouseEnter:Connect(function() tween(result, 0.12, {BackgroundTransparency = 0.13}) end)
	result.MouseLeave:Connect(function() tween(result, 0.12, {BackgroundTransparency = 0}) end)
	result.Parent = parent
	return result
end

local function card(parent: Instance, height: number): Frame
	local result = Instance.new("Frame")
	result.Size = UDim2.new(1, 0, 0, height)
	result.BorderSizePixel = 0
	result.BackgroundTransparency = 0.05
	mark(result, "surface")
	corner(result, 13)
	local stroke = Instance.new("UIStroke")
	stroke.Transparency = 0.35
	stroke.Thickness = 1
	mark(stroke, "border")
	stroke.Parent = result
	result.Parent = parent
	return result
end

local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1, 1)
root.BorderSizePixel = 0
mark(root, "background")
root.Parent = gui

local toastArea = Instance.new("Frame")
toastArea.AnchorPoint = Vector2.new(1, 0)
toastArea.Position = UDim2.new(1, -18, 0, 18)
toastArea.Size = UDim2.fromOffset(320, 0)
toastArea.AutomaticSize = Enum.AutomaticSize.Y
toastArea.BackgroundTransparency = 1
toastArea.ZIndex = 20
toastArea.Parent = root
local toastLayout = Instance.new("UIListLayout")
toastLayout.Padding = UDim.new(0, 8)
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
toastLayout.Parent = toastArea

local function notify(kind: string, title: string, description: string)
	local toast = Instance.new("TextButton")
	toast.AutoButtonColor = false
	toast.Text = ""
	toast.Size = UDim2.fromOffset(308, 68)
	toast.BorderSizePixel = 0
	mark(toast, "raised")
	toast.ZIndex = 20
	corner(toast, 11)
	toast.Parent = toastArea
	local line = Instance.new("Frame")
	line.Size = UDim2.fromOffset(4, 46)
	line.Position = UDim2.fromOffset(10, 11)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = kind == "success" and theme.success or kind == "warning" and theme.warning or theme.accent
	line.ZIndex = 21
	corner(line, 4)
	line.Parent = toast
	local titleLabel = label(toast, title, 13, "text")
	titleLabel.Position = UDim2.fromOffset(25, 6)
	titleLabel.Size = UDim2.new(1, -35, 0, 23)
	titleLabel.ZIndex = 21
	local descriptionLabel = label(toast, description, 11, "muted")
	descriptionLabel.Position = UDim2.fromOffset(25, 29)
	descriptionLabel.Size = UDim2.new(1, -35, 0, 31)
	descriptionLabel.TextWrapped = true
	descriptionLabel.ZIndex = 21
	local closed = false
	local function close()
		if closed then return end
		closed = true
		tween(toast, 0.15, {BackgroundTransparency = 1})
		task.delay(0.17, function() if toast.Parent then toast:Destroy() end end)
	end
	toast.Activated:Connect(close)
	task.delay(5, close)
end

-- Intro is kept separate from the application shell, preventing accidental input during startup.
local intro = Instance.new("Frame")
intro.Size = UDim2.fromScale(1, 1)
intro.BorderSizePixel = 0
intro.ZIndex = 10
mark(intro, "background")
intro.Parent = root
local introCenter = Instance.new("Frame")
introCenter.AnchorPoint = Vector2.new(0.5, 0.5)
introCenter.Position = UDim2.fromScale(0.5, 0.5)
introCenter.Size = UDim2.fromOffset(440, 210)
introCenter.BackgroundTransparency = 1
introCenter.ZIndex = 11
introCenter.Parent = intro
local logo = label(introCenter, "NEXUS ULTIMATE", 30, "text")
logo.Font = Enum.Font.GothamBold
logo.TextXAlignment = Enum.TextXAlignment.Center
logo.Position = UDim2.fromOffset(0, 42)
logo.ZIndex = 11
local subtitle = label(introCenter, "ADVANCED GAMING INTERFACE", 11, "success")
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.Position = UDim2.fromOffset(0, 83)
subtitle.ZIndex = 11
local track = Instance.new("Frame")
track.Size = UDim2.fromOffset(360, 5)
track.Position = UDim2.fromOffset(40, 132)
track.BorderSizePixel = 0
mark(track, "raised")
track.ZIndex = 11
corner(track, 5)
track.Parent = introCenter
local progress = Instance.new("Frame")
progress.Size = UDim2.new(0, 0, 1, 0)
progress.BorderSizePixel = 0
mark(progress, "accent")
progress.ZIndex = 12
corner(progress, 5)
progress.Parent = track
local introState = label(introCenter, "●  Инициализация интерфейса", 11, "muted")
introState.TextXAlignment = Enum.TextXAlignment.Center
introState.Position = UDim2.fromOffset(0, 151)
introState.ZIndex = 11

local window = Instance.new("Frame")
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.53)
window.Size = UDim2.new(0.91, 0, 0.84, 0)
window.BorderSizePixel = 0
window.Visible = false
mark(window, "surface")
corner(window, 16)
window.Parent = root
local windowScale = Instance.new("UIScale")
windowScale.Scale = 0.96
windowScale.Parent = window
local windowStroke = Instance.new("UIStroke")
windowStroke.Transparency = 0.3
mark(windowStroke, "border")
windowStroke.Parent = window

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 62)
header.BorderSizePixel = 0
mark(header, "raised")
corner(header, 16)
header.Parent = window
local brand = label(header, "NEXUS <font color=\"#5BA8FF\">ULTIMATE</font>", 17, "text")
brand.Font = Enum.Font.GothamBold
brand.Position = UDim2.fromOffset(19, 10)
brand.Size = UDim2.fromOffset(230, 42)
local online = label(header, "●  LOCAL MODE", 11, "success")
online.TextXAlignment = Enum.TextXAlignment.Right
online.AnchorPoint = Vector2.new(1, 0.5)
online.Position = UDim2.new(1, -18, 0.5, 0)
online.Size = UDim2.fromOffset(130, 28)

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 62)
sidebar.Size = UDim2.new(0, 218, 1, -92)
sidebar.BorderSizePixel = 0
mark(sidebar, "background")
sidebar.Parent = window
local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 11)
sidebarPadding.PaddingLeft = UDim.new(0, 10)
sidebarPadding.PaddingRight = UDim.new(0, 10)
sidebarPadding.Parent = sidebar
local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.Parent = sidebar

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(218, 62)
content.Size = UDim2.new(1, -218, 1, -92)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = window
local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 20)
contentPadding.PaddingBottom = UDim.new(0, 20)
contentPadding.PaddingLeft = UDim.new(0, 21)
contentPadding.PaddingRight = UDim.new(0, 21)
contentPadding.Parent = content
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 14)
contentLayout.Parent = content

local status = label(window, "NEXUS • standalone client edition • no server privileges", 10, "muted")
status.Position = UDim2.new(0, 16, 1, -30)
status.Size = UDim2.new(1, -32, 0, 22)

local pages = {
	{"dashboard", "◆", "Главная"}, {"quick", "⚡", "Быстрые действия"}, {"character", "◉", "Персонаж"},
	{"features", "◈", "Игровые возможности"}, {"games", "▦", "Мини-игры"}, {"assistant", "✦", "NEXUS AI"},
	{"developer", "⌘", "Инструменты разработчика"}, {"monitor", "◌", "Статистика"}, {"themes", "◐", "Кастомизация"},
	{"notifications", "●", "Уведомления"}, {"settings", "⚙", "Настройки"}, {"about", "i", "О проекте"},
}
local navButtons: {[string]: TextButton} = {}
local currentPage = ""
local function clearContent()
	for _, child in content:GetChildren() do
		if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
	end
end
local function pageTitle(title: string, description: string)
	clearContent()
	local heading = label(content, title, 24, "text")
	heading.Font = Enum.Font.GothamBold
	local subheading = label(content, description, 12, "muted")
	subheading.Size = UDim2.new(1, 0, 0, 25)
end
local function unavailable(title: string)
	pageTitle(title, "Страница доступна в навигации, но не симулирует функции, для которых нужен серверный код.")
	local info = card(content, 102)
	local h = label(info, "Недоступно в one-file режиме", 15, "warning")
	h.Position = UDim2.fromOffset(15, 12)
	local d = label(info, "Этот автономный LocalScript не получает серверные права, DataStore или внешний AI. Это честнее и безопаснее, чем показывать фиктивный результат.", 12, "muted")
	d.Position = UDim2.fromOffset(15, 43)
	d.Size = UDim2.new(1, -30, 0, 46)
	d.TextWrapped = true
end

local fps = 0
local fpsTimer = 0
local fpsFrames = 0
local fpsLabel: TextLabel? = nil
RunService.RenderStepped:Connect(function(delta)
	fpsTimer += delta
	fpsFrames += 1
	if fpsTimer >= 0.5 then
		fps = math.floor(fpsFrames / fpsTimer + 0.5)
		fpsTimer = 0
		fpsFrames = 0
		if fpsLabel and fpsLabel.Parent then fpsLabel.Text = tostring(fps) .. " FPS" end
	end
end)

local reactionToken = 0
local function showReaction()
	pageTitle("Reaction Test", "Нажмите только после появления сигнала. Раннее нажатие не засчитывается.")
	local gameCard = card(content, 246)
	local result = label(gameCard, "Нажмите «Начать попытку»", 17, "text")
	result.TextXAlignment = Enum.TextXAlignment.Center
	result.Position = UDim2.fromOffset(15, 25)
	result.Size = UDim2.new(1, -30, 0, 40)
	local target = button(gameCard, "Начать попытку", true)
	target.AnchorPoint = Vector2.new(0.5, 0.5)
	target.Position = UDim2.new(0.5, 0, 0.57, 0)
	target.Size = UDim2.fromOffset(220, 76)
	target.TextSize = 16
	local best = math.huge
	local attempts = 0
	local signalAt = 0
	local state = "idle"
	target.Activated:Connect(function()
		if state == "idle" or state == "finished" then
			reactionToken += 1
			local token = reactionToken
			state = "waiting"
			target.Text = "Ждите сигнал..."
			target.BackgroundColor3 = theme.raised
			result.Text = "Не нажимайте до сигнала"
			task.delay(math.random(18, 40) / 10, function()
				if token ~= reactionToken or not target.Parent then return end
				state = "signal"
				signalAt = os.clock()
				target.Text = "НАЖМИТЕ!"
				target.BackgroundColor3 = theme.success
				result.Text = "СИГНАЛ"
			end)
		elseif state == "waiting" then
			reactionToken += 1
			state = "finished"
			target.Text = "Слишком рано — начать заново"
			target.BackgroundColor3 = theme.warning
			result.Text = "Раннее нажатие не засчитано"
		elseif state == "signal" then
			local ms = math.floor((os.clock() - signalAt) * 1000 + 0.5)
			attempts += 1
			best = math.min(best, ms)
			state = "finished"
			target.Text = "Новая попытка"
			target.BackgroundColor3 = theme.accent
			result.Text = string.format("%d мс  •  Лучший: %d мс  •  Попыток: %d", ms, best, attempts)
			notify("success", "Результат Reaction Test", tostring(ms) .. " мс")
		end
	end)
end

local function openPage(id: string)
	currentPage = id
	for pageId, nav in pairs(navButtons) do
		local selected = pageId == id
		nav.BackgroundTransparency = selected and 0 or 1
		nav.BackgroundColor3 = theme.accent
		nav.TextColor3 = selected and theme.text or theme.muted
	end
	if id == "dashboard" then
		pageTitle("Добро пожаловать, " .. player.DisplayName, "NEXUS ULTIMATE • автономный безопасный режим")
		local profile = card(content, 135)
		local h = label(profile, "ПРОФИЛЬ ИГРОКА", 11, "success"); h.Position = UDim2.fromOffset(15, 12)
		local n = label(profile, player.DisplayName, 18, "text"); n.Position = UDim2.fromOffset(15, 34)
		local d = label(profile, "@" .. player.Name .. "  •  Public User ID: " .. player.UserId .. "\nРеальное состояние персонажа доступно на странице «Персонаж».", 12, "muted"); d.Position = UDim2.fromOffset(15, 65); d.Size = UDim2.new(1, -30, 0, 48)
		local start = card(content, 94)
		local q = label(start, "БЫСТРЫЙ СТАРТ", 11, "success"); q.Position = UDim2.fromOffset(15, 10)
		local b = button(start, "Reaction Test", true); b.Position = UDim2.fromOffset(15, 45); b.Activated:Connect(function() openPage("games") end)
	elseif id == "games" then
		showReaction()
	elseif id == "monitor" then
		pageTitle("System Monitor", "Настоящая локальная оценка FPS; сетевой ping без серверного измерения не подменяется числом.")
		local performance = card(content, 130)
		local cap = label(performance, "ТЕКУЩАЯ ПРОИЗВОДИТЕЛЬНОСТЬ", 11, "success"); cap.Position = UDim2.fromOffset(15, 12)
		fpsLabel = label(performance, tostring(fps) .. " FPS", 30, "text"); fpsLabel.Font = Enum.Font.GothamBold; fpsLabel.Position = UDim2.fromOffset(15, 39)
		local note = label(performance, "Ping: недоступно в автономном клиентском режиме", 12, "muted"); note.Position = UDim2.fromOffset(15, 87)
	elseif id == "themes" then
		pageTitle("Кастомизация", "Тема применяется ко всему автономному интерфейсу сразу.")
		for name in pairs(themes) do
			local item = card(content, 78)
			local h = label(item, name, 15, "text"); h.Position = UDim2.fromOffset(15, 12)
			local apply = button(item, "Применить", true); apply.AnchorPoint = Vector2.new(1, 0.5); apply.Position = UDim2.new(1, -15, 0.5, 0)
			apply.Activated:Connect(function()
				themeName = name; theme = themes[name]; restyle(root); openPage(currentPage); notify("success", "Тема применена", name)
			end)
		end
	elseif id == "settings" then
		pageTitle("Настройки", "Рабочие настройки автономного интерфейса.")
		local setting = card(content, 100)
		local h = label(setting, "Интерфейс", 15, "text"); h.Position = UDim2.fromOffset(15, 12)
		local d = label(setting, "RightShift открывает/закрывает окно. Escape закрывает его. Сенсорное управление работает через кнопки.", 12, "muted"); d.Position = UDim2.fromOffset(15, 43); d.Size = UDim2.new(1, -30, 0, 43); d.TextWrapped = true
	elseif id == "character" then
		pageTitle("Player Hub", "Доступные данные текущего персонажа.")
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		local info = humanoid and string.format("Здоровье: %.0f / %.0f\nСкорость: %.0f\nСила прыжка: %.0f", humanoid.Health, humanoid.MaxHealth, humanoid.WalkSpeed, humanoid.JumpPower) or "Персонаж ещё не создан."
		local characterCard = card(content, 144)
		local h = label(characterCard, player.DisplayName, 18, "text"); h.Position = UDim2.fromOffset(15, 13)
		local d = label(characterCard, info, 13, "muted"); d.Position = UDim2.fromOffset(15, 51); d.Size = UDim2.new(1, -30, 0, 75)
	elseif id == "about" then
		pageTitle("О проекте", "NEXUS ULTIMATE • one-file client edition")
		local info = card(content, 142)
		local d = label(info, "Работает: intro, адаптивная навигация, темы, уведомления, Character Hub, FPS и Reaction Test.\n\nДля DataStore, AI, честных рекордов, телепортации и изменения игровых параметров нужна серверная версия пакета.", 12, "muted")
		d.Position = UDim2.fromOffset(15, 13); d.Size = UDim2.new(1, -30, 1, -26); d.TextWrapped = true
	elseif id == "notifications" then
		pageTitle("Уведомления", "Новые уведомления отображаются в правом верхнем углу.")
		local info = card(content, 78)
		local d = label(info, "Нажмите на всплывающее уведомление, чтобы закрыть его. История в one-file версии не сохраняется между сессиями.", 12, "muted"); d.Position = UDim2.fromOffset(15, 14); d.Size = UDim2.new(1, -30, 0, 52); d.TextWrapped = true
	else
		local selectedName = "Функция"
		for _, entry in ipairs(pages) do if entry[1] == id then selectedName = entry[3] end end
		unavailable(selectedName)
	end
end

for _, entry in ipairs(pages) do
	local id, icon, title = entry[1], entry[2], entry[3]
	local nav = Instance.new("TextButton")
	nav.Name = id
	nav.AutoButtonColor = false
	nav.Text = icon .. "   " .. title
	nav.Font = Enum.Font.GothamMedium
	nav.TextSize = 12
	nav.TextXAlignment = Enum.TextXAlignment.Left
	nav.Size = UDim2.new(1, 0, 0, 35)
	nav.BorderSizePixel = 0
	nav.BackgroundTransparency = 1
	nav.TextColor3 = theme.muted
	nav:SetAttribute("Icon", icon)
	nav:SetAttribute("Title", title)
	corner(nav, 8)
	nav.Activated:Connect(function() openPage(id) end)
	nav.Parent = sidebar
	navButtons[id] = nav
end

local function updateResponsive()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local compact = camera.ViewportSize.X < 650
	window.Size = compact and UDim2.new(0.98, 0, 0.94, 0) or UDim2.new(0.91, 0, 0.84, 0)
	local sideWidth = compact and 58 or 218
	sidebar.Size = UDim2.new(0, sideWidth, 1, -92)
	content.Position = UDim2.fromOffset(sideWidth, 62)
	content.Size = UDim2.new(1, -sideWidth, 1, -92)
	brand.Visible = not compact
	for _, nav in pairs(navButtons) do
		local icon = nav:GetAttribute("Icon") :: string
		local title = nav:GetAttribute("Title") :: string
		nav.Text = compact and icon or icon .. "   " .. title
	end
end
updateResponsive()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsive) end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		window.Visible = not window.Visible
	elseif input.KeyCode == Enum.KeyCode.Escape then
		window.Visible = false
	end
end)

restyle(root)
logo.TextTransparency = 1
logo.Position += UDim2.fromOffset(0, 12)
tween(logo, 0.42, {TextTransparency = 0, Position = logo.Position - UDim2.fromOffset(0, 12)})
local function introStage(value: number, message: string)
	introState.Text = "●  " .. message
	tween(progress, 0.28, {Size = UDim2.new(value, 0, 1, 0)})
	task.wait(0.22)
end
introStage(0.32, "Создание компонентов")
introStage(0.68, "Подготовка навигации")
introStage(1, "Интерфейс готов")
window.Visible = true
tween(windowScale, 0.38, {Scale = 1})
tween(intro, 0.32, {BackgroundTransparency = 1})
task.delay(0.35, function() if intro.Parent then intro:Destroy() end end)
openPage("dashboard")
notify("success", "NEXUS ULTIMATE готов", "Автономный интерфейс запущен.")
