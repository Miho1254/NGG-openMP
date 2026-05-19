stock ShowStats(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[65], org[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
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
			format(org, sizeof(org), "To chuc: %s (%d)\nCap bac: %s (%d)\nDon vi: %s (%d)\n", employer, PlayerInfo[targetid][pMember], rank, PlayerInfo[targetid][pRank], division, PlayerInfo[targetid][pDivision]);
			if(arrGroupData[PlayerInfo[targetid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) format(org, sizeof(org), "%sMa phu hieu: %s\n", org, PlayerInfo[targetid][pBadge]);
		}
		else format(org, sizeof(org), "");
		if(PlayerInfo[targetid][pBusiness] != INVALID_BUSINESS_ID) format(biz, sizeof(biz), "Cua hang: %s (%d)\nCap bac: %s (%d)\n", Businesses[PlayerInfo[targetid][pBusiness]][bName], PlayerInfo[targetid][pBusiness], GetBusinessRankName(PlayerInfo[targetid][pBusinessRank]), PlayerInfo[targetid][pBusinessRank]);
		else format(biz, sizeof(biz), "");
		switch(PlayerInfo[targetid][pNation])
		{
			case 0: nation = "San Andreas";
			case 1: nation = "New Robada";
			case 2: nation = "Trong";
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
				case 1: famedrank = "{228B22}Old-School (1){FFFFFF}\n";
				case 2: famedrank = "{FF7F00}Old-School (2){FFFFFF}\n";
				case 3: famedrank = "{ADFF2F}Chartered Old-School{FFFFFF}\n";
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
				case 4: dprank = "{336600}Thanh vien Uu Tu{FFFFFF}\n";
			}
		}
		if(PlayerInfo[targetid][pMarriedID] == -1) format(PlayerInfo[targetid][pMarriedName], MAX_PLAYER_NAME, "Khong co");
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
		format(header, sizeof(header), "{F5CB42}PLAYER STATS");
		format(resultline, sizeof(resultline),"%s\n\
			%s\
			%s\
			%s\
			%s\
			%s\
			\n\
			{FFFFFF}------ {F5CB42}THONG TIN CA NHAN {FFFFFF}------\n\
			\n\
			{FFFFFF}Ten nhan vat: {F5CB42}%s{FFFFFF} (%d)\n\
			Gioi tinh: %s\n\
			Ngay sinh: %s\n\
			Nguoi yeu: {F5CB42}%s{FFFFFF}\n\
			\n\
			{FFFFFF}------ {F5CB42}THONG KE CA NHAN {FFFFFF}------\n\
			\n\
			Mau: %.1f\n\
			Giap: %.1f\n\
			Diem nang cap: %s\n\
			The luc: %d\n\
			\n\
			{FFFFFF}------ {F5CB42}THONG TIN CAP DO {FFFFFF}------\n\
			\n\
			Cap do: {F5CB42}%d{FFFFFF}\n\
			Gio choi: %s\n\
			Cap do ke tiep: %s/%s gio\n\
			Dedicated Hours: %s\n\
			\n\
			{FFFFFF}------ {F5CB42}THONG TIN KHAC {FFFFFF}------\n\
			\n\
			Quoc tich: {F5CB42}%s{FFFFFF}\n\
			%s\
			%s\
			\n\
			{FFFFFF}------ {F5CB42}THONG TIN JOB {FFFFFF}------\n\
			\n\
			Cong viec: %s (Cap do: %d)\n\
			Cong viec 2: %s (Cap do: %d)\n\
			Cong viec 3: %s (Cap do: %d)\n\
			Bao hiem tai: %s",
			staffrank,
			famedrank,
			dprank,
			drank,
			svipmod,
			fifstr,
			GetPlayerNameEx(targetid),
			targetid,
			sext,
			PlayerInfo[targetid][pBirthDate],
			PlayerInfo[targetid][pMarriedName],
			health,
			armor,
			number_format(PlayerInfo[targetid][gPupgrade]),
			PlayerInfo[targetid][pFitness],
			PlayerInfo[targetid][pLevel],
			number_format(PlayerInfo[targetid][pConnectHours]),
			number_format(PlayerInfo[targetid][pExp]),
			number_format(expamount),
			number_format(PlayerInfo[targetid][pDedicatedHours]),
			nation,
			org,
			biz,
			GetJobName(PlayerInfo[targetid][pJob]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob]),
			GetJobName(PlayerInfo[targetid][pJob2]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob2]),
			GetJobName(PlayerInfo[targetid][pJob3]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob3]),
			insur);
		ShowPlayerDialogEx(playerid, DISPLAY_STATS, DIALOG_STYLE_MSGBOX, header, resultline, "Trang ke", "Dong");
	}
	return 1;
}
