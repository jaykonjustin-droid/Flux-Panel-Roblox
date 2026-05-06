--[[
    UtilityLib - Biblioteca de utilidades comunes
]]

local UtilityLib = {
    Version = "1.0.0"
}

function UtilityLib:Init()
    print("[Utils] Utilidades listas.")
end

-- Ejemplo de función de utilidad
function UtilityLib:FormatNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

return UtilityLib
