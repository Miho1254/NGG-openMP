
#include <YSI\y_hooks>

CMD:top(playerid, params[])
{
		ShowPlayerDialog(playerid,DIALOG_TOP,DIALOG_STYLE_LIST,"Bang Xep Hang","TOP Level\nTOP Gio choi","Lua chon", "Dong");
		return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_TOP)
	{
	    if(response)
	    {
	        if(listitem == 0)
			{
		        new Cache:Result, ss[2500];
				Result = mysql_query(MainPipeline, "SELECT `Level`, `Username` FROM `accounts` ORDER BY `Level` DESC LIMIT 50");
				if(cache_num_rows())
				{
					new money, username[MAX_PLAYER_NAME + 1];
					format(ss,sizeof(ss),"%sTOP\tNguoi choi\tLevel\n", ss);
					for(new i = 0; i < cache_num_rows(); ++i)
					{
						money = cache_get_row_int(i, 0);
						cache_get_row(i, 1, username);
						format(ss,sizeof(ss),"%s{FF0000}%d\t{FFFFFF}%s\t{00FF00}%s\n", ss, i+1, username, number_format(money));
	                }
				}
	    		cache_delete(Result);
		    	ShowPlayerDialog(playerid, TOPLEVEL, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}TOP 50 Level", ss, "Ok", "");
	 		}
	 		if(listitem == 1)
			{
		        new Cache:Result, ss[2500];
				Result = mysql_query(MainPipeline, "SELECT `ConnectHours`, `Username` FROM `accounts` ORDER BY `ConnectHours` DESC LIMIT 50");
				if(cache_num_rows())
				{
					new giochoi, username[MAX_PLAYER_NAME + 1];
					format(ss,sizeof(ss),"%sTOP\tNguoi choi\tGio Choi\n", ss);
					for(new i = 0; i < cache_num_rows(); ++i)
					{
						giochoi = cache_get_row_int(i, 0);
						cache_get_row(i, 1, username);
						format(ss,sizeof(ss),"%s{FF0000}%d\t{FFFFFF}%s\t{00FF00}%s\n", ss, i+1, username, number_format(giochoi));
	                }
				}
	    		cache_delete(Result);
		    	ShowPlayerDialog(playerid, TOPLEVEL, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}TOP 50 Level", ss, "Ok", "");
	 		}
	 	}
	}
	return 1;
}