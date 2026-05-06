--[[
    BNXYUNG7 MENU - ULTIMATE ALL-IN-ONE (FIXED & OPTIMIZED)
    VERSION: 1.1.0
    ESTADO: ESTABLE
    CONTROLES: RightShift para Toggle
]]

-- =============================================================================
-- 1. CONFIGURACIÓN Y SERVICIOS
-- =============================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local UI_NAME = "BNXYUNG7_MENU_MASTER"
local TOGGLE_KEY = Enum.KeyCode.RightShift
local player = Players.LocalPlayer

-- =============================================================================
-- 2. TABLA MAESTRA DEL PROYECTO
-- =============================================================================
local BNXYUNG7 = {
    UI = {
        Visible = true,
        Minimized = false,
        CurrentPage = nil,
        Pages = {},
        Instances = {},
        Theme = {
            Main = Color3.fromRGB(12, 12, 12),
            Sidebar = Color3.fromRGB(18, 18, 18),
            Accent = Color3.fromRGB(0, 170, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(140, 140, 140),
            Hover = Color3.fromRGB(30, 30, 30),
            Red = Color3.fromRGB(255, 70, 70),
            Green = Color3.fromRGB(70, 255, 70)
        }
    },
    Utils = {}
}

-- =============================================================================
-- 3. UTILIDADES INTERNAS
-- =============================================================================
function BNXYUNG7.Utils:Tween(obj, info, goal)
    if not obj then return end
    local tween = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    tween:Play()
    return tween
end

function BNXYUNG7.Utils:Copy(text)
    local success = pcall(function()
        if setclipboard then
            setclipboard(text)
        elseif toclipboard then
            toclipboard(text)
        end
    end)
    return success
end

-- =============================================================================
-- 4. LÓGICA DE LA INTERFAZ (UI)
-- =============================================================================
function BNXYUNG7.UI:Init()
    -- Anti-Duplicación Robusta
    local success, target = pcall(function() return CoreGui end)
    local parent = (success and target) or player:WaitForChild("PlayerGui")
    
    local existing = parent:FindFirstChild(UI_NAME)
    if existing then
        existing:Destroy()
    end

    local createSuccess, err = pcall(function()
        self:CreateInterface(parent)
        self:SetupControls()
    end)

    if not createSuccess then
        warn("[UI Error] Fallo al crear interfaz: " .. tostring(err))
    end
end

function BNXYUNG7.UI:CreateInterface(parent)
    local T = self.Theme

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = UI_NAME
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = parent
    self.Instances.ScreenGui = ScreenGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = T.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    self.Instances.Main = MainFrame

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 10)
    
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = T.Accent
    Stroke.Thickness = 1.2
    Stroke.Transparency = 0.4

    -- TOP BAR
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local WindowBtns = Instance.new("Frame")
    WindowBtns.Size = UDim2.new(0, 100, 1, 0)
    WindowBtns.Position = UDim2.new(1, -100, 0, 0)
    WindowBtns.BackgroundTransparency = 1
    WindowBtns.Parent = TopBar

    local function CreateWinBtn(name, char, color, callback)
        local B = Instance.new("TextButton")
        B.Name = name
        B.Size = UDim2.new(0, 30, 0, 30)
        B.Position = UDim2.new(0, (name == "X" and 65) or (name == "M" and 35) or 5, 0.5, -15)
        B.BackgroundTransparency = 1
        B.Text = char
        B.TextColor3 = T.TextDim
        B.Font = Enum.Font.GothamBold
        B.TextSize = 14
        B.Parent = WindowBtns
        
        B.MouseEnter:Connect(function() B.TextColor3 = color end)
        B.MouseLeave:Connect(function() B.TextColor3 = T.TextDim end)
        B.MouseButton1Click:Connect(callback)
    end

    CreateWinBtn("X", "X", T.Red, function() ScreenGui:Destroy() end)
    CreateWinBtn("M", "☐", T.Green, function() print("Maximized (Not Implemented)") end)
    CreateWinBtn("I", "_", T.Accent, function() 
        self.Minimized = not self.Minimized
        BNXYUNG7.Utils:Tween(MainFrame, {0.4, Enum.EasingStyle.Quart}, {Size = self.Minimized and UDim2.new(0, 600, 0, 35) or UDim2.new(0, 600, 0, 400)})
    end)

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 170, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = T.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner", Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "BNXYUNG7 MENU"
    Title.TextColor3 = T.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Sidebar

    local Nav = Instance.new("Frame")
    Nav.Position = UDim2.new(0, 0, 0, 60)
    Nav.Size = UDim2.new(1, 0, 1, -110)
    Nav.BackgroundTransparency = 1
    Nav.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout", Nav)
    NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NavLayout.Padding = UDim.new(0, 5)

    -- ÁREA DE CONTENIDO
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Position = UDim2.new(0, 170, 0, 35)
    Content.Size = UDim2.new(1, -170, 1, -35)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- SISTEMA DE PÁGINAS
    local function AddPage(name)
        local P = Instance.new("Frame")
        P.Name = name .. "Page"
        P.Size = UDim2.new(1, 0, 1, 0)
        P.BackgroundTransparency = 1
        P.Visible = false
        P.Parent = Content
        
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1, -40, 0, 50)
        L.Position = UDim2.new(0, 20, 0, 10)
        L.BackgroundTransparency = 1
        L.Text = name:upper()
        L.TextColor3 = T.Text
        L.Font = Enum.Font.GothamBold
        L.TextSize = 22
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.Parent = P

        self.Pages[name] = P

        local B = Instance.new("TextButton")
        B.Size = UDim2.new(0.9, 0, 0, 38)
        B.BackgroundColor3 = T.Sidebar
        B.BorderSizePixel = 0
        B.Text = "  " .. name
        B.TextColor3 = T.TextDim
        B.Font = Enum.Font.GothamMedium
        B.TextSize = 14
        B.TextXAlignment = Enum.TextXAlignment.Left
        B.AutoButtonColor = false
        B.Parent = Nav

        local BCorn = Instance.new("UICorner", B)
        BCorn.CornerRadius = UDim.new(0, 6)

        B.MouseEnter:Connect(function() BNXYUNG7.Utils:Tween(B, {0.2}, {BackgroundColor3 = T.Hover, TextColor3 = T.Text}) end)
        B.MouseLeave:Connect(function() BNXYUNG7.Utils:Tween(B, {0.2}, {BackgroundColor3 = T.Sidebar, TextColor3 = T.TextDim}) end)
        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(self.Pages) do pg.Visible = false end
            P.Visible = true
        end)
    end

    local tabs = {"Home", "Visual", "Aimbot", "Misc", "Settings"}
    for _, t in ipairs(tabs) do AddPage(t) end
    if self.Pages.Home then self.Pages.Home.Visible = true end

    -- BOTÓN COPIAR
    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0.85, 0, 0, 35)
    CopyBtn.Position = UDim2.new(0.075, 0, 1, -45)
    CopyBtn.BackgroundColor3 = T.Accent
    CopyBtn.Text = "Copiar"
    CopyBtn.TextColor3 = T.Main
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.TextSize = 14
    CopyBtn.Parent = Sidebar
    
    local CopyCorn = Instance.new("UICorner", CopyBtn)
    CopyCorn.CornerRadius = UDim.new(0, 6)

    CopyBtn.MouseEnter:Connect(function() BNXYUNG7.Utils:Tween(CopyBtn, {0.2}, {BackgroundColor3 = T.Text}) end)
    CopyBtn.MouseLeave:Connect(function() BNXYUNG7.Utils:Tween(CopyBtn, {0.2}, {BackgroundColor3 = T.Accent}) end)
    CopyBtn.MouseButton1Click:Connect(function()
        local ok = BNXYUNG7.Utils:Copy("BNXYUNG7 MENU LOADED")
        CopyBtn.Text = ok and "¡Copiado!" or "Error"
        BNXYUNG7.Utils:Tween(CopyBtn, {0.2}, {BackgroundColor3 = T.Green})
        task.delay(1, function()
            CopyBtn.Text = "Copiar"
            BNXYUNG7.Utils:Tween(CopyBtn, {0.2}, {BackgroundColor3 = T.Accent})
        end)
    end)

    -- ARRASTRE (FIXED)
    local dStart, sPos, dragging
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dStart = i.Position
            sPos = MainFrame.Position
            
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dStart
            MainFrame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
        end
    end)

    -- ANIMACIÓN APERTURA
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    BNXYUNG7.Utils:Tween(MainFrame, {0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 600, 0, 400)})
end

function BNXYUNG7.UI:SetupControls()
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == TOGGLE_KEY then
            if self.Instances.Main then
                self.Visible = not self.Visible
                self.Instances.Main.Visible = self.Visible
            end
        end
    end)
end

-- =============================================================================
-- 5. INICIALIZADOR FINAL
-- =============================================================================
local function Init()
    print("--------------------------------")
    print("   BNXYUNG7 PROJECT ALL-IN-ONE  ")
    print("   Status: Fixed & Optimized    ")
    print("--------------------------------")
    local success, err = pcall(function()
        BNXYUNG7.UI:Init()
    end)
    
    if success then
        print("[System] Menú cargado con éxito.")
    else
        warn("[Critical Error] Fallo al inicializar: " .. tostring(err))
    end
end

Init()
