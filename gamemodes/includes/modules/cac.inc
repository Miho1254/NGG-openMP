#if defined _modules_cac_included
    #endinput
#endif

#define _modules_cac_included

#include <YSI\y_hooks>

#define MAX_ITEM_TRADE_NEFT 1

enum pc_Info
{
    pc_Pass[4],
    pc_GP,
    pc_Coin,
    pc_EA, // exp adventure
    pc_FoodBar,
    pc_WaterBar,
    pc_Job,
    pc_Job2,
    pc_Job3,
    pc_FishmanSkill,
    pc_AlcoholSkill,
    pc_PizzaBoySkill,
    pc_SweeperSkill,
    pc_TruckerSkill,
    pc_AlcoholLimit, // gioi han lam viec
    pc_SweeperLimit, // gioi han lam viec
    pc_AlcoholTimer, // mo khoa gioi han lam viec
    pc_SweeperTimer, // mo khoa gioi han lam viec
    pc_CaribbeanTeam, // thông tin phe tham gia
    pc_CaribbeanEvent, // tình trạng tham gia
    pc_FamedPoint, // Điểm danh vọng
    pc_LimitEventReward, // nhận quà đền bù
    pc_ClaimRoseWinter, // thu thập hoa hồng
    pc_CargoTimeOnline, // thoi gian lam viec cua job nguoi van chuyen
    pc_CargoTimeSeconds, // thoi gian ++ cua nguoi van chuyen
    pc_ItemTradeNeft_Miner, // neft giao dịch vật phẩm
    pc_ItemTradeNeftExpire_Miner // thời gian neft giao dịch vật phẩm
};
new PlayerData[MAX_PLAYERS][pc_Info];

new pc_PassKey[][] =
{
    "1","2","3","4","5","6","7","8","9","Reset","Hoan thanh"
};

new temppc_Pass[MAX_PLAYERS][4];
new temppc_Login[MAX_PLAYERS];

CMD:taikhoan(playerid, params[])
{
    return callcmd::account(playerid, params);
}

CMD:account(playerid, params[])
{
    new
        szPass[30],
        str[45];
    if(PlayerData[playerid][pc_Pass][0] > 0)
    {
        szPass = "{22FF00}Dang su dung";
    }
    else
    {
        szPass = "{FF0000}Dang tat";
    }
    format(str, sizeof(str), "{DBDBDB}Mat khau 4 so\t%s", szPass);
    Dialog_Show(playerid, DIALOG_CONFIG_ACCOUNT, DIALOG_STYLE_TABLIST, "Cai dat tai khoan", str, "Chon", "Thoat");
    return 1;
}

CMD:gtasa_setmygp(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        if(PlayerInfo[playerid][pAdmin] > 1337)
        {
            new amount;
            if(sscanf(params, "i", amount))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gtasa_setmygp [amount]");
            }
            if(amount < 0) return 1;
            if(amount >= 0)
            {
                new string[65];
                format(string, sizeof(string), "* Da set %d GP.", amount);
                SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
                PlayerData[playerid][pc_GP] = amount;
            }
        }
    }
    return 1;
}

Function: GetPlayerConfigAccount(playerid)
{
    new szQuery[128];
    mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT * FROM `account2` WHERE `UID` = %d LIMIT 1", PlayerInfo[playerid][pId]);
    mysql_tquery(MainPipeline, szQuery, "CheckPlayerConfigAccount", "i", playerid);
    return 1;
}

