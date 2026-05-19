
CMD:setgiongnoi(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new string[128], giveplayerid, giongnoi;
		if(sscanf(params, "ud", giveplayerid, giongnoi)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /setgiongnoi [playerid] [ID Giong noi]");
		if(IsPlayerConnected(giveplayerid))
		{
		PlayerInfo[giveplayerid][pAccent] = giongnoi;
		format(string, sizeof(string), "Ban set cho %s giong noi (%s).", GetPlayerNameEx(giveplayerid), giongnoi);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong duoc phep su dung lenh nay.");
	}
	return 1;
}
CMD:accent(playerid, params[])
{
	new accent;
	if(sscanf(params, "d", accent))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /giongnoi [tuy chon]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "TUY CHON: Mac dinh [1], Ha Noi [2], Da Nang [3], Sai Gon [4], Han Quoc [5], Tau Khua [6], Han Xeng [7]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "TUY CHON: Sadboiz [8], Trau Tre [9], Mien Nam [10], Mien Bac [11], Mien Trung [12], Mien Tay [13], Gangsta [14]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "TUY CHON: Gay [15], Bede [16], Mr [17], Mrs [18], Police [19], Doctor [20], Grab [21], Taxi [22]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "TUY CHON: HotBoy [23], HotGirl [24], Dang Cap [25], An Xin [26], Dan Choi [27], Super [28], Sieu Nhan [29]");
		return 1;
	}

	switch(accent)
	{
		case 1:
		{
			PlayerInfo[playerid][pAccent] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Mac dich, su dung /giongnoi de doi." );
		}
		case 2:
		{
			PlayerInfo[playerid][pAccent] = 2;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Ha Noi, su dung /giongnoi de doi." );
		}
		case 3:
		{
			PlayerInfo[playerid][pAccent] = 3;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Da Nang, su dung /giongnoi de doi." );
		}
		case 4:
		{
			PlayerInfo[playerid][pAccent] = 4;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Sai Gon, su dung /giongnoi de doi." );
		}
		case 5:
		{
			PlayerInfo[playerid][pAccent] = 5;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Han Quoc, su dung /giongnoi de doi." );
		}
		case 6:
		{
			PlayerInfo[playerid][pAccent] = 6;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Tau Khua, su dung /giongnoi de doi." );
		}
		case 7:
		{
			PlayerInfo[playerid][pAccent] = 7;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Han Xeng, su dung /giongnoi de doi." );
		}
		case 8:
		{
			PlayerInfo[playerid][pAccent] = 8;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Sadboiz, su dung /giongnoi de doi." );
		}
		case 9:
		{
			PlayerInfo[playerid][pAccent] = 9;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Trau Tre, su dung /giongnoi de doi." );
		}
		case 10:
		{
			PlayerInfo[playerid][pAccent] = 10;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Mien Nam, su dung /giongnoi de doi." );
		}
		case 11:
		{
			PlayerInfo[playerid][pAccent] = 11;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Mien Bac, su dung /giongnoi de doi." );
		}
		case 12:
		{
			PlayerInfo[playerid][pAccent] = 12;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Mien Trung, su dung /giongnoi de doi." );
		}
		case 13:
		{
			PlayerInfo[playerid][pAccent] = 13;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Mien Tay, su dung /giongnoi de doi." );
		}
		case 14:
		{
			PlayerInfo[playerid][pAccent] = 14;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Gangsta, su dung /giongnoi de doi." );
		}
		case 15:
		{
			PlayerInfo[playerid][pAccent] = 15;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Gay, su dung /giongnoi de doi." );
		}
		case 16:
		{
			PlayerInfo[playerid][pAccent] = 16;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Bede, su dung /giongnoi de doi." );
		}
		case 17:
		{
			PlayerInfo[playerid][pAccent] = 17;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Mr, su dung /giongnoi de doi." );
		}
		case 18:
		{
			PlayerInfo[playerid][pAccent] = 18;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Mrs, su dung /giongnoi de doi." );
		}
		case 19:
		{
			PlayerInfo[playerid][pAccent] = 19;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Police, su dung /giongnoi de doi." );
		}
		case 20:
		{
			PlayerInfo[playerid][pAccent] = 20;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Doctor, su dung /giongnoi de doi." );
		}
		case 21:
	    {
	        PlayerInfo[playerid][pAccent] = 21;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Grab, su dung /giongnoi de doi." );
	    }
		case 22:
	    {
	        PlayerInfo[playerid][pAccent] = 22;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Taxi, su dung /giongnoi de doi." );
	    }
   		case 23:
	    {
	        PlayerInfo[playerid][pAccent] = 23;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi HotBoy, su dung /giongnoi de doi." );
	    }
	    case 24:
	    {
	        PlayerInfo[playerid][pAccent] = 24;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi HotGirl, su dung /giongnoi de doi." );
	    }
		case 25:
	    {
	        PlayerInfo[playerid][pAccent] = 25;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Dang Cap, su dung /giongnoi de doi." );
	    }
		case 26:
	    {
	        PlayerInfo[playerid][pAccent] = 26;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi An Xin, su dung /giongnoi de doi." );
	    }
		case 27:
	    {
	        PlayerInfo[playerid][pAccent] = 27;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Dan Choi, su dung /giongnoi de doi." );
	    }
		case 28:
	    {
	        PlayerInfo[playerid][pAccent] = 28;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Super, su dung /giongnoi de doi." );
	    }
		case 29:
		{
			PlayerInfo[playerid][pAccent] = 29;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi sang giong noi Sieu Nhan, su dung /giongnoi de doi." );
		}
		case 21515:
		{
			PlayerInfo[playerid][pAccent] = 21515;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi OS" );
		}
		case 32215:
		{
			PlayerInfo[playerid][pAccent] = 32215;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi GTANetwork" );
		}
		case 99485:
		{
			PlayerInfo[playerid][pAccent] = 54561873;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Admin" );
		}
		case 12254:
		{
			PlayerInfo[playerid][pAccent] = 99697894;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi VIP" );
		}
		case 49518:
		{
			PlayerInfo[playerid][pAccent] = 49518;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Hypebeast" );
		}
		case 95418:
		{
			PlayerInfo[playerid][pAccent] = 95418;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi SipHong" );
		}
		case 35854:
		{
			PlayerInfo[playerid][pAccent] = 35854;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Proplayer" );
		}
		case 25842:
		{
			PlayerInfo[playerid][pAccent] = 25842;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi FendiGang" );
		}
		case 14841:
		{
			PlayerInfo[playerid][pAccent] = 14841;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi GucciGang" );
		}
		case 27101:
		{
			PlayerInfo[playerid][pAccent] = 27101;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi SUPER" );
		}
		case 10172:
		{
			PlayerInfo[playerid][pAccent] = 10172;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi My Name Is" );
		}
		case 271001:
		{
			PlayerInfo[playerid][pAccent] = 271001;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Nguyen" );
		}
		case 171169:
		{
			PlayerInfo[playerid][pAccent] = 171169;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi SouthSide (ord)" );
		}
		case 45981:
		{
			PlayerInfo[playerid][pAccent] = 45981;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi DEV" );
		}
		case 98132:
		{
			PlayerInfo[playerid][pAccent] = 98132;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Morgan" );
		}
		case 339900:
		{
			PlayerInfo[playerid][pAccent] = 339900;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Stoner" );
		}
		case 813184:
		{
			PlayerInfo[playerid][pAccent] = 813184;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Cam Ranh" );
		}
		case 215485:
		{
			PlayerInfo[playerid][pAccent] = 215485;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Police" );
		}
		case 875851:
		{
			PlayerInfo[playerid][pAccent] = 875851;
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da doi qua giong noi Korea" );
		}
	}
	return 1;
}
//41165 = SouthSide
//4265 = Ne339900
