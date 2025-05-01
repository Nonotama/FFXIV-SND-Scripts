--[[

********************************************************************************
*                             Multi Zone Farming                               *
*                                Version 1.0.1                                 *
********************************************************************************

Multi zone farming script meant to be used with `Fate Farming.lua`. This will go
down the list of zones and farm fates until there are no eligible fates left,
then teleport to the next zone and restart the fate farming script.

Created by: pot0to (https://ko-fi.com/pot0to)
        
    -> 1.0.1    Added check for death and unexpected combat
                First release

--#region Settings

--[[
********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

FateMacro = "Farming"      -- Name of whatever you nicknamed the base fate farming SND script

-- Ctrl+F through Fate Farming.lua to find the zoneIds, or find them in Godbert
-- ジョブを設定していないゾーンは実行されない
ZonesToFarmTable =
{
    -- DT
    { zoneName="オルコ・パチャ",       zoneId=1187, jobName="" },
    { zoneName="コザマル・カ",         zoneId=1188, jobName="" },
    { zoneName="ヤクテル樹海",         zoneId=1189, jobName="" },
    { zoneName="シャーローニ荒野",     zoneId=1190, jobName="ヴァイパー" },
    { zoneName="ヘリテージファウンド", zoneId=1191, jobName="ヴァイパー" },
    { zoneName="リビング・メモリー",   zoneId=1192, jobName="ヴァイパー" },
    -- EW
    { zoneName="ラヴィリンソス",       zoneId=956,  jobName="" },
    { zoneName="サベネア島",           zoneId=957,  jobName="" },
    { zoneName="ガレマルド",           zoneId=958,  jobName="" },
    { zoneName="嘆きの海",             zoneId=959,  jobName="" },
    { zoneName="ウルティマ・トゥーレ", zoneId=960,  jobName="ヴァイパー" },
    { zoneName="エルピス",             zoneId=961,  jobName="ヴァイパー" },
    -- ShB
    { zoneName="レイクランド",         zoneId=813,  jobName="" },
    { zoneName="コルシア島",           zoneId=814,  jobName="" },
    { zoneName="アム・アレーン",       zoneId=815,  jobName="" },
    { zoneName="イル・メグ",           zoneId=816,  jobName="ヴァイパー" },
    { zoneName="ラケティカ大森林",     zoneId=817,  jobName="" },
    { zoneName="テンペスト",           zoneId=818,  jobName="ヴァイパー" },
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

ZonesToFarm = {}
for i=1, #ZonesToFarmTable do
    if ZonesToFarmTable[i].jobName ~= "" then
        ZonesToFarm[#ZonesToFarm + 1] = ZonesToFarmTable[i]
        LogInfo("[MultiZone] AddFarmTable:" .. ZonesToFarmTable[i].zoneName)
    end
end
FarmingZoneIndex = 1
for i=1, #ZonesToFarm do
    if GetZoneID() == ZonesToFarm[i].zoneId then
        FarmingZoneIndex = i
    end
end
OldBicolorGemCount = GetItemCount(26807)
while true do
    if not IsPlayerOccupied() and not IsMacroRunningOrQueued(FateMacro) then
        if GetCharacterCondition(2) or GetCharacterCondition(26) or GetZoneID() == ZonesToFarm[FarmingZoneIndex].zoneId then
            yield("/gs change "..ZonesToFarm[FarmingZoneIndex].jobName)
            LogInfo("[MultiZone] Starting FateMacro")
            yield("/snd run "..FateMacro)
            repeat
                yield("/wait 1")
            until not IsMacroRunningOrQueued(FateMacro)
            LogInfo("[MultiZone] FateMacro has stopped")
            NewBicolorGemCount = GetItemCount(26807)
            if NewBicolorGemCount == OldBicolorGemCount then
                yield("/echo Bicolor Count: "..NewBicolorGemCount)
                FarmingZoneIndex  = (FarmingZoneIndex % #ZonesToFarm) + 1
            else
                OldBicolorGemCount = NewBicolorGemCount
            end
        else
            LogInfo("[MultiZone] Teleporting to "..ZonesToFarm[FarmingZoneIndex].zoneName)
            TeleportTo(GetAetheryteName(GetAetherytesInZone(ZonesToFarm[FarmingZoneIndex].zoneId)[0]))
        end
    end
    yield("/wait 1")
end