Function: CheckPlayerConfigAccount(playerid)
{
    new rows, i, z, y, szQuery[128], str[128];
    cache_get_row_count(rows);
    if(rows > 0)
    {
        while(i < rows)
        {
            cache_get_value_name_int(i, "GP", PlayerData[playerid][pc_GP]);
            cache_get_value_name_int(i, "Coin", PlayerData[playerid][pc_Coin]);
            cache_get_value_name_int(i, "EA", PlayerData[playerid][pc_EA]);
            cache_get_value_name_int(i, "FoodBar", PlayerData[playerid][pc_FoodBar]);
            cache_get_value_name_int(i, "WaterBar", PlayerData[playerid][pc_WaterBar]);
            cache_get_value_name_int(i, "Job", PlayerData[playerid][pc_Job]);
            cache_get_value_name_int(i, "Job2", PlayerData[playerid][pc_Job2]);
            cache_get_value_name_int(i, "Job3", PlayerData[playerid][pc_Job3]);
            cache_get_value_name_int(i, "FishmanSkill", PlayerData[playerid][pc_FishmanSkill]);
            cache_get_value_name_int(i, "AlcoholSkill", PlayerData[playerid][pc_AlcoholSkill]);
            cache_get_value_name_int(i, "PizzaBoySkill", PlayerData[playerid][pc_PizzaBoySkill]);
            cache_get_value_name_int(i, "SweeperSkill", PlayerData[playerid][pc_SweeperSkill]);
            cache_get_value_name_int(i, "TruckerSkill", PlayerData[playerid][pc_TruckerSkill]);
            cache_get_value_name_int(i, "AlcoholLimit", PlayerData[playerid][pc_AlcoholLimit]);
            cache_get_value_name_int(i, "SweeperLimit", PlayerData[playerid][pc_SweeperLimit]);
            cache_get_value_name_int(i, "AlcoholTimer", PlayerData[playerid][pc_AlcoholTimer]);
            cache_get_value_name_int(i, "SweeperTimer", PlayerData[playerid][pc_SweeperTimer]);
            cache_get_value_name_int(i, "CaribbeanTeam", PlayerData[playerid][pc_CaribbeanTeam]);
            cache_get_value_name_int(i, "CaribbeanEvent", PlayerData[playerid][pc_CaribbeanEvent]);
            cache_get_value_name_int(i, "FamedPoint", PlayerData[playerid][pc_FamedPoint]);
            cache_get_value_name_int(i, "LimitEventReward", PlayerData[playerid][pc_LimitEventReward]);
            cache_get_value_name_int(i, "ClaimRoseWinter", PlayerData[playerid][pc_ClaimRoseWinter]);
            cache_get_value_name_int(i, "CargoTimeOnline", PlayerData[playerid][pc_CargoTimeOnline]);
            cache_get_value_name_int(i, "CargoTimeSeconds", PlayerData[playerid][pc_CargoTimeSeconds]);
            cache_get_value_name_int(i, "ItemTradeNeftMiner", PlayerData[playerid][pc_ItemTradeNeft_Miner]);
            cache_get_value_name_int(i, "ItemTradeNeftExpireMiner", PlayerData[playerid][pc_ItemTradeNeftExpire_Miner]);
            for(z = 0 ; z < 4 ; z++)
            {
                temppc_Pass[playerid][z] = 0;
                format(str, sizeof(str), "pc_Pass%d", z);
                cache_get_value_name_int(i, str, PlayerData[playerid][pc_Pass][z]);

                if(z == 3 && PlayerData[playerid][pc_Pass][z] != 0)
                {
                    str[0] = 0;
                    temppc_Login[playerid] = 0;
                    for(y = 0 ; y < sizeof(pc_PassKey) ; y++)
                    {
                        format(str, sizeof(str), "%s\n%s", str, pc_PassKey[y]);
                    }
                    Dialog_Show(playerid, DIALOG_INPUT_FINPASS, DIALOG_STYLE_LIST, "Mat khau 4 so", str, "Chon","");
                }
                if(z == 3 && PlayerData[playerid][pc_Pass][z] == 0)
                {
                    OnPlayerLoad(playerid);
                }
            }
            i++;
        }
    }
    else
    {
        mysql_format(MainPipeline, szQuery, sizeof(szQuery), "INSERT INTO `account2` (`UID`) VALUES (%d)", PlayerInfo[playerid][pId]);
        mysql_tquery(MainPipeline, szQuery);

        OnPlayerLoad(playerid);
    }
    return 1;
}

