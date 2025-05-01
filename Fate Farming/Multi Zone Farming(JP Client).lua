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
-- �W���u��ݒ肵�Ă��Ȃ��]�[���͎��s����Ȃ�
ZonesToFarmTable =
{
    -- DT
    { zoneName="�I���R�E�p�`��",       zoneId=1187, jobName="" },
    { zoneName="�R�U�}���E�J",         zoneId=1188, jobName="" },
    { zoneName="���N�e�����C",         zoneId=1189, jobName="" },
    { zoneName="�V���[���[�j�r��",     zoneId=1190, jobName="���@�C�p�[" },
    { zoneName="�w���e�[�W�t�@�E���h", zoneId=1191, jobName="���@�C�p�[" },
    { zoneName="���r���O�E�������[",   zoneId=1192, jobName="���@�C�p�[" },
    -- EW
    { zoneName="�����B�����\�X",       zoneId=956,  jobName="" },
    { zoneName="�T�x�l�A��",           zoneId=957,  jobName="" },
    { zoneName="�K���}���h",           zoneId=958,  jobName="" },
    { zoneName="�Q���̊C",             zoneId=959,  jobName="" },
    { zoneName="�E���e�B�}�E�g�D�[��", zoneId=960,  jobName="���@�C�p�[" },
    { zoneName="�G���s�X",             zoneId=961,  jobName="���@�C�p�[" },
    -- ShB
    { zoneName="���C�N�����h",         zoneId=813,  jobName="" },
    { zoneName="�R���V�A��",           zoneId=814,  jobName="" },
    { zoneName="�A���E�A���[��",       zoneId=815,  jobName="" },
    { zoneName="�C���E���O",           zoneId=816,  jobName="���@�C�p�[" },
    { zoneName="���P�e�B�J��X��",     zoneId=817,  jobName="" },
    { zoneName="�e���y�X�g",           zoneId=818,  jobName="���@�C�p�[" },
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