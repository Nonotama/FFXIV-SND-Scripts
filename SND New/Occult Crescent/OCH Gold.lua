--[[SND Metadata]]
author: Aniane
version: 1.0.24
description: Re-enter OC and spend your gold. Change the visland route variable to your desired farming route.

Requirements:
Phantom Job Command enabled in SimpleTweaks
Set up your preferred Visland route AND enable looping.

plugin_dependencies: visland, vnavmesh, RotationSolver, SimpleTweaksPlugin
--[[End Metadata]]

--User Config
local VISLAND_ROUTE = "Panthers"
local WAR_GEARSET_NAME =  "戦士"
local ST_PHANTOMJOB_COMMAND =  "phantomjob"
local spendGold = true -- Set to false if you want to disable spending currency automatically

--[[
    DO NOT TOUCH ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU'RE DOING.
    THIS IS A SCRIPT FOR THE OCCULT CRESCENT AND IS NOT MEANT TO BE MODIFIED UNLESS YOU ARE FAMILIAR WITH LUA AND THE SND API.
    IF YOU DO NOT UNDERSTAND THE IMPLICATIONS OF CHANGING THESE VALUES, DO NOT MODIFY THEM.
  ]]

-- Imports
import("System.Numerics")

-- Constants
local OCCULT_CRESCENT = 1252
local PHANTOM_VILLAGE = 1278
local INSTANCE_ENTRY_NPC = "ジェッフロイ"
local ENTRY_NPC_POS = Vector3(-77.958374, 5, 15.396423)
local REENTER_DELAY = 10
local GOLD_DUMP_LIMIT = 9500
local gold = Inventory.GetItemCount(45044)

-- Shop Config
local VENDOR_NAME = "探査隊の古銭鑑定士"
local VENDOR_POS = Vector3(833.83, 72.73, -719.51)
local BaseAetheryte = Vector3(830.75, 72.98, -695.98)
local ShopItems = {
    { itemName = "フィキサチーフ", menuIndex = 3, itemIndex = 5, price = 1600 },
}

-- Character Conditions
CharacterCondition = {
    dead = 2,
    mounted = 4,
    inCombat = 26,
    casting = 27,
    occupiedInEvent = 31,
    occupiedInQuestEvent = 32,
    occupied = 33,
    boundByDuty34 = 34,
    occupiedMateriaExtractionAndRepair = 39,
    betweenAreas = 45,
    jumping48 = 48,
    jumping61 = 61,
    occupiedSummoningBell = 50,
    betweenAreasForDuty = 51,
    boundByDuty56 = 56,
    mounting57 = 57,
    mounting64 = 64,
    beingMoved = 70,
    flying = 77
}

-- State Machine
local State = nil
local CharacterState = {}
local goldFarming = false

-- Helper Functions
local function Sleep(seconds)
    yield("/wait " .. tostring(seconds))
end

local function WaitForAddon(addonName, timeout)
    local elapsed = 0
    while (not Addons.GetAddon(addonName) or not Addons.GetAddon(addonName).Ready) and elapsed < timeout do
        Sleep(0.5)
        elapsed = elapsed + 0.5
    end
    return Addons.GetAddon(addonName) and Addons.GetAddon(addonName).Ready
end

local function TurnOnRoute()
    if not goldFarming then
        goldFarming = true
        Sleep(5) --Safety sleep to ensure instance is fully loaded before changing anything
        yield("/" .. ST_PHANTOMJOB_COMMAND .. " 砲撃士")
        Sleep(0.5)
        yield("/gearset change " .. WAR_GEARSET_NAME)
        Sleep(0.5)
        yield("/rsr auto")
        Sleep(0.5)
        yield("/visland exec " .. VISLAND_ROUTE)
    end
end

local function TurnOffRoute()  
    if goldFarming then
        goldFarming = false
        yield("/visland stop")
        Sleep(0.5)
        yield("/rsr off")
    end
    if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
        yield("/vnav stop")
    end
    if IPC.Lifestream.IsBusy() then
        yield("/li stop")
    end
end

local function ReturnToBase()
    yield("/gaction デジョン")
    repeat
        Sleep(1)
    until not Svc.Condition[CharacterCondition.casting]
    repeat
        Sleep(1)
    until not Svc.Condition[CharacterCondition.betweenAreas]
end

