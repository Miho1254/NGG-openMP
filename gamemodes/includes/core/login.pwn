#define 					LOGINCAM_SPEED 						10000
#define 					LOGINCAM_CUT 						CAMERA_MOVE

#define 					CAMERA_MOVE_SPEED					7000
#define						CAMERA_ZOOM_DISTANCE				800.0
#define 					CAMERA_ROTATION_ANGLE				15.0
#define 					MAINMENU_CAMERA_SPEED				20000

stock SetPlayerJoinCamera(playerid)
{
	new randcamera = Random(1,9);
	switch(randcamera)
	{
		case 1: // Gym
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,2229.4968,-1722.0701,13.5625);
			SetPlayerPos(playerid,2211.1460,-1748.3909,-10.0);
			SetPlayerCameraPos(playerid,2211.1460,-1748.3909,29.3744);
			SetPlayerCameraLookAt(playerid,2229.4968,-1722.0701,13.5625);
		}
		case 2: // Paintball Arena
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1295.6960,-1422.5111,14.9596);
			SetPlayerPos(playerid,1283.8524,-1385.5304,-10.0);
			SetPlayerCameraPos(playerid,1283.8524,-1385.5304,25.8896);
			SetPlayerCameraLookAt(playerid,1295.6960,-1422.5111,14.9596);
		}
		case 3: // LSPD
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1554.3381,-1675.5692,16.1953);
			SetPlayerPos(playerid,1514.7783,-1700.2913,-10.0);
			SetPlayerCameraPos(playerid,1514.7783,-1700.2913,36.7506);
			SetPlayerCameraLookAt(playerid,1554.3381,-1675.5692,16.1953);
		}
		case 4: // SaC HQ (Gang HQ)
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,655.5394,-1867.2231,5.4609);
			SetPlayerPos(playerid,655.5394,-1867.2231,-10.0);
			SetPlayerCameraPos(playerid,699.7435,-1936.7568,24.8646);
			SetPlayerCameraLookAt(playerid,655.5394,-1867.2231,5.4609);

		}
		case 5: // Fishing Pier
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,370.0804,-2087.8767,7.8359);
			SetPlayerPos(playerid,370.0804,-2087.8767,-10.0);
			SetPlayerCameraPos(playerid,423.3802,-2067.7915,29.8605);
			SetPlayerCameraLookAt(playerid,370.0804,-2087.8767,7.8359);
		}
		case 6: // VIP
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1797.3397,-1578.3440,14.0798);
			SetPlayerPos(playerid,1797.3397,-1578.3440,-10.0);
			SetPlayerCameraPos(playerid,1832.1698,-1600.1538,32.2877);
			SetPlayerCameraLookAt(playerid,1797.3397,-1578.3440,14.0798);
		}
		case 7: // All Saints
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1175.5581,-1324.7922,18.1610);
			SetPlayerPos(playerid, 1188.4574,-1309.2242,-10.0);
			SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
			SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
		}
		case 8: // Unity
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
	}
	return 1;
}

