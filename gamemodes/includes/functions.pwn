/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[FUNCTIONS.PWN]--------------------------------


 * Copyright (c) 2016, GTA.Network, LLC
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are not permitted in any case.
 *
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

			/*  ---------------- FUNCTIONS ----------------- */
			
#if defined zombiemode

stock intdiffabs(tick1, tick2)
{
	if(tick1 > tick2)
		return abs(tick1 - tick2);

	else
		return abs(tick2 - tick1);
}

stock GetTickCountDifference(a, b)
{
	if ((a < 0) && (b > 0))
	{

		new dist;

		dist = intdiffabs(a, b);

		if(dist > 2147483647)
			return intdiffabs(a - 2147483647, b - 2147483647);

		else
			return dist;
	}

	return intdiffabs(a, b);
}

Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
  new Float:x, Float:y, Float:z;
  x = x1-x2;
  y = y1-y2;
  z = z1-z2;
  return floatsqroot(x*x+y*y+z*z);
}
#endif

Format_PlayerName(playerid) {
	
	szMiscArray[0] = 0;
	
	new iPos, name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, szMiscArray, MAX_PLAYER_NAME);
	for(new i; i < MAX_PLAYER_NAME; i++) szMiscArray[i] = tolower(szMiscArray[i]);
	szMiscArray[0] = toupper(szMiscArray[0]);
	format(name, sizeof(name), "Formatting_%d", playerid);
	SetPlayerName(playerid, name);
	while((iPos = strfind(szMiscArray, "_", false, iPos)) != -1) iPos++, szMiscArray[iPos] = toupper(szMiscArray[iPos]);
	SetPlayerName(playerid, szMiscArray);
	printf("[PlayerName] Formatted %s to the correct RP-format standards.", szMiscArray);
}

CheckPointCheck(iTargetID)  {
	if(GetPVarType(iTargetID, "hFind") > 0 || GetPVarType(iTargetID, "TrackCar") > 0 || GetPVarType(iTargetID, "DV_TrackCar") > 0 || GetPVarType(iTargetID, "Packages") > 0 || TaxiAccepted[iTargetID] != INVALID_PLAYER_ID || EMSAccepted[iTargetID] != INVALID_PLAYER_ID || BusAccepted[iTargetID] != INVALID_PLAYER_ID || gPlayerCheckpointStatus[iTargetID] != CHECKPOINT_NONE || MedicAccepted[iTargetID] != INVALID_PLAYER_ID || MechanicCallTime[iTargetID] >= 1) {
		return 1;
	}
	if(MatDeliver[iTargetID] != -1 || GetPVarType(iTargetID, "TrackVehicleBurglary") > 0 || GetPVarType(iTargetID, "DeliveringVehicleTime") > 0 || GetPVarType(iTargetID, "pDTest") > 0 || GetPVarType(iTargetID, "pGarbageRun") > 0 || GetPVarType(iTargetID, "pSellingFish") > 0 || GetPVarType(iTargetID, "pDrugRun") || PlayerInfo[iTargetID][pTut] >= 0) 
		return 1;
	return 0;
}

IsNumeric(szInput[]) {

	new
		iChar,
		i = 0;

	while ((iChar = szInput[i++])) if (!('0' <= iChar <= '9')) return 0;
	return 1;
}

ReturnUserFromIP(szIP[]) {

	foreach(new i : Player) {
		if(strcmp(szIP, GetPlayerIpEx(i), true) == 0) return i;
	}
	return INVALID_PLAYER_ID;
}

ReturnUser(text[]) {

	new
		strPos,
		returnID = 0,
		bool: isnum = true;
	
	if(!strlen(text)) return INVALID_PLAYER_ID;
	
	while(text[strPos]) {
		if(isnum) {
			if ('0' <= text[strPos] <= '9') returnID = (returnID * 10) + (text[strPos] - '0');
			else isnum = false;
		}
		strPos++;
	}
	if (isnum) {
		if(IsPlayerConnected(returnID)) return returnID;
	}
	else {

		new
			sz_playerName[MAX_PLAYER_NAME];

		foreach(new i: Player)
		{
			GetPlayerName(i, sz_playerName, MAX_PLAYER_NAME);
			if(!strcmp(sz_playerName, text, true, strPos)) return i;
		}	
	}
	return INVALID_PLAYER_ID;
}

MainMenuUpdateForPlayer(playerid)
{
	new string[156];

	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1)
	{
		format(string, sizeof(string), "~y~MOTD~w~: %s", GlobalMOTD);
		TextDrawSetString(MainMenuTxtdraw[9], string);
	}
}

/*
Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
  new Float:x, Float:y, Float:z;
  x = x1-x2;
  y = y1-y2;
  z = z1-z2;
  return floatsqroot(x*x+y*y+z*z);
}

Float:GetPointDistanceToPointEx(Float:x1,Float:y1,Float:x2,Float:y2)
{
  new Float:x, Float:y;
  x = x1-x2;
  y = y1-y2;
  return floatsqroot(x*x+y*y);
} */

RemovePlayerWeapon(playerid, weaponid)
{
	ResetPlayerWeapons(playerid);
	PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] = 0;
	SetPlayerWeaponsEx(playerid);
	return 1;
}

IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

SetPlayerPosObjectOffset(objectid, playerid, Float:offset_x, Float:offset_y, Float:offset_z)
{
	new Float:object_px,
        Float:object_py,
        Float:object_pz,
        Float:object_rx,
        Float:object_ry,
        Float:object_rz;

    GetDynamicObjectPos(objectid, object_px, object_py, object_pz);
    GetDynamicObjectRot(objectid, object_rx, object_ry, object_rz);

    printf("%f, %f, %f, %f, %f, %f", object_px, object_py, object_pz, object_rx, object_ry, object_rz);

    new Float:cos_x = floatcos(object_rx, degrees),
        Float:cos_y = floatcos(object_ry, degrees),
        Float:cos_z = floatcos(object_rz, degrees),
        Float:sin_x = floatsin(object_rx, degrees),
        Float:sin_y = floatsin(object_ry, degrees),
        Float:sin_z = floatsin(object_rz, degrees);

	new Float:x, Float:y, Float:z;
    x = object_px + offset_x * cos_y * cos_z - offset_x * sin_x * sin_y * sin_z - offset_y * cos_x * sin_z + offset_z * sin_y * cos_z + offset_z * sin_x * cos_y * sin_z;
    y = object_py + offset_x * cos_y * sin_z + offset_x * sin_x * sin_y * cos_z + offset_y * cos_x * cos_z + offset_z * sin_y * sin_z - offset_z * sin_x * cos_y * cos_z;
    z = object_pz - offset_x * cos_x * sin_y + offset_y * sin_x + offset_z * cos_x * cos_y;

	SetPlayerPos(playerid, x, y, z);
}

GlobalPlaySound(soundid, Float:x, Float:y, Float:z) {
	
	foreach(new i : Player) {
		if(IsPlayerInRangeOfPoint(i, 25.0, x, y, z)) {
			PlayerPlaySound(i, soundid, x, y, z);
		}
	}
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

GetXYBehindPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a+180, degrees));
    y += (distance * floatcos(-a+180, degrees));
}

/*GetXYInFrontOfVehicle(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetVehiclePos(playerid, x, y, a);
    GetVehicleZAngle(playerid, a);
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}*/

IsInRangeOfPoint(Float: fPosX, Float: fPosY, Float: fPosZ, Float: fPosX2, Float: fPosY2, Float: fPosZ2, Float: fDist) {
    fPosX -= fPosX2;
	fPosY -= fPosY2;
    fPosZ -= fPosZ2;
    return ((fPosX * fPosX) + (fPosY * fPosY) + (fPosZ * fPosZ)) < (fDist * fDist);
}

/*PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0,1);
}*/

IsValidName(szPlayerName[]) {

	new
		iLength,
		tmpName[MAX_PLAYER_NAME],
		invalids;

	mysql_escape_string(szPlayerName, tmpName);
	if(strcmp(szPlayerName, tmpName, false) != 0)
	{
		return 0;
	}
	iLength = strlen(szPlayerName);

	if(strfind(szPlayerName, "_", false) == -1 || szPlayerName[iLength - 1] == '_' || szPlayerName[0] == '_') return 0;
	else if(szPlayerName[0] == '.' || szPlayerName[0] == '_' || strfind(szPlayerName, "_says", true) != -1 || strfind(szPlayerName, "_shouts", true) != -1 || strfind(szPlayerName, "_quietly", true) != -1) return 0;
	else if(strfind(szPlayerName, "_whispers", true) != -1 || strfind(szPlayerName, "_whisper", true) != -1) return 0;
	else for(new i; i < iLength; ++i) {
		if(!('a' <= szPlayerName[i] <= 'z' || 'A' <= szPlayerName[i] <= 'Z' 
			|| szPlayerName[i] == '_') && szPlayerName[i] != '.') return 0;
		if(szPlayerName[i] == 'I' && i == 0) continue;
		if(szPlayerName[i] == '_' && szPlayerName[i+1] == '.') invalids++;
		if(szPlayerName[i] == 'I' && szPlayerName[i-1] != '_') invalids++;
		if(invalids > 0) return 0;
	}
	return 1;
}

GetPlayerPriority(Player)
{
	if(PlayerInfo[Player][pDonateRank] >= 4 || PlayerInfo[Player][pRewardHours] > 150) return 2;
	else if(PlayerInfo[Player][pAdmin] >= 1 || PlayerInfo[Player][pHelper] >= 2) return 3;
	else return 4;
}

IsPlayerInRangeOfDynamicObject(iPlayerID, iObjectID, Float: fRadius) {

	new
		Float: fPos[3];

	GetDynamicObjectPos(iObjectID, fPos[0], fPos[1], fPos[2]);
	return IsPlayerInRangeOfPoint(iPlayerID, fRadius, fPos[0], fPos[1], fPos[2]);
}

Array_Count(arrCount[], iMax = sizeof arrCount) {

	new
		iCount,
		iPos;

	while(iPos < iMax) if(arrCount[iPos++]) ++iCount;
	return iCount;
}

String_Count(arrCount[][], iMax = sizeof arrCount) {

	new
		iCount,
		iPos;

	while(iPos < iMax) if(arrCount[iPos++][0]) ++iCount;
	return iCount;
}

			/*  ---------------- PUBLIC FUNCTIONS -----------------  */
forward HideReportText(playerid);
public HideReportText(playerid)
{
    TextDrawHideForPlayer(playerid, PriorityReport[playerid]);
    return 1;
}

forward killPlayer(playerid);
public killPlayer(playerid)
{
	new query[128];
	if(GetPVarInt(playerid, "commitSuicide") == 1) 
	{
		mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `kills` (`id`, `killerid`, `killedid`, `date`, `weapon`) VALUES (NULL, %d, %d, NOW(), '/kill')", GetPlayerSQLId(playerid), GetPlayerSQLId(playerid));
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
		SetPVarInt(playerid, "commitSuicide", 0);
		SetHealth(playerid, 0);
	}
	else
		return SendClientMessageEx(playerid, COLOR_RED, "Ban da bi ton thuong trong 10 giay, do do ban khong the tu sat.");
	return 1;
}

forward DisableVehicleAlarm(vehicleid);
public DisableVehicleAlarm(vehicleid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
 	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    SetVehicleParamsEx(vehicleid,engine,lights,VEHICLE_PARAMS_OFF,doors,bonnet,boot,objective);
	return 1;
}

forward ReleasePlayer(playerid);
public ReleasePlayer(playerid)
{
	DeletePVar(playerid, "IsFrozen");
	if(PlayerCuffed[playerid] == 0)
	{
		TogglePlayerControllable(playerid,1);
	}
}

forward ControlCam(playerid);
public ControlCam(playerid)
{
    new Float:X, Float:Y, Float:Z;
	GetDynamicObjectPos(Carrier[0], X, Y, Z);
 	SetPlayerCameraPos(playerid, X-200, Y, Z+40);
  	SetPlayerCameraLookAt(playerid, X, Y, Z);
}

forward IdiotSound(playerid);
public IdiotSound(playerid)
{
    PlayAudioStreamForPlayerEx(playerid, "http://www.ng-gaming.net/users/farva/you-are-an-idiot.mp3");
    ShowPlayerDialogEx(playerid,DIALOG_NOTHING,DIALOG_STYLE_MSGBOX,"BUSTED!","Thue 15 phan tram duoc danh thue vao tai khoan cua ban cung voi 3 gio tu, su dung tinh nang co the bi khoa tai khoan","Exit","");
}

forward SetCamBack(playerid);
public SetCamBack(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:plocx,Float:plocy,Float:plocz;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		SetPlayerPos(playerid, -1863.15, -21.6598, 1060.15); // Warp the player
		SetPlayerInterior(playerid,14);
	}
}

