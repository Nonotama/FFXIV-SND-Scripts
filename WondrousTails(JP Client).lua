--[[
※※※ 最初にAutoDutyでTrustを開き、フェイスの更新を行うこと！！ ※※※

********************************************************************************
*                             Wondrous Tails Doer                              *
*                                Version 0.2.2                                 *
********************************************************************************

Created by: pot0to (https://ko-fi.com/pot0to)

Description: Picks up a Wondrous Tails journal from Khloe, then attempts each duty

For dungeons:
- Attempts dungeon Unsynced if duty is at least 20 levels below you
- Attempts dungeon with Duty Support if duty is within 20 levels of you and Duty
Support is available

For EX Trials:
- Attempts any duty unsynced if it is 20 levels below you and skips any that are
within 20 levels
- Note: Not all EX trials have BossMod support, but this script will attempt
each one once anyways
- Some EX trials are blacklisted due to mechanics that cannot be done solo
(Byakko tank buster, Tsukuyomi meteors, etc.)

Alliance Raids/PVP/Treasure Maps/Palace of the Dead
- Skips them all


    -> 0.2.1    Duty names updated after patch 7.2
    -> 0.2.0    Fixes for ex trials
                Update for patch 7.1

********************************************************************************
*                               Required Plugins                               *
********************************************************************************
1. Autoduty
2. Rotation Solver Reborn
3. BossModReborn (BMR) or Veyn's BossMod (VBM)
]]

-- Region: Data ---------------------------------------------------------------------------------

WonderousTailsDuties = {
    { -- type 0:extreme trials
        { dutyMode="Trial", instanceId=20010, dutyId=297, dutyName="極ガルーダ討滅戦" },
        { dutyMode="Trial", instanceId=20009, dutyId=296, dutyName="極タイタン討滅戦" },
        { dutyMode="Trial", instanceId=20008, dutyId=295, dutyName="極イフリート討滅戦" },
        { dutyMode="Trial", instanceId=20012, dutyId=364, dutyName="極王モグル・モグXII世討滅戦" },
        { dutyMode="Trial", instanceId=20018, dutyId=359, dutyName="極リヴァイアサン討滅戦" },
        { dutyMode="Trial", instanceId=20023, dutyId=375, dutyName="極ラムウ討滅戦" },
        { dutyMode="Trial", instanceId=20025, dutyId=378, dutyName="極シヴァ討滅戦" },
        { dutyMode="Trial", instanceId=20013, dutyId=348, dutyName="究極幻想 アルテマウェポン破壊作戦" },
        { dutyMode="Trial", instanceId=20032, dutyId=446, dutyName="極ラーヴァナ討滅戦" },
        { dutyMode="Trial", instanceId=20036, dutyId=448, dutyName="蒼天幻想 ナイツ・オブ・ラウンド討滅戦" },
        { dutyMode="Trial", instanceId=20038, dutyId=524, dutyName="極魔神セフィロト討滅戦" },
        { dutyMode="Trial", instanceId=20040, dutyId=566, dutyName="極ニーズヘッグ征竜戦" },
        { dutyMode="Trial", instanceId=20042, dutyId=577, dutyName="極女神ソフィア討滅戦" },
    },
    { -- type 1: expansion cap dungeons
        { dutyMode="Trust", dutyName="Lv100ダンジョン", dutyId=1266 }, --王城旧跡 アンダーキープ
    },
    2,
    3,
    { -- type 4: normal raids
        { dutyMode="Raid", dutyName="大迷宮バハムート：邂逅編1-4", dutyId=241 }, --1層
        { dutyMode="Raid", dutyName="大迷宮バハムート：侵攻編1-4", dutyId=355 }, --1層
--        { dutyMode="Raid", dutyName="大迷宮バハムート：真成編1-4", dutyId=193 }, --1層
        { dutyMode="Raid", dutyName="機工城アレキサンダー：起動編1-4", dutyId=442 },  --1層
        { dutyMode="Raid", dutyName="機工城アレキサンダー：律動編1-4", dutyId=520 },  --1層
        { dutyMode="Raid", dutyName="機工城アレキサンダー：天道編1-4", dutyId=580 },  --1層
        { dutyMode="Raid", dutyName="次元の狭間オメガ：デルタ編1-4", dutyId=693 },  --3層
        { dutyMode="Raid", dutyName="次元の狭間オメガ：シグマ編1-4", dutyId=748 },  --1層
        { dutyMode="Raid", dutyName="次元の狭間オメガ：オメガ編1-4", dutyId=798 },  --1層
--        { dutyMode="Raid", dutyName="希望の園エデン：覚醒編1", dutyId=849 },
--        { dutyMode="Raid", dutyName="希望の園エデン：共鳴編1", dutyId=903 },
--        { dutyMode="Raid", dutyName="希望の園エデン：再生編1", dutyId=942 },
    },
    { -- type 5: leveling dungeons
        { dutyMode="Trial", dutyName="レベリングダンジョン Lv1-49", dutyId=1045 }, --イフリート討伐戦
        { dutyMode="Regular", dutyName="レベリングダンジョン Lv51-59/61-69/71-79", dutyId=434 }, --廃砦捜索 ダスクヴィジル
        { dutyMode="Regular", dutyName="レベリングダンジョン Lv81-89/91-99", dutyId=952 }, --異形楼閣 ゾットの塔
    },
    { -- type 6: expansion cap dungeons
        { dutyMode="Regular", dutyName="ハイレベリングダンジョン Lv50-60", dutyId=362 }, --盟友支援 ブレイフロクスの野営地 (Hard)
        { dutyMode="Regular", dutyName="ハイレベリングダンジョン Lv70・80", dutyId=788 }, --草木汚染 聖モシャーヌ植物園 (Hard)
        { dutyMode="Trust", dutyName="ハイレベリングダンジョン Lv90", dutyId=973 }, --最終幻想 レムナント
    },
    { -- type 7: ex trials

    },
    { -- type 8: alliance raids

    },
    { -- type 9: normal raids

    },
    Blacklisted= {
        { -- 0
            -- 蒼天
            { dutyMode="Trial", instanceId=20034, dutyId=447, dutyName="極ビスマルク討滅戦" }, 
            { dutyMode="Trial", instanceId=20044, dutyId=638, dutyName="極鬼神ズルワーン討滅戦" },
            -- 紅蓮
            { dutyMode="Trial", instanceId=20047, dutyId=677, dutyName="極スサノオ討滅戦" },
            { dutyMode="Trial", instanceId=20049, dutyId=720, dutyName="極ラクシュミ討滅戦" },
            { dutyMode="Trial", instanceId=20052, dutyId=758, dutyName="極白虎征魂戦" },
            { dutyMode="Trial", instanceId=20054, dutyId=762, dutyName="極リオレウス狩猟戦" },
            { dutyMode="Trial", instanceId=20056, dutyId=779, dutyName="極ツクヨミ討滅戦" },
            { dutyMode="Trial", instanceId=20058, dutyId=811, dutyName="極朱雀征魂戦" },
            { dutyMode="Trial", instanceId=20061, dutyId=825, dutyName="極極青龍征魂戦" },
            -- 漆黒
            { dutyMode="Trial", instanceId=20063, dutyId=858, dutyName="極ティターニア討滅戦" },
            { dutyMode="Trial", instanceId=20065, dutyId=848, dutyName="極イノセンス討滅戦" },
            { dutyMode="Trial", instanceId=20067, dutyId=885, dutyName="極ハーデス討滅戦" },
            { dutyMode="Trial", instanceId=20069, dutyId=912, dutyName="極ルビーウェポン破壊作戦" },
            { dutyMode="Trial", instanceId=20070, dutyId=913, dutyName="極シタデル・ボズヤ追憶戦" },
            { dutyMode="Trial", instanceId=20072, dutyId=923, dutyName="極ウォーリイア・オブ・ライト討滅戦" },
            { dutyMode="Trial", instanceId=20074, dutyId=935, dutyName="極エメラルドウェポン破壊作戦" },
            { dutyMode="Trial", instanceId=20076, dutyId=951, dutyName="極ダイヤウェポン破壊作戦" },
            -- 暁月
            { dutyMode="Trial", instanceId=20078, dutyId=996, dutyName="極ハイデリン討滅戦" },
            { dutyMode="Trial", instanceId=20081, dutyId=993, dutyName="極ゾディアーク討滅戦" },
            { dutyMode="Trial", instanceId=20083, dutyId=998, dutyName="終極の戦い" },
            { dutyMode="Trial", instanceId=20085, dutyId=1072, dutyName="極バルバリシア討滅戦" },
            { dutyMode="Trial", instanceId=20087, dutyId=1096, dutyName="極ルビカンテ討滅戦" },
            { dutyMode="Trial", instanceId=20090, dutyId=1141, dutyName="極ゴルベーザ討滅戦" },
            { dutyMode="Trial", instanceId=20092, dutyId=1169, dutyName="極ゼロムス討滅戦" },
        },
        {}, -- 1
        {}, -- 2
        { -- 3
            { dutyName="Treasure Dungeons" }
        },
        { -- 4
            { dutyName="アライアンスレイド（新生エオルゼア）", dutyId=174 },
            { dutyName="アライアンスレイド（蒼天のイシュガルド）", dutyId=508 },
            { dutyName="アライアンスレイド（紅蓮のリベレーター）", dutyId=734 },
            { dutyName="アライアンスレイド（漆黒のヴィランズ）", dutyId=882 },
            { dutyName="アライアンスレイド（暁月のフィナーレ）", dutyId=1054 },
            { dutyName="万魔殿パンデモニウム：辺獄編1-4", dutyId=1002 },
            { dutyName="万魔殿パンデモニウム：煉獄編1-4", dutyId=1081 },
            { dutyName="万魔殿パンデモニウム：天獄編1-4", dutyId=1147 },
            { dutyName="至天の座アルカディア：ライトヘビー級1-2", dutyId=1125 },
            { dutyName="至天の座アルカディア：ライトヘビー級3-4", dutyId=1231 },
            { dutyName="至天の座アルカディア：クルーザー級1-2", dutyId=1231 },
            { dutyName="至天の座アルカディア：クルーザー級3-4", dutyId=1231 },
        }
    }
}

Khloe = {
    x = -19.346453,
    y = 210.99998,
    z = 0.086749226,
    name = "クロ・アリアポー"
}

-- Region: Functions ---------------------------------------------------------------------------------

function SearchWonderousTailsTable(type, data, text)
    if type == 0 then -- ex trials are indexed by instance#
        for _, duty in ipairs(WonderousTailsDuties[type+1]) do
            if duty.instanceId == data then
                return duty
            end
        end
    elseif type == 1 or type == 5 or type == 6 or type == 7 then -- dungeons, level range ex trials
        for _, duty in ipairs(WonderousTailsDuties[type+1]) do
            if duty.dutyName == text then
                return duty
            end
        end
    elseif type == 4 or type == 8 then -- normal raids
        for _, duty in ipairs(WonderousTailsDuties[type+1]) do
            if duty.dutyName == text then
                return duty
            end
        end
    end
end

-- Region: Main ---------------------------------------------------------------------------------

CurrentLevel = GetLevel()

-- Pick up a journal if you need one
if not HasWeeklyBingoJournal() or IsWeeklyBingoExpired() or WeeklyBingoNumPlacedStickers() == 9 then
    if not IsInZone(478) then
        yield("/tp イディルシャイア")
        yield("/wait 1")
    end
    while not (IsInZone(478) and IsPlayerAvailable()) do
        yield("/wait 1")
    end
    PathfindAndMoveTo(Khloe.x, Khloe.y, Khloe.z)
    while(GetDistanceToPoint(Khloe.x, Khloe.y, Khloe.z) > 5) do
        yield("/wait 1")
    end
    yield("/target "..Khloe.name)
    yield("/wait 1")
    yield("/interact")
    while not IsAddonVisible("SelectString") do
        yield("/click Talk Click")
        yield("/wait 1")
    end
    if IsAddonVisible("SelectString") then
        if not HasWeeklyBingoJournal() then
            yield("/callback SelectString true 0")
        elseif IsWeeklyBingoExpired() then
            yield("/callback SelectString true 1")
        elseif WeeklyBingoNumPlacedStickers() == 9 then
            yield("/callback SelectString true 0")
        end
        
    end
    while GetCharacterCondition(32) do
        yield("/click Talk Click")
        yield("/wait 1")
    end
    yield("/wait 1")
end

yield("/bmrai on")

-- skip 13: Shadowbringers raids (not doable solo unsynced)
-- skip 14: Endwalker raids (not doable solo unsynced)
-- skip 15: PVP
for i = 0, 12 do
    if GetWeeklyBingoTaskStatus(i) == 0 then
        local key = GetWeeklyBingoOrderDataKey(i)
        local type = GetWeeklyBingoOrderDataType(key)
        local data = GetWeeklyBingoOrderDataData(key)
        local text = GetWeeklyBingoOrderDataText(key)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Key: "..key)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Type: "..type)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Data: "..data)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Text: "..text)

        local duty = SearchWonderousTailsTable(type, data, text)

        if duty ~= nil then
            if duty.dutyMode == "Trust" then
                yield("/autoduty cfg Unsynced false")
                jobName = "ヴァイパー"
            else
                yield("/autoduty cfg Unsynced true")
                jobName = "ヴァイパー"
            end
            yield("/gs change "..jobName)
            yield("/wait 1")

            if duty.dutyId ~= nil then
                yield("/autoduty run "..duty.dutyMode.." "..duty.dutyId.." 1 true")
                yield("/echo [WonderousTails] 実行中（"..(i+1).."マス目）："..duty.dutyName)
                yield("/rotation auto")
                yield("/rotation settings aoetype 2")
                yield("/wait 10")
                while GetCharacterCondition(34) or GetCharacterCondition(51) or GetCharacterCondition(56) do -- wait for duty to be finished
                    if GetCharacterCondition(2) and i > 4 then -- dead, not a dungeon
                        yield("/echo [WonderousTails] 死亡したため"..duty.dutyName.."の実行をスキップしました。")
                        repeat
                            yield("/wait 1")
                        until not GetCharacterCondition(2)
                        LeaveDuty()
                        break
                    end
                    yield("/wait 1")
                end
                yield("/echo [WonderousTails] 終了（"..(i+1).."マス目）："..duty.dutyName)
                yield("/wait 3")
            else
                if duty.dutyName ~= nil then
                    yield("/echo 本スクリプトでは対応していないID、またはレイドです。 （"..(i+1).."マス目）："..duty.dutyName)
                    LogInfo("[WonderousTails] 本スクリプトでは対応していないID、またはレイドです。 （"..(i+1).."マス目）："..duty.dutyName)
                else
                    yield("/echo 本スクリプトでは対応していないID、またはレイドです。 （"..(i+1).."マス目）：")
                    LogInfo("[WonderousTails] 本スクリプトでは対応していないID、またはレイドです。 （"..(i+1).."マス目）：")
                end
            end
        end
    end
end

yield("/rotation settings aoetype 2")
yield("/echo 実行可能な空想帳のマスをすべて完了しました。 <se.3>")