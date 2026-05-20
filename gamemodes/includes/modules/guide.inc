#if defined _modules_guide_included
    #endinput
#endif

#define _modules_guide_included

#include <YSI\y_hooks>

#define MAX_GUIDE 3
#define MAX_ITEM_GUIDE 8

// Event_Show, TaskFarm_Show, Guide_ReadPost, GuideTimer are declared in inventory.inc
// VNC_Action, TaskFarm_Action stubs:
stock VNC_Action(playerid, action) { playerid++; action++; return 1; }
stock TaskFarm_Action(playerid, action) { playerid++; action++; return 1; }

new PlayerText:Guide_Main[MAX_PLAYERS][MAX_GUIDE][MAX_ITEM_GUIDE];
new PlayerText:Guide_Post[MAX_PLAYERS];
new Guide_ReadTab[MAX_PLAYERS];
// Guide_ReadPost and GuideTimer are declared in inventory.inc
new Guide_Page[MAX_PLAYERS];

Function: CPTD_Guide(playerid)
{
    Guide_Main[playerid][0][0] = CreatePlayerTextDraw(playerid, 150.000, 118.000, "mdl-2001:bg_main");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][0][0], 475.000, 291.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][0][0], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][0][0], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][0][0], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][0][0], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][0][0], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][0][0], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][0][0], 1);

    Guide_Main[playerid][0][1] = CreatePlayerTextDraw(playerid, 604.000, 129.000, "mdl-2001:btn_cancel");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][0][1], 13.000, 13.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][0][1], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][0][1], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][0][1], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][0][1], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][0][1], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][0][1], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][0][1], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][0][1], 1);

    Guide_Main[playerid][0][2] = CreatePlayerTextDraw(playerid, 197.000, 377.000, "mdl-2001:btn_icoredo");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][0][2], 17.000, 17.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][0][2], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][0][2], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][0][2], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][0][2], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][0][2], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][0][2], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][0][2], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][0][2], 1);

    Guide_Main[playerid][0][3] = CreatePlayerTextDraw(playerid, 219.000, 377.000, "mdl-2001:btn_iconext");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][0][3], 17.000, 17.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][0][3], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][0][3], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][0][3], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][0][3], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][0][3], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][0][3], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][0][3], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][0][3], 1);

    Guide_Main[playerid][0][4] = CreatePlayerTextDraw(playerid, 465.000, 383.000, "mdl-2001:btn_texticoredo");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][0][4], 53.000, 16.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][0][4], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][0][4], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][0][4], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][0][4], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][0][4], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][0][4], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][0][4], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][0][4], 1);

    Guide_Main[playerid][0][5] = CreatePlayerTextDraw(playerid, 551.000, 383.000, "mdl-2001:btn_texticonext");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][0][5], 53.000, 16.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][0][5], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][0][5], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][0][5], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][0][5], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][0][5], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][0][5], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][0][5], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][0][5], 1);

    Guide_Main[playerid][1][0] = CreatePlayerTextDraw(playerid, 158.000, 156.000, "mdl-2001:value_rules");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][0], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][0], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][0], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][0], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][0], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][0], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][0], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][0], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][0], 1);

    Guide_Main[playerid][1][1] = CreatePlayerTextDraw(playerid, 158.000, 181.000, "mdl-2001:value_eventshop");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][1], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][1], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][1], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][1], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][1], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][1], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][1], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][1], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][1], 1);

    Guide_Main[playerid][1][2] = CreatePlayerTextDraw(playerid, 158.000, 206.000, "mdl-2001:value_inventory");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][2], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][2], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][2], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][2], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][2], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][2], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][2], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][2], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][2], 1);

    Guide_Main[playerid][1][3] = CreatePlayerTextDraw(playerid, 158.000, 231.000, "mdl-2001:value_nvhn");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][3], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][3], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][3], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][3], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][3], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][3], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][3], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][3], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][3], 1);

    Guide_Main[playerid][1][4] = CreatePlayerTextDraw(playerid, 158.000, 256.000, "mdl-2001:value_advertisement");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][4], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][4], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][4], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][4], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][4], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][4], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][4], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][4], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][4], 1);

    Guide_Main[playerid][1][5] = CreatePlayerTextDraw(playerid, 158.000, 281.000, "mdl-2001:value_advertisement");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][5], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][5], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][5], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][5], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][5], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][5], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][5], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][5], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][5], 1);

    Guide_Main[playerid][1][6] = CreatePlayerTextDraw(playerid, 158.000, 306.000, "mdl-2001:value_advertisement");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][6], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][6], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][6], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][6], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][6], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][6], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][6], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][6], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][6], 1);

    Guide_Main[playerid][1][7] = CreatePlayerTextDraw(playerid, 158.000, 331.000, "mdl-2001:value_advertisement");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][1][7], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][1][7], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][1][7], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][1][7], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][1][7], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][1][7], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][1][7], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][1][7], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][1][7], 1);

    Guide_Main[playerid][2][0] = CreatePlayerTextDraw(playerid, 158.000, 156.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][0], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][0], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][0], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][0], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][0], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][0], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][0], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][0], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][0], 1);

    Guide_Main[playerid][2][1] = CreatePlayerTextDraw(playerid, 158.000, 181.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][1], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][1], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][1], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][1], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][1], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][1], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][1], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][1], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][1], 1);

    Guide_Main[playerid][2][2] = CreatePlayerTextDraw(playerid, 158.000, 206.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][2], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][2], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][2], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][2], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][2], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][2], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][2], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][2], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][2], 1);

    Guide_Main[playerid][2][3] = CreatePlayerTextDraw(playerid, 158.000, 231.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][3], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][3], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][3], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][3], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][3], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][3], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][3], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][3], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][3], 1);

    Guide_Main[playerid][2][4] = CreatePlayerTextDraw(playerid, 158.000, 256.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][4], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][4], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][4], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][4], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][4], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][4], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][4], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][4], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][4], 1);

    Guide_Main[playerid][2][5] = CreatePlayerTextDraw(playerid, 158.000, 281.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][5], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][5], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][5], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][5], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][5], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][5], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][5], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][5], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][5], 1);

    Guide_Main[playerid][2][6] = CreatePlayerTextDraw(playerid, 158.000, 306.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][6], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][6], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][6], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][6], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][6], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][6], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][6], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][6], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][6], 1);

    Guide_Main[playerid][2][7] = CreatePlayerTextDraw(playerid, 158.000, 331.000, "mdl-2001:item");
    PlayerTextDrawTextSize(playerid, Guide_Main[playerid][2][7], 118.000, 22.000);
    PlayerTextDrawAlignment(playerid, Guide_Main[playerid][2][7], 1);
    PlayerTextDrawColor(playerid, Guide_Main[playerid][2][7], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Main[playerid][2][7], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Main[playerid][2][7], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Main[playerid][2][7], 255);
    PlayerTextDrawFont(playerid, Guide_Main[playerid][2][7], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Main[playerid][2][7], 1);
    PlayerTextDrawSetSelectable(playerid, Guide_Main[playerid][2][7], 1);

    return 1;
}

