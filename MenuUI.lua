--[[
    MenuUI - Módulo de Interfaz BNXYUNG MENU
    Encapsulado para carga segura.
]]

local MenuUI = {
    Version = "1.0.0",
    Active = false,
    UI = nil
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local THEME = {
    Background = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    ButtonHover = Color3.fromRGB(45, 45, 45)
}

function MenuUI:Init()
    print("[UI] Inicializando BNXYUNG MENU...")
    self:Create()
end

function MenuUI:Create()
    local player = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BNXYUNG_MENU_UI"
    ScreenGui.ResetOnSpawn = false
    
    -- Ubicación segura
    local success, target = pcall(function() return game:GetService("CoreGui") end)
    ScreenGui.Parent = (success and target) or player:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "BNXYUNG MENU"
    Title.TextColor3 = THEME.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = MainFrame

    -- Sistema Draggable
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    self.UI = ScreenGui
    self.Active = true
    print("[UI] Menú creado y listo.")
end

return MenuUI
