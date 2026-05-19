#include <YSI\y_hooks>
  
stock SaveTongTien(playerid)
{
	new szMessage[128];
	format(szMessage, sizeof(szMessage), "UPDATE `accounts` SET `TongTien`=%d WHERE `id` = %d", PlayerInfo[playerid][pTongTien], GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMessage, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
}
stock SaveTOPLevel(playerid)
{
	new szMessage[128];
	format(szMessage, sizeof(szMessage), "UPDATE `accounts` SET `Level`=%d WHERE `id` = %d", PlayerInfo[playerid][pLevel], GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMessage, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
}
stock SaveGiochoi(playerid)
{
	new szMessage[128];
	format(szMessage, sizeof(szMessage), "UPDATE `accounts` SET `ConnectedTime`=%d WHERE `id` = %d", PlayerInfo[playerid][pConnectHours], GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMessage, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
}
stock SaveCredits(playerid)
{
	new szMessage[128];
	format(szMessage, sizeof(szMessage), "UPDATE `accounts` SET `Credits`=%d WHERE `id` = %d", PlayerInfo[playerid][pCredits], GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMessage, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
}
hook OnPlayerUpdate(playerid)
{
	PlayerInfo[playerid][pTongTien] = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
    SaveTongTien(playerid);
	SaveCredits(playerid);
	SaveTOPLevel(playerid);
	SaveGiochoi(playerid);
}
hook OnPlayerLoad(playerid)
{
    PlayerInfo[playerid][pTongTien] = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
}

CMD:bangxephang(playerid, params[])
{
		ShowPlayerDialog(playerid,DIALOG_TOP,DIALOG_STYLE_LIST,"Bang xep hang - TOP Player","TOP Money\nTOP Level\nTOP Gio choi\nTOP Credits","Lua chon", "Dong");
		return 1;
}