#include <YSI\y_hooks>


hook OnPlayerDisconnect(playerid, reason)
{
    if(GetPVarInt(playerid,"TruyDuoi") == 1 ) // b
    {
            new strings[128];
            SetPVarInt(playerid, "TruyDuoi", 0);
            ResetPlayerWeaponsEx(playerid);
            StaffAccountCheck(playerid, GetPlayerIpEx(playerid));
            PhoneOnline[playerid] = 1;
            PlayerInfo[playerid][pJailTime] = 120*60;
            SetPlayerInterior(playerid, 1);
            SetPlayerHealth(playerid, 0x7FB00000);
            SetPlayerFacingAngle(playerid, 0);
            new rand = random(sizeof(OOCPrisonSpawns));
            SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
            PlayerInfo[playerid][pVW] = 0;
            SetPlayerVirtualWorld(playerid, 0);
            format(strings, sizeof(strings), "[OOC]Ban da bi giam vi /q khi canh sat truy duoi.");
            SendClientMessageEx(playerid, COLOR_LIGHTRED, strings);
            format(PlayerInfo[playerid][pPrisonReason], 128, "[OOC][JAIL] AR /q ((/truyduoi))");
            SetPlayerColor(playerid, TEAM_APRISON_COLOR);
    }
	return 1;
}
CMD:truyduoi(playerid,params[])
{
    if(IsACop(playerid)  || (arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess] != 1) && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess])
    {
            new    iTargetID,strc[128];
            if(sscanf(params, "u", iTargetID)) {
                return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /truyduoi [player]");
            }
            else if(iTargetID == playerid) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay cho ban.");
            }
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "Ban phai ngoi tren xe moi co the truy duoi mot ai do.");
            else if(IsACop(iTargetID))
            {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the truy duoi nhan vien thi hanh phap luat.");
            }
            else if(!IsPlayerConnected(iTargetID)) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
            }
            else if(GetPlayerInterior(iTargetID) != 0) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay trong khi dang o trong mot noi that.");
            }
            else if(PlayerInfo[iTargetID][pAdmin] >= 2 && PlayerInfo[iTargetID][pTogReports] != 1) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the truy duoi nguoi nay.");
            }
            else if (GetPVarInt(playerid, "_SwimmingActivity") >= 1) {
                return SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong the tim thay nguoi nay trong khi dang boi loi.");
            }
            if(GetPVarInt(playerid,"TruyDuoi") == 1 )
            {
                SendClientMessageEx(playerid, COLOR_GRAD2, " Nguoi nay dang bi ai do truy duoi");
                return 1;
            }
            if(!ProxDetectorS(200,playerid,iTargetID))
            {
                SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai gan nguoi nay trong pham vi 200 met.");
                return 1;
            }
            if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
            {
                SendClientMessageEx(playerid, COLOR_GRAD2, "Ban phai dung boi! (/stopswimming)");
                return 1;
            }
            if(gettime() < TimeTruyDuoi[playerid])
            {
                format(strc,sizeof(strc),"Ban phai doi %d giay nua moi co the tiep tuc truy duoi.",TimeTruyDuoi[playerid]-gettime());
                SendClientMessageEx(playerid, COLOR_GRAD2,strc);
                return 1;
            }
            else
            {
                new str[128],str2[128];
                TimeTruyDuoi[playerid]=gettime()+300;
                format(str,128,"Ban dang truy duoi doi tuong %s (( Truy duoi co hieu luc trong 10 phut ))",GetPlayerNameExt(iTargetID));
                SendClientMessageEx(playerid, COLOR_LIGHTRED,str);
                SendClientMessageEx(iTargetID, COLOR_LIGHTRED, "Ban dang bi truy duoi boi Canh Sat neu ban thoat game se bi o tu 120 phut (( Truy duoi co hieu luc trong 10 phut ))");
                SetPVarInt(iTargetID, "TruyDuoi", 1);
                timetrd[iTargetID] = SetTimerEx("TruyDuoiC",600000,false,"ii",iTargetID,playerid);
                format(str2,128,"HQ: Officer %s dang truy duoi doi tuong %s",GetPlayerNameExt(playerid),GetPlayerNameExt(iTargetID));
                SendGroupMessage(1,COLOR_LIGHTBLUE,str2);
            }
    }
    else  SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh nay.");
    return 1;
}
forward TruyDuoiC(playerid,pid);
public TruyDuoiC(playerid,pid)
{
    new ss[128];
    format(ss,128,"Hieu luc truy duoi doi tuong %s da het.",GetPlayerNameExt(playerid));
    SendClientMessageEx(pid, COLOR_LIGHTRED,ss);
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "Ban da het thoi gian truy duoi.");
    SetPVarInt(playerid, "TruyDuoi", 0);
    KillTimer(timetrd[playerid]);
    return 1;
}
CMD:xemtruyduoi(playerid,params[])
{
    if(GetPVarInt(playerid,"TruyDuoi") == 1 )
    {
        SendClientMessageEx(playerid,COLOR_GREY,"Ban dang bi truy duoi boi canh sat. Hay chay tron!");
    }
    else if(GetPVarInt(playerid,"TruyDuoi") == 0)
    {
        SendClientMessageEx(playerid,COLOR_GREY,"Ban khong bi canh sat truy duoi.");
    }
    return 1;
}

CMD:xoatruyduoi(playerid,params[])
{
    if(IsACop(playerid)  || (arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess] != 1) && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iBugAccess])
    {
            new    iTargetID,str[128];
            if(sscanf(params, "u", iTargetID)) {
                return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /xoatruyduoi [player]");
            }
            else if(iTargetID == playerid) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay cho ban.");
            }
            else if(!IsPlayerConnected(iTargetID)) {
                return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi khong hop le.");
            }
            if(GetPVarInt(iTargetID,"TruyDuoi") == 0 )
            {
                SendClientMessageEx(playerid, COLOR_GRAD2, "Nguoi nay khong bi truy duoi");
                return 1;
            }
            else
            {
                SetPVarInt(iTargetID, "TruyDuoi", 0);
                format(str,128,"Ban da ngung truy duoi doi tuong %s.",GetPlayerNameExt(iTargetID));
                SendClientMessageEx(playerid, COLOR_LIGHTRED,str);
                SendClientMessageEx(iTargetID, COLOR_LIGHTRED, "[AN TOAN] Hien tai khong co ai truy duoi ban nua.");
            }
    }
    else  SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh nay.");
    return 1;
}