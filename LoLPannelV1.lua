--========================================================
-- LoL Pannel V1
-- by: zaishi
-- Mobile Edition
-- Luau / Roblox
--========================================================

--========================================================
-- SERVICES
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")

--========================================================
-- MOBILE CHECK
--========================================================

if not UserInputService.TouchEnabled then
	return
end

--========================================================
-- PLAYER
--========================================================

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- CONFIG
--========================================================

local CONFIG = {
	PanelWidth = 430,
	PanelHeight = 340,

	MinMessageSize = 48,
	MaxMessageSize = 150,
	DefaultMessageSize = 78,

	ArrowSize = 76,

	ESPColor = Color3.fromRGB(255, 35, 35),

	PanelColor = Color3.fromRGB(18, 18, 18),
	ButtonColor = Color3.fromRGB(38, 38, 38),
	Red = Color3.fromRGB(150, 0, 0),
	Green = Color3.fromRGB(0, 120, 60)
}

--========================================================
-- STATE
--========================================================

local State = {
	PanelOpen = true,
	EditMode = false,
	ESP = false,
	ShiftLock = false,
	Arrows = true,
	DoubleSend = false,
	FreeCam = false,
	Optimization = false,

	SelectedButton = nil,

	DraggingPanel = false,

	FreeCamPosition = nil,
	FreeCamYaw = 0,
	FreeCamPitch = 0
}

--========================================================
-- CHARACTER
--========================================================

local Character
local Humanoid
local RootPart

local function UpdateCharacter(character)

	Character = character

	Humanoid = character:WaitForChild("Humanoid", 10)

	RootPart = character:WaitForChild(
		"HumanoidRootPart",
		10
	)

	if State.ShiftLock and Humanoid then
		Humanoid.AutoRotate = false
	end
end

if Player.Character then
	task.spawn(UpdateCharacter, Player.Character)
end

Player.CharacterAdded:Connect(UpdateCharacter)

--========================================================
-- CAMERA
--========================================================

local Camera = workspace.CurrentCamera

local function GetCamera()

	Camera = workspace.CurrentCamera

	return Camera
end

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")

Gui.Name = "LoLPannelV1"

Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

Gui.DisplayOrder = 100

Gui.Parent = PlayerGui

--========================================================
-- UTILITY
--========================================================

local function Corner(object, radius)

	local corner = Instance.new("UICorner")

	corner.CornerRadius = UDim.new(0, radius)

	corner.Parent = object

	return corner
end

local function Stroke(object, color, thickness)

	local stroke = Instance.new("UIStroke")

	stroke.Color = color
	stroke.Thickness = thickness

	stroke.Parent = object

	return stroke
end

local function CreateButton(
	parent,
	text,
	size,
	position
)

	local button = Instance.new("TextButton")

	button.Size = size
	button.Position = position

	button.BackgroundColor3 =
		CONFIG.ButtonColor

	button.BorderSizePixel = 0

	button.Text = text

	button.TextColor3 =
		Color3.new(1, 1, 1)

	button.TextSize = 14

	button.Font =
		Enum.Font.GothamBold

	button.AutoButtonColor = true

	button.Parent = parent

	Corner(button, 10)

	return button
end

--========================================================
-- PANEL
--========================================================

local Panel = Instance.new("Frame")

Panel.Name = "MainPanel"

Panel.Size = UDim2.fromOffset(
	CONFIG.PanelWidth,
	CONFIG.PanelHeight
)

Panel.AnchorPoint =
	Vector2.new(0.5, 0.5)

Panel.Position =
	UDim2.fromScale(0.5, 0.5)

Panel.BackgroundColor3 =
	CONFIG.PanelColor

Panel.BorderSizePixel = 0

Panel.Parent = Gui

Corner(Panel, 16)

Stroke(
	Panel,
	Color3.fromRGB(130, 0, 0),
	2
)

--========================================================
-- PANEL SCALE
--========================================================

local PanelScale = Instance.new("UIScale")

PanelScale.Parent = Panel