Function: CPTD_GuidePost(playerid)
{
    Guide_Post[playerid] = CreatePlayerTextDraw(playerid, 301.000, 165.000, "mdl-2001:default_postguide");
    PlayerTextDrawTextSize(playerid, Guide_Post[playerid], 309.000, 209.000);
    PlayerTextDrawAlignment(playerid, Guide_Post[playerid], 1);
    PlayerTextDrawColor(playerid, Guide_Post[playerid], -1);
    PlayerTextDrawSetShadow(playerid, Guide_Post[playerid], 0);
    PlayerTextDrawSetOutline(playerid, Guide_Post[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, Guide_Post[playerid], 255);
    PlayerTextDrawFont(playerid, Guide_Post[playerid], 4);
    PlayerTextDrawSetProportional(playerid, Guide_Post[playerid], 1);
    return 1;
}

Function: Guide_Action(playerid, action)
{
    new i, z;
    new icanyes[3] = 0;
    switch(action)
    {
        case 0:
        {
            for(i = 0 ; i < MAX_GUIDE ; i++)
            {
                for(z = 0 ; z < MAX_ITEM_GUIDE ; z++)
                {
                    if(i == 0 && z < 6)
                    {
                        if(Guide_Main[playerid][i][z] == PlayerText:INVALID_TEXT_DRAW)
                        {
                            if(z == 5)
                            {
                                icanyes[0] = 1;
                            }
                        }
                    }
                    if(i == 1 && z < 8)
                    {
                        if(Guide_Main[playerid][i][z] == PlayerText:INVALID_TEXT_DRAW)
                        {
                            if(z == 7)
                            {
                                icanyes[1] = 1;
                            }
                        }
                    }
                    if(i == 2 && z < 8)
                    {
                        if(Guide_Main[playerid][i][z] == PlayerText:INVALID_TEXT_DRAW)
                        {
                            if(z == 7)
                            {
                                icanyes[2] = 1;
                            }
                        }
                    }
                }
            }
            for(i = 0 ; i < 3 ; i++)
            {
                if(icanyes[i] == 0)
                {
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}GUIDE{FFFFFF}]: Da co loi xay ra trong qua trinh mo GUIDE.");
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}GUIDE{FFFFFF}]: Ban hay kiem tra lai file cache/models cua minh.");
                    return 1;
                }
            }
            CPTD_Guide(playerid);
            for(i = 0 ; i < MAX_GUIDE ; i++)
            {
                for(z = 0 ; z < MAX_ITEM_GUIDE ; z++)
                {
                    if(i == 0 && z < 6)
                    {
                        if(Guide_Main[playerid][i][z] != PlayerText:INVALID_TEXT_DRAW)
                        {
                            PlayerTextDrawShow(playerid, Guide_Main[playerid][i][z]);
                        }
                    }
                    if(i == 1 && z < 8 || i == 2 && z < 8)
                    {
                        if(Guide_Main[playerid][i][z] != PlayerText:INVALID_TEXT_DRAW)
                        {
                            PlayerTextDrawShow(playerid, Guide_Main[playerid][i][z]);
                        }
                    }
                }
            }
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}GUIDE{FFFFFF}]: Ban da mo 'Guide' thanh cong.");
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}GUIDE{FFFFFF}]: Neu bi mat con tro chuot hay nhan phim 'T' va nhap /mouse de mo lai.");
            SelectTextDraw(playerid, 0xFF422485);
            GuideTimer[playerid] = 1;
            defer KillTimerGuideTimer(playerid);
            Guide_Show[playerid] = 1;
            Guide_Action(playerid, 1);
            return 1;
        }
        case 1:
        {
            CPTD_GuidePost(playerid);
            if(Guide_Post[playerid] != PlayerText:INVALID_TEXT_DRAW)
            {
                PlayerTextDrawShow(playerid, Guide_Post[playerid]);
            }
            Guide_ReadPost[playerid] = 1;
            Guide_ReadTab[playerid] = 0;
            Guide_Page[playerid] = 1;
            for(z = 0 ; z < 8 ; z++)
            {
                if(z >= 5) PlayerTextDrawHide(playerid, Guide_Main[playerid][1][z]);
                PlayerTextDrawHide(playerid, Guide_Main[playerid][2][z]);
            }
            Guide_Action(playerid, 2);
            return 1;
        }
        case 2:
        {
            switch(Guide_ReadTab[playerid])
            {
                case 0:
                {
                    switch(Guide_ReadPost[playerid])
                    {
                        case 1:
                        {
                            PlayerTextDrawSetString(playerid, Guide_Post[playerid], "mdl-2001:default_postguide");
                        }
                        case 2:
                        {
                            PlayerTextDrawSetString(playerid, Guide_Post[playerid], "mdl-2001:default_postguide_2");
                        }
                        default:
                        {
                            Guide_ReadPost[playerid]--;
                        }
                    }
                }
                case 1:
                {
                    switch(Guide_ReadPost[playerid])
                    {
                        case 1:
                        {
                            PlayerTextDrawSetString(playerid, Guide_Post[playerid], "mdl-2001:postguide_rules_1");
                        }
                        case 2:
                        {
                            PlayerTextDrawSetString(playerid, Guide_Post[playerid], "mdl-2001:postguide_rules_2");
                        }
                        default:
                        {
                            Guide_ReadPost[playerid]--;
                        }
                    }
                }
                case 2:
                {
                  /*  callcmd::closeguide(playerid, "");
                    defer GiveMouseSelect(playerid, 2); // give sau 3 giay // shop*/
                    SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}GUIDE{FFFFFF}]: Cua hang hien dang tam khoa, hay den NPC o VIP SF de mua nhe.");
                }
                case 3:
                {
                    callcmd::closeguide(playerid, "");
                    defer GiveMouseSelect(playerid, 3); // inventory
                }
                case 4:
                {
                    callcmd::closeguide(playerid, "");
                    defer GiveMouseSelect(playerid, 4); // taskfarm
                }
            }
        }
    }
    return 1;
}

