#if defined _modules_new_stats_included
    #endinput
#endif

#define _modules_new_stats_included

stock GetJobNameEx(jobid) {
    new string[84];
    switch(jobid) {
        case 1: string = "Ngu dan";
        case 2: string = "Nguoi giao ruou";
        case 3: string = "Pizza Boy";
        case 4: string = "Nhan vien moi truong";
        case 5: string = "Van chuyen hang hoa";
        case 6: string = "Cong ty Van chuyen";
        default: string = "Khong co";
    }
    return string;
}

stock GetJobLevelEx(playerid, jobid) {
    #pragma unused playerid, jobid
    return 1;
}

Function: ShowStatsEx(playerid, targetid)
{
    ShowStatsNew(playerid, targetid);
    return 1;
}

stock ShowStatsNew(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1132], header[65], org[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
		new sext[16], std[20], nation[24], biz[128];
		if(PlayerInfo[targetid][pSex] == 1) { sext = "Nam"; } else { sext = "Nu"; }
		switch(GetPVarInt(targetid, "STD"))
		{
		    case 1: std = "Chlamydia";
		    case 2: std = "Gonorrhea";
		    case 3: std = "Syphilis";
		    default: std = "None";
		}
		if(PlayerInfo[targetid][pMember] != INVALID_GROUP_ID)
		{
			GetPlayerGroupInfo(targetid, rank, division, employer);
			format(org, sizeof(org), "Group: %s (%d)\nRank: %s (%d)\nDivision: %s (%d)\n", employer, PlayerInfo[targetid][pMember], rank, PlayerInfo[targetid][pRank], division, PlayerInfo[targetid][pDivision]);
			if(arrGroupData[PlayerInfo[targetid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) format(org, sizeof(org), "%sSo huy hieu: %s\n", org, PlayerInfo[targetid][pBadge]);
		}
		else format(org, sizeof(org), "");
		if(PlayerInfo[targetid][pBusiness] != INVALID_BUSINESS_ID) format(biz, sizeof(biz), "Cua hang: %s (%d)\nCap bac: %s (%d)\n", Businesses[PlayerInfo[targetid][pBusiness]][bName], PlayerInfo[targetid][pBusiness], GetBusinessRankName(PlayerInfo[targetid][pBusinessRank]), PlayerInfo[targetid][pBusinessRank]);
		else format(biz, sizeof(biz), "");
		switch(PlayerInfo[targetid][pNation])
		{
			case 0: nation = "San Andreas";
			case 1: nation = "New Robada";
			case 2: nation = "Khong ro";
		}
		new insur[32];
		insur = GetHospitalName(PlayerInfo[targetid][pInsurance]);

		new staffrank[64];
		if(PlayerInfo[targetid][pHelper] > 0 || PlayerInfo[targetid][pWatchdog] > 0 || PlayerInfo[targetid][pSEC] > 0 || PlayerInfo[targetid][pAdmin] == 1 || (PlayerInfo[targetid][pAdmin] > 1 && PlayerInfo[playerid][pAdmin] <= PlayerInfo[targetid][pAdmin])) format(staffrank, sizeof(staffrank), "%s", GetStaffRank(targetid));
		else staffrank = "";
		new drank[64];
		if(PlayerInfo[targetid][pDonateRank] > 0)
		{
			switch(PlayerInfo[targetid][pDonateRank])
			{
				case 1: drank = "{800080}Bronze VIP{FFFFFF}\n";
				case 2: drank = "{800080}Silver VIP{FFFFFF}\n";
				case 3: drank = "{FFD700}Gold VIP{FFFFFF}\n";
				case 4: drank = "{E5E4E2}Platinum VIP{FFFFFF}\n";
			}
		}
		new svipmod[40];
		if(PlayerInfo[targetid][pVIPMod])
		{
			switch(PlayerInfo[targetid][pVIPMod])
			{
				case 1: svipmod = "{800080}VIP Moderator{FFFFFF}\n";
				case 2: svipmod = "{800080}Senior VIP Moderator{FFFFFF}\n";
			}
		}
		new famedrank[64];
		if(PlayerInfo[targetid][pFamed] > 0)
		{
			switch(PlayerInfo[targetid][pFamed])
			{
				case 1: famedrank = "{228B22}Old-School{FFFFFF}\n";
				case 2: famedrank = "{FF7F00}Chartered Old-School{FFFFFF}\n";
				case 3: famedrank = "{ADFF2F}Famed{FFFFFF}\n";
				case 4: famedrank = "{8F00FF}Famed Commissioner{FFFFFF}\n";
				case 5: famedrank = "{8F00FF}Famed Moderator{FFFFFF}\n";
				case 6: famedrank = "{8F00FF}Famed Vice-Chairman{FFFFFF}\n";
				case 7: famedrank = "{8F00FF}Famed Chairman{FFFFFF}\n";
			}
		}
		new dprank[64];
		if(PlayerInfo[targetid][pDedicatedPlayer] > 0)
		{
			switch(PlayerInfo[targetid][pDedicatedPlayer])
			{
				case 1: dprank = "{336600}Tier 1 Dedicated Player{FFFFFF}\n";
				case 2: dprank = "{336600}Tier 2 Dedicated Player{FFFFFF}\n";
				case 3: dprank = "{336600}Tier 3 Dedicated Player{FFFFFF}\n";
				case 4: dprank = "{336600}Dedicated Moderator{FFFFFF}\n";
			}
		}
		new famerank[64];
		switch(PlayerData[playerid][pc_FamedPoint])
		{
			case 0 .. 100: famerank = "{C0D62F}Doanh nhan moi{FFFFFF}"; // Mức 1: Người mới
			case 101 .. 300: famerank = "{DBFF3D}Hao Phu{FFFFFF}"; // Mức 2: Có chút tiếng tăm
			case 301 .. 500: famerank = "{FF9B3D}Nguoi noi tieng{FFFFFF}"; // Mức 3: Đã được nhiều người biết đến
			case 501 .. 700: famerank = "{FF8A1C}Ngoi sao{FFFFFF}"; // Mức 4: Gây ảnh hưởng lớn
			case 701 .. 900: famerank = "{7E1CFF}Huyen thoai{FFFFFF}"; // Mức 5: Đỉnh cao danh vọng
			case 901 .. 1000: famerank = "{915EAB}Dich ton{FFFFFF}"; // Mức 6: Vô song, tuyệt đỉnh
		}
		if(PlayerInfo[targetid][pMarriedID] == -1) format(PlayerInfo[targetid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*4;
		new Float:health, Float:armor;
		GetHealth(targetid, health);
		GetArmour(targetid, armor);
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new zone[MAX_ZONE_NAME];
		GetPlayer3DZone(targetid, zone, sizeof(zone));
		new fifstr[128];
		if(FIFEnabled)
		{
			format(fifstr, sizeof(fifstr), "{FF8000}FIF Hours:{FFFFFF} %d\n{FF8000}FIF Chances:{FFFFFF} %d\n", FIFInfo[targetid][FIFHours], FIFInfo[targetid][FIFChances]);
		}
		SetPVarInt(playerid, "ShowStats", targetid);
		format(header, sizeof(header), "Thong tin cua %s", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"%s\n\
			%s\
			%s\
			%s\
			%s\
			%s\
			{FFFFFF}Cap do: %d\n\
			EXP Farm: %d\n\
			GP: %d\n\
			Coin: %d\n\
			Danh vong: %s\n\
			Gioi tinh: %s\n\
			Sinh nhat: %s\n\
			Vi tri hien tai: %s (%0.2f, %0.2f, %0.2f)\n\
			Da ket hon voi: %s\n\
			Mau (HP): %.1f\n\
			Giap (Armour): %.1f\n\
			Gio da choi: %s\n\
			Dedicated Hours: %s\n\
			The luc: %d\n\
			Diem can thiet de nang cap: %s\n\
			Cap do tiep theo: %s{303030}/{FFFFFF}%s hours\n\
			Quoc tich: %s\n\
			%s\
			%s\
            Cong viec 1: %s (Cap bac lanh nghe: %d)\n\
            Cong viec 2: %s (Cap bac lanh nghe: %d)\n\
            Cong viec 3 (VIP): %s (Cap bac lanh nghe: %d)\n\
			Insurance: %s",
			staffrank,
			famedrank,
			dprank,
			drank,
			svipmod,
			fifstr,
			PlayerInfo[targetid][pLevel],
			PlayerData[targetid][pc_EA],
			PlayerData[targetid][pc_GP],
			PlayerData[targetid][pc_Coin],
			famerank,
			sext,
			PlayerInfo[targetid][pBirthDate],
			zone, px, py, pz,
			PlayerInfo[targetid][pMarriedName],
			health,
			armor,
			number_format(PlayerInfo[targetid][pConnectHours]),
			number_format(PlayerInfo[targetid][pDedicatedHours]),			
			PlayerInfo[targetid][pFitness],
			number_format(PlayerInfo[targetid][gPupgrade]),
			number_format(PlayerInfo[targetid][pExp]),
			number_format(expamount),
			nation,
			org,
			biz,
            GetJobNameEx(PlayerData[playerid][pc_Job]),
            GetJobLevelEx(playerid, PlayerData[playerid][pc_Job]),
            GetJobNameEx(PlayerData[playerid][pc_Job2]),
            GetJobLevelEx(playerid, PlayerData[playerid][pc_Job2]),
            GetJobNameEx(PlayerData[playerid][pc_Job3]),
            GetJobLevelEx(playerid, PlayerData[playerid][pc_Job3]),
			insur);
		ShowPlayerDialogEx(playerid, DISPLAY_STATS, DIALOG_STYLE_MSGBOX, header, resultline, "Next Page", "Close");
	}
	return 1;
}

CMD:thongtin(playerid, params[])
{
    return callcmd::stats(playerid, params);
}