local function UpdatePanelScale()

	local camera = GetCamera()

	if not camera then
		return
	end

	local viewport = camera.ViewportSize

	local scale = math.min(
		viewport.X / 900,
		viewport.Y / 700
	)

	scale = math.clamp(
		scale,
		0.62,
		0.90
	)

	PanelScale.Scale = scale
end

--========================================================
-- TITLE
--========================================================

local Title = Instance.new("TextLabel")

Title.Size =
	UDim2.new(1, -20, 0, 42)

Title.Position =
	UDim2.fromOffset(10, 5)

Title.BackgroundTransparency = 1

Title.Text =
	"LoL Pannel V1"

Title.TextColor3 =
	Color3.fromRGB(255, 55, 55)

Title.TextSize = 21

Title.Font =
	Enum.Font.GothamBold

Title.Parent = Panel

--========================================================
-- AUTHOR
--========================================================

local Author = Instance.new("TextLabel")

Author.Size =
	UDim2.new(1, -20, 0, 20)

Author.Position =
	UDim2.fromOffset(10, 38)

Author.BackgroundTransparency = 1

Author.Text =
	"by: zaishi"

Author.TextColor3 =
	Color3.fromRGB(150, 150, 150)

Author.TextSize = 11

Author.Font =
	Enum.Font.Gotham

Author.Parent = Panel

--========================================================
-- DRAG AREA
--========================================================

local DragArea = Instance.new("TextButton")

DragArea.Size =
	UDim2.new(1, -120, 0, 48)

DragArea.Position =
	UDim2.fromOffset(10, 0)

DragArea.BackgroundTransparency = 1

DragArea.Text = ""

DragArea.Parent = Panel

--========================================================
-- PANEL DRAG MOBILE
--========================================================

local panelDragging = false
local panelDragStart
local panelStartPosition

DragArea.InputBegan:Connect(function(input)

	if input.UserInputType ~=
		Enum.UserInputType.Touch then
		return
	end

	panelDragging = true

	panelDragStart = input.Position

	panelStartPosition = Panel.Position

end)

UserInputService.InputChanged:Connect(function(input)

	if not panelDragging then
		return
	end

	if input.UserInputType ~=
		Enum.UserInputType.Touch then
		return
	end

	local delta =
		input.Position - panelDragStart

	Panel.Position =
		UDim2.new(
			panelStartPosition.X.Scale,
			panelStartPosition.X.Offset + delta.X,

			panelStartPosition.Y.Scale,
			panelStartPosition.Y.Offset + delta.Y
		)

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.Touch then

		panelDragging = false

	end

end)

--========================================================
-- MESSAGE INPUT
--========================================================

local MessageInput = Instance.new("TextBox")

MessageInput.Size =
	UDim2.new(1, -30, 0, 42)

MessageInput.Position =
	UDim2.fromOffset(15, 65)

MessageInput.BackgroundColor3 =
	Color3.fromRGB(40, 40, 40)

MessageInput.BorderSizePixel = 0

MessageInput.TextColor3 =
	Color3.new(1, 1, 1)

MessageInput.PlaceholderColor3 =
	Color3.fromRGB(150, 150, 150)

MessageInput.PlaceholderText =
	"Digite uma mensagem"

MessageInput.Text = ""

MessageInput.ClearTextOnFocus = false

MessageInput.TextSize = 14

MessageInput.Font =
	Enum.Font.Gotham

MessageInput.Parent = Panel

Corner(MessageInput, 9)

--========================================================
-- MESSAGE LAYER
--========================================================

local MessageLayer = Instance.new("Frame")

MessageLayer.Name =
	"MessageButtons"

MessageLayer.Size =
	UDim2.fromScale(1, 1)

MessageLayer.BackgroundTransparency = 1

MessageLayer.Parent = Gui

--========================================================
-- MESSAGE DATA
--========================================================

local MessageButtons = {}

--========================================================
-- CHAT
--========================================================

local function SendMessage(message)

	if typeof(message) ~= "string" then
		return
	end

	if message == "" then
		return
	end

	local channels =
		TextChatService:FindFirstChild(
			"TextChannels"
		)

	if not channels then
		return
	end

	local general =
		channels:FindFirstChild(
			"RBXGeneral"
		)

	if not general then
		return
	end

	pcall(function()
		general:SendAsync(message)
	end)

