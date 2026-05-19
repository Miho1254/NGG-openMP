#include <YSI\y_hooks>

CMD:duatuivang(playerid, params[])
{
	if(PlayerInfo[playerid][pLevel] >= 5)
	{
			ShowPlayerDialog(playerid, DIALOG_TANGQUA, DIALOG_STYLE_MSGBOX, "Nhan Vang","{FFFFFF}Moi tai khoan tren {FF0000}cap do 5{FFFFFF} moi co the nhan duoc {f5d442}1 Vang{FFFFFF}\n{FF0000}Luu Y: Moi tai khoan chi co the nhan duoc 1 lan duy nhat." ,"Nhan","Thoat");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban can dat level 5 de nhan phan qua nay.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TANGQUA)
	{
	  	if(response)
		{
		    if(PlayerInfo[playerid][pNhanVang] == 1)
		    {
				PlayerInfo[playerid][pVang] += 1;
				PlayerInfo[playerid][pNhanVang] += 1;
				SendClientMessageEx(playerid, COLOR_GREEN, "Ban da nhan duoc 1 Vang");
				SendClientMessageEx(playerid, COLOR_GREY, "[>] Kiem tra Vang bang cach go lenh (/tuido).");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD1, "Ban da nhan phan qua nay roi.");
        }
    }
    return 1;
}         
