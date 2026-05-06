--[[
    BNXYUNG PROJECT - MAIN EXECUTABLE (All-In-One)
    Este es el único archivo necesario para ejecutar el proyecto completo.
    Contiene la lógica de utilidades, interfaz y carga segura.
]]

-- ==========================================
-- SERVICIOS GLOBALES
-- ==========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==========================================
-- UTILITY LIB (Utilidades Locales)
-- ==========================================
local UtilityLib = {
    Version = "1.0.0"
}

function UtilityLib:Init()
    print("[Utils] Utilidades cargadas.")
end

function UtilityLib:FormatNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

-- ==========================================
-- MENU UI (Interfaz Principal BNXYUNG)
-- ==========================================
local MenuUI = {
    Version = "1.1.0",
    Active = false,
    UI = nil,
    THEME = {
        Background = Color3.fromRGB(25, 25, 25),
        Sidebar = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 180),
        ButtonHover = Color3.fromRGB(45, 45, 45)
    }
}

function MenuUI:Init()
    print("[UI] Inicializando BNXYUNG MENU...")
    self:Create()
end

function MenuUI:Create()
    local player = Players.LocalPlayer
    local THEME = self.THEME

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BNXYUNG_MENU_UI"
    ScreenGui.ResetOnSpawn = false
    
    -- Ubicación segura (CoreGui o PlayerGui)
    local success, target = pcall(function() return game:GetService("CoreGui") end)
    ScreenGui.Parent = (success and target) or player:WaitForChild("PlayerGui")

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Arrastre (Draggable)
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEME.Accent
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = THEME.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundTransparency = 1
    Title.Text = "BNXYUNG MENU"
    Title.TextColor3 = THEME.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = Sidebar

    -- Contenedor de Botones
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "Buttons"
    ButtonContainer.Position = UDim2.new(0, 0, 0, 70)
    ButtonContainer.Size = UDim2.new(1, 0, 1, -70)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Sidebar

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ButtonContainer

    -- CONTENIDO
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Position = UDim2.new(0, 180, 0, 0)
    ContentArea.Size = UDim2.new(1, -180, 1, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local Pages = {}
    local function CreatePage(name, titleText)
        local Page = Instance.new("Frame")
        Page.Name = name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = ContentArea

        local PageTitle = Instance.new("TextLabel")
        PageTitle.Size = UDim2.new(1, -40, 0, 50)
        PageTitle.Position = UDim2.new(0, 20, 0, 20)
        PageTitle.BackgroundTransparency = 1
        PageTitle.Text = titleText
        PageTitle.TextColor3 = THEME.Text
        PageTitle.Font = Enum.Font.GothamBold
        PageTitle.TextSize = 24
        PageTitle.TextXAlignment = Enum.TextXAlignment.Left
        PageTitle.Parent = Page

        Pages[name] = Page
        return Page
    end

    CreatePage("Home", "Inicio")
    CreatePage("Settings", "Configuración")
    Pages["Home"].Visible = true

    local function CreateNavButton(name, label)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 40)
        Button.BackgroundColor3 = THEME.Sidebar
        Button.BorderSizePixel = 0
        Button.Text = "  " .. label
        Button.TextColor3 = THEME.TextDim
        Button.Font = Enum.Font.GothamMedium
        Button.TextSize = 14
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.AutoButtonColor = false
        Button.Parent = ButtonContainer

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button

        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ButtonHover, TextColor3 = THEME.Text}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Sidebar, TextColor3 = THEME.TextDim}):Play()
        end)

        Button.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            if Pages[name] then Pages[name].Visible = true end
            if name == "Exit" then ScreenGui:Destroy() end
        end)
    end

    CreateNavButton("Home", "Inicio")
    CreateNavButton("Settings", "Configuración")
    CreateNavButton("Exit", "Salir")

    -- Animación de entrada
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)}):Play()

    self.UI = ScreenGui
    self.Active = true
end

-- ==========================================
-- MAIN LOADER (Inicializador)
-- ==========================================
local MainLoader = {
    _VERSION = "2.0.0",
    _MODULES = {UtilityLib, MenuUI}
}

function MainLoader:Init()
    print("--- BNXYUNG PROJECT LOADER ---")
    for _, module in ipairs(self._MODULES) do
        local success, err = pcall(function()
            if module.Init then module:Init() end
        end)
        if not success then warn("Error cargando módulo: " .. tostring(err)) end
    end
    print("------------------------------")
end

-- INICIAR PROYECTO
MainLoader:Init()