end

--========================================================
-- SELECT MESSAGE BUTTON
--========================================================

local function SelectMessageButton(button)

	if State.SelectedButton then

		local old =
			State.SelectedButton:FindFirstChild(
				"Selection"
			)

		if old then
			old:Destroy()
		end

	end

	State.SelectedButton = button

	if not button then
		return
	end

	local selection =
		Instance.new("UIStroke")

	selection.Name = "Selection"

	selection.Color =
		Color3.fromRGB(255, 220, 0)

	selection.Thickness = 3

	selection.Parent = button

end

--========================================================
-- RESIZE HANDLE
--========================================================

local function CreateResizeHandle(button)

	local handle =
		Instance.new("TextButton")

	handle.Name = "ResizeHandle"

	handle.Size =
		UDim2.fromOffset(30, 30)

	handle.AnchorPoint =
		Vector2.new(0.5, 0.5)

	handle.Position =
		UDim2.new(0.5, 0, 1, 4)

	handle.BackgroundColor3 =
		Color3.fromRGB(255, 220, 0)

	handle.Text = "↔"

	handle.TextColor3 =
		Color3.fromRGB(20, 20, 20)

	handle.TextSize = 14

	handle.Font =
		Enum.Font.GothamBold

	handle.Visible = false

	handle.Parent = button

	Corner(handle, 15)

	local resizing = false
	local startPosition
	local startSize

	handle.InputBegan:Connect(function(input)

		if not State.EditMode then
			return
		end

		if input.UserInputType ~=
			Enum.UserInputType.Touch then
			return
		end

		resizing = true

		startPosition = input.Position
		startSize = button.AbsoluteSize

	end)

	UserInputService.InputChanged:Connect(function(input)

		if not resizing then
			return
		end

		if input.UserInputType ~=
			Enum.UserInputType.Touch then
			return
		end

		local delta =
			input.Position - startPosition

		local newWidth =
			math.clamp(
				startSize.X + delta.X,
				CONFIG.MinMessageSize,
				CONFIG.MaxMessageSize
			)

		local newHeight =
			math.clamp(
				startSize.Y + delta.Y,
				CONFIG.MinMessageSize,
				CONFIG.MaxMessageSize
			)

		button.Size =
			UDim2.fromOffset(
				newWidth,
				newHeight
			)

	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType ==
			Enum.UserInputType.Touch then

			resizing = false

		end

	end)

	return handle
end

--========================================================
-- CREATE MESSAGE BUTTON
--========================================================

local function CreateMessageButton(message)

	if message == "" then
		return
	end

	local button =
		Instance.new("TextButton")

	button.Name =
		"MessageButton"

	button.Size =
		UDim2.fromOffset(
			CONFIG.DefaultMessageSize,
			CONFIG.DefaultMessageSize
		)

	local index =
		#MessageButtons

	local x =
		10 + (index % 5) * 88

	local y =
		90 + math.floor(index / 5) * 90

	button.Position =
		UDim2.fromOffset(x, y)

	button.BackgroundColor3 =
		CONFIG.Red

	button.BorderSizePixel = 0

	button.Text = message

	button.TextColor3 =
		Color3.new(1, 1, 1)

	button.TextWrapped = true

	button.TextScaled = true

	button.Font =
		Enum.Font.GothamBold

	button.Parent =
		MessageLayer

	Corner(button, 12)

	Stroke(
		button,
		Color3.fromRGB(255, 60, 60),
		1
	)

	local handle =
		CreateResizeHandle(button)

	button.Activated:Connect(function()

		if State.EditMode then

			SelectMessageButton(button)

			return
		end

		SendMessage(message)

		if State.DoubleSend then
			task.defer(function()
				SendMessage(message)
			end)
		end

	end)

	table.insert(
		MessageButtons,
		{
			Object = button,
			Message = message,
			Handle = handle
		}
	)

end