stock ShowMainMenuDialog(playerid, frame)
{
    new titlestring[128];
    new string[1024]; 
    TextDrawShowForPlayer(playerid, TDE_LOGINGTN[0]);
    TextDrawShowForPlayer(playerid, TDE_LOGINGTN[1]);
    
    new pName[MAX_PLAYER_NAME];
    format(pName, sizeof(pName), "%s", GetPlayerNameEx(playerid));

    switch(frame)
    {
        case 1: // Đăng nhập
        {
            format(titlestring, sizeof(titlestring), "{00FFCC}SAW Community {FFFFFF}>> Dang Nhap");
            format(string, sizeof(string), "\
            {FFFFFF}Chao mung tro lai, {00FFCC}%s{FFFFFF}!\n\
            {FFFFFF}Trang thai dinh danh: {4EC25D}Da co du lieu{FFFFFF}.\n\
            {A9A9A9}------------------------------------------------\n\n\
            {FFFFFF}He thong an ninh yeu cau ma bao mat de truy cap.\n\
            {A9A9A9}Vui long nhap mat khau cua ban vao o ben duoi:", pName);
            
            ShowPlayerDialogEx(playerid, MAINMENU, DIALOG_STYLE_PASSWORD, titlestring, string, "Truy cap", "Thoat");
        }
        case 2: // Đăng ký
        {
            format(titlestring, sizeof(titlestring), "{00FFCC}SAW Community {FFFFFF}>> Dang Ky Dinh Danh");
            format(string, sizeof(string), "\
            {FFFFFF}Nhan dien cu dan moi: {00FFCC}%s{FFFFFF}\n\
            {FFFFFF}Trang thai dinh danh: {FF4C4C}Chua co ho so{FFFFFF}.\n\
            {A9A9A9}------------------------------------------------\n\n\
            {FFFFFF}Vui long thiet lap ma bao mat (mat khau) de tao tai khoan:", pName);
            
            if(PassComplexCheck) 
            {
                strcat(string, "\n\n\
                {FFCC00}[!] Yeu cau bao mat he thong:{FFFFFF}\n\
                {A9A9A9}- Do dai tu 8 den 64 ky tu.\n\
                - Khuyen dung ket hop chu, so va ky tu dac biet.\n\
                - Ky tu bi cam: {FF4C4C}%%{A9A9A9} (Phan tram)");
            }
            
            ShowPlayerDialogEx(playerid, MAINMENU2, DIALOG_STYLE_PASSWORD, titlestring, string, "Khoi tao", "Thoat");
        }
        case 3: // Sai pass
        {
            format(titlestring, sizeof(titlestring), "{FF4C4C}CANH BAO {FFFFFF}>> Sai Ma Bao Mat");
            format(string, sizeof(string), "\
            {FF4C4C}[X] Mat khau khong chinh xac! Vui long kiem tra lai.{FFFFFF}\n\n\
            {FFFFFF}Tai khoan truy cap: {00FFCC}%s{FFFFFF}\n\
            {A9A9A9}------------------------------------------------\n\n\
            {FFFFFF}He thong dang cho ma bao mat hop le.\n\
            {A9A9A9}Neu quen mat khau, vui long lien he Ban Quan Tri qua Discord.", pName);
            
            ShowPlayerDialogEx(playerid, MAINMENU, DIALOG_STYLE_PASSWORD, titlestring, string, "Thu lai", "Thoat");
        }
        case 4: // Kẹt acc
        {
            format(titlestring, sizeof(titlestring), "{FFCC00}LOI TRUY CAP {FFFFFF}>> Tai Khoan Dang Hoat Dong");
            format(string, sizeof(string), "\
            {FFCC00}[!] He thong phat hien bat thuong!{FFFFFF}\n\n\
            Dinh danh {00FFCC}%s{FFFFFF} hien dang truc tuyen tren may chu.\n\
            {A9A9A9}------------------------------------------------\n\n\
            {FFFFFF}Nguyen nhan co the do:\n\
            {A9A9A9}- Ban vua bi vang game (Ket Acc) - Hay thu vao lai sau 1-2 phut.\n\
            - Co nguoi khac dang dang nhap vao tai khoan cua ban.\n\n\
            {FFFFFF}Neu tinh trang tiep dien, hay bao ngay cho Admin!", pName);
            
            ShowPlayerDialogEx(playerid, MAINMENU3, DIALOG_STYLE_MSGBOX, titlestring, string, "Da ro", "");
        }
    }
    return 1;
}

stock SafeLogin(playerid, type)
{
	switch(type)
	{
		case 1: // Account Exists
		{
			ShowMainMenuDialog(playerid, 1);
		}
		case 2: // No Account Exists
		{
			if(betaserver == 0 || betaserver == 2)
			{
				if(!IsValidName(GetPlayerNameExt(playerid)))
				{
				    SetPVarString(playerid, "KickNonRP", GetPlayerNameEx(playerid));
				    SetTimerEx("KickNonRP", 3000, false, "i", playerid);
				}
				else
				{
				    ShowMainMenuDialog(playerid, 2);
				}
			}
			else
			{
				Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "ERROR: You were kicked!", "You're unable to create an account on this server!\n\nThis server is for the Beta Team only.\n\nIf you are a beta tester go to http://saw-community.net and create an account.", "Tat", "");
				SetTimerEx("KickEx", 3000, 0, "i", playerid);
			}
		}
	}

	return 1;
}