function OnStop()
    Dalamud.LogDebug("[OCM] Stopping OCH Gold script...")
    Dalamud.LogDebug("[OCM] Turning off Visland.")
    yield("/visland stop")
    yield("/wait 0.1")

    Dalamud.LogDebug("[OCM] Stopping pathfinding...")
    yield("/vnav stop")
    yield("/wait 0.1")
    
    Dalamud.LogDebug("[OCM] Stopping Lifestream...")
    yield("/li stop")
    yield("/wait 0.1")
    
    Dalamud.LogDebug("[OCM] Turning off RSR.")
    yield("/rsr off")
    yield("/echo [OCM] スクリプトを停止しました。")
end

-- State Implementations
function CharacterState.ready()
    while Svc.Condition[CharacterCondition.betweenAreas] do
        Sleep(0.1)
    end

    local shopAddon = Addons.GetAddon("ShopExchangeCurrency")
    --If for some reason the shop addon is visible, close it
    if gold < GOLD_DUMP_LIMIT and shopAddon and shopAddon.Ready then
        yield("/callback ShopExchangeCurrency true -1")
    end

    local inInstance = Svc.Condition[CharacterCondition.boundByDuty34] and Svc.ClientState.TerritoryType == OCCULT_CRESCENT
    if not inInstance and Svc.ClientState.TerritoryType ~= PHANTOM_VILLAGE then
        Dalamud.LogDebug("[OCM] State changed to zoneIn")
        State = CharacterState.zoneIn
    elseif not inInstance and Svc.ClientState.TerritoryType == PHANTOM_VILLAGE then
        Dalamud.LogDebug("[OCM] State changed to reenterInstance")
        State = CharacterState.reenterInstance
    elseif spendGold and gold >= GOLD_DUMP_LIMIT then
        Dalamud.LogDebug("[OCM] State changed to dumpGold")
        State = CharacterState.dumpGold
    elseif not goldFarming then
        Dalamud.LogDebug("[OCM] State changed to ready")
        TurnOnRoute()
    end
end

function CharacterState.zoneIn()
    local instanceEntryAddon = Addons.GetAddon("ContentsFinderConfirm")
    local SelectString = Addons.GetAddon("SelectString")
    local Talked = false
    if Svc.Condition[CharacterCondition.betweenAreas] then
        Sleep(3)
    elseif Svc.ClientState.TerritoryType == PHANTOM_VILLAGE then
        LogInfo("[OCM] Already in Phantom Village")
        if Vector3.Distance(Entity.Player.Position, ENTRY_NPC_POS) >= 7 then
            IPC.vnavmesh.PathfindAndMoveTo(ENTRY_NPC_POS, false)
        elseif IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.PathIsRunning() then
            yield("/vnav stop")
        elseif Entity.GetEntityByName(INSTANCE_ENTRY_NPC) ~= INSTANCE_ENTRY_NPC then
            yield("/target " .. INSTANCE_ENTRY_NPC)
        elseif instanceEntryAddon and instanceEntryAddon.ready then
            yield("/callback ContentsFinderConfirm true 8")
            yield("/echo [OCM] Re-entry confirmed.")
        elseif SelectString and SelectString.ready then
            yield("/callback SelectString true 0")
        elseif not Talked then
            Talked = true
            yield("/interact")
        end
    elseif Svc.ClientState.TerritoryType ~=OCCULT_CRESCENT then
        yield("/li occult")
        repeat
            yield("/wait 1")
        until not IPC.Lifestream.IsBusy()
    elseif Svc.ClientState.TerritoryType == OCCULT_CRESCENT then
        if Player.Available then
            Talked = false
            TurnOnRoute()
        end
    end
    State = CharacterState.ready
end