--========================================================
-- CREATE MESSAGE
--========================================================

MessageInput.FocusLost:Connect(function(enterPressed)

	if not enterPressed then
		return
	end

	local message =
		MessageInput.Text

	if message == "" then
		return
	end

	CreateMessageButton(message)

	MessageInput.Text = ""

end)

--========================================================
-- BUTTONS
--========================================================

local EditButton =
	CreateButton(
		Panel,
		"Edição: OFF",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(15, 120)
	)

local DeleteButton =
	CreateButton(
		Panel,
		"Apagar",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(150, 120)
	)

local ESPButton =
	CreateButton(
		Panel,
		"ESP: OFF",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(285, 120)
	)

local ShiftButton =
	CreateButton(
		Panel,
		"ShiftLock: OFF",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(15, 170)
	)

local ArrowButton =
	CreateButton(
		Panel,
		"Setas: ON",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(150, 170)
	)

local DoubleButton =
	CreateButton(
		Panel,
		"Enviar 2x: OFF",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(285, 170)
	)

local FreeCamButton =
	CreateButton(
		Panel,
		"Free Cam: OFF",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(15, 220)
	)

local OptimizationButton =
	CreateButton(
		Panel,
		"Otimização: OFF",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(150, 220)
	)

local CloseButton =
	CreateButton(
		Panel,
		"Fechar",
		UDim2.fromOffset(125, 40),
		UDim2.fromOffset(285, 220)
	)

--========================================================
-- EDIT MODE
--========================================================

EditButton.Activated:Connect(function()

	State.EditMode =
		not State.EditMode

	if State.EditMode then

		EditButton.Text =
			"Edição: ON"

		EditButton.BackgroundColor3 =
			CONFIG.Green

		for _, data in ipairs(MessageButtons) do

			if data.Handle then
				data.Handle.Visible = true
			end

		end

	else

		EditButton.Text =
			"Edição: OFF"

		EditButton.BackgroundColor3 =
			CONFIG.ButtonColor

		SelectMessageButton(nil)

		for _, data in ipairs(MessageButtons) do

			if data.Handle then
				data.Handle.Visible = false
			end

		end

	end

end)

--========================================================
-- DELETE
--========================================================

DeleteButton.Activated:Connect(function()

	if not State.EditMode then
		return
	end

	local selected =
		State.SelectedButton

	if not selected then
		return
	end

	for i, data in ipairs(MessageButtons) do

		if data.Object == selected then

			table.remove(
				MessageButtons,
				i
			)

			break
		end

	end

	selected:Destroy()

	State.SelectedButton = nil

end)

--========================================================
-- ESP
--========================================================

local ESPObjects = {}

local function RemoveESP(player)

	local object =
		ESPObjects[player]

	if not object then
		return
	end

	if object.Highlight then
		object.Highlight:Destroy()
	end

	if object.Tag then
		object.Tag:Destroy()
	end

	ESPObjects[player] = nil

end

local function CreateESP(player)

	if player == Player then
		return
	end

	RemoveESP(player)

	local character =
		player.Character

	if not character then
		return
	end

	local head =
		character:FindFirstChild("Head")

	if not head then
		return
	end

	local highlight =
		Instance.new("Highlight")

	highlight.Name =
		"LoL_ESP"

	highlight.Adornee =
		character

	highlight.FillColor =
		CONFIG.ESPColor

	highlight.OutlineColor =
		CONFIG.ESPColor

	highlight.FillTransparency =
		0.55

	highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	highlight.Parent =
		character

	local tag =
		Instance.new("BillboardGui")

	tag.Name =
		"LoL_ESP_Name"

	tag.Adornee =
		head

	tag.Size =
		UDim2.fromOffset(160, 32)

	tag.StudsOffset =
		Vector3.new(0, 3, 0)

	tag.AlwaysOnTop = true

	tag.Parent = head

	local label =
		Instance.new("TextLabel")

	label.Size =
		UDim2.fromScale(1, 1)

	label.BackgroundTransparency = 1

	label.Text =
		player.DisplayName

	label.TextColor3 =
		CONFIG.ESPColor

	label.TextStrokeTransparency = 0

	label.TextScaled = true

	label.Font =
		Enum.Font.GothamBold

	label.Parent = tag

	ESPObjects[player] = {
		Highlight = highlight,
		Tag = tag
	}

