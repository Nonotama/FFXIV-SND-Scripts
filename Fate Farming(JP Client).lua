--[[

********************************************************************************
*                                Fate Farming                                  *
*                              Version 2.15.11                                 *
********************************************************************************

Created by: pot0to (https://ko-fi.com/pot0to)
State Machine Diagram: https://github.com/pot0to/pot0to-SND-Scripts/blob/main/FateFarmingStateMachine.drawio.png

    -> 2.15.11  Truncated random wait to 3 decimal places
                Removed check for targeting forlorn only once
                Added <0,0,0> check for pathing to enemies while in a fate
                Added nilcheck for BossFatesClass
                Fixed class changing for part 2 fates, fixed materia extraction flag
                Fixed wait for bonus buff for retainers, mender, gysahl greens
                    and dark matter purchases, bugfix for
                    unexpectedCombat -> ready -> unexpectedCombat loop
                Switch to /rsr manual for forlorns and switch back after
                Added a dismount check before summoning chocobo
                Fixed name of Fate La Selva se lo Llevó in Yak T'el
                Fix for chocobo summoning
                Removed Pandora, added feature to purchase Gysahl Greens and
                    Grade 8 Dark Matter from Limsa vendors, turned off BMR when
                    turning in collections fates, fixed S9 waits
                Fixing fate selection bug
                Added missing Kozama'uka npc fates, fixed aoe settings after
                    forlorn dies
                Added pretty README
                Added setting to select RSR aoe type, reworked aoe settings for
                    targeting forlorns, added settings for special fates,
                    updated RSR recommendations
                Removed feature to use Thavnairian Onions when chocobo is ready
                    for level up
                Fixed fate name for The Serpentlord Seethes
                Turn off aoes for forlorn
                Added Dawntrail special fates to blacklist
                Fixed continaution fates
    -> 2.0.0    State system

********************************************************************************
*                               Required Plugins                               *
********************************************************************************

Plugins that are needed for it to work:

    -> Something Need Doing [Expanded Edition] : (Main Plugin for everything to work)   https://puni.sh/api/repository/croizat   
    -> VNavmesh :   (for Pathing/Moving)    https://puni.sh/api/repository/veyn         
    -> RotationSolver Reborn :  (for Attacking enemys)  https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json       
        -> Target -> Check "Select only Fate targets in Fate" and DESELECT "Target Fate priority" (or else it will mess up Forlorn targeting)
        -> Target -> "Engage settings" set to "All targets that are in range for any abilities (Tanks/Autoduty)" regardless of whether you are tank
        -> List -> Map Specific Settings -> Add "Forlorn Maiden" and "The Forlorn" to Prio Targets
        -> Recommended for melees: Target -> Configuration -> gapcloser distance = 20y
    -> TextAdvance: (for interacting with Fate NPCs)
    -> Teleporter :  (for Teleporting to aetherytes [teleport][Exchange][Retainers])
    -> Lifestream :  (for changing Instances [ChangeInstance][Exchange]) https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json

********************************************************************************
*                                Optional Plugins                              *
********************************************************************************

This Plugins are Optional and not needed unless you have it enabled in the settings:

    -> AutoRetainer : (for Retainers [Retainers])   https://love.puni.sh/ment.json
    -> Deliveroo : (for gc turn ins [TurnIn])   https://plugins.carvel.li/
    -> Bossmod/BossModReborn: (for AI dodging)  https://puni.sh/api/repository/veyn
                                                https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
    -> ChatCoordinates : (for setting a flag on the next Fate) available via base /xlplugins

--------------------------------------------------------------------------------------------------------------------------------------------------------------
]]

--#region Settings

--[[
********************************************************************************
*                                   Settings                                   *
********************************************************************************
]]

--Pre Fate Settings
Food = ""                                      --Leave "" Blank if you don't want to use any food. If its HQ include <hq> next to the name "Baked Eggplant <hq>"
Potion = ""                                    --Leave "" Blank if you don't want to use any potions.
ShouldSummonChocobo = true                     --Summon chocobo?
    ShouldAutoBuyGysahlGreens = false              --Automatically buys a 99 stack of Gysahl Greens from the Limsa gil vendor if you're out
MountToUse = "チャイチャ"                      --The mount you'd like to use when flying between fates

--Fate Combat Settings
CompletionToIgnoreFate = 80                    --If the fate has more than this much progress already, skip it
MinTimeLeftToIgnoreFate = 1.5*60                 --If the fate has less than this many seconds left on the timer, skip it
CompletionToJoinBossFate = 0                   --If the boss fate has less than this much progress, skip it (used to avoid soloing bosses)
    CompletionToJoinSpecialBossFates = 20          --For the Special Fates like the Serpentlord Seethes or Mascot Murder
    ClassForBossFates = ""                         --If you want to use a different class for boss fates, set this to the 3 letter abbreviation
                                                   --for the class. Ex: "PLD"
JoinCollectionsFates = false                   --Set to false if you never want to do collections fates
RSRAoeType = "Full"                            --Options: Cleave/Full/Off
RSRAutoType = "LowHP"                          --Options: LowHP/HighHP/Big/Small/HighMaxHP/LowMaxHP/Nearest/Farthest.
                                    
UseBM = true                                   --if you want to use the BossMod dodge/follow mode
    BMorBMR = "BMR"
    MeleeDist = 2.5                                --distance for BMRAI melee. Melee attacks (auto attacks) max distance is 2.59y, 2.60 is "target out of range"
    RangedDist = 20                                --distance for BMRAI ranged. Ranged attacks and spells max distance to be usable is 25.49y, 25.5 is "target out of range"=


--Post Fate Settings
EnableChangeInstance = true                    --should it Change Instance when there is no Fate (only works on DT fates)
    WaitIfBonusBuff = true                         --Don't change instances if you have the Twist of Fate bonus buff
ShouldExchangeBicolorVouchers = true           --Should it exchange Bicolor Gemstone Vouchers?
    VoucherTown = "ソリューションナイン"           -- Old Sharlayan for "オールド・シャーレアン" and Solution Nine for "ソリューションナイン"
SelfRepair = true                              --if false, will go to Limsa mender
    RepairAmount = 20                              --the amount it needs to drop before Repairing (set it to 0 if you don't want it to repair)
    ShouldAutoBuyDarkMatter = false                --Automatically buys a 99 stack of Grade 8 Dark Matter from the Limsa gil vendor if you're out
ShouldExtractMateria = true                    --should it Extract Materia
Retainers = true                               --should it do Retainers
ShouldGrandCompanyTurnIn = true                --should it to Turn ins at the GC (requires Deliveroo)
    InventorySlotsLeft = 5                         --how much inventory space before turning in

--Change this value for how much echos u want in chat 
--0 no echos
--1 echo how many bicolor gems you have after every fate
--2 echo how many bicolor gems you have after every fate and the next fate you're moving to
Echo = 0

--#endregion Settings

------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
**************************************************************
*  Code: Don't touch this unless you know what you're doing  *
**************************************************************
]]