stock InvalidNameCheck(playerid) {

	new
		arrForbiddenNames[][] = {
			"com1", "com2", "com3", "com4",
			"com5", "com6", "com7", "com8",
			"com9", "lpt4", "lpt5", "lpt6",
			"lpt7", "lpt8", "lpt9", "nul",
			"clock$", "aux", "prn", "con",
			"InvalidNick"
	    };

	new i = 0;
	while(i < sizeof(arrForbiddenNames)) if(strcmp(arrForbiddenNames[i++], GetPlayerNameExt(playerid), true) == 0) {
		SetPlayerName(playerid, "InvalidNick");
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ban da bi kick khoi may chu vi su dung ten dang nhap bi cam.");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 0;

	}
	return 1;
}

stock ShowMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = true;
	MainMenuUpdateForPlayer(playerid);

	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[10]);
	TextDrawShowForPlayer(playerid, TD_LoginScreen);

	PlayAudioStreamForPlayer(playerid, "http://160.187.229.19/login_background_audio.mp3");

	TogglePlayerSpectating(playerid, true);
	//SetTimerEx("loginCamera", 1000, false, "i", playerid);
}

stock HideMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = false;

	TextDrawHideForPlayer(playerid, TD_LoginScreen);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[10]);

	//DeletePVar(playerid, "LoginScreen");
	TogglePlayerSpectating(playerid, false);
	StopAudioStreamForPlayer(playerid);
}

CheckPasswordComplexity(const password[])
{
	if(!(8 <= strlen(password) <= 64)) return 0;
	new i = 0, containsletters, containsnumbers, containsspecial;
	while(password[i] != '\0')
	{
		if('a' <= password[i] <= 'z') containsletters = 1;
		else if('A' <= password[i] <= 'Z') containsletters = 1;
		else if('0' <= password[i] <= '9') containsnumbers = 1;
		// !"#$%&'()*+,-./ :;<=>?@[\]^_`  {|}~
		else if(33 <= password[i] <= 47 || 58 <= password[i] <= 64 || 91 <= password[i] <= 96 || 123 <= password[i] <= 126) containsspecial = 1;
		if(containsletters && containsnumbers && containsspecial) break;
		i++;
	}
	if(!containsletters || !containsnumbers || !containsspecial) return 0;
	return 1;
}