end

local function UpdateESP()

	for _, player in ipairs(
		Players:GetPlayers()
	) do

		if player ~= Player then

			if State.ESP then
				CreateESP(player)
			else
				RemoveESP(player)
			end

		end

	end

end

ESPButton.Activated:Connect(function()

	State.ESP =
		not State.ESP

	ESPButton.Text =
		State.ESP
		and "ESP: ON"
		or "ESP: OFF"

	ESPButton.BackgroundColor3 =
		State.ESP
		and CONFIG.Red
		or CONFIG.ButtonColor

	UpdateESP()

end)

Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function()

		if State.ESP then

			task.wait(0.25)

			CreateESP(player)

		end

	end)

end)

Players.PlayerRemoving:Connect(RemoveESP)

--========================================================
-- SHIFTLOCK MOBILE
--========================================================

local Crosshair =
	Instance.new("TextLabel")

Crosshair.Size =
	UDim2.fromOffset(40, 40)

Crosshair.AnchorPoint =
	Vector2.new(0.5, 0.5)

Crosshair.Position =
	UDim2.fromScale(0.5, 0.5)

Crosshair.BackgroundTransparency = 1

Crosshair.Text = "+"

Crosshair.TextColor3 =
	Color3.new(1, 1, 1)

Crosshair.TextStrokeTransparency = 0

Crosshair.TextSize = 30

Crosshair.Font =
	Enum.Font.GothamBold

Crosshair.Visible = false

Crosshair.Parent = Gui

local function SetShiftLock(enabled)

	State.ShiftLock =
		enabled

	if Humanoid then

		Humanoid.AutoRotate =
			not enabled

	end

	Crosshair.Visible =
		enabled

	ShiftButton.Text =
		enabled
		and "ShiftLock: ON"
		or "ShiftLock: OFF"

	ShiftButton.BackgroundColor3 =
		enabled
		and CONFIG.Green
		or CONFIG.ButtonColor

end

ShiftButton.Activated:Connect(function()

	SetShiftLock(
		not State.ShiftLock
	)

end)

--========================================================
-- ARROW SYSTEM
--========================================================

local ArrowFrame =
	Instance.new("Frame")

ArrowFrame.Name =
	"MobileArrows"

ArrowFrame.AnchorPoint =
	Vector2.new(0, 1)

ArrowFrame.Size =
	UDim2.fromOffset(250, 210)

ArrowFrame.Position =
	UDim2.new(
		0,
		20,
		1,
		-20
	)

ArrowFrame.BackgroundTransparency = 1

ArrowFrame.Parent = Gui

--========================================================
-- ARROW BUTTON
--========================================================

local function CreateArrow(
	name,
	text,
	position
)

	local button =
		Instance.new("TextButton")

	button.Name =
		name

	button.Size =
		UDim2.fromOffset(
			CONFIG.ArrowSize,
			CONFIG.ArrowSize
		)

	button.Position =
		position

	button.BackgroundColor3 =
		Color3.fromRGB(30, 30, 30)

	button.BackgroundTransparency = 0.12

	button.BorderSizePixel = 0

	button.Text =
		text

	button.TextColor3 =
		Color3.new(1, 1, 1)

	button.TextSize = 34

	button.Font =
		Enum.Font.GothamBold

	button.AutoButtonColor = false

	button.Parent =
		ArrowFrame

	Corner(button, 20)

	Stroke(
		button,
		Color3.fromRGB(100, 100, 100),
		1
	)

	return button
end

local Up =
	CreateArrow(
		"Up",
		"▲",
		UDim2.fromOffset(87, 0)
	)

local Down =
	CreateArrow(
		"Down",
		"▼",
		UDim2.fromOffset(87, 90)
	)

local Left =
	CreateArrow(
		"Left",
		"◀",
		UDim2.fromOffset(0, 9
