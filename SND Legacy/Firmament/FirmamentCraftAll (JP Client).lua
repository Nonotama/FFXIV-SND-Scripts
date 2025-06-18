--[[

********************************************************************************
*                            Firmament Craft All                               *
*                               Version 1.0.0                                  *
********************************************************************************

Created by: pot0to (https://ko-fi.com/pot0to)

This script will teleport you to the firmament, switch to each crafter class and
run FirmamentCrafting.lua for each of those classes. You will need
FirmamentCrafting.lua in order for this to work.

********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

MacroName = "Crafting"      -- this is what you named the FirmamentCrafting.lua script in SND

--[[
********************************************************************************
*           Code: Don't touch this unless you know what you're doing           *
********************************************************************************
]]

Classes = {
    "木工師",
    "鍛冶師",
    "甲冑師",
    "彫金師",
    "革細工師",
    "裁縫師",
    "錬金術師",
    "調理師"
}

CharacterCondition = {
    casting=27,
    occupiedInEvent=31,
    occupiedInQuestEvent=32,
    occupied=33,
    betweenAreas=45,
    beingMoved=70
}

local Npcs =
{
    turnInNpc = "ポットキン",
    kupoVouchersNpc = "リズベス",
    x = 52.750366, y = -16, z = 168.9325
}

FoundationZoneId = 418
FirmamentZoneId = 886
function TeleportTo(aetheryteName)
    yield("/tp "..aetheryteName)
    yield("/wait 1") -- wait for casting to begin
    while GetCharacterCondition(CharacterCondition.casting) do
        LogInfo("[Firmament Craft All] Casting teleport...")
        yield("/wait 1")
    end
    yield("/wait 1") -- wait for that microsecond in between the cast finishing and the transition beginning
    while GetCharacterCondition(CharacterCondition.betweenAreas) do
        LogInfo("[Firmament Craft All] Teleporting...")
        yield("/wait 1")
    end
    yield("/wait 1")
end

if not (IsInZone(FoundationZoneId) or IsInZone(FirmamentZoneId)) then
    TeleportTo("イシュガルド：下層")
end
if IsInZone(FoundationZoneId) then
    yield("/target エーテライト")
    yield("/wait 1")
    if GetTargetName() == "エーテライト" then
        yield("/interact")
    end
    repeat
        yield("/wait 1")
    until IsAddonVisible("SelectString")
    yield("/callback SelectString true 2")
    repeat
        yield("/wait 1")
    until IsInZone(FirmamentZoneId) and not GetCharacterCondition(CharacterCondition.betweenAreas)
end

PathfindAndMoveTo(Npcs.x, Npcs.y, Npcs.z)
repeat
    yield("/wait 1")
until GetDistanceToPoint(Npcs.x, Npcs.y, Npcs.z) < 20

yield("/vnav stop")

for _, class in ipairs(Classes) do
    yield("/echo Crafting for "..class)
    yield("/gs change "..class)
    yield("/wait 5")

    yield("/snd run "..MacroName)
    repeat
        yield("/wait 5")
    until not IsMacroRunningOrQueued(MacroName)

    repeat
        yield("/callback RecipeNote true -1")
        yield("/wait 1")
    until not IsAddonVisible("RecipeNote")
end