forward HttpCallback_ShopIDCheck(index, response_code, data[]);
public HttpCallback_ShopIDCheck(index, response_code, data[])
{
	new string[128], shopstring[512], shoptechs, confirmed = strval(data);
	PlayerInfo[index][pOrderConfirmed] = confirmed;

	if(response_code == 200)
	{
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pShopTech] > 0)
			{
				shoptechs++;
			}
		}	

		if(shoptechs > 0)
		{
			if(confirmed)
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Ban dang cho de nhan don hang ID: %d (Confirmed)\n\nA Shop tech se den gap ban cang som cang tot.\n\nNeu ban co nhieu hon mot don hang thi vui long cho cac shop tech biet nhe.\n\nShop Techs Online: %d\n\nLuu y: Don hang van duoc cho xu ly ngay ca khi ban ngoai tuyen va dang nhap lai.", PlayerInfo[index][pOrder], shoptechs);
				ShowPlayerDialogEx(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");

				format(string, sizeof(string), "Shop order ID %d (Confirmed) from %s (ID: %d) is now pending.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), index);
				ShopTechBroadCast(COLOR_SHOP, string);
			}
			else
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Bay gio ban dang cho nhan duoc don dat hang ID: %d (Invalid)\n\nA Shop tech se den gap ban cang som cang tot.\n\nNeu ban co hon mot don hang hay noi cho ho biet nhe.\n\nShop Techs Online: %d\n\nLuu y: Don hang van xu ly ngay ca khi ban ngoai tuyen va dang nhap lai.", PlayerInfo[index][pOrder], shoptechs);
				ShowPlayerDialogEx(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");

				format(string, sizeof(string), "Shop order ID %d (Invalid) from %s (ID: %d) is now pending.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), index);
				ShopTechBroadCast(COLOR_SHOP, string);
			}
		}
		else
		{
			if(confirmed)
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Ban dang cho de nhan dat hang cua cua hang ID: %d (Confirmed)\n\nA shop tech den gap ban cang som cang tot.\n\nNeu ban co hon mot don hang thi hay noi cho ho biet nhe.\n\nHien tai chua co Shop Tech lam viec, Ban co the tiep tuc choi tro choi binh thuong shop tech se o ben ban khi ho dang nhap lai.\n\nNOTE: Don hang van dang cho xu ly ngay ca khi ban ngoai tuyen va dang nhap lai.", PlayerInfo[index][pOrder]);
				ShowPlayerDialogEx(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");
			}
			else
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}Ban dang cho de nhan  dat hang cua cua hang ID: %d (Invalid)\n\nA shop tech den gap ban cang som cang tot.\n\nNeu ban co hon mot don hang thi hay noi cho ho biet nhe.\n\nHien tai chua co Shop Tech lam viec, Ban co the tiep tuc choi tro choi binh thuong shop tech se o ben ban khi ho dang nhap lai.\n\nNOTE: Don hang van dang cho xu ly ngay ca khi ban ngoai tuyen va dang nhap lai.", PlayerInfo[index][pOrder]);
				ShowPlayerDialogEx(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");
			}
		}
		new playerip[32];
		GetPlayerIp(index, playerip, sizeof(playerip));
		format(string, sizeof(string), "Shop order ID %d from %s(%d)(IP: %s) is now pending.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), GetPlayerSQLId(index), playerip);
		Log("logs/shoporders.log", string);
	}
	else
	{
		PlayerInfo[index][pOrder] = 0;
		PlayerInfo[index][pOrderConfirmed] = 0;
		ShowPlayerDialogEx(index, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order - Server Connection Error", "{FFFFFF}Chung toi khong the xu ly  don hang dat hang cua ban tai thoi diem nay.\n\nVui long thu lai lan sau.", "Close", "");
	}
}

forward TurnOffFlash(playerid);
public TurnOffFlash(playerid)
{
	PlayerTextDrawHide(playerid, _vhudFlash[playerid]);
	return 1;
}

forward ClearDrugs(playerid);
public ClearDrugs(playerid)
{
	UsedWeed[playerid] = 0;
	UsedCrack[playerid] = 0;
	return 1;
}

forward KickEx(playerid);
public KickEx(playerid)
{
	Kick(playerid);
}

forward SetVehicleEngine(vehicleid, playerid);
public SetVehicleEngine(vehicleid, playerid)
{
	new string[128];
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(engine == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Dong co xe da dung lai thanh cong.");
		arr_Engine{vehicleid} = 0;
	}
    else if(engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET)
	{
		new
			Float: f_vHealth;

		GetVehicleHealth(vehicleid, f_vHealth);
		if (GetPVarInt(playerid, "Refueling")) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban khong the lam dieu nay khi dang do xang.");
		if(f_vHealth < 350.0) return SendClientMessageEx(playerid, COLOR_RED, "Xe khong khoi dong duoc - No da bi hong!");
		if(IsRefuelableVehicle(vehicleid) && !IsVIPcar(vehicleid) && !IsAdminSpawnedVehicle(vehicleid) && VehicleFuel[vehicleid] <= 0.0)
		{
			/*if(!PlayerInfo[playerid][pShopNotice])
			{
				PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[7]);
				PlayerTextDrawShow(playerid, MicroNotice[playerid]);
				SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
			}*/
			return SendClientMessageEx(playerid, COLOR_RED, "Xe khong khoi dong duoc - trong xe da het xang!");
		}
		SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && IsAPlane(vehicleid)) { SendClientMessageEx(playerid, COLOR_WHITE, "Dong co xe da khoi dong thanh cong (/announcetakeoff de tat dong co)."); }
		else SendClientMessageEx(playerid, COLOR_WHITE, "Dong co da khoi dong thanh cong (bam ~k~~CONVERSATION_YES~ de tat dong co).");
		arr_Engine{vehicleid} = 1;
		if(GetChased[playerid] != INVALID_PLAYER_ID && VehicleBomb{vehicleid} == 1)
		{
			if(PlayerInfo[playerid][pHeadValue] >= 1)
			{
				if (IsAHitman(playerid))
				{
					new Float:boomx, Float:boomy, Float:boomz;
					GetPlayerPos(playerid,boomx, boomy, boomz);
					CreateExplosion(boomx, boomy , boomz, 7, 1);
					VehicleBomb{vehicleid} = 0;
					PlacedVehicleBomb[GetChased[playerid]] = INVALID_VEHICLE_ID;
					new takemoney = PlayerInfo[playerid][pHeadValue];//(PlayerInfo[playerid][pHeadValue] / 4) * 2;
					GivePlayerCash(GetChased[playerid], floatround(takemoney * 0.9));
					GivePlayerCash(playerid, -takemoney);
					format(string,sizeof(string),"Hitman %s da hoan thanh hop dong %s va nhan duocF $%d.",GetPlayerNameEx(GetChased[playerid]),GetPlayerNameEx(playerid),takemoney);
					foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, string);
					format(string,sizeof(string),"Ban da bi thuong nang boi hitman va bi mat $%d!",takemoney);
					ResetPlayerWeaponsEx(playerid);
					// SpawnPlayer(playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					PlayerInfo[playerid][pHeadValue] = 0;
					PlayerInfo[GetChased[playerid]][pCHits] += 1;
					SetHealth(playerid, 0.0);
					// KillEMSQueue(playerid);
					GoChase[GetChased[playerid]] = INVALID_PLAYER_ID;
					PlayerInfo[GetChased[playerid]][pC4Used] = 0;
					PlayerInfo[GetChased[playerid]][pC4] = 0;
					GotHit[playerid] = 0;
					GetChased[playerid] = INVALID_PLAYER_ID;

					new iHitPercent = floatround(takemoney * 0.10);
					iHMASafe_Val += iHitPercent;
					format(szMiscArray, sizeof szMiscArray, "[hit] %s (%d) da thiet mang %s (%d) [car bomb] for $%s ($%s deposited to safe).", GetPlayerNameEx(GetChased[playerid]), GetPlayerSQLId(GetChased[playerid]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), number_format(takemoney), number_format(iHitPercent));
					Log("logs/hitman.log", szMiscArray);
					return 1;
				}
			}
		}
	}
	return 1;
}

forward SurfingFix(playerid, Float:x, Float:y, Float:z);
public SurfingFix(playerid, Float:x, Float:y, Float:z)
{
	SetPlayerPos(playerid, x, y, z);
	return 1;
}

forward firstaid5(playerid);
public firstaid5(playerid)
{
	if(GetPVarInt(playerid, "usingfirstaid") == 1)
	{
		new Float:health;
		GetHealth(playerid, health);
		if(health < 100.0)
		{
			if((health+5.0) <= 100.0)
			{
 				SetHealth(playerid, health+5.0);
			}
		}
	}
}
forward firstaidexpire(playerid);
public firstaidexpire(playerid)
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "Bo so cuu cua ban da het hieu luc.");
	KillTimer(GetPVarInt(playerid, "firstaid5"));
	SetPVarInt(playerid, "usingfirstaid", 0);
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid)
		{
			SendClientMessageEx(i, COLOR_ORANGE, "Note{ffffff}: Hieu ung so cuu da het han doi voi nguoi bi thuong ban dang kiem tra.");
		}
	}	
}
forward rccam(playerid);
public rccam(playerid)
{
	DestroyVehicle(GetPVarInt(playerid, "rcveh"));
 	SetPlayerPos(playerid, GetPVarFloat(playerid, "rcX"), GetPVarFloat(playerid, "rcY"), GetPVarFloat(playerid, "rcZ"));
  	SendClientMessageEx(playerid, COLOR_GRAD1, "RC CAM cua ban da het pin!");
   	SetPVarInt(playerid, "rccam", 0);
}
forward cameraexpire(playerid);
public cameraexpire(playerid)
{
	SetPVarInt(playerid, "cameraactive", 0);
 	SetCameraBehindPlayer(playerid);
 	if(GetPVarInt(playerid, "camerasc") == 1)
 	{
	 	SetPlayerPos(playerid, GetPVarFloat(playerid, "cameraX2"), GetPVarFloat(playerid, "cameraY2"), GetPVarFloat(playerid, "cameraZ2"));
	  	SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "cameravw2"));
	  	SetPlayerInterior(playerid, GetPVarInt(playerid, "cameraint2"));
	}
 	TogglePlayerControllable(playerid,1);
  	DestroyDynamic3DTextLabel(Camera3D[playerid]);
   	SendClientMessageEx(playerid, COLOR_GRAD1, "May anh cua ban da het pin!");
}

forward split(const strsrc[], strdest[][], delimiter);
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

forward KickNonRP(playerid);
public KickNonRP(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPVarString(playerid, "KickNonRP", name, sizeof(name));
	if(strcmp(GetPlayerNameEx(playerid), name) == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Ban da bi kick vi dat ten sai quy dinh (v.d. Huy_Tran).");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
	}
}

timer RotateWheel[1000 * 3]()
{
    UpdateWheelTarget();

    new Float:fModifyWheelZPos = 0.0;
    if(gWheelTransAlternate) fModifyWheelZPos = 0.05;

    MoveObject( gFerrisWheel, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2]+fModifyWheelZPos,
				0.01, 0.0, gCurrentTargetYAngle, -270.0 );
}