Function: SavePlayerAccountic(playerid)
{
    SAC_Integer(GetPlayerSQLId(playerid), "GP", PlayerData[playerid][pc_GP]);
    SAC_Integer(GetPlayerSQLId(playerid), "Coin", PlayerData[playerid][pc_Coin]);
    SAC_Integer(GetPlayerSQLId(playerid), "EA", PlayerData[playerid][pc_EA]);
    SAC_Integer(GetPlayerSQLId(playerid), "FoodBar", PlayerData[playerid][pc_FoodBar]);
    SAC_Integer(GetPlayerSQLId(playerid), "WaterBar", PlayerData[playerid][pc_WaterBar]);
    SAC_Integer(GetPlayerSQLId(playerid), "Job", PlayerData[playerid][pc_Job]);
    SAC_Integer(GetPlayerSQLId(playerid), "Job2", PlayerData[playerid][pc_Job2]);
    SAC_Integer(GetPlayerSQLId(playerid), "Job3", PlayerData[playerid][pc_Job3]);
    SAC_Integer(GetPlayerSQLId(playerid), "FishmanSkill", PlayerData[playerid][pc_FishmanSkill]);
    SAC_Integer(GetPlayerSQLId(playerid), "AlcoholSkill", PlayerData[playerid][pc_AlcoholSkill]);
    SAC_Integer(GetPlayerSQLId(playerid), "PizzaBoySkill", PlayerData[playerid][pc_PizzaBoySkill]);
    SAC_Integer(GetPlayerSQLId(playerid), "SweeperSkill", PlayerData[playerid][pc_SweeperSkill]);
    SAC_Integer(GetPlayerSQLId(playerid), "TruckerSkill", PlayerData[playerid][pc_TruckerSkill]);
    SAC_Integer(GetPlayerSQLId(playerid), "AlcoholLimit", PlayerData[playerid][pc_AlcoholLimit]);
    SAC_Integer(GetPlayerSQLId(playerid), "SweeperLimit", PlayerData[playerid][pc_SweeperLimit]);
    SAC_Integer(GetPlayerSQLId(playerid), "AlcoholTimer", PlayerData[playerid][pc_AlcoholTimer]);
    SAC_Integer(GetPlayerSQLId(playerid), "SweeperTimer", PlayerData[playerid][pc_SweeperTimer]);
    SAC_Integer(GetPlayerSQLId(playerid), "CaribbeanTeam", PlayerData[playerid][pc_CaribbeanTeam]);
    SAC_Integer(GetPlayerSQLId(playerid), "CaribbeanEvent", PlayerData[playerid][pc_CaribbeanEvent]);
    SAC_Integer(GetPlayerSQLId(playerid), "FamedPoint", PlayerData[playerid][pc_FamedPoint]);
    SAC_Integer(GetPlayerSQLId(playerid), "LimitEventReward", PlayerData[playerid][pc_LimitEventReward]);
    SAC_Integer(GetPlayerSQLId(playerid), "ClaimRoseWinter", PlayerData[playerid][pc_ClaimRoseWinter]);
    SAC_Integer(GetPlayerSQLId(playerid), "CargoTimeOnline", PlayerData[playerid][pc_CargoTimeOnline]);
    SAC_Integer(GetPlayerSQLId(playerid), "CargoTimeSeconds", PlayerData[playerid][pc_CargoTimeSeconds]);
    SAC_Integer(GetPlayerSQLId(playerid), "ItemTradeNeftMiner", PlayerData[playerid][pc_ItemTradeNeft_Miner]);
    SAC_Integer(GetPlayerSQLId(playerid), "ItemTradeNeftExpireMiner", PlayerData[playerid][pc_ItemTradeNeftExpire_Miner]);
    return 1;
}

stock SAC_Integer(SQLId, const field[], value)
{
    new szQuery[128];
    mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `account2` SET `%s` = %d WHERE `UID` = %d", field, value, SQLId);
    mysql_tquery(MainPipeline, szQuery);
    return 1;
}

Dialog:DIALOG_CONFIG_ACCOUNT(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[256];
        new i;
        if(strcmp(inputtext, "Mat khau 4 so", true) == 0)
        {
            if(PlayerData[playerid][pc_Pass][0] > 0)
            {
                format(str, sizeof(str), "{FFFFFF}Ban co chac muon {FF0000}tat mat khau 4 so {FFFFFF}khong?\nNeu tat ban se khong duoc yeu cau nhap mat khau 4 so o lan dang nhap tiep theo nua.");
                return Dialog_Show(playerid, DIALOG_TOGGLE_FINPASS, DIALOG_STYLE_MSGBOX, "Mat khau 4 so", str, "Dong Y", "Thoat");
            }
            for(i = 0 ; i < sizeof(pc_PassKey) ; i++)
            {
                format(str, sizeof(str), "%s\n%s", str, pc_PassKey[i]);
            }
            return Dialog_Show(playerid, DIALOG_INPUT_FINPASS, DIALOG_STYLE_LIST, "Mat khau 4 so", str, "Chon","");
        }
    }
    else
    {
        return 1;
    }
    return 1;
}

