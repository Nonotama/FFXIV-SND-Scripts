--[[

********************************************************************************
*                             Multi Zone Farming                               *
*                                Version 1.0.0                                 *
********************************************************************************

Multi zone farming script meant to be used with `Fate Farming.lua`. This will go
down the list of zones and farm fates until there are no eligible fates left,
then teleport to the next zone and restart the fate farming script.

Created by: pot0to (https://ko-fi.com/pot0to)
        
    -> 1.0.0    First release

--#region Settings

--[[
********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

FateMacro = "Fate Farming ( JP Client )"      -- Name of whatever you nicknamed the base fate farming SND script

-- Ctrl+F through Fate Farming.lua to find the zoneIds, or find them in Godbert
ZonesToFarm =
{
--    { zoneName = "オルコ・パチャ", zoneId = 1187 },
--    { zoneName = "コザマル・カ", zoneId = 1188 },
--    { zoneName = "ヤクテル樹海", zoneId = 1189 },
    { zoneName = "シャーローニ荒野", zoneId = 1190 },
    { zoneName = "ヘリテージファウンド", zoneId = 1191 },
--    { zoneName = "リビング・メモリー", zoneId = 1192 }
    { zoneName = "エルピス", zoneId = 961 },
    { zoneName = "ウルティマ・トゥーレ", zoneId = 960 },
}

--#endregion Settings

------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
**************************************************************
*  Code: Don't touch this unless you know what you're doing  *
**************************************************************
]]

CharacterCondition = {
    casting=27,
    betweenAreas=45
}

function TeleportTo(aetheryteName)
    yield("/tp "..aetheryteName)
    yield("/wait 1") -- wait for casting to begin
    while GetCharacterCondition(CharacterCondition.casting) do
        yield("/wait 1")
    end
    yield("/wait 1") -- wait for that microsecond in between the cast finishing and the transition beginning
    while GetCharacterCondition(CharacterCondition.betweenAreas) do
        yield("/wait 1")
    end
    yield("/wait 1")
end

FarmingZoneIndex = 3
NearestFateName = 0
OldBicolorGemCount = GetItemCount(26807)
while true do
    NearestFateName = GetFateName(GetNearestFate())
    if NearestFateName == 0 then
        FarmingZoneIndex = FarmingZoneIndex + 1
        if FarmingZoneIndex > #ZonesToFarm then
            FarmingZoneIndex = 2
        end
        LogInfo("[MultiZone] Teleporting to "..ZonesToFarm[FarmingZoneIndex].zoneName)
        TeleportTo(GetAetheryteName(GetAetherytesInZone(ZonesToFarm[FarmingZoneIndex].zoneId)[0]))
    end
    if not IsPlayerOccupied() and not IsMacroRunningOrQueued(FateMacro) then
        if GetZoneID() ~= ZonesToFarm[FarmingZoneIndex].zoneId then
            LogInfo("[MultiZone] Teleporting to "..ZonesToFarm[FarmingZoneIndex].zoneName)
            TeleportTo(GetAetheryteName(GetAetherytesInZone(ZonesToFarm[FarmingZoneIndex].zoneId)[0]))
        else
            LogInfo("[MultiZone] Starting FateMacro")
            yield("/snd run "..FateMacro)
            repeat
                yield("/wait 3")
            until not IsMacroRunningOrQueued(FateMacro)
            LogInfo("[MultiZone] FateMacro has stopped")
            NewBicolorGemCount = GetItemCount(26807)
            if NewBicolorGemCount == OldBicolorGemCount then
                yield("/echo Bicolor Count: "..NewBicolorGemCount)
                FarmingZoneIndex  = (FarmingZoneIndex % #ZonesToFarm) + 1
            else
                OldBicolorGemCount = NewBicolorGemCount
            end
        end
    end
    yield("/wait 1")
end