--[=====[
[[SND Metadata]]
author: 'pot0to || Updated by: Minnu'
version: 2.0.0
description: Multi Zone Farming - Companion script for Fate Farming
plugin_dependencies:
- Lifestream
- vnavmesh
- TextAdvance
configs:
  FateMacro:Fate Farming (JP)
    description: Name of the primary fate macro script.

[[End Metadata]]
--]=====]

--[[

********************************************************************************
*                             Multi Zone Farming                               *
*                                Version 2.0.0                                 *
********************************************************************************

Multi zone farming script meant to be used with `Fate Farming.lua`. This will go
down the list of zones and farm fates until there are no eligible fates left,
then teleport to the next zone and restart the fate farming script.

Created by: pot0to (https://ko-fi.com/pot0to)
Updated by: Minnu

    -> 2.0.0    Updated for Latest SnD
    -> 1.0.1    Added check for death and unexpected combat
                First release

--#region Settings

--[[
********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

FateMacro  = Config.Get("FateMacro")

ZonesToFarmTable =
{
    -- DT
    { zoneName="�I���R�E�p�`��",       zoneId=1187 },
    { zoneName="�R�U�}���E�J",         zoneId=1188 },
    { zoneName="���N�e�����C",         zoneId=1189 },
    { zoneName="�V���[���[�j�r��",     zoneId=1190 },
    { zoneName="�w���e�[�W�t�@�E���h", zoneId=1191 },
    { zoneName="���r���O�E�������[",   zoneId=1192 },
    -- EW 
    { zoneName="�����B�����\�X",       zoneId=956, },
    { zoneName="�T�x�l�A��",           zoneId=957, },
    { zoneName="�K���}���h",           zoneId=958, },
    { zoneName="�Q���̊C",             zoneId=959, },
    { zoneName="�E���e�B�}�E�g�D�[��", zoneId=960, },
    { zoneName="�G���s�X",             zoneId=961, },
    -- ShB
    { zoneName="���C�N�����h",         zoneId=813, },
    { zoneName="�R���V�A��",           zoneId=814, },
    { zoneName="�A���E�A���[��",       zoneId=815, },
    { zoneName="�C���E���O",           zoneId=816, },
    { zoneName="���P�e�B�J��X��",     zoneId=817, },
    { zoneName="�e���y�X�g",           zoneId=818, },
}

--#endregion Settings

------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
**************************************************************
*  Code: Don't touch this unless you know what you're doing  *
**************************************************************
]]

CharacterCondition = {
    dead          =  2,
    inCombat      = 26,
    casting       = 27,
    betweenAreas  = 45
}

function OnChatMessage()
    local message = TriggerData.message
    local patternToMatch = "%[Fate%] Loop Ended !!"

    if message and message:find(patternToMatch) then
        Dalamud.Log("[MultiZone] OnChatMessage triggered")
        FateMacroRunning = false
        Dalamud.Log("[MultiZone] FateMacro has stopped")
    end
end

function TeleportTo(aetheryteName)
    yield("/tp " .. aetheryteName)
    yield("/wait 1")
    while Svc.Condition[CharacterCondition.casting] do
        yield("/wait 1")
    end
    yield("/wait 1")
    while Svc.Condition[CharacterCondition.betweenAreas] do
        yield("/wait 1")
    end
    yield("/wait 1")
end

function GetAetheryteName(ZoneID)
    local territoryData = Excel.GetRow("TerritoryType", ZoneID)

    if territoryData and territoryData.Aetheryte and territoryData.Aetheryte.PlaceName then
        return tostring(territoryData.Aetheryte.PlaceName.Name)
    end
end

FarmingZoneIndex = 1
OldBicolorGemCount =Inventory.GetItemCount(26807)

while true do
    if not Player.IsBusy and not FateMacroRunning then
        if Svc.Condition[CharacterCondition.dead] or Svc.Condition[CharacterCondition.inCombat] or Svc.ClientState.TerritoryType == ZonesToFarm[FarmingZoneIndex].zoneId then
            Dalamud.Log("[MultiZone] Starting FateMacro")
            yield("/snd run " .. FateMacro)
            FateMacroRunning = true

            while FateMacroRunning do
                yield("/wait 3")
            end

            Dalamud.Log("[MultiZone] FateMacro has stopped")
            NewBicolorGemCount = Inventory.GetItemCount(26807)

            if NewBicolorGemCount == OldBicolorGemCount then
                FarmingZoneIndex  = (FarmingZoneIndex % #ZonesToFarm) + 1
            else
                OldBicolorGemCount = NewBicolorGemCount
            end
        else
            Dalamud.Log("[MultiZone] Teleporting to " .. ZonesToFarm[FarmingZoneIndex].zoneName)
            local aetheryteName = GetAetheryteName(ZonesToFarm[FarmingZoneIndex].zoneId)

            if aetheryteName then
                TeleportTo(aetheryteName)
            end
        end
    end
    yield("/wait 1")
end