Dialog:DIALOG_TOGGLE_FINPASS(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[124], szQuery[128];
        SendClientMessageEx(playerid, COLOR_WHITE, "[{9DFF00}PC{FFFFFF}]: Ban da lua chon phuong an 'tat' mat khau bao ve 4 so.");
        SendClientMessageEx(playerid, COLOR_GREY, "[PC]: Ban khong can phai nhap mat khau 4 so o lan dang nhap tiep theo nua.");

        for(new i = 0 ; i < 4 ; i++)
        {
            PlayerData[playerid][pc_Pass][i] = 0;
            temppc_Pass[playerid][i] = 0;
            format(str, sizeof(str), "pc_Pass%d", i);
            mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `account2` SET `%s` = %d WHERE `UID` = %d", str, temppc_Pass[playerid][i], PlayerInfo[playerid][pId]);
            mysql_tquery(MainPipeline, szQuery);
        }
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[{9DFF00}PC{FFFFFF}]: Ban da lua chon phuong an 'tiep tuc su dung' mat khau 4 so.");
        return 1;
    }
    return 1;
}

Dialog:DIALOG_INPUT_FINPASS(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new i, z, str[124], szQuery[124];
        if(strcmp(inputtext, "Reset", true) != 0 && strcmp(inputtext, "Hoan thanh", true) != 0)
        {
            for(i = 0 ; i < 4 ; i++)
            {
                if(temppc_Pass[playerid][i] == 0)
                {
                    temppc_Pass[playerid][i] = listitem + 1;
                    format(str, sizeof(str), "[{58732E}PC{FFFFFF}]: Okay! lua chon (%d) la {FF0000}[%d]{FFFFFF}.", i+1, listitem+1);
                    SendClientMessage(playerid, COLOR_WHITE, str);
                    if(i == 3) SendClientMessage(playerid, COLOR_WHITE, "[{58732E}PC{FFFFFF}]: Ban da nhap day du mat khau, hay bam 'Hoan thanh' de dang nhap!");
                    str[0] = 0;
                    for(i = 0 ; i < sizeof(pc_PassKey) ; i++)
                    {
                        format(str, sizeof(str), "%s\n%s", str, pc_PassKey[i]);
                    }
                    return Dialog_Show(playerid, DIALOG_INPUT_FINPASS, DIALOG_STYLE_LIST, "Mat khau 4 so", str, "Chon","");
                }
                if(temppc_Pass[playerid][0] != 0 && temppc_Pass[playerid][1] != 0 && temppc_Pass[playerid][2] != 0 && temppc_Pass[playerid][3] != 0)
                {
                    SendClientMessage(playerid, COLOR_WHITE, "[{58732E}PC{FFFFFF}]: Ban da nhap day du mat khau, hay bam 'Hoan thanh' de dang nhap!");
                    str[0] = 0;
                    for(i = 0 ; i < sizeof(pc_PassKey) ; i++)
                    {
                        format(str, sizeof(str), "%s\n%s", str, pc_PassKey[i]);
                    }
                    return Dialog_Show(playerid, DIALOG_INPUT_FINPASS, DIALOG_STYLE_LIST, "Mat khau 4 so", str, "Chon","");
                }
            }
        }
        if(strcmp(inputtext, "Reset", true) == 0)
        {
            ClearChatbox(playerid);
            SendClientMessage(playerid, COLOR_WHITE, "[{58732E}PC{FFFFFF}]: Ban da reset lai lua chon cua minh (4 so ve lai thanh 0)");
            for(i = 0 ; i < 4 ; i++)
            {
                temppc_Pass[playerid][i] = 0;
            }

            for(i = 0 ; i < sizeof(pc_PassKey) ; i++)
            {
                format(str, sizeof(str), "%s\n%s", str, pc_PassKey[i]);
            }
            return Dialog_Show(playerid, DIALOG_INPUT_FINPASS, DIALOG_STYLE_LIST, "Mat khau 4 so", str, "Chon","");
        }
        if(strcmp(inputtext, "Hoan thanh", true) == 0)
        {
            for(i = 0 ; i < 4 ; i++)
            {
                if(temppc_Pass[playerid][i] == 0)
                {
                    ClearChatbox(playerid);
                    SendClientMessage(playerid, COLOR_WHITE, "[{58732E}PC{FFFFFF}]: Ban chua hoan thanh tat ca cac lua chon, mat khau da bi reset ve so 0.");
                    for(z = 0 ; z < 4 ; z++)
                    {
                        temppc_Pass[playerid][z] = 0;
                    }

                    for(z = 0 ; z < sizeof(pc_PassKey) ; z++)
                    {
                        format(str, sizeof(str), "%s\n%s", str, pc_PassKey[z]);
                    }
                    return Dialog_Show(playerid, DIALOG_INPUT_FINPASS, DIALOG_STYLE_LIST, "Mat khau 4 so", str, "Chon","");
                }
            }
            if(gPlayerLogged{playerid})
            {
                ClearChatbox(playerid);
                SendClientMessageEx(playerid, COLOR_WHITE, "[{58732E}PC{FFFFFF}]: Ban da thiet lap mat khau 4 so, tu phien dang nhap tiep theo no se co hieu luc.");
                for(i = 0 ; i < 4 ; i++)
                {
                    PlayerData[playerid][pc_Pass][i] = temppc_Pass[playerid][i];
                    format(str, sizeof(str), "pc_Pass%d", i);
                    mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `account2` SET `%s` = %d WHERE `UID` = %d", str, temppc_Pass[playerid][i], PlayerInfo[playerid][pId]);
                    mysql_tquery(MainPipeline, szQuery);
                }
            }
            else
            {
                ClearChatbox(playerid);
                for(i = 0 ; i < 4 ; i++)
                {
                    if(temppc_Pass[playerid][i] != PlayerData[playerid][pc_Pass][i])
                    {
                        if(temppc_Login[playerid] == 3)
                        {
                            SendClientMessage(playerid, COLOR_LIGHTRED, "Ban da bi moi ra khoi may chu vi khong hoan thanh thao tac bao mat.");
                            SetTimerEx("KickEx", 1000, false, "i", playerid);
                            return 1;
                        }
                        SendClientMessage(playerid, COLOR_WHITE, "[{58732E}PC{FFFFFF}]: Ban da nhap sai mat khau, vui long nhap lai.");
                        temppc_Login[playerid]++;
                        for(z = 0 ; z < 4 ; z++)
                        {
                            temppc_Pass[playerid][z] = 0;
                        }

                        for(z = 0 ; z < sizeof(pc_PassKey) ; z++)
                        {
                            format(str, sizeof(str), "%s\n%s", str, pc_PassKey[z]);
                        }
                        return Dialog_Show(playerid, DIALOG_INPUT_FINPASS, DIALOG_STYLE_LIST, "Mat khau 4 so", str, "Chon","");
                    }
                }
                SendClientMessage(playerid, COLOR_WHITE, "[{58732E}PC{FFFFFF}]: Cam on ban vi da hoan thanh buoc kiem tra, congratulations!");
                OnPlayerLoad(playerid);
                return 1;
            }
        }
    }
    else
    {
        if(!gPlayerLogged{playerid})
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "Ban da bi moi ra khoi may chu vi khong hoan thanh thao tac bao mat.");
            SetTimerEx("KickEx", 1000, false, "i", playerid);
            return 1;
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    PlayerData[playerid][pc_EA] = 0;
    PlayerData[playerid][pc_FoodBar] = 0;
    PlayerData[playerid][pc_WaterBar] = 0;
    PlayerData[playerid][pc_Job] = 0;
    PlayerData[playerid][pc_Job2] = 0;
    PlayerData[playerid][pc_Job3] = 0;
    PlayerData[playerid][pc_FishmanSkill] = 0;
    PlayerData[playerid][pc_AlcoholSkill] = 0;
    PlayerData[playerid][pc_PizzaBoySkill] = 0;
    PlayerData[playerid][pc_SweeperSkill] = 0;
    PlayerData[playerid][pc_TruckerSkill] = 0;
    PlayerData[playerid][pc_AlcoholLimit] = 0;
    PlayerData[playerid][pc_SweeperLimit] = 0;
    PlayerData[playerid][pc_AlcoholTimer] = 0;
    PlayerData[playerid][pc_SweeperTimer] = 0;
    PlayerData[playerid][pc_CaribbeanTeam] = 0;
    PlayerData[playerid][pc_CaribbeanEvent] = 0;
    PlayerData[playerid][pc_FamedPoint] = 0;
    PlayerData[playerid][pc_LimitEventReward] = 0;
    PlayerData[playerid][pc_ClaimRoseWinter] = 0;
    PlayerData[playerid][pc_CargoTimeOnline] = 0;
    PlayerData[playerid][pc_CargoTimeSeconds] = 0;

    new i;
    for (i = 0; i < 4; i++)
    {
        PlayerData[playerid][pc_Pass][i] = 0;
    }

    PlayerData[playerid][pc_ItemTradeNeft_Miner] = 0;
    PlayerData[playerid][pc_ItemTradeNeftExpire_Miner] = 0;
    
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(gPlayerLogged{playerid})
    {
        SavePlayerAccountic(playerid);
    }
    return 1;
}