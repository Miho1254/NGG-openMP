#include <YSI\y_hooks>
new BaoTriNhanCredits = 0;

CMD:duatuicredits(playerid, params[])
{
	if(BaoTriNhanCredits == 1) return SendClientMessageEx(playerid, -1, "Lenh Dang Bao Tri!");
	if(PlayerInfo[playerid][pDuaTuiCredits] == 0)
	{
	    if(PlayerInfo[playerid][pLevel] >= 3)
	    {
	        new szMessage[128];
			PlayerInfo[playerid][pCredits] += 500;
			mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE accounts SET Credits=%d WHERE id = %d", PlayerInfo[playerid][pCredits], GetPlayerSQLId(playerid));
		    mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		    print(szMessage);
			PlayerInfo[playerid][pDuaTuiCredits] += 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "[EVENT] Ban da nhan thanh cong 500 credits tu su kien");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong du dieu kien nhan qua su kien");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da nhan qua tu su kien nay roi");
	return 1;
}

CMD:baotrinhancre(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 5)
	{
		if(BaoTriNhanCredits == 0)
		{
			BaoTriNhanCredits = 1;
			SendClientMessageEx(playerid, COLOR_RED,"Ban da bao tri /duatuicredits.");
		}
		else if(BaoTriNhanCredits == 1)
		{
			BaoTriNhanCredits = 0;
			SendClientMessageEx(playerid, COLOR_GREEN,"Ban da ngung bao tri /duatuicredits");
		}
	}
	return 1;
}
