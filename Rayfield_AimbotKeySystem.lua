--[[ 
    Rayfield Aimbot Script com Key System (Discord)
    Ao rodar, pede a key. Para conseguir a key, copia o link do Discord: https://discord.gg/sSKmjQURTB
    A key correta libera o aimbot. O aimbot mira instantaneamente na cabeça do inimigo mais próximo.
    FEITO PARA JOGOS DE ARMA NO ROBLOX (exemplo didático, adapte para seu jogo!)
    by SpiderDev Rayfield
]]

-- Carrega Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- CONFIGURE SUA KEY ABAIXO
local KEY_CORRETA = "SPIDERDEV2024" -- (troque por outra se quiser)

-- Função para copiar link do Discord
local function CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif toclipboard then
        toclipboard(text)
    else
        -- fallback: mostrar aviso
        Rayfield:Notify({
            Title = "Atenção",
            Content = "Não foi possível copiar automaticamente! Copie manualmente:\n" .. text,
            Duration = 8,
        })
    end
end

-- Key System
local liberado = false
local function KeySystem()
    local win = Rayfield:CreateWindow({
        Name = "Aimbot Key System | by SpiderDev Rayfield",
        LoadingTitle = "Key System",
        LoadingSubtitle = "Entre no Discord para pegar a key!",
        ConfigurationSaving = {Enabled = false},
        Discord = {Enabled = false},
        KeySystem = false,
    })

    local keyTab = win:CreateTab("Key", 6035067836)
    keyTab:CreateSection("Obtenha sua key no Discord:")
    keyTab:CreateButton({
        Name = "Copiar Link do Discord",
        Callback = function()
            CopyToClipboard("https://discord.gg/sSKmjQURTB")
            Rayfield:Notify({
                Title = "Link Copiado!",
                Content = "Cole no navegador para entrar.",
                Duration = 3,
            })
        end,
    })
    keyTab:CreateSection("Digite sua Key")
    local inputKey = ""
    keyTab:CreateInput({
        Name = "Key",
        PlaceholderText = "Digite a key aqui...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Value)
            inputKey = Value
        end,
    })
    keyTab:CreateButton({
        Name = "Verificar Key",
        Callback = function()
            if string.lower(inputKey) == string.lower(KEY_CORRETA) then
                liberado = true
                Rayfield:Notify({
                    Title = "Sucesso!",
                    Content = "Key correta. Aimbot liberado!",
                    Duration = 3,
                })
                task.wait(1.5)
                win:Destroy()
            else
                Rayfield:Notify({
                    Title = "Key Incorreta",
                    Content = "Pegue a key correta no Discord!",
                    Duration = 3,
                })
            end
        end,
    })

    -- Aguarda a key correta
    while not liberado do
        task.wait(0.5)
    end
end
KeySystem()

-- ============================
-- Aimbot Instantâneo (Cabeça)
-- ============================
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function GetClosestPlayerToMouse()
    local closestPlayer, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local headPos = player.Character.Head.Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
            if onScreen then
                local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Aimbot: vira a tela instantaneamente para a cabeça do inimigo mais próximo
local AimbotAtivado = false

local MainWin = Rayfield:CreateWindow({
    Name = "Aimbot | by SpiderDev Rayfield",
    LoadingTitle = "",
    LoadingSubtitle = "",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
})

local AimbotTab = MainWin:CreateTab("Aimbot", 6035067836)
AimbotTab:CreateSection("Aimbot Instantâneo")
AimbotTab:CreateToggle({
    Name = "Aimbot (Vira tela para cabeça)",
    CurrentValue = false,
    Callback = function(val)
        AimbotAtivado = val
        Rayfield:Notify({
            Title = val and "Aimbot ON" or "Aimbot OFF",
            Content = val and "Mira automática ativada." or "Mira automática desativada.",
            Duration = 2,
        })
    end,
})

-- Loop do Aimbot (quando ativado)
RunService.RenderStepped:Connect(function()
    if AimbotAtivado then
        local enemy = GetClosestPlayerToMouse()
        if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemy.Character.Head.Position)
        end
    end
end)

AimbotTab:CreateSection("Créditos")
AimbotTab:CreateParagraph({
    Title = "Script by SpiderDev Rayfield",
    Content = "Key apenas no Discord: https://discord.gg/sSKmjQURTB"
})