--#region Plugin Checks and Setting Init

--Required Plugin Warning
if not HasPlugin("vnavmesh") then
    yield("/echo [FATE] Please Install vnavmesh")
end

if UseBM then
    if HasPlugin("BossModReborn") then
        BMorBMR = "BMR"
    elseif HasPlugin("BossMod") then
        BMorBMR = "BM"
    else
        UseBM = false
        yield("/echo [FATE] Neither BossMod nor BossModReborn have been detected. "..
            "Please set useBM to false or install one of these plugins to silence this warning.")
    end
end

if HasPlugin("RotationSolver") then
    yield("/rotation Settings TargetingTypes removeall")
    yield("/rotation Settings TargetingTypes add "..RSRAutoType)
else
    yield("/echo [FATE] Please Install Rotation Solver Reborn")
end
if not HasPlugin("TextAdvance") then
    yield("/echo [FATE] Please Install TextAdvance")
end

--Optional Plugin Warning
if EnableChangeInstance == true  then
    if HasPlugin("Lifestream") == false then
        yield("/echo [FATE] Please Install Lifestream or Disable ChangeInstance in the settings")
    end
end
if Retainers then
    if not HasPlugin("AutoRetainer") then
        yield("/echo [FATE] Please Install AutoRetainer")
    end
end
if ShouldGrandCompanyTurnIn then
    if not HasPlugin("Deliveroo") then
        ShouldGrandCompanyTurnIn = false
        yield("/echo [FATE] Please Install Deliveroo")
    end
end
if ShouldExtractMateria then
    if HasPlugin("YesAlready") == false then
        yield("/echo [FATE] Please Install YesAlready")
    end 
end   

if not HasPlugin("ChatCoordinates") then
    yield("/echo [FATE] ChatCoordinates is not installed. Map will not show flag when moving to next Fate.")
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
    occupied31=31,
    occupiedShopkeeper=32,
    occupied=33,
    occupiedMateriaExtraction=39,
    betweenAreas=45,
    jumping48=48,
    jumping61=61,
    occupiedSummoningBell=50,
    mounting57=57,
    mounting64=64,
    beingmoved70=70,
    beingmoved75=75,
    flying=77
}