forward OtherTimerEx(playerid, type);
public OtherTimerEx(playerid, type)
{
	switch(type) {
		case TYPE_TPMATRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpMatRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpMatRunTimer", GetPVarInt(playerid, "tpMatRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPMATRUNTIMER);
			}
		}
		case TYPE_TPDRUGRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpDrugRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpDrugRunTimer", GetPVarInt(playerid, "tpDrugRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPDRUGRUNTIMER);
			}
		}
		case TYPE_TPTRUCKRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpTruckRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpTruckRunTimer", GetPVarInt(playerid, "tpTruckRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
			}
		}
		case TYPE_ARMSTIMER:
		{
			if(GetPVarInt(playerid, "ArmsTimer") > 0)
			{
				SetPVarInt(playerid, "ArmsTimer", GetPVarInt(playerid, "ArmsTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_ARMSTIMER);
			}
		}
		case TYPE_GUARDTIMER:
		{
			if(GetPVarInt(playerid, "GuardTimer") > 0)
			{
				SetPVarInt(playerid, "GuardTimer", GetPVarInt(playerid, "GuardTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GUARDTIMER);
			}
		}
		case TYPE_GIVEWEAPONTIMER:
		{
			if(GetPVarInt(playerid, "GiveWeaponTimer") > 0)
			{
				SetPVarInt(playerid, "GiveWeaponTimer", GetPVarInt(playerid, "GiveWeaponTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		case TYPE_SHOPORDERTIMER:
		{
			if(GetPVarInt(playerid, "ShopOrderTimer") > 0)
			{
				SetPVarInt(playerid, "ShopOrderTimer", GetPVarInt(playerid, "ShopOrderTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SHOPORDERTIMER);
			}
		}
		case TYPE_SELLMATSTIMER:
		{
			if(GetPVarInt(playerid, "SellMatsTimer") > 0)
			{
				SetPVarInt(playerid, "SellMatsTimer", GetPVarInt(playerid, "SellMatsTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SELLMATSTIMER);
			}
		}
		case TYPE_HOSPITALTIMER:
		{
			if(GetPVarInt(playerid, "HospitalTimer") > 0)
			{
				new Float:curhealth;
				GetHealth(playerid, curhealth);
				SetPVarInt(playerid, "HospitalTimer", GetPVarInt(playerid, "HospitalTimer")-1);
				SetHealth(playerid, curhealth+1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HOSPITALTIMER);
				if(GetPVarInt(playerid, "HospitalTimer") == 0)
				{
					//HospitalSpawn(playerid);
				}
			}
		}
		case TYPE_FLOODPROTECTION:
		{
			if( CommandSpamUnmute[playerid] >= 1)
			{
				CommandSpamUnmute[playerid]--;
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			}
			if( TextSpamUnmute[playerid] >= 1)
			{
				TextSpamUnmute[playerid]--;
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			}
		}
		case TYPE_HEALTIMER:
		{
			if( GetPVarInt(playerid, "TriageTimer") >= 1)
			{
				SetPVarInt(playerid, "TriageTimer", GetPVarInt(playerid, "TriageTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HEALTIMER);
			}
		}
		case TYPE_TPPIZZARUNTIMER:
		{
			if(GetPVarInt(playerid, "tpPizzaTimer") > 0 && GetPVarInt(playerid, "Pizza"))
			{
				SetPVarInt(playerid, "tpPizzaTimer", GetPVarInt(playerid, "tpPizzaTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPPIZZARUNTIMER);
			}
		}
		case TYPE_PIZZATIMER:
		{
			if(GetPVarType(playerid, "pizzaTimer") && GetPVarInt(playerid, "pizzaTimer") == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Ban da that bai trong viec giao pizza qua tre, nguoi mua da huy don , go /map neu ban khong biet duong ve lai pizza!");
				DeletePVar(playerid, "Pizza");
				DeletePVar(playerid, "pizzaTimer");
				DisablePlayerCheckpoint(playerid);
			}
			else if (GetPVarInt(playerid, "Pizza") == 0)
			{
				DeletePVar(playerid, "Pizza");
				DeletePVar(playerid, "pizzaTimer");
				DisablePlayerCheckpoint(playerid);
			}
			else if(GetPVarInt(playerid, "pizzaTimer") > 0 && GetPVarInt(playerid, "Pizza") > 0) {

				new houseid = GetPVarInt(playerid, "Pizza");
				SetPlayerCheckpoint(playerid, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ], 5); // Temporary fix.
				SetPVarInt(playerid, "pizzaTimer", GetPVarInt(playerid, "pizzaTimer")-1);
				new string[128];
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d giay con lai", GetPVarInt(playerid, "pizzaTimer"));
				GameTextForPlayer(playerid, string, 1100, 3);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_PIZZATIMER);
			}
		}
		case TYPE_CRATETIMER:
		{
			if(GetPVarInt(playerid, "tpForkliftTimer") > 0)
			{
			    if(IsPlayerInVehicle(playerid, GetPVarInt(playerid, "tpForkliftID")))
			    {
				    new Float: pX = GetPVarFloat(playerid, "tpForkliftX"), Float: pY = GetPVarFloat(playerid, "tpForkliftY"), Float: pZ = GetPVarFloat(playerid, "tpForkliftZ");
				    if(GetPlayerDistanceFromPoint(playerid, pX, pY, pZ) > 500)
				    {
				        if(GetPVarInt(playerid, "tpJustEntered") == 0)
				        {
				        	new string[128];
							format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s may be TP hacking with a crate/forklift.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, string, 2);
							SetPVarInt(playerid, "tpForkliftTimer", GetPVarInt(playerid, "tpForkliftTimer")+15);
						}
						else
						{
						    DeletePVar(playerid, "tpJustEntered");
						}
				    }
					GetPlayerPos(playerid, pX, pY, pZ);
					SetPVarFloat(playerid, "tpForkliftX", pX);
			 		SetPVarFloat(playerid, "tpForkliftY", pY);
			  		SetPVarFloat(playerid, "tpForkliftZ", pZ);
					SetPVarInt(playerid, "tpForkliftTimer", GetPVarInt(playerid, "tpForkliftTimer")-1);
					SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_CRATETIMER);
					if(GetPVarInt(playerid, "tpForkliftTimer") == 0)
					{
					    DeletePVar(playerid, "tpForkliftTimer");
					    DeletePVar(playerid, "tpForkliftID");
					    DeletePVar(playerid, "tpForkliftX");
					    DeletePVar(playerid, "tpForkliftY");
					    DeletePVar(playerid, "tpForkliftZ");
					}
				}
				else
				{
				    DeletePVar(playerid, "tpForkliftTimer");
				    DeletePVar(playerid, "tpForkliftID");
				    DeletePVar(playerid, "tpForkliftX");
				    DeletePVar(playerid, "tpForkliftY");
				    DeletePVar(playerid, "tpForkliftZ");
				}
			}
		}
		case TYPE_DELIVERVEHICLE: 
		{
			if(GetPVarType(playerid, "tpDeliverVehTimer") > 0 && GetPVarType(playerid, "DeliveringVehicleTime") > 0)
			{
				new Float: pX = GetPVarFloat(playerid, "tpDeliverVehX"), Float: pY = GetPVarFloat(playerid, "tpDeliverVehY"), Float: pZ = GetPVarFloat(playerid, "tpDeliverVehZ");
				if(GetPlayerDistanceFromPoint(playerid, pX, pY, pZ) > 500)
				{
					if(GetPVarType(playerid, "tpJustEntered") == 0)
					{
						new string[128];
						format(string, sizeof(string), "{AA3333}GTN-Warning{FFFF00}: %s(%d) may be TP hacking while delivering a lock picked vehicle.", GetPlayerNameEx(playerid), playerid);
						ABroadCast(COLOR_YELLOW, string, 2);
						SetPVarInt(playerid, "tpDeliverVehTimer", GetPVarInt(playerid, "tpDeliverVehTimer")+15);
					}
					else
					{
						DeletePVar(playerid, "tpJustEntered");
					}
				}
				GetPlayerPos(playerid, pX, pY, pZ);
				SetPVarFloat(playerid, "tpDeliverVehX", pX);
				SetPVarFloat(playerid, "tpDeliverVehY", pY);
				SetPVarFloat(playerid, "tpDeliverVehZ", pZ);
				SetPVarInt(playerid, "tpDeliverVehTimer", GetPVarInt(playerid, "tpDeliverVehTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_DELIVERVEHICLE);
				if(GetPVarInt(playerid, "tpDeliverVehTimer") == 0)
				{
					DeletePVar(playerid, "tpDeliverVehTimer");
					DeletePVar(playerid, "tpDeliverVehX");
					DeletePVar(playerid, "tpDeliverVehY");
					DeletePVar(playerid, "tpDeliverVehZ");
				}
			}
			else
			{
				DeletePVar(playerid, "tpDeliverVehTimer");
				DeletePVar(playerid, "tpDeliverVehX");
				DeletePVar(playerid, "tpDeliverVehY");
				DeletePVar(playerid, "tpDeliverVehZ");
			}
		}
	}
}

forward Disconnect(playerid);
public Disconnect(playerid)
{
	new string[24];
    GetPlayerIp(playerid, unbanip[playerid], 16);
    format(string, sizeof(string),"banip %s", unbanip[playerid]);
	SendRconCommand(string);
	Kick(playerid);
	return 1;
}

forward GetColorCode(clr[]);
public GetColorCode(clr[])
{
	new color = -1;

	if (IsNumeric(clr)) {
		color = strval(clr);
		return color;
	}

	if(strcmp(clr, "black", true)==0) color=0;
	if(strcmp(clr, "white", true)==0) color=1;
	if(strcmp(clr, "blue", true)==0) color=2;
	if(strcmp(clr, "red", true)==0) color=3;
	if(strcmp(clr, "green", true)==0) color=16;
	if(strcmp(clr, "purple", true)==0) color=5;
	if(strcmp(clr, "yellow", true)==0) color=6;
	if(strcmp(clr, "lightblue", true)==0) color=7;
	if(strcmp(clr, "navy", true)==0) color=94;
	if(strcmp(clr, "beige", true)==0) color=102;
	if(strcmp(clr, "darkgreen", true)==0) color=51;
	if(strcmp(clr, "darkblue", true)==0) color=103;
	if(strcmp(clr, "darkgrey", true)==0) color=13;
	if(strcmp(clr, "gold", true)==0) color=99;
	if(strcmp(clr, "brown", true)==0 || strcmp(clr, "dennell", true)==0) color=55;
	if(strcmp(clr, "darkbrown", true)==0) color=84;
	if(strcmp(clr, "darkred", true)==0) color=74;
	if(strcmp(clr, "maroon", true)==0) color=115;
	if(strcmp(clr, "pink", true)==0) color=126;
	return color;
}

forward HelpTimer(playerid);
public HelpTimer(playerid)
{
	if(GetPVarInt(playerid, "HelpTime") > 0)
 	{
  		SetPVarInt(playerid, "HelpTime", GetPVarInt(playerid, "HelpTime")-1);
    	if(GetPVarInt(playerid, "HelpTime") == 0)
     	{
      		SendClientMessageEx(playerid, COLOR_GREY, "Yeu cau tro giup cua ban da het han, ban nen tim su tro giup tu dien dan ");
        	DeletePVar(playerid, "COMMUNITY_ADVISOR_REQUEST");
         	return 1;
        }
		SetTimerEx("HelpTimer", 60000, 0, "d", playerid);
	}
	return 1;
}

forward DrinkCooldown(playerid);
public DrinkCooldown(playerid)
{
	SetPVarInt(playerid, "DrinkCooledDown", 1);
	return 1;
}

forward RadarCooldown(playerid);
public RadarCooldown(playerid)
{
   DeletePVar(playerid, "RadarTimeout");
   return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{	
	new vehicleid = GetPlayerVehicleID(playerid);
	for(new iGroup; iGroup < MAX_GROUPS; iGroup++)
	{
		for(new x = 0; x < MAX_SPIKES; ++x)
		{
			if(SpikeStrips[iGroup][x][sX] != 0 && pickupid == SpikeStrips[iGroup][x][sPickupID])
			{
				DestroyDynamicPickup(SpikeStrips[iGroup][x][sPickupID]);
				SpikeStrips[iGroup][x][sPickupID] = CreateDynamicPickup(19300, 14, SpikeStrips[iGroup][x][sX], SpikeStrips[iGroup][x][sY], SpikeStrips[iGroup][x][sZ]);
				if(GetVehicleDistanceFromPoint(vehicleid, SpikeStrips[iGroup][x][sX], SpikeStrips[iGroup][x][sY], SpikeStrips[iGroup][x][sZ]) <= 6.0) 
				{
					new Float:pos[4];
					GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
					GetVehicleZAngle(vehicleid, pos[3]);
					// TODO: This should be more specific to the vehicle
					// TODO: Bike tires should be checked differently

					if(GetDistanceBetweenPoints(pos[0], pos[1], pos[2], SpikeStrips[iGroup][x][sX], SpikeStrips[iGroup][x][sY], SpikeStrips[iGroup][x][sZ]) <= 4)
					{
							// Pop Front
						SetVehicleTireState(vehicleid, 0, 0, 0, 0);
					}
				}
			}	
		}
	}
	if (GetPVarInt(playerid, "_BikeParkourStage") > 0)
	{
		new stage = GetPVarInt(playerid, "_BikeParkourStage");
		new slot = GetPVarInt(playerid, "_BikeParkourSlot");
		new bikePickup = GetPVarInt(playerid, "_BikeParkourPickup");
		new business = InBusiness(playerid);

		if (pickupid != bikePickup)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "Day khong phai xe cua ban!");
			return 1;
		}

		if (stage > 1 && !IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban phai di xe dap de tiep tuc!");
			return 1;
		}

		switch (GetPVarInt(playerid, "_BikeParkourStage"))
		{
			case 1:
			{
				DestroyDynamicPickup(bikePickup);

				new Float:pos[4];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);

				new vehicleId = CreateVehicle(481, pos[0], pos[1], pos[2], pos[3], 0, 0, 0);
				SetVehicleVirtualWorld(vehicleId, GetPlayerVirtualWorld(playerid));
				LinkVehicleToInterior(vehicleId, GetPlayerInterior(playerid));
				Businesses[business][bGymBikeVehicles][slot] = vehicleId;

				SendClientMessageEx(playerid, COLOR_WHITE, "Theo cac mui ten da chon de hoan thanh.");
				//SendClientMessageEx(playerid, COLOR_WHITE, "Nhap /leaveparkour de thoat khoi hoat dong ma khong hoan thanh no.");

				bikePickup = CreateDynamicPickup(1318, 14, 2823.5071, -2260.9243, 97.5347, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 2);
			}

			case 2:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2821.0806, -2254.6775, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 3);
			}

			case 3:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2817.6206, -2246.4187, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 4);
			}

			case 4:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2813.2246, -2235.4602, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 5);
			}

			case 5:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2817.3789, -2228.5271, 98.6919, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 6);
			}

			case 6:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2823.3210, -2232.0654, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 7);
			}

			case 7:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2828.3071, -2231.8882, 99.2544, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 8);
			}

			case 8:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2831.8652, -2235.8438, 99.8750, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 9);
			}

			case 9:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2832.3789, -2243.1646, 98.8604, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 10);
			}

			case 10:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2830.2227, -2247.3076, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 11);
			}

			case 11:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2830.8708, -2251.3501, 99.7329, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 12);
			}

			case 12:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2840.0076, -2252.7549, 99.7329, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 13);
			}

			case 13:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2858.3438, -2252.1355, 99.2871, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 14);
			}

			case 14:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2857.1311, -2239.4653, 99.2373, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 15);
			}

			case 15:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2852.6345, -2239.1692, 98.6665, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 16);
			}

			case 16:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2846.7661, -2226.1548, 98.8716, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 17);
			}

			case 17:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2838.6113, -2228.2808, 98.7231, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 18);
			}

			case 18:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2837.6887, -2219.9446, 100.5010, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 19);
			}

			case 19:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2833.5979, -2215.8831, 100.4380, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 20);
			}

			case 20:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2825.3645, -2220.9446, 100.4761, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 21);
			}

			case 21:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2818.7837, -2223.2014, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 22);
			}

			case 22:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2823.7703, -2224.3865, 98.9653, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 23);
			}

			case 23:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2836.5769, -2232.2056, 96.0278, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 24);
			}

			case 24:
			{
				DestroyDynamicPickup(bikePickup);

				new vehicle = Businesses[business][bGymBikeVehicles][slot];
				DestroyVehicle(vehicle);

				Businesses[business][bGymBikePlayers][slot] = INVALID_PLAYER_ID;
				Businesses[business][bGymBikeVehicles][slot] = INVALID_VEHICLE_ID;

				SendClientMessageEx(playerid, COLOR_WHITE, "Track finished.");

				DeletePVar(playerid, "_BikeParkourStage");
				DeletePVar(playerid, "_BikeParkourSlot");
				DeletePVar(playerid, "_BikeParkourPickup");

				if(PlayerInfo[playerid][mCooldown][4]) PlayerInfo[playerid][pFitness] += 23;
				else PlayerInfo[playerid][pFitness] += 15;

				if (PlayerInfo[playerid][pFitness] > 100)
					PlayerInfo[playerid][pFitness] = 100;
			}
		}
	}
	return 1;
}