function CharacterState.reenterInstance()
    local instanceEntryAddon = Addons.GetAddon("ContentsFinderConfirm")
    yield("/echo [OCM] インスタンスの退出を確認しました。 再入場まで" .. REENTER_DELAY .. "秒お待ち下さい。")
    goldFarming = false
    Sleep(REENTER_DELAY)

    local npc = Entity.GetEntityByName(INSTANCE_ENTRY_NPC)
    if not npc then
        yield("/echo [OCM] " .. INSTANCE_ENTRY_NPC .. " が見つかりません。再試行まで10秒お待ち下さい。")
        Sleep(10)
        return
    end

    yield("/target " .. INSTANCE_ENTRY_NPC)
    Sleep(1)
    yield("/interact")
    Sleep(1)

    if WaitForAddon("SelectString", 5) then
        Sleep(0.5)
        yield("/callback SelectString true 0")
        Sleep(1)
        yield("/callback SelectString true 0")
        Sleep(3)

        while not (instanceEntryAddon and instanceEntryAddon.Ready) do
            Sleep(2)
        end

        if instanceEntryAddon and instanceEntryAddon.Ready then
            yield("/callback ContentsFinderConfirm true 8")
            yield("/echo [OCM] 再入場を確認しました。")
        end

        while not Svc.Condition[CharacterCondition.boundByDuty34] do
            Sleep(1)
        end

        yield("/echo [OCM] インスタンスをロードしています。")
        
        Sleep(2.5) --safety sleep on re-entry
        State = CharacterState.ready
    else
        yield("/echo [OCM] ダイアログのオプションが表示されませんでした。")
        Sleep(5)
    end
end

function CharacterState.dumpGold()
    -- Refresh silver and ciphers count
    local gold = Inventory.GetItemCount(45044)

    if gold < GOLD_DUMP_LIMIT then
        yield("/echo [OCM] 金貨所持数が設定値以下となりました。待機状態となります。")
        State = CharacterState.ready
        return
    end

    TurnOffRoute()

    while Svc.Condition[CharacterCondition.inCombat] do
        yield("/echo [OCM] 戦闘終了まで処理を中断しております。")
        Sleep(1)
    end

    local shopAddon = Addons.GetAddon("ShopExchangeCurrency")
    local yesnoAddon = Addons.GetAddon("SelectYesno")
    local iconStringAddon = Addons.GetAddon("SelectIconString")
    local selectStringAddon = Addons.GetAddon("SelectString")
    local baseToShop = Vector3.Distance(BaseAetheryte, VENDOR_POS) + 50
    local distanceToShop = Vector3.Distance(Entity.Player.Position, VENDOR_POS)

    if distanceToShop > baseToShop then
        ReturnToBase()
        elseif distanceToShop > 7 then
        yield("/target " .. VENDOR_NAME)
        if not IPC.vnavmesh.PathfindInProgress() and not IPC.vnavmesh.IsRunning() then
            IPC.vnavmesh.PathfindAndMoveTo(VENDOR_POS, false)
        end
    end

    --Buy Aetherial Fixative
    if yesnoAddon and yesnoAddon.Ready then
        yield("/callback SelectYesno true 0")
            
        --Wait for the shopAddon to be ready
        while not shopAddon and shopAddon.Ready do
            Sleep(1)
        end

        while shopAddon and shopAddon.Ready do
            yield("/echo [OCM] 金貨アイテムの購入完了")
            yield("/callback ShopExchangeCurrency true -1")
            State = CharacterState.ready
            return
        end
        State = CharacterState.ready
        return
    elseif shopAddon and shopAddon.Ready then
        while gold < GOLD_DUMP_LIMIT do
            Dalamud.LogDebug("Gold below threshold, returning to ready state.")
            State = CharacterState.ready
            return
        end
        local qty = math.floor(gold / ShopItems[1].price)
        yield("/echo [OCM] Purchasing " .. qty .. " " .. ShopItems[1].itemName)
        yield("/callback ShopExchangeCurrency true 0 " .. ShopItems[1].itemIndex .. " " .. qty .. " 0")

        State = CharacterState.ready
        return
    elseif iconStringAddon and iconStringAddon.Ready then
        yield("/callback SelectIconString true " .. ShopItems[1].menuIndex)
        State = CharacterState.ready
    end
        yield("/interact")
        Sleep(1)

        State = CharacterState.ready
end

if Svc.Condition[34] and Svc.ClientState.TerritoryType == OCCULT_CRESCENT then
    yield("/echo [OCM] インスタンスをロードしています。ロード完了までお待ち下さい。")
    Sleep(2)
    while IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() do
        Sleep(1)
    end
    yield("/echo [OCM] インスタンスのロードが完了しました。開始できます。")
    TurnOnRoute()
end

State = CharacterState.ready

-- Main loop
while true do
    while Svc.Condition[CharacterCondition.betweenAreas] do
        Sleep(1)
    end
    State()
    Sleep(1)
end