forward LoginCheck(playerid);
public LoginCheck(playerid)
{
	if(gPlayerLogged{playerid} == 0 && IsPlayerConnected(playerid))
	{
		new string[128];
		format(string, sizeof(string), "%s(%d) [%s] has timed out of the login screen.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
		Log("logs/security.log", string);
		SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: Het thoi gian dang nhap - Ban phai dang nhap trong 60 giay!");
		ShowPlayerDialogEx(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
	}
	return 1;
}

stock ShowLoginDialogs(playerid, index)
{
	new string[128];
	switch(index)
	{
		case 0:
		{
			ShowPlayerDialogEx(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.", "Change", "Exit" );
			if(PassComplexCheck) ShowPlayerDialogEx(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.\n\n\
			- You can't select a password that's below 8 or above 64 characters\n\
			- Your password must contain a combination of letters, numbers and special characters.\n\
			- Invalid Character: %", "Change", "Exit" );
		}
		case 1: 
		{
			// ShowPlayerDialogEx(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
			AdvanceTutorial(playerid);
		}
		case 4: ShowPlayerDialogEx(playerid, PMOTDNOTICE, DIALOG_STYLE_MSGBOX, "Notice", pMOTD, "Dismiss", "");
		case 5:
		{
			format(string, sizeof(string), "Ban da nhan duoc {FFD700}%s{A9C4E4} credits! Use /shophelp for more information.", number_format(PlayerInfo[playerid][pReceivedCredits]));
			ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Credits Received!", string, "Close", "");

			new szLog[128];
			format(szLog, sizeof(szLog), "[ISSUED] [User: %s(%i)] [IP: %s] [Credits: %s]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pReceivedCredits]));
			Log("logs/logincredits.log", szLog), print(szLog);

			PlayerInfo[playerid][pReceivedCredits] = 0;
		}
	}
	return 1;
}

forward loginCamera(playerid);
public loginCamera(playerid)
{
	if(InsideMainMenu{playerid} == 0) return 1;
	new stage = GetPVarInt(playerid, "LoginScreen");
	if(!stage) return 1;
	switch(stage)
	{
		case 1: // Gym
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,2229.4968,-1722.0701,13.5625);
			SetPlayerPos(playerid,2211.1460,-1748.3909,-10.0);
			SetPlayerCameraPos(playerid,2211.1460,-1748.3909,29.3744);
			SetPlayerCameraLookAt(playerid,2229.4968,-1722.0701,13.5625);
		}
		case 2: // Paintball Arena
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1295.6960,-1422.5111,14.9596);
			SetPlayerPos(playerid,1283.8524,-1385.5304,-10.0);
			SetPlayerCameraPos(playerid,1283.8524,-1385.5304,25.8896);
			SetPlayerCameraLookAt(playerid,1295.6960,-1422.5111,14.9596);
		}
		case 3: // LSPD
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1554.3381,-1675.5692,16.1953);
			SetPlayerPos(playerid,1514.7783,-1700.2913,-10.0);
			SetPlayerCameraPos(playerid,1514.7783,-1700.2913,36.7506);
			SetPlayerCameraLookAt(playerid,1554.3381,-1675.5692,16.1953);
		}
		case 4: // SaC HQ (Gang HQ)
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,655.5394,-1867.2231,5.4609);
			SetPlayerPos(playerid,655.5394,-1867.2231,-10.0);
			SetPlayerCameraPos(playerid,699.7435,-1936.7568,24.8646);
			SetPlayerCameraLookAt(playerid,655.5394,-1867.2231,5.4609);

		}
		case 5: // Fishing Pier
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,370.0804,-2087.8767,7.8359);
			SetPlayerPos(playerid,370.0804,-2087.8767,-10.0);
			SetPlayerCameraPos(playerid,423.3802,-2067.7915,29.8605);
			SetPlayerCameraLookAt(playerid,370.0804,-2087.8767,7.8359);
		}
		case 6: // VIP
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1797.3397,-1578.3440,14.0798);
			SetPlayerPos(playerid,1797.3397,-1578.3440,-10.0);
			SetPlayerCameraPos(playerid,1832.1698,-1600.1538,32.2877);
			SetPlayerCameraLookAt(playerid,1797.3397,-1578.3440,14.0798);
		}
		case 7: // All Saints
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1175.5581,-1324.7922,18.1610);
			SetPlayerPos(playerid, 1188.4574,-1309.2242,-10.0);
			SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
			SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
		}
		case 8: // Unity
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
	}
	SetTimerEx("loginCamera", 10000, false, "i", playerid);
	SetPVarInt(playerid, "LoginScreen", Random(1,9));
	return 1;
}