forward DisableCheckPoint(playerid);
public DisableCheckPoint(playerid)
{
    return DisablePlayerCheckpoint(playerid);
}

forward AttachGasTrailer(trailerid,vehicleid);
public AttachGasTrailer(trailerid,vehicleid)
{
	return AttachTrailerToVehicle(trailerid, vehicleid);
}


forward UpdateCarRadars();
public UpdateCarRadars()
{
	foreach(new p : Player)
	{
		if (!IsPlayerInAnyVehicle(p) || CarRadars[p] == 0) continue;

		new target = -1;
		new Float:tempDist = 50.0;

		if(CarRadars[p] == 1)
		{
			foreach(new t : Player)
			{
				if (!IsPlayerInAnyVehicle(t) || t == p || IsPlayerInVehicle(t, GetPlayerVehicleID(p))) continue;

				new Float:distance = GetDistanceBetweenPlayers(p, t);

				if (distance < tempDist)
				{
					target = t;
					tempDist = distance;
				}
			}	
			
			if (target == -1)
			{
				// no target was found
				PlayerTextDrawSetString(p, _crTextTarget[p], "Target Vehicle: ~r~N/A");
				PlayerTextDrawSetString(p, _crTextSpeed[p], "Speed: ~r~N/A");
				PlayerTextDrawSetString(p, _crTickets[p], "Tickets: ~r~N/A");
			}
			else
			{	
				new targetVehicle = GetPlayerVehicleID(target), cveh;
				if(GetVehicleModel(targetVehicle))
				{
					new Float: speed = player_get_speed(target);

					new str[60];

					format(str, sizeof(str), "Target Vehicle: ~r~%s (%i)", GetVehicleName(targetVehicle), targetVehicle);
					PlayerTextDrawSetString(p, _crTextTarget[p], str);
					format(str, sizeof(str), "Speed: ~r~%d MPH", floatround(speed, floatround_round));
					PlayerTextDrawSetString(p, _crTextSpeed[p], str);
					foreach(new i : Player)
					{
						new veh = GetPlayerVehicle(i, targetVehicle);
						if (veh != -1 && PlayerVehicleInfo[i][veh][pvTicket] > 0)
						{
							format(str, sizeof(str), "Tickets: ~r~$%s", number_format(PlayerVehicleInfo[i][veh][pvTicket]));
							PlayerTextDrawSetString(p, _crTickets[p], str);
							if (gettime() >= (GetPVarInt(p, "_lastTicketWarning") + 10))
							{
								SetPVarInt(p, "_lastTicketWarning", gettime());
								PlayerPlaySound(p, 4202, 0.0, 0.0, 0.0);
							}
						}
					}
					if((cveh = IsDynamicCrateVehicle(targetVehicle)) != -1) {
						if(ValidGroup(CrateVehicle[cveh][cvGroupID]) && CrateVehicle[cveh][cvTickets] > 0) {
							format(str, sizeof(str), "Tickets: ~r~$%s", number_format(CrateVehicle[cveh][cvTickets]));
							PlayerTextDrawSetString(p, _crTickets[p], str);
							if (gettime() >= (GetPVarInt(p, "_lastTicketWarning") + 10))
							{
								SetPVarInt(p, "_lastTicketWarning", gettime());
								PlayerPlaySound(p, 4202, 0.0, 0.0, 0.0);
							}
						}
					}
				}
			}
		}
	}
}
			
			/*  ---------------- STOCK FUNCTIONS ----------------- */
stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {
    return floatsqroot(floatpower(x1 - x2, 2) + floatpower(y1 - y2, 2) + floatpower(z1 - z2, 2));
}

stock BubbleSort(a[], size)
{
	new tmp=0, bool:swapped;

	do
	{
		swapped = false;
		for(new i=1; i < size; i++) {
			if(a[i-1] > a[i]) {
				tmp = a[i];
				a[i] = a[i-1];
				a[i-1] = tmp;
				swapped = true;
			}
		}
	} while(swapped);
}

stock ShowNoticeGUIFrame(playerid, frame)
{
	HideNoticeGUIFrame(playerid);

	TextDrawShowForPlayer(playerid, NoticeTxtdraw[0]);
	TextDrawShowForPlayer(playerid, NoticeTxtdraw[1]);

	switch(frame)
	{
		case 1: // Looking up account
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[2]);
		}
		case 2: // Fetching & Comparing Password
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[3]);
		}
		case 3: // Fetching & Loading Account
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[4]);
		}
		case 4: // Streaming Objects
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[5]);
		}
		case 5: // Login Queue
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[6]);
		}
		case 6: // General loading
		{
		    TextDrawShowForPlayer(playerid, NoticeTxtdraw[7]);
		}
	}
}

stock HideNoticeGUIFrame(playerid)
{
	for(new i = 0; i < 8; i++)
	{
		TextDrawHideForPlayer(playerid, NoticeTxtdraw[i]);
	}
}

stock BadFloat(Float:x)
{
	if(x >= 10.0 || x <= -10.0)
	    return true;

	return false;
}

stock SendBugMessage(playerid, member, string[])
{
    if(!(0 <= member < MAX_GROUPS))
        return 0;

	new iGroupID;
	foreach(new i: Player)
	{
		iGroupID = PlayerInfo[i][pMember];
		if(iGroupID == member && PlayerInfo[i][pRank] >= arrGroupData[iGroupID][g_iBugAccess] && gBug{i} == 1)	{

			if(playerid != i) ChatTrafficProcess(i, COLOR_LIGHTGREEN, string, 13);				
		}
	}	
	return 1;
}

/*stock ReplacePH(oldph, newph)
{
    #pragma unused oldph
    #pragma unused newph
    new File: file2 = fopen("tmpPHList.cfg", io_write);
    new number;
    new string[32];
    new PHList[32];
    format(string, sizeof(string), "%d\r\n", newph);
    fwrite(file2, string);
    fclose(file2);
    file2 = fopen("tmpPHList.cfg", io_append);
    if(fexist("PHList.cfg"))
	{
		new File: file = fopen("PHList.cfg", io_read);
	    while(fread(file, string))
		{
	        strmid(PHList, string, 0, strlen(string)-1, 255);
	        number = strval(PHList);
	    	if (number != oldph)
			{
	            format(string, sizeof(string), "%d\r\n", number);
	        	fwrite(file2, string);
	    	}
	    }
	    fclose(file);
	    fclose(file2);
	    file2 = fopen("PHList.cfg", io_write);
	    file = fopen("tmpPHList.cfg", io_read);
		while(fread(file, string))
		{
	        strmid(PHList, string, 0, strlen(string)-1, 255);
	        number = strval(PHList);
	        if (number != oldph)
			{
	            format(string, sizeof(string), "%d\r\n", number);
	        	fwrite(file2, string);
	    	}
	    }
	    fclose(file);
	    fclose(file2);
		fremove("tmpPHList.cfg");
	}
	return 1;
}*/

stock IsValidIP(ip[])
{
    new a;
	for (new i = 0; i < strlen(ip); i++)
	{
		if (ip[i] == '.')
		{
		    a++;
		}
	}
	if (a != 3)
	{
	    return 1;
	}
	return 0;
}

stock GetPlayersName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock IsValidSkin(skinid)
{
	if (skinid < 0 || skinid > 299)
	    return 0;

	switch (skinid)
	{
	    case 71, 265, 266, 267, 269, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288: return 0;
	}

	return 1;
}

stock IsFemaleSpawnSkin(skinid)
{
	switch (skinid)
	{
	    case
		9, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54,
		55, 56, 65, 76, 77, 89, 91, 93, 129, 130,
		131, 141, 148, 150, 151, 157, 169, 172, 190,
		191, 192, 193, 194, 195, 196, 197, 198, 199,
		211, 214, 215, 216, 218, 219, 224, 225, 226,
		231, 232, 233, 263, 298: return 1;
	}

	return 0;
}

stock IsFemaleSkin(skinid)
{
	switch (skinid)
	{
	    case
		9, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55,
		56, 63, 64, 65, 75, 76, 77, 85, 87, 88, 89, 90,
		91, 92, 93, 129, 130, 131, 138, 139, 140, 141,
		145, 148, 150, 151, 152, 157, 169, 172, 178, 190,
		191, 192, 193, 194, 195, 196, 197, 198, 199, 201,
		205, 207, 211, 214, 215, 216, 218, 219, 224, 225,
		226, 231, 232, 233, 237, 238, 243, 244, 245, 246,
		251, 256, 257, 263, 298: return 1;
	}

	return 0;
}

stock PlayerFacePlayer( playerid, targetplayerid )
{
	new Float: Angle;
	GetPlayerFacingAngle( playerid, Angle );
	SetPlayerFacingAngle( targetplayerid, Angle+180 );
	return true;
}

stock GivePlayerEventWeapons( playerid )
{
	if( GetPVarInt( playerid, "EventToken" ) == 1 )
	{
		GivePlayerValidWeapon( playerid, EventKernel[ EventWeapons ][ 0 ] );
		GivePlayerValidWeapon( playerid, EventKernel[ EventWeapons ][ 1 ] );
		GivePlayerValidWeapon( playerid, EventKernel[ EventWeapons ][ 2 ] );
		GivePlayerValidWeapon( playerid, EventKernel[ EventWeapons ][ 3 ] );
		GivePlayerValidWeapon( playerid, EventKernel[ EventWeapons ][ 4 ] );
	}

	return 1;
}

stock crc32(string[])
{
	new crc_table[256] = {
			0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535,
			0x9E6495A3, 0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD,
			0xE7B82D07, 0x90BF1D91, 0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D,
			0x6DDDE4EB, 0xF4D4B551, 0x83D385C7, 0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC,
			0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5, 0x3B6E20C8, 0x4C69105E, 0xD56041E4,
			0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B, 0x35B5A8FA, 0x42B2986C,
			0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59, 0x26D930AC,
			0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
			0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB,
			0xB6662D3D, 0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F,
			0x9FBFE4A5, 0xE8B8D433, 0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB,
			0x086D3D2D, 0x91646C97, 0xE6635C01, 0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E,
			0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457, 0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA,
			0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65, 0x4DB26158, 0x3AB551CE,
			0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB, 0x4369E96A,
			0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9,
			0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409,
			0xCE61E49F, 0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81,
			0xB7BD5C3B, 0xC0BA6CAD, 0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739,
			0x9DD277AF, 0x04DB2615, 0x73DC1683, 0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8,
			0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1, 0xF00F9344, 0x8708A3D2, 0x1E01F268,
			0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7, 0xFED41B76, 0x89D32BE0,
			0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5, 0xD6D6A3E8,
			0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
			0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF,
			0x4669BE79, 0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703,
			0x220216B9, 0x5505262F, 0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7,
			0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D, 0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A,
			0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713, 0x95BF4A82, 0xE2B87A14, 0x7BB12BAE,
			0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21, 0x86D3D2D4, 0xF1D4E242,
			0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777, 0x88085AE6,
			0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45,
			0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D,
			0x3E6E77DB, 0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5,
			0x47B2CF7F, 0x30B5FFE9, 0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605,
			0xCDD70693, 0x54DE5729, 0x23D967BF, 0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94,
			0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D
	};
	new crc = -1;
	for(new i = 0; i < strlen(string); i++)
	{
 		crc = ( crc >>> 8 ) ^ crc_table[(crc ^ string[i]) & 0xFF];
  	}
  	return crc ^ -1;
}

stock GetPlayerSQLId(playerid)
{
	if(gPlayerLogged{playerid})
	{
		return PlayerInfo[playerid][pId];
	}
	return -1;
}