CMD:closeguide(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        if(Guide_Show[playerid] != 0)
        {
            for(new i = 0 ; i < MAX_GUIDE ; i++)
            {
                for(new z = 0 ; z < MAX_ITEM_GUIDE ; z++)
                {
                    if(i == 0 && z < 6)
                    {
                        PlayerTextDrawDestroy(playerid, Guide_Main[playerid][i][z]);
                        Guide_Main[playerid][i][z] = PlayerText:INVALID_TEXT_DRAW;
                    }
                    if(i == 1 && z < 8 || i == 2 && z < 8)
                    {
                        PlayerTextDrawDestroy(playerid, Guide_Main[playerid][i][z]);
                        Guide_Main[playerid][i][z] = PlayerText:INVALID_TEXT_DRAW;
                    }
                }
            }
            PlayerTextDrawDestroy(playerid, Guide_Post[playerid]);
            Guide_Post[playerid] = PlayerText:INVALID_TEXT_DRAW;
            SendClientMessageEx(playerid, COLOR_WHITE, "[{FFB561}GUIDE{FFFFFF}]: Ban da dong 'Guide' thanh cong.");
            Guide_ReadPost[playerid] = 0;
            Guide_ReadTab[playerid] = 0;
            Guide_Page[playerid] = 0;
            Guide_Show[playerid] = 0;
            CancelSelectTextDraw(playerid);
        }
    }
    return 1;
}

