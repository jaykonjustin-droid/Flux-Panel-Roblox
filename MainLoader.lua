--[[
    MainLoader - Sistema de Carga Seguro para BNXYUNG Project
    Descripción: Inicializa módulos de forma controlada, segura y organizada.
]]

local MainLoader = {
    _VERSION = "1.0.0",
    _MODULES = {},
    _LOGS = {},
}

-- Configuración de integridad (Ejemplo: Versiones esperadas de módulos)
local INTEGRITY_MANIFEST = {
    ["MenuUI"] = "1.0.0",
    ["DataManager"] = "1.0.0",
    ["UtilityLib"] = "1.0.0"
}

-- Función para registrar logs
function MainLoader:Log(tag, message, level)
    local timestamp = os.date("%X")
    local entry = string.format("[%s] [%s] %s", timestamp, tag:upper(), message)
    table.insert(self._LOGS, entry)
    
    if level == "error" then
        warn(entry)
    else
        print(entry)
    end
end

-- Función principal para cargar un módulo
function MainLoader:LoadModule(moduleScript)
    if not moduleScript or not moduleScript:IsA("ModuleScript") then
        self:Log("Loader", "Fallo al cargar: El objeto no es un ModuleScript", "error")
        return nil
    end

    local moduleName = moduleScript.Name
    self:Log("Loader", "Iniciando carga de: " .. moduleName, "info")

    -- Ejecución segura con pcall
    local success, result = pcall(function()
        local module = require(moduleScript)
        
        -- Verificación de integridad básica (si el módulo tiene versión)
        if module.Version and INTEGRITY_MANIFEST[moduleName] then
            if module.Version ~= INTEGRITY_MANIFEST[moduleName] then
                self:Log("Integrity", "Advertencia: Versión de " .. moduleName .. " no coincide con el manifiesto", "error")
            end
        end

        -- Inicializar si el módulo tiene una función Init
        if type(module.Init) == "function" then
            module:Init()
        end

        return module
    end)

    if success then
        self._MODULES[moduleName] = result
        self:Log("Loader", "Módulo " .. moduleName .. " cargado con éxito", "info")
        return result
    else
        self:Log("Loader", "Error crítico en módulo " .. moduleName .. ": " .. tostring(result), "error")
        return nil
    end
end

-- Inicializar todo el sistema
function MainLoader:Init(modulesFolder)
    self:Log("System", "Iniciando BNXYUNG Loader v" .. self._VERSION, "info")
    
    if not modulesFolder then
        self:Log("System", "Error: No se proporcionó la carpeta de módulos", "error")
        return
    end

    -- Orden de carga preferido por carpetas
    local loadOrder = {"Utils", "Logic", "UI"}

    for _, folderName in ipairs(loadOrder) do
        local folder = modulesFolder:FindFirstChild(folderName)
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("ModuleScript") then
                    self:LoadModule(child)
                end
            end
        end
    end

    self:Log("System", "Carga finalizada. Módulos activos: " .. #table.keys(self._MODULES), "info")
end

-- Helper para obtener una tabla con las keys (necesario en Luau estándar)
function table.keys(t)
    local keys = {}
    for k in pairs(t) do table.insert(keys, k) end
    return keys
end

return MainLoader