stock GetPlayerNameExt(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock GetWeaponNameEx(weaponid)
{
	new name[MAX_PLAYER_NAME];
	GetWeaponName(weaponid, name, sizeof(name));
	return name;
}

stock GetPlayerNameEx(playerid) {

	new
		szName[MAX_PLAYER_NAME],
		iPos;

	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	while ((iPos = strfind(szName, "_", false, iPos)) != -1) szName[iPos] = ' ';
	return szName;
}

stock StripUnderscore(string[]) // Doesn't remove underscore from original string any more
{
	new iPos, newstring[128];
	format(newstring, sizeof(newstring), "%s", string);
	while ((iPos = strfind(newstring, "_", false, iPos)) != -1) newstring[iPos] = ' ';
	return newstring;
}


stock GetPlayerIpEx(playerid)
{
    new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

stock StripNewLine(string[])
{
  new len = strlen(string);
  if (string[0]==0) return ;
  if ((string[len - 1] == '\n') || (string[len - 1] == '\r'))
    {
      string[len - 1] = 0;
      if (string[0]==0) return ;
      if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
    }
}

stock StripColorEmbedding(string[])
{
 	new i, tmp[7];
  	while (i < strlen(string) - 7)
	{
	    if (string[i] == '{' && string[i + 7] == '}')
		{
		    strmid(tmp, string, i + 1, i + 7);
			if (ishex(tmp))
			{
				strdel(string, i, i + 8);
				i = 0;
				continue;
			}
		}
		i++;
  	}
}

stock strtoupper(string[])
{
        new retStr[128], i, j;
        while ((j = string[i])) retStr[i++] = chrtoupper(j);
        retStr[i] = '\0';
        return retStr;
}

stock wordwrap(string[], width, seperator[] = "\n", dest[], size = sizeof(dest))
{
    if (dest[0])
    {
        dest[0] = '\0';
    }
    new
        length,
        multiple,
        processed,
        tmp[192];

    strmid(tmp, string, 0, width);
    length = strlen(string);

    if (width > length || !width)
    {
        memcpy(dest, string, _, size * 4, size);
        return 0;
    }
    for (new i = 1; i < length; i ++)
    {
        if (tmp[0] == ' ')
        {
            strdel(tmp, 0, 1);
        }
        multiple = !(i % width);
        if (multiple)
        {
            strcat(dest, tmp, size);
            strcat(dest, seperator, size);
            strmid(tmp, string, i, width + i);
            if (strlen(tmp) < width)
            {
                strmid(tmp, string, (width * processed) + width, length);
                if (tmp[0] == ' ')
                {
                    strdel(tmp, 0, 1);
                }
                strcat(dest, tmp, size);
                break;
            }
            processed++;
            continue;
        }
        else if (i == length - 1)
        {
            strmid(tmp, string, (width * processed), length);
            strcat(dest, tmp, size);
            break;
        }
    }
    return 1;
}

stock fcreate(filename[])
{
	if (fexist(filename)) return false;
	new File:fhnd;
	fhnd=fopen(filename,io_write);
	if (fhnd) {
		fclose(fhnd);
		return true;
	}
	return false;
}

stock IsAtBar(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,3.0,495.7801,-76.0305,998.7578) || IsPlayerInRangeOfPoint(playerid,3.0,499.9654,-20.2515,1000.6797) || IsPlayerInRangeOfPoint(playerid,9.0,1497.5735,-1811.6150,825.3397))
		{//In grove street bar (with girlfriend), and in Havanna
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,4.0,1215.9480,-13.3519,1000.9219) || IsPlayerInRangeOfPoint(playerid,10.0,-2658.9749,1407.4136,906.2734) || IsPlayerInRangeOfPoint(playerid,10.0,2155.3367,-97.3984,3.8308))
		{//PIG Pen
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1131.3655,-1641.2759,18.6054) || IsPlayerInRangeOfPoint(playerid,10.0,-2676.4509,1540.6925,900.8359))
		{//Families 8 & SaC
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,2492.5532,-1698.2817,1715.5508) || IsPlayerInRangeOfPoint(playerid,5.0,2462.8247,-1649.5435,1732.0295) || IsPlayerInRangeOfPoint(playerid,5.0,2498.9863,-1666.6274,1738.3696))
		{
		    //Custom House
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,878.6188,1431.0234,-82.3449) || IsPlayerInRangeOfPoint(playerid,5.0,918.7236,1421.3997,-81.1839))
		{
		    //VIP
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,2574.3931,-1682.1548,1030.0206))
		{
			//The Cove
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1266.14,-1073.00,1082.92))
		{
			//The Cove
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1886.993652, -734.707275, 3380.847656))
		{
			//Syndicate HQ Bar
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,300.4993, 203.9201, 1104.3500))
		{
			//SHIELD HQ Bar
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,252.205978, -54.826644, 1.577644))
		{
			//Red County Liquor Store
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,453.2437,-105.4000,999.5500) || IsPlayerInRangeOfPoint(playerid,10.0,1255.69, -791.76, 1085.38) ||
		IsPlayerInRangeOfPoint(playerid,10.0,2561.94, -1296.44, 1062.04) || IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) ||
		IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) || IsPlayerInRangeOfPoint(playerid, 10.0, 880.06, 1430.86, -82.34) ||
		IsPlayerInRangeOfPoint(playerid,10.0,499.96, -20.66, 1000.68) || IsPlayerInRangeOfPoint(playerid,10.0,3282, -635, 8424))
		{
			//Bars
			return 1;
		}
	}
	return 0;
}

stock Group_NumToDialogHex(iValue)
{
	new szValue[7];
	format(szValue, sizeof(szValue), "%x", iValue);
	new i, padlength = 6 - strlen(szValue);
	while (i++ != padlength) {
		strins(szValue, "0", 0, 7);
	}
	return szValue;
}

stock FIXES_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}

stock GetClosestPlayer(p1)
{
	new Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	foreach(new x: Player)
	{
		if(x != p1)
		{
			dis2 = GetDistanceBetweenPlayers(x,p1);
			if(dis2 < dis && dis2 != -1.00)
			{
				dis = dis2;
				player = x;
			}
		}
	}	
	return player;
}

stock Float: FormatFloat(Float:number) {
    if(number != number) return 0.0;
    else return number;
}

stock OnPlayerStatsUpdate(playerid) {
	if(gPlayerLogged{playerid}) {
		if(!GetPVarType(playerid, "TempName") && !GetPVarInt(playerid, "EventToken") && !GetPVarType(playerid, "IsInArena")) {
		    new Float: Pos[4], Float: Health[2];
			GetHealth(playerid, Health[0]);
			GetArmour(playerid, Health[1]);

			PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
			PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(playerid);

			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			PlayerInfo[playerid][pHealth] = FormatFloat(Health[0]);
			PlayerInfo[playerid][pArmor] = FormatFloat(Health[1]);
		    if(IsPlayerInRangeOfPoint(playerid, 1200, -1083.90002441,4289.70019531,7.59999990) && PlayerInfo[playerid][pMember] == INVALID_GROUP_ID)
			{
				PlayerInfo[playerid][pInt] = 0;
				PlayerInfo[playerid][pVW] = 0;
				GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
				PlayerInfo[playerid][pPos_x] = 1529.6;
				PlayerInfo[playerid][pPos_y] = -1691.2;
				PlayerInfo[playerid][pPos_z] = 13.3;
			}
			else if(GetPVarInt(playerid, "ShopTP") == 1 && GetPVarFloat(playerid, "tmpX") != 0)
			{
				PlayerInfo[playerid][pPos_x] = GetPVarFloat(playerid, "tmpX");
				PlayerInfo[playerid][pPos_y] = GetPVarFloat(playerid, "tmpY");
				PlayerInfo[playerid][pPos_z] = GetPVarFloat(playerid, "tmpZ");
				PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "tmpInt");
				PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "tmpVW");
			}
			else
			{
				PlayerInfo[playerid][pPos_x] = FormatFloat(Pos[0]);
				PlayerInfo[playerid][pPos_y] = FormatFloat(Pos[1]);
				PlayerInfo[playerid][pPos_z] = FormatFloat(Pos[2]);
				PlayerInfo[playerid][pPos_r] = FormatFloat(Pos[3]);
			}
		}
		else {
			if(GetPVarInt(playerid, "IsInArena") >= 0) {
				PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "pbOldInt");
				PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "pbOldVW");
				PlayerInfo[playerid][pPos_x] = GetPVarFloat(playerid, "pbOldX");
				PlayerInfo[playerid][pPos_y] = GetPVarFloat(playerid, "pbOldY");
				PlayerInfo[playerid][pPos_z] = GetPVarFloat(playerid, "pbOldZ");
			}
		}
		g_mysql_SaveAccount(playerid);
	}
	return 1;
}

stock splits(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}

stock AddSpecialToken(playerid)
{

	new
		sz_FileStr[10 + MAX_PLAYER_NAME],
		sz_playerName[MAX_PLAYER_NAME],
		File: fPointer;

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	format(sz_FileStr, sizeof(sz_FileStr), "stokens/%s", sz_playerName);
	if(fexist(sz_FileStr)) {
		fPointer = fopen(sz_FileStr, io_read);
		fread(fPointer, sz_playerName), fclose(fPointer);

		new
			i_tokenVal = strval(sz_playerName);

		format(sz_playerName, sizeof(sz_playerName), "%i", i_tokenVal + 1);
		fPointer = fopen(sz_FileStr, io_write);
		if(fPointer)
		{
			fwrite(fPointer, sz_playerName);
			fclose(fPointer);
		}
	}
	else {
		fPointer = fopen(sz_FileStr, io_write);
	    if(fPointer)
		{
			fwrite(fPointer, "1");
			fclose(fPointer);
		}
	}
	return 1;
}

stock SeeSpecialTokens(playerid, hoursneeded)
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return 0; // Admins cant win
	if(hoursneeded <= 0) return 1;

	new
		szName[MAX_PLAYER_NAME],
		szFileStr[10 + MAX_PLAYER_NAME];

	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	format(szFileStr, sizeof(szFileStr), "stokens/%s", szName);
	if(fexist(szFileStr)) {

		new
			File: iFile = fopen(szFileStr, io_read);

		fread(iFile, szFileStr);
		fclose(iFile);
		if(strval(szFileStr) >= hoursneeded) return 1;
	}
	return 0;
}

stock ResetPlayerCash(playerid)
{
	PlayerInfo[playerid][pCash] = 0;
	ResetPlayerMoney(playerid);
	return 1;
}

stock SendTeamBeepMessage(color, string[])
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SendClientMessageEx(i, color, string);
			RingTone[i] = 20;
		}
	}	
}

stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

stock abs(value)
{
    return ((value < 0 ) ? (-value) : (value));
}

stock str_replace(sSearch[], sReplace[], const sSubject[], &iCount = 0)
{
	new
		iLengthTarget = strlen(sSearch),
		iLengthReplace = strlen(sReplace),
		iLengthSource = strlen(sSubject),
		iItterations = (iLengthSource - iLengthTarget) + 1;

	new
		sTemp[128],
		sReturn[128];

	strcat(sReturn, sSubject, 256);
	iCount = 0;

	for(new iIndex; iIndex < iItterations; ++iIndex)
	{
		strmid(sTemp, sReturn, iIndex, (iIndex + iLengthTarget), (iLengthTarget + 1));

		if(!strcmp(sTemp, sSearch, false))
		{
			strdel(sReturn, iIndex, (iIndex + iLengthTarget));
			strins(sReturn, sReplace, iIndex, iLengthReplace);

			iIndex += iLengthTarget;
			iCount++;
		}
	}
	return sReturn;
}

stock SaveAllAccountsUpdate()
{
	foreach(new i: Player)
	{
		if(gPlayerLogged{i}) {
			GetPlayerIp(i, PlayerInfo[i][pIP], 16);
			SetPVarInt(i, "AccountSaving", 1);
			OnPlayerStatsUpdate(i);
			break; // We only need to save one person at a time.
		}
	}	
}

stock SetPlayerToTeamColor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerInfo[playerid][pWantedLevel] > 0) {
			SetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWantedLevel]);
		}
	    #if defined zombiemode
   		if(GetPVarType(playerid, "pZombieBit"))
    	{
	    	SetPlayerColor(playerid, 0xFFCC0000);
  	   		return 1;
		}
		if(GetPVarType(playerid, "pIsZombie"))
		{
  			SetPlayerColor(playerid, 0x0BC43600);
	    	return 1;
		}
 		if(GetPVarType(playerid, "pEventZombie"))
		{
			SetPlayerColor(playerid, 0x0BC43600);
			return 1;
		}
		#endif
		if(GetPVarType(playerid, "IsInArena"))
	    {
	        new arenaid = GetPVarInt(playerid, "IsInArena");
	        if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3 || PaintBallArena[arenaid][pbGameType] == 5) switch(PlayerInfo[playerid][pPaintTeam]) {
				case 1: SetPlayerColor(playerid, PAINTBALL_TEAM_RED);
				case 2: SetPlayerColor(playerid, PAINTBALL_TEAM_BLUE);
	        }
	    }
	    else if(PlayerInfo[playerid][pJailTime] > 0) {
            if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1 || strfind(PlayerInfo[playerid][pPrisonReason], "[ISOLATE]", true) != -1) {
				SetPlayerColor(playerid,TEAM_ORANGE_COLOR);
			}
			else if(strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) {
    			SetPlayerColor(playerid,TEAM_APRISON_COLOR);
			}
		}
		else if(PlayerInfo[playerid][pBeingSentenced] != 0)
		{
			SetPlayerColor(playerid, SHITTY_JUDICIALSHITHOTCH);
		}
		else if((PlayerInfo[playerid][pJob] == 17 || PlayerInfo[playerid][pJob2] == 17 || PlayerInfo[playerid][pJob3] == 17 || PlayerInfo[playerid][pTaxiLicense] == 1) && TransportDuty[playerid] != 0) {
			SetPlayerColor(playerid,TEAM_TAXI_COLOR);
		}
	    else if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS && PlayerInfo[playerid][pDuty]) {

	    	if(GetPVarType(playerid, "MedBadge")) {

	    		DeletePVar(playerid, "MedBadge");
	    		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 1) { 
					SetPlayerColor(playerid, 0xFF828200);
				}
				else SetPlayerColor(playerid, 0x9569BF00);
	    	}
			else SetPlayerColor(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256);
		}
		else if(GetPVarType(playerid, "HitmanBadgeColour") && IsAHitman(playerid))
		{
		    SetPlayerColor(playerid, GetPVarInt(playerid, "HitmanBadgeColour"));
		}
		else {
			SetPlayerColor(playerid,TEAM_HIT_COLOR);
		}
	}
	return 1;
}

