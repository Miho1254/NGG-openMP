

CMD:thatuchotui(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 99999) return SendClientMessageEx(playerid, COLOR_GRAD1, "Lenh dang duoc bao tri, vui long thu lai sau...");
	if(PlayerInfo[playerid][pJailTime] == 0)
	{
		return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong o trong tu!");
	}
	if(PlayerInfo[playerid][pThatu] == 0)
	{
		PlayerInfo[playerid][pThatu] += 1;
		PhoneOnline[playerid] = 0;
		PlayerInfo[playerid][pWantedLevel] = 0;
		PlayerInfo[playerid][pBeingSentenced] = 0;
		SetPlayerToTeamColor(playerid);
		SetHealth(playerid, 100);
		SetPlayerWantedLevel(playerid, 0);
		PlayerInfo[playerid][pJailTime] = 0;
		SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
		SetPlayerInterior(playerid,0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		strcpy(PlayerInfo[playerid][pPrisonReason], "None", 128);
		SetPlayerToTeamColor(playerid);
		SendClientMessageEx(playerid, COLOR_GREEN, "Ban da su dung lan ra tu trong ngay hom nay");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Ban da su dung het so lan ra tu trong ngay hom nay");
	return 1;
}
