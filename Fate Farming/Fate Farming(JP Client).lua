--[[

********************************************************************************
*                                Fate Farming                                  *
*                               Version 2.21.11                                 *
********************************************************************************

Created by: pot0to (https://ko-fi.com/pot0to)
Contributors: Prawellp, Mavi, Allison
State Machine Diagram: https://github.com/pot0to/pot0to-SND-Scripts/blob/main/FateFarmingStateMachine.drawio.png

    -> 2.21.11  Added 1s wait after mount so you're firmly on the mount. Seems
                    like some languages like Chinese execute log and echo
                    messages faster than English, causing the next Pathfind step
                    to happen too fast, before you are properly mounted, while
                    you are in the middle of the jump. This forces vnav to give
                    you a walking path, instead of a flying path, so you
                    sometimes get stuck.
    -> 2.21.10  Fix call to vbmai preset
    -> 2.21.9   By Allison
                Added priority for checking distance to FATE accounting for a
                    possible lower distance if you teleported.
                Added FatePriority Setting. Default works the same as before 
                    but with new check from above. 
                    Progress -> Bonus -> Time Left -> Distance
                Added setting for if you should wait at the Aetheryte when no 
                    FATE is found. If you disable, you wait where the FATE 
                    finished.
                Added MinWait setting because sometimes 3 seconds felt to long.
                Changed name of WaitUpTo to match MinWait.
                Added check to disable targeting with VBM if you are using RSR
                    for the rotation plugin.
                Small adjustment to wait time after choosing nextFate, results
                    in landing further from center of fates upon approach.
                New extra checks in movement to prevent cast cancelling.
                May have messed something up when pushed out of the fate.
                Fixed typo with "should it to Turn" -> "should it do Turn"
        
********************************************************************************
*                               Required Plugins                               *
********************************************************************************

Plugins that are needed for it to work:

    -> Something Need Doing [Expanded Edition] : (Main Plugin for everything to work)   https://puni.sh/api/repository/croizat
    -> VNavmesh :   (for Pathing/Moving)    https://puni.sh/api/repository/veyn
    -> Some form of rotation plugin for attacking enemies. Options are:
        -> RotationSolver Reborn: https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json       
        -> BossMod Reborn: https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
        -> Veyn's BossMod: https://puni.sh/api/repository/veyn
        -> Wrath Combo: https://love.puni.sh/ment.json
    -> Some form of AI dodging. Options are: 
        -> BossMod Reborn: https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
        -> Veyn's BossMod: https://puni.sh/api/repository/veyn
    -> TextAdvance: (for interacting with Fate NPCs) https://github.com/NightmareXIV/MyDalamudPlugins/raw/main/pluginmaster.json
    -> Teleporter :  (for Teleporting to aetherytes [teleport][Exchange][Retainers])
    -> Lifestream :  (for changing Instances [ChangeInstance][Exchange]) https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json

********************************************************************************
*                                Optional Plugins                              *
********************************************************************************

This Plugins are Optional and not needed unless you have it enabled in the settings:

    -> AutoRetainer : (for Retainers [Retainers])   https://love.puni.sh/ment.json
    -> Deliveroo : (for gc turn ins [TurnIn])   https://plugins.carvel.li/
    -> YesAlready : (for extracting materia)

--------------------------------------------------------------------------------------------------------------------------------------------------------------
]]

--#region Settings

--[[
********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

--Pre Fate Settings
Food                                = ""            --Leave "" Blank if you don't want to use any food. If its HQ include <hq> next to the name "Baked Eggplant <hq>"
Potion                              = ""            --Leave "" Blank if you don't want to use any potions.
ShouldSummonChocobo                 = true          --Summon chocobo?
    ResummonChocoboTimeLeft         = 3 * 60        --Resummons chocobo if there's less than this many seconds left on the timer, so it doesn't disappear on you in the middle of a fate.
    ChocoboStance                   = "ヒーラースタンス"             --Options: 追従/フリーファイト/ディフェンダースタンス/ヒーラースタンス/アタッカースタンス
    ShouldAutoBuyGysahlGreens       = false          --Automatically buys a 99 stack of Gysahl Greens from the Limsa gil vendor if you're out
MountToUse                          = "ウィング・オブ・ディザスター"   --The mount you'd like to use when flying between fates (ルーレット使用の場合は"")
FatePriority                        = {"DistanceTeleport", "Progress", "DistanceTeleport", "Bonus", "TimeLeft", "Distance"}

--Fate Combat Settings
CompletionToIgnoreFate              = 80            --If the fate has more than this much progress already, skip it
MinTimeLeftToIgnoreFate             = 3*60          --If the fate has less than this many seconds left on the timer, skip it
CompletionToJoinBossFate            = 0             --If the boss fate has less than this much progress, skip it (used to avoid soloing bosses)
    CompletionToJoinSpecialBossFates = 20           --For the Special Fates like the Serpentlord Seethes or Mascot Murder
    ClassForBossFates               = ""            --If you want to use a different class for boss fates, set this to the 3 letter abbreviation
                                                        --for the class. Ex: "PLD"
JoinCollectionsFates                = false         --Set to false if you never want to do collections fates
BonusFatesOnly                      = false         --If true, will only do bonus fates and ignore everything else

MeleeDist                           = 2.5           --Distance for melee. Melee attacks (auto attacks) max distance is 2.59y, 2.60 is "target out of range"
RangedDist                          = 20            --Distance for ranged. Ranged attacks and spells max distance to be usable is 25.49y, 25.5 is "target out of range"=

RotationPlugin                      = "RSR"         --Options: RSR/BMR/VBM/Wrath/None
    RSRAoeType                      = "Cleave"      --Options: Cleave/Full/Off

    -- For BMR/VBM/Wrath
    RotationSingleTargetPreset      = ""            --Preset name with single target strategies (for forlorns). TURN OFF AUTOMATIC TARGETING FOR THIS PRESET
    RotationAoePreset               = ""            --Preset with AOE + Buff strategies.
    RotationHoldBuffPreset          = ""            --Preset to hold 2min burst when progress gets to seleted %
    PercentageToHoldBuff            = 65            --Ideally you'll want to make full use of your buffs, higher than 70% will still waste a few seconds if progress is too fast.
DodgingPlugin                       = "BMR"         --Options: BMR/VBM/None. If your RotationPlugin is BMR/VBM, then this will be overriden

IgnoreForlorns                      = false
    IgnoreBigForlornOnly            = false

--Post Fate Settings
MinWait                             = 1             --Min number of seconds it should wait until mounting up for next fate.
MaxWait                             = 3            --Max number of seconds it should wait until mounting up for next fate.
                                                        --Actual wait time will be a randomly generated number between MinWait and MaxWait.
DownTimeWaitAtNearestAetheryte      = false         --When waiting for fates to pop, should you fly to the nearest Aetheryte and wait there?
EnableChangeInstance                = true          --should it Change Instance when there is no Fate (only works on DT fates)
    WaitIfBonusBuff                 = true          --Don't change instances if you have the Twist of Fate bonus buff
    NumberOfInstances               = 2
ShouldExchangeBicolorGemstones      = true         --Should it exchange Bicolor Gemstone Vouchers?
    ItemToPurchase                  = "バイカラージェム納品証【黄金】"        -- Old Sharlayan for "Bicolor Gemstone Voucher" and Solution Nine for "Turali Bicolor Gemstone Voucher"
SelfRepair                          = true          --if false, will go to Limsa mender
    RepairAmount                    = 20            --the amount it needs to drop before Repairing (set it to 0 if you don't want it to repair)
    ShouldAutoBuyDarkMatter         = false         --Automatically buys a 99 stack of Grade 8 Dark Matter from the Limsa gil vendor if you're out
ShouldExtractMateria                = true          --should it Extract Materia
Retainers                           = true          --should it do Retainers
ShouldGrandCompanyTurnIn            = false         --should it do Turn ins at the GC (requires Deliveroo)
    InventorySlotsLeft              = 5             --how much inventory space before turning in

Echo                                = "None"        --Options: All/Gems/None

CompanionScriptMode                 = true          --Set to true if you are using the fate script with a companion script (such as the Atma Farmer)

FatePriority                        = "Bonus"    --Distance (default pot0to "")
TradeGemCount                       = 1501

--#endregion Settings

--[[
********************************************************************************
*           Code: Don't touch this unless you know what you're doing           *
********************************************************************************
]]

--#region Plugin Checks and Setting Init

if not HasPlugin("vnavmesh") then
    yield("/echo [FATE] Please install vnavmesh")
end

if not HasPlugin("BossMod") and not HasPlugin("BossModReborn") then
    yield("/echo [FATE] Please install an AI dodging plugin, either Veyn's BossMod or BossMod Reborn")
end

if not HasPlugin("TextAdvance") then
    yield("/echo [FATE] Please install TextAdvance")
end

if EnableChangeInstance == true  then
    if HasPlugin("Lifestream") == false then
        yield("/echo [FATE] Please install Lifestream or Disable ChangeInstance in the settings")
    end
end
if Retainers then
    if not HasPlugin("AutoRetainer") then
        yield("/echo [FATE] Please install AutoRetainer")
    end
end
if ShouldGrandCompanyTurnIn then
    if not HasPlugin("Deliveroo") then
        ShouldGrandCompanyTurnIn = false
        yield("/echo [FATE] Please install Deliveroo")
    end
end
if ShouldExtractMateria then
    if HasPlugin("YesAlready") == false then
        yield("/echo [FATE] Please install YesAlready")
    end
end
if DodgingPlugin == "None" then
    -- do nothing
elseif RotationPlugin == "BMR" and DodgingPlugin ~= "BMR" then
    DodgingPlugin = "BMR"
elseif RotationPlugin == "VBM" and DodgingPlugin ~= "VBM"  then
    DodgingPlugin = "VBM"
end

yield("/at y")

--snd property
function setSNDProperty(propertyName, value)
    local currentValue = GetSNDProperty(propertyName)
    if currentValue ~= value then
        SetSNDProperty(propertyName, tostring(value))
        LogInfo("[SetSNDProperty] " .. propertyName .. " set to " .. tostring(value))
    end
end

setSNDProperty("UseItemStructsVersion", true)
setSNDProperty("UseSNDTargeting", true)
setSNDProperty("StopMacroIfTargetNotFound", false)
setSNDProperty("StopMacroIfCantUseItem", false)
setSNDProperty("StopMacroIfItemNotFound", false)
setSNDProperty("StopMacroIfAddonNotFound", false)
setSNDProperty("StopMacroIfAddonNotVisible", false)

--#endregion Plugin Checks and Setting Init

--#region Data

CharacterCondition = {
    dead=2,
    mounted=4,
    inCombat=26,
    casting=27,
    occupiedInEvent=31,
    occupiedInQuestEvent=32,
    occupied=33,
    boundByDuty34=34,
    occupiedMateriaExtractionAndRepair=39,
    betweenAreas=45,
    jumping48=48,
    jumping61=61,
    occupiedSummoningBell=50,
    betweenAreasForDuty=51,
    boundByDuty56=56,
    mounting57=57,
    mounting64=64,
    beingMoved=70,
    flying=77
}

ClassList =
{
    gla = { classId=1, className="剣術士",          isMelee=true,  isTank=true },
    pgl = { classId=2, className="格闘士",          isMelee=true,  isTank=false },
    mrd = { classId=3, className="斧術士",          isMelee=true,  isTank=true },
    lnc = { classId=4, className="槍術士",          isMelee=true,  isTank=false },
    arc = { classId=5, className="弓術士",          isMelee=false, isTank=false },
    cnj = { classId=6, className="幻術士",          isMelee=false, isTank=false },
    thm = { classId=7, className="呪術士",          isMelee=false, isTank=false },
    pld = { classId=19, className="ナイト",         isMelee=true,  isTank=true },
    mnk = { classId=20, className="モンク",         isMelee=true,  isTank=false },
    war = { classId=21, className="戦士",           isMelee=true,  isTank=true },
    drg = { classId=22, className="竜騎士",         isMelee=true,  isTank=false },
    brd = { classId=23, className="吟遊詩人",       isMelee=false, isTank=false },
    whm = { classId=24, className="白魔道士",       isMelee=false, isTank=false },
    blm = { classId=25, className="黒魔道士",       isMelee=false, isTank=false },
    acn = { classId=26, className="巴術士",         isMelee=false, isTank=false },
    smn = { classId=27, className="召喚士",         isMelee=false, isTank=false },
    sch = { classId=28, className="学者",           isMelee=false, isTank=false },
    rog = { classId=29, className="双剣士",         isMelee=true,  isTank=false },
    nin = { classId=30, className="忍者",           isMelee=true,  isTank=false },
    mch = { classId=31, className="機工士",         isMelee=false, isTank=false},
    drk = { classId=32, className="暗黒騎士",       isMelee=true,  isTank=true },
    ast = { classId=33, className="占星術師",       isMelee=false, isTank=false },
    sam = { classId=34, className="侍",             isMelee=true,  isTank=false },
    rdm = { classId=35, className="赤魔道士",       isMelee=false, isTank=false },
    blu = { classId=36, className="青魔道士",       isMelee=false, isTank=false },
    gnb = { classId=37, className="ガンブレイカー", isMelee=true,  isTank=true },
    dnc = { classId=38, className="踊り子",         isMelee=false, isTank=false },
    rpr = { classId=39, className="リーパー",       isMelee=true,  isTank=false },
    sge = { classId=40, className="賢者",           isMelee=false, isTank=false },
    vpr = { classId=41, className="ヴァイパー",     isMelee=true,  isTank=false },
    pct = { classId=42, className="ピクトマンサー", isMelee=false, isTank=false }
}

BicolorExchangeData =
{
    {
        shopKeepName = "広域交易商 ガドフリッド",
        zoneName = "オールド・シャーレアン",
        zoneId = 962,
        aetheryteName = "オールド・シャーレアン",
        x=78, y=5, z=-37,
        shopItems =
        {
            { itemName = "ポートレート教材:オールド・シャーレアン1", itemIndex = 0, price = 600 },
            { itemName = "ポートレート教材:オールド・シャーレアン2", itemIndex = 1, price = 600 },
            { itemName = "シャーレアンディアデーマ", itemIndex = 2, price = 600 },
            { itemName = "オーケストリオン譜:知恵の水瓶", itemIndex = 3, price = 800 },
            { itemName = "オーケストリオン譜:知恵の巻貝", itemIndex = 4, price = 350 },
            { itemName = "オーケストリオン譜:いつの日かきっと", itemIndex = 5, price = 350 },
            { itemName = "シャーレアン・ランプポスト", itemIndex = 6, price = 100 },
            { itemName = "グリーナーズ・ナップサック", itemIndex = 7, price = 100 },
            { itemName = "バイカラージェム納品証", itemIndex = 8, price = 100 },
            { itemName = "オウヴィボスの乳", itemIndex = 9, price = 2 },
            { itemName = "ハンサの笹身", itemIndex = 10, price = 2 },
            { itemName = "ヤーコウの肩肉", itemIndex = 11, price = 2 },
            { itemName = "ブレスト・オブ・エルピス", itemIndex = 12, price = 2 },
            { itemName = "エッグ・オブ・エルピス", itemIndex = 13, price = 2 },
            { itemName = "アームラ", itemIndex = 14, price = 2 },
            { itemName = "デュラミスシャード", itemIndex = 15, price = 2 },
            { itemName = "アルマスティの毛", itemIndex = 16, price = 2 },
            { itemName = "ガジャの粗皮", itemIndex = 17, price = 2 },
            { itemName = "サイガの粗皮", itemIndex = 18, price = 2 },
            { itemName = "クンビーラの粗皮", itemIndex = 19, price = 2 },
            { itemName = "オピオタウロスの粗皮", itemIndex = 20, price = 2 },
            { itemName = "クンビーラの粗皮", itemIndex = 21, price = 2 },
            { itemName = "ベルカナの樹液", itemIndex = 22, price = 2 },
            { itemName = "ダイナマイトの灰", itemIndex = 23, price = 2 },
            { itemName = "ルナテンダーの花", itemIndex = 24, price = 2 },
            { itemName = "ムースの肉", itemIndex = 25, price = 2 },
            { itemName = "ペタルダの鱗粉", itemIndex = 26, price = 2 },
        }
    },
    {
        shopKeepName = "広域交易商 ベリル",
        zoneName = "ソリューション・ナイン",
        zoneId = 1186,
        aetheryteName = "ソリューション・ナイン",
        x=-198.47, y=0.92, z=-6.95,
        miniAethernet = {
            name = "ネクサスアーケード",
            x=-157.74, y=0.29, z=17.43
        },
        shopItems =
        {
            { itemName = "ポートレート教材:ソリューション・ナイン1", itemIndex = 0, price = 600 },
            { itemName = "ポートレート教材:ソリューション・ナイン2", itemIndex = 1, price = 600 },
            { itemName = "ネオンパラソル", itemIndex = 2, price = 500 },
            { itemName = "オーケストリオン譜:星なき摩天楼", itemIndex = 3, price = 450 },
            { itemName = "ナインズ・ベンディングマシン", itemIndex = 4, price = 150 },
            { itemName = "ホロディスプレイ", itemIndex = 5, price = 200 },
            { itemName = "バイカラージェム納品証【黄金】", itemIndex = 6, price = 100 },
            { itemName = "アルパカのフィレ肉", itemIndex = 7, price = 2 },
            { itemName = "スワンプモンクのモモ肉", itemIndex = 8, price = 2 },
            { itemName = "ロネークの肩肉", itemIndex = 9, price = 2 },
            { itemName = "メガマゲイの球茎", itemIndex = 10, price = 2 },
            { itemName = "ブランチベアラーの果実", itemIndex = 11, price = 2 },
            { itemName = "ノパルテンダーのトゥナ", itemIndex = 12, price = 2 },
            { itemName = "ロネークの獣毛", itemIndex = 13, price = 2 },
            { itemName = "シルバリオの粗皮", itemIndex = 14, price = 2 },
            { itemName = "ハンマーヘッドダイルの粗皮", itemIndex = 15, price = 2 },
            { itemName = "ブラーシャの粗皮", itemIndex = 16, price = 2 },
            { itemName = "ゴンフォテリウムの粗皮", itemIndex = 17, price = 2 },
            { itemName = "ガルガンチュアの粗皮", itemIndex = 18, price = 2 },
            { itemName = "チャイチャの刃爪", itemIndex = 19, price = 2 },
            { itemName = "ポイズンフロッグの粘液", itemIndex = 20, price = 2 },
            { itemName = "アックスビークの翼膜", itemIndex = 21, price = 2 },
            { itemName = "レッサーアポリオンの甲殻", itemIndex = 22, price = 2 },
            { itemName = "タンブルクラブの枯草", itemIndex = 23, price = 2 },
        }
    }
}

FatesData = {
    {
        zoneName = "中央ラノシア",
        zoneId = 134,
        fatesList = {
            collectionsFates= {},
            otherNpcFates= {
                { fateName="海軍式の通過儀礼" , npcName="イエロージャケット訓練教官" },
                { fateName="デネペール関門防衛訓練", npcName="鬼のデューンファル甲軍曹"},
                { fateName="上には上がある", npcName="助けを求める農夫"},
                { fateName="果てなきモグラ叩き", npcName="困り果てた農夫" }
            },
            fatesWithContinuations = {
                "追う者と追われる者",
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "低地ラノシア",
        zoneId = 135,
        fatesList = {
            collectionsFates= {},
            otherNpcFates= {
                { fateName="迷惑千万「密航のアクトシュティム」" , npcName="熟練の警備兵" },
                { fateName="小麦粉戦争" , npcName="助けを求める風車番" },
                { fateName="俺たちゃ海賊" , npcName="イエロージャケット陸戦兵" },
                { fateName="危ない野良仕事", npcName="怒りに燃える農夫" }
            },
            fatesWithContinuations = {
                "シダーウッドの戦い",
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "東ラノシア",
        zoneId = 137,
        fatesList = {
            collectionsFates= {
                { fateName="コリブリたちの食卓" , npcName="虹蝶貝を探す女" }
            },
            otherNpcFates= {
                { fateName="新鮮な生肉" , npcName="リムサ・ロミンサの商人" },
                { fateName="蜜蜂誘う甘い蜜" , npcName="ワインポートの農夫" }
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "西ラノシア",
        zoneId = 138,
        fatesList = {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "高地ラノシア",
        zoneId = 139,
        fatesList = {
            collectionsFates= {},
            otherNpcFates= {
                { fateName="悲運の傭兵「美男のブガージャ」" , npcName="黒渦団甲軍曹" },
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "中央ザナラーン",
        zoneId = 141,
        fatesList = {
            collectionsFates= {
                { fateName="キヴロン家の住人" , npcName="途方に暮れた商人" },
                { fateName="サボテンサラダ", npcName="腹を減らした少女"},
            },
            otherNpcFates= {
                { fateName="底無の酒豪「飲んべえググルン」", npcName="コッファー＆コフィンの用心棒" }, --22 ボス
                { fateName="粗野な勝負師「無頼のグリスヒルド」", npcName="敗北した冒険者" }, --22 ボス
                { fateName="殺人魚スポーニングキラー", npcName="クリス少年" }
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "東ザナラーン",
        zoneId = 145,
        fatesList = {
            collectionsFates= {},
            otherNpcFates= {
                { fateName="ハイブリッジの死闘：市民奪還作戦" , npcName="銅刃団の衛兵" } --22 ボス
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "南ザナラーン",
        zoneId = 146,
        fatesList = {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        },
        flying = false
    },
    {
        zoneName = "外地ラノシア",
        zoneId = 180,
        fatesList = {
            collectionsFates= {},
            otherNpcFates= {
                { fateName="試掘地強襲作戦", npcName="黒渦団二等甲兵"},
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        },
        flying = false
    },
    {
        zoneName = "クルザス中央高地",
        zoneId = 155,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            specialFates = {
                "伝説の魔獣「ベヒーモス」", --ベヒーモス
                "手負いの魔獣「ベヒーモス」" --ベヒーモス
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "クルザス西部高地",
        zoneId = 397,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "モードゥナ",
        zoneId = 156,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "アバラシア雲海",
        zoneId = 401,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "アジス・ラー",
        zoneId = 402,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "高地ドラヴァニア",
        zoneId = 398,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            specialFates = {
                "爆着の甲竜「タラスク」" --coeurlregina
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "イディルシャイア",
        zoneId=399,
        tpZoneId = 478,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "ドラヴァニア雲海",
        zoneId=400,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "ギラバニア辺境地帯",
        zoneId = 612,
        fatesList= {
            collectionsFates= {
                { fateName="血をわけた姉妹", npcName="ウィルラの職人" },
                { fateName="新石器時代", npcName="メ族の少女" },
            },
            otherNpcFates= {
                { fateName="ブートキャンプ：兵卒編", npcName="フレーラク少甲佐" },
                { fateName="混交林の大熊「シャープアイ・グリズリー」", npcName="不滅隊の斥候" },
                { fateName="果しなき河よ我を誘え", npcName="黒渦団の伝令" },
                { fateName="辺境パトロール", npcName="アラミゴ解放軍の闘士" },
                { fateName="続・辺境パトロール", npcName="アラミゴ解放軍の闘士" }
            },
            fatesWithContinuations = {
                "ブートキャンプ：兵卒編",
                "ブートキャンプ：下士編",
                "暴走の巨象「ランページング・マーリド」"
            },
            specialFates = {
                "樹人の長老「キルニス」" --アチーブメント
            },
            blacklistedFates= {
                "辺境パトロール", --escort
                "続・辺境パトロール" --escort
            }
        }
    },
    {
        zoneName = "ギラバニア山岳地帯",
        zoneId = 620,
        fatesList= {
            collectionsFates= {
                { fateName="グリフィンの物語", npcName="流れの酒保商人" }
            },
            otherNpcFates= {
                { fateName="完全菜食主義", npcName="菜食のミミルン" },
                { fateName="血の収穫", npcName="屈強な農夫" },
                { fateName="死ぬのは奴らだ", npcName="アラガーナの住人" },
                { fateName="チャプリの勇敢", npcName="負傷した闘士" },
                { fateName="ジャ族の戦士", npcName="陽炎のジャ・ナジャク" },
                { fateName="待ってたんだ！", npcName="コールドハースの住人" }
            },
            fatesWithContinuations = {
                "ジャ族の戦士"
            },
            specialFates = {
                "豪腕の襲撃者「フンババ」" --アチーブメント
            },
            blacklistedFates= {
                "完全菜食主義", --escort
                "暴走最終兵器「リーサルウェポン」" --escort
            }
        }
    },
    {
        zoneName = "ギラバニア湖畔地帯",
        zoneId = 621,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {
                "ナンカ移動時代"
            },
            specialFates = {
                "白色大顔面「トール・マウンテン」", --アチーブメント
                "伝説の雷馬「イクシオン」"
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "紅玉海",
        zoneId = 613,
        fatesList= {
            collectionsFates= {
                { fateName="赤い珊瑚礁", npcName="おっとりした海賊" },
                { fateName="The Coral High Ground", npcName="Busy Beachcomber" }
            },
            otherNpcFates= {
                { fateName="無礼なる牛鬼「ジンリンキ」", npcName="大弱りの海賊" },
                { fateName="紅甲羅あばれ凧", npcName="負傷した海賊" },
                { fateName="紅甲羅千両首", npcName="略奪された碧甲羅" },
                { fateName="兵法修行人「一刀のセンバン」", npcName="海賊衆の少女" }
            },
            fatesWithContinuations = {
                "無礼なる牛鬼「ジンリンキ」",
                "されど修羅ゆく君は"
            },
            specialFates = {
                "夢見る大名「ダイミョウユメミ」" --アチーブメント
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "ヤンサ",
        zoneId = 614,
        fatesList= {
            collectionsFates= {
                { fateName="稲生物怪録", npcName="困り果てた農婦" },
                { fateName="ベニツノの卵は誰のもの", npcName="ナマイ村の農夫" },
                { fateName="ギンコの願い", npcName="ギンコ" }
            },
            otherNpcFates= {
                { fateName="狂える案山子「クエビコ」", npcName="一刀のセンバン" },
                { fateName="人狼：紅い足跡", npcName="仁徳のガエイ" },
                { fateName="キンコの願い", npcName="キンコ" },
                { fateName="その名はミクズメ", npcName="ミクズメ" }
            },
            specialFates = {
                "逆心の巨兵「キドウ丸」", --アチーブメント
                "九尾の妖狐「玉藻御前」"
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "アジムステップ",
        zoneId = 622,
        fatesList= {
            collectionsFates= {
                { fateName="ダタクの旅：羊乳搾り", npcName="アルタニ" }
            },
            otherNpcFates= {
                { fateName="時には懺悔を", npcName="オロニル族の若者" },
                { fateName="家路につく牛飼いの少女", npcName="オルクンド族の牛飼い" },
                { fateName="つかのまの悪夢", npcName="モル族の羊飼い" },
                { fateName="沈黙の制裁", npcName="ケスティル族の商人" }
            },
            fatesWithContinuations = {
                "つかのまの悪夢",
                "よみがえる悪夢"
            },
            specialFates = {
                "長牙の圧殺者「マヒシャスラ」" --アチーブメント
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "レイクランド",
        zoneId = 813,
        fatesList= {
            collectionsFates= {
                { fateName="木こり歌の事", npcName="レイクランドの木こり" }
            },
            otherNpcFates= {
                { fateName="紫葉団との戦い：卑劣な罠", npcName="行商人らしき男" }, --24 タワーディフェンス
                { fateName="汚れた血め！", npcName="ジョッブ砦の衛兵" } --24 タワーディフェンス
            },
            fatesWithContinuations = {
                "ハイエボリューション"
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "コルシア島",
        zoneId = 814,
        fatesList= {
            collectionsFates= {
                { fateName="紫葉団との戦い：卑劣な罠", npcName="トルー一家の技師" }
            },
            otherNpcFates= {},
            fatesWithContinuations = {},
            specialFates = {
                "激闘フォーミダブル：切り札起動" -- フォーミダブル（特殊FATE）
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "アム・アレーン",
        zoneId = 815,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {
                "トルバNo. 1" -- 敵へのルートが困難
            }
        }
    },
    {
        zoneName = "イル・メグ",
        zoneId = 816,
        fatesList= {
            collectionsFates= {
                { fateName="ピクシーテイル：黄金色の花蜜", npcName="花蜜探しのピクシー" }
            },
            otherNpcFates= {
                { fateName="ピクシーテイル：魔物包囲網", npcName="花蜜探しのピクシー" }
            },
            fatesWithContinuations = {},
            blacklistedFates= {
                "がんばれ、ローズベアーズ"}
        }
    },
    {
        zoneName = "ラケティカ大森林",
        zoneId = 817,
        fatesList= {
            collectionsFates= {
                { fateName="ピンク・フラミンゴ", npcName="夜の民の導師" },
                { fateName="ミャルナの巡察：矢の補充", npcName="弓音のミャルナ" },
                { fateName="伝説が生まれる", npcName="ファノヴの護人" }
            },
            otherNpcFates= {
                { fateName="キルメとサルメ", npcName="血槍のキルメ" }, --24 タワーディフェンス
                { fateName="死相の陸鳥「ケライノー」", npcName="ファノヴの狩人" } --22 ボス
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "テンペスト",
        zoneId = 818,
        fatesList= {
            collectionsFates= {
                { fateName="厄災のアルケオタニア：紅血珊瑚の収集", npcName="テウスィー・オーン" },
                { fateName="パールは永遠の輝き", npcName="オンド族の漁師" }
            },
            otherNpcFates= {
                { fateName="厄災のアルケオタニア：追跡開始", npcName="テウスィー・オーン" }, --23 通常
                { fateName="厄災のアルケオタニア：ズムスィー登場", npcName="テウスィー・オーン" }, --23 通常
                { fateName="厄災のアルケオタニア：テウスィー防衛", npcName="テウスィー・オーン" }, --24 タワーディフェンス
                { fateName="厄災のアルケオタニア：テウスィー護衛", npcName="テウスィー・オーン" }, --エスコート
                { fateName="厄災のアルケオタニア：決戦の下準備", npcName="テウスィー・オーン" } --24 タワーディフェンス
            },
            fatesWithContinuations = {},
            specialFates = {
                "厄災のアルケオタニア：深海の討伐戦" -- アルケオタニア（特殊FATE）
            },
            blacklistedFates= {
                "黒風海産ヒドロ虫類", -- FATE範囲内に入らず、開始しないことがある
                "貝汁物語", --エスコート
                "厄災のアルケオタニア：テウスィー護衛" --エスコート
            }
        }
    },
    {
        zoneName = "ラヴィリンソス",
        zoneId = 956,
        fatesList= {
            collectionsFates= {
                { fateName="風の十四方位", npcName="困り果てた研究員" },
                { fateName="天然由来保湿成分", npcName="美肌の研究員" }
            },
            otherNpcFates= {
                { fateName="羊飼いの暮らし", npcName="種畜研究所の獣牧士" } --24 タワーディフェンス
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "サベネア島",
        zoneId = 957,
        fatesList= {
            collectionsFates= {
                { fateName="香りの錬金術師：危険な花摘み", npcName="調香のサジャバート" }
            },
            otherNpcFates= {
                { fateName="少年と海", npcName="漁師の息子" } --24 タワーディフェンス
            },
            fatesWithContinuations = {},
            specialFates = {
                "ムリガ信仰：偽りの神" -- ダイヴァディーパ（特殊FATE）
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "ガレマルド",
        zoneId = 958,
        fatesList= {
            collectionsFates= {
                { fateName="回収は一刻を争う！", npcName="難民の魔導技師" }
            },
            otherNpcFates= {
                { fateName="魔導技師の帰郷：ファースト・ステップ", npcName="ケルトロナ少甲士" }, --22 ボス
                { fateName="魔導技師の帰郷：ファースト・イン・トラップ", npcName="エルブレノ" }, --24 タワーディフェンス
                { fateName="魔導技師の帰郷：ビフォー・コンタクト", npcName="ケルトロナ少甲士" }, --23 通常
                { fateName="霜の巨人たち", npcName="生き残りの難民" } --24 タワーディフェンス
            },
            fatesWithContinuations = {
                { fateName="魔導技師の帰郷：ビフォー・コンタクト", continuationIsBoss=true }
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "嘆きの海",
        zoneId = 959,
        fatesList= {
            collectionsFates= {
                { fateName="What a Thrill", npcName="Thrillingway" }
            },
            otherNpcFates= {
                { fateName="嘆きの白兎：ばくばく大爆発", npcName="ウォリングウェイ" }, --24 タワーディフェンス
                { fateName="嘆きの白兎：だめだめ大暴走", npcName="フォリングウェイ" }, --23 通常
                { fateName="嘆きの白兎：むきむき大処分", npcName="フォリングウェイ" } --22 ボス
            },
            fatesWithContinuations = {},
            blacklistedFates= {
                "大海を隔てるがごとく", --斜面で見通しが悪く何もできず棒立ちする可能性が高い
            }
        }
    },
    {
        zoneName = "ウルティマ・トゥーレ",
        zoneId = 960,
        fatesList= {
            collectionsFates= {
                { fateName="カイのメモリーより：通信機拡張", npcName="N-6205" }
            },
            otherNpcFates= {
                { fateName="栄光の翼「アル・アイン」", npcName="アル・アインの友" }, --22 ボス
                { fateName="カイのメモリーより：N-6205防衛", npcName="N-6205"}, --24 タワーディフェンス
                { fateName="永遠の終わり", npcName="ミク・ネール" } --24 タワーディフェンス
            },
            fatesWithContinuations = {},
            specialFates = {
                "カイのメモリーより：侵略兵器の破壊" -- カイ（特殊FATE）
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "エルピス",
        zoneId = 961,
        fatesList= {
            collectionsFates= {
                { fateName="ソクレスへの弁明", npcName="植物担当の観察者" }
            },
            otherNpcFates= {
                { fateName="創造計画：エゴーケロス観察", npcName="深遠のメレトス" }, --23 通常
                { fateName="創造計画：斬新すぎたイデア", npcName="深遠のメレトス" }, --23 通常
                { fateName="死の鳥", npcName="モノセロスの観察者" }, --24 タワーディフェンス
            },
            fatesWithContinuations = {
                { fateName="創造計画：エゴーケロス観察", continuationIsBoss=true },
                { fateName="創造計画：斬新すぎたイデア", continuationIsBoss=true }
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "オルコ・パチャ",
        zoneId = 1187,
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {
                { fateName="ポゼッション", npcName="健脚のジーベリ" }, --23 通常
                { fateName="踊る山火「ラカクウルク」", npcName="健脚のジーベリ" }, --22 ボス
                { fateName="不死の人", npcName="墓参りのヨカフイ族" }, --23 通常
                { fateName="失われた山岳の都", npcName="遺跡守のヨカフイ族" }, --24 タワーディフェンス
                { fateName="コーヒーを巡る冒険", npcName="カピー農園の作業員" }, --24 タワーディフェンス
                { fateName="千年の孤独", npcName="チーワグー・サベラー" }, --23 通常
                { fateName="空飛ぶ鍋奉行「ペルペルイーター」", npcName="ペルペル族の旅商" }, --22 ボス
                { fateName="狼の家", npcName="ペルペル族の旅商" }  --23 通常
            },
            fatesWithContinuations = {
                { fateName="不死の人", continuationIsBoss=true },
                { fateName="千年の孤独", continuationIsBoss=true }
            },
            blacklistedFates= {
                "オンリー・ザ・ボム", -- なぜか行かない
                "狼の家", -- 同名NPCが、同一箇所に複数いるため
                "空飛ぶ鍋奉行「ペルペルイーター」" -- 同名NPCが、同一箇所に複数いるため
            }
        }
    },
    {
        zoneName="コザマル・カ",
        zoneId=1188,
        fatesList={
            collectionsFates={
                { fateName="落ち石拾い", npcName="モブリン族の採集人" },
                { fateName="人鳥細工", npcName="ハヌハヌ族の細工師" },
                
            },
            otherNpcFates= {
                { fateName="怪力の大食漢「マイティ・マイプ」", npcName="ハヌハヌ族の釣り人" }, --22 ボス
                { fateName="野性と葦", npcName="ハヌハヌ族の農夫" }, --23 通常
                { fateName="我々の貢物", npcName="ハヌハヌ族の巫女" }, --24 タワーディフェンス
                { fateName="奸臣、大寒心", npcName="ペルペル族の行商人" }, --24 タワーディフェンス
                { fateName="素晴らしき、キノコの世界", npcName="匠想いのバノブロク" }  --23 通常
            },
            fatesWithContinuations = {
                { fateName="素晴らしき、キノコの世界", continuationIsBoss=true }
            },
            blacklistedFates= {
                "奸臣、大寒心", -- 同名NPCが、同一箇所に複数いるため
                "落ち石拾い" -- 地形が複雑でスタックする可能性が高いため
            }
        }
    },
    {
        zoneName="ヤクテル樹海",
        zoneId=1189,
        fatesList= {
            collectionsFates= {
                { fateName="恐怖！キノコ魔物", npcName="フビゴ族の採集人" }
            },
            otherNpcFates= {
                { fateName="上段の突きを喰らうイブルク", npcName="シュバラール族の狩人" }, --23 通常
                { fateName="血濡れの爪「ミユールル」", npcName="シュバラール族の狩人" }, --22 ボス
                { fateName="ザ・デッドリーマンティス", npcName="シュバラール族の狩人" }, --23 通常
                { fateName="荒くれマムージャ襲撃編", npcName="ドプロ族の槍使い" }, --23 通常
                { fateName="秘薬を守る戦い", npcName="フビゴ族の荷運び人" }  --24 タワーディフェンス
            },
            fatesWithContinuations = {
                { fateName="上段の突きを喰らうイブルク", continuationIsBoss=false },
                { fateName="荒くれマムージャ襲撃", continuationIsBoss=true }
            },
            blacklistedFates= {
                "上段の突きを喰らうイブルク", -- 同名NPCが、同一箇所に複数いるため
                "血濡れの爪「ミユールル」", -- 同名NPCが、同一箇所に複数いるため
                "ザ・デッドリーマンティス" -- 同名NPCが、同一箇所に複数いるため
            }
        }
    },
    {
        zoneName="シャーローニ荒野",
        zoneId=1190,
        fatesList= {
            collectionsFates= {
                { fateName="毛狩りの季節", npcName="トナワータ族の採集人" },
                { fateName="トクローネ：狩猟の下準備", npcName="赤日のブルクバー" }
            },
            otherNpcFates= {
                { fateName="死せる悪漢「デッドマン・ダーテカ」", npcName="トナワータ族の労働者" }, --22 ボス
                { fateName="嘆きの猛進「ウィデキ」", npcName="ヘイザ・アロ族の男性" }, --22 ボス
                { fateName="ロネークと人の大地", npcName="ヘイザ・アロ族の女性" }, --23 通常
                { fateName="リバー・ランズ・スルー・イット", npcName="ヘイザ・アロ族の釣人" }, --24 タワーディフェンス
                { fateName="恐竜怪鳥の伝説", npcName="ペルペル族の行商人" }  --23 通常
            },
            fatesWithContinuations = {
                { fateName="トクローネ：狩猟の下準備", continuationIsBoss=false }
            },
            specialFates = {
                "トクローネ：荒野の死闘" -- トクローネ（特殊FATE）
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName="ヘリテージファウンド",
        zoneId=1191,
        fatesList= {
            collectionsFates= {
                { fateName="薬屋のひと仕事", npcName="農務役のトナワータ族" },
                { fateName="人生がときめく片づけの技法", npcName="凛とした拾得人" }
            },
            otherNpcFates= {
                { fateName="ブロークンボットダイアリー", npcName="駆け出しの駆除人" }, --23 通常
                { fateName="逃走テレメトリー", npcName="駆け出しの駆除人" }, --23 通常
                { fateName="人狼伝説", npcName="危機に瀕した駆除人" }, --23 通常
                { fateName="気まぐれロボット", npcName="途方に暮れた拾得人" }, --23 通常
                { fateName="巨獣めざめる", npcName="ドリフトダウンズの拾得人" }, --23 通常
                { fateName="道を視る青年", npcName="怯えた配達人" }  --23 通常
            },
            fatesWithContinuations = {
--                { fateName="気まぐれロボット", continuationIsBoss=false }
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName="リビング・メモリー",
        zoneId=1192,
        fatesList= {
            collectionsFates= {
                { fateName="種の期限", npcName="アンロスト・セントリーGX" },
                { fateName="メモリーズ", npcName="アンロスト・セントリーGX" }
            },
            otherNpcFates= {
                { fateName="カナルタウンでやすらかに", npcName="アンロスト・セントリーGX" }, --24 タワーディフェンス
                { fateName="マイカ・ザ・ムー：出発進行", npcName="ファニー・パレードマスター" }  --23 通常
            },
            fatesWithContinuations =
            {
                { fateName="水の迷宮の夢", continuationIsBoss=ture },
                { fateName="マイカ・ザ・ムー：出発進行", continuationIsBoss=ture }
            },
            specialFates =
            {
                "マイカ・ザ・ムー：大団円"
            },
            blacklistedFates= {
            }
        }
    }
}

--#endregion Data

--#region Fate Functions
function IsCollectionsFate(fateName)
    for i, collectionsFate in ipairs(SelectedZone.fatesList.collectionsFates) do
        if collectionsFate.fateName == fateName then
            return true
        end
    end
    return false
end

function IsBossFate(fateId)
    local fateIcon = GetFateIconId(fateId)
    return fateIcon == 60722
end

function IsOtherNpcFate(fateName)
    for i, otherNpcFate in ipairs(SelectedZone.fatesList.otherNpcFates) do
        if otherNpcFate.fateName == fateName then
            return true
        end
    end
    return false
end

function IsSpecialFate(fateName)
    if SelectedZone.fatesList.specialFates == nil then
        return false
    end
    for i, specialFate in ipairs(SelectedZone.fatesList.specialFates) do
        if specialFate == fateName then
            return true
        end
    end
end

function IsBlacklistedFate(fateName)
    for i, blacklistedFate in ipairs(SelectedZone.fatesList.blacklistedFates) do
        if blacklistedFate == fateName then
            return true
        end
    end
    if not JoinCollectionsFates then
        for i, collectionsFate in ipairs(SelectedZone.fatesList.collectionsFates) do
            if collectionsFate.fateName == fateName then
                return true
            end
        end
    end
    return false
end

function GetFateNpcName(fateName)
    for i, fate in ipairs(SelectedZone.fatesList.otherNpcFates) do
        if fate.fateName == fateName then
            return fate.npcName
        end
    end
    for i, fate in ipairs(SelectedZone.fatesList.collectionsFates) do
        if fate.fateName == fateName then
            return fate.npcName
        end
    end
end

function IsFateActive(fateId)
    local activeFates = GetActiveFates()
    for i = 0, activeFates.Count-1 do
        if fateId == activeFates[i] then
            return true
        end
    end
    return false
end

function EorzeaTimeToUnixTime(eorzeaTime)
    return eorzeaTime/(144/7) -- 24h Eorzea Time equals 70min IRL
end

function SelectNextZone()
    local nextZone = nil
    local nextZoneId = GetZoneID()

    for i, zone in ipairs(FatesData) do
        if nextZoneId == zone.zoneId then
            nextZone = zone
        end
    end
    if nextZone == nil then
        yield("/echo [FATE] 現在のエリアは部分的にしかサポートされていません。NPC FATEのデータがありません。")
        nextZone = {
            zoneName = "",
            zoneId = nextZoneId,
            fatesList= {
                collectionsFates= {},
                otherNpcFates= {},
                bossFates= {},
                blacklistedFates= {},
                fatesWithContinuations = {}
            }
        }
    end

    nextZone.zoneName = nextZone.zoneName
    nextZone.aetheryteList = {}
    local aetheryteIds = GetAetherytesInZone(nextZone.zoneId)
    for i=0, aetheryteIds.Count-1 do
        local aetherytePos = GetAetheryteRawPos(aetheryteIds[i])
        local aetheryteTable = {
            aetheryteName = GetAetheryteName(aetheryteIds[i]),
            aetheryteId = aetheryteIds[i],
            x = aetherytePos.Item1,
            y = QueryMeshPointOnFloorY(aetherytePos.Item1, 1024, aetherytePos.Item2, true, 50),
            z = aetherytePos.Item2
        }
        table.insert(nextZone.aetheryteList, aetheryteTable)
    end

    if nextZone.flying == nil then
        nextZone.flying = true
    end

    return nextZone
end

--[[
    Selects the better fate based on the priority order defined in FatePriority.
    Default Priority order is "Progress" -> "DistanceTeleport" -> "Bonus" -> "TimeLeft" -> "Distance"
]]
function SelectNextFateHelper(tempFate, nextFate)
    --Check if WaitForBonusIfBonusBuff is true, and have eithe buff, then set BonusFatesOnlyTemp to true
    if BonusFatesOnly then
        if not tempFate.isBonusFate and nextFate ~= nil and nextFate.isBonusFate then
            return nextFate
        elseif tempFate.isBonusFate and (nextFate == nil or not nextFate.isBonusFate) then
            return tempFate
        elseif not tempFate.isBonusFate and (nextFate == nil or not nextFate.isBonusFate) then
            return nil
        end
        -- if both are bonus fates, go through the regular fate selection process
    end

    if tempFate.timeLeft < MinTimeLeftToIgnoreFate or tempFate.progress > CompletionToIgnoreFate then
        LogInfo("[FATE] Ignoring fate #"..tempFate.fateId.." due to insufficient time or high completion.")
        return nextFate
    elseif nextFate == nil then
                LogInfo("[FATE] Selecting #"..tempFate.fateId.." because no other options so far.")
                return tempFate
        elseif nextFate.timeLeft < MinTimeLeftToIgnoreFate or nextFate.progress > CompletionToIgnoreFate then
        LogInfo("[FATE] Ignoring fate #"..nextFate.fateId.." due to insufficient time or high completion.")
            return tempFate
            end

    -- Evaluate based on priority (Loop through list return first non-equal priority)
    for _, criteria in ipairs(FatePriority) do
        if criteria == "Progress" then
            LogInfo("[FATE] Comparing progress: "..tempFate.progress.." vs "..nextFate.progress)
            if tempFate.progress > nextFate.progress then return tempFate end
            if tempFate.progress < nextFate.progress then return nextFate end
        elseif criteria == "Bonus" then
            LogInfo("[FATE] Checking bonus status: "..tostring(tempFate.isBonusFate).." vs "..tostring(nextFate.isBonusFate))
            if tempFate.isBonusFate and not nextFate.isBonusFate then return tempFate end
            if nextFate.isBonusFate and not tempFate.isBonusFate then return nextFate end
        elseif criteria == "TimeLeft" then
            LogInfo("[FATE] Comparing time left: "..tempFate.timeLeft.." vs "..nextFate.timeLeft)
            if tempFate.timeLeft > nextFate.timeLeft then return tempFate end
            if tempFate.timeLeft < nextFate.timeLeft then return nextFate end
        elseif criteria == "Distance" then
            local tempDist = GetDistanceToPoint(tempFate.x, tempFate.y, tempFate.z)
            local nextDist = GetDistanceToPoint(nextFate.x, nextFate.y, nextFate.z)
            LogInfo("[FATE] Comparing distance: "..tempDist.." vs "..nextDist)
            if tempDist < nextDist then return tempFate end
            if tempDist > nextDist then return nextFate end
        elseif criteria == "DistanceTeleport" then
            local tempDist = GetDistanceToPointWithAetheryteTravel(tempFate.x, tempFate.y, tempFate.z)
            local nextDist = GetDistanceToPointWithAetheryteTravel(nextFate.x, nextFate.y, nextFate.z)
            LogInfo("[FATE] Comparing distance: "..tempDist.." vs "..nextDist)
            if tempDist < nextDist then return tempFate end
            if tempDist > nextDist then return nextFate end
        end
    end

    -- Fallback: Select fate with the lower ID
    LogInfo("[FATE] Selecting lower ID fate: "..tempFate.fateId.." vs "..nextFate.fateId)
    return (tempFate.fateId < nextFate.fateId) and tempFate or nextFate
end

function BuildFateTable(fateId)
    local fateTable = {
        fateId = fateId,
        fateName = GetFateName(fateId),
        progress = GetFateProgress(fateId),
        duration = GetFateDuration(fateId),
        startTime = GetFateStartTimeEpoch(fateId),
        x = GetFateLocationX(fateId),
        y = GetFateLocationY(fateId),
        z = GetFateLocationZ(fateId),
        isBonusFate = GetFateIsBonus(fateId),
    }
    fateTable.npcName = GetFateNpcName(fateTable.fateName)

    local currentTime = EorzeaTimeToUnixTime(GetCurrentEorzeaTimestamp())
    if fateTable.startTime == 0 then
        fateTable.timeLeft = 900
    else
        fateTable.timeElapsed = currentTime - fateTable.startTime
        fateTable.timeLeft = fateTable.duration - fateTable.timeElapsed
    end

    fateTable.isCollectionsFate = IsCollectionsFate(fateTable.fateName)
    fateTable.isBossFate = IsBossFate(fateTable.fateId)
    fateTable.isOtherNpcFate = IsOtherNpcFate(fateTable.fateName)
    fateTable.isSpecialFate = IsSpecialFate(fateTable.fateName)
    fateTable.isBlacklistedFate = IsBlacklistedFate(fateTable.fateName)

    fateTable.continuationIsBoss = false
    fateTable.hasContinuation = false
    for _, continuationFate in ipairs(SelectedZone.fatesList.fatesWithContinuations) do
        if fateTable.fateName == continuationFate.fateName then
            fateTable.hasContinuation = true
            fateTable.continuationIsBoss = continuationFate.continuationIsBoss
        end
    end

    return fateTable
end

--Gets the Location of the next Fate. Prioritizes anything with progress above 0, then by shortest time left
function SelectNextFate()
    local fates = GetActiveFates()
    if fates == nil then
        return
    end

    local nextFate = nil
    for i = 0, fates.Count-1 do
        local tempFate = BuildFateTable(fates[i])
        LogInfo("[FATE] Considering fate #"..tempFate.fateId.." "..tempFate.fateName)
        LogInfo("[FATE] Time left on fate #:"..tempFate.fateId..": "..math.floor(tempFate.timeLeft//60).."min, "..math.floor(tempFate.timeLeft%60).."s")
        
        if not (tempFate.x == 0 and tempFate.z == 0) then -- sometimes game doesn't send the correct coords
            if not tempFate.isBlacklistedFate then -- check fate is not blacklisted for any reason
                if tempFate.isBossFate then
                    if (tempFate.isSpecialFate and tempFate.progress >= CompletionToJoinSpecialBossFates) or
                        (not tempFate.isSpecialFate and tempFate.progress >= CompletionToJoinBossFate) then
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    else
                        LogInfo("[FATE] Skipping fate #"..tempFate.fateId.." "..tempFate.fateName.." due to boss fate with not enough progress.")
                    end
                elseif (tempFate.isOtherNpcFate or tempFate.isCollectionsFate) and tempFate.startTime == 0 then
                    if nextFate == nil then -- pick this if there's nothing else
                        nextFate = tempFate
                    elseif tempFate.isBonusFate then
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    elseif nextFate.startTime == 0 then -- both fates are unopened npc fates
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    end
                elseif tempFate.duration ~= 0 then -- else is normal fate. avoid unlisted talk to npc fates
                    nextFate = SelectNextFateHelper(tempFate, nextFate)
                end
                LogInfo("[FATE] Finished considering fate #"..tempFate.fateId.." "..tempFate.fateName)
            else
                LogInfo("[FATE] Skipping fate #"..tempFate.fateId.." "..tempFate.fateName.." due to blacklist.")
            end
        end
    end

    LogInfo("[FATE] Finished considering all fates")

    if nextFate == nil then
        LogInfo("[FATE] No eligible fates found.")
        if Echo == "All" then
            yield("/echo [FATE] No eligible fates found.")
        end
    else
        LogInfo("[FATE] Final selected fate #"..nextFate.fateId.." "..nextFate.fateName)
    end
    yield("/wait 0.211")

    return nextFate
end

function RandomAdjustCoordinates(x, y, z, maxDistance)
    local angle = math.random() * 2 * math.pi
    local x_adjust = maxDistance * math.random()
    local z_adjust = maxDistance * math.random()

    local randomX = x + (x_adjust * math.cos(angle))
    local randomY = y + maxDistance
    local randomZ = z + (z_adjust * math.sin(angle))

    return randomX, randomY, randomZ
end

--#endregion Fate Functions

--#region Movement Functions

function DistanceFromClosestAetheryteToPoint(x, y, z, teleportTimePenalty)
    local closestAetheryte = nil
    local closestTravelDistance = math.maxinteger
    for _, aetheryte in ipairs(SelectedZone.aetheryteList) do
        local distanceAetheryteToFate = DistanceBetween(aetheryte.x, y, aetheryte.z, x, y, z)
        local comparisonDistance = distanceAetheryteToFate + teleportTimePenalty
        LogInfo("[FATE] Distance via "..aetheryte.aetheryteName.." adjusted for tp penalty is "..tostring(comparisonDistance))

        if comparisonDistance < closestTravelDistance then
            LogInfo("[FATE] Updating closest aetheryte to "..aetheryte.aetheryteName)
            closestTravelDistance = comparisonDistance
            closestAetheryte = aetheryte
        end
    end

    return closestTravelDistance
end

function GetDistanceToPointWithAetheryteTravel(x, y, z)
    -- Get the direct flight distance (no aetheryte)
    local directFlightDistance = GetDistanceToPoint(x, y, z)
    LogInfo("[FATE] Direct flight distance is: " .. directFlightDistance)
    
    -- Get the distance to the closest aetheryte, including teleportation penalty
    local distanceToAetheryte = DistanceFromClosestAetheryteToPoint(x, y, z, 200)
    LogInfo("[FATE] Distance via closest Aetheryte is: " .. (distanceToAetheryte or "nil"))

    -- Return the minimum distance, either via direct flight or via the closest aetheryte travel
    if distanceToAetheryte == nil then
        return directFlightDistance
    else
        return math.min(directFlightDistance, distanceToAetheryte)
    end
end

function GetClosestAetheryte(x, y, z, teleportTimePenalty)
    local closestAetheryte = nil
    local closestTravelDistance = math.maxinteger
    for _, aetheryte in ipairs(SelectedZone.aetheryteList) do
        local distanceAetheryteToFate = DistanceBetween(aetheryte.x, y, aetheryte.z, x, y, z)
        local comparisonDistance = distanceAetheryteToFate + teleportTimePenalty
        LogInfo("[FATE] Distance via "..aetheryte.aetheryteName.." adjusted for tp penalty is "..tostring(comparisonDistance))

        if comparisonDistance < closestTravelDistance then
            LogInfo("[FATE] Updating closest aetheryte to "..aetheryte.aetheryteName)
            closestTravelDistance = comparisonDistance
            closestAetheryte = aetheryte
        end
    end

    return closestAetheryte
end

function GetClosestAetheryteToPoint(x, y, z, teleportTimePenalty)
    local directFlightDistance = GetDistanceToPoint(x, y, z)
    LogInfo("[FATE] Direct flight distance is: "..directFlightDistance)
    local closestAetheryte = GetClosestAetheryte(x, y, z, teleportTimePenalty)
    if closestAetheryte ~= nil then
        local aetheryteY = QueryMeshPointOnFloorY(closestAetheryte.x, y, closestAetheryte.z, true, 50)
        if aetheryteY == nil then
            aetheryteY = GetPlayerRawYPos()
        end
        local closestAetheryteDistance = DistanceBetween(x, y, z, closestAetheryte.x, aetheryteY, closestAetheryte.z) + teleportTimePenalty

        if closestAetheryteDistance < directFlightDistance then
            return closestAetheryte
        end
    end
    return nil
end

function TeleportToClosestAetheryteToFate(nextFate)
    local aetheryteForClosestFate = GetClosestAetheryteToPoint(nextFate.x, nextFate.y, nextFate.z, 200)
    if aetheryteForClosestFate ~=nil then
        TeleportTo(aetheryteForClosestFate.aetheryteName)
        return true
    end
    return false
end

function AcceptTeleportOfferLocation(destinationAetheryte)
    if IsAddonVisible("_NotificationTelepo") then
        local location = GetNodeText("_NotificationTelepo", 3, 4)
        yield("/callback _Notification true 0 16 "..location)
        yield("/wait 1")
    end

    if IsAddonVisible("SelectYesno") then
        local teleportOfferMessage = GetNodeText("SelectYesno", 15)
        if type(teleportOfferMessage) == "string" then
            local teleportOfferLocation = teleportOfferMessage:match("Accept Teleport to (.+)%?")
            if teleportOfferLocation ~= nil then
                if string.lower(teleportOfferLocation) == string.lower(destinationAetheryte) then
                    yield("/callback SelectYesno true 0") -- accept teleport
                    return
                else
                    LogInfo("Offer for "..teleportOfferLocation.." and destination "..destinationAetheryte.." are not the same. Declining teleport.")
                end
            end
            yield("/callback SelectYesno true 2") -- decline teleport
            return
        end
    end
end

function AcceptNPCFateOrRejectOtherYesno()
    if IsAddonVisible("SelectYesno") then
        local dialogBox = GetNodeText("SelectYesno", 15)
        if type(dialogBox) == "string" and dialogBox:find("このF.A.T.E.の推奨レベルは") then
            yield("/callback SelectYesno true 0") --accept fate
        else
            yield("/callback SelectYesno true 1") --decline all other boxes
        end
    end
end

function TeleportTo(aetheryteName)
    AcceptTeleportOfferLocation(aetheryteName)

    while EorzeaTimeToUnixTime(GetCurrentEorzeaTimestamp()) - LastTeleportTimeStamp < 5 do
        LogInfo("[FATE] Too soon since last teleport. Waiting...")
        yield("/wait 5.001")
    end

    yield("/tp "..aetheryteName)
    yield("/wait 1") -- wait for casting to begin
    while GetCharacterCondition(CharacterCondition.casting) do
        LogInfo("[FATE] Casting teleport...")
        yield("/wait 1")
    end
    yield("/wait 1") -- wait for that microsecond in between the cast finishing and the transition beginning
    while GetCharacterCondition(CharacterCondition.betweenAreas) do
        LogInfo("[FATE] Teleporting...")
        yield("/wait 1")
    end
    yield("/wait 1")
    LastTeleportTimeStamp = EorzeaTimeToUnixTime(GetCurrentEorzeaTimestamp())
end

function ChangeInstance()
    if SuccessiveInstanceChanges >= NumberOfInstances then
        if CompanionScriptMode then
            local shouldWaitForBonusBuff = WaitIfBonusBuff and (HasStatusId(1288) or HasStatusId(1289))
            if WaitingForFateRewards == 0 and not shouldWaitForBonusBuff then
                StopScript = true
            else
                LogInfo("[Fate Farming] Waiting for buff or fate rewards")
                yield("/wait 3")
            end
        else
            yield("/wait 10")
            SuccessiveInstanceChanges = 0
        end
        return
    end

    yield("/target エーテライト") -- search for nearby aetheryte
    if not HasTarget() or GetTargetName() ~= "エーテライト" then -- if no aetheryte within targeting range, teleport to it
        LogInfo("[FATE] Aetheryte not within targetable range")
        local closestAetheryte = nil
        local closestAetheryteDistance = math.maxinteger
        for i, aetheryte in ipairs(SelectedZone.aetheryteList) do
            -- GetDistanceToPoint is implemented with raw distance instead of distance squared
            local distanceToAetheryte = GetDistanceToPoint(aetheryte.x, aetheryte.y, aetheryte.z)
            if distanceToAetheryte < closestAetheryteDistance then
                closestAetheryte = aetheryte
                closestAetheryteDistance = distanceToAetheryte
            end
        end
        TeleportTo(closestAetheryte.aetheryteName)
        return
    end

    if WaitingForFateRewards ~= 0 then
        yield("/wait 10")
        return
    end

    if GetDistanceToTarget() > 10 then
        LogInfo("[FATE] Targeting aetheryte, but greater than 10 distance")
        if GetDistanceToTarget() > 20 and not GetCharacterCondition(CharacterCondition.mounted) then
            State = CharacterState.mounting
            LogInfo("[FATE] State Change: Mounting")
        elseif not (PathfindInProgress() or PathIsRunning()) then
            PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
        end
        return
    end

    LogInfo("[FATE] Within 10 distance")
    if PathfindInProgress() or PathIsRunning() then
        yield("/vnav stop")
        return
    end

    if GetCharacterCondition(CharacterCondition.mounted) then
        State = CharacterState.changeInstanceDismount
        LogInfo("[FATE] State Change: ChangeInstanceDismount")
        return
    end

    LogInfo("[FATE] Transferring to next instance")
    local nextInstance = (GetZoneInstance() % 2) + 1
    yield("/li "..nextInstance) -- start instance transfer
    yield("/wait 1") -- wait for instance transfer to register
    State = CharacterState.ready
    SuccessiveInstanceChanges = SuccessiveInstanceChanges + 1
    LogInfo("[FATE] State Change: Ready")
end

function WaitForContinuation()
    if IsInFate() then
        LogInfo("WaitForContinuation IsInFate")
        local nextFateId = GetNearestFate()
        if nextFateId ~= CurrentFate.fateId then
            CurrentFate = BuildFateTable(nextFateId)
            State = CharacterState.doFate
            LogInfo("[FATE] State Change: DoFate")
        end
    elseif os.clock() - LastFateEndTime > 30 then
        LogInfo("WaitForContinuation Abort")
        LogInfo("Over 30s since end of last fate. Giving up on part 2.")
        TurnOffCombatMods()
        State = CharacterState.ready
        LogInfo("State Change: Ready")
    else
        LogInfo("WaitForContinuation Else")
        if BossFatesClass ~= nil then
            local currentClass = GetClassJobId()
            LogInfo("WaitForContinuation "..CurrentFate.fateName)
            if not IsPlayerOccupied() then
                if CurrentFate.continuationIsBoss and currentClass ~= BossFatesClass.classId then
                    LogInfo("WaitForContinuation SwitchToBoss")
                    yield("/gs change "..BossFatesClass.className)
                elseif not CurrentFate.continuationIsBoss and currentClass ~= MainClass.classId then
                    LogInfo("WaitForContinuation SwitchToMain")
                    yield("/gs change "..MainClass.className)
                end
            end
        end

        yield("/wait 1")
    end
end

function FlyBackToAetheryte()
    NextFate = SelectNextFate()
    if NextFate ~= nil then
        yield("/vnav stop")
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        return
    end

    local x = GetPlayerRawXPos()
    local y = GetPlayerRawYPos()
    local z = GetPlayerRawZPos()
    local closestAetheryte = GetClosestAetheryte(x, y, z, 0)
    -- if you get any sort of error while flying back, then just abort and tp back
    if IsAddonVisible("_TextError") and GetNodeText("_TextError", 1) == "Your mount can fly no higher." then
        yield("/vnav stop")
        TeleportTo(closestAetheryte.aetheryteName)
        return
    end

    yield("/target エーテライト")

    if HasTarget() and GetTargetName() == "エーテライト" and DistanceBetween(GetTargetRawXPos(), y, GetTargetRawZPos(), x, y, z) <= 20 then
        if PathfindInProgress() or PathIsRunning() then
            yield("/vnav stop")
        end

        if GetCharacterCondition(CharacterCondition.flying) then
            yield("/gaction 降りる") -- land but don't actually dismount, to avoid running chocobo timer
        elseif GetCharacterCondition(CharacterCondition.mounted) then
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        else
            if MountToUse == "" then
                yield("/gaction マウント・ルーレット")
            else
                yield("/mount " .. MountToUse)
            end
        end
        return
    end

    if not GetCharacterCondition(CharacterCondition.mounted) then
        State = CharacterState.mounting
        LogInfo("[FATE] State Change: Mounting")
        return
    end
    
    if not (PathfindInProgress() or PathIsRunning()) then
        LogInfo("[FATE] ClosestAetheryte.y: "..closestAetheryte.y)
        if closestAetheryte ~= nil then
            SetMapFlag(SelectedZone.zoneId, closestAetheryte.x, closestAetheryte.y, closestAetheryte.z)
            PathfindAndMoveTo(closestAetheryte.x, closestAetheryte.y, closestAetheryte.z, GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
        end
    end
end

function Mount()
    if GetCharacterCondition(CharacterCondition.mounted) then
        yield("/wait 1") -- wait a second to make sure you're firmly on the mount
        State = CharacterState.moveToFate
        LogInfo("[FATE] State Change: MoveToFate")
    else
        if MountToUse == "" then
            yield("/gaction マウント・ルーレット")
        else
            yield('/mount "' .. MountToUse)
        end
    end
    yield("/wait 1")
    yield("/gaction ジャンプ")
end

function Dismount()
    if GetCharacterCondition(CharacterCondition.flying) then
        yield("/gaction 降りる")

        local now = os.clock()
        if now - LastStuckCheckTime > 1 then
            local x = GetPlayerRawXPos()
            local y = GetPlayerRawYPos()
            local z = GetPlayerRawZPos()

            if GetCharacterCondition(CharacterCondition.flying) and GetDistanceToPoint(LastStuckCheckPosition.x, LastStuckCheckPosition.y, LastStuckCheckPosition.z) < 2 then
                LogInfo("[FATE] Unable to dismount here. Moving to another spot.")
                local random_x, random_y, random_z = RandomAdjustCoordinates(x, y, z, 10)
                local nearestPointX = QueryMeshNearestPointX(random_x, random_y, random_z, 100, 100)
                local nearestPointY = QueryMeshNearestPointY(random_x, random_y, random_z, 100, 100)
                local nearestPointZ = QueryMeshNearestPointZ(random_x, random_y, random_z, 100, 100)
                if nearestPointX ~= nil and nearestPointY ~= nil and nearestPointZ ~= nil then
                    PathfindAndMoveTo(nearestPointX, nearestPointY, nearestPointZ, GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
                    yield("/wait 1")
                end
            end

            LastStuckCheckTime = now
            LastStuckCheckPosition = {x=x, y=y, z=z}
        end
    elseif GetCharacterCondition(CharacterCondition.mounted) then
        yield("/gaction 降りる")
    end
end

function MiddleOfFateDismount()
    if not IsFateActive(CurrentFate.fateId) then
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        return
    end

    if HasTarget() then
        if DistanceBetween(GetPlayerRawXPos(), 0, GetPlayerRawZPos(), GetTargetRawXPos(), 0, GetTargetRawZPos()) > (MaxDistance + GetTargetHitboxRadius() + 5) then
            if not (PathfindInProgress() or PathIsRunning()) then
                LogInfo("[FATE] MiddleOfFateDismount PathfindAndMoveTo")
                PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying))
            end
        else
            if GetCharacterCondition(CharacterCondition.mounted) then
                LogInfo("[FATE] MiddleOfFateDismount Dismount()")
                Dismount()
            else
                yield("/vnav stop")
                State = CharacterState.doFate
                LogInfo("[FATE] State Change: DoFate")
            end
        end
    else
        TargetClosestFateEnemy()
    end
end

function NPCDismount()
    if GetCharacterCondition(CharacterCondition.mounted) then
        Dismount()
    else
        State = CharacterState.interactWithNpc
        LogInfo("[FATE] State Change: InteractWithFateNpc")
    end
end

function ChangeInstanceDismount()
    if GetCharacterCondition(CharacterCondition.mounted) then
        Dismount()
    else
        State = CharacterState.changingInstances
        LogInfo("[FATE] State Change: ChangingInstance")
    end
end

--Paths to the Fate NPC Starter
function MoveToNPC()
    yield("/target "..CurrentFate.npcName)
    if HasTarget() and GetTargetName()==CurrentFate.npcName then
        if GetDistanceToTarget() > 5 then
            PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), false)
        end
    end
end

--Paths to the Fate. CurrentFate is set here to allow MovetoFate to change its mind,
--so CurrentFate is possibly nil.
function MoveToFate()
    SuccessiveInstanceChanges = 0

    if not IsPlayerAvailable() then
        return
    end

    if CurrentFate~=nil and not IsFateActive(CurrentFate.fateId) then
        LogInfo("[FATE] Next Fate is dead, selecting new Fate.")
        yield("/vnav stop")
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        return
    end

    NextFate = SelectNextFate()
    if NextFate == nil then -- when moving to next fate, CurrentFate == NextFate
        yield("/vnav stop")
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        return
    elseif CurrentFate == nil or NextFate.fateId ~= CurrentFate.fateId then
        yield("/vnav stop")
        CurrentFate = NextFate
            SetMapFlag(SelectedZone.zoneId, CurrentFate.x, CurrentFate.y, CurrentFate.z)
        return
    end

    -- change to secondary class if it's a boss fate
    if BossFatesClass ~= nil then
        local currentClass = GetClassJobId()
        if CurrentFate.isBossFate and currentClass ~= BossFatesClass.classId then
            yield("/gs change "..BossFatesClass.className)
            return
        elseif not CurrentFate.isBossFate and currentClass ~= MainClass.classId then
            yield("/gs change "..MainClass.className)
            return
        end
    end

    -- upon approaching fate, pick a target and switch to pathing towards target
    if GetDistanceToPoint(CurrentFate.x, CurrentFate.y, CurrentFate.z) < 60 then
	    if HasTarget() then
	        LogInfo("[FATE] Found FATE target, immediate rerouting")
	        PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos())
            if (CurrentFate.isOtherNpcFate or CurrentFate.isCollectionsFate) then
                State = CharacterState.interactWithNpc
                LogInfo("[FATE] State Change: Interact with npc")
            -- if GetTargetName() == CurrentFate.npcName then
            --     State = CharacterState.interactWithNpc
            -- elseif GetTargetFateID() == CurrentFate.fateId then
            --     State = CharacterState.middleOfFateDismount
            --     LogInfo("[FATE] State Change: MiddleOfFateDismount")
	        else
                State = CharacterState.middleOfFateDismount
                LogInfo("[FATE] State Change: MiddleOfFateDismount")
	        end
	        return
        else
	        if (CurrentFate.isOtherNpcFate or CurrentFate.isCollectionsFate) and not IsInFate() then
	            yield("/target "..CurrentFate.npcName)
	        else
	            TargetClosestFateEnemy()
	        end
            yield("/wait 0.5") -- give it a moment to make sure the target sticks
	        return
    	end
    end

    -- check for stuck
    if (PathIsRunning() or PathfindInProgress()) and GetCharacterCondition(CharacterCondition.mounted) then
        local now = os.clock()
        if now - LastStuckCheckTime > 10 then
            local x = GetPlayerRawXPos()
            local y = GetPlayerRawYPos()
            local z = GetPlayerRawZPos()

            if GetDistanceToPoint(LastStuckCheckPosition.x, LastStuckCheckPosition.y, LastStuckCheckPosition.z) < 3 then
                yield("/vnav stop")
                yield("/wait 1")
                LogInfo("[FATE] Antistuck")
                PathfindAndMoveTo(x, y + 10, z, GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying) -- fly up 10 then try again
            end
            
            LastStuckCheckTime = now
            LastStuckCheckPosition = {x=x, y=y, z=z}
        end
        return
    end

    if not MovingAnnouncementLock then
        LogInfo("[FATE] Moving to fate #"..CurrentFate.fateId.." "..CurrentFate.fateName)
        MovingAnnouncementLock = true
        if Echo == "All" then
            yield("/echo [FATE] Moving to fate #"..CurrentFate.fateId.." "..CurrentFate.fateName)
        end
    end

    if TeleportToClosestAetheryteToFate(CurrentFate) then
        return
    end

    if not GetCharacterCondition(CharacterCondition.mounted) then
        State = CharacterState.mounting
        LogInfo("[FATE] State Change: Mounting")
        return
    end

    local nearestLandX, nearestLandY, nearestLandZ = CurrentFate.x, CurrentFate.y, CurrentFate.z
    if not (CurrentFate.isCollectionsFate or CurrentFate.isOtherNpcFate) then
        nearestLandX, nearestLandY, nearestLandZ = RandomAdjustCoordinates(CurrentFate.x, CurrentFate.y, CurrentFate.z, 10)
    end

    if GetDistanceToPoint(nearestLandX, nearestLandY, nearestLandZ) > 5 then
        PathfindAndMoveTo(nearestLandX, nearestLandY, nearestLandZ, HasFlightUnlocked(SelectedZone.zoneId) and SelectedZone.flying)
    else
        State = CharacterState.middleOfFateDismount
    end
end

function InteractWithFateNpc()
    if IsInFate() or GetFateStartTimeEpoch(CurrentFate.fateId) > 0 then
        yield("/vnav stop")
        State = CharacterState.doFate
        LogInfo("[FATE] State Change: DoFate")
        yield("/wait 1") -- give the fate a second to register before dofate and lsync
    elseif not IsFateActive(CurrentFate.fateId) then
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
    elseif PathfindInProgress() or PathIsRunning() then
        if HasTarget() and GetTargetName() == CurrentFate.npcName and GetDistanceToTarget() < (5*math.random()) then
            yield("/vnav stop")
        end
        return
    else
        -- if target is already selected earlier during pathing, avoids having to target and move again
        if (not HasTarget() or GetTargetName()~=CurrentFate.npcName) then
            yield("/target "..CurrentFate.npcName)
            return
        end

        if GetCharacterCondition(CharacterCondition.mounted) then
            State = CharacterState.npcDismount
            LogInfo("[FATE] State Change: NPCDismount")
            return
        end

        if GetDistanceToPoint(GetTargetRawXPos(), GetPlayerRawYPos(), GetTargetRawZPos()) > 5 then
            MoveToNPC()
            return
        end

        if IsAddonVisible("SelectYesno") then
            AcceptNPCFateOrRejectOtherYesno()
        elseif not GetCharacterCondition(CharacterCondition.occupied) then
            yield("/interact")
        end
    end
end

function CollectionsFateTurnIn()
    AcceptNPCFateOrRejectOtherYesno()

    if CurrentFate ~= nil and not IsFateActive(CurrentFate.fateId) then
        CurrentFate = nil
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        return
    end

    if (not HasTarget() or GetTargetName()~=CurrentFate.npcName) then
        TurnOffCombatMods()
        yield("/target "..CurrentFate.npcName)
        yield("/wait 1")

        -- if too far from npc to target, then head towards center of fate
        if (not HasTarget() or GetTargetName()~=CurrentFate.npcName and GetFateProgress(CurrentFate.fateId) < 100) then
            if not PathfindInProgress() and not PathIsRunning() then
                PathfindAndMoveTo(CurrentFate.x, CurrentFate.y, CurrentFate.z)
            end
        else
            yield("/vnav stop")
        end
        return
    end

    if GetDistanceToPoint(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos()) > 5 then
        if not (PathfindInProgress() or PathIsRunning()) then
            MoveToNPC()
        end
    else
        if GetItemCount(GetFateEventItem(CurrentFate.fateId)) >= 7 then
            GotCollectionsFullCredit = true
        end

        yield("/vnav stop")
        yield("/interact")
        yield("/wait 3")

        if GetFateProgress(CurrentFate.fateId) < 100 then
            TurnOnCombatMods()
            State = CharacterState.doFate
            LogInfo("[FATE] State Change: DoFate")
        else
            if GotCollectionsFullCredit then
                State = CharacterState.unexpectedCombat
                LogInfo("[FATE] State Change: UnexpectedCombat")
            end
        end

        if CurrentFate ~=nil and CurrentFate.npcName ~=nil and GetTargetName() == CurrentFate.npcName then
            LogInfo("[FATE] Attempting to clear target.")
            ClearTarget()
            yield("/wait 1")
        end
    end
end

--#endregion

--#region Combat Functions

function GetClassJobTableFromId(jobId)
    if jobId == nil then
        LogInfo("[FATE] JobId is nil")
        return nil
    end
    for _, classJob in pairs(ClassList) do
        if classJob.classId == jobId then
            return classJob
        end
    end
    LogInfo("[FATE] Cannot recognize combat job.")
    return nil
end

function GetClassJobTableFromAbbrev(classString)
    if classString == "" then
        LogInfo("[FATE] No class set")
        return nil
    end
    for classJobAbbrev, classJob in pairs(ClassList) do
        if classJobAbbrev == string.lower(classString) then
            return classJob
        end
    end
    LogInfo("[FATE] Cannot recognize combat job.")
    return nil
end

function SummonChocobo()
    if GetCharacterCondition(CharacterCondition.mounted) then
        Dismount()
        return
    end

    if ShouldSummonChocobo and GetBuddyTimeRemaining() <= ResummonChocoboTimeLeft then
        if GetItemCount(4868) > 0 then
            yield("/item ギサールの野菜")
            yield("/wait 3")
            if GetZoneID() == 1190 or GetZoneID() == 1191 or GetZoneID() == 1192 then
                yield("/cac "..ChocoboStance)
            else
                yield("/cac アタッカースタンス")
            end
        elseif ShouldAutoBuyGysahlGreens then
            State = CharacterState.autoBuyGysahlGreens
            LogInfo("[FATE] State Change: AutoBuyGysahlGreens")
            return
        end
    end
    State = CharacterState.ready
    LogInfo("[FATE] State Change: Ready")
end

function AutoBuyGysahlGreens()
    if GetItemCount(4868) > 0 then -- don't need to buy
        if IsAddonVisible("Shop") then
            yield("/callback Shop true -1")
        elseif IsInZone(SelectedZone.zoneId) then
            yield("/item ギサールの野菜")
        else
            State = CharacterState.ready
            LogInfo("State Change: ready")
        end
        return
    else
        if not IsInZone(129) then
            yield("/vnav stop")
            TeleportTo("リムサ・ロミンサ：下甲板層")
            return
        else
            local gysahlGreensVendor = { x=-62.1, y=18.0, z=9.4, npcName="ブルゲール商会 バンゴ・ザンゴ" }
            if GetDistanceToPoint(gysahlGreensVendor.x, gysahlGreensVendor.y, gysahlGreensVendor.z) > 5 then
                if not (PathIsRunning() or PathfindInProgress()) then
                    PathfindAndMoveTo(gysahlGreensVendor.x, gysahlGreensVendor.y, gysahlGreensVendor.z)
                end
            elseif HasTarget() and GetTargetName() == gysahlGreensVendor.npcName then
                yield("/vnav stop")
                if IsAddonVisible("SelectYesno") then
                    yield("/callback SelectYesno true 0")
                elseif IsAddonVisible("SelectIconString") then
                    yield("/callback SelectIconString true 0")
                    return
                elseif IsAddonVisible("Shop") then
                    yield("/callback Shop true 0 2 99")
                    return
                elseif not GetCharacterCondition(CharacterCondition.occupied) then
                    yield("/interact")
                    yield("/wait 1")
                    return
                end
            else
                yield("/vnav stop")
                yield("/target "..gysahlGreensVendor.npcName)
            end
        end
    end
end

--Paths to the enemy (for Meele)
function EnemyPathing()
    while HasTarget() and GetDistanceToTarget() > (GetTargetHitboxRadius() + MaxDistance) do
        local enemy_x = GetTargetRawXPos()
        local enemy_y = GetTargetRawYPos()
        local enemy_z = GetTargetRawZPos()
        if PathIsRunning() == false then
            PathfindAndMoveTo(enemy_x, enemy_y, enemy_z, GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
        end
        yield("/wait 0.1")
    end
end

function TurnOnAoes()
    if not AoesOn then
        if RotationPlugin == "RSR" then
            yield("/rotation off")
--            yield("/rotation auto on")
            yield("/rotation manual")
            LogInfo("[FATE] TurnOnAoes /rotation auto on")
        
            if RSRAoeType == "Off" then
                yield("/rotation settings aoetype 0")
            elseif RSRAoeType == "Cleave" then
                yield("/rotation settings aoetype 1")
            elseif RSRAoeType == "Full" then
                yield("/rotation settings aoetype 2")
            end
        elseif RotationPlugin == "BMR" then
            yield("/bmrai setpresetname "..RotationAoePreset)
        elseif RotationPlugin == "VBM" then
            yield("/vbm ar toggle "..RotationAoePreset)
        end
        AoesOn = true
    end
end

function TurnOffAoes()
    if AoesOn then
        if RotationPlugin == "RSR" then
            yield("/rotation settings aoetype 1")
            yield("/rotation manual")
            LogInfo("[FATE] TurnOffAoes /rotation manual")
        elseif RotationPlugin == "BMR" then
            yield("/bmrai setpresetname "..RotationSingleTargetPreset)
        elseif RotationPlugin == "VBM" then
            yield("/vbm ar toggle "..RotationSingleTargetPreset)
        end
        AoesOn = false
    end
end

function TurnOffRaidBuffs()
    if AoesOn then
        if RotationPlugin == "BMR" then
            yield("/bmrai setpresetname "..RotationHoldBuffPreset)
        elseif RotationPlugin == "VBM" then
            yield("/vbm ar toggle "..RotationHoldBuffPreset)
        end
    end
end

function SetMaxDistance()
    MaxDistance = MeleeDist --default to melee distance
    --ranged and casters have a further max distance so not always running all way up to target
    local currentClass = GetClassJobTableFromId(GetClassJobId())
    if not currentClass.isMelee then
        MaxDistance = RangedDist
    end
end

function TurnOnCombatMods(rotationMode)
    if not CombatModsOn then
        CombatModsOn = true
        -- turn on RSR in case you have the RSR 30 second out of combat timer set
        if RotationPlugin == "RSR" then
            if rotationMode == "manual" then
                yield("/rotation manual")
                LogInfo("[FATE] TurnOnCombatMods /rotation manual")
            else
                yield("/rotation off")
                yield("/rotation auto on")
                LogInfo("[FATE] TurnOnCombatMods /rotation auto on")
            end
        elseif RotationPlugin == "BMR" then
            yield("/bmrai setpresetname "..RotationAoePreset)
        elseif RotationPlugin == "VBM" then
            yield("/vbm ar toggle "..RotationAoePreset)
        elseif RotationPlugin == "Wrath" then
            yield("/wrath auto on")
        end

        local class = GetClassJobTableFromId(GetClassJobId())

        if not AiDodgingOn then
            SetMaxDistance()
            
            if DodgingPlugin == "BMR" then
                yield("/bmrai on")
                yield("/bmrai followtarget on") -- overrides navmesh path and runs into walls sometimes
                yield("/bmrai followcombat on")
                -- yield("/bmrai followoutofcombat on")
                yield("/bmrai maxdistancetarget " .. MaxDistance)
            elseif DodgingPlugin == "VBM" then
                yield("/vbmai on")
                yield("/vbmai followtarget on") -- overrides navmesh path and runs into walls sometimes
                yield("/vbmai followcombat on")
                -- yield("/bmrai followoutofcombat on")
                yield("/vbmai maxdistancetarget " .. MaxDistance)
                if RotationPlugin ~= "VBM" then
                    yield("/vbmai ForbidActions on") --This Disables VBM AI Auto-Target
                end
            end
            AiDodgingOn = true
        end
    end
end

function TurnOffCombatMods()
    if CombatModsOn then
        LogInfo("[FATE] Turning off combat mods")
        CombatModsOn = false

        if RotationPlugin == "RSR" then
            yield("/rotation off")
            LogInfo("[FATE] TurnOffCombatMods /rotation off")
        elseif RotationPlugin == "BMR" or RotationPlugin == "VBM" then
            yield("/bmrai setpresetname null")
        elseif RotationPlugin == "Wrath" then
            yield("/wrath auto off")
        end

        -- turn off BMR so you don't start following other mobs
        if AiDodgingOn then
            if DodgingPlugin == "BMR" then
--                yield("/bmrai off")
--                yield("/bmrai followtarget off")
--                yield("/bmrai followcombat off")
--                yield("/bmrai followoutofcombat off")
            elseif DodgingPlugin == "VBM" then
                yield("/vbm ar disable")
                yield("/vbmai off")
                yield("/vbmai followtarget off")
                yield("/vbmai followcombat off")
                yield("/vbmai followoutofcombat off")
                if RotationPlugin ~= "VBM" then
                    yield("/vbmai ForbidActions off") --This Enables VBM AI Auto-Target
                end
            end
            AiDodgingOn = false
        end
    end
end

function HandleUnexpectedCombat()
    TurnOnCombatMods("manual")

    if IsInFate() and GetFateProgress(GetNearestFate()) < 100 then
        CurrentFate = BuildFateTable(GetNearestFate())
        State = CharacterState.doFate
        LogInfo("[FATE] State Change: DoFate")
        return
    elseif not GetCharacterCondition(CharacterCondition.inCombat) then
        yield("/vnav stop")
        ClearTarget()
        TurnOffCombatMods()
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        local randomWait = (math.floor(math.random()*MaxWait * 1000)/1000) + MinWait -- truncated to 3 decimal places
        yield("/wait "..randomWait)
        return
    end

    if GetCharacterCondition(CharacterCondition.mounted) then
        if not (PathfindInProgress() or PathIsRunning()) then
            PathfindAndMoveTo(GetPlayerRawXPos(), GetPlayerRawYPos() + 10, GetPlayerRawZPos(), true)
        end
        yield("/wait 10")
        return
    end

    -- targets whatever is trying to kill you
    if not HasTarget() then
        yield("/battletarget")
    end

    -- pathfind closer if enemies are too far
    if HasTarget() then
        if GetDistanceToTarget() > (MaxDistance + GetTargetHitboxRadius()) then
            if not (PathfindInProgress() or PathIsRunning()) then
                PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
            end
        else
            if PathfindInProgress() or PathIsRunning() then
                yield("/vnav stop")
            elseif not GetCharacterCondition(CharacterCondition.inCombat) then
                --inch closer 3 seconds
                PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
                yield("/wait 3")
            end
        end
    end
    yield("/wait 1")
end

function DoFate()
    if WaitingForFateRewards ~= CurrentFate.fateId then
        WaitingForFateRewards = CurrentFate.fateId
        LogInfo("[FATE] WaitingForFateRewards DoFate: "..tostring(WaitingForFateRewards))
    end
    local currentClass = GetClassJobId()
    -- switch classes (mostly for continutation fates that pop you directly into the next one)
    if CurrentFate.isBossFate and BossFatesClass ~= nil and currentClass ~= BossFatesClass.classId and not IsPlayerOccupied() then
        TurnOffCombatMods()
        yield("/gs change "..BossFatesClass.className)
        yield("/wait 1")
        return
    elseif not CurrentFate.isBossFate and BossFatesClass ~= nil and currentClass ~= MainClass.classId and not IsPlayerOccupied() then
        TurnOffCombatMods()
        yield("/gs change "..MainClass.className)
        yield("/wait 1")
        return
    elseif IsInFate() and (GetFateMaxLevel(CurrentFate.fateId) < GetLevel()) and not IsLevelSynced() then
        yield("/lsync")
        yield("/wait 0.5") -- give it a second to register
    elseif IsFateActive(CurrentFate.fateId) and not IsInFate() and GetFateProgress(CurrentFate.fateId) < 100 and
        (GetDistanceToPoint(CurrentFate.x, CurrentFate.y, CurrentFate.z) < GetFateRadius(CurrentFate.fateId) + 10) and
        not GetCharacterCondition(CharacterCondition.mounted) and not (PathIsRunning() or PathfindInProgress())
    then -- got pushed out of fate. go back
        yield("/vnav stop")
        yield("/wait 1")
        LogInfo("[FATE] pushed out of fate going back!")
        PathfindAndMoveTo(CurrentFate.x, CurrentFate.y, CurrentFate.z, GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
        return
    elseif not IsFateActive(CurrentFate.fateId) or GetFateProgress(CurrentFate.fateId) == 100 then
        yield("/vnav stop")
        ClearTarget()
        if not LogInfo("[FATE] HasContintuation check") and CurrentFate.hasContinuation then
            LastFateEndTime = os.clock()
            State = CharacterState.waitForContinuation
            LogInfo("[FATE] State Change: WaitForContinuation")
            return
        else
            DidFate = true
            LogInfo("[FATE] No continuation for "..CurrentFate.fateName)
            local randomWait = (math.floor(math.random() * (math.max(0, MaxWait - 3)) * 1000)/1000) + MinWait -- truncated to 3 decimal places
            yield("/wait "..randomWait)
            TurnOffCombatMods()
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        end
        return
    elseif GetCharacterCondition(CharacterCondition.mounted) then
        State = CharacterState.middleOfFateDismount
        LogInfo("[FATE] State Change: MiddleOfFateDismount")
        return
    elseif CurrentFate.isCollectionsFate then
        yield("/wait 1") -- needs a moment after start of fate for GetFateEventItem to populate
        if GetItemCount(GetFateEventItem(CurrentFate.fateId)) >= 7 or (GotCollectionsFullCredit and GetFateProgress(CurrentFate.fateId) == 100) then
            yield("/vnav stop")
            State = CharacterState.collectionsFateTurnIn
            LogInfo("[FATE] State Change: CollectionsFatesTurnIn")
        end
    end

    LogInfo("DoFate->Finished transition checks")

    -- do not target fate npc during combat
    if CurrentFate.npcName ~=nil and GetTargetName() == CurrentFate.npcName then
        LogInfo("[FATE] Attempting to clear target.")
        ClearTarget()
        yield("/wait 1")
    end
    
    TurnOnCombatMods("manual")

    GemAnnouncementLock = false

    -- switches to targeting forlorns for bonus (if present)
    if not IgnoreForlorns then
        yield("/target フォーローン・メイデン")
        if not IgnoreBigForlornOnly then
            yield("/target フォーローン")
        end
    end

    if (GetTargetName() == "フォーローン・メイデン" or GetTargetName() == "フォーローン") then
        if IgnoreForlorns or (IgnoreBigForlornOnly and GetTargetName() == "フォーローン") then
            ClearTarget()
        elseif GetTargetHP() > 0 then
            if not ForlornMarked then
--                yield("/enemysign attack1")
                if Echo == "All" then
                    yield("/echo Found Forlorn! <se.3>")
                end
                TurnOffAoes()
                ForlornMarked = true
            end
        else
            ClearTarget()
            TurnOnAoes()
        end
    else
        TurnOnAoes()
    end

    -- targets whatever is trying to kill you
    if not HasTarget() then
        yield("/battletarget")
    end

    -- clears target
    if GetTargetFateID() ~= CurrentFate.fateId and not IsTargetInCombat() then
        ClearTarget()
    end

    -- do not interrupt casts to path towards enemies
    if GetCharacterCondition(CharacterCondition.casting) then
        return
    end

    -- pathfind closer if enemies are too far
    if not GetCharacterCondition(CharacterCondition.inCombat) then
        if HasTarget() then
            local x,y,z = GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos()
            if GetDistanceToTarget() <= (MaxDistance + GetTargetHitboxRadius() + 1) then
                if PathfindInProgress() or PathIsRunning() then
                    yield("/vnav stop")
                    yield("/wait 5.002") -- wait 5s before inching any closer
                elseif (GetDistanceToTarget() > (1 + GetTargetHitboxRadius())) and not GetCharacterCondition(CharacterCondition.casting) then -- never move into hitbox
                    PathfindAndMoveTo(x, y, z)
                    yield("/wait 1") -- inch closer by 1s
                end
            elseif not (PathfindInProgress() or PathIsRunning()) then
                yield("/wait 5.003") -- give 5s for enemy AoE casts to go off before attempting to move closer
                if (x ~= 0 and z~=0 and not GetCharacterCondition(CharacterCondition.inCombat)) and not GetCharacterCondition(CharacterCondition.casting) then
                    PathfindAndMoveTo(x, y, z)
                end
            end
            return
        else
            TargetClosestFateEnemy()
            yield("/wait 1") -- wait in case target doesn't stick
            if (not HasTarget()) and not GetCharacterCondition(CharacterCondition.casting) then
                PathfindAndMoveTo(CurrentFate.x, CurrentFate.y, CurrentFate.z)
            end
        end
    else
        if HasTarget() and (GetDistanceToTarget() <= (MaxDistance + GetTargetHitboxRadius() + 1)) then
            if PathfindInProgress() or PathIsRunning() then
            yield("/vnav stop")
            end
        elseif not CurrentFate.isBossFate then
            if not (PathfindInProgress() or PathIsRunning()) then
                yield("/wait 5.004")
                local x,y,z = GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos()
                if (x ~= 0 and z~=0)  and not GetCharacterCondition(CharacterCondition.casting) then
                    PathfindAndMoveTo(x,y,z, GetCharacterCondition(CharacterCondition.flying) and SelectedZone.flying)
                end
            end
        end
    end
        
    --hold buff thingy
    if GetFateProgress(CurrentFate.fateId) >= PercentageToHoldBuff then
        TurnOffRaidBuffs()
    end
end

--#endregion

--#region State Transition Functions

function FoodCheck()
    --food usage
    if not HasStatusId(48) and Food ~= "" then
        yield("/item " .. Food)
    end
end

function PotionCheck()
    --pot usage
    if not HasStatusId(49) and Potion ~= "" then
        yield("/item " .. Potion)
    end
end

function Ready()
    FoodCheck()
    PotionCheck()
    
    CombatModsOn = false -- expect RSR to turn off after every fate
    GotCollectionsFullCredit = false
    ForlornMarked = false
    MovingAnnouncementLock = false

    local shouldWaitForBonusBuff = WaitIfBonusBuff and (HasStatusId(1288) or HasStatusId(1289))

    NextFate = SelectNextFate()
    if CurrentFate ~= nil and not IsFateActive(CurrentFate.fateId) then
        CurrentFate = nil
    end

    if CurrentFate == nil then
        LogInfo("[FATE] CurrentFate is nil")
    else
        LogInfo("[FATE] CurrentFate is "..CurrentFate.fateName)
    end

    if NextFate == nil then
        LogInfo("[FATE] NextFate is nil")
    else
        LogInfo("[FATE] NextFate is "..NextFate.fateName)
    end

    if not LogInfo("[FATE] Ready -> IsPlayerAvailable()") and not IsPlayerAvailable() then
        return
    elseif not LogInfo("[FATE] Ready -> Repair") and RepairAmount > 0 and NeedsRepair(RepairAmount) and
        (not shouldWaitForBonusBuff or (SelfRepair and GetItemCount(33916) > 0)) then
        State = CharacterState.repair
        LogInfo("[FATE] State Change: Repair")
    elseif not LogInfo("[FATE] Ready -> ExtractMateria") and ShouldExtractMateria and CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        State = CharacterState.extractMateria
        LogInfo("[FATE] State Change: ExtractMateria")
    elseif (not LogInfo("[FATE] Ready -> WaitBonusBuff") and NextFate == nil and shouldWaitForBonusBuff) and DownTimeWaitAtNearestAetheryte then
        if not HasTarget() or GetTargetName() ~= "エーテライト" or GetDistanceToTarget() > 20 then
            State = CharacterState.flyBackToAetheryte
            LogInfo("[FATE] State Change: FlyBackToAetheryte")
        else
            yield("/wait 10")
        end
        return
    elseif not LogInfo("[FATE] Ready -> ExchangingVouchers") and WaitingForFateRewards == 0 and
        ShouldExchangeBicolorGemstones and (BicolorGemCount >= TradeGemCount) and not shouldWaitForBonusBuff
    then
        State = CharacterState.exchangingVouchers
        LogInfo("[FATE] State Change: ExchangingVouchers")
    elseif not LogInfo("[FATE] Ready -> ProcessRetainers") and WaitingForFateRewards == 0 and
        Retainers and ARRetainersWaitingToBeProcessed() and GetInventoryFreeSlotCount() > 1  and not shouldWaitForBonusBuff
    then
        State = CharacterState.processRetainers
        LogInfo("[FATE] State Change: ProcessingRetainers")
    elseif not LogInfo("[FATE] Ready -> GC TurnIn") and ShouldGrandCompanyTurnIn and
        GetInventoryFreeSlotCount() < InventorySlotsLeft and not shouldWaitForBonusBuff
    then
        State = CharacterState.gcTurnIn
        LogInfo("[FATE] State Change: GCTurnIn")
    elseif not LogInfo("[FATE] Ready -> TeleportBackToFarmingZone") and not IsInZone(SelectedZone.zoneId) then
        TeleportTo(SelectedZone.aetheryteList[1].aetheryteName)
        return
    elseif not LogInfo("[FATE] Ready -> SummonChocobo") and ShouldSummonChocobo and GetBuddyTimeRemaining() <= ResummonChocoboTimeLeft and
        (not shouldWaitForBonusBuff or GetItemCount(4868) > 0) then
        State = CharacterState.summonChocobo
    elseif not LogInfo("[FATE] Ready -> NextFate nil") and NextFate == nil then
        if EnableChangeInstance and GetZoneInstance() > 0 and not shouldWaitForBonusBuff then
            State = CharacterState.changingInstances
            LogInfo("[FATE] State Change: ChangingInstances")
            return
        elseif CompanionScriptMode and not shouldWaitForBonusBuff then
            if WaitingForFateRewards == 0 then
                StopScript = true
                LogInfo("[FATE] StopScript: Ready")
            else
                LogInfo("[FATE] Waiting for fate rewards")
            end
        elseif (not HasTarget() or GetTargetName() ~= "エーテライト" or GetDistanceToTarget() > 20) and DownTimeWaitAtNearestAetheryte then
            State = CharacterState.flyBackToAetheryte
            LogInfo("[FATE] State Change: FlyBackToAetheryte")
        else
            yield("/wait 10")
        end
        return
    elseif CompanionScriptMode and DidFate and not shouldWaitForBonusBuff then
        if WaitingForFateRewards == 0 then
            StopScript = true
            LogInfo("[FATE] StopScript: DidFate")
        else
            LogInfo("[FATE] Waiting for fate rewards")
        end
    elseif not LogInfo("[FATE] Ready -> MovingToFate") then -- and ((CurrentFate == nil) or (GetFateProgress(CurrentFate.fateId) == 100) and NextFate ~= nil) then
        CurrentFate = NextFate
        SetMapFlag(SelectedZone.zoneId, CurrentFate.x, CurrentFate.y, CurrentFate.z)
        State = CharacterState.moveToFate
        LogInfo("[FATE] State Change: MovingtoFate "..CurrentFate.fateName)
    end

    if not GemAnnouncementLock and (Echo == "All" or Echo == "Gems") then
        GemAnnouncementLock = true
        if BicolorGemCount >= TradeGemCount then
            yield("/echo [FATE] You're almost capped with "..tostring(BicolorGemCount).."/1500 gems! <se.3>")
        else
            yield("/echo [FATE] Gems: "..tostring(BicolorGemCount).."/1500")
        end
    end
end


function HandleDeath()
    CurrentFate = nil

    if CombatModsOn then
        TurnOffCombatMods()
    end

    if PathfindInProgress() or PathIsRunning() then
        yield("/vnav stop")
    end

    if GetCharacterCondition(CharacterCondition.dead) then --Condition Dead
        if Echo and not DeathAnnouncementLock then
            DeathAnnouncementLock = true
            if Echo == "All" then
                yield("/echo [FATE] You have died. Returning to home aetheryte.")
            end
        end

        if IsAddonVisible("SelectYesno") then --rez addon yes
            yield("/callback SelectYesno true 0")
            yield("/wait 0.1")
        end
    else
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        DeathAnnouncementLock = false
    end
end

function ExecuteBicolorExchange()
    CurrentFate = nil

    if BicolorGemCount >= TradeGemCount then
        if IsAddonVisible("SelectYesno") then
            yield("/callback SelectYesno true 0")
            return
        end

        if IsAddonVisible("ShopExchangeCurrency") then
            yield("/callback ShopExchangeCurrency false 0 "..SelectedBicolorExchangeData.item.itemIndex.." "..(BicolorGemCount//SelectedBicolorExchangeData.item.price))
            return
        end

        if not IsInZone(SelectedBicolorExchangeData.zoneId) then
            TeleportTo(SelectedBicolorExchangeData.aetheryteName)
            return
        end

        local shopX = SelectedBicolorExchangeData.x
        local shopY = SelectedBicolorExchangeData.y
        local shopZ = SelectedBicolorExchangeData.z
    
        if SelectedBicolorExchangeData.miniAethernet ~= nil and
            GetDistanceToPoint(shopX, shopY, shopZ) > (DistanceBetween(SelectedBicolorExchangeData.miniAethernet.x, SelectedBicolorExchangeData.miniAethernet.y, SelectedBicolorExchangeData.miniAethernet.z, shopX, shopY, shopZ) + 10) then
            LogInfo("Distance to shopkeep is too far. Using mini aetheryte.")
            yield("/li "..SelectedBicolorExchangeData.miniAethernet.name)
            yield("/wait 1") -- give it a moment to register
            return
        elseif IsAddonVisible("TelepotTown") then
            LogInfo("TelepotTown open")
            yield("/callback TelepotTown false -1")
        elseif GetDistanceToPoint(shopX, shopY, shopZ) > 5 then
            LogInfo("Distance to shopkeep is too far. Walking there.")
            if not (PathfindInProgress() or PathIsRunning()) then
                LogInfo("Path not running")
                PathfindAndMoveTo(shopX, shopY, shopZ)
            end
        else
            LogInfo("[FATE] Arrived at Shopkeep")
            if PathfindInProgress() or PathIsRunning() then
            yield("/vnav stop")
        end

        if not HasTarget() or GetTargetName() ~= SelectedBicolorExchangeData.shopKeepName then
                yield("/target "..SelectedBicolorExchangeData.shopKeepName)
            elseif not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent) then
                yield("/interact")
            end
        end
    else
        if IsAddonVisible("ShopExchangeCurrency") then
            LogInfo("[FATE] Attemping to close shop window")
            yield("/callback ShopExchangeCurrency true -1")
            return
        elseif GetCharacterCondition(CharacterCondition.occupiedInEvent) then
            LogInfo("[FATE] Character still occupied talking to shopkeeper")
            yield("/wait 0.5")
            return
        end

        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        return
    end
end

function ProcessRetainers()
    CurrentFate = nil

    LogInfo("[FATE] Handling retainers...")
    if ARRetainersWaitingToBeProcessed() and GetInventoryFreeSlotCount() > 1 then
    
        if PathfindInProgress() or PathIsRunning() then
            return
        end

        if not IsInZone(129) then
            yield("/vnav stop")
            TeleportTo("リムサ・ロミンサ：下甲板層")
            return
        end

        local summoningBell = {
            x = -122.72,
            y = 18.00,
            z = 20.39
        }
        if GetDistanceToPoint(summoningBell.x, summoningBell.y, summoningBell.z) > 4.5 then
            PathfindAndMoveTo(summoningBell.x, summoningBell.y, summoningBell.z)
            return
        end

        if not HasTarget() or GetTargetName() ~= "呼び鈴" then
            yield("/target 呼び鈴")
            return
        end

        if not GetCharacterCondition(CharacterCondition.occupiedSummoningBell) then
            yield("/interact")
            if IsAddonVisible("RetainerList") then
                yield("/ays e")
                if Echo == "All" then
                    yield("/echo [FATE] Processing retainers")
                end
                yield("/wait 1")
            end
        end
    else
        if IsAddonVisible("RetainerList") then
            yield("/callback RetainerList true -1")
        elseif not GetCharacterCondition(CharacterCondition.occupiedSummoningBell) then
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        end
    end
end

function GrandCompanyTurnIn()
    if GetInventoryFreeSlotCount() <= InventorySlotsLeft then
        local playerGC = GetPlayerGC()
        local gcZoneIds = {
            128, --リムサ・ロミンサ：上甲板層
            132, --グリダニア：新市街
            130 --ウルダハ：ナル回廊
        }
        local GCVendor = { npcName="補給担当官", x=95.75, y=40.25, z=76.67 }
        if not IsInZone(gcZoneIds[playerGC]) then
            yield("/li gc")
            yield("/wait 1")
        elseif GetDistanceToPoint(GCVendor.x, GCVendor.y, GCVendor.z) > 4 then
            return
        elseif DeliverooIsTurnInRunning() then
            return
        else
            yield("/deliveroo enable")
        end
    else
        State = CharacterState.ready
        LogInfo("State Change: Ready")
    end
end

function Repair()
    if IsAddonVisible("SelectYesno") then
        yield("/callback SelectYesno true 0")
        return
    end

    if IsAddonVisible("Repair") then
        if not NeedsRepair(RepairAmount) then
            yield("/callback Repair true -1") -- if you don't need repair anymore, close the menu
        else
            yield("/callback Repair true 0") -- select repair
        end
        return
    end

    -- if occupied by repair, then just wait
    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) then
        LogInfo("[FATE] Repairing...")
        yield("/wait 1")
        return
    end
    
    local hawkersAlleyAethernetShard = { x=-213.95, y=15.99, z=49.35 }
    if SelfRepair then
        if GetItemCount(33916) > 0 then
            if IsAddonVisible("Shop") then
                yield("/callback Shop true -1")
                return
            end

            if not IsInZone(SelectedZone.zoneId) then
                TeleportTo(SelectedZone.aetheryteList[1].aetheryteName)
                return
            end

            if GetCharacterCondition(CharacterCondition.mounted) then
                Dismount()
                LogInfo("[FATE] State Change: Dismounting")
                return
            end

            if NeedsRepair(RepairAmount) then
                if not IsAddonVisible("Repair") then
                    LogInfo("[FATE] Opening repair menu...")
                    yield("/generalaction 修理")
                end
            else
                State = CharacterState.ready
                LogInfo("[FATE] State Change: Ready")
            end
        elseif ShouldAutoBuyDarkMatter then
            if not IsInZone(129) then
                if Echo == "All" then
                    yield("/echo Out of Dark Matter! Purchasing more from Limsa Lominsa.")
                end
                TeleportTo("リムサ・ロミンサ：下甲板層")
                return
            end

            local darkMatterVendor = { npcName="雑貨屋 ウンシンレール", x=-257.71, y=16.19, z=50.11, wait=0.08 }
            if GetDistanceToPoint(darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z) > (DistanceBetween(hawkersAlleyAethernetShard.x, hawkersAlleyAethernetShard.y, hawkersAlleyAethernetShard.z,darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z) + 10) then
                yield("/li マーケット（国際街広場）")
                yield("/wait 1") -- give it a moment to register
            elseif IsAddonVisible("TelepotTown") then
                yield("/callback TelepotTown false -1")
            elseif GetDistanceToPoint(darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z) > 5 then
                if not (PathfindInProgress() or PathIsRunning()) then
                    PathfindAndMoveTo(darkMatterVendor.x, darkMatterVendor.y, darkMatterVendor.z)
                end
            else
                if not HasTarget() or GetTargetName() ~= darkMatterVendor.npcName then
                    yield("/target "..darkMatterVendor.npcName)
                elseif not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent) then
                    yield("/interact")
                elseif IsAddonVisible("SelectYesno") then
                    yield("/callback SelectYesno true 0")
                elseif IsAddonVisible("Shop") then
                    yield("/callback Shop true 0 40 99")
                end
            end
        else
            if Echo == "All" then
                yield("/echo Out of Dark Matter and ShouldAutoBuyDarkMatter is false. Switching to Limsa mender.")
            end
            SelfRepair = false
        end
    else
        if NeedsRepair(RepairAmount) then
            if not IsInZone(129) then
                TeleportTo("リムサ・ロミンサ：下甲板層")
                return
            end

            local mender = { npcName="修理屋 アリステア", x=-246.87, y=16.19, z=49.83 }
            if GetDistanceToPoint(mender.x, mender.y, mender.z) > (DistanceBetween(hawkersAlleyAethernetShard.x, hawkersAlleyAethernetShard.y, hawkersAlleyAethernetShard.z, mender.x, mender.y, mender.z) + 10) then
                yield("/li マーケット（国際街広場）")
                yield("/wait 1") -- give it a moment to register
            elseif IsAddonVisible("TelepotTown") then
                yield("/callback TelepotTown false -1")
            elseif GetDistanceToPoint(mender.x, mender.y, mender.z) > 5 then
                if not (PathfindInProgress() or PathIsRunning()) then
                    PathfindAndMoveTo(mender.x, mender.y, mender.z)
                end
            else
                if not HasTarget() or GetTargetName() ~= mender.npcName then
                    yield("/target "..mender.npcName)
                elseif not GetCharacterCondition(CharacterCondition.occupiedInQuestEvent) then
                    yield("/interact")
                end
            end
        else
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        end
    end
end

function ExtractMateria()
    if GetCharacterCondition(CharacterCondition.mounted) then
        Dismount()
        LogInfo("[FATE] State Change: Dismounting")
        return
    end

    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) then
        return
    end

    if CanExtractMateria(100) and GetInventoryFreeSlotCount() > 1 then
        if not IsAddonVisible("Materialize") then
            yield("/gaction マテリア精製")
            return
        end

        LogInfo("[FATE] Extracting materia...")
            
        if IsAddonVisible("MaterializeDialog") then
            yield("/callback MaterializeDialog true 0")
        else
            yield("/callback Materialize true 2 0")
        end
    else
        if IsAddonVisible("Materialize") then
            yield("/callback Materialize true -1")
        else
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        end
    end
end

CharacterState = {
    ready = Ready,
    dead = HandleDeath,
    unexpectedCombat = HandleUnexpectedCombat,
    mounting = Mount,
    npcDismount = NPCDismount,
    middleOfFateDismount = MiddleOfFateDismount,
    moveToFate = MoveToFate,
    interactWithNpc = InteractWithFateNpc,
    collectionsFateTurnIn = CollectionsFateTurnIn,
    doFate = DoFate,
    waitForContinuation = WaitForContinuation,
    changingInstances = ChangeInstance,
    changeInstanceDismount = ChangeInstanceDismount,
    flyBackToAetheryte = FlyBackToAetheryte,
    extractMateria = ExtractMateria,
    repair = Repair,
    exchangingVouchers = ExecuteBicolorExchange,
    processRetainers = ProcessRetainers,
    gcTurnIn = GrandCompanyTurnIn,
    summonChocobo = SummonChocobo,
    autoBuyGysahlGreens = AutoBuyGysahlGreens
}

--#endregion State Transition Functions

--#region Main

LogInfo("[FATE] Starting fate farming script.")

StopScript = false
DidFate = false
GemAnnouncementLock = false
DeathAnnouncementLock = false
MovingAnnouncementLock = false
SuccessiveInstanceChanges = 0
LastInstanceChangeTimestamp = 0
LastTeleportTimeStamp = 0
GotCollectionsFullCredit = false -- needs 7 items for  full
-- variable to track collections fates that you have completed but are still active.
-- will not leave area or change instance if value ~= 0
WaitingForFateRewards = 0
LastFateEndTime = os.clock()
LastStuckCheckTime = os.clock()
LastStuckCheckPosition = {x=GetPlayerRawXPos(), y=GetPlayerRawYPos(), z=GetPlayerRawZPos()}
MainClass = GetClassJobTableFromId(GetClassJobId())
BossFatesClass = nil
if ClassForBossFates ~= "" then
    BossFatesClass = GetClassJobTableFromAbbrev(ClassForBossFates)
end
SetMaxDistance()

SelectedZone = SelectNextZone()
if SelectedZone.zoneName ~= "" and Echo == "All" then
    yield("/echo [FATE] Farming "..SelectedZone.zoneName)
end
LogInfo("[FATE] Farming Start for "..SelectedZone.zoneName)

for _, shop in ipairs(BicolorExchangeData) do
    for _, item in ipairs(shop.shopItems) do
        if item.itemName == ItemToPurchase then
            SelectedBicolorExchangeData = {
                shopKeepName = shop.shopKeepName,
                zoneId = shop.zoneId,
                aetheryteName = shop.aetheryteName,
                miniAethernet = shop.miniAethernet,
                x = shop.x, y = shop.y, z = shop.z,
                item = item
            }
        end
    end
end
if SelectedBicolorExchangeData == nil then
    yield("/echo [FATE] Cannot recognize bicolor shop item "..ItemToPurchase.."! Please make sure it's in the BicolorExchangeData table!")
    StopScript = true
end

State = CharacterState.ready
CurrentFate = nil
if IsInFate() and GetFateProgress(GetNearestFate()) < 100 then
    CurrentFate = BuildFateTable(GetNearestFate())
end

if ShouldSummonChocobo and GetBuddyTimeRemaining() > 0 then
    if GetZoneID() == 1190 or GetZoneID() == 1191 or GetZoneID() == 1192 then
        yield("/cac "..ChocoboStance)
    else
        yield("/cac アタッカースタンス")
    end
end

while not StopScript do
    if not NavIsReady() then
        yield("/echo [FATE] Waiting for vnavmesh to build...")
        LogInfo("[FATE] Waiting for vnavmesh to build...")
        repeat
            yield("/wait 1")
        until NavIsReady()
    end
        if State ~= CharacterState.dead and GetCharacterCondition(CharacterCondition.dead) then
            State = CharacterState.dead
            LogInfo("[FATE] State Change: Dead")
        elseif State ~= CharacterState.unexpectedCombat and State ~= CharacterState.doFate and
            State ~= CharacterState.waitForContinuation and State ~= CharacterState.collectionsFateTurnIn and
            (not IsInFate() or (IsInFate() and IsCollectionsFate(GetFateName(GetNearestFate())) and GetFateProgress(GetNearestFate()) == 100)) and
            GetCharacterCondition(CharacterCondition.inCombat)
        then
            State = CharacterState.unexpectedCombat
            LogInfo("[FATE] State Change: UnexpectedCombat")
        end
        
        BicolorGemCount = GetItemCount(26807)

        if not (IsPlayerCasting() or
            GetCharacterCondition(CharacterCondition.betweenAreas) or
            GetCharacterCondition(CharacterCondition.jumping48) or
            GetCharacterCondition(CharacterCondition.jumping61) or
            GetCharacterCondition(CharacterCondition.mounting57) or
            GetCharacterCondition(CharacterCondition.mounting64) or
            GetCharacterCondition(CharacterCondition.beingMoved) or
            GetCharacterCondition(CharacterCondition.occupiedMateriaExtractionAndRepair) or
            LifestreamIsBusy())
        then
            if WaitingForFateRewards ~= 0 and not IsFateActive(WaitingForFateRewards) then
                WaitingForFateRewards = 0
                LogInfo("[FATE] WaitingForFateRewards: "..tostring(WaitingForFateRewards))
            end
            State()
        end
    yield("/wait 0.1")
end
yield("/vnav stop")

if GetClassJobId() ~= MainClass.classId then
    yield("/gs change "..MainClass.className)
end
--#endregion Main