stock strfindcount(substring[], string[], bool:ignorecase = false, startpos = 0)
{
	new ncount, start = strfind(string, substring, ignorecase, startpos);
	while(start >- 1)
	{
		start = strfind(string, substring, ignorecase, start + strlen(substring));
		ncount++;
	}
	return ncount;
}

stock IsInvalidSkin(skin) {
	if(!(0 <= skin <= 311)) return 1;
    return 0;
}

stock IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

stock UpdateWheelTarget()
{
    gCurrentTargetYAngle += 36.0; // There are 10 carts, so 360 / 10
    if(gCurrentTargetYAngle >= 360.0) {
		gCurrentTargetYAngle = 0.0;
    }
	if(gWheelTransAlternate) gWheelTransAlternate = 0;
	else gWheelTransAlternate = 1;
}

// stock Random(min, max)
// {
//     new a = random(max - min) + min;
//     return a;
// }

forward ResetVariables();
public ResetVariables()
{
	for(new i = 1; i < MAX_VEHICLES; i++)  {
		DynVeh[i] = -1;
		TruckDeliveringTo[i] = INVALID_BUSINESS_ID;
	}
	
	if(Jackpot < 0) Jackpot = 0;
	if(TaxValue < 0) TaxValue = 0;

	for(new i = 0; i < MAX_VEHICLES; ++i) {
		VehicleFuel[i] = 100.0;
	}
	for(new i = 0; i < sizeof(CreatedCars); ++i) {
		CreatedCars[i] = INVALID_VEHICLE_ID;
	}
	
	EventKernel[EventRequest] = INVALID_PLAYER_ID;
	EventKernel[EventCreator] = INVALID_PLAYER_ID;
	for(new x; x < sizeof(EventKernel[EventStaff]); x++) {
		EventKernel[EventStaff][x] = INVALID_PLAYER_ID;
	}
	print("Resetting default server variables..");
	return 1;
}	

forward ResetNews();
public ResetNews()
{
	News[hTaken1] = 0; News[hTaken2] = 0; News[hTaken3] = 0; News[hTaken4] = 0; News[hTaken5] = 0; new string[32];
	for(new i = 0; i < 6; i++)
	{
		format(string, sizeof(string), "News[hAdd%d]", i);
		strcat(string, "Nothing");
		format(string, sizeof(string), "News[hContact%d]", i);
		strcat(string, "No-one");
	}
	print("Resetting news...");
	return true;
}	

/*
forward Float: GetPlayerSpeed(playerid);
public Float: GetPlayerSpeed(playerid)
{
	new Float: fVelocity[3];
	GetPlayerVelocity(playerid, fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}
*/

forward HidePlayerTextDraw(playerid, PlayerText:txd);
public HidePlayerTextDraw(playerid, PlayerText:txd) return PlayerTextDrawHide(playerid, txd);

forward DG_AutoReset();
public DG_AutoReset()
{
	for(new i = 0; i < sizeof(dgVar); i++)
	{
		if(dgVar[dgItems:i][0] == 1 && dgVar[dgItems:i][1] == 0)
		{
			dgVar[dgItems:i][1] += dgAmount;
		}
	}
}

stock GetFirstName(playerid)
{
	new name[MAX_PLAYER_NAME], underscore;
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	underscore = strfind(name, "_");
	strdel(name, underscore, MAX_PLAYER_NAME);
	return name;
}

stock GetLastName(playerid)
{
	new name[MAX_PLAYER_NAME], underscore;
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	underscore = strfind(name, "_");
	strdel(name, 0, underscore+1);
	return name;
}

/*ShowPlayerHolsterDialog(playerid)
{
	new szString[128];
	
	for(new i = 0; i < 12; i++)
	{
		if(PlayerInfo[playerid][pGuns][i] == 0 && i == 0)
		{
			format(szString, sizeof(szString), "%s\n", ReturnWeaponName(PlayerInfo[playerid][pGuns][i]));
		}
		else if(PlayerInfo[playerid][pGuns][i] != 0 && i > 0)
		{
			format(szString, sizeof(szString), "%s%s\n", szString, ReturnWeaponName(PlayerInfo[playerid][pGuns][i]));
		}
		else 
		{
			format(szString, sizeof(szString), "%sN/A\n", szString);
		}
	}
	return ShowPlayerDialogEx(playerid, DIALOG_HOLSTER, DIALOG_STYLE_LIST, "Holster Menu", szString, "Select", "Cancel"); 
}*/

stock randomString(strDest[], strLen = 10)
{
	while(strLen--) strDest[strLen] = random(2) ? (random(26) + (random(2) ? 'a' : 'A')) : (random(10) + '0');
}
/*
CanGetVIPWeapon(playerid)
{
	switch(PlayerInfo[playerid][pDonateRank])
	{
		case 1: return 1;
		case 2: return 1;
		case 3: if(PlayerInfo[playerid][pVIPGuncount] < 4) return 1;
		case 4:  if(PlayerInfo[playerid][pVIPGuncount] < 8) return 1;
	}
	return 0;
}*/

