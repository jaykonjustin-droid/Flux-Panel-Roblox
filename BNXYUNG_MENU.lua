--[[
    BNXYUNG MENU - Plantilla Profesional para Roblox
    Descripción: Un sistema de menú moderno, animado y fácil de personalizar.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIGURACIÓN DE COLORES
local THEME = {
    Background = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    ButtonHover = Color3.fromRGB(45, 45, 45),
    ButtonPressed = Color3.fromRGB(55, 55, 55)
}

-- CREACIÓN DE LA UI
local function CreateMenu()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BNXYUNG_MENU_UI"
    ScreenGui.ResetOnSpawn = false
    
    -- Detectar si se ejecuta como exploit o script interno
    local success, target = pcall(function() return game:GetService("CoreGui") end)
    if success and target then
        ScreenGui.Parent = target
    else
        ScreenGui.Parent = player:WaitForChild("PlayerGui")
    end

    -- Main Frame (Contenedor Principal)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Permitir arrastrar el menú (Draggable)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
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

    -- SIDEBAR (Barra Lateral)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = THEME.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    -- Título del Menú
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
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

    -- ÁREA DE CONTENIDO (Derecha)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Position = UDim2.new(0, 180, 0, 0)
    ContentArea.Size = UDim2.new(1, -180, 1, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    -- Páginas (Submenús)
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

        local Description = Instance.new("TextLabel")
        Description.Size = UDim2.new(1, -40, 0, 30)
        Description.Position = UDim2.new(0, 20, 0, 60)
        Description.BackgroundTransparency = 1
        Description.Text = "Contenido de " .. titleText
        Description.TextColor3 = THEME.TextDim
        Description.Font = Enum.Font.Gotham
        Description.TextSize = 14
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.Parent = Page

        Pages[name] = Page
        return Page
    end

    -- Crear las páginas solicitadas
    CreatePage("Home", "Inicio")
    CreatePage("Options", "Opciones")
    CreatePage("Settings", "Configuración")
    CreatePage("Credits", "Créditos")
    
    Pages["Home"].Visible = true -- Mostrar inicio por defecto

    -- FUNCIÓN PARA CREAR BOTONES DE NAVEGACIÓN
    local function CreateNavButton(name, label)
        local Button = Instance.new("TextButton")
        Button.Name = name .. "Btn"
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

        -- Animaciones de Hover
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = THEME.ButtonHover,
                TextColor3 = THEME.Text
            }):Play()
        end)

        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = THEME.Sidebar,
                TextColor3 = THEME.TextDim
            }):Play()
        end)

        -- Acción de Click
        Button.MouseButton1Click:Connect(function()
            -- Ocultar todas las páginas
            for _, page in pairs(Pages) do
                page.Visible = false
            end
            
            -- Mostrar página seleccionada con efecto simple
            if Pages[name] then
                Pages[name].Visible = true
                Pages[name].GroupTransparency = 1
                TweenService:Create(Pages[name], TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
            elseif name == "Exit" then
                -- Animación de cierre del menú
                TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Transparency = 1
                }):Play()
                task.wait(0.5)
                ScreenGui:Destroy()
            end
        end)

        return Button
    end

    -- Generar botones
    CreateNavButton("Home", "Inicio")
    CreateNavButton("Options", "Opciones")
    CreateNavButton("Settings", "Configuración")
    CreateNavButton("Credits", "Créditos")
    
    -- Separador antes de Salir
    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(0.8, 0, 0, 1)
    Separator.BackgroundColor3 = THEME.TextDim
    Separator.BackgroundTransparency = 0.8
    Separator.BorderSizePixel = 0
    Separator.Parent = ButtonContainer

    CreateNavButton("Exit", "Salir")

    -- ANIMACIÓN DE ENTRADA
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 400)
    }):Play()

    return ScreenGui
end

-- Ejecutar la creación
local menu = CreateMenu()
print("BNXYUNG MENU cargado con éxito.")
