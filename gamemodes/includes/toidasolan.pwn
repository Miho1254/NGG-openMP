GetDate_V(&day, &month, &year)
{
   getdate(year, month, day);
}

forward toidasolan(playerid);
public toidasolan(playerid)
{
	new d, m, y;
	GetDate_V(d, m, y);
	if(d != PlayerInfo[playerid][pResetsolan])
	{
	    PlayerInfo[playerid][pResetsolan] = d;
	    PlayerInfo[playerid][pGioihan] = 0;
	    PlayerInfo[playerid][pThatu] = 0;
	}
	return 1;
}