SpawnPlayerInPrisonCell(playerid, cellid)
{
	
	switch(cellid)
	{
	    case 0: { 
	    	SetPlayerPos(playerid, 566.7456,1444.0634,6000.4571);
	    	Player_StreamPrep(playerid, 566.7456,1444.0634,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 1: { 
	    	SetPlayerPos(playerid, 563.0581,1444.1854,6000.4571);
	    	Player_StreamPrep(playerid, 563.0581,1444.1854,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 2: { 
	    	SetPlayerPos(playerid, 559.4159,1443.9288,6000.4571);
	    	Player_StreamPrep(playerid, 559.4159,1443.9288,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 3: { 
	    	SetPlayerPos(playerid, 555.6315,1444.2306,6000.4571);
	    	Player_StreamPrep(playerid, 555.6315,1444.2306,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 4: { 
	    	SetPlayerPos(playerid, 552.0065,1444.1968,6000.4571);
	    	Player_StreamPrep(playerid, 552.0065,1444.1968,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 5: { 
	    	SetPlayerPos(playerid, 548.0844,1444.0985,6000.4571);
	    	Player_StreamPrep(playerid, 548.0844,1444.0985,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 6: { 
	    	SetPlayerPos(playerid, 544.6454,1444.1449,6000.4571);
	    	Player_StreamPrep(playerid, 544.6454,1444.1449,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 7: { 
	    	SetPlayerPos(playerid, 540.5981,1447.5231,6000.4571);
	    	Player_StreamPrep(playerid, 540.5981,1447.5231,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 8: { 
	    	SetPlayerPos(playerid, 540.4813,1450.9047,6000.4571);
	    	Player_StreamPrep(playerid, 540.4813,1450.9047,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 9: { 
	    	SetPlayerPos(playerid, 540.4357,1454.4258,6000.4571);
	    	Player_StreamPrep(playerid, 540.4357,1454.4258,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 10: { 
	    	SetPlayerPos(playerid, 540.7283,1458.2170,6000.4571);
	    	Player_StreamPrep(playerid, 540.7283,1458.2170,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 11: { 
	    	SetPlayerPos(playerid, 544.1293,1464.5228,6000.4571);
	    	Player_StreamPrep(playerid, 544.1293,1464.5228,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 12: { 
	    	SetPlayerPos(playerid, 547.7798,1464.7081,6000.4571);
	    	Player_StreamPrep(playerid, 547.7798,1464.7081,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 13: { 
	    	SetPlayerPos(playerid, 551.2144,1464.6027,6000.4571);
	    	Player_StreamPrep(playerid, 551.2144,1464.6027,6000.4571, FREEZE_TIME + 4000); 
	    }
	    case 14: { 
	    	SetPlayerPos(playerid, 557.2998,1464.8198,6000.4571);
	    	Player_StreamPrep(playerid, 557.2998,1464.8198,6000.4571, FREEZE_TIME + 4000); 
	    }
	    // end of first floor
	    case 15: { 
	    	SetPlayerPos(playerid, 566.3901,1443.7551,6004.4946);
	    	Player_StreamPrep(playerid, 566.3901,1443.7551,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 16: { 
	    	SetPlayerPos(playerid, 562.5015,1443.7295,6004.4946);
	    	Player_StreamPrep(playerid, 562.5015,1443.7295,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 17: { 
	    	SetPlayerPos(playerid, 2559.0636,1444.0476,6004.4946);
	    	Player_StreamPrep(playerid, 2559.0636,1444.0476,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 18: { 
	    	SetPlayerPos(playerid, 555.3583,1444.0355,6004.4946);
	    	Player_StreamPrep(playerid, 555.3583,1444.0355,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 19: { 
	    	SetPlayerPos(playerid, 551.9474,1443.7928,6004.4946);
	    	Player_StreamPrep(playerid, 551.9474,1443.7928,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 20: { 
	    	SetPlayerPos(playerid, 548.2891,1444.0117,6004.4946);
	    	Player_StreamPrep(playerid, 548.2891,1444.0117,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 21: { 
	    	SetPlayerPos(playerid, 544.8405,1444.0632,6004.4946);
	    	Player_StreamPrep(playerid, 544.8405,1444.0632,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 22: { 
	    	SetPlayerPos(playerid, 540.6741,1447.4341,6004.4946);
	    	Player_StreamPrep(playerid, 540.6741,1447.4341,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 23: { 
	    	SetPlayerPos(playerid, 540.6885,1451.2081,6004.4946);
	    	Player_StreamPrep(playerid, 540.6885,1451.2081,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 24: { 
	    	SetPlayerPos(playerid, 540.7267,1454.9779,6004.4946);
	    	Player_StreamPrep(playerid, 540.7267,1454.9779,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 25: { 
	    	SetPlayerPos(playerid, 540.4955,1458.8861,6004.4946);
	    	Player_StreamPrep(playerid, 540.4955,1458.8861,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 26: { 
	    	SetPlayerPos(playerid, 543.8416,1464.8979,6004.4946);
	    	Player_StreamPrep(playerid, 543.8416,1464.8979,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 27: { 
	    	SetPlayerPos(playerid, 547.9120,1464.5593,6004.4946);
	    	Player_StreamPrep(playerid, 547.9120,1464.5593,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 28: { 
	    	SetPlayerPos(playerid, 551.5958,1464.7749,6004.4946);
	    	Player_StreamPrep(playerid, 551.5958,1464.7749,6004.4946, FREEZE_TIME + 4000); 
	    }
	    case 29: { 
	    	SetPlayerPos(playerid, 557.6133,1464.9932,6004.4946);
	    	Player_StreamPrep(playerid, 557.6133,1464.9932,6004.4946, FREEZE_TIME + 4000); 
	    }
	    // end of second floor
	}
	return 1;
}
/*
stock WindowStatusForChat(sendid, receiveid)
{
	new SendWindow[4], ReceiveWindow[4];
	if(GetPlayerVehicleID(sendid) && GetPlayerVehicleID(receiveid))
	{
		GetVehicleParamsCarWindows(GetPlayerVehicleID(sendid), SendWindow[0], SendWindow[1], SendWindow[2], SendWindow[3]);
		GetVehicleParamsCarWindows(GetPlayerVehicleID(receiveid), ReceiveWindow[0], ReceiveWindow[1], ReceiveWindow[2], ReceiveWindow[3]);
		if(GetPlayerVehicleID(sendid) == GetPlayerVehicleID(receiveid)) return 1;
		else if(NoWindows(GetPlayerVehicleID(sendid)) && NoWindows(GetPlayerVehicleID(receiveid))) return 1;
		else if(NoWindows(GetPlayerVehicleID(receiveid)) && SendWindow[GetPlayerVehicleSeat(sendid)] == 0) return 1;
		else if(NoWindows(GetPlayerVehicleID(sendid)) && ReceiveWindow[GetPlayerVehicleSeat(receiveid)] == 0) return 1;
		else if(SendWindow[GetPlayerVehicleSeat(sendid)] == 0 && ReceiveWindow[GetPlayerVehicleSeat(receiveid)] == 0) return 1;
		else return 0;
	}
	else if(GetPlayerVehicleID(sendid) && !GetPlayerVehicleID(receiveid))
	{
		GetVehicleParamsCarWindows(GetPlayerVehicleID(sendid), SendWindow[0], SendWindow[1], SendWindow[2], SendWindow[3]);
		if(NoWindows(GetPlayerVehicleID(sendid))) return 1;
		else if(SendWindow[GetPlayerVehicleSeat(sendid)] == 0) return 1;
		else return 0;
	}
	else if(!GetPlayerVehicleID(sendid) && GetPlayerVehicleID(receiveid))
	{
		GetVehicleParamsCarWindows(GetPlayerVehicleID(receiveid), ReceiveWindow[0], ReceiveWindow[1], ReceiveWindow[2], ReceiveWindow[3]);
		if(NoWindows(GetPlayerVehicleID(receiveid))) return 1;
		else if(ReceiveWindow[GetPlayerVehicleSeat(receiveid)] == 0) return 1;
		else return 0;
	}
	return 1;
}*/

stock PlayerBusy(target) {
	if(GetPVarType(target, "PlayerCuffed") ||
		GetPVarInt(target, "pBagged") >= 1 ||
		GetPVarType(target, "Injured") ||
		GetPVarType(target, "IsFrozen") ||
		PlayerInfo[target][pHospital] > 0 ||
		GetPVarType(target, "IsInArena") ||
		GetPVarInt(target, "EventToken") != 0)
	return 1;
	else return 0;
}

stock TakePlayerMoney(playerid, amount) {
	if(GetPlayerCash(playerid) > amount) {
		GivePlayerCash(playerid, -amount);
		return 1;
	}
	if(PlayerInfo[playerid][pAccount] > amount) {
		PlayerInfo[playerid][pAccount] -= amount;
		return 1;
	}
	return 0;
}

new Float:water_squares[][] = {
	{-1584.0, -1826.0, -1360.0, -1642.0, 0.00000},
	{-3000.0, 354.0, -2832.0, 2942.0, 0.00000},
	{-2832.0, 1296.0, -2704.0, 2192.0, 0.00000},
	{-2704.0, 1360.0, -2240.0, 2224.0, 0.00000},
	{-2240.0, 1432.0, -2000.0, 2224.0, 0.00000},
	{-2064.0, 1312.0, -2000.0, 1432.0, 0.00000},
	{-2000.0, 1392.0, -1712.0, 1792.0, 0.00000},
	{-2000.0, 1792.0, -1724.0, 2016.0, 0.00000},
	{-2000.0, 2016.0, -1836.0, 2176.0, 0.00000},
	{-2000.0, 2176.0, -1920.0, 2224.0, 0.00000},
	{-2208.0, 2224.0, -2000.0, 2432.0, 0.00000},
	{-2208.0, 2432.0, -2000.0, 2576.0, 0.00000},
	{-2352.0, 2448.0, -2208.0, 2576.0, 0.00000},
	{-2312.0, 2344.0, -2208.0, 2448.0, 0.00000},
	{-1712.0, 1360.0, -1600.0, 1792.0, 0.00000},
	{-1664.0, 1280.0, -1600.0, 1360.0, 0.00000},
	{-1600.0, 1280.0, -1440.0, 1696.0, 0.00000},
	{-1600.0, 1696.0, -1488.0, 1744.0, 0.00000},
	{-1440.0, 1440.0, -1232.0, 1696.0, 0.00000},
	{-1232.0, 1440.0, -1136.0, 1616.0, 0.00000},
	{-1440.0, 1280.0, -1136.0, 1440.0, 0.00000},
	{-1136.0, 1248.0, -1104.0, 1424.0, 0.00000},
	{-1520.0, 1104.0, -1104.0, 1248.0, 0.00000},
	{-1520.0, 1248.0, -1136.0, 1280.0, 0.00000},
	{-1600.0, 1200.0, -1520.0, 1280.0, 0.00000},
	{-1104.0, 944.0, -932.0, 1136.0, 0.00000},
	{-1424.0, 944.0, -1104.0, 1104.0, 0.00000},
	{-1520.0, 1008.0, -1424.0, 1104.0, 0.00000},
	{-1424.0, 784.0, -896.0, 944.0, 0.00000},
	{-1488.0, 560.0, -896.0, 784.0, 0.00000},
	{-1536.0, 560.0, -1488.0, 672.0, 0.00000},
	{-896.0, 208.0, -768.0, 732.0, 0.00000},
	{-1600.0, 208.0, -896.0, 560.0, 0.00000},
	{-992.0, -144.0, -912.0, 208.0, 0.00000},
	{-1748.0, -816.0, -1180.0, -592.0, 0.00000},
	{-1458.0, -592.0, -1054.0, -432.0, 0.00000},
	{-3000.0, -1186.0, -2880.0, -822.0, 0.00000},
	{-2880.0, -1168.0, -2768.0, -896.0, 0.00000},
	{-2768.0, -1106.0, -2656.0, -830.0, 0.00000},
	{-2656.0, -1024.0, -2512.0, -816.0, 0.00000},
	{-2512.0, -976.0, -2400.0, -816.0, 0.00000},
	{-2400.0, -1056.0, -2256.0, -864.0, 0.00000},
	{-2256.0, -1198.0, -2144.0, -950.0, 0.00000},
	{-2144.0, -1408.0, -2000.0, -1072.0, 0.00000},
	{-2000.0, -1536.0, -1856.0, -1280.0, 0.00000},
	{-1856.0, -1648.0, -1728.0, -1440.0, 0.00000},
	{-1728.0, -1728.0, -1584.0, -1520.0, 0.00000},
	{-1360.0, -2052.0, -1216.0, -1696.0, 0.00000},
	{-1440.0, -2110.0, -1360.0, -1950.0, 0.00000},
	{-1484.0, -2180.0, -1440.0, -2036.0, 0.00000},
	{-1572.0, -2352.0, -1484.0, -2096.0, 0.00000},
	{-1216.0, -2208.0, -1104.0, -1864.0, 0.00000},
	{-1232.0, -2304.0, -1120.0, -2208.0, 0.00000},
	{-1270.0, -2480.0, -1178.0, -2304.0, 0.00000},
	{-1260.0, -2560.0, -1188.0, -2480.0, 0.00000},
	{-1262.0, -2640.0, -1146.0, -2560.0, 0.00000},
	{-1216.0, -2752.0, -1080.0, -2640.0, 0.00000},
	{-1200.0, -2896.0, -928.0, -2752.0, 0.00000},
	{-2016.0, -3000.0, -1520.0, -2704.0, 0.00000},
	{-1520.0, -3000.0, -1376.0, -2894.0, 0.00000},
	{-2256.0, -3000.0, -2016.0, -2772.0, 0.00000},
	{-2448.0, -3000.0, -2256.0, -2704.0, 0.00000},
	{-3000.0, -3000.0, -2448.0, -2704.0, 0.00000},
	{-3000.0, -2704.0, -2516.0, -2576.0, 0.00000},
	{-3000.0, -2576.0, -2600.0, -2448.0, 0.00000},
	{-3000.0, -2448.0, -2628.0, -2144.0, 0.00000},
	{-3000.0, -2144.0, -2670.0, -2032.0, 0.00000},
	{-3000.0, -2032.0, -2802.0, -1904.0, 0.00000},
	{-3000.0, -1904.0, -2920.0, -1376.0, 0.00000},
	{-3000.0, -1376.0, -2936.0, -1186.0, 0.00000},
	{-768.0, 208.0, -720.0, 672.0, 0.00000},
	{-720.0, 256.0, -656.0, 672.0, 0.00000},
	{-656.0, 276.0, -496.0, 576.0, 0.00000},
	{-496.0, 298.0, -384.0, 566.0, 0.00000},
	{-384.0, 254.0, -224.0, 530.0, 0.00000},
	{-224.0, 212.0, -64.0, 528.0, 0.00000},
	{-64.0, 140.0, 64.0, 544.0, 0.00000},
	{64.0, 140.0, 304.0, 544.0, 0.00000},
	{120.0, 544.0, 304.0, 648.0, 0.00000},
	{304.0, 164.0, 384.0, 608.0, 0.00000},
	{384.0, 222.0, 464.0, 630.0, 0.00000},
	{464.0, 304.0, 544.0, 656.0, 0.00000},
	{544.0, 362.0, 800.0, 646.0, 0.00000},
	{800.0, 432.0, 944.0, 704.0, 0.00000},
	{944.0, 480.0, 976.0, 720.0, 0.00000},
	{976.0, 528.0, 1040.0, 704.0, 0.00000},
	{1040.0, 560.0, 1280.0, 672.0, 0.00000},
	{1280.0, 480.0, 1472.0, 640.0, 0.00000},
	{1472.0, 432.0, 1616.0, 640.0, 0.00000},
	{1616.0, 416.0, 1824.0, 608.0, 0.00000},
	{1824.0, 400.0, 2160.0, 576.0, 0.00000},
	{2160.0, 400.0, 2432.0, 512.0, 0.00000},
	{2432.0, 368.0, 2560.0, 544.0, 0.00000},
	{2560.0, 336.0, 2720.0, 576.0, 0.00000},
	{2720.0, 196.0, 2816.0, 560.0, 0.00000},
	{2816.0, 160.0, 3000.0, 576.0, 0.00000},
	{2860.0, -80.0, 3000.0, 160.0, 0.00000},
	{-1376.0, -3000.0, -544.0, -2896.0, 0.00000},
	{-928.0, -2896.0, -544.0, -2800.0, 0.00000},
	{-544.0, -3000.0, -320.0, -2824.0, 0.00000},
	{-320.0, -3000.0, -192.0, -2876.0, 0.00000},
	{-192.0, -3000.0, 160.0, -2920.0, 0.00000},
	{-128.0, -2920.0, 160.0, -2872.0, 0.00000},
	{-60.0, -2872.0, 160.0, -2816.0, 0.00000},
	{-4.0, -2816.0, 160.0, -2672.0, 0.00000},
	{40.0, -2672.0, 160.0, -2256.0, 0.00000},
	{16.0, -2560.0, 40.0, -2256.0, 0.00000},
	{-32.0, -2440.0, 16.0, -2256.0, 0.00000},
	{-32.0, -2488.0, 16.0, -2440.0, 0.00000},
	{-96.0, -2440.0, -32.0, -2256.0, 0.00000},
	{-168.0, -2384.0, -96.0, -2256.0, 0.00000},
	{-224.0, -2256.0, 160.0, -2080.0, 0.00000},
	{-248.0, -2080.0, 160.0, -1968.0, 0.00000},
	{-280.0, -1968.0, -128.0, -1824.0, 0.00000},
	{-264.0, -2016.0, -248.0, -1968.0, 0.00000},
	{-264.0, -1824.0, -128.0, -1640.0, 0.00000},
	{-128.0, -1768.0, 124.0, -1648.0, 0.00000},
	{-128.0, -1792.0, 140.0, -1768.0, 0.00000},
	{-128.0, -1968.0, 148.0, -1792.0, 0.00000},
	{160.0, -2128.0, 592.0, -1976.0, 0.00000},
	{480.0, -1976.0, 592.0, -1896.0, 0.00000},
	{352.0, -1976.0, 480.0, -1896.0, 0.00000},
	{232.0, -1976.0, 352.0, -1880.0, 0.00000},
	{160.0, -1976.0, 232.0, -1872.0, 0.00000},
	{160.0, -2784.0, 592.0, -2128.0, 0.00000},
	{160.0, -3000.0, 592.0, -2784.0, 0.00000},
	{352.0, -1896.0, 544.0, -1864.0, 0.00000},
	{592.0, -2112.0, 976.0, -1896.0, 0.00000},
	{736.0, -1896.0, 904.0, -1864.0, 0.00000},
	{704.0, -1896.0, 736.0, -1728.0, 0.00000},
	{736.0, -1864.0, 752.0, -1728.0, 0.00000},
	{688.0, -1728.0, 752.0, -1480.0, 0.00000},
	{592.0, -2192.0, 976.0, -2112.0, 0.00000},
	{592.0, -2328.0, 1008.0, -2192.0, 0.00000},
	{592.0, -3000.0, 1008.0, -2328.0, 0.00000},
	{1008.0, -3000.0, 1072.0, -2368.0, 0.00000},
	{1008.0, -2368.0, 1064.0, -2320.0, 0.00000},
	{1072.0, -2672.0, 1288.0, -2412.0, 0.00000},
	{1072.0, -2768.0, 1288.0, -2672.0, 0.00000},
	{1072.0, -3000.0, 1288.0, -2768.0, 0.00000},
	{1288.0, -3000.0, 1448.0, -2760.0, 0.00000},
	{1288.0, -2760.0, 1392.0, -2688.0, 0.00000},
	{1448.0, -3000.0, 1720.0, -2754.0, 0.00000},
	{1720.0, -3000.0, 2064.0, -2740.0, 0.00000},
	{2064.0, -3000.0, 2144.0, -2742.0, 0.00000},
	{2144.0, -3000.0, 2208.0, -2700.0, 0.00000},
	{2208.0, -3000.0, 2272.0, -2684.0, 0.00000},
	{2272.0, -3000.0, 2376.0, -2312.0, 0.00000},
	{2376.0, -2480.0, 2472.0, -2240.0, 0.00000},
	{2472.0, -2376.0, 2776.0, -2240.0, 0.00000},
	{2776.0, -2336.0, 2856.0, -2192.0, 0.00000},
	{2808.0, -2560.0, 3000.0, -2336.0, 0.00000},
	{2856.0, -2336.0, 3000.0, -2136.0, 0.00000},
	{2888.0, -2136.0, 3000.0, -1840.0, 0.00000},
	{2872.0, -1880.0, 2888.0, -1840.0, 0.00000},
	{2864.0, -1840.0, 3000.0, -1720.0, 0.00000},
	{2888.0, -1720.0, 3000.0, -1664.0, 0.00000},
	{2896.0, -1664.0, 3000.0, -1592.0, 0.00000},
	{2920.0, -1592.0, 3000.0, -1504.0, 0.00000},
	{2940.0, -1504.0, 3000.0, -1344.0, 0.00000},
	{2908.0, -1344.0, 3000.0, -1096.0, 0.00000},
	{2912.0, -1096.0, 3000.0, -800.0, 0.00000},
	{2918.0, -800.0, 3000.0, -472.0, 0.00000},
	{2872.0, -472.0, 3000.0, -376.0, 0.00000},
	{2912.0, -376.0, 3000.0, -80.0, 0.00000},
	{2864.0, -376.0, 2912.0, -80.0, 0.00000},
	{2560.0, -2560.0, 2680.0, -2456.0, 0.00000},
	{-992.0, -422.0, -848.0, -238.0, 0.00000},
	{-848.0, -384.0, -512.0, -256.0, 0.00000},
	{-512.0, -400.0, -320.0, -272.0, 0.00000},
	{-320.0, -400.0, -208.0, -304.0, 0.00000},
	{-384.0, -528.0, -100.0, -460.0, 0.00000},
	{-384.0, -704.0, -64.0, -528.0, 0.00000},
	{-336.0, -816.0, -80.0, -704.0, 0.00000},
	{-208.0, -936.0, -48.0, -816.0, 0.00000},
	{-48.0, -936.0, 144.0, -874.0, 0.00000},
	{32.0, -1024.0, 128.0, -936.0, 0.00000},
	{-16.0, -1104.0, 96.0, -1024.0, 0.00000},
	{0.0, -1200.0, 144.0, -1104.0, 0.00000},
	{-16.0, -1296.0, 128.0, -1200.0, 0.00000},
	{-16.0, -1440.0, 112.0, -1296.0, 0.00000},
	{0.0, -1552.0, 96.0, -1440.0, 0.00000},
	{-128.0, -1648.0, 96.0, -1552.0, 0.00000},
	{-64.0, -672.0, 32.0, -576.0, 0.00000},
	{-64.0, -576.0, 96.0, -496.0, 0.00000},
	{16.0, -496.0, 144.0, -392.0, 0.00000},
	{144.0, -448.0, 240.0, -384.0, 0.00000},
	{240.0, -432.0, 304.0, -320.0, 0.00000},
	{304.0, -384.0, 352.0, -288.0, 0.00000},
	{352.0, -332.0, 400.0, -252.0, 0.00000},
	{400.0, -298.0, 464.0, -234.0, 0.00000},
	{464.0, -288.0, 576.0, -208.0, 0.00000},
	{576.0, -272.0, 688.0, -192.0, 0.00000},
	{688.0, -256.0, 768.0, -144.0, 0.00000},
	{768.0, -212.0, 800.0, -124.0, 0.00000},
	{800.0, -180.0, 976.0, -92.0, 0.00000},
	{976.0, -160.0, 1200.0, -64.0, 0.00000},
	{1200.0, -244.0, 1264.0, -108.0, 0.00000},
	{1264.0, -330.0, 1344.0, -158.0, 0.00000},
	{1344.0, -320.0, 1456.0, -208.0, 0.00000},
	{1456.0, -282.0, 1520.0, -198.0, 0.00000},
	{1520.0, -208.0, 1648.0, -80.0, 0.00000},
	{1568.0, -80.0, 1648.0, 16.0, 0.00000},
	{1648.0, -64.0, 1792.0, 16.0, 0.00000},
	{1792.0, -128.0, 1888.0, 0.0, 0.00000},
	{1888.0, -268.0, 2016.0, -20.0, 0.00000},
	{2016.0, -256.0, 2144.0, -16.0, 0.00000},
	{2144.0, -272.0, 2224.0, -96.0, 0.00000},
	{2224.0, -272.0, 2288.0, -144.0, 0.00000},
	{2048.0, -16.0, 2144.0, 112.0, 0.00000},
	{2096.0, 112.0, 2224.0, 240.0, 0.00000},
	{2098.0, 240.0, 2242.0, 400.0, 0.00000},
	{2160.0, 512.0, 2432.0, 576.0, 0.00000},
	{2432.0, 544.0, 2560.0, 592.0, 0.00000},
	{2560.0, 576.0, 2720.0, 608.0, 0.00000},
	{2720.0, 560.0, 2816.0, 608.0, 0.00000},
	{2816.0, 576.0, 3000.0, 752.0, 0.00000},
	{-656.0, 576.0, -496.0, 672.0, 0.00000},
	{-740.0, 672.0, -484.0, 784.0, 0.00000},
	{-720.0, 784.0, -384.0, 1008.0, 0.00000},
	{-640.0, 1008.0, -400.0, 1216.0, 0.00000},
	{-880.0, 1296.0, -688.0, 1408.0, 0.00000},
	{-688.0, 1216.0, -400.0, 1424.0, 0.00000},
	{-672.0, 1424.0, -448.0, 1616.0, 0.00000},
	{-832.0, 1616.0, -512.0, 1728.0, 0.00000},
	{-984.0, 1632.0, -832.0, 1712.0, 0.00000},
	{-832.0, 1728.0, -576.0, 2032.0, 0.00000},
	{-1248.0, 2536.0, -1088.0, 2824.0, 40.60000},
	{-1088.0, 2544.0, -1040.0, 2800.0, 40.59998},
	{-1040.0, 2544.0, -832.0, 2760.0, 40.59998},
	{-1088.0, 2416.0, -832.0, 2544.0, 40.60000},
	{-1040.0, 2304.0, -864.0, 2416.0, 40.60000},
	{-1024.0, 2144.0, -864.0, 2304.0, 40.60000},
	{-1072.0, 2152.0, -1024.0, 2264.0, 40.59999},
	{-1200.0, 2114.0, -1072.0, 2242.0, 40.60000},
	{-976.0, 2016.0, -848.0, 2144.0, 40.60000},
	{-864.0, 2144.0, -448.0, 2272.0, 40.59995},
	{-700.0, 2272.0, -484.0, 2320.0, 40.59999},
	{-608.0, 2320.0, -528.0, 2352.0, 40.59999},
	{-848.0, 2044.0, -816.0, 2144.0, 40.59998},
	{-816.0, 2060.0, -496.0, 2144.0, 40.59999},
	{-604.0, 2036.0, -484.0, 2060.0, 40.60000},
	{2376.0, -3000.0, 3000.0, -2688.0, 0.00000},
	{2520.0, -2688.0, 3000.0, -2560.0, 0.00000},
	{-1328.0, 2082.0, -1200.0, 2210.0, 40.59999},
	{-1400.0, 2074.0, -1328.0, 2150.0, 40.60000},
	{-1248.0, -144.0, -992.0, 208.0, 0.00000},
	{-1176.0, -432.0, -992.0, -144.0, 0.00000},
	{-1792.0, -592.0, -1728.0, -144.0, 0.00000},
	{-1792.0, 170.0, -1600.0, 274.0, 0.00000},
	{-1600.0, 168.0, -1256.0, 208.0, 0.00000},
	{-1574.0, -44.0, -1550.0, 108.0, 0.00000},
	{1928.0, -1222.0, 2012.0, -1178.0, 18.00000},
	{-464.0, -1908.0, -280.0, -1832.0, 0.00000},
	{2248.0, -1182.0, 2260.0, -1170.0, 23.33740},
	{2292.0, -1432.0, 2328.0, -1400.0, 22.16500},
	{1888.0, 1468.0, 2036.0, 1700.0, 8.59839},
	{2090.0, 1670.0, 2146.0, 1694.0, 9.61171},
	{2110.0, 1234.0, 2178.0, 1330.0, 7.83275},
	{2108.0, 1084.0, 2180.0, 1172.0, 7.56284},
	{2506.0, 1546.0, 2554.0, 1586.0, 8.96708},
	{1270.0, -812.0, 1290.0, -800.0, 86.67300},
	{1084.0, -684.0, 1104.0, -660.0, 112.00000},
	{502.0, -1114.0, 522.0, -1098.0, 78.42310},
	{214.0, -1208.0, 246.0, -1180.0, 74.00000},
	{218.0, -1180.0, 238.0, -1172.0, 74.00000},
	{178.0, -1244.0, 206.0, -1216.0, 77.05340},
	{1744.0, 2780.0, 1792.0, 2868.0, 8.47297},
	{-2832.0, 2888.0, 3000.0, 3000.0, 0.00000},
	{-2778.0, -522.0, -2662.0, -414.0, 2.79256},
	{1520.0, -252.0, 1572.0, -208.0, 0.00000},
	{2922.0, 752.0, 3000.0, 2888.0, 0.00000},
	{-3000.0, -446.0, -2910.0, 354.0, 0.00000},
	{-2434.0, 2224.0, -2294.0, 2340.0, 0.00000},
	{-2294.0, 2224.0, -2208.0, 2312.0, 0.00000},
	{2058.0, 1868.0, 2110.0, 1964.0, 9.62916},
	{-3000.0, 2942.0, -2832.0, 3000.0, 0.00000},
	{-550.0, 2004.0, -494.0, 2036.0, 40.60000},
	{-896.0, 842.0, -776.0, 954.0, 0.00000},
	{-2240.0, 1336.0, -2088.0, 1432.0, 0.00000},
	{-3000.0, -822.0, -2930.0, -446.0, 0.00000},
	{-2660.0, 2224.0, -2520.0, 2264.0, 0.00000},
	{-378.0, -460.0, -138.0, -400.0, 0.00000},
	{1836.0, 1468.0, 1888.0, 1568.0, 8.59839},
	{890.0, -1106.0, 902.0, -1098.0, 22.41000},
	{1202.0, -2414.0, 1278.0, -2334.0, 8.86445},
	{1072.0, -2412.0, 1128.0, -2372.0, 0.00000},
	{-848.0, -2082.0, -664.0, -1866.0, 5.27000},
	{-664.0, -1924.0, -464.0, -1864.0, 5.27000},
	{-1484.0, 784.0, -1424.0, 840.0, 0.00000},
	{-496.0, 566.0, -432.0, 642.0, 0.00000},
	{250.0, 2808.0, 818.0, 2888.0, 0.00000},
	{2502.0, -2240.0, 2670.0, -2120.0, 0.00000},
	//{1270.0, -780.0, 1290.0, -768.0, 1082.72998}, //IMPORTANT MESSAGE: THIS IS MADD DOGG'S HOUSE IN INTERIOR ID 5!
	{88.0, 544.0, 120.0, 572.0, 0.00000},
	{1856.0, -202.0, 1888.0, -158.0, 0.00000},
	{-2048.0, -962.0, -2004.0, -758.0, 30.40000},
	{2564.0, 2370.0, 2604.0, 2398.0, 16.40000},
	{-2522.0, -310.0, -2382.0, -234.0, 35.38200},
	{2872.0, -2136.0, 2888.0, -2120.0, 0.00000},
	{2760.0, -2240.0, 2776.0, -2232.0, 0.00000}
};
// These are all the triangle water zones in SA-MP. Takes some more figuring out which value is which.
// See it as ({x1,y1}, {x2,y2}, {x3,y3}, height)
// x1 is minimum X value, x5 is maximum X value
// Points 1 and two lie on the same horizontal line, that is, y1 = y2
// Point 3 is the 'pointy' end facing either upwards (north, due to higher Y) or downwards (sotuh,  due to lower Y)
// Final value is Z height value.
new Float:water_triangles[][] = {
	{-912.0, 208.0, -724.0, 208.0, -912.0, 20.0, 0.00000},
	{-1610.0, 168.0, -1550.0, 168.0, -1550.0, 108.0, 0.00000},
	{-1728.0, -62.0, -1568.0, -62.0, -1728.0, -222.0, 0.00000},
	{-1724.0, 170.0, -1612.0, 170.0, -1724.0, 58.0, 0.00000},
	{-1550.0, 168.0, -1362.0, 168.0, -1550.0, -20.0, 0.00000},
	{-1722.0, -62.0, -1574.0, -62.0, -1574.0, 86.0, 0.00000}
};

stock IsPointInMapBounds(Float:x, Float:y, Float:z)
{
	if(-3000.0 <= x <= 3000.0)
	{
		if(-3000.0 <= y <= 3000.0)
		{
			if(-100.0 <= z <= 1000.0)
			{
				return 1;
			}
		}
	}

	return 0;
}

stock IsPosInWater(Float:x, Float:y, Float:z)
{
	// todo: weather based z threshold
	if(z < 1.7 && !IsPointInMapBounds(x, y, z))
		return 1;

	for(new i = 0; i < sizeof water_squares; i++) // Check the squares. This is simple.
	{
		if(z <= water_squares[i][4])
		{
			if( (water_squares[i][0] <= x <= water_squares[i][2]) && (water_squares[i][1] <= y <= water_squares[i][3]) )
				return 1;
		}
	}

	for(new i = 0; i < sizeof water_triangles; i++) // Check the triangle zones too.
	{
		if(z <= water_triangles[i][6])
		{
			// Is within X boundaries
			if(water_triangles[i][0] > x || water_triangles[i][2] < x)
				continue;

			// Is within Y boundaries check.
			if(water_triangles[i][1] > water_triangles[i][5])
			{
				if(water_triangles[i][5] > y || water_triangles[i][1] < y)
					continue;
			}
			else if(water_triangles[i][1] > y || water_triangles[i][5] < y)
			{
				continue;
			}

			// We need to apply some entry level black magic (http://totologic.blogspot.nl/2014/01/accurate-point-in-triangle-test.html)
			new Float:denominator = ( (water_triangles[i][3]-water_triangles[i][5]) * (water_triangles[i][0]-water_triangles[i][4]) ) + \
				((water_triangles[i][4] - water_triangles[i][2]) * (water_triangles[i][1] - water_triangles[i][5]));
			new Float:a = (((water_triangles[i][3] - water_triangles[i][5]) * (x - water_triangles[i][4])) + \
				((water_triangles[i][4] - water_triangles[i][2]) * (y - water_triangles[i][5]))) / denominator;
			new Float:b = (((water_triangles[i][5] - water_triangles[i][1]) * (x - water_triangles[i][4])) + \
				((water_triangles[i][0] - water_triangles[i][4]) * (y - water_triangles[i][5]))) / denominator;
			new Float:c = 1 - (a + b);

			if( (0 <= a <= 1) && (0 <= b <= 1) && (0 <= c <= 1) )
				return 1;
		}
	}
	return 0;
}