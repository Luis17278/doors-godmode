-- Evita execuções duplicadas
if _G.GodModeLoaded then return end
_G.GodModeLoaded = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- --- CONFIGURAÇÃO DE LUZ (FULLBRIGHT) ---
local function EnableFullBright()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
end
EnableFullBright()
Lighting.Changed:Connect(EnableFullBright)

-- --- FUNÇÃO DE DESTRUIÇÃO DA HITBOX DE DANO ---
local function ApplyGodMode(character)
    if not character then return end
    
    -- O Arceus X precisa esperar o personagem carregar totalmente
    character:WaitForChild("HumanoidRootPart")
    
    -- Loop contínuo para garantir que nenhuma hitbox de dano te afete
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not character:Parent() then
            connection:Disconnect()
            return
        end
        
        -- Varre o mapa procurando hitboxes de dano que possam te tocar
        for _, obj in ipairs(workspace:GetDescendants()) do
            -- Ignora explicitamente o Figure e o Seek para manter o desafio/mecânica
            if obj.Name ~= "Figure" and obj.Name ~= "Seek" then
                -- Verifica se o objeto causa dano por toque (TouchInterest)
                if obj:IsA("TouchTransmitter") or obj:IsA("TouchInterest") then
                    local parent = obj.Parent
                    -- Se a hitbox estiver perto de você, desativa a colisão dela com seu personagem
                    if parent and parent:IsA("BasePart") and LocalPlayer:DistanceFromCharacter(parent.Position) < 15 then
                        parent.CanTouch = false
                    end
                end
            end
        end
    end)
end

-- --- IMUNIDADE AO SCREECH ---
-- Monitora quando o Screech tenta spawnar ou atacar o jogador
workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Screech" then
        task.wait()
        -- Deleta o Screech antes que ele aplique o jumpscare/dano
        descendant:Destroy()
    end
end)

-- Aplica no personagem atual e nos próximos após morrer
if LocalPlayer.Character then ApplyGodMode(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ApplyGodMode)
