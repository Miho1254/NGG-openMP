
#include <YSI\y_hooks>



hook OnGameModeInit()
{
	TDE_DOMAINSV[0] = TextDrawCreate(1.900017, 433.669677, "GTN:VN v1.4");
	TextDrawLetterSize(TDE_DOMAINSV[0], 0.251998, 1.201776);
	TextDrawAlignment(TDE_DOMAINSV[0], 1);
	TextDrawColor(TDE_DOMAINSV[0], -77);
	TextDrawSetShadow(TDE_DOMAINSV[0], 0);
	TextDrawSetOutline(TDE_DOMAINSV[0], 0);
	TextDrawBackgroundColor(TDE_DOMAINSV[0], 255);
	TextDrawFont(TDE_DOMAINSV[0], 1);
	TextDrawSetProportional(TDE_DOMAINSV[0], 1);
	TextDrawSetShadow(TDE_DOMAINSV[0], 0);
}
//format(string, sizeof(string), "%s (ID: %d | SQL ID: %d | Level: %d | IP: %s) has logged in.",
//TextDrawShowForPlayer(playerid, TDE_DOMAINSV[0]);