timer KillTimerGuideTimer[3000](playerid)
{
    if(GuideTimer[playerid] != 0) GuideTimer[playerid] = 0;
    return 1;
}

timer GiveMouseSelect[1000](playerid, resultid)
{
    switch(resultid)
    {
        case 2: return VNC_Action(playerid, 1);
        case 3: return Inventory_Action(playerid, 0);
        case 4: return TaskFarm_Action(playerid, 1);
    }
    return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
    new z, i;
    if(playertextid == Guide_Main[playerid][0][1])
    {
        if(Guide_Main[playerid][0][1] != PlayerText:INVALID_TEXT_DRAW)
        {
            return callcmd::closeguide(playerid, "");
        }
    }
    if(playertextid == Guide_Main[playerid][0][4])
    {
        if(Guide_ReadPost[playerid] == 0 || Guide_ReadPost[playerid] == 1) return 1;
        Guide_ReadPost[playerid]--;
        Guide_Action(playerid, 2);
    }
    if(playertextid == Guide_Main[playerid][0][5])
    {
        Guide_ReadPost[playerid]++;
        Guide_Action(playerid, 2);
    }
    for(z = 0 ; z < 8 ; z++)
    {
        if(playertextid == Guide_Main[playerid][1][z])
        {
            for(i = 0 ; i < 8 ; i++)
            {
                PlayerTextDrawHide(playerid, Guide_Main[playerid][2][i]);
                if(i == 7) PlayerTextDrawShow(playerid, Guide_Main[playerid][2][z]);
            }

            switch(Guide_Page[playerid])
            {
                case 1: Guide_ReadTab[playerid] = z + 1; // page 1
                case 2: Guide_ReadTab[playerid] = z+9; // page 2
                case 3: Guide_ReadTab[playerid] = z+17; // page 3
            }
            Guide_ReadPost[playerid] = 1;
            Guide_Action(playerid, 2);
            return 1;
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_CTRL_BACK))
    {
        if(gPlayerLogged{playerid})
        {
            if(IsPlayerUsingSampMobile(playerid)) return callcmd::tuidomobile(playerid, "");
            new i;
            if(GuideTimer[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban dang thao tac qua nhanh.");
            if(GetPVarInt(playerid, "EventToken"))
                return SendClientMessageEx(playerid, COLOR_GRAD1, "Ban khong the lam dieu nay ngay bay gio khi event dang dien ra.");
            if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen"))
                return SendClientMessage(playerid, COLOR_GRAD2, "Ban khong the lam dieu nay ngay bay gio!");
            if(Inventory_Show[playerid] != 0) return SendClientMessageEx(playerid, COLOR_WHITE, "[{EB8034}Warning{FFFFFF}]: Hay tat tui do truoc khi mo guide.");
            for(i = 0 ; i < MAX_EVENT_SPAWN ; i++)
                if(Event_Show[i][playerid] != 0) return SendClientMessageEx(playerid, COLOR_WHITE, "[{EB8034}Warning{FFFFFF}]: Hay tat event shop truoc khi mo guide.");
            if(TaskFarm_Show[playerid] != 0) return SendClientMessageEx(playerid, COLOR_WHITE, "[{EB8034}Warning{FFFFFF}]: Hay tat nhiem vu hang ngay truoc khi mo guide.");
            if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) Guide_Action(playerid, 0);
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    for(new i = 0 ; i < MAX_GUIDE ; i++)
    {
        for(new z = 0 ; z < MAX_ITEM_GUIDE ; z++)
        {
            if(i == 0 && z < 6)
            {
                Guide_Main[playerid][i][z] = PlayerText:INVALID_TEXT_DRAW;
            }
            if(i == 1 && z < 8 || i == 2 && z < 8)
            {
                Guide_Main[playerid][i][z] = PlayerText:INVALID_TEXT_DRAW;
            }
        }
    }
    Guide_Post[playerid] = PlayerText:INVALID_TEXT_DRAW;
    Guide_ReadPost[playerid] = 0;
    Guide_ReadTab[playerid] = 0;
    Guide_Page[playerid] = 0;
    Guide_Show[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    for(new i = 0 ; i < MAX_GUIDE ; i++)
    {
        for(new z = 0 ; z < MAX_ITEM_GUIDE ; z++)
        {
            if(i == 0 && z < 6)
            {
                PlayerTextDrawDestroy(playerid, Guide_Main[playerid][i][z]);
            }
            if(i == 1 && z < 8 || i == 2 && z < 8)
            {
                PlayerTextDrawDestroy(playerid, Guide_Main[playerid][i][z]);
            }
        }
    }
    PlayerTextDrawDestroy(playerid, Guide_Post[playerid]);
    Guide_ReadPost[playerid] = 0;
    Guide_ReadTab[playerid] = 0;
    Guide_Page[playerid] = 0;
    Guide_Show[playerid] = 0;
    GuideTimer[playerid] = 0;
    return 1;
}