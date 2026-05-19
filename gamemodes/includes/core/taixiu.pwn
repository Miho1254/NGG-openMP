#include <YSI\y_hooks>

new BatTatTaiXiu[MAX_PLAYERS];
new TXStats = 0;
new HeThongTaiXiu = 0;
new Phientaixiu = 1;
new KetQuaTaiXiu = 0;
new TimeTaiXiu = 170;
new ChonTaiAll = 0;
new ChonXiuAll = 0;
new TienCuocTaiAll = 0;
new TienCuocTraAll = 0;
new TienCuocXiuAll = 0;
new IdTaiWin = -1;
new IdXiuWin = -1;
new TienIdTaiWin = -1;
new TienIdXiuWin = -1;
new TTPhienTaiXiu[10000][500];
new TTWinTaiXiu[10000][500];
new ChonTaiXiu[MAX_PLAYERS];
new TimeChonTaiXiu[MAX_PLAYERS];
new TienCuocTaiXiu[MAX_PLAYERS];
new TraTienTaiXiu[MAX_PLAYERS];
hook OnPlayerConnect(playerid, reason) 
{
	BatTatTaiXiu[playerid] = 0;
	return 1;
}	
hook OnPlayerDisconnect(playerid, reason) 
{
    if(TraTienTaiXiu[playerid] == 1)
    {
       GivePlayerCash(playerid,TienCuocTaiXiu[playerid]);
       TraTienTaiXiu[playerid] = 0;
    }
    if(ChonTaiXiu[playerid] == 1)
    {
        ChonTaiAll--;
        TienCuocTaiAll -= TienCuocTaiXiu[playerid];
        TienCuocTaiXiu[playerid] = 0;
        ChonTaiXiu[playerid	] = 0;
    }
    if(ChonTaiXiu[playerid] == 2)
    {
        ChonXiuAll--;
        TienCuocXiuAll -= TienCuocTaiXiu[playerid];
        TienCuocTaiXiu[playerid] = 0;
        ChonTaiXiu[playerid] = 0;
    }
	return 1;
}