ClassList =
{
    pld = { classId=19, className="ナイト",         isMelee=true,  isTank=true },
    mnk = { classId=20, className="モンク",         isMelee=true,  isTank=false },
    war = { classId=21, className="戦士",           isMelee=true,  isTank=true },
    drg = { classId=22, className="竜騎士",         isMelee=true,  isTank=false },
    brd = { classId=23, className="吟遊詩人",       isMelee=false, isTank=false },
    whm = { classId=24, className="白魔道士",       isMelee=false, isTank=false },
    blm = { classId=25, className="黒魔道士",       isMelee=false, isTank=false },
    smn = { classId=27, className="召喚士",         isMelee=false, isTank=false },
    sch = { classId=28, className="学者",           isMelee=false, isTank=false },
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

FatesData = {
    {
        zoneName = "クルザス中央高地",
        zoneId = 155,
        aetheryteList = {
            { aetheryteName="キャンプ・ドラゴンヘッド", x=223.98718, y=315.7854, z=-234.85168 }
        },
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "クルザス西部高知",
        zoneId = 397,
        aetheryteList = {
            { aetheryteName="ファルコンネスト", x=474.87585, y=217.94458, z=708.5221 }
        },
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
        aetheryteList = {
            { aetheryteName="レヴナンツトール", x=40.024292, y=24.002441, z=-668.0247 }
        },
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
        aetheryteList = {
            { aetheryteName="キャンプ・クラウドトップ", x=-615.7473, y=-118.36426, z=546.5934 },
            { aetheryteName="オク・ズンド", x=-613.1533, y=-49.485046, z=-415.03015 }
        },
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
        aetheryteList = {
            { aetheryteName="ポート・ヘリックス", x=-722.8046, y=-182.29956, z=-593.40814 }
        },
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "高知ドラヴァニア",
        zoneId = 398,
        aetheryteList = {
            { aetheryteName="テイルフェザー", x=532.6771, y=-48.722107, z=30.166992 },
            { aetheryteName="不浄の三塔", x=-304.12756, y=-16.70868, z=32.059082 }
        },
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "イディルシャイア",
        zoneId=399,
        tpZoneId = 478,
        aetheryteList = {
            { aetheryteName="イディルシャイア", x=71.94617, y=211.26111, z=-18.905945 }
        },
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
        aetheryteList = {
            { aetheryteName="モグモグホーム", x=259.20496, y=-37.70508, z=596.85657 },
            { aetheryteName="白亜の宮殿", x=-584.9546, y=52.84192, z=313.43542 },
        },
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "レイクランド",
        zoneId = 813,
        aetheryteList = {
            { aetheryteName="オスタル厳命城", x=-735, y=53, z=-230 },
            { aetheryteName="ジョッブ砦", x=753, y=24, z=-28 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="Pick-up Sticks", npcName="Crystarium Botanist" }
            },
            otherNpcFates= {
                { fateName="Subtle Nightshade", npcName="Artless Dodger" },
                { fateName="Economic Peril", npcName="Jobb Guard" }
            },
            fatesWithContinuations = {
                "Behind Anemone Lines"
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName = "コルシア島",
        zoneId = 814,
        aetheryteList = {
            { aetheryteName="スティルタイド", x=668, y=29, z=289 },
            { aetheryteName="ライト村", x=-244, y=20, z=385 },
            { aetheryteName="トメラの村", x=-426, y=419, z=-623 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="Ironbeard Builders - Rebuilt", npcName="Tholl Engineer" }
            },
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "アム・アレーン",
        zoneId = 815,
        aetheryteList = {
            { aetheryteName="モルド・スーク", x=246, y=12, z=-220 },
            { aetheryteName="トゥワイン", x=-511, y=47, z=-212 },
            { aetheryteName="旅立ちの宿", x=399, y=-24, z=307 },
        },
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            fatesWithContinuations = {},
            blacklistedFates= {
                "Tolba No. 1", -- pathing is really bad to enemies
            }
        }
    },
    {
        zoneName = "イル・メグ",
        zoneId = 816,
        aetheryteList = {
            { aetheryteName="リダ・ラーン", x=-344, y=48, z=512 },
            { aetheryteName="ヴォレクドルフ", x=380, y=87, z=-687 },
            { aetheryteName="プラ・エンニ茸窟", x=-72, y=103, z=-857 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="Twice Upon a Time", npcName="Nectar-seeking Pixie" }
            },
            otherNpcFates= {
                { fateName="Once Upon a Time", npcName="Nectar-seeking Pixie" },
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "ラケティカ大森林",
        zoneId = 817,
        aetheryteList = {
            { aetheryteName="スリザーバウ", x=-103, y=-19, z=297 },
            { aetheryteName="ファノヴの里", x=382, y=21, z=-194 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="Picking up the Pieces", npcName="Night's Blessed Missionary" },
                { fateName="Pluck of the Draw", npcName="Myalna Bowsing" },
                { fateName="Monkeying Around", npcName="Fanow Warder" }
            },
            otherNpcFates= {
                { fateName="Queen of the Harpies", npcName="Fanow Huntress" },
                { fateName="Shot Through the Hart", npcName="Qilmet Redspear" },
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "テンペスト",
        zoneId = 818,
        aetheryteList = {
            { aetheryteName="オンドの潮溜まり", x=561, y=352, z=-199 },
            { aetheryteName="マカレンサス広場", x=-141, y=-280, z=218 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="Low Coral Fiber", npcName="Teushs Ooan" },
                { fateName="Pearls Apart", npcName="Ondo Spearfisher" }
            },
            otherNpcFates= {
                { fateName="Where has the Dagon", npcName="Teushs Ooan" },
                { fateName="Ondo of Blood", npcName="Teushs Ooan" },
                { fateName="Lookin' Back on the Track", npcName="Teushs Ooan" },
            },
            fatesWithContinuations = {},
            blacklistedFates= {
                "Coral Support", -- escort fate
                "The Seashells He Sells", -- escort fate
            }
        }
    },
    {
        zoneName = "ラヴィリンソス",
        zoneId = 956,
        aetheryteList = {
            { aetheryteName="アルケイオン保管院", x=443, y=170, z=-476 },
            { aetheryteName="リトルシャーレアン", x=8, y=-27, z=-46 },
            { aetheryteName="アポリア本部", x=-729, y=-27, z=302 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="風の十四方位", npcName="困り果てた研究員" },
                { fateName="天然由来保湿成分", npcName="美肌の研究員" }
            },
            otherNpcFates= {
                { fateName="羊飼いの暮らし", npcName="種畜研究所の獣牧士" }, --24 tower defense
            },
            fatesWithContinuations = {},
            blacklistedFates= {}
        }
    },
    {
        zoneName = "サベネア島",
        zoneId = 957,
        aetheryteList = {
            { aetheryteName="イェドリマン", x=193, y=6, z=629 },
            { aetheryteName="デミールの遺烈郷", x=-527, y=4, z=36 },
            { aetheryteName="パーラカの里", x=405, y=5, z=-244 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="香りの錬金術師：危険な花摘み", npcName="調香のサジャバート" }
            },
            otherNpcFates= {
                { fateName="少年と海", npcName="漁師の息子" }, --24 tower defense
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
        aetheryteList = {
            { aetheryteName="キャンプ・ブロークングラス", x=-408, y=24, z=479 },
            { aetheryteName="テルティウム駅", x=518, y=-35, z=-178 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="回収は一刻を争う！", npcName="難民の魔導技師" }
            },
            otherNpcFates= {
                { fateName="魔導技師の帰郷：ファースト・ステップ", npcName="ケルトロナ少甲士" }, --22 boss
                { fateName="魔導技師の帰郷：ファースト・イン・トラップ", npcName="エルブレノ" }, --24 tower defense
                { fateName="魔導技師の帰郷：ビフォー・コンタクト", npcName="ケルトロナ少甲士" }, --23 normal
                { fateName="霜の巨人たち", npcName="生き残りの難民" } --24 tower defense
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
        aetheryteList = {
            { aetheryteName="涙の入江", x=-566, y=134, z=650 },
            { aetheryteName="ベストウェイ・バロー", x=0, y=-128, z=-512 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="What a Thrill", npcName="Thrillingway" }
            },
            otherNpcFates= {
                { fateName="嘆きの白兎：ばくばく大爆発", npcName="ウォリングウェイ" }, --24 tower defense
                { fateName="嘆きの白兎：だめだめ大暴走", npcName="フォリングウェイ" }, --23 normal
                { fateName="嘆きの白兎：むきむき大処分", npcName="フォリングウェイ" } --22 boss
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
        aetheryteList = {
            { aetheryteName="リア・ターラ", x=-544, y=74, z=269 },
            { aetheryteName="イーアの里", x=64, y=272, z=-657 },
            { aetheryteName="オミクロンベース", x=-489, y=437, z=333 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="カイのメモリーより：通信機拡張", npcName="N-6205" }
            },
            otherNpcFates= {
                { fateName="栄光の翼「アル・アイン」", npcName="アル・アインの友" }, --22 boss
                { fateName="カイのメモリーより：N-6205防衛", npcName="N-6205"}, --24 tower defense
                { fateName="永遠の終わり", npcName="ミク・ネール" } --24 tower defense
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
        aetheryteList = {
            { aetheryteName="アナグノリシス天測園", x=159, y=11, z=126 },
            { aetheryteName="十二節の園", x=-633, y=-19, z=542 },
            { aetheryteName="ポイエテーン・オイコス", x=-529, y=161, z=-222 },
        },
        fatesList= {
            collectionsFates= {
                { fateName="ソクレスへの弁明", npcName="植物担当の観察者" }
            },
            otherNpcFates= {
                { fateName="創造計画：エゴーケロス観察", npcName="深遠のメレトス" }, --23 normal
                { fateName="創造計画：斬新すぎたイデア", npcName="深遠のメレトス" }, --23 normal
                { fateName="死の鳥", npcName="モノセロスの観察者" }, --24 tower defense
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
        aetheryteList = {
            { aetheryteName="ワチュン・ペロ", x=335, y=-160, z=-415 },
            { aetheryteName="ウォーラーの残響", x=465, y=115, z=635 },
        },
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {
                { fateName="ポゼッション", npcName="健脚のジーベリ" }, --23 normal
                { fateName="踊る山火「ラカクウルク」", npcName="健脚のジーベリ" }, --22 boss
                { fateName="不死の人", npcName="墓参りのヨカフイ族" }, --23 normal
                { fateName="失われた山岳の都", npcName="遺跡守のヨカフイ族" }, --24 tower defense
                { fateName="コーヒーを巡る冒険", npcName="カピー農園の作業員" }, --24 tower defense
                { fateName="千年の孤独", npcName="チーワグー・サベラー" }, --23 normal
                { fateName="空飛ぶ鍋奉行「ペルペルイーター」", npcName="ペルペル族の旅商" }, --22 boss
                { fateName="狼の家", npcName="ペルペル族の旅商" }  --23 normal
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
        aetheryteList={
            { aetheryteName="オック・ハヌ", x=-170, y=6, z=-470 },
            { aetheryteName="朋友の灯火", x=541, y=117, z=203 },
            { aetheryteName="アースンシャイア", x=-477, y=124, z=311 }
        },
        fatesList={
            collectionsFates={
                { fateName="落ち石拾い", npcName="モブリン族の採集人" },
                { fateName="人鳥細工", npcName="ハヌハヌ族の細工師" },
                
            },
            otherNpcFates= {
                { fateName="怪力の大食漢「マイティ・マイプ」", npcName="ハヌハヌ族の釣り人" }, --22 boss
                { fateName="野性と葦", npcName="ハヌハヌ族の農夫" }, --23 normal
                { fateName="我々の貢物", npcName="ハヌハヌ族の巫女" }, --24 tower defense
                { fateName="奸臣、大寒心", npcName="ペルペル族の行商人" }, --24 tower defense
                { fateName="素晴らしき、キノコの世界", npcName="匠想いのバノブロク" }  --23 normal
            },
            fatesWithContinuations = {
                { fateName="匠想いのバノブロク", continuationIsBoss=true }
            },
            blacklistedFates= {
                "奸臣、大寒心" -- 同名NPCが、同一箇所に複数いるため
            }
        }
    },
    {
        zoneName="ヤクテル樹海",
        zoneId=1189,
        aetheryteList={
            { aetheryteName="イクブラーシャ", x=-400, y=24, z=-431 },
            { aetheryteName="マムーク", x=720, y=-132, z=527 }
        },
        fatesList= {
            collectionsFates= {
                { fateName="恐怖！キノコ魔物", npcName="フビゴ族の採集人" }
            },
            otherNpcFates= {
                { fateName="上段の突きを喰らうイブルク", npcName="シュバラール族の狩人" }, --23 normal
                { fateName="血濡れの爪「ミユールル」", npcName="シュバラール族の狩人" }, --22 boss
                { fateName="ザ・デッドリーマンティス", npcName="シュバラール族の狩人" }, --23 normal
                { fateName="荒くれマムージャ襲撃編", npcName="ドプロ族の槍使い" }, --23 normal
                { fateName="秘薬を守る戦い", npcName="フビゴ族の荷運び人" }  --24 tower defense
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
        aetheryteList= {
            { aetheryteName="フーサタイ宿場町", x=390, y=0, z=465 },
            { aetheryteName="シェシェネ青燐泉", x=-295, y=19, z=-115 },
            { aetheryteName="メワヘイゾーン", x=310, y=-15, z=-567 }
        },
        fatesList= {
            collectionsFates= {
                { fateName="毛狩りの季節", npcName="トナワータ族の採集人" },
                { fateName="トクローネ：狩猟の下準備", npcName="赤日のブルクバー" }
            },
            otherNpcFates= {
                { fateName="死せる悪漢「デッドマン・ダーテカ」", npcName="トナワータ族の労働者" }, --22 boss
                { fateName="嘆きの猛進「ウィデキ」", npcName="ヘイザ・アロ族の男性" }, --22 boss
                { fateName="ロネークと人の大地", npcName="ヘイザ・アロ族の女性" }, --23 normal
                { fateName="リバー・ランズ・スルー・イット", npcName="ヘイザ・アロ族の釣人" }, --24 tower defense
                { fateName="恐竜怪鳥の伝説", npcName="ペルペル族の行商人" }  --23 normal
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
        aetheryteList= {
            { aetheryteName="ヤースラニ駅", x=515, y=145, z=210 },
            { aetheryteName="アウトスカーツ", x=-221, y=32, z=-583 },
            { aetheryteName="エレクトロープ採石場", x=-222, y=31,  z=123 }
        },
        fatesList= {
            collectionsFates= {
                { fateName="薬屋のひと仕事", npcName="農務役のトナワータ族" },
                { fateName="人生がときめく片づけの技法", npcName="凛とした拾得人" }
            },
            otherNpcFates= {
                { fateName="ブロークンボットダイアリー", npcName="駆け出しの駆除人" }, --23 normal
                { fateName="逃走テレメトリー", npcName="駆け出しの駆除人" }, --23 normal
                { fateName="人狼伝説", npcName="危機に瀕した駆除人" }, --23 normal
                { fateName="気まぐれロボット", npcName="途方に暮れた拾得人" }, --23 normal
                { fateName="巨獣めざめる", npcName="ドリフトダウンズの拾得人" }, --23 normal
                { fateName="道を視る青年", npcName="怯えた配達人" }  --23 normal
            },
            fatesWithContinuations = {
                { fateName="気まぐれロボット", continuationIsBoss=false }
            },
            blacklistedFates= {}
        }
    },
    {
        zoneName="リビング・メモリー",
        zoneId=1192,
        aetheryteList= {
            { aetheryteName="レイノード・メモリス", x=0, y=56, z=796 },
            { aetheryteName="レイノード・ファイア", x=659, y=27, z=-285 },
            { aetheryteName="レイノード・ウィンド", x=-253, y=56, z=-400 }
        },
        fatesList= {
            collectionsFates= {
                { fateName="種の期限", npcName="アンロスト・セントリーGX" },
                { fateName="メモリーズ", npcName="アンロスト・セントリーGX" }
            },
            otherNpcFates= {
                { fateName="カナルタウンでやすらかに", npcName="アンロスト・セントリーGX" }, --24 tower defense
                { fateName="マイカ・ザ・ムー：出発進行", npcName="ファニー・パレードマスター" }  --23 normal
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

--[[
    Given two fates, picks the better one based on priority progress -> is bonus -> time left -> distance
]]
function SelectNextFateHelper(tempFate, nextFate)
    if tempFate.timeLeft < MinTimeLeftToIgnoreFate or tempFate.progress > CompletionToIgnoreFate then
        return nextFate
    else
        if nextFate == nil then
                LogInfo("[FATE] Selecting #"..tempFate.fateId.." because no other options so far.")
                return tempFate
        -- elseif nextFate.startTime == 0 and tempFate.startTime > 0 then -- nextFate is an unopened npc fate
        --     LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." is an unopened npc fate.")
        --     return tempFate
        -- elseif tempFate.startTime == 0 and nextFate.startTime > 0 then -- tempFate is an unopened npc fate
        --     return nextFate
        elseif nextFate.timeLeft < MinTimeLeftToIgnoreFate or nextFate.progress > CompletionToIgnoreFate then
            return tempFate
        else -- select based on progress
            if nextFate.isBonusFate then
                return nextFate
            elseif tempFate.isBonusFate then
                return tempFate
            elseif tempFate.progress > nextFate.progress then
                LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." has less progress.")
                return tempFate
            elseif tempFate.progress < nextFate.progress then
                LogInfo("[FATE] Selecting #"..nextFate.fateId.." because other fate #"..tempFate.fateId.." has less progress.")
                return nextFate
            else
                if (nextFate.isBonusFate and tempFate.isBonusFate) or (not nextFate.isBonusFate and not tempFate.isBonusFate) then
                    if tempFate.timeLeft < nextFate.timeLeft then -- select based on time left
                        LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." has more time left.")
                        return tempFate
                    elseif tempFate.timeLeft > nextFate.timeLeft then
                        LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." has more time left.")
                        return nextFate
                    else
                        tempFatePlayerDistance = GetDistanceToPoint(tempFate.x, tempFate.y, tempFate.z)
                        nextFatePlayerDistance = GetDistanceToPoint(nextFate.x, nextFate.y, nextFate.z)
                        if tempFatePlayerDistance < nextFatePlayerDistance then
                            LogInfo("[FATE] Selecting #"..tempFate.fateId.." because other fate #"..nextFate.fateId.." is farther.")
                            return tempFate
                        elseif tempFatePlayerDistance > nextFatePlayerDistance then
                            LogInfo("[FATE] Selecting #"..nextFate.fateId.." because other fate #"..nextFate.fateId.." is farther.")
                            return nextFate
                        else
                            if tempFate.fateId < nextFate.fateId then
                                return tempFate
                            else
                                return nextFate
                            end
                        end
                    end
                end
            end
        end
    end
    return nextFate
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
        if Echo == 2 then
            yield("/echo [FATE] No eligible fates found.")
        end
    else
        LogInfo("[FATE] Final selected fate #"..nextFate.fateId.." "..nextFate.fateName)
    end
    yield("/wait 1")

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

function GetClosestAetheryte(x, y, z, teleportTimePenalty)
    local closestAetheryte = nil
    local closestTravelDistance = math.maxinteger
    for _, aetheryte in ipairs(SelectedZone.aetheryteList) do
        local distanceAetheryteToFate = DistanceBetween(aetheryte.x, aetheryte.y, aetheryte.z, x, y, z)
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
        local closestAetheryteDistance = DistanceBetween(x, y, z, closestAetheryte.x, closestAetheryte.y, closestAetheryte.z) + teleportTimePenalty

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
        yield("/wait 5")
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
    if SuccessiveInstanceChanges >= 3 then
        yield("/wait 1")
        SuccessiveInstanceChanges = 0
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

    if WaitingForCollectionsFate ~= 0 then
        yield("/wait 10")
        return
    end

    if GetDistanceToTarget() > 10 then
        LogInfo("[FATE] Targeting aetheryte, but greater than 10 distance")
        if GetDistanceToTarget() > 20 and not GetCharacterCondition(CharacterCondition.flying) then
            State = CharacterState.mounting
            LogInfo("[FATE] State Change: Mounting")
        elseif not (PathfindInProgress() or PathIsRunning()) then
            PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying))
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
    local nextInstance = (GetZoneInstance() % 3) + 1
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
            LogInfo("State Change: DoFate")
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

    yield("/target エーテライト")

    if HasTarget() and GetTargetName() == "エーテライト" and GetDistanceToTarget() <= 20 then
        if PathfindInProgress() or PathIsRunning() then
            yield("/vnav stop")
        end

        if GetCharacterCondition(CharacterCondition.flying) then
            yield("/mount") -- land but don't actually dismount, to avoid running chocobo timer
        elseif GetCharacterCondition(CharacterCondition.mounted) then
            State = CharacterState.ready
            LogInfo("[FATE] State Change: Ready")
        else
            if MountToUse == "マウント・ルーレット" then
                yield("/gaction マウント・ルーレット")
            else
                yield('/mount "' .. MountToUse)
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
        local closestAetheryte = GetClosestAetheryte(GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos(), 0)
        if closestAetheryte ~= nil then
            PathfindAndMoveTo(closestAetheryte.x, closestAetheryte.y, closestAetheryte.z, GetCharacterCondition(CharacterCondition.flying))
        end
    end
end

function Mount()
    if GetCharacterCondition(CharacterCondition.flying) then
        State = CharacterState.moveToFate
        LogInfo("[FATE] State Change: MoveToFate")
    elseif GetCharacterCondition(CharacterCondition.mounted) then
        yield("/gaction ジャンプ")
    else
        if MountToUse == "マウント・ルーレット" then
            yield("/gaction マウント・ルーレット")
        else
            yield('/mount "' .. MountToUse)
        end
    end
    yield("/wait 0.1")
end

function Dismount()
    if PathIsRunning() or PathfindInProgress() then
        yield("/vnav stop")
        return
    end

    if GetCharacterCondition(CharacterCondition.flying) then
        yield("/mount")

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
                    PathfindAndMoveTo(nearestPointX, nearestPointY, nearestPointZ, GetCharacterCondition(CharacterCondition.flying))
                    yield("/wait 1")
                end
            end

            LastStuckCheckTime = now
            LastStuckCheckPosition = {x=x, y=y, z=z}
        end
    elseif GetCharacterCondition(CharacterCondition.mounted) then
        yield("/mount")
    end
end

function MiddleOfFateDismount()
    if not IsFateActive(CurrentFate.fateId) then
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
        return
    end

    if HasTarget() then
        if DistanceBetween(GetPlayerRawXPos(), 0, GetPlayerRawZPos(), GetTargetRawXPos(), 0, GetTargetRawZPos()) > (MaxDistance + GetTargetHitboxRadius()) then
            if not (PathfindInProgress() or PathIsRunning()) then
                LogInfo("[FATE DEBUG] MiddleOfFateDismount PathfindAndMoveTo")
                PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying))
            end
        else
            if GetCharacterCondition(CharacterCondition.mounted) then
                LogInfo("[FATE DEBUG] MiddleOfFateDismount Dismount()")
                Dismount()
            else
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
            PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying))
        else
            yield("/vnav stop")
        end
        return
    end
end

--Paths to the Fate. CurrentFate is set here to allow MovetoFate to change its mind,
--so CurrentFate is possibly nil.
function MoveToFate()
    SuccessiveInstanceChanges = 0

    if not IsPlayerAvailable() then
        yield("/echo [FATE] Player not available")
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
        if HasPlugin("ChatCoordinates") then
            SetMapFlag(SelectedZone.zoneId, CurrentFate.x, CurrentFate.y, CurrentFate.z)
        end
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
    if HasTarget() then
        if GetTargetName() == CurrentFate.npcName then
            yield("/vnav stop")
            State = CharacterState.interactWithNpc
        elseif GetTargetFateID() == CurrentFate.fateId then
            yield("/vnav stop")
            State = CharacterState.middleOfFateDismount
            LogInfo("[FATE] State Change: MiddleOfFateDismount")
        else
            ClearTarget()
        end
        return
    elseif GetDistanceToPoint(CurrentFate.x, CurrentFate.y, CurrentFate.z) < 40 then
        if (CurrentFate.isOtherNpcFate or CurrentFate.isCollectionsFate) and not IsInFate() then
            yield("/target "..CurrentFate.npcName)
        else
            TargetClosestFateEnemy()
        end

        if HasTarget() and GetDistanceToTarget() < 30 then
            yield("/vnav stop")
        end
        return
    end

    -- if not PathIsRunning() and IsInFate() and GetFateProgress(CurrentFate.fateId) < 100 then
    --     State = CharacterState.doFate
    --     LogInfo("[FATE] State Change: DoFate")
    --     return
    -- end

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
                PathfindAndMoveTo(x, y + 10, z, GetCharacterCondition(CharacterCondition.flying)) -- fly up 10 then try again
            end
            
            LastStuckCheckTime = now
            LastStuckCheckPosition = {x=x, y=y, z=z}
        end
        return
    end

    -- if GetDistanceToPoint(CurrentFate.x, CurrentFate.y, CurrentFate.z) < GetFateRadius(CurrentFate.fateId) + 20 then
    --     if (IsOtherNpcFate(CurrentFate.fateName) or IsCollectionsFate(CurrentFate.fateName)) and CurrentFate.startTime == 0 then
    --         State = CharacterState.interactWithNpc
    --         LogInfo("[FATE] State Change: InteractWithFateNpc")
    --         return
    --     else
    --         if not PathIsRunning() and GetFateProgress(CurrentFate.fateId) < 100 then
    --             State = CharacterState.doFate
    --             LogInfo("[FATE] State Change: DoFate")
    --             return
    --         end
    --     end
    --     return
    -- end

    if not GetCharacterCondition(CharacterCondition.flying) then
        State = CharacterState.mounting
        LogInfo("[FATE] State Change: Mounting")
        return
    end

    LogInfo("[FATE] Moving to fate #"..CurrentFate.fateId.." "..CurrentFate.fateName)
    if Echo == 2 then
        yield("/echo [FATE] Moving to fate #"..CurrentFate.fateId.." "..CurrentFate.fateName)
    end

    local nearestLandX, nearestLandY, nearestLandZ = CurrentFate.x, CurrentFate.y, CurrentFate.z
    if not (CurrentFate.isCollectionsFate or CurrentFate.isOtherNpcFate) then
        nearestLandX, nearestLandY, nearestLandZ = RandomAdjustCoordinates(CurrentFate.x, CurrentFate.y, CurrentFate.z, 10)
    end

    if TeleportToClosestAetheryteToFate(CurrentFate) then
        return
    end

    PathfindAndMoveTo(nearestLandX, nearestLandY + 10, nearestLandZ, HasFlightUnlocked(SelectedZone.zoneId))
end

function InteractWithFateNpc()
    

    if IsInFate() or GetFateStartTimeEpoch(CurrentFate.fateId) > 0 then
        State = CharacterState.doFate
        LogInfo("[FATE] State Change: DoFate")
        yield("/wait 1") -- give the fate a second to register before dofate and lsync
    elseif not IsFateActive(CurrentFate.fateId) then
        State = CharacterState.ready
        LogInfo("[FATE] State Change: Ready")
    elseif PathfindInProgress() or PathIsRunning() then
        if HasTarget() and GetTargetName() == CurrentFate.npcName and GetDistanceToTarget() < 5 then
            yield("/vnav stop")
        end
        return
    else
        -- if target is already selected earlier during pathing, avoids having to target and move again
        if (not HasTarget() or GetTargetName()~=CurrentFate.npcName) then
            yield("/target "..CurrentFate.npcName)
            return
        end

        if GetDistanceToPoint(GetTargetRawXPos(), GetPlayerRawYPos(), GetTargetRawZPos()) > 5 then
            MoveToNPC()
            return
        end

        if GetCharacterCondition(CharacterCondition.mounted) then
            State = CharacterState.npcDismount
            LogInfo("[FATE] State Change: NPCDismount")
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

    if ShouldSummonChocobo and GetBuddyTimeRemaining() == 0 then
        if GetItemCount(4868) > 0 then
            yield("/item ギサールの野菜")
        elseif AutoBuyGysahlGreens then
            State = CharacterState.autoBuyGysahlGreens
            LogInfo("[State] State Change: AutoBuyGysahlGreens")
            return
        end
    end
    State = CharacterState.ready
    LogInfo("[State] State Change: Ready")
end

function AutoBuyGysahlGreens()
    if GetItemCount(4868) > 0 then -- don't need to buy
        if IsAddonVisible("Shop") then
            yield("/callback Shop true -1")
            State = CharacterState.ready
            LogInfo("State Change: ready")
            return
        elseif IsInZone(SelectedZone.zoneId) then
            yield("/item ギサールの野菜")
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
                yield("/echo has target")
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
            PathfindAndMoveTo(enemy_x, enemy_y, enemy_z, GetCharacterCondition(CharacterCondition.flying))
        end
        yield("/wait 0.1")
    end
end

-- function AvoidEnemiesWhileFlying()
--     --If you get attacked it flies up
--     if GetCharacterCondition(CharacterCondition.inCombat) then
--         Name = GetCharacterName()
--         PlocX = GetPlayerRawXPos(Name)
--         PlocY = GetPlayerRawYPos(Name)+40
--         PlocZ = GetPlayerRawZPos(Name)
--         yield("/gaction jump")
--         yield("/wait 0.5")
--         yield("/vnavmesh stop")
--         yield("/wait 1")
--         PathfindAndMoveTo(PlocX, PlocY, PlocZ, true)
--         PathStop()
--         yield("/wait 2")
--     end
-- end

function TurnOnAoes()
    if not AoesOn then
        if rotationMode == "manual" then
            yield("/rotation manual")
        else
            yield("/rotation auto on")
        end
        
        if RSRAoeType == "Cleave" then
            yield("/rotation settings aoetype 1")
        elseif RSRAoeType == "Full" then
            yield("/rotation settings aoetype 2")
        end
        AoesOn = true
    end
end

function TurnOffAoes()
    if AoesOn then
        yield("/rotation settings aoetype 0")
        yield("/rotation manual")
        AoesOn = false
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
        if rotationMode == "manual" then
            yield("/rotation manual")
        else
            yield("/rotation auto on")
        end

        local class = GetClassJobTableFromId(GetClassJobId())

        TurnOnAoes()
        
        if not bossModAIActive and UseBM then
            SetMaxDistance()
            
            if BMorBMR == "BMR" then
                yield("/bmrai on")
                yield("/bmrai followtarget on") -- overrides navmesh path and runs into walls sometimes
                yield("/bmrai followcombat on")
                -- yield("/bmrai followoutofcombat on")
                yield("/bmrai maxdistancetarget " .. MaxDistance)
            else
--                yield("/vbmai on")
--                yield("/vbmai followtarget on")
--                yield("/vbmai followcombat on")
                --yield("/vbmai followoutofcombat on")
            end
            bossModAIActive = true
        end
    end
end

function TurnOffCombatMods()
    if CombatModsOn then
        LogInfo("[FATE] Turning off combat mods")
        CombatModsOn = false

        yield("/rotation manual")
        -- yield("/wait 0.5")
        -- yield("/rotation off") -- rotation off doesn't always stick

        -- turn off BMR so you don't start following other mobs
        if UseBM and bossModAIActive then
            if BMorBMR == "BMR" then
--                yield("/bmrai off")
--                yield("/bmrai followtarget off")
--                yield("/bmrai followcombat off")
--                yield("/bmrai followoutofcombat off")
            else
--                yield("/vbmai off")
                --yield("/vbmai followtarget off")
                --yield("/vbmai followcombat off")
                --yield("/vbmai followoutofcombat off")
            end
            bossModAIActive = false
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
        return
    end

    if GetCharacterCondition(CharacterCondition.flying) then
        if not (PathfindInProgress() or PathIsRunning()) then
            PathfindAndMoveTo(GetPlayerRawXPos(), GetPlayerRawYPos() + 10, GetPlayerRawZPos(), true)
        end
        yield("/wait 10")
        return
    elseif GetCharacterCondition(CharacterCondition.mounted) then
        yield("/gaction ジャンプ")
        return
    end

    -- targets whatever is trying to kill you
    if not HasTarget() then
        yield("/battletarget")
    end

    --Paths to enemys when Bossmod is disabled
    if not UseBM then
        EnemyPathing()
    end

    -- pathfind closer if enemies are too far
    if HasTarget() then
        if GetDistanceToTarget() > (MaxDistance + GetTargetHitboxRadius()) then
            if not (PathfindInProgress() or PathIsRunning()) then
                PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying))
            end
        else
            if PathfindInProgress() or PathIsRunning() then
                yield("/vnav stop")
            elseif not GetCharacterCondition(CharacterCondition.inCombat) then
                --inch closer 3 seconds
                PathfindAndMoveTo(GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos(), GetCharacterCondition(CharacterCondition.flying))
                yield("/wait 3")
            end
        end
    end
    yield("/wait 0.5")
end

function DoFate()
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
        yield("/wait 0.5")
        PathfindAndMoveTo(CurrentFate.x, CurrentFate.y, CurrentFate.z, GetCharacterCondition(CharacterCondition.flying))
        return
    elseif not IsFateActive(CurrentFate.fateId) then
        yield("/vnav stop")
        ClearTarget()
        if not LogInfo("[FATE] HasContintuation check") and CurrentFate.hasContinuation then
            LastFateEndTime = os.clock()
            State = CharacterState.waitForContinuation
            LogInfo("[FATE] State Change: WaitForContinuation")
        else
            LogInfo("[FATE] No continuation for "..CurrentFate.fateName)
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
        WaitingForCollectionsFate = CurrentFate.fateId
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

    TurnOnCombatMods("auto")

    GemAnnouncementLock = false

    -- switches to targeting forlorns for bonus (if present)
    yield("/target フォーローン・メイデン")
    yield("/target フォーローン")

    if (GetTargetName() == "フォーローン・メイデン" or GetTargetName() == "フォーローン") then
        if GetTargetHP() > 0 then
            if not ForlornMarked then
--                yield("/enemysign attack1")
--                yield("/echo Found Forlorn! <se.3>")
--                TurnOffAoes()
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

    --Paths to enemys when Bossmod is disabled
    if not UseBM then
        EnemyPathing()
    end

    -- pathfind closer if enemies are too far
    if not GetCharacterCondition(CharacterCondition.inCombat) then
        if HasTarget() then
            if GetDistanceToTarget() <= (1 + GetTargetHitboxRadius()) then
                yield("/vnav stop")
            elseif not (PathfindInProgress() or PathIsRunning()) then
                yield("/wait 1")
                local x,y,z = GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos()
                if x ~= 0 and z~=0 then
                    PathfindAndMoveTo(x,y,z, GetCharacterCondition(CharacterCondition.flying))
                end
            end
            return
        else
            TargetClosestFateEnemy()
        end
    else
        if HasTarget() and GetDistanceToTarget() <= (MaxDistance + GetTargetHitboxRadius()) then
            yield("/vnav stop")
        else
            if not (PathfindInProgress() or PathIsRunning()) and not UseBM then
                yield("/wait 1")
                local x,y,z = GetTargetRawXPos(), GetTargetRawYPos(), GetTargetRawZPos()
                if x ~= 0 and z~=0 then
                    PathfindAndMoveTo(x,y,z, GetCharacterCondition(CharacterCondition.flying))
                end
            end
        end
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

    local shouldWaitForBonusBuff = WaitIfBonusBuff and HasStatusId(1289)

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
    elseif not LogInfo("[FATE] Ready -> WaitBonusBuff") and NextFate == nil and shouldWaitForBonusBuff then
        if not HasTarget() or GetTargetName() ~= "エーテライト" or GetDistanceToTarget() > 20 then
            State = CharacterState.flyBackToAetheryte
            LogInfo("[FATE] State Change: FlyBackToAetheryte")
        else
            yield("/wait 3")
        end
        return
    elseif not LogInfo("[FATE] Ready -> ExchangingVouchers") and WaitingForCollectionsFate == 0 and
        ShouldExchangeBicolorVouchers and (BicolorGemCount >= 1400) and not shouldWaitForBonusBuff
    then
        State = CharacterState.exchangingVouchers
        LogInfo("[FATE] State Change: ExchangingVouchers")
    elseif not LogInfo("[FATE] Ready -> ProcessRetainers") and WaitingForCollectionsFate == 0 and
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
    elseif not LogInfo("[FATE] Ready -> SummonChocobo") and ShouldSummonChocobo and GetBuddyTimeRemaining() == 0 and
        (not shouldWaitForBonusBuff or GetItemCount(4868) > 0) then
        State = CharacterState.summonChocobo
    elseif not LogInfo("[FATE] Ready -> ChangingInstances") and NextFate == nil then
        if EnableChangeInstance and GetZoneInstance() > 0 and not shouldWaitForBonusBuff then
            State = CharacterState.changingInstances
            LogInfo("[FATE] State Change: ChangingInstances")
        elseif not HasTarget() or GetTargetName() ~= "エーテライト" or GetDistanceToTarget() > 20 then
            State = CharacterState.flyBackToAetheryte
            LogInfo("[FATE] State Change: FlyBackToAetheryte")
        else
            yield("/wait 10")
        end
        return
    elseif not LogInfo("[FATE] Ready -> MovingToFate") then -- and ((CurrentFate == nil) or (GetFateProgress(CurrentFate.fateId) == 100) and NextFate ~= nil) then
        CurrentFate = NextFate
        if HasPlugin("ChatCoordinates") then
            SetMapFlag(SelectedZone.zoneId, CurrentFate.x, CurrentFate.y, CurrentFate.z)
        end
        State = CharacterState.moveToFate
        LogInfo("[FATE] State Change: MovingtoFate "..CurrentFate.fateName)
    end

    if not GemAnnouncementLock and Echo >= 1 then
        GemAnnouncementLock = true
        if BicolorGemCount >= 1400 then
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

    if GetCharacterCondition(CharacterCondition.dead) then --Condition Dead
        if Echo and not DeathAnnouncementLock then
            DeathAnnouncementLock = true
            yield("/echo [FATE] You have died. Returning to home aetheryte.")
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

function ExchangeOldVouchers()
    if not IsInZone(962) then
        TeleportTo("オールド・シャーレアン")
        return
    end

    if PathfindInProgress() or PathIsRunning() then
        return
    end

    local gadfrid = { x=74.17, y=5.15, z=-37.44}
    if GetDistanceToPoint(gadfrid.x, gadfrid.y, gadfrid.z) > 5 then
        PathfindAndMoveTo(gadfrid.x, gadfrid.y, gadfrid.z)
        yield("/ac スプリント")
    else
        if not HasTarget() or GetTargetName() ~= "広域交易商 ガドフリッド" then
            yield("/target 広域交易商 ガドフリッド")
        elseif not GetCharacterCondition(CharacterCondition.occupiedShopkeeper) then
            yield("/interact")
        end
    end
end

function ExchangeNewVouchers()
    if not IsInZone(1186) then
        TeleportTo("ソリューション・ナイン")
        return
    end

    local beryl = { x=-198.47, y=0.92, z=-6.95 }
    local nexusArcade = { x=-157.74, y=0.29, z=17.43 }
    if GetDistanceToPoint(beryl.x, beryl.y, beryl.z) > (DistanceBetween(nexusArcade.x, nexusArcade.y, nexusArcade.z, beryl.x, beryl.y, beryl.z) + 10) then
        LogInfo("Distance to Beryl is too far. Using mini aetheryte.")
        yield("/li ネクサスアーケード")
        yield("/wait 1") -- give it a moment to register
        return
    elseif IsAddonVisible("TelepotTown") then
            LogInfo("TelepotTown open")
            yield("/callback TelepotTown false -1")
    elseif GetDistanceToPoint(beryl.x, beryl.y, beryl.z) > 5 then
        LogInfo("Distance to Beryl is too far. Walking there.")
        if not (PathfindInProgress() or PathIsRunning()) then
            LogInfo("Path not running")
            PathfindAndMoveTo(beryl.x, beryl.y, beryl.z)
            yield("/ac スプリント")
        end
    else
        LogInfo("広域交易商 ベリル")
        if not HasTarget() or GetTargetName() ~= "広域交易商 ベリル" then
            yield("/target 広域交易商 ベリル")
        elseif not GetCharacterCondition(CharacterCondition.occupiedShopkeeper) then
            yield("/interact")
        end
    end
end

function ExchangeVouchers()
    CurrentFate = nil

    if BicolorGemCount >= 1400 then
        if IsAddonVisible("SelectYesno") then
            yield("/callback SelectYesno true 0")
            return
        end

        if IsAddonVisible("ShopExchangeCurrency") then
            yield("/callback ShopExchangeCurrency false 0 5 "..(BicolorGemCount//100))
            return
        end

        if VoucherTown == "オールド・シャーレアン" then
            ExchangeOldVouchers()
        else
            ExchangeNewVouchers()
        end
    else
        if IsAddonVisible("ShopExchangeCurrency") then
            yield("/callback ShopExchangeCurrency true -1")
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
                yield("/echo [FATE] Processing retainers")
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
    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtraction) then
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
                yield("/echo Out of Dark Matter! Purchasing more from Limsa Lominsa.")
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
                elseif not GetCharacterCondition(CharacterCondition.occupiedShopkeeper) then
                    yield("/interact")
                elseif IsAddonVisible("SelectYesno") then
                    yield("/callback SelectYesno true 0")
                elseif IsAddonVisible("Shop") then
                    yield("/callback Shop true 0 40 99")
                end
            end
        else
            yield("/echo Out of Dark Matter and ShouldAutoBuyDarkMatter is false. Switching to Limsa mender.")
            SelfRepair = false
        end
    else
        if NeedsRepair(RepairAmount) then
            if not IsInZone(129) then
                TeleportTo("リムサ・ロミンサ：下甲板層")
                return
            end

            local mender = { npcName="修理屋 アリステア", x=-246.87, y=16.19, z=49.83 }
            if GetDistanceToPoint(mender.x, mender.y, mender.z) > (DistanceBetween(hawkersAlleyAethernetShard.x, hawkersAlleyAethernetShard.y, hawkersAlleyAethernetShard.z, mender.x, mender.y, mender.z) + 10) then                yield("/li Hawkers' Alley")
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
                elseif not GetCharacterCondition(CharacterCondition.occupiedShopkeeper) then
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

    if GetCharacterCondition(CharacterCondition.occupiedMateriaExtraction) then
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
    exchangingVouchers = ExchangeVouchers,
    processRetainers = ProcessRetainers,
    gcTurnIn = GrandCompanyTurnIn,
    summonChocobo = SummonChocobo,
    autoBuyGysahlGreens = AutoBuyGysahlGreens
}

--#endregion State Transition Functions

--#region Main

GemAnnouncementLock = false
DeathAnnouncementLock = false
SuccessiveInstanceChanges = 0
LastInstanceChangeTimestamp = 0
LastTeleportTimeStamp = 0
GotCollectionsFullCredit = false -- needs 7 items for  full credit
LastStuckCheckTime = os.clock()
LastStuckCheckPosition = {x=GetPlayerRawXPos(), y=GetPlayerRawYPos(), z=GetPlayerRawZPos()}
MainClass = GetClassJobTableFromId(GetClassJobId())
BossFatesClass = nil
if ClassForBossFates ~= "" then
    BossFatesClass = GetClassJobTableFromAbbrev(ClassForBossFates)
end
SetMaxDistance()

local selectedZoneId = GetZoneID()
for i, zone in ipairs(FatesData) do
    if selectedZoneId == zone.zoneId then
        SelectedZone = zone
    end
end
if SelectedZone == nil then
    yield("/echo [FATE] Current zone is only partially supported. Will not teleport back on death or leaving.")
    SelectedZone = {
        zoneName = "Unknown Zone Name",
        zoneId = selectedZoneId,
        aetheryteList = {},
        fatesList= {
            collectionsFates= {},
            otherNpcFates= {},
            bossFates= {},
            blacklistedFates= {}
        }
    }
end


-- variable to track collections fates that you have completed but are still active.
-- will not leave area or change instance if value ~= 0
WaitingForCollectionsFate = 0
LastFateEndTime = os.clock()
State = CharacterState.ready
CurrentFate = nil
if IsInFate() and GetFateProgress(GetNearestFate()) < 100 then
    CurrentFate = BuildFateTable(GetNearestFate())
end

LogInfo("[FATE] Starting fate farming script.")
while true do
    if NavIsReady() then
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
            GetCharacterCondition(CharacterCondition.beingmoved70) or
            GetCharacterCondition(CharacterCondition.beingmoved75) or
            GetCharacterCondition(CharacterCondition.occupiedMateriaExtraction) or
            LifestreamIsBusy())
        then
            if WaitingForCollectionsFate ~= 0 and not IsFateActive(WaitingForCollectionsFate) then
                WaitingForCollectionsFate = 0
            end
            State()
        end
    end
    yield("/wait 0.1")
end

--#endregion Main