﻿--[=====[
[[SND Metadata]]
author: pot0to || updated by baanderson40
version: 3.0.10n
description: >-
  Fate farming script with the following features:
  - Can purchase Bicolor Gemstone Vouchers (both old and new) when your gemstones are almost capped
  - Priority system for Fate selection: distance w/ teleport > most progress > is bonus fate > least time left > distance
  - Will prioritize Forlorns when they show up during Fate
  - Can do all fates, including NPC collection fates
  - Revives upon death and gets back to fate farming
  - Attempts to change instances when there are no fates left in the zone
  - Can process your retainers and Grand Company turn ins, then get back to fate farming
  - Autobuys gysahl greens and grade 8 dark matter when you run out
  - Has companion scripts dedicated to atma farming, or you can write your own! (See section for companion scripts) Probably doesn't work.
plugin_dependencies:
- Lifestream
- vnavmesh
- TextAdvance
configs:
  General:
    default: false
    type: boolean
    description: "--- General Settings Section ---"

  Echo logs:
    default: Gems
    type: string
    description: |
      Supported values:
        - All
        - Gems
        - None

  Rotation Plugin:
    default: "Any"
    type: string
    description: |
      What roation plugin to use
      Supported values:
        - Any
        - Wrath
        - RotationSolver
        - BossMod
        - BossModReborn

  Dodging Plugin:
    default: "Any"
    type: string
    description: |
      What dodging plugin to use. If your Rotation plugin is BMR or VBM, this will be overriden.
      Supported values:
        - Any
        - BossMod
        - BossModReborn
        - None

  BMR/VBM Specific settings:
    default: false
    type: boolean
    description: "--- BMR/VBM Specific settings if you are using one of them as your rotation plugin ---"    
    
  Single Target Rotation:
    default: ""
    type: string
    description: Preset name with single strategies (for forlorns). TURN OFF AUTOMATIC TARGETING FOR THIS PRESET   

  AoE Rotation:
    default: ""
    type: string
    description: Preset with AoE and Buff Strategies.
    
  Hold Buff Rotation:
    default: ""
    type: string
    description: Preset to hold 2min burst when progress gets to select %

  Percentage to Hold Buff:
    default: 65
    type: int
    description: Ideally you want to make full use of your buffs, higher then 70% will still waste a few seconds if progress is too fast.

  Combat & Buffs:
    default: false
    type: boolean
    description: "--- Combat & Buffs Section ---"

  Food:
    default: 
    description: Leave blank if you dont want to use any food. If its HQ include <hq> next to the name "Baked Eggplant <hq>"
    type: string

  Potion:
    default:
    description: Leave blank if you dont want to use any potions. If its HQ include <hq> next to the name "Superior Spiritbond Potion <hq>"
    type: string

  Max melee distance:
    default: 2.5
    type: float
    min: 0
    max: 30
    required: true

  Max ranged distance:
    default: 20
    type: float
    min: 0
    max: 30
    required: true

  FATE Filtering:
    default: false
    type: boolean
    description: "--- FATE Filtering Section ---"

  Ignore FATE if progress is over (%):
    default: 80
    type: int
    min: 0
    max: 100
    required: true

  Ignore FATE if duration is less than (mins):
    default: 3
    type: int
    min: 0
    max: 100
    required: true

  Ignore boss FATEs until progress is at least (%):
    default: 0
    type: int
    min: 0
    max: 100
    required: true

  Ignore Special FATEs until progress is at least (%):
    default: 20
    type: int
    min: 0
    max: 100
    required: true

  Do collection FATEs?:
    default: true
    type: boolean

  Do only bonus FATEs?:
    default: false
    type: boolean

  Forlorns:
    default: All
    type: string
    description: |
      Forlorns to attack.
      Supported values:
        - All
        - Small
        - None
    required: true

  Change instances if no FATEs?:
    default: true
    type: boolean

  Randomly Move if no eligible Fate?:
    default: false
    description: Will automatically move after a fate if there are no eligible fates available.
    type: boolean

  Bicolor Exchange:
    default: false
    type: boolean
    description: "--- Bicolor Exchange Section ---"

  Exchange bicolor gemstones for:
    default: バイカラージェム納品証【黄金】
    type: string
    description: Leave blank if you dont want to spend your bicolors. See the bottom options for supported items.

  Mount & Chocobo:
    default: false
    type: boolean
    description: "--- Mount & Chocobo Section ---"

  Chocobo Companion Stance:
    default: "ヒーラースタンス"
    description: Options - Follow/Free/Defender/Healer/Attacker/None. Will not summon chocobo if set to "None"
    type: string

  Buy Gysahl Greens?:
    default: true
    description: Automatically buys a 99 stack of Gysahl Greens from the Limsa gil vendor if none in inventory
    type: boolean

  Maintenance:
    default: false
    type: boolean
    description: "--- Maintenance Section ---"

  Self repair?:
    default: true
    description: If checked, will attempt to repair your gear. If not checked, will go to Limsa mender.
    type: boolean

  Pause for retainers?:
    default: true
    type: boolean

  Dump extra gear at GC?:
    default: true
    type: boolean
    description: Used with retainers, in case they come back with too much stuff and clog your inventory.

  Death & Recovery:
    default: false
    type: boolean
    description: "--- Death & Recovery Section ---"

  Return on death?:
    default: true
    type: boolean
    description: Auto accept the box to return to home aetheryte when you die.

  Bicolor Gemstone Items:
    default: false
    type: boolean
    description: |
      Item name to select.  
      Supported values:
        - 暁月 **************************
        - バイカラージェム納品証【黄金】
        - アルマスティの毛
        - アームラ
        - エッグ・オブ・エルピス
        - オウヴィボスの乳
        - オピオタウロスの粗皮
        - ガジャの粗皮
        - クンビーラの粗皮
        - サイガの粗皮
        - ダイナマイトの灰
        - デュラミスシャード
        - ハンサの笹身
        - ブレスト・オブ・エルピス
        - ペタルダの鱗粉
        - ベルカナの樹液
        - マウンテンチキンの粗皮
        - ムースの肉
        - ヤーコウの肩肉
        - ルナテンダーの花
        - 黄金 **************************
        - バイカラージェム納品証【黄金】
        - アックスビークの翼膜
        - アルパカのフィレ肉
        - ガルガンチュアの粗皮
        - ゴンフォテリウムの粗皮
        - シルバリオの粗皮
        - スワンプモンクのモモ肉
        - タンブルクラブの枯草
        - チャイチャの刃爪
        - ノパルテンダーのトゥナ
        - ハンマーヘッドダイルの粗皮
        - ブラーシャの粗皮
        - ブランチベアラーの果実
        - ポイズンフロッグの粘液
        - メガマゲイの球茎
        - レッサーアポリオンの甲殻
        - ロネークの肩肉
        - ロネークの獣毛

[[End Metadata]]
--]=====]
--[[

********************************************************************************
*                                  Changelog                                   *
********************************************************************************

    -> 3.0.10   By baanderson40
            a   Max melee distance fix.
            b   WaitingForFateRewards fix.
            c   Removed HasPlugin and implemented IPC.IsInstalled from SND **reversed**.
            d   Removed Deliveroo and implemented AutoReainter GC Delievery.
            e   Swapped echo yields for Engines.Run.
            f   Added settions to config settings.
            g   Fixed unexpected Combat.
            h   Removed the remaining yields except for waits.
            i   Ready function optimized and refactord.
            j   Reworked Rotation and Dodging pluings.
            k   Fixed Materia Extraction
            l   Updated Config settings for BMR/VMR rotations
            m   Added option to move to random location after fate if none are eligible.
            n   Actually fixed WaitingForFateRewards & instance hopping.
    -> 3.0.9    By Allison.
                Fix standing in place after fate finishes bug.
                Add config options for Rotation Plugin and Dodging Plugin (Fixed bug when multiple solvers present at once)
                Update description to more accurately reflect script. 
                Cleaned up metadata + changed description to more accurately reflect script.
                Small change to combat related distance to target checks to more accurately reflect how FFXIV determines if abilities are usable (no height). Hopefully fixes some max distance checks during combat.
                Small Bugfixes.
    -> 3.0.6    Adding metadata
    -> 3.0.5    Fixed repair function
    -> 3.0.4    Remove noisy logging
    -> 3.0.2    Fixed HasPlugin check
    -> 3.0.1    Fixed typo causing it to crash
    -> 3.0.0    Updated for SND2

********************************************************************************
*                               Required Plugins                               *
********************************************************************************

Plugins that are needed for it to work:

    -> Something Need Doing [Expanded Edition] : (Main Plugin for everything to work)   https://puni.sh/api/repository/croizat
    -> VNavmesh :   (for Pathing/Moving)    https://puni.sh/api/repository/veyn
    -> Some form of rotation plugin for attacking enemies. Options are:
        -> RotationSolver Reborn: https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json       
        -> BossMod Reborn: https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
        -> Veyns BossMod: https://puni.sh/api/repository/veyn
        -> Wrath Combo: https://love.puni.sh/ment.json
    -> Some form of AI dodging. Options are: 
        -> BossMod Reborn: https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
        -> Veyns BossMod: https://puni.sh/api/repository/veyn
    -> TextAdvance: (for interacting with Fate NPCs) https://github.com/NightmareXIV/MyDalamudPlugins/raw/main/pluginmaster.json
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

--[[
********************************************************************************
*           Code: Dont touch this unless you know what youre doing           *
********************************************************************************
]]

import("System.Numerics")

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
        position=Vector3(78, 5, -37),
        shopItems =
        {
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
            { itemName = "マウンテンチキンの粗皮", itemIndex = 18, price = 2 },
            { itemName = "サイガの粗皮", itemIndex = 19, price = 2 },
            { itemName = "クンビーラの粗皮", itemIndex = 20, price = 2 },
            { itemName = "オピオタウロスの粗皮", itemIndex = 21, price = 2 },
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
        position=Vector3(-198.47, 0.92, -6.95),
        miniAethernet = {
            name = "ネクサスアーケード",
            position=Vector3(-157.74, 0.29, 17.43)
        },
        shopItems =
        {
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

--#region Utils
function mysplit(inputstr)
  for str in string.gmatch(inputstr, "[^%.]+") do
    return str
  end
end

function load_type(type_path)
    local assembly = mysplit(type_path)
    luanet.load_assembly(assembly)
    local type_var = luanet.import_type(type_path)
    return type_var
end

EntityWrapper = load_type('SomethingNeedDoing.LuaMacro.Wrappers.EntityWrapper')

function GetBuddyTimeRemaining()
    return Instances.Buddy.CompanionInfo.TimeLeft
end

function SetMapFlag(zoneId, position)
    Dalamud.Log("[FATE] Setting map flag to zone #"..zoneId..", (X: "..position.X..", "..position.Z.." )")
    Instances.Map.Flag:SetFlagMapMarker(zoneId, position.X, position.Z)
end

function GetZoneInstance()
    return InstancedContent.PublicInstance.InstanceId
end

function GetTargetName()
    if Svc.Targets.Target == nil then
        return ""
    else
        return Svc.Targets.Target.Name:GetText()
    end
end

function AttemptToTargetClosestFateEnemy()
    --Svc.Targets.Target = Svc.Objects.OrderBy(DistanceToObject).FirstOrDefault(o => o.IsTargetable && o.IsHostile() && !o.IsDead && (distance == 0 || DistanceToObject(o) <= distance) && o.Struct()->FateId > 0);
    local closestTarget = nil
    local closestTargetDistance = math.maxinteger
    for i=0, Svc.Objects.Length-1 do
        local obj = Svc.Objects[i]
        if obj ~= nil and obj.IsTargetable and obj:IsHostile() and
            not obj.IsDead and EntityWrapper(obj).FateId > 0
        then
                local dist = GetDistanceToPoint(obj.Position)
                if dist < closestTargetDistance then
                    closestTargetDistance = dist
                    closestTarget = obj
                end
        end
    end
    if closestTarget ~= nil then
        Svc.Targets.Target = closestTarget
    end
end

-- Calculates a point on the line from 'start' to 'end',
-- stopping 'd' units before reaching 'end'
function MoveToTargetHitbox()
    if Svc.Targets.Target == nil then
        return
    end

    -- Vector from start to end
    local distance = GetDistanceToTarget()

    -- Distance between start and end
    if distance == 0 then
        return
    end

    -- Scale direction vector to (distance - d)
    local newDistance = distance - GetTargetHitboxRadius()
    if newDistance <= 0 then
        return
    end

    -- Calculate normalized direction vector
    local norm = (Svc.Targets.Target.Position - Svc.ClientState.LocalPlayer.Position) / distance
    local edgeOfHitbox = (norm*newDistance) + Svc.ClientState.LocalPlayer.Position
    local newPos = nil
    local halfExt = 10
    while newPos == nil do
        newPos = IPC.vnavmesh.PointOnFloor(edgeOfHitbox, false, halfExt)
        halfExt = halfExt + 10
    end
    Engines.Run("/vnav moveto "..newPos.X.." "..newPos.Y.." "..newPos.Z)
end

function HasPlugin(name)
    for plugin in luanet.each(Svc.PluginInterface.InstalledPlugins) do
        if plugin.InternalName == name and plugin.IsLoaded then
            return true
        end
    end
    return false
end

--#endregion Utils

--#region Fate Functions
function IsCollectionsFate(fateName)
    for i, collectionsFate in ipairs(SelectedZone.fatesList.collectionsFates) do
        if collectionsFate.fateName == fateName then
            return true
        end
    end
    return false
end

function IsBossFate(fate)
    return fate.IconId == 60722
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

function IsFateActive(fate)
    if fate.State == nil then
        return false
    else
        return fate.State ~= FateState.Ending and fate.State ~= FateState.Ended and fate.State ~= FateState.Failed
    end
end

function InActiveFate()
    local activeFates = Fates.GetActiveFates()
    for i=0, activeFates.Count-1 do
        if activeFates[i].InFate == true and IsFateActive(activeFates[i]) then
            return true
        end
    end
    return false
end

function SelectNextZone()
    local nextZone = nil
    local nextZoneId = Svc.ClientState.TerritoryType

    for i, zone in ipairs(FatesData) do
        if nextZoneId == zone.zoneId then
            nextZone = zone
        end
    end
    if nextZone == nil then
        Engines.Run("/echo  [FATE] Current zone is only partially supported. No data on npc fates.")
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
    local aetherytes = GetAetherytesInZone(nextZone.zoneId)
    for _, aetheryte in ipairs(aetherytes) do
        local aetherytePos = Instances.Telepo:GetAetherytePosition(aetheryte.AetheryteId)
        local aetheryteTable = {
            aetheryteName = GetAetheryteName(aetheryte),
            aetheryteId = aetheryte.AetheryteId,
            position = aetherytePos,
            aetheryteObj = aetheryte
        }
        table.insert(nextZone.aetheryteList, aetheryteTable)
    end

    if nextZone.flying == nil then
        nextZone.flying = true
    end

    return nextZone
end

function BuildFateTable(fateObj)
    Dalamud.Log("[FATE] Enter->BuildFateTable")
    local fateTable = {
        fateObject = fateObj,
        fateId = fateObj.Id,
        fateName = fateObj.Name,
        duration = fateObj.Duration,
        startTime = fateObj.StartTimeEpoch,
        position = fateObj.Location,
        isBonusFate = fateObj.IsBonus,
    }

    fateTable.npcName = GetFateNpcName(fateTable.fateName)

    local currentTime = EorzeaTimeToUnixTime(Instances.Framework.EorzeaTime)
    if fateTable.startTime == 0 then
        fateTable.timeLeft = 900
    else
        fateTable.timeElapsed = currentTime - fateTable.startTime
        fateTable.timeLeft = fateTable.duration - fateTable.timeElapsed
    end

    fateTable.isCollectionsFate = IsCollectionsFate(fateTable.fateName)
    fateTable.isBossFate = IsBossFate(fateTable.fateObject)
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

--[[
    Selects the better fate based on the priority order defined in FatePriority.
    Default Priority order is "DistanceTeleport" -> "Progress" -> "Bonus" -> "TimeLeft" -> "Distance"
]]
function SelectNextFateHelper(tempFate, nextFate)
    if nextFate == nil then
        Dalamud.Log("[FATE] nextFate is nil")
        return tempFate
    elseif BonusFatesOnly then
        Dalamud.Log("[FATE] only doing bonus fates")
        --Check if WaitForBonusIfBonusBuff is true, and have eithe buff, then set BonusFatesOnlyTemp to true
        if not tempFate.isBonusFate and nextFate ~= nil and nextFate.isBonusFate then
            return nextFate
        elseif tempFate.isBonusFate and (nextFate == nil or not nextFate.isBonusFate) then
            return tempFate
        elseif not tempFate.isBonusFate and (nextFate == nil or not nextFate.isBonusFate) then
            return nil
        end
        -- if both are bonus fates, go through the regular fate selection process
    end

    if tempFate.timeLeft < MinTimeLeftToIgnoreFate or tempFate.fateObject.Progress > CompletionToIgnoreFate then
        Dalamud.Log("[FATE] Ignoring fate #"..tempFate.fateId.." due to insufficient time or high completion.")
        return nextFate
    elseif nextFate == nil then
        Dalamud.Log("[FATE] Selecting #"..tempFate.fateId.." because no other options so far.")
        return tempFate
    elseif nextFate.timeLeft < MinTimeLeftToIgnoreFate or nextFate.fateObject.Progress > CompletionToIgnoreFate then
        Dalamud.Log("[FATE] Ignoring fate #"..nextFate.fateId.." due to insufficient time or high completion.")
        return tempFate
    end

    -- Evaluate based on priority (Loop through list return first non-equal priority)
    for _, criteria in ipairs(FatePriority) do
        if criteria == "Progress" then
            Dalamud.Log("[FATE] Comparing progress: "..tempFate.fateObject.Progress.." vs "..nextFate.fateObject.Progress)
            if tempFate.fateObject.Progress > nextFate.fateObject.Progress then return tempFate end
            if tempFate.fateObject.Progress < nextFate.fateObject.Progress then return nextFate end
        elseif criteria == "Bonus" then
            Dalamud.Log("[FATE] Checking bonus status: "..tostring(tempFate.isBonusFate).." vs "..tostring(nextFate.isBonusFate))
            if tempFate.isBonusFate and not nextFate.isBonusFate then return tempFate end
            if nextFate.isBonusFate and not tempFate.isBonusFate then return nextFate end
        elseif criteria == "TimeLeft" then
            Dalamud.Log("[FATE] Comparing time left: "..tempFate.timeLeft.." vs "..nextFate.timeLeft)
            if tempFate.timeLeft > nextFate.timeLeft then return tempFate end
            if tempFate.timeLeft < nextFate.timeLeft then return nextFate end
        elseif criteria == "Distance" then
            local tempDist = GetDistanceToPoint(tempFate.position)
            local nextDist = GetDistanceToPoint(nextFate.position)
            Dalamud.Log("[FATE] Comparing distance: "..tempDist.." vs "..nextDist)
            if tempDist < nextDist then return tempFate end
            if tempDist > nextDist then return nextFate end
        elseif criteria == "DistanceTeleport" then
            local tempDist = GetDistanceToPointWithAetheryteTravel(tempFate.position)
            local nextDist = GetDistanceToPointWithAetheryteTravel(nextFate.position)
            Dalamud.Log("[FATE] Comparing distance: "..tempDist.." vs "..nextDist)
            if tempDist < nextDist then return tempFate end
            if tempDist > nextDist then return nextFate end
        end
    end

    -- Fallback: Select fate with the lower ID
    Dalamud.Log("[FATE] Selecting lower ID fate: "..tempFate.fateId.." vs "..nextFate.fateId)
    return (tempFate.fateId < nextFate.fateId) and tempFate or nextFate
end

--Gets the Location of the next Fate. Prioritizes anything with progress above 0, then by shortest time left
function SelectNextFate()
    local fates = Fates.GetActiveFates()
    if fates == nil then
        return
    end

    local nextFate = nil
    for i = 0, fates.Count-1 do
        Dalamud.Log("[FATE] Building fate table")
        local tempFate = BuildFateTable(fates[i])
        Dalamud.Log("[FATE] Considering fate #"..tempFate.fateId.." "..tempFate.fateName)
        Dalamud.Log("[FATE] Time left on fate #:"..tempFate.fateId..": "..math.floor(tempFate.timeLeft//60).."min, "..math.floor(tempFate.timeLeft%60).."s")

        if not (tempFate.position.X == 0 and tempFate.position.Z == 0) then -- sometimes game doesnt send the correct coords
            if not tempFate.isBlacklistedFate then -- check fate is not blacklisted for any reason
                if tempFate.isBossFate then
                    Dalamud.Log("[FATE] Is a boss fate")
                    if (tempFate.isSpecialFate and tempFate.fateObject.Progress >= CompletionToJoinSpecialBossFates) or
                        (not tempFate.isSpecialFate and tempFate.fateObject.Progress >= CompletionToJoinBossFate) then
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    else
                        Dalamud.Log("[FATE] Skipping fate #"..tempFate.fateId.." "..tempFate.fateName.." due to boss fate with not enough progress.")
                    end
                elseif (tempFate.isOtherNpcFate or tempFate.isCollectionsFate) and tempFate.startTime == 0 then
                    Dalamud.Log("[FATE] Is not an npc or collections fate")
                    if nextFate == nil then -- pick this if theres nothing else
                        Dalamud.Log("[FATE] Selecting this fate because there's nothing else so far")
                        nextFate = tempFate
                    elseif tempFate.isBonusFate then
                        Dalamud.Log("[FATE] tempFate.isBonusFate")
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    elseif nextFate.startTime == 0 then -- both fates are unopened npc fates
                        Dalamud.Log("[FATE] Both fates are unopened npc fates")
                        nextFate = SelectNextFateHelper(tempFate, nextFate)
                    else
                        Dalamud.Log("[FATE] else")
                    end
                elseif tempFate.duration ~= 0 then -- else is normal fate. avoid unlisted talk to npc fates
                    Dalamud.Log("[FATE] Normal fate")
                    nextFate = SelectNextFateHelper(tempFate, nextFate)
                else
                    Dalamud.Log("[FATE] Fate duration was zero.")
                end
                Dalamud.Log("[FATE] Finished considering fate #"..tempFate.fateId.." "..tempFate.fateName)
            else
                Dalamud.Log("[FATE] Skipping fate #"..tempFate.fateId.." "..tempFate.fateName.." due to blacklist.")
            end
        else
            Dalamud.Log("[FATE] FATE coords were zeroed out")
        end
    
    end

    Dalamud.Log("[FATE] Finished considering all fates")
    if nextFate == nil then
        Dalamud.Log("[FATE] No eligible fates found.")
        if Echo == "all" then
            Engines.Run("/echo  [FATE] No eligible fates found.")
        end
    else
        Dalamud.Log("[FATE] Final selected fate #"..nextFate.fateId.." "..nextFate.fateName)
    end
    yield("/wait 0.211")
    return nextFate
end

function AcceptNPCFateOrRejectOtherYesno()
    if Addons.GetAddon("SelectYesno").Ready then
        local dialogBox = GetNodeText("SelectYesno", 1, 2)
        if type(dialogBox) == "string" and dialogBox:find("The recommended level for this FATE is") then
            Engines.Run("/callback SelectYesno true 0") --accept fate
        else
            Engines.Run("/callback SelectYesno true 1") --decline all other boxes
        end
    end
end

--#endregion Fate Functions

--#region Movement Functions

function DistanceBetween(pos1, pos2)
    return Vector3.Distance(pos1, pos2)
end

function GetDistanceToPoint(vec3)
    return DistanceBetween(Svc.ClientState.LocalPlayer.Position, vec3)
end

function GetDistanceToTarget()
    if Svc.Targets.Target ~= nil then
        return GetDistanceToPoint(Svc.Targets.Target.Position)
    else
        return math.maxinteger
    end
end

function GetDistanceToTargetFlat()
    if Svc.Targets.Target ~= nil then
        return GetDistanceToPointFlat(Svc.Targets.Target.Position)
    else
        return math.maxinteger
    end
end

function GetDistanceToPointFlat(vec3)
    return DistanceBetweenFlat(Svc.ClientState.LocalPlayer.Position, vec3)
end

function DistanceBetweenFlat(pos1, pos2)
    local flat1 = Vector3(pos1.X, 0, pos1.Z)
    local flat2 = Vector3(pos2.X, 0, pos2.Z)
    return Vector3.Distance(flat1, flat2)
end

function RandomAdjustCoordinates(position, maxDistance)
    local angle = math.random() * 2 * math.pi
    local x_adjust = maxDistance * math.random()
    local z_adjust = maxDistance * math.random()

    local randomX = position.X + (x_adjust * math.cos(angle))
    local randomY = position.Y + maxDistance
    local randomZ = position.Z + (z_adjust * math.sin(angle))

    return Vector3(randomX, randomY, randomZ)
end

function GetAetherytesInZone(zoneId)
    local aetherytesInZone = {}
    for _, aetheryte in ipairs(Svc.AetheryteList) do
        if aetheryte.TerritoryId == zoneId then
            table.insert(aetherytesInZone, aetheryte)
        end
    end
    return aetherytesInZone
end

function GetAetheryteName(aetheryte)
    local name = aetheryte.AetheryteData.Value.PlaceName.Value.Name:GetText()
    if name == nil then
        return ""
    else
        return name
    end
end

function DistanceFromClosestAetheryteToPoint(vec3, teleportTimePenalty)
    local closestAetheryte = nil
    local closestTravelDistance = math.maxinteger
    for _, aetheryte in ipairs(SelectedZone.aetheryteList) do
        local distanceAetheryteToFate = DistanceBetween(aetheryte.position, vec3)
        local comparisonDistance = distanceAetheryteToFate + teleportTimePenalty
        Dalamud.Log("[FATE] Distance via "..aetheryte.aetheryteName.." adjusted for tp penalty is "..tostring(comparisonDistance))

        if comparisonDistance < closestTravelDistance then
            Dalamud.Log("[FATE] Updating closest aetheryte to "..aetheryte.aetheryteName)
            closestTravelDistance = comparisonDistance
            closestAetheryte = aetheryte
        end
    end

    return closestTravelDistance
end

function GetDistanceToPointWithAetheryteTravel(vec3)
    -- Get the direct flight distance (no aetheryte)
    local directFlightDistance = GetDistanceToPoint(vec3)
    Dalamud.Log("[FATE] Direct flight distance is: " .. directFlightDistance)

    -- Get the distance to the closest aetheryte, including teleportation penalty
    local distanceToAetheryte = DistanceFromClosestAetheryteToPoint(vec3, 200)
    Dalamud.Log("[FATE] Distance via closest Aetheryte is: " .. (distanceToAetheryte or "nil"))

    -- Return the minimum distance, either via direct flight or via the closest aetheryte travel
    if distanceToAetheryte == nil then
        return directFlightDistance
    else
        return math.min(directFlightDistance, distanceToAetheryte)
    end
end

function GetClosestAetheryte(position, teleportTimePenalty)
    local closestAetheryte = nil
    local closestTravelDistance = math.maxinteger
    for _, aetheryte in ipairs(SelectedZone.aetheryteList) do
        Dalamud.Log("[FATE] Considering aetheryte "..aetheryte.aetheryteName)
        local distanceAetheryteToFate = DistanceBetween(aetheryte.position, position)
        local comparisonDistance = distanceAetheryteToFate + teleportTimePenalty
        Dalamud.Log("[FATE] Distance via "..aetheryte.aetheryteName.." adjusted for tp penalty is "..tostring(comparisonDistance))

        if comparisonDistance < closestTravelDistance then
            Dalamud.Log("[FATE] Updating closest aetheryte to "..aetheryte.aetheryteName)
            closestTravelDistance = comparisonDistance
            closestAetheryte = aetheryte
        end
    end
    if closestAetheryte ~= nil then
        Dalamud.Log("[FATE] Final selected aetheryte is: "..closestAetheryte.aetheryteName)
    else
        Dalamud.Log("[FATE] Closest aetheryte is nil")
    end

    return closestAetheryte
end

function GetClosestAetheryteToPoint(position, teleportTimePenalty)
    local directFlightDistance = GetDistanceToPoint(position)
    Dalamud.Log("[FATE] Direct flight distance is: "..directFlightDistance)
    local closestAetheryte = GetClosestAetheryte(position, teleportTimePenalty)
    if closestAetheryte ~= nil then
        local closestAetheryteDistance = DistanceBetween(position, closestAetheryte.position) + teleportTimePenalty

        if closestAetheryteDistance < directFlightDistance then
            return closestAetheryte
        end
    end
    return nil
end

function TeleportToClosestAetheryteToFate(nextFate)
    local aetheryteForClosestFate = GetClosestAetheryteToPoint(nextFate.position, 200)
    if aetheryteForClosestFate ~=nil then
        TeleportTo(aetheryteForClosestFate.aetheryteName)
        return true
    end
    return false
end

function AcceptTeleportOfferLocation(destinationAetheryte)
    if Addons.GetAddon("_NotificationTelepo").Ready then
        local location = GetNodeText("_NotificationTelepo", 3, 4)
        Engines.Run("/callback _Notification true 0 16 "..location)
        yield("/wait 1")
    end

    if Addons.GetAddon("SelectYesno").Ready then
        local teleportOfferMessage = GetNodeText("SelectYesno", 1, 2)
        if type(teleportOfferMessage) == "string" then
            local teleportOfferLocation = teleportOfferMessage:match("Accept Teleport to (.+)%?")
            if teleportOfferLocation ~= nil then
                if string.lower(teleportOfferLocation) == string.lower(destinationAetheryte) then
                    Engines.Run("/callback SelectYesno true 0") -- accept teleport
                    return
                else
                    Dalamud.Log("Offer for "..teleportOfferLocation.." and destination "..destinationAetheryte.." are not the same. Declining teleport.")
                end
            end
            Engines.Run("/callback SelectYesno true 2") -- decline teleport
            return
        end
    end
end

function TeleportTo(aetheryteName)
    AcceptTeleportOfferLocation(aetheryteName)
    local start = os.clock()

    while EorzeaTimeToUnixTime(Instances.Framework.EorzeaTime) - LastTeleportTimeStamp < 5 do
        Dalamud.Log("[FATE] Too soon since last teleport. Waiting...")
        yield("/wait 5.001")
        if os.clock() - start > 30 then
            Engines.Run("/echo  [FATE] Teleport failed: Timeout waiting before cast.")
            return false
        end
    end

    Engines.Run("/li tp "..aetheryteName)
    yield("/wait 1")
    while Svc.Condition[CharacterCondition.casting] do
        Dalamud.Log("[FATE] Casting teleport...")
        yield("/wait 1")
        if os.clock() - start > 60 then
            Engines.Run("/echo  [FATE] Teleport failed: Timeout during cast.")
            return false
        end
    end
    yield("/wait 1")
    while Svc.Condition[CharacterCondition.betweenAreas] do
        Dalamud.Log("[FATE] Teleporting...")
        yield("/wait 1")
        if os.clock() - start > 120 then
            Engines.Run("/echo  [FATE] Teleport failed: Timeout during zone transition.")
            return false
        end
    end
    yield("/wait 1")
    LastTeleportTimeStamp = EorzeaTimeToUnixTime(Instances.Framework.EorzeaTime)
    HasFlownUpYet = false
    return true
end

function ChangeInstance()
    if SuccessiveInstanceChanges >= NumberOfInstances then
        if CompanionScriptMode then
            local shouldWaitForBonusBuff = WaitIfBonusBuff and (HasStatusId(1288) or HasStatusId(1289))
            if WaitingForFateRewards == nil and not shouldWaitForBonusBuff then
                StopScript = true
            else
                Dalamud.Log("[Fate Farming] Waiting for buff or fate rewards")
                yield("/wait 3")
            end
        else
            yield("/wait 10")
            SuccessiveInstanceChanges = 0
        end
        return
    end

    yield("/target エーテライト") -- search for nearby aetheryte
    if Svc.Targets.Target == nil or GetTargetName() ~= "エーテライト" then -- if no aetheryte within targeting range, teleport to it
        Dalamud.Log("[FATE] Aetheryte not within targetable range")
        local closestAetheryte = nil
        local closestAetheryteDistance = math.maxinteger
        for i, aetheryte in ipairs(SelectedZone.aetheryteList) do
            -- GetDistanceToPoint is implemented with raw distance instead of distance squared
            local distanceToAetheryte = GetDistanceToPoint(aetheryte.position)
            if distanceToAetheryte < closestAetheryteDistance then
                closestAetheryte = aetheryte
                closestAetheryteDistance = distanceToAetheryte
            end
        end
        if closestAetheryte ~= nil then
            TeleportTo(closestAetheryte.aetheryteName)
        end
        return
    end

    if WaitingForFateRewards ~= nil then
        yield("/wait 10")
        return
    end

    if GetDistanceToTarget() > 10 then
        Dalamud.Log("[FATE] Targeting aetheryte, but greater than 10 distance")
        if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
            if Svc.Condition[CharacterCondition.flying] and SelectedZone.flying then
                yield("/vnav flytarget")
            else
                yield("/vnav movetarget")
            end
        elseif GetDistanceToTarget() > 20 and not Svc.Condition[CharacterCondition.mounted] then
            State = CharacterState.mounting
            Dalamud.Log("[FATE] State Change: Mounting")
        end
        return
    end

    Dalamud.Log("[FATE] Within 10 distance")
    if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
        yield("/vnav stop")
        return
    end

    if Svc.Condition[CharacterCondition.mounted] then
        State = CharacterState.changeInstanceDismount
        Dalamud.Log("[FATE] State Change: ChangeInstanceDismount")
        return
    end

    Dalamud.Log("[FATE] Transferring to next instance")
    local nextInstance = (GetZoneInstance() % 2) + 1
    yield("/li "..nextInstance) -- start instance transfer
    yield("/wait 1") -- wait for instance transfer to register
    State = CharacterState.ready
    SuccessiveInstanceChanges = SuccessiveInstanceChanges + 1
    Dalamud.Log("[FATE] State Change: Ready")
end

function WaitForContinuation()
    if InActiveFate() then
        Dalamud.Log("WaitForContinuation IsInFate")
        local nextFateId = Fates.GetNearestFate()
        if nextFateId ~= CurrentFate.fateObject then
            CurrentFate = BuildFateTable(nextFateId)
            State = CharacterState.doFate
            Dalamud.Log("[FATE] State Change: DoFate")
        end
    elseif os.clock() - LastFateEndTime > 30 then
        Dalamud.Log("WaitForContinuation Abort")
        Dalamud.Log("Over 30s since end of last fate. Giving up on part 2.")
        TurnOffCombatMods()
        State = CharacterState.ready
        Dalamud.Log("State Change: Ready")
    else
        Dalamud.Log("WaitForContinuation Else")
        if BossFatesClass ~= nil then
            local currentClass = Player.Job.Id
            Dalamud.Log("WaitForContinuation "..CurrentFate.fateName)
            if not Player.IsPlayerOccupied then
                if CurrentFate.continuationIsBoss and currentClass ~= BossFatesClass.classId then
                    Dalamud.Log("WaitForContinuation SwitchToBoss")
                    Engines.Run("/gs change "..BossFatesClass.className)
                elseif not CurrentFate.continuationIsBoss and currentClass ~= MainClass.classId then
                    Dalamud.Log("WaitForContinuation SwitchToMain")
                    Engines.Run("/gs change "..MainClass.className)
                end
            end
        end

        yield("/wait 1")
    end
end

function FlyBackToAetheryte()
    NextFate = SelectNextFate()
    if NextFate ~= nil then
        Engines.Run("/vnav stop")
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        return
    end

    local closestAetheryte = GetClosestAetheryte(Svc.ClientState.LocalPlayer.Position, 0)
    if closestAetheryte == nil then
        DownTimeWaitAtNearestAetheryte = false
        Engines.Run("/echo  Could not find aetheryte in the area. Turning off feature to fly back to aetheryte.")
        return
    end
    -- if you get any sort of error while flying back, then just abort and tp back
    if Addons.GetAddon("_TextError").Ready and GetNodeText("_TextError", 1) == "Your mount can fly no higher." then
        Engines.Run("/vnav stop")
        TeleportTo(closestAetheryte.aetheryteName)
        return
    end

    Engines.Run("/target エーテライト")

    if Svc.Targets.Target ~= nil and GetTargetName() == "エーテライト" and GetDistanceToTarget() <= 20 then
        if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
            Engines.Run("/vnav stop")
        end

        if Svc.Condition[CharacterCondition.flying] then
            Engines.Run("/gaction 降りる") -- land but dont actually dismount, to avoid running chocobo timer
        elseif Svc.Condition[CharacterCondition.mounted] then
            State = CharacterState.ready
            Dalamud.Log("[FATE] State Change: Ready")
        else
            if MountToUse == "mount roulette" then
                Engines.Run("/gaction マウント・ルーレット")
            else
                Engines.Run("/mount " .. MountToUse)
            end
        end
        return
    end
    
    if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
        Dalamud.Log("[FATE] ClosestAetheryte.y: "..closestAetheryte.position.Y)
        if closestAetheryte ~= nil then
            SetMapFlag(SelectedZone.zoneId, closestAetheryte.position)
            IPC.vnavmesh.PathfindAndMoveTo(closestAetheryte.position, Svc.Condition[CharacterCondition.flying] and SelectedZone.flying)
        end
    end

    if not Svc.Condition[CharacterCondition.mounted] then
        Mount()
        return
    end
end

HasFlownUpYet = false
function MoveToRandomNearbySpot(minDist, maxDist)
    local playerPos = Svc.ClientState.LocalPlayer.Position
    local angle = math.random() * 2 * math.pi
    local distance = minDist + math.random() * (maxDist - minDist)
    local dx = math.cos(angle) * distance
    local dz = math.sin(angle) * distance
    local yOffset = 0
    if not HasFlownUpYet then
        -- Always fly upward significantly the first time
        yOffset = 25 + math.random() * 15  -- +25 to +40
        HasFlownUpYet = true
    else
        yOffset = (math.random() * 30) - 15  -- -15 to +15
    end
    local targetPos = Vector3(playerPos.X + dx, playerPos.Y + yOffset, playerPos.Z + dz)
    if not Svc.Condition[CharacterCondition.mounted] then
        Mount()
        yield("/wait 2")
    end
    IPC.vnavmesh.PathfindAndMoveTo(targetPos, true)
    Engines.Run("/echo  [FATE] Moving to a random location while waiting...")
end

function Mount()
    if MountToUse == "mount roulette" then
        Engines.Run("/gaction マウント・ルーレット")
    else
        Engines.Run("/mount " .. MountToUse)
    end
    yield("/wait 1")
end

function MountState()
    if Svc.Condition[CharacterCondition.mounted] then
        yield("/wait 1") -- wait a second to make sure youre firmly on the mount
        State = CharacterState.moveToFate
        Dalamud.Log("[FATE] State Change: MoveToFate")
    else
        Mount()
    end
end

function Dismount()
    if Svc.Condition[CharacterCondition.flying] then
        Engines.Run("/gaction 降りる")

        local now = os.clock()
        if now - LastStuckCheckTime > 1 then

            if Svc.Condition[CharacterCondition.flying] and GetDistanceToPoint(LastStuckCheckPosition) < 2 then
                Dalamud.Log("[FATE] Unable to dismount here. Moving to another spot.")
                local random = RandomAdjustCoordinates(Svc.ClientState.LocalPlayer.Position, 10)
                local nearestFloor = IPC.vnavmesh.PointOnFloor(random, true, 100)
                if nearestFloor ~= nil then
                    IPC.vnavmesh.PathfindAndMoveTo(nearestFloor, Svc.Condition[CharacterCondition.flying] and SelectedZone.flying)
                    yield("/wait 1")
                end
            end

            LastStuckCheckTime = now
            LastStuckCheckPosition = Svc.ClientState.LocalPlayer.Position
        end
    elseif Svc.Condition[CharacterCondition.mounted] then
        Engines.Run("/gaction 降りる")
    end
end

function MiddleOfFateDismount()
    if not IsFateActive(CurrentFate.fateObject) then
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        return
    end

    if Svc.Targets.Target ~= nil then
        if GetDistanceToTarget() > (MaxDistance + GetTargetHitboxRadius() + 5) then
            if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                Dalamud.Log("[FATE] MiddleOfFateDismount IPC.vnavmesh.PathfindAndMoveTo")
                if Svc.Condition[CharacterCondition.flying] then
                    Engines.Run("/vnav flytarget")
                else
                    Engines.Run("/vnav movetarget")
                end
            end
        else
            if Svc.Condition[CharacterCondition.mounted] then
                Dalamud.Log("[FATE] MiddleOfFateDismount Dismount()")
                Dismount()
            else
                Engines.Run("/vnav stop")
                State = CharacterState.doFate
                Dalamud.Log("[FATE] State Change: DoFate")
            end
        end
    else
        AttemptToTargetClosestFateEnemy()
    end
end

function NpcDismount()
    if Svc.Condition[CharacterCondition.mounted] then
        Dismount()
    else
        State = CharacterState.interactWithNpc
        Dalamud.Log("[FATE] State Change: InteractWithFateNpc")
    end
end

function ChangeInstanceDismount()
    if Svc.Condition[CharacterCondition.mounted] then
        Dismount()
    else
        State = CharacterState.changingInstances
        Dalamud.Log("[FATE] State Change: ChangingInstance")
    end
end

--Paths to the Fate NPC Starter
function MoveToNPC()
    Engines.Run("/target "..CurrentFate.npcName)
    if Svc.Targets.Target ~= nil and GetTargetName()==CurrentFate.npcName then
        if GetDistanceToTarget() > 5 then
            Engines.Run("/vnav movetarget")
        end
    end
end

--Paths to the Fate. CurrentFate is set here to allow MovetoFate to change its mind,
--so CurrentFate is possibly nil.
function MoveToFate()
    SuccessiveInstanceChanges = 0

    if not Player.Available then
        return
    end

    if CurrentFate~=nil and not IsFateActive(CurrentFate.fateObject) then
        Dalamud.Log("[FATE] Next Fate is dead, selecting new Fate.")
        Engines.Run("/vnav stop")
        MovingAnnouncementLock = false
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        return
    end

    NextFate = SelectNextFate()
    if NextFate == nil then -- when moving to next fate, CurrentFate == NextFate
        Engines.Run("/vnav stop")
        MovingAnnouncementLock = false
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        return
    elseif CurrentFate == nil or NextFate.fateId ~= CurrentFate.fateId then
        Engines.Run("/vnav stop")
        CurrentFate = NextFate
        SetMapFlag(SelectedZone.zoneId, CurrentFate.position)
        return
    end

    -- change to secondary class if its a boss fate
    if BossFatesClass ~= nil then
        local currentClass = Player.Job.Id
        if CurrentFate.isBossFate and currentClass ~= BossFatesClass.classId then
            Engines.Run("/gs change "..BossFatesClass.className)
            return
        elseif not CurrentFate.isBossFate and currentClass ~= MainClass.classId then
            Engines.Run("/gs change "..MainClass.className)
            return
        end
    end

    -- upon approaching fate, pick a target and switch to pathing towards target
    if GetDistanceToPoint(CurrentFate.position) < 60 then
        if Svc.Targets.Target ~= nil then
            Dalamud.Log("[FATE] Found FATE target, immediate rerouting")
            yield("/wait 0.1")
            MoveToTargetHitbox()
            if (CurrentFate.isOtherNpcFate or CurrentFate.isCollectionsFate) then
                State = CharacterState.interactWithNpc
                Dalamud.Log("[FATE] State Change: Interact with npc")
            -- if GetTargetName() == CurrentFate.npcName then
            --     State = CharacterState.interactWithNpc
            -- elseif GetTargetFateID() == CurrentFate.fateId then
            --     State = CharacterState.middleOfFateDismount
            --     Dalamud.Log("[FATE] State Change: MiddleOfFateDismount")
            else
                State = CharacterState.MiddleOfFateDismount
                Dalamud.Log("[FATE] State Change: MiddleOfFateDismount")
            end
            return
        else
            if (CurrentFate.isOtherNpcFate or CurrentFate.isCollectionsFate) and not InActiveFate() then
                Engines.Run("/target "..CurrentFate.npcName)
            else
                AttemptToTargetClosestFateEnemy()
            end
            yield("/wait 0.5") -- give it a moment to make sure the target sticks
            return
        end
    end

    -- check for stuck
    if (IPC.vnavmesh.IsRunning() or IPC.vnavmesh.PathfindInProgress()) and Svc.Condition[CharacterCondition.mounted] then
        local now = os.clock()
        if now - LastStuckCheckTime > 10 then

            if GetDistanceToPoint(LastStuckCheckPosition) < 3 then
                Engines.Run("/vnav stop")
                yield("/wait 1")
                Dalamud.Log("[FATE] Antistuck")
                local up10 = Svc.ClientState.LocalPlayer.Position + Vector3(0, 10, 0)
                IPC.vnavmesh.PathfindAndMoveTo(up10, Svc.Condition[CharacterCondition.flying] and SelectedZone.flying) -- fly up 10 then try again
            end
            
            LastStuckCheckTime = now
            LastStuckCheckPosition = Svc.ClientState.LocalPlayer.Position
        end
        return
    end

    if not MovingAnnouncementLock then
        Dalamud.Log("[FATE] Moving to fate #"..CurrentFate.fateId.." "..CurrentFate.fateName)
        MovingAnnouncementLock = true
        if Echo == "all" then
            Engines.Run("/echo  [FATE] Moving to fate #"..CurrentFate.fateId.." "..CurrentFate.fateName)
        end
    end

    if TeleportToClosestAetheryteToFate(CurrentFate) then
        Dalamud.Log("Executed teleport to closer aetheryte")
        return
    end

    local nearestFloor = CurrentFate.position
    if not (CurrentFate.isCollectionsFate or CurrentFate.isOtherNpcFate) then
        nearestFloor = RandomAdjustCoordinates(CurrentFate.position, 10)
    end

    if GetDistanceToPoint(nearestFloor) > 5 then
        if not Svc.Condition[CharacterCondition.mounted] then
            State = CharacterState.mounting
            Dalamud.Log("[FATE] State Change: Mounting")
            return
        elseif not IPC.vnavmesh.PathfindInProgress() and not IPC.vnavmesh.IsRunning() then
            if Player.CanFly and SelectedZone.flying then
                Engines.Run("/vnav flyflag")
            else
                Engines.Run("/vnav moveflag")
            end
        end
    else
        State = CharacterState.MiddleOfFateDismount
    end
end

function InteractWithFateNpc()
    if InActiveFate() or CurrentFate.startTime > 0 then
        Engines.Run("/vnav stop")
        State = CharacterState.doFate
        Dalamud.Log("[FATE] State Change: DoFate")
        yield("/wait 1") -- give the fate a second to register before dofate and lsync
    elseif not IsFateActive(CurrentFate.fateObject) then
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
    elseif IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
        if Svc.Targets.Target ~= nil and GetTargetName() == CurrentFate.npcName and GetDistanceToTarget() < (5*math.random()) then
            Engines.Run("/vnav stop")
        end
        return
    else
        -- if target is already selected earlier during pathing, avoids having to target and move again
        if (Svc.Targets.Target == nil or GetTargetName()~=CurrentFate.npcName) then
            Engines.Run("/target "..CurrentFate.npcName)
            return
        end

        if Svc.Condition[CharacterCondition.mounted] then
            State = CharacterState.npcDismount
            Dalamud.Log("[FATE] State Change: NPCDismount")
            return
        end

        if GetDistanceToPoint(Svc.Targets.Target.Position) > 5 then
            MoveToNPC()
            return
        end

        if Addons.GetAddon("SelectYesno").Ready then
            AcceptNPCFateOrRejectOtherYesno()
        elseif not Svc.Condition[CharacterCondition.occupied] then
            Engines.Run("/interact")
        end
    end
end

function CollectionsFateTurnIn()
    AcceptNPCFateOrRejectOtherYesno()

    if CurrentFate ~= nil and not IsFateActive(CurrentFate.fateObject) then
        CurrentFate = nil
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        return
    end

    if (Svc.Targets.Target == nil or GetTargetName()~=CurrentFate.npcName) then
        TurnOffCombatMods()
        Engines.Run("/target "..CurrentFate.npcName)
        yield("/wait 1")

        -- if too far from npc to target, then head towards center of fate
        if (Svc.Targets.Target == nil or GetTargetName()~=CurrentFate.npcName and CurrentFate.fateObject.Progress ~= nil and CurrentFate.fateObject.Progress < 100) then
            if not IPC.vnavmesh.PathfindInProgress() and not IPC.vnavmesh.IsRunning() then
                IPC.vnavmesh.PathfindAndMoveTo(CurrentFate.position, false)
            end
        else
            Engines.Run("/vnav stop")
        end
        return
    end

    if GetDistanceToTarget() > 5 then
        if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
            MoveToNPC()
        end
    else
        if Inventory.GetItemCount(CurrentFate.fateObject.EventItem) >= 7 then
            GotCollectionsFullCredit = true
        end

        Engines.Run("/vnav stop")
        Engines.Run("/interact")
        yield("/wait 3")

        if CurrentFate.fateObject.Progress < 100 then
            TurnOnCombatMods()
            State = CharacterState.doFate
            Dalamud.Log("[FATE] State Change: DoFate")
        else
            if GotCollectionsFullCredit then
                GotCollectionsFullCredit = false
                State = CharacterState.unexpectedCombat
                Dalamud.Log("[FATE] State Change: UnexpectedCombat")
            end
        end

        if CurrentFate ~=nil and CurrentFate.npcName ~=nil and GetTargetName() == CurrentFate.npcName then
            Dalamud.Log("[FATE] Attempting to clear target.")
            ClearTarget()
            yield("/wait 1")
        end
    end
    GotCollectionsFullCredit = false
end

--#endregion movement

--#region Combat Functions

function GetClassJobTableFromName(classString)
    if classString == nil or classString == "" then
        return nil
    end

    for classJobId=1, 42 do
        local job = Player.GetJob(classJobId)
        if job.Name == classString then
            return job
        end
    end
    
    Dalamud.Log("[FATE] Cannot recognize combat job for boss fates.")
    return nil
end

function SummonChocobo()
    if Svc.Condition[CharacterCondition.mounted] then
        Dismount()
        return
    end

    if ShouldSummonChocobo and GetBuddyTimeRemaining() <= ResummonChocoboTimeLeft then
        if Inventory.GetItemCount(4868) > 0 then
            Engines.Run("/item ギサールの野菜")
            yield("/wait 3")
            Engines.Run("/cac "..ChocoboStance)
        elseif ShouldAutoBuyGysahlGreens then
            State = CharacterState.autoBuyGysahlGreens
            Dalamud.Log("[FATE] State Change: AutoBuyGysahlGreens")
            return
        end
    end
    State = CharacterState.ready
    Dalamud.Log("[FATE] State Change: Ready")
end

function AutoBuyGysahlGreens()
    if Inventory.GetItemCount(4868) > 0 then -- dont need to buy
        if Addons.GetAddon("Shop").Ready then
            Engines.Run("/callback Shop true -1")
        elseif Svc.ClientState.TerritoryType == SelectedZone.zoneId then
            Engines.Run("/item ギサールの野菜")
        else
            State = CharacterState.ready
            Dalamud.Log("State Change: ready")
        end
        return
    else
        if Svc.ClientState.TerritoryType ~=  129 then
            Engines.Run("/vnav stop")
            TeleportTo("リムサ・ロミンサ：下甲板層")
            return
        else
            local gysahlGreensVendor = { position=Vector3(-62.1, 18.0, 9.4), npcName="ブルゲール商会 バンゴ・ザンゴ" }
            if GetDistanceToPoint(gysahlGreensVendor.position) > 5 then
                if not (IPC.vnavmesh.IsRunning() or IPC.vnavmesh.PathfindInProgress()) then
                    IPC.vnavmesh.PathfindAndMoveTo(gysahlGreensVendor.position, false)
                end
            elseif Svc.Targets.Target ~= nil and GetTargetName() == gysahlGreensVendor.npcName then
                Engines.Run("/vnav stop")
                if Addons.GetAddon("SelectYesno").Ready then
                    Engines.Run("/callback SelectYesno true 0")
                elseif Addons.GetAddon("SelectIconString").Ready then
                    Engines.Run("/callback SelectIconString true 0")
                    return
                elseif Addons.GetAddon("Shop").Ready then
                    Engines.Run("/callback Shop true 0 2 99")
                    return
                elseif not Svc.Condition[CharacterCondition.occupied] then
                    Engines.Run("/interact")
                    yield("/wait 1")
                    return
                end
            else
                Engines.Run("/vnav stop")
                Engines.Run("/target "..gysahlGreensVendor.npcName)
            end
        end
    end
end

function ClearTarget()
    Svc.Targets.Target = nil
end

function GetTargetHitboxRadius()
    if Svc.Targets.Target ~= nil then
        return Svc.Targets.Target.HitboxRadius
    else
        return 0
    end
end

function GetPlayerHitboxRadius()
    if Svc.ClientState.LocalPlayer ~= nil then
        return Svc.ClientState.LocalPlayer.HitboxRadius
    else
        return 0
    end
end

function TurnOnAoes()
    if not AoesOn then
        if RotationPlugin == "RSR" then
            yield("/rotation off")
            yield("/rotation auto on")
            Dalamud.Log("[FATE] TurnOnAoes /rotation auto on")

            if RSRAoeType == "Off" then
                Engines.Run("/rotation settings aoetype 0")
            elseif RSRAoeType == "Cleave" then
                Engines.Run("/rotation settings aoetype 1")
            elseif RSRAoeType == "Full" then
                Engines.Run("/rotation settings aoetype 2")
            end
        elseif RotationPlugin == "BMR" then
            Engines.Run("/bmrai setpresetname "..RotationAoePreset)
        elseif RotationPlugin == "VBM" then
            Engines.Run("/vbm ar toggle "..RotationAoePreset)
        end
        AoesOn = true
    end
end

function TurnOffAoes()
    if AoesOn then
        if RotationPlugin == "RSR" then
            Engines.Run("/rotation settings aoetype 1")
            Engines.Run("/rotation manual")
            Dalamud.Log("[FATE] TurnOffAoes /rotation manual")
        elseif RotationPlugin == "BMR" then
            Engines.Run("/bmrai setpresetname "..RotationSingleTargetPreset)
        elseif RotationPlugin == "VBM" then
            Engines.Run("/vbm ar toggle "..RotationSingleTargetPreset)
        end
        AoesOn = false
    end
end

function TurnOffRaidBuffs()
    if AoesOn then
        if RotationPlugin == "BMR" then
            Engines.Run("/bmrai setpresetname "..RotationHoldBuffPreset)
        elseif RotationPlugin == "VBM" then
            Engines.Run("/vbm ar toggle "..RotationHoldBuffPreset)
        end
    end
end

function SetMaxDistance()
    -- Check if the current job is a melee DPS or tank.
    if Player.Job and (Player.Job.IsMeleeDPS or Player.Job.IsTank) then
        MaxDistance = MeleeDist
        MoveToMob = true
        Dalamud.Log("[FATE] Setting max distance to " .. tostring(MeleeDist) .. " (melee/tank)")
    else
        MoveToMob = false
        MaxDistance = RangedDist
        Dalamud.Log("[FATE] Setting max distance to " .. tostring(RangedDist) .. " (ranged/caster)")
    end
end

function TurnOnCombatMods(rotationMode)
    if not CombatModsOn then
        CombatModsOn = true
        -- turn on RSR in case you have the RSR 30 second out of combat timer set
        if RotationPlugin == "RSR" then
            if rotationMode == "manual" then
                Engines.Run("/rotation manual")
                Dalamud.Log("[FATE] TurnOnCombatMods /rotation manual")
            else
                yield("/rotation off")
                yield("/rotation auto on")
                Dalamud.Log("[FATE] TurnOnCombatMods /rotation auto on")
            end
        elseif RotationPlugin == "BMR" then
            Engines.Run("/bmrai setpresetname "..RotationAoePreset)
        elseif RotationPlugin == "VBM" then
            Engines.Run("/vbm ar toggle "..RotationAoePreset)
        elseif RotationPlugin == "Wrath" then
            Engines.Run("/wrath auto on")
        end
        
        if not AiDodgingOn then
            SetMaxDistance()
            
            if DodgingPlugin == "BMR" then
                Engines.Run("/bmrai on")
                Engines.Run("/bmrai followtarget on") -- overrides navmesh path and runs into walls sometimes
                Engines.Run("/bmrai followcombat on")
                Engines.Run("/bmrai maxdistancetarget " .. MaxDistance)
                if MoveToMob == true then
                    Engines.Run("/bmrai followoutofcombat on")
                end
            elseif DodgingPlugin == "VBM" then
                Engines.Run("/vbmai on")
                Engines.Run("/vbmai followtarget on") -- overrides navmesh path and runs into walls sometimes
                Engines.Run("/vbmai followcombat on")
                Engines.Run("/vbmai maxdistancetarget " .. MaxDistance)
                if MoveToMob == true then
                    Engines.Run("/bmrai followoutofcombat on")
                end
                if RotationPlugin ~= "VBM" then
                    Engines.Run("/vbmai ForbidActions on") --This Disables VBM AI Auto-Target
                end
            end
            AiDodgingOn = true
        end
    end
end

function TurnOffCombatMods()
    if CombatModsOn then
        Dalamud.Log("[FATE] Turning off combat mods")
        CombatModsOn = false

        if RotationPlugin == "RSR" then
            Engines.Run("/rotation off")
            Dalamud.Log("[FATE] TurnOffCombatMods /rotation off")
        elseif RotationPlugin == "BMR" or RotationPlugin == "VBM" then
            Engines.Run("/bmrai setpresetname nil")
        elseif RotationPlugin == "Wrath" then
            Engines.Run("/wrath auto off")
        end

        -- turn off BMR so you dont start following other mobs
        if AiDodgingOn then
            if DodgingPlugin == "BMR" then
                Engines.Run("/bmrai off")
--                Engines.Run("/bmrai followtarget off")
--                Engines.Run("/bmrai followcombat off")
--                Engines.Run("/bmrai followoutofcombat off")
--                Engines.Run("/bmrai followoutofcombat off")
            elseif DodgingPlugin == "VBM" then
                Engines.Run("/vbm ar disable")
                Engines.Run("/vbmai off")
                Engines.Run("/vbmai followtarget off")
                Engines.Run("/vbmai followcombat off")
                Engines.Run("/vbmai followoutofcombat off")
                Engines.Run("/bmrai followoutofcombat off")
                if RotationPlugin ~= "VBM" then
                    Engines.Run("/vbmai ForbidActions off") --This Enables VBM AI Auto-Target
                end
            end
            AiDodgingOn = false
        end
    end
end

function HandleUnexpectedCombat()
    if Svc.Condition[CharacterCondition.mounted] or Svc.Condition[CharacterCondition.flying] then
        Dalamud.Log("[FATE] UnexpectedCombat: Dismounting due to combat")
        Dismount()
        return
    end
    TurnOnCombatMods("manual")

    local nearestFate = Fates.GetNearestFate()
    if InActiveFate() and nearestFate.Progress < 100 then
        CurrentFate = BuildFateTable(nearestFate)
        State = CharacterState.doFate
        Dalamud.Log("[FATE] State Change: DoFate")
        return
    elseif not Svc.Condition[CharacterCondition.inCombat] then
        Engines.Run("/vnav stop")
        ClearTarget()
        TurnOffCombatMods()
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        local randomWait = (math.floor(math.random()*MaxWait * 1000)/1000) + MinWait -- truncated to 3 decimal places
        yield("/wait "..randomWait)
        return
    end

    -- if Svc.Condition[CharacterCondition.mounted] then
    --     if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
    --         IPC.vnavmesh.PathfindAndMoveTo(Svc.ClientState.Location, true)
    --     end
    --     yield("/wait 10")
    --     return
    -- end

    -- targets whatever is trying to kill you
    if Svc.Targets.Target == nil then
        Engines.Run("/battletarget")
    end

    -- pathfind closer if enemies are too far
    if Svc.Targets.Target ~= nil then
        if GetDistanceToTargetFlat() > (MaxDistance + GetTargetHitboxRadius() + GetPlayerHitboxRadius()) then
            if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                if Player.CanFly and SelectedZone.flying then
                    Engines.Run("/vnav flytarget")
                else
                    MoveToTargetHitbox()
                end
            end
        else
            if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
                Engines.Run("/vnav stop")
            elseif not Svc.Condition[CharacterCondition.inCombat] then
                --inch closer 3 seconds
                if Svc.Condition[CharacterCondition.flying] and SelectedZone.flying then
                    Engines.Run("/vnav flytarget")
                else
                    MoveToTargetHitbox()
                end
                yield("/wait 3")
            end
        end
    end
    yield("/wait 1")
end

function DoFate()
    local msg = "[FATE] DoFate"
    if Echo == "all" then
        Dalamud.Log(msg)
        Engines.Run("/echo  "..msg)
    end
    if WaitingForFateRewards == nil or WaitingForFateRewards.fateId ~= CurrentFate.fateId then
        WaitingForFateRewards = CurrentFate
        Dalamud.Log("[FATE] WaitingForFateRewards DoFate: "..tostring(WaitingForFateRewards.fateId))
    end
    local currentClass = Player.Job
    -- switch classes (mostly for continutation fates that pop you directly into the next one)
    if CurrentFate.isBossFate and BossFatesClass ~= nil and currentClass ~= BossFatesClass.classId and not Player.IsBusy then
        TurnOffCombatMods()
        Engines.Run("/gs change "..BossFatesClass.className)
        yield("/wait 1")
        return
    elseif not CurrentFate.isBossFate and BossFatesClass ~= nil and currentClass ~= MainClass.classId and not Player.IsBusy then
        TurnOffCombatMods()
        Engines.Run("/gs change "..MainClass.className)
        yield("/wait 1")
        return
    elseif InActiveFate() and (CurrentFate.fateObject.MaxLevel < Player.Job.Level) and not Player.IsLevelSynced then
        Engines.Run("/lsync")
        yield("/wait 0.5") -- give it a second to register
    elseif IsFateActive(CurrentFate.fateObject) and not InActiveFate() and CurrentFate.fateObject.Progress ~= nil and CurrentFate.fateObject.Progress < 100 and (GetDistanceToPoint(CurrentFate.position) < CurrentFate.fateObject.Radius + 10) and not Svc.Condition[CharacterCondition.mounted] and not (IPC.vnavmesh.IsRunning() or IPC.vnavmesh.PathfindInProgress()) then -- got pushed out of fate. go back
        Engines.Run("/vnav stop")
        yield("/wait 1")
        Dalamud.Log("[FATE] pushed out of fate going back!")
        IPC.vnavmesh.PathfindAndMoveTo(CurrentFate.position, Svc.Condition[CharacterCondition.flying] and SelectedZone.flying)
        return
    elseif not IsFateActive(CurrentFate.fateObject) or CurrentFate.fateObject.Progress == 100 then
        Engines.Run("/vnav stop")
        ClearTarget()
        if not Dalamud.Log("[FATE] HasContintuation check") and CurrentFate.hasContinuation then
            LastFateEndTime = os.clock()
            State = CharacterState.waitForContinuation
            Dalamud.Log("[FATE] State Change: WaitForContinuation")
            return
        else
            DidFate = true
            Dalamud.Log("[FATE] No continuation for "..CurrentFate.fateName)
            local randomWait = (math.floor(math.random() * (math.max(0, MaxWait - 3)) * 1000)/1000) + MinWait -- truncated to 3 decimal places
            yield("/wait "..randomWait)
            TurnOffCombatMods()
            ForlornMarked = false
            MovingAnnouncementLock = false
            State = CharacterState.ready
            Dalamud.Log("[FATE] State Change: Ready")
        end
        return
    elseif Svc.Condition[CharacterCondition.mounted] then
        State = CharacterState.MiddleOfFateDismount
        Dalamud.Log("[FATE] State Change: MiddleOfFateDismount")
        return
    elseif CurrentFate.isCollectionsFate then
        yield("/wait 1") -- needs a moment after start of fate for GetFateEventItem to populate
        if Inventory.GetItemCount(CurrentFate.fateObject.EventItem) >= 7 or (GotCollectionsFullCredit and CurrentFate.fateObject.Progress == 100) then
            Engines.Run("/vnav stop")
            State = CharacterState.collectionsFateTurnIn
            Dalamud.Log("[FATE] State Change: CollectionsFatesTurnIn")
        end
    end

    if Echo == "all" then
        Dalamud.Log(msg)
        Engines.Run("/echo  "..msg)
    end

    -- do not target fate npc during combat
    if CurrentFate.npcName ~=nil and GetTargetName() == CurrentFate.npcName then
        Dalamud.Log("[FATE] Attempting to clear target.")
        ClearTarget()
        yield("/wait 1")
    end

    TurnOnCombatMods("auto")

    GemAnnouncementLock = false

    -- switches to targeting forlorns for bonus (if present)
    if not IgnoreForlorns then
        Engines.Run("/target フォーローン・メイデン")
        if not IgnoreBigForlornOnly then
            Engines.Run("/target フォーローン")
        end
    end

    if (GetTargetName() == "フォーローン・メイデン" or GetTargetName() == "フォーローン") then
        if IgnoreForlorns or (IgnoreBigForlornOnly and GetTargetName() == "フォーローン") then
            ClearTarget()
        elseif not Svc.Targets.Target.IsDead then
            if not ForlornMarked then
                Engines.Run("/enemysign attack1")
                if Echo == "all" then
                    Engines.Run("/echo  Found Forlorn! <se.3>")
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
    if Entity.Target == nil then
        Engines.Run("/battletarget")
    end

    -- clears target
    if Entity.Target ~= nil and Entity.Target.FateId ~= CurrentFate.fateId and not Entity.Target.IsInCombat then
        Entity.Target:ClearTarget()
    end

    -- do not interrupt casts to path towards enemies
    if Svc.Condition[CharacterCondition.casting] then
        return
    end

    --hold buff thingy
    if CurrentFate.fateObject.Progress ~= nil and CurrentFate.fateObject.Progress >= PercentageToHoldBuff then
        TurnOffRaidBuffs()
    end

    -- pathfind closer if enemies are too far
    if not Svc.Condition[CharacterCondition.inCombat] then
        if Svc.Targets.Target ~= nil then
            if GetDistanceToTargetFlat() <= (MaxDistance + GetTargetHitboxRadius() + GetPlayerHitboxRadius()) then
                if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
                    Engines.Run("/vnav stop")
                    yield("/wait 5.002") -- wait 5s before inching any closer
                elseif (GetDistanceToTargetFlat() > (1 + GetTargetHitboxRadius() + GetPlayerHitboxRadius())) and not Svc.Condition[CharacterCondition.casting] then -- never move into hitbox
                    Engines.Run("/vnav movetarget")
                    yield("/wait 1") -- inch closer by 1s
                end
            elseif not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                yield("/wait 5.003") -- give 5s for enemy AoE casts to go off before attempting to move closer
                if (Svc.Targets.Target ~= nil and not Svc.Condition[CharacterCondition.inCombat]) and not Svc.Condition[CharacterCondition.casting] then
                    MoveToTargetHitbox()
                end
            end
            return
        else
            AttemptToTargetClosestFateEnemy()
            yield("/wait 1") -- wait in case target doesnt stick
            if (Svc.Targets.Target == nil) and not Svc.Condition[CharacterCondition.casting] then
                IPC.vnavmesh.PathfindAndMoveTo(CurrentFate.position, false)
            end
        end
    else
        if Svc.Targets.Target ~= nil and (GetDistanceToTargetFlat() <= (MaxDistance + GetTargetHitboxRadius() + GetPlayerHitboxRadius())) then
            if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
                Engines.Run("/vnav stop")
            end
        elseif not CurrentFate.isBossFate then
            if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                yield("/wait 5.004")
                if Svc.Targets.Target ~= nil and not Svc.Condition[CharacterCondition.casting] then
                    if Svc.Condition[CharacterCondition.flying] and SelectedZone.flying then
                        Engines.Run("/vnav flytarget")
                    else
                        MoveToTargetHitbox()
                    end
                end
            end
        end
    end
end

--#endregion

--#region State Transition Functions

function Ready()
    if SelectedZone == nil or SelectedZone.zoneId == nil then
        Engines.Run("/echo  [FATE] ERROR: SelectedZone is not set! Aborting.")
        StopScript = true
        return
    end
    if StopScript then return end --Early exit before running ready checks.

    FoodCheck()
    PotionCheck()

    CombatModsOn = false

    local shouldWaitForBonusBuff = WaitIfBonusBuff and (HasStatusId(1288) or HasStatusId(1289))
    local needsRepair = Inventory.GetItemsInNeedOfRepairs(RemainingDurabilityToRepair)
    local spiritbonded = Inventory.GetSpiritbondedItems()

    if not GemAnnouncementLock and (Echo == "all" or Echo == "gems") then
        GemAnnouncementLock = true
        if BicolorGemCount >= 1400 then
            Engines.Run("/echo  [FATE] You're almost capped with "..tostring(BicolorGemCount).."/1500 gems! <se.3>")
            if ShouldExchangeBicolorGemstones and not shouldWaitForBonusBuff and Player.IsLevelSynced ~= true then
                State = CharacterState.exchangingVouchers
                Dalamud.Log("[FATE] State Change: ExchangingVouchers")
                return
            end
        else
            Engines.Run("/echo  [FATE] Gems: "..tostring(BicolorGemCount).."/1500")
        end
    end

    if RemainingDurabilityToRepair > 0 and needsRepair.Count > 0 and (not shouldWaitForBonusBuff or (SelfRepair and Inventory.GetItemCount(33916) > 0)) then
        State = CharacterState.repair
        Dalamud.Log("[FATE] State Change: Repair")
        return
    end

    if ShouldExtractMateria and spiritbonded.Count > 0 and Inventory.GetFreeInventorySlots() > 1 then
        State = CharacterState.extractMateria
        Dalamud.Log("[FATE] State Change: ExtractMateria")
        return
    end

    if WaitingForFateRewards == nil and Retainers and ARRetainersWaitingToBeProcessed() and Inventory.GetFreeInventorySlots() > 1 and not shouldWaitForBonusBuff then
        State = CharacterState.processRetainers
        Dalamud.Log("[FATE] State Change: ProcessingRetainers")
        return
    end

    if ShouldGrandCompanyTurnIn and Inventory.GetFreeInventorySlots() < InventorySlotsLeft and not shouldWaitForBonusBuff then
        State = CharacterState.gcTurnIn
        Dalamud.Log("[FATE] State Change: GCTurnIn")
        return
    end

    if Svc.ClientState.TerritoryType ~= SelectedZone.zoneId then
        if not SelectedZone or not SelectedZone.aetheryteList or not SelectedZone.aetheryteList[1] then
            Engines.Run("/echo  [FATE] ERROR: No aetheryte found for selected zone. Cannot teleport. Stopping script.")
            StopScript = true
            return
        end
        local teleSuccess = TeleportTo(SelectedZone.aetheryteList[1].aetheryteName)
        if teleSuccess == false then
            Engines.Run("/echo  [FATE] ERROR: Teleportation failed. Stopping script.")
            StopScript = true
            return
        end
        Dalamud.Log("[FATE] Teleport Back to Farming Zone")
        return
    end

    if ShouldSummonChocobo and GetBuddyTimeRemaining() <= ResummonChocoboTimeLeft and (not shouldWaitForBonusBuff or Inventory.GetItemCount(4868) > 0) then
        State = CharacterState.summonChocobo
        Dalamud.Log("[FATE] State Change: summonChocobo")
        return
    end

    NextFate = SelectNextFate()
    if CurrentFate ~= nil and not IsFateActive(CurrentFate.fateObject) then
        CurrentFate = nil
    end

    if NextFate == nil then
        if EnableChangeInstance and GetZoneInstance() > 0 and not shouldWaitForBonusBuff then
            State = CharacterState.changingInstances
            Dalamud.Log("[FATE] State Change: ChangingInstances")
            return
        end
        if CompanionScriptMode and not shouldWaitForBonusBuff then
            if WaitingForFateRewards == nil then
                StopScript = true
                Dalamud.Log("[FATE] StopScript: Ready")
            else
                Dalamud.Log("[FATE] Waiting for fate rewards")
            end
            return
        end
        if DownTimeWaitAtNearestAetheryte and (Svc.Targets.Target == nil or GetTargetName() ~= "aetheryte" or GetDistanceToTarget() > 20) then
            State = CharacterState.flyBackToAetheryte
            Dalamud.Log("[FATE] State Change: FlyBackToAetheryte")
            return
        end
        if MoveToRandomSpot then
            MoveToRandomNearbySpot(50, 75)
            yield("/wait 10")
        end
        return        
    end


    if NextFate == nil and shouldWaitForBonusBuff and DownTimeWaitAtNearestAetheryte then
        if Svc.Targets.Target == nil or GetTargetName() ~= "aetheryte" or GetDistanceToTarget() > 20 then
            State = CharacterState.flyBackToAetheryte
            Dalamud.Log("[FATE] State Change: FlyBackToAetheryte")
        else
            yield("/wait 10")
        end
        return
    end

    if CompanionScriptMode and DidFate and not shouldWaitForBonusBuff then
        if WaitingForFateRewards == nil then
            StopScript = true
            Dalamud.Log("[FATE] StopScript: DidFate")
        else
            Dalamud.Log("[FATE] Waiting for fate rewards")
        end
        return
    end

    if not Player.Available then
        return
    end

    CurrentFate = NextFate
    HasFlownUpYet = false
    SetMapFlag(SelectedZone.zoneId, CurrentFate.position)
    State = CharacterState.moveToFate
    Dalamud.Log("[FATE] State Change: MovingtoFate "..CurrentFate.fateName)
end

function HandleDeath()
    CurrentFate = nil

    if CombatModsOn then
        TurnOffCombatMods()
    end

    if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
        Engines.Run("/vnav stop")
    end

    if Svc.Condition[CharacterCondition.dead] then --Condition Dead
        if ReturnOnDeath then
            if Echo and not DeathAnnouncementLock then
                DeathAnnouncementLock = true
                if Echo == "all" then
                    Engines.Run("/echo  [FATE] You have died. Returning to home aetheryte.")
                end
            end

            if Addons.GetAddon("SelectYesno").Ready then --rez addon yes
                Engines.Run("/callback SelectYesno true 0")
                yield("/wait 0.1")
            end
        else
            if Echo and not DeathAnnouncementLock then
                DeathAnnouncementLock = true
                if Echo == "all" then
                    Engines.Run("/echo  [FATE] You have died. Waiting until script detects you're alive again...")
                end
            end
            yield("/wait 1")
        end
    else
        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        DeathAnnouncementLock = false
        HasFlownUpYet = false
    end
end

function ExecuteBicolorExchange()
    CurrentFate = nil

    if BicolorGemCount >= 1400 then
        if Addons.GetAddon("SelectYesno").Ready then
            Engines.Run("/callback SelectYesno true 0")
            return
        end

        if Addons.GetAddon("ShopExchangeCurrency").Ready then
            Engines.Run("/callback ShopExchangeCurrency false 0 "..SelectedBicolorExchangeData.item.itemIndex.." "..(BicolorGemCount//SelectedBicolorExchangeData.item.price))
            return
        end

        if Svc.ClientState.TerritoryType ~=  SelectedBicolorExchangeData.zoneId then
            TeleportTo(SelectedBicolorExchangeData.aetheryteName)
            return
        end
    
        if SelectedBicolorExchangeData.miniAethernet ~= nil and
            GetDistanceToPoint(SelectedBicolorExchangeData.position) > (DistanceBetween(SelectedBicolorExchangeData.miniAethernet.position, SelectedBicolorExchangeData.position) + 10) then
            Dalamud.Log("Distance to shopkeep is too far. Using mini aetheryte.")
            Engines.Run("/li "..SelectedBicolorExchangeData.miniAethernet.name)
            yield("/wait 1") -- give it a moment to register
            return
        elseif Addons.GetAddon("TelepotTown").Ready then
            Dalamud.Log("TelepotTown open")
            Engines.Run("/callback TelepotTown false -1")
        elseif GetDistanceToPoint(SelectedBicolorExchangeData.position) > 5 then
            Dalamud.Log("Distance to shopkeep is too far. Walking there.")
            if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                Dalamud.Log("Path not running")
                IPC.vnavmesh.PathfindAndMoveTo(SelectedBicolorExchangeData.position, false)
            end
        else
            Dalamud.Log("[FATE] Arrived at Shopkeep")
            if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
                Engines.Run("/vnav stop")
            end
    
            if Svc.Targets.Target == nil or GetTargetName() ~= SelectedBicolorExchangeData.shopKeepName then
                Engines.Run("/target "..SelectedBicolorExchangeData.shopKeepName)
            elseif not Svc.Condition[CharacterCondition.occupiedInQuestEvent] then
                Engines.Run("/interact")
            end
        end
    else
        if Addons.GetAddon("ShopExchangeCurrency").Ready then
            Dalamud.Log("[FATE] Attemping to close shop window")
            Engines.Run("/callback ShopExchangeCurrency true -1")
            return
        elseif Svc.Condition[CharacterCondition.occupiedInEvent] then
            Dalamud.Log("[FATE] Character still occupied talking to shopkeeper")
            yield("/wait 0.5")
            return
        end

        State = CharacterState.ready
        Dalamud.Log("[FATE] State Change: Ready")
        return
    end
end

function ProcessRetainers()
    CurrentFate = nil

    Dalamud.Log("[FATE] Handling retainers...")
    if ARRetainersWaitingToBeProcessed() and Inventory.GetFreeInventorySlots() > 1 then
    
        if IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning() then
            return
        end

        if Svc.ClientState.TerritoryType ~=  129 then
            Engines.Run("/vnav stop")
            TeleportTo("リムサ・ロミンサ：下甲板層")
            return
        end

        local summoningBell = {
            name="呼び鈴",
            position=Vector3(-122.72, 18.00, 20.39)
        }
        if GetDistanceToPoint(summoningBell.position) > 4.5 then
            IPC.vnavmesh.PathfindAndMoveTo(summoningBell.position, false)
            return
        end

        if Svc.Targets.Target == nil or GetTargetName() ~= summoningBell.name then
            Engines.Run("/target "..summoningBell.name)
            return
        end

        if not Svc.Condition[CharacterCondition.occupiedSummoningBell] then
            Engines.Run("/interact")
            if Addons.GetAddon("RetainerList").Ready then
                Engines.Run("/ays e")
                if Echo == "all" then
                    Engines.Run("/echo  [FATE] Processing retainers")
                end
                yield("/wait 1")
            end
        end
    else
        if Addons.GetAddon("RetainerList").Ready then
            Engines.Run("/callback RetainerList true -1")
        elseif not Svc.Condition[CharacterCondition.occupiedSummoningBell] then
            State = CharacterState.ready
            Dalamud.Log("[FATE] State Change: Ready")
        end
    end
end

function GrandCompanyTurnIn()
    if Inventory.GetFreeInventorySlots() <= InventorySlotsLeft then
        if IPC.Lifestream and IPC.Lifestream.ExecuteCommand then
            IPC.Lifestream.ExecuteCommand("gc")
            Dalamud.Log("[FATE] Executed Lifestream teleport to GC.")
        else
            Engines.Run("/echo  [FATE] Lifestream IPC not available! Cannot teleport to GC.")
            return
        end
        yield("/wait 1")
        while (IPC.Lifestream.IsBusy and IPC.Lifestream.IsBusy())
           or (Svc.Condition[CharacterCondition.betweenAreas]) do
            yield("/wait 0.5")
        end
        Dalamud.Log("[FATE] Lifestream complete, standing at GC NPC.")
        if IPC.AutoRetainer and IPC.AutoRetainer.EnqueueInitiation then
            IPC.AutoRetainer.EnqueueInitiation()
            Dalamud.Log("[FATE] Called AutoRetainer.EnqueueInitiation() for GC handin.")
        else
            Engines.Run("/echo  [FATE] AutoRetainer IPC not available! Cannot process GC turnin.")
        end
    else
        State = CharacterState.ready
        Dalamud.Log("State Change: Ready")
    end
end

function Repair()
    local needsRepair = Inventory.GetItemsInNeedOfRepairs(RemainingDurabilityToRepair)
    if Addons.GetAddon("SelectYesno").Ready then
        Engines.Run("/callback SelectYesno true 0")
        return
    end

    if Addons.GetAddon("Repair").Ready then
        if needsRepair.Count == nil or needsRepair.Count == 0 then
            Engines.Run("/callback Repair true -1") -- if you dont need repair anymore, close the menu
        else
            Engines.Run("/callback Repair true 0") -- select repair
        end
        return
    end

    -- if occupied by repair, then just wait
    if Svc.Condition[CharacterCondition.occupiedMateriaExtractionAndRepair] then
        Dalamud.Log("[FATE] Repairing...")
        yield("/wait 1")
        return
    end

    local hawkersAlleyAethernetShard = { x=-213.95, y=15.99, z=49.35 }
    if SelfRepair then
        if Inventory.GetItemCount(33916) > 0 then
            if Addons.GetAddon("Shop").Ready then
                Engines.Run("/callback Shop true -1")
                return
            end

            if Svc.ClientState.TerritoryType ~=  SelectedZone.zoneId then
                TeleportTo(SelectedZone.aetheryteList[1].aetheryteName)
                return
            end

            if Svc.Condition[CharacterCondition.mounted] then
                Dismount()
                Dalamud.Log("[FATE] State Change: Dismounting")
                return
            end

            if needsRepair.Count > 0 then
                if not Addons.GetAddon("Repair").Ready then
                    Dalamud.Log("[FATE] Opening repair menu...")
                    Engines.Run("/gaction 修理")
                end
            else
                State = CharacterState.ready
                Dalamud.Log("[FATE] State Change: Ready")
            end
        elseif ShouldAutoBuyDarkMatter then
            if Svc.ClientState.TerritoryType ~=  129 then
                if Echo == "all" then
                    Engines.Run("/echo  Out of Dark Matter! Purchasing more from Limsa Lominsa.")
                end
                TeleportTo("リムサ・ロミンサ：下甲板層")
                return
            end

            local darkMatterVendor = { npcName="雑貨屋 ウンシンレール", x=-257.71, y=16.19, z=50.11, wait=0.08 }
            if GetDistanceToPoint(darkMatterVendor.position) > (DistanceBetween(hawkersAlleyAethernetShard.position, darkMatterVendor.position) + 10) then
                Engines.Run("/li マーケット（国際街広場）")
                yield("/wait 1") -- give it a moment to register
            elseif Addons.GetAddon("TelepotTown").Ready then
                Engines.Run("/callback TelepotTown false -1")
            elseif GetDistanceToPoint(darkMatterVendor.position) > 5 then
                if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                    IPC.vnavmesh.PathfindAndMoveTo(darkMatterVendor.position, false)
                end
            else
                if Svc.Targets.Target == nil or GetTargetName() ~= darkMatterVendor.npcName then
                    Engines.Run("/target "..darkMatterVendor.npcName)
                elseif not Svc.Condition[CharacterCondition.occupiedInQuestEvent] then
                    Engines.Run("/interact")
                elseif Addons.GetAddon("SelectYesno").Ready then
                    Engines.Run("/callback SelectYesno true 0")
                elseif Addons.GetAddon("Shop") then
                    Engines.Run("/callback Shop true 0 40 99")
                end
            end
        else
            if Echo == "all" then
                Engines.Run("/echo  Out of Dark Matter and ShouldAutoBuyDarkMatter is false. Switching to Limsa mender.")
            end
            SelfRepair = false
        end
    else
        if needsRepair.Count > 0 then
            if Svc.ClientState.TerritoryType ~= 129 then
                TeleportTo("リムサ・ロミンサ：下甲板層")
                return
            end
            
            local mender = { npcName="修理屋 アリステア", x=-246.87, y=16.19, z=49.83 }
            if GetDistanceToPoint(mender.position) > (DistanceBetween(hawkersAlleyAethernetShard.position, mender.position) + 10) then
                Engines.Run("/li マーケット（国際街広場）")
                yield("/wait 1") -- give it a moment to register
            elseif Addons.GetAddon("TelepotTown").Ready then
                Engines.Run("/callback TelepotTown false -1")
            elseif GetDistanceToPoint(mender.position) > 5 then
                if not (IPC.vnavmesh.PathfindInProgress() or IPC.vnavmesh.IsRunning()) then
                    IPC.vnavmesh.PathfindAndMoveTo(mender.position, false)
                end
            else
                if Svc.Targets.Target == nil or GetTargetName() ~= mender.npcName then
                    Engines.Run("/target "..mender.npcName)
                elseif not Svc.Condition[CharacterCondition.occupiedInQuestEvent] then
                    Engines.Run("/interact")
                end
            end
        else
            State = CharacterState.ready
            Dalamud.Log("[FATE] State Change: Ready")
        end
    end
end

function ExtractMateria()
    if Svc.Condition[CharacterCondition.mounted] then
        Dismount()
        Dalamud.Log("[FATE] State Change: Dismounting")
        return
    end

    if Svc.Condition[CharacterCondition.occupiedMateriaExtractionAndRepair] then
        return
    end

    if Inventory.GetSpiritbondedItems().Count > 0 and Inventory.GetFreeInventorySlots() > 1 then
        if not Addons.GetAddon("Materialize").Ready then
            Engines.Run("/gaction マテリア精製")
            yield("/wait .25")
            return
        end

        Dalamud.Log("[FATE] Extracting materia...")
            
        if Addons.GetAddon("MaterializeDialog").Ready then
            Engines.Run("/callback MaterializeDialog true 0")
            yield("/wait .25")
        else
            Engines.Run("/callback Materialize true 2 0")
            yield("/wait .25")
        end
    else
        if Addons.GetAddon("Materialize").Ready then
            Engines.Run("/callback Materialize true -1")
            yield("/wait .25")
        else
            State = CharacterState.ready
            Dalamud.Log("[FATE] State Change: Ready")
        end
    end
end

--#endregion State Transition Functions

--#region Misc Functions

function EorzeaTimeToUnixTime(eorzeaTime)
    return eorzeaTime/(144/7) -- 24h Eorzea Time equals 70min IRL
end

function HasStatusId(statusId)
    local statusList = Svc.ClientState.LocalPlayer.StatusList
    if statusList == nil then
        return false
    end
    for i=0, statusList.Length-1 do
        if statusList[i].StatusId == statusId then
            return true
        end
    end
    return false
end

function FoodCheck()
    --food usage
    if not HasStatusId(48) and Food ~= "" then
        Engines.Run("/item " .. Food)
    end
end

function PotionCheck()
    --pot usage
    if not HasStatusId(49) and Potion ~= "" then
        Engines.Run("/item " .. Potion)
    end
end

function GetNodeText(addonName, nodePath, ...)
    local addon = Addons.GetAddon(addonName)
    repeat
        yield("/wait 0.1")
    until addon.Ready
    return addon:GetNode(nodePath, ...).Text
end

function ARRetainersWaitingToBeProcessed()
    local offlineCharacterData = IPC.AutoRetainer.GetOfflineCharacterData(Svc.ClientState.LocalContentId)
    for i=0, offlineCharacterData.RetainerData.Count-1 do
        local retainer = offlineCharacterData.RetainerData[i]
        if retainer.HasVenture and retainer.VentureEndsAt <= os.time() then
            return true
        end
    end
    return false
end

--#endregion Misc Functions

--#region Main

CharacterState = {
    ready = Ready,
    dead = HandleDeath,
    unexpectedCombat = HandleUnexpectedCombat,
    mounting = MountState,
    npcDismount = NpcDismount,
    MiddleOfFateDismount = MiddleOfFateDismount,
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


Food = Config.Get("Food")
Potion = Config.Get("Potion")
ResummonChocoboTimeLeft         = 3 * 60        --Resummons chocobo if there's less than this many seconds left on the timer, so it doesn't disappear on you in the middle of a fate.
ChocoboStance = Config.Get("Chocobo Companion Stance") -- Options: Follow, Free, Defender, Healer, Attacker, None. Do not summon if None.
ShouldSummonChocobo = ChocoboStance == "追従"
    or ChocoboStance == "フリーファイト"
    or ChocoboStance == "ディフェンダースタンス"
    or ChocoboStance == "ヒーラースタンス"
    or ChocoboStance == "アタッカースタンス"

ShouldAutoBuyGysahlGreens = Config.Get("Buy Gysahl Greens?")    --
MountToUse                          = "ウィング・オブ・リゾルヴ"       --The mount you'd like to use when flying between fates
FatePriority                        = {"Bonus", "Distance", "DistanceTeleport", "Progress", "TimeLeft"}

--Fate Combat Settings
CompletionToIgnoreFate = Config.Get("Ignore FATE if progress is over (%)")
MinTimeLeftToIgnoreFate = Config.Get("Ignore FATE if duration is less than (mins)")*60
CompletionToJoinBossFate = Config.Get("Ignore boss FATEs until progress is at least (%)")
CompletionToJoinSpecialBossFates = Config.Get("Ignore Special FATEs until progress is at least (%)")
ClassForBossFates = ""            --If you want to use a different class for boss fates, set this to the 3 letter abbreviation
                                                        --for the class. Ex: "PLD"
JoinCollectionsFates = Config.Get("Do collection FATEs?")
BonusFatesOnly = Config.Get("Do only bonus FATEs?")         --If true, will only do bonus fates and ignore everything else

MeleeDist = Config.Get("Max melee distance")
RangedDist = Config.Get("Max ranged distance")

RotationPlugin = string.lower(Config.Get("Rotation Plugin"))
if RotationPlugin == "any" then
    if HasPlugin("WrathCombo") then
        RotationPlugin = "Wrath"
    elseif HasPlugin("RotationSolver") then
        RotationPlugin = "RSR"
    elseif HasPlugin("BossModReborn") then
        RotationPlugin = "BMR"
    elseif HasPlugin("BossMod") then
        RotationPlugin = "VBM"
    end
elseif RotationPlugin == "wrath" and HasPlugin("WrathCombo") then
    RotationPlugin = "Wrath"
elseif RotationPlugin == "rotationsolver" and HasPlugin("RotationSolver") then
    RotationPlugin = "RSR"
elseif RotationPlugin == "bossmodreborn" and HasPlugin("BossModReborn") then
    RotationPlugin = "BMR"
elseif RotationPlugin == "bossbod" and HasPlugin("BossMod") then
    RotationPlugin = "VBM"
else
    StopScript = true
end
    RSRAoeType                      = "Full"        --Options: Cleave/Full/Off

    -- For BMR/VBM/Wrath
    RotationSingleTargetPreset      = Config.Get("Single Target Rotation") --Preset name with single target strategies (for forlorns). TURN OFF AUTOMATIC TARGETING FOR THIS PRESET
    RotationAoePreset               = Config.Get("AoE Rotation")           --Preset with AOE + Buff strategies.
    RotationHoldBuffPreset          = Config.Get("Hold Buff Rotation")     --Preset to hold 2min burst when progress gets to seleted %
    PercentageToHoldBuff            = Config.Get("Percentage to Hold Buff")--Ideally youll want to make full use of your buffs, higher than 70% will still waste a few seconds if progress is too fast.

IgnoreForlorns = false
IgnoreBigForlornOnly = false
Forlorns = string.lower(Config.Get("Forlorns"))
if Forlorns == "none" then
    IgnoreForlorns = true
elseif Forlorns == "small" then
    IgnoreBigForlornOnly = true
end

--Post Fate Settings
MinWait                             = 0             --Min number of seconds it should wait until mounting up for next fate.
MaxWait                             = 2            --Max number of seconds it should wait until mounting up for next fate.
                                                        --Actual wait time will be a randomly generated number between MinWait and MaxWait.
DownTimeWaitAtNearestAetheryte      = false         --When waiting for fates to pop, should you fly to the nearest Aetheryte and wait there?
EnableChangeInstance = Config.Get("Change instances if no FATEs?")
WaitIfBonusBuff = true          --Dont change instances if you have the Twist of Fate bonus buff
NumberOfInstances = 2
ShouldExchangeBicolorGemstones = Config.Get("Exchange bicolor gemstones?")
ItemToPurchase = Config.Get("Exchange bicolor gemstones for")
ShouldExchangeBicolorGemstones = true
if ItemToPurchase == "" or ItemToPurchase == nil then
    ShouldExchangeBicolorGemstones = false
end
SelfRepair = Config.Get("Self repair?")
RemainingDurabilityToRepair     = 90            --the amount it needs to drop before Repairing (set it to 0 if you don't want it to repair)
ShouldAutoBuyDarkMatter         = false         --Automatically buys a 99 stack of Grade 8 Dark Matter from the Limsa gil vendor if you're out
ShouldExtractMateria                = true          --should it Extract Materia
Retainers = Config.Get("Pause for retainers?")
ShouldGrandCompanyTurnIn = Config.Get("Dump extra gear at GC?")         --should it do Turn ins at the GC (requires Deliveroo)
    InventorySlotsLeft              = 5             --how much inventory space before turning in

ReturnOnDeath = Config.Get("Return on death?")

Echo = string.lower(Config.Get("Echo logs"))
CompanionScriptMode                 = false         --Set to true if you are using the fate script with a companion script (such as the Atma Farmer)
MoveToRandomSpot = Config.Get("Randomly Move if no eligible Fate?")

-- Get user-configured plugin
local dodgeConfig = string.lower(Config.Get("Dodging Plugin"))  -- Options: Any / BossModReborn / BossMod / None

-- Resolve "any" or specific plugin if available
if dodgeConfig == "any" then
    if HasPlugin("BossModReborn") then
        DodgingPlugin = "BMR"
    elseif HasPlugin("BossMod") then
        DodgingPlugin = "VBM"
    else
        DodgingPlugin = "None"
    end
elseif dodgeConfig == "bossmodreborn" and HasPlugin("BossModReborn") then
    DodgingPlugin = "BMR"
elseif dodgeConfig == "bossmod" and HasPlugin("BossMod") then
    DodgingPlugin = "VBM"
else
    DodgingPlugin = "None"
end

-- Override if RotationPlugin already uses a dodging plugin
if RotationPlugin == "BMR" then
    DodgingPlugin = "BMR"
elseif RotationPlugin == "VBM" then
    DodgingPlugin = "VBM"
end

-- Final warning if no dodging plugin is active
if DodgingPlugin == "None" then
    Engines.Run("/echo  [FATE] Warning: you do not have an AI dodging plugin configured, so your character will stand in AOEs. Please install either Veyn's BossMod or BossMod Reborn")
end

if Retainers and not HasPlugin("AutoRetainer") then
    Retainers = false
    Engines.Run("/echo  [FATE] Warning: you have enabled the feature to process retainers, but you do not have AutoRetainer installed.")
end

if ShouldGrandCompanyTurnIn and not HasPlugin("AutoRetainer") then
    ShouldGrandCompanyTurnIn = false
    Engines.Run("/echo  [FATE] Warning: you have enabled the feature to process GC turn ins, but you do not have Deliveroo installed.")
end

if not CompanionScriptMode then
    Engines.Run("/at y")
end

StopScript = false
DidFate = false
fateState = nil
GemAnnouncementLock = false
DeathAnnouncementLock = false
MovingAnnouncementLock = false
SuccessiveInstanceChanges = 0
LastInstanceChangeTimestamp = 0
LastTeleportTimeStamp = 0
GotCollectionsFullCredit = false -- needs 7 items for  full
-- variable to track collections fates that you have completed but are still active.
-- will not leave area or change instance if value ~= 0
WaitingForFateRewards = nil
LastFateEndTime = os.clock()
LastStuckCheckTime = os.clock()
LastStuckCheckPosition = Player.Entity.Position
MainClass = Player.Job
BossFatesClass = nil
if ClassForBossFates ~= "" then
    BossFatesClass = GetClassJobTableFromName(ClassForBossFates)
end
SetMaxDistance()

SelectedZone = SelectNextZone()
if SelectedZone.zoneName ~= "" and Echo == "all" then
    Engines.Run("/echo  [FATE] Farming "..SelectedZone.zoneName)
end
Dalamud.Log("[FATE] Farming Start for "..SelectedZone.zoneName)


if ShouldExchangeBicolorGemstones ~= false then
    for _, shop in ipairs(BicolorExchangeData) do
        for _, item in ipairs(shop.shopItems) do
            if item.itemName == ItemToPurchase then
                SelectedBicolorExchangeData = {
                    shopKeepName = shop.shopKeepName,
                    zoneId = shop.zoneId,
                    aetheryteName = shop.aetheryteName,
                    miniAethernet = shop.miniAethernet,
                    position = shop.position,
                    item = item
                }
            end
        end
    end
    if SelectedBicolorExchangeData == nil then
        Engines.Run("/echo  [FATE] Cannot recognize bicolor shop item "..ItemToPurchase.."! Please make sure it's in the BicolorExchangeData table!")
        StopScript = true
    end
end

State = CharacterState.ready
CurrentFate = nil
if InActiveFate() then
    CurrentFate = BuildFateTable(Fates.GetNearestFate())
end

if ShouldSummonChocobo and GetBuddyTimeRemaining() > 0 then
    Engines.Run("/cac "..ChocoboStance)
end

Dalamud.Log("[FATE] Starting fate farming script.")

while not StopScript do
    local nearestFate = Fates.GetNearestFate()
    if not IPC.vnavmesh.IsReady() then
        Engines.Run("/echo  [FATE] Waiting for vnavmesh to build...")
        Dalamud.Log("[FATE] Waiting for vnavmesh to build...")
        repeat
            yield("/wait 1")
        until IPC.vnavmesh.IsReady()
    end
    if State ~= CharacterState.dead and Svc.Condition[CharacterCondition.dead] then
        State = CharacterState.dead
        Dalamud.Log("[FATE] State Change: Dead")
    elseif State ~= CharacterState.unexpectedCombat
        and State ~= CharacterState.doFate
        and State ~= CharacterState.waitForContinuation
        and State ~= CharacterState.collectionsFateTurnIn
        and Svc.Condition[CharacterCondition.inCombat]
        and (
            not InActiveFate()
            or (InActiveFate() and IsCollectionsFate(nearestFate.Name) and nearestFate.Progress == 100)
            or State == CharacterState.moveToFate   -- <-- this is new!
        )
    then
        State = CharacterState.unexpectedCombat
        Dalamud.Log("[FATE] State Change: UnexpectedCombat")
    end
    
    BicolorGemCount = Inventory.GetItemCount(26807)

    if WaitingForFateRewards ~= nil then
        local state = WaitingForFateRewards.fateObject and WaitingForFateRewards.fateObject.State or nil
        if WaitingForFateRewards.fateObject == nil
            or state == nil
            or state == FateState.Ended
            or state == FateState.Failed
        then
            local msg = "[FATE] WaitingForFateRewards.fateObject is nil or fate state ("..tostring(state)..") indicates fate is finished for fateId: "..tostring(WaitingForFateRewards.fateId)..". Clearing it."
            if Echo == "all" then
                Dalamud.Log(msg)
                Engines.Run("/echo  "..msg)
            end
            WaitingForFateRewards = nil
        else
            local msg = "[FATE] Not clearing WaitingForFateRewards: fateState="..tostring(state)..", expected one of [Ended: "..tostring(FateState.Ended)..", Failed: "..tostring(FateState.Failed).."] or nil."
            if Echo == "all" then
                Dalamud.Log(msg)
                Engines.Run("/echo  "..msg)
            end
        end
    end
    if not (Svc.Condition[CharacterCondition.betweenAreas] 
        or Svc.Condition[CharacterCondition.occupiedMateriaExtractionAndRepair] 
        or IPC.Lifestream.IsBusy())
        then
            State()
    end
    yield("/wait 0.25")
end
Engines.Run("/vnav stop")

if Player.Job.Id ~= MainClass.Id then
    Engines.Run("/gs change "..MainClass.Name)
end
--#endregion Main