--[[
������ �ŏ���AutoDuty��Trust���J���A�t�F�C�X�̍X�V���s�����ƁI�I ������

********************************************************************************
*                             Wondrous Tails Doer                              *
*                                Version 0.2.1                                 *
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
        { dutyMode="Trial", instanceId=20010, dutyId=297, dutyName="�ɃK���[�_���Ő�" },
        { dutyMode="Trial", instanceId=20009, dutyId=296, dutyName="�Ƀ^�C�^�����Ő�" },
        { dutyMode="Trial", instanceId=20008, dutyId=295, dutyName="�ɃC�t���[�g���Ő�" },
        { dutyMode="Trial", instanceId=20012, dutyId=364, dutyName="�ɉ����O���E���OXII�����Ő�" },
        { dutyMode="Trial", instanceId=20018, dutyId=359, dutyName="�Ƀ����@�C�A�T�����Ő�" },
        { dutyMode="Trial", instanceId=20023, dutyId=375, dutyName="�Ƀ����E���Ő�" },
        { dutyMode="Trial", instanceId=20025, dutyId=378, dutyName="�ɃV���@���Ő�" },
        { dutyMode="Trial", instanceId=20013, dutyId=348, dutyName="���Ɍ��z �A���e�}�E�F�|���j����" },
        { dutyMode="Trial", instanceId=20034, dutyId=447, dutyName="�Ƀr�X�}���N���Ő�" },
        { dutyMode="Trial", instanceId=20032, dutyId=446, dutyName="�Ƀ��[���@�i���Ő�" },
        { dutyMode="Trial", instanceId=20036, dutyId=448, dutyName="���V���z �i�C�c�E�I�u�E���E���h���Ő�" },
        { dutyMode="Trial", instanceId=20038, dutyId=524, dutyName="�ɖ��_�Z�t�B���g���Ő�" },
        { dutyMode="Trial", instanceId=20040, dutyId=566, dutyName="�Ƀj�[�Y�w�b�O������" },
        { dutyMode="Trial", instanceId=20042, dutyId=577, dutyName="�ɏ��_�\�t�B�A���Ő�" },
        { dutyMode="Trial", instanceId=20044, dutyId=638, dutyName="�ɋS�_�Y�����[�����Ő�" },
        { dutyMode="Trial", instanceId=20049, dutyId=720, dutyName="�Ƀ��N�V���~���Ő�" },
--        { dutyMode="Trial", instanceId=20056, dutyId=779, dutyName="�Ƀc�N���~���Ő�" },
--        { dutyMode="Trial", instanceId=20058, dutyId=811, dutyName="�Ɏ鐝������" },
--        { dutyMode="Trial", instanceId=20054, dutyId=762, dutyName="�Ƀ��I���E�X���" },
--        { dutyMode="Trial", instanceId=20061, dutyId=825, dutyName="�ɋɐ�������" },
--        { dutyMode="Trial", instanceId=20063, dutyId=858, dutyName="�Ƀe�B�^�[�j�A���Ő�" },
--        { dutyMode="Trial", instanceId=20065, dutyId=848, dutyName="�ɃC�m�Z���X���Ő�" },
--        { dutyMode="Trial", instanceId=20067, dutyId=885, dutyName="�Ƀn�[�f�X���Ő�" },
--        { dutyMode="Trial", instanceId=20069, dutyId=912, dutyName="�Ƀ��r�[�E�F�|���j����" },
--        { dutyMode="Trial", instanceId=20070, dutyId=913, dutyName="�ɃV�^�f���E�{�Y���ǉ���" },
--        { dutyMode="Trial", instanceId=20072, dutyId=923, dutyName="�ɃE�H�[���C�A�E�I�u�E���C�g���Ő�" },
--        { dutyMode="Trial", instanceId=20074, dutyId=935, dutyName="�ɃG�������h�E�F�|���j����" },
--        { dutyMode="Trial", instanceId=20076, dutyId=951, dutyName="�Ƀ_�C���E�F�|���j����" },
--        { dutyMode="Trial", instanceId=20078, dutyId=996, dutyName="�Ƀn�C�f�������Ő�" },
--        { dutyMode="Trial", instanceId=20081, dutyId=993, dutyName="�Ƀ]�f�B�A�[�N���Ő�" },
--        { dutyMode="Trial", instanceId=20083, dutyId=998, dutyName="�I�ɂ̐킢" },
--        { dutyMode="Trial", instanceId=20085, dutyId=1072, dutyName="�Ƀo���o���V�A���Ő�" },
--        { dutyMode="Trial", instanceId=20087, dutyId=1096, dutyName="�Ƀ��r�J���e���Ő�" },
--        { dutyMode="Trial", instanceId=20090, dutyId=1141, dutyName="�ɃS���x�[�U���Ő�" },
--        { dutyMode="Trial", instanceId=20092, dutyId=1169, dutyName="�Ƀ[�����X���Ő�" }
    },
    { -- type 1: expansion cap dungeons
        { dutyMode="Trust", dutyName="Lv100�_���W����", dutyId=1199 }, --�L�����z �A���N�T���h���A
    },
    2,
    3,
    { -- type 4: normal raids
        { dutyMode="Raid", dutyName="����{�o�n���[�g�F�琕�1-4", dutyId=241 }, --1�w
        { dutyMode="Raid", dutyName="����{�o�n���[�g�F�N�U��1-4", dutyId=355 }, --1�w
--        { dutyMode="Raid", dutyName="����{�o�n���[�g�F�^����1-4", dutyId=193 }, --1�w
        { dutyMode="Raid", dutyName="�@�H��A���L�T���_�[�F�N����1-4", dutyId=442 },  --1�w
        { dutyMode="Raid", dutyName="�@�H��A���L�T���_�[�F������1-4", dutyId=520 },  --1�w
        { dutyMode="Raid", dutyName="�@�H��A���L�T���_�[�F�V����1-4", dutyId=580 },  --1�w
        { dutyMode="Raid", dutyName="�����̋��ԃI���K�F�f���^��1-4", dutyId=693 },  --3�w
        { dutyMode="Raid", dutyName="�����̋��ԃI���K�F�V�O�}��1-4", dutyId=748 },  --1�w
        { dutyMode="Raid", dutyName="�����̋��ԃI���K�F�I���K��1-4", dutyId=798 },  --1�w
--        { dutyMode="Raid", dutyName="��]�̉��G�f���F�o����1", dutyId=849 },
--        { dutyMode="Raid", dutyName="��]�̉��G�f���F����1", dutyId=903 },
--        { dutyMode="Raid", dutyName="��]�̉��G�f���F�Đ���1", dutyId=942 },
    },
    { -- type 5: leveling dungeons
        { dutyMode="Trial", dutyName="���x�����O�_���W���� Lv1-49", dutyId=1045 }, --�C�t���[�g������
        { dutyMode="Regular", dutyName="���x�����O�_���W���� Lv51-79", dutyId=434 }, --�p�ԑ{�� �_�X�N���B�W��
        { dutyMode="Regular", dutyName="���x�����O�_���W���� Lv81-99", dutyId=952 }, --�ٌ`�O�t �]�b�g�̓�
    },
    { -- type 6: expansion cap dungeons
        { dutyMode="Regular", dutyName="�n�C���x�����O�_���W���� Lv50-60", dutyId=362 }, --���F�x�� �u���C�t���N�X�̖�c�n (Hard)
        { dutyMode="Regular", dutyName="�n�C���x�����O�_���W���� Lv70-80", dutyId=788 }, --���؉��� �����V���[�k�A���� (Hard)
        { dutyMode="Trust", dutyName="�n�C���x�����O�_���W���� Lv90", dutyId=973 }, --�ŏI���z �����i���g
    },
    { -- type 7: ex trials
        {
            { instanceId=20008, dutyId=295, dutyName="Trials (Lv. 50-60)" }, -- Bowl of Embers
            { instanceId=20049, dutyId=720, dutyName="Trials (Lv. 70-100)" }
        }
    },
    { -- type 8: alliance raids

    },
    { -- type 9: normal raids
        { dutyName="Normal Raids (Lv. 50-60)", dutyId=241 },
        { dutyName="Normal Raids (Lv. 70-80)", dutyId=693 },
    },
    Blacklisted= {
        { -- 0
            { instanceId=20052, dutyId=758, dutyName="�ɔ��Ր�����" }, -- cannot solo double tankbuster vuln
            { instanceId=20047, dutyId=677, dutyName="�ɃX�T�m�I���Ő�" }, -- �A�N�e�B�u�^�C���}�j���[�o���ł��Ȃ�����
            { instanceId=20056, dutyId=779, dutyName="�Ƀc�N���~���Ő�" } -- cannot solo meteors
        },
        {}, -- 1
        {}, -- 2
        { -- 3
            { dutyName="Treasure Dungeons" }
        },
        { -- 4
            { dutyName="�A���C�A���X���C�h�i�V���G�I���[�A�j", dutyId=174 },
            { dutyName="�A���C�A���X���C�h�i���V�̃C�V���K���h�j", dutyId=508 },
            { dutyName="�A���C�A���X���C�h�i�g�@�̃��x���[�^�[�j", dutyId=734 },
            { dutyName="�A���C�A���X���C�h�i�����̃��B�����Y�j", dutyId=882 },
            { dutyName="�A���C�A���X���C�h�i�Ō��̃t�B�i�[���j", dutyId=1054 },
            { dutyName="�����a�p���f���j�E���F�Ӎ���1-4", dutyId=1002 },
            { dutyName="�����a�p���f���j�E���F������1-4", dutyId=1081 },
            { dutyName="�����a�p���f���j�E���F�V����1-4", dutyId=1147 },
            { dutyName="���V�̍��A���J�f�B�A�F���C�g�w�r�[��1-2", dutyId=1125 },
            { dutyName="���V�̍��A���J�f�B�A�F���C�g�w�r�[��3-4", dutyId=1231 }
        }
    }
}

Khloe = {
    x = -19.346453,
    y = 210.99998,
    z = 0.086749226,
    name = "�N���E�A���A�|�["
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
        yield("/tp �C�f�B���V���C�A")
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
            if duty.dutyId == 952 then
                yield("/gs change �i�C�g")
                yield("/wait 1")
            end
            if duty.dutyMode == "Trust" then
                yield("/autoduty cfg Unsynced false")
            else
                yield("/autoduty cfg Unsynced true")
            end

            if duty.dutyId ~= nil then
                yield("/autoduty run "..duty.dutyMode.." "..duty.dutyId.." 1 true")
                yield("/echo [WonderousTails] ���s���i"..(i+1).."�}�X�ځj�F"..duty.dutyName)
                yield("/bmrai on")
                yield("/rotation auto")
                yield("/rotation settings aoetype 2")
                yield("/wait 10")
                while GetCharacterCondition(34) or GetCharacterCondition(51) or GetCharacterCondition(56) do -- wait for duty to be finished
                    if GetCharacterCondition(2) and i > 4 then -- dead, not a dungeon
                        yield("/echo [WonderousTails] ���S��������"..duty.dutyName.."�̎��s���X�L�b�v���܂����B")
                        repeat
                            yield("/wait 1")
                        until not GetCharacterCondition(2)
                        LeaveDuty()
                        break
                    end
                    yield("/wait 1")
                end
                yield("/wait 7")
            else
                if duty.dutyName ~= nil then
                    yield("/echo �{�X�N���v�g�ł͑Ή����Ă��Ȃ�ID�A�܂��̓��C�h�ł��B �i"..(i+1).."�}�X�ځj�F"..duty.dutyName)
                    LogInfo("[WonderousTails] �{�X�N���v�g�ł͑Ή����Ă��Ȃ�ID�A�܂��̓��C�h�ł��B �i"..(i+1).."�}�X�ځj�F"..duty.dutyName)
                else
                    yield("/echo �{�X�N���v�g�ł͑Ή����Ă��Ȃ�ID�A�܂��̓��C�h�ł��B �i"..(i+1).."�}�X�ځj�F")
                    LogInfo("[WonderousTails] �{�X�N���v�g�ł͑Ή����Ă��Ȃ�ID�A�܂��̓��C�h�ł��B �i"..(i+1).."�}�X�ځj�F")
                end
            end
        end
    end
end

yield("/rotation settings aoetype 1")
yield("/echo ���s�\�ȋ�z���̃}�X�����ׂĊ������܂����B <se.3>")