CMD:edittx(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 5)
 	{
		new chon[32];
	    if(sscanf(params, "s[32]", chon))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /eddittx [Lua chon] ");
			SendClientMessageEx(playerid, COLOR_GREY, "Lua chon: tai - xiu - ngaunhien - thang - thua");
			return 1;
		}
		else if(strcmp(chon,"tai",true) == 0)
		{
	        HeThongTaiXiu = 1;
	        SendClientMessageEx(playerid, -1,"Ban da thay doi he thong Tai Xiu [TAI - Thang]");
		}
		else if(strcmp(chon,"xiu",true) == 0)
		{
	        HeThongTaiXiu = 2;
	        SendClientMessageEx(playerid, -1,"Ban da thay doi he thong Tai Xiu [XIU - Thang]");
		}
		else if(strcmp(chon,"ngaunhien",true) == 0)
		{
	        HeThongTaiXiu = 0;
	        SendClientMessageEx(playerid, -1,"Ban da thay doi he thong Tai Xiu [Ngau Nhien]");
		}
		else if(strcmp(chon,"thang",true) == 0)
		{
	        HeThongTaiXiu = 3;
	        SendClientMessageEx(playerid, -1,"Ban da thay doi he thong Tai Xiu [Ben nao nhieu tien ben do thang]");
		}
		else if(strcmp(chon,"thua",true) == 0)
		{
	        HeThongTaiXiu = 4;
	        SendClientMessageEx(playerid, -1,"Ban da thay doi he thong Tai Xiu [Ben nao it tien ben do thang]");
		}
	}
	return 1;
}
CMD:taixiuinfo(playerid, params[])
{
	if(BatTatTaiXiu[playerid] == 0)
    {
    	return SendClientMessage(playerid, COLOR_WHITE, "Ban chua bat tai xiu [/togtaixiu]");
    }	
    if(TXStats == 0) return SendClientMessageEx(playerid, -1, "{ffff00}[!] {ffffff}Tai xiu hien dang dong! Vui long quay lai sau.");
	new string[128],taixiu[32],taixiuid[32],string2[1024];
	switch(ChonTaiXiu[playerid])
	{
		case 1: taixiu = "{ff0000}Tai{ffffff}";
		case 2: taixiu = "{ffec8b}Xiu{ffffff}";
    }
	format(string,sizeof(string),"[TAI XIU] Phien [#%d] khui trong [%d giay].",Phientaixiu,TimeTaiXiu);
	SendClientMessageEx(playerid, -1, string);
	format(string,sizeof(string),"{ff0000}TAI {ffffff}(%d nguoi choi)  |  {3aea46}XIU {ffffff}(%d nguoi choi)",ChonTaiAll,ChonXiuAll);
	SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][pAdmin] >= 5)
	{
		format(string,sizeof(string),"[Admin Check] {ff0000}TAI {ffffff}($%s)   VS   {3aea46}XIU {FFFFFF}($%s)",number_format(TienCuocTaiAll),number_format(TienCuocXiuAll));
		SendClientMessageEx(playerid, -1, string);
	}
	if(ChonTaiXiu[playerid] > 0)
	{
		format(string,sizeof(string),"Ban da dat cuoc vao %s voi so tien la $%s.",taixiu,number_format(TienCuocTaiXiu[playerid]));
 		SendClientMessageEx(playerid, -1, string);
	}
	new szDialog[1024];
	foreach(new i: Player)
	{
	    switch(ChonTaiXiu[i])
		{
			case 1: taixiuid = "{ff0000}Tai{ffffff}";
			case 2: taixiuid = "{3aea46}Xiu{ffffff}";
    	}
		if(ChonTaiXiu[i] > 0)
		{
			format(szDialog, sizeof(szDialog), "%s\n%s\t%s\t%s", szDialog, GetPlayerNameEx(i),taixiuid,number_format(TienCuocTaiXiu[i]));
		}
	}
	format(string2,sizeof(string2),"Ten\tDat cuoc vao\tSo tien\n%s",szDialog);
	if(!isnull(szDialog) && PlayerInfo[playerid][pAdmin] >= 5)
	{
 		strdel(szDialog, 0, 1);
	  	ShowPlayerDialog(playerid, 123,DIALOG_STYLE_TABLIST_HEADERS, "Thong tin Tai Xiu",string2,"Ok", "Thoat");
 	}
	return 1;
}
CMD:taixiu(playerid, params[])
{
	if(PlayerInfo[playerid][pLevel] < 2) 
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "[TAI XIU] Ban can dat cap do 2 de choi tai xiu");
	} 
	if(BatTatTaiXiu[playerid] == 0)
    {
    	return SendClientMessage(playerid, COLOR_WHITE, "Ban chua bat tai xiu [/togtaixiu]");
    }
    new string[128], chon[32],tiencuoc;
    if(TXStats == 0) return SendClientMessageEx(playerid, -1, "{ffff00}[!] {ffffff}Tai xiu hien dang dong! Vui long quay lai sau.");
	if(sscanf(params, "s[32]d", chon, tiencuoc))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /taixiu [Lua chon] [So tien dat cuoc]");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Lua chon: 1: TAI - 2: XIU");
		SendClientMessageEx(playerid, COLOR_GRAD2, "SU DUNG: /taixiuinfo de xem danh sach cuoc");
		SendClientMessageEx(playerid, COLOR_GRAD3, "SU DUNG: /thongtinphien de xem chi tiet cua Phien");
		SendClientMessageEx(playerid, COLOR_GRAD4, "Vui long dat tai xiu truoc 40 giay truoc khi phien tai xiu ket thuc, neu khong se hoan tien.");
		return 1;
	}
	if(!IsPlayerInRangeOfPoint(playerid, 50.0, 1122.9740, -1388.2837, 13.6895) && !IsPlayerInRangeOfPoint(playerid, 50.0, -2581.8645, 580.2866, 15.6267) && !IsPlayerInRangeOfPoint(playerid, 40.0, 4111.784179, -152.760116, 23.389602) && !IsPlayerInRangeOfPoint(playerid, 50.0, 2324.4272, -1141.8785, 1050.9835) && !IsPlayerInRangeOfPoint(playerid, 50.0, -1657.1882, 1320.0900, 7.1875))
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "[TAI XIU] Ban khong o khu vuc choi Tai Xiu (Khu vuc choi Tai xiu: Market, Pizza SF, Benh vien SF).");
	}	
	else if(tiencuoc < 10000 || tiencuoc > 3000000) return SendClientMessageEx(playerid, COLOR_WHITE, "[TAI XIU] Ban khong de dat duoi 10,000$ va tren 3,000,000$");
	else if(ChonTaiXiu[playerid] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "[TAI XIU] Ban da dat cuoc roi.");
	else if(PlayerInfo[playerid][pCash] < tiencuoc) return SendClientMessageEx(playerid, COLOR_WHITE, "[TAI XIU] Ban khong co nhieu tien de dat cuoc.");
    else if(strcmp(chon,"1",true) == 0)
	{
		new szMessage[128];
        ChonTaiXiu[playerid] = 1;
        TraTienTaiXiu[playerid] = 1;
        TienCuocTaiXiu[playerid] = tiencuoc;
        GivePlayerCash(playerid,-tiencuoc);
        ChonTaiAll++;
        TienCuocTaiAll += tiencuoc;
        TimeChonTaiXiu[playerid] = TimeTaiXiu;
        format(string,sizeof(string),"[TAI XIU] Ban da dat cuoc $%d vao{ff0000} Tai{FFFFFF} o phien so #%d.",tiencuoc,Phientaixiu);
        SendClientMessageEx(playerid, -1, string);
		format(szMessage, sizeof(szMessage), "[TAI XIU] [Ten IC: %s] [Chon: TAI] [Phien: #%d] [So Tien: %d]",GetPlayerNameEx(playerid), Phientaixiu, tiencuoc);
		Log("logs/taixiu.log", szMessage), print(szMessage);
        if(tiencuoc > TienIdTaiWin)
        {
            IdTaiWin = playerid;
            TienIdTaiWin = tiencuoc;
        }
	}
	else if(strcmp(chon,"2",true) == 0)
	{
		new szMessage[128];
        ChonTaiXiu[playerid] = 2;
        TraTienTaiXiu[playerid] = 1;
        TienCuocTaiXiu[playerid] = tiencuoc;
        GivePlayerCash(playerid,-tiencuoc);
        ChonXiuAll++;
        TienCuocXiuAll += tiencuoc;
        TimeChonTaiXiu[playerid] = TimeTaiXiu;
        format(string,sizeof(string),"[TAI XIU] Ban da dat cuoc $%d vao{3aea46} Xiu{FFFFFF} o phien so #%d.",tiencuoc,Phientaixiu);
        SendClientMessageEx(playerid, -1, string);
		format(szMessage, sizeof(szMessage), "[TAI XIU] [Ten IC: %s] [Chon: Xiu] [Phien: #%d] [So Tien: %d]",GetPlayerNameEx(playerid), Phientaixiu, tiencuoc);
		Log("logs/taixiu.log", szMessage), print(szMessage);
        if(tiencuoc > TienIdXiuWin)
        {
            IdXiuWin = playerid;
            TienIdXiuWin = tiencuoc;
        }
	}
	return 1;
}
CMD:thongtinphien(playerid, params[])
{
	if(BatTatTaiXiu[playerid] == 0)
    {
    	return SendClientMessage(playerid, COLOR_WHITE, "Ban chua bat tai xiu [/togtaixiu]");
    }	
	new number;
 //   if(TXStats == 0) return SendClientMessageEx(playerid, -1, "{ffff00}[!] {ffffff}Tai xiu hien dang dong! Vui long quay lai sau.");
    if(sscanf(params, "d", number))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /thongtinphien [phien]");
	}
	new string1[128];
	format(string1,sizeof(string1),"Phien Tai Xiu %d",number);
    SetPVarInt(playerid,"phien",number);
  	ShowPlayerDialog(playerid, 123,DIALOG_STYLE_LIST,string1,TTPhienTaiXiu[number],"Chon", "Thoat");

	return 1;
}
///
task eventtaixiu[1000]()
{
    new xucxac1 = random(7);
	new xucxac2 = random(7);
	new xucxac3 = random(7);
	if(xucxac1 == 0)
	{
	xucxac1 = random(6);
	}
	else if(xucxac2 == 0)
	{
	xucxac2 = 1 + random(6);
	}
	else if(xucxac3 == 0)
	{
	xucxac3 = 1 + random(6);
	}
	new ketquaxucxac = xucxac1 + xucxac2 + xucxac3;
    if(TimeTaiXiu > 0)
	{
	    TimeTaiXiu--;
	}
	if(TimeTaiXiu == 0 && TXStats == 1)
	{
	    new string[1024],string2[1024],ketqua[32];
	    if(HeThongTaiXiu == 0)
	    {
			switch(ketquaxucxac)
			{
	        	case 2,4,6,8,10,12,14,16,18: KetQuaTaiXiu = 1;
				case 1,3,5,7,9,11,13,15,17: KetQuaTaiXiu = 2;
			}
		}
		if(HeThongTaiXiu == 1)
	    {
			KetQuaTaiXiu = 1;
		}
		if(HeThongTaiXiu == 2)
	    {
			KetQuaTaiXiu = 2;
		}
		if(HeThongTaiXiu == 3 && TienCuocTaiAll > TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 1;
		}
		if(HeThongTaiXiu == 3 && TienCuocTaiAll < TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 2;
		}
		if(HeThongTaiXiu == 3 && TienCuocTaiAll == TienCuocXiuAll)
	    {
			switch(ketquaxucxac)
			{
	        	case 0,2,4,6,8,10,12,14,16,18: KetQuaTaiXiu = 1;
				case 1,3,5,7,9,11,13,15,17: KetQuaTaiXiu = 2;
			}
		}
		if(HeThongTaiXiu == 4 && TienCuocTaiAll > TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 2;
		}
		if(HeThongTaiXiu == 4 && TienCuocTaiAll < TienCuocXiuAll)
	    {
			KetQuaTaiXiu = 1;
		}
		if(HeThongTaiXiu == 4 && TienCuocTaiAll == TienCuocXiuAll)
	    {
			switch(ketquaxucxac)
			{
	        	case 2,4,6,8,10,12,14,16,18: KetQuaTaiXiu = 1;
				case 1,3,5,7,9,11,13,15,17: KetQuaTaiXiu = 2;
			}
		}
		switch(KetQuaTaiXiu)
		{
		    case 1: ketqua = "{FF0000}Tai{FFFFFF}";
		    case 2: ketqua = "{009900}Xiu{FFFFFF}";
		}
		new totalwealth;
		totalwealth = TienCuocTaiAll + TienCuocXiuAll - TienCuocTraAll;
	    foreach(new i: Player)
		{
		if(BatTatTaiXiu[i] == 1)
    	{
			if(TimeChonTaiXiu[i] < 40)
			{
			    if(TienCuocTaiXiu[i] > 0)
			    {
					format(string,sizeof(string),"[TAI XIU] Ban duoc tra lai %d$ va loai khoi phien nay de can bang so tien giua tai va xiu",TienCuocTaiXiu[i]);
            		SendClientMessageEx(i, COLOR_WHITE, string);
            		SendClientMessageEx(i, -1, "[TAI XIU] Co gang tham gia som hon de khoi bi loai nhe.");
            		GivePlayerCash(i,TienCuocTaiXiu[i]);
                    TienCuocTraAll = TienCuocTraAll + TienCuocTaiXiu[i];
				}
				if(TienCuocTaiAll == 0 && KetQuaTaiXiu == 1)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so #%d tuyen bo: %s thang ( Tong tien cuoc: %s$ )",Phientaixiu,ketqua,number_format(totalwealth));
            		SendClientMessageEx(i, COLOR_WHITE, string);
				}
				if(TienCuocTaiAll > 0 && KetQuaTaiXiu == 1)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so #%d | Ket qua: %s | Tong tien cuoc: %s$ | TOP: %s [%s$]",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdTaiWin),number_format(TienIdTaiWin * 2 - TienIdTaiWin * 10 / 100));
            		SendClientMessageEx(i, COLOR_WHITE, string);
				}
				if(TienCuocXiuAll == 0 && KetQuaTaiXiu == 2)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so #%d tuyen bo: %s thang ( Tong tien cuoc: %s$ )",Phientaixiu,ketqua,number_format(totalwealth));
            		SendClientMessageEx(i, COLOR_WHITE, string);
				}
				if(TienCuocXiuAll > 0 && KetQuaTaiXiu == 2)
				{
            		format(string,sizeof(string),"[TAI XIU] Phien so #%d | Ket qua: %s | Tong tien cuoc: %s$ | TOP: %s [%s$]",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdXiuWin),number_format(TienIdXiuWin * 2 - TienIdXiuWin * 10 / 100));
            		SendClientMessageEx(i, COLOR_WHITE, string);
				}
            	ChonTaiXiu[i] = 0;
				TimeChonTaiXiu[i] = 0;
				TienCuocTaiXiu[i ]= 0;
				HeThongTaiXiu = 4;
			}
			if(TimeChonTaiXiu[i] >= 40)
			{
				if(ChonTaiXiu[i] == KetQuaTaiXiu)
				{
     				if(TienCuocTaiAll == 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d tuyen bo: %s thang ( Tong tien cuoc: %s$ )",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
					if(TienCuocTaiAll > 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d | Ket qua: %s | Tong tien cuoc: %s$ | TOP: %s [%s$]",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdTaiWin),number_format(TienIdTaiWin * 2 - TienIdTaiWin * 10 / 100));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
					if(TienCuocXiuAll == 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d tuyen bo: %s thang ( Tong tien cuoc: %s$ )",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
					if(TienCuocXiuAll > 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d | Ket qua: %s | Tong tien cuoc: %s$ | TOP: %s [%s$]",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdXiuWin),number_format(TienIdXiuWin * 2 - TienIdXiuWin * 10 / 100));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
	            	format(string,sizeof(string),"Ban chien thang phien tai xiu %d va nhan duoc %s$",Phientaixiu,number_format(TienCuocTaiXiu[i]* 2 - TienCuocTaiXiu[i] * 10 / 100));
	            	SendClientMessageEx(i, -1, string);
	            	format(string2, sizeof(string2),"%s\n%s\t%s",
					string2,
					GetPlayerNameEx(i),number_format(TienCuocTaiXiu[i]* 2 - TienCuocTaiXiu[i] * 10 / 100));
	            	GivePlayerCash(i,TienCuocTaiXiu[i]* 2 - TienCuocTaiXiu[i] * 10 / 100);
	            	ChonTaiXiu[i] = 0;
					TimeChonTaiXiu[i] = 0;
					TienCuocTaiXiu[i]= 0;
					HeThongTaiXiu = 4;
					TraTienTaiXiu[i] = 0;
				}
				else if(ChonTaiXiu[i] != KetQuaTaiXiu)
				{
	         		if(TienCuocTaiAll == 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d tuyen bo: %s thang ( Tong tien cuoc: %s$ )",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
					if(TienCuocTaiAll > 0 && KetQuaTaiXiu == 1)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d | Ket qua: %s | Tong tien cuoc: %s$ | TOP: %s [%s$]",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdTaiWin),number_format(TienIdTaiWin * 2 - TienIdTaiWin * 10 / 100));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
					if(TienCuocXiuAll == 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d tuyen bo: %s thang ( Tong tien cuoc: %s$ )",Phientaixiu,ketqua,number_format(totalwealth));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
					if(TienCuocXiuAll > 0 && KetQuaTaiXiu == 2)
					{
	            		format(string,sizeof(string),"[TAI XIU] Phien so #%d | Ket qua: %s | Tong tien cuoc: %s$ | TOP: %s [%s$]",Phientaixiu,ketqua,number_format(totalwealth),GetPlayerNameEx(IdXiuWin),number_format(TienIdXiuWin * 2 - TienIdXiuWin * 10 / 100));
	            		SendClientMessageEx(i, COLOR_WHITE, string);
					}
	            	if(ChonTaiXiu[i] > 0)
	            	{
	            		SendClientMessageEx(i, -1, "[TAI XIU] Ban da thua trong phien nay");
					}
	            	ChonTaiXiu[i] = 0;
					TimeChonTaiXiu[i] = 0;
					TienCuocTaiXiu[i] = 0;
					HeThongTaiXiu = 4;
					TraTienTaiXiu[i] = 0;
				}
			}
		}
	}
		new year, month, day;
		getdate(year, month, day);
		format(TTPhienTaiXiu[Phientaixiu], sizeof(string), "Thoi gian: %d/%d/%d - %d:%d:%d\n\
		Ket qua: %s\n\
		Tong tien tai: %s\n\
		Tong tien xiu: %s\n\
		Tong tien hoan tra: %s\n\
		{FF0000}Chi tiet nguoi thang cuoc",
		month, day, year, hour, minuite,second,
		ketqua,
		number_format(TienCuocTaiAll),
		number_format(TienCuocXiuAll),
		number_format(TienCuocTraAll));
	 	format(TTWinTaiXiu[Phientaixiu], sizeof(string2), "%s",string2);
		Phientaixiu++;
		KetQuaTaiXiu = 0;
		TimeTaiXiu = 170;
		ChonTaiAll = 0;
		ChonXiuAll = 0;
		TienCuocTaiAll = 0;
		TienCuocXiuAll = 0;
		IdTaiWin = -1;
		IdXiuWin = -1;
		TienIdTaiWin = -1;
		TienIdXiuWin = -1;
		TienCuocTraAll = 0;
	}
	return 1;
}
CMD:settingtaixiu(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 5)
	{
		new chon[32], string[128];
	    if(sscanf(params, "s[32]", chon))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /settingtaixiu [dong,mo]");
			return 1;
		}
		else if(strcmp(chon,"dong",true) == 0)
		{
	        TXStats = 0;
	        TimeTaiXiu = 0;
	        SendClientMessageEx(playerid, -1,"Ban da dong tai xiu.");
	        format(string, sizeof(string), "[TAI XIU] Tai xiu da duoc dong boi %s.",GetPlayerNameEx(playerid));
	        SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		}
		else if(strcmp(chon,"mo",true) == 0)
		{
	        TXStats = 1;
	        TimeTaiXiu = 180;
	        SendClientMessageEx(playerid, -1,"Ban da mo tai xiu.");
	        format(string, sizeof(string), "[TAI XIU] Tai xiu da duoc mo boi %s",GetPlayerNameEx(playerid));
	        SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		}
	}
	return 1;
}
CMD:togtaixiu(playerid, params[])
{
    if(BatTatTaiXiu[playerid] == 1)
    {
		BatTatTaiXiu[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_RED, "[Tai Xiu] Ban da tat tai xiu");
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "[Tai Xiu] Ban da bat tai xiu.");
        BatTatTaiXiu[playerid] = 1;
    }
    return 1;
}
