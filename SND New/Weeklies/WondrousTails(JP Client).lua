--[[
������ �ŏ���AutoDuty��Trust���J���A�t�F�C�X�̍X�V���s�����ƁI�I ������

********************************************************************************
*                             Wondrous Tails Doer                              *
*                                Version 0.3.0                                 *
********************************************************************************

Created by: pot0to (https://ko-fi.com/pot0to)
Updated by: Censored

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

    -> 0.3.0    Updated for newest SND Version
    -> 0.2.1    Duty names updated after patch 7.2
    -> 0.2.0    Fixes for ex trials
                Update for patch 7.1

********************************************************************************
*                               Required Plugins                               *
********************************************************************************
1. Autoduty
2. Rotation Solver Reborn
3. BossModReborn (BMR) or Veyn's BossMod (VBM)

********************************************************************************
*           Code: Don't touch this unless you know what you're doing           *
********************************************************************************
]]

import("System.Numerics")

local wonderousTailsDuties = {
    { -- type 0:extreme trials
        { dutyMode="Trial", instanceId=20010, dutyId=297, dutyName="�ɃK���[�_���Ő�" },
        { dutyMode="Trial", instanceId=20009, dutyId=296, dutyName="�Ƀ^�C�^�����Ő�" },
        { dutyMode="Trial", instanceId=20008, dutyId=295, dutyName="�ɃC�t���[�g���Ő�" },
        { dutyMode="Trial", instanceId=20012, dutyId=364, dutyName="�ɉ����O���E���OXII�����Ő�" },
        { dutyMode="Trial", instanceId=20018, dutyId=359, dutyName="�Ƀ����@�C�A�T�����Ő�" },
        { dutyMode="Trial", instanceId=20023, dutyId=375, dutyName="�Ƀ����E���Ő�" },
        { dutyMode="Trial", instanceId=20025, dutyId=378, dutyName="�ɃV���@���Ő�" },
        { dutyMode="Trial", instanceId=20013, dutyId=348, dutyName="���Ɍ��z �A���e�}�E�F�|���j����" },
        { dutyMode="Trial", instanceId=20032, dutyId=446, dutyName="�Ƀ��[���@�i���Ő�" },
        { dutyMode="Trial", instanceId=20036, dutyId=448, dutyName="���V���z �i�C�c�E�I�u�E���E���h���Ő�" },
        { dutyMode="Trial", instanceId=20038, dutyId=524, dutyName="�ɖ��_�Z�t�B���g���Ő�" },
        { dutyMode="Trial", instanceId=20040, dutyId=566, dutyName="�Ƀj�[�Y�w�b�O������" },
        { dutyMode="Trial", instanceId=20042, dutyId=577, dutyName="�ɏ��_�\�t�B�A���Ő�" },
    },
    { -- type 1: expansion cap dungeons
        { dutyMode="Trust", dutyName="Lv100�_���W����", dutyId=1292 }, --�i�v�H�� ���C���^�[�~�i��
    },
    2,
    3,
    { -- type 4: normal raids
        { dutyMode="Raid", dutyName="����{�o�n���[�g�F�琕�1-5", dutyId=241 }, --1�w
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
        { dutyMode="Regular", dutyName="���x�����O�_���W���� Lv51-59/61-69/71-79", dutyId=434 }, --�p�ԑ{�� �_�X�N���B�W��
        { dutyMode="Regular", dutyName="���x�����O�_���W���� Lv81-89/91-99", dutyId=952 }, --�ٌ`�O�t �]�b�g�̓�
    },
    { -- type 6: expansion cap dungeons
        { dutyMode="Regular", dutyName="�n�C���x�����O�_���W���� Lv50-60", dutyId=362 }, --���F�x�� �u���C�t���N�X�̖�c�n (Hard)
        { dutyMode="Regular", dutyName="�n�C���x�����O�_���W���� Lv70�E80", dutyId=788 }, --���؉��� �����V���[�k�A���� (Hard)
        { dutyMode="Trust", dutyName="�n�C���x�����O�_���W���� Lv90", dutyId=973 }, --�ŏI���z �����i���g
    },
    { -- type 7: ex trials

    },
    { -- type 8: alliance raids

    },
    { -- type 9: normal raids

    },
    -- BMR�Ŏ��s����Ɨ����ȂǂŎ��S����A�܂��̓\���ł̏������������
    Blacklisted= {
        { -- 0
            -- ���V
            { dutyMode="Trial", instanceId=20034, dutyId=447, dutyName="�Ƀr�X�}���N���Ő�" }, 
            { dutyMode="Trial", instanceId=20044, dutyId=638, dutyName="�ɋS�_�Y�����[�����Ő�" },
            -- �g�@
            { dutyMode="Trial", instanceId=20047, dutyId=677, dutyName="�ɃX�T�m�I���Ő�" },
            { dutyMode="Trial", instanceId=20049, dutyId=720, dutyName="�Ƀ��N�V���~���Ő�" },
            { dutyMode="Trial", instanceId=20052, dutyId=758, dutyName="�ɔ��Ր�����" },
            { dutyMode="Trial", instanceId=20054, dutyId=762, dutyName="�Ƀ��I���E�X���" },
            { dutyMode="Trial", instanceId=20056, dutyId=779, dutyName="�Ƀc�N���~���Ő�" },
            { dutyMode="Trial", instanceId=20058, dutyId=811, dutyName="�Ɏ鐝������" },
            { dutyMode="Trial", instanceId=20061, dutyId=825, dutyName="�ɋɐ�������" },
            -- ����
            { dutyMode="Trial", instanceId=20063, dutyId=858, dutyName="�Ƀe�B�^�[�j�A���Ő�" },
            { dutyMode="Trial", instanceId=20065, dutyId=848, dutyName="�ɃC�m�Z���X���Ő�" },
            { dutyMode="Trial", instanceId=20067, dutyId=885, dutyName="�Ƀn�[�f�X���Ő�" },
            { dutyMode="Trial", instanceId=20069, dutyId=912, dutyName="�Ƀ��r�[�E�F�|���j����" },
            { dutyMode="Trial", instanceId=20070, dutyId=913, dutyName="�ɃV�^�f���E�{�Y���ǉ���" },
            { dutyMode="Trial", instanceId=20072, dutyId=923, dutyName="�ɃE�H�[���C�A�E�I�u�E���C�g���Ő�" },
            { dutyMode="Trial", instanceId=20074, dutyId=935, dutyName="�ɃG�������h�E�F�|���j����" },
            { dutyMode="Trial", instanceId=20076, dutyId=951, dutyName="�Ƀ_�C���E�F�|���j����" },
            -- �Ō�
            { dutyMode="Trial", instanceId=20078, dutyId=996, dutyName="�Ƀn�C�f�������Ő�" },
            { dutyMode="Trial", instanceId=20081, dutyId=993, dutyName="�Ƀ]�f�B�A�[�N���Ő�" },
            { dutyMode="Trial", instanceId=20083, dutyId=998, dutyName="�I�ɂ̐킢" },
            { dutyMode="Trial", instanceId=20085, dutyId=1072, dutyName="�Ƀo���o���V�A���Ő�" },
            { dutyMode="Trial", instanceId=20087, dutyId=1096, dutyName="�Ƀ��r�J���e���Ő�" },
            { dutyMode="Trial", instanceId=20090, dutyId=1141, dutyName="�ɃS���x�[�U���Ő�" },
            { dutyMode="Trial", instanceId=20092, dutyId=1169, dutyName="�Ƀ[�����X���Ő�" },
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
            { dutyName="���V�̍��A���J�f�B�A�F���C�g�w�r�[��1-4", dutyId=1125 },
            { dutyName="���V�̍��A���J�f�B�A�F�N���[�U�[��1-2", dutyId=1231 },
            { dutyName="���V�̍��A���J�f�B�A�F�N���[�U�[��3-4", dutyId=1231 },
        }
    }
}

local currentLevel = Player.Job.Level
local khloe = {
    x = -19.346453,
    y = 210.99998,
    z = 0.086749226,
    name = "�N���E�A���A�|�["
}
local khloeVector3 = Vector3(khloe.x, khloe.y, khloe.z)

-- Region: Functions ---------------------------------------------------------------------------------

function SearchWonderousTailsTable(type, data, text)
    if type == 0 then -- ex trials are indexed by instance#
        for _, duty in ipairs(wonderousTailsDuties[type + 1]) do
            if duty.instanceId == data then
                return duty
            end
        end
    elseif type == 1 or type == 5 or type == 6 or type == 7 then -- dungeons, level range ex trials
        for _, duty in ipairs(wonderousTailsDuties[type + 1]) do
            if duty.dutyName == text then
                return duty
            end
        end
    elseif type == 4 or type == 8 then -- normal raids
        for _, duty in ipairs(wonderousTailsDuties[type + 1]) do
            if duty.dutyName == text then
                return duty
            end
        end
    end
end

-- Region: Main ---------------------------------------------------------------------------------

-- Pick up a journal if you need one
if Player.Bingo.IsWeeklyBingoExpired or Player.Bingo.WeeklyBingoNumPlacedStickers == 9 or not Player.Bingo.HasWeeklyBingoJournal then
    if not (Svc.ClientState.TerritoryType == 478) then
        yield("/li tp �C�f�B���V���C�A")
        yield("/wait 1")
    end

    repeat
        yield("/wait 1")
    until Svc.ClientState.TerritoryType == 478 and Player.Available

    IPC.vnavmesh.PathfindAndMoveTo(khloeVector3, false)

    repeat
        yield("/wait 1")
    until not (IPC.vnavmesh.PathfindInProgress() and IPC.vnavmesh.IsRunning())

    yield("/target " .. khloe.name)
    yield("/wait 1")
    yield("/interact")

    while not Addons.GetAddon("SelectString").Ready do
        yield("/click Talk Click")
        yield("/wait 1")
    end

    if Addons.GetAddon("SelectString").Ready then
        if not Player.Bingo.HasWeeklyBingoJournal then
            yield("/callback SelectString true 0")
        elseif Player.Bingo.IsWeeklyBingoExpired then
            yield("/callback SelectString true 1")
        elseif Player.Bingo.WeeklyBingoNumPlacedStickers == 9 then
            yield("/callback SelectString true 0")
        end
    end

    while Svc.Condition[32] do
        yield("/click Talk Click")
        yield("/wait 1")
    end

    yield("/wait 1")
end

-- skip 13: Shadowbringers raids (not doable solo unsynced)
-- skip 14: Endwalker raids (not doable solo unsynced)
-- skip 15: PVP
for i = 0, 12 do
    if Player.Bingo:GetWeeklyBingoTaskStatus(i) == WeeklyBingoTaskStatus.Open then
        local dataRow = Player.Bingo:GetWeeklyBingoOrderDataRow(i)
        local type = dataRow.Type
        local data = dataRow.Data
        local text = dataRow.Text.Description
        local duty = SearchWonderousTailsTable(type, data, text)
        local dutyMode = "Support"

        Dalamud.Log("[WondrousTails] Wonderous Tails #" .. (i + 1) .. " Type: " .. type)
        Dalamud.Log("[WondrousTails] Wonderous Tails #" .. (i + 1) .. " Data: " .. data)
        Dalamud.Log("[WondrousTails] Wonderous Tails #" .. (i + 1) .. " Text: " .. text)

        if duty == nil then
            yield("/echo duty is nil")
        end

        if duty ~= nil then
            if duty.dutyMode == "Trust" then
                IPC.AutoDuty.SetConfig("Unsynced", "false")
            else
                IPC.AutoDuty.SetConfig("Unsynced", "true")
            end

            if duty.dutyId ~= nil then
                -- IPC.AutoDuty.Run(duty.dutyId, 1, false)

                yield("/echo Queuing  Mode:".. duty.dutyMode .. ", DutyID:" .. duty.dutyId .. ", Name:" .. duty.dutyName)
                yield("/autoduty run " .. duty.dutyMode .. " " .. duty.dutyId .. " 1 true")
                yield("/wait 10")

                repeat
                    yield("/wait 1")
                until not IPC.AutoDuty.IsLooping()

                yield("/wait 10")
            else
                if duty.dutyName ~= nil then
                    yield("/echo Wonderous Tails Script does not support Wonderous Tails entry #" .. (i + 1) .. " " .. duty.dutyName)
                    Dalamud.Log("[WonderousTails] Wonderous Tails Script does not support Wonderous Tails entry #" .. (i + 1) .. " " .. duty.dutyName)
                else
                    yield("/echo Wonderous Tails Script does not support Wonderous Tails entry #" .. (i + 1))
                    Dalamud.Log("[WonderousTails] Wonderous Tails Script does not support Wonderous Tails entry #" .. (i + 1))
                end
            end
        end
    end
end

yield("/echo Completed all Wonderous Tails entries it is capable of.<se.3>")