/*
forward loginCamera(playerid);
public loginCamera(playerid)
{
	if(InsideMainMenu{playerid} == 0) return 1;
	new stage = GetPVarInt(playerid, "LoginScreen");
	if(!stage) return 1;
	switch(stage)
	{
		case 1:
		{
			//SetPVarInt(playerid, "o_iLoginObjectID", CreateDynamicObject(10757, -1037.50903, 453.60007, 34.86839,   0.00000, 0.00000, 315.27899, -1, -1, playerid, 500.0));
			//MoveDynamicObject(GetPVarInt(playerid, "o_iLoginObjectID"), -1181.16455, 310.40958, 28.76766, 30.0);
			InterpolateCameraPos(playerid, -1205.5737, 287.1576, 15.0854, -1084.4949, 408.7233, 19.8364, LOGINCAM_SPEED, LOGINCAM_CUT);
			InterpolateCameraLookAt(playerid, -1204.8885, 287.8855, 15.1403, -1083.7922, 409.4344, 19.8913, LOGINCAM_SPEED, LOGINCAM_CUT);
			SetPlayerPos(playerid, -1204.8885, 287.8855, 15.1403);
		}
		case 2:
		{
			//DestroyDynamicObject(GetPVarInt(playerid,"o_iLoginObjectID"));
			InterpolateCameraPos(playerid, 367.0753, -2008.7896, 7.9850, 367.0673, -2002.2097, 8.4014, LOGINCAM_SPEED, LOGINCAM_CUT);
			InterpolateCameraLookAt(playerid, 366.2721, -2008.2030, 8.1950, 366.1893, -2001.7432, 8.5165, LOGINCAM_SPEED, LOGINCAM_CUT);
			SetPlayerPos(playerid, 367.0753, -2008.7896, 7.9850);
		}
		case 3:
		{
			InterpolateCameraPos(playerid, 220.7953, -1931.9850, 11.1282, 118.6140, -2010.0983, 36.6997, LOGINCAM_SPEED, LOGINCAM_CUT);
			InterpolateCameraLookAt(playerid, 219.9500, -1932.5101, 11.2782, 119.2489, -2009.3315, 36.5448, LOGINCAM_SPEED, LOGINCAM_CUT);
			SetPlayerPos(playerid, 220.7953, -1931.9850, 11.1282);
		}
		case 4:
		{
			InterpolateCameraPos(playerid, -178.8338, -1365.6261, 34.7616, -119.1325, -1245.7603, 23.8896, LOGINCAM_SPEED, LOGINCAM_CUT);
			InterpolateCameraLookAt(playerid, -178.4177, -1364.7233, 34.6766, -119.1364, -1244.7668, 23.7446, LOGINCAM_SPEED, LOGINCAM_CUT);
			SetPlayerPos(playerid, -178.8338, -1365.6261, 34.7616);
		}
		case 5:
		{
			InterpolateCameraPos(playerid, 691.6666, -1390.5863, 12.6861, 717.0291, -1391.0935, 13.1583, LOGINCAM_SPEED, LOGINCAM_CUT);
			InterpolateCameraLookAt(playerid, 692.4824, -1390.0200, 12.9711, 717.9996, -1390.8818, 13.3234, LOGINCAM_SPEED, LOGINCAM_CUT);
			SetPlayerPos(playerid, 691.6666, -1390.5863, 12.6861);
		}
		case 6:
		{
			InterpolateCameraPos(playerid, 1024.1499, -333.9991, 74.7856, 1069.5502, -326.5808, 74.3607, LOGINCAM_SPEED, LOGINCAM_CUT);
			InterpolateCameraLookAt(playerid, 1025.1135, -333.7570, 74.7156, 1070.2540, -327.2821, 74.5607, LOGINCAM_SPEED, LOGINCAM_CUT);
			SetPlayerPos(playerid, 1024.1499, -333.9991, 74.7856);
		}
		case 7:
		{
			InterpolateCameraPos(playerid, 234.6522, 1982.8652, 18.7558, 238.8765, 2003.7644, 22.0445, LOGINCAM_SPEED, LOGINCAM_CUT);
			InterpolateCameraLookAt(playerid, 234.2398, 1983.7708, 18.7858, 238.4337, 2004.6549, 22.0845, LOGINCAM_SPEED, LOGINCAM_CUT);
			SetPlayerPos(playerid, 234.6522, 1982.8652, 18.7558);
			return 1;
		}
	}
	SetTimerEx("loginCamera", 10000, false, "i", playerid);
	SetPVarInt(playerid, "LoginScreen", stage+1);
	return 1;
}*/

/*LoginCamToPlayer(playerid)
{
        new Float:A;
        GetPlayerFacingAngle(playerid, A);
        
        SetPVarInt(playerid, "LoginCam", 1); 
        SetTimerEx("OnLoginCam", CAMERA_MOVE_SPEED, false, "i", playerid);
        TogglePlayerControllable(playerid, 0);
        InterpolateCameraPos(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z] + CAMERA_ZOOM_DISTANCE, PlayerInfo[playerid][pPos_x] + 3.255828, PlayerInfo[playerid][pPos_y] - 4.534179, PlayerInfo[playerid][pPos_z] + 1.047477, CAMERA_MOVE_SPEED, CAMERA_MOVE);
        InterpolateCameraLookAt(playerid, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y] + CAMERA_ROTATION_ANGLE, PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], CAMERA_MOVE_SPEED, CAMERA_MOVE);
        return 1;
}

forward OnLoginCam(playerid);
public OnLoginCam(playerid)
{
	StopAudioStreamForPlayer(playerid);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	DeletePVar(playerid, "LoginCam");
	return 1;
}*/
