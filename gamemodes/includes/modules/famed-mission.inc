#if defined _famed_mission_included
    #endinput
#endif

#define _famed_mission_included

#include <YSI\y_hooks>

#define CHECKPOINT_FAMEMISSION 4512
#define CHECKPOINT_FAMENPC 4513

#define MAX_FAME_NPC 3
#define MAX_FAME_PROGRESS 5

new fameNPC[MAX_FAME_NPC];
new fameReadPost[MAX_PLAYERS];
new fameMisson_Task[MAX_PLAYERS][MAX_FAME_PROGRESS];
new bool:fameMission_Ready[MAX_PLAYERS];
new gFindNPCFame[MAX_PLAYERS];

new fameNPC_Name[][] =
{
    "Jerry", "Richard", "Huong Giang"
};
new fameNPC_Model[] =
{
    20006, 72, 20007
};

new Float:fameNPC_Pos[][4] =
{
    {-1984.5582,1129.9293,53.2022,267.1447},
    {-1600.6066,51.5451,3.5547,43.6012},
    {-2640.0288,552.6786,14.6094,358.8986}
};
CMD:nhiemvudanhvong(playerid, params[])
{
    if(gPlayerLogged{playerid})
    {
        if(PlayerInfo[playerid][pTut] < 29) return SendClientMessageEx(playerid, COLOR_GRAD3, "Vui long hoan thanh nhiem vu co ban truoc khi nhan nhiem vu danh vong.");
        if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Hay xoa bo muc tieu hien tai truoc khi nhan muc tieu moi (/xoamuctieu).");
        AdvanceFamed(playerid);
    }
    return 1;
}

CMD:settut(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 1337)
        return SendClientMessageEx(playerid, COLOR_RED, "Ban khong du quyen han de su dung lenh nay.");
    new tut_id;
    if (sscanf(params, "d", tut_id))
    {
        return SendClientMessageEx(playerid, COLOR_RED, "USAGE: /settut [Tut ID]");
    }
    
    if (tut_id < 0)
    {
        return SendClientMessageEx(playerid, COLOR_RED, "Loi: Tut ID phai la mot so nguyen duong.");
    }
    
    PlayerInfo[playerid][pTut] = tut_id;
    fameReadPost[playerid] = 0;
    fameMission_Ready[playerid] = false;
    DisablePlayerCheckpoint(playerid);
    gPlayerCheckpointStatus[playerid] = 0;
    for(new i = 0 ; i < MAX_FAME_PROGRESS ; i++)
    {
        fameMisson_Task[playerid][i] = 0;
    }
    
    new str[128];
    format(str, sizeof(str), "** Da dat Tut ID cua ban la %d. Vui long su dung /nhiemvudanhvong de bat dau lai.", tut_id);
    SendClientMessageEx(playerid, COLOR_RED, str);

    return 1;
}

Function: GivePlayerFamePoint(playerid, progress, amount)
{
    switch(PlayerInfo[playerid][pTut])
    {
        case 0 .. 28: return 1;
        case 29:
        {
            if(fameMisson_Task[playerid][progress] == 10) return 1;
        }
        case 32: // New quest: Huong Giang Mining (use index 0 for progress)
        {
            if(fameMisson_Task[playerid][0] == 1) return 1;
        }
    }
    if(fameMission_Ready[playerid])
    {
        if(progress > MAX_FAME_PROGRESS) return 1;
        
        if (PlayerInfo[playerid][pTut] == 32)
        {
            if (progress != 0) return 1; // Only progress index 0 for Tut 32
            fameMisson_Task[playerid][0] += amount;
        }
        else
        {
            fameMisson_Task[playerid][progress] += amount;
        }

        PlayerData[playerid][pc_FamedPoint] += amount;
        new str[68];
        format(str, sizeof(str), "[{DAA4F5}Diem Danh Vong{FFFFFF}] Ban nhan duoc %d diem danh vong.", amount);
        SendClientMessageEx(playerid, COLOR_WHITE, str);
    }
    switch(PlayerInfo[playerid][pTut])
    {
        case 29:
        {
            if(fameMisson_Task[playerid][progress] == 10)
            {
                GameTextForPlayer(playerid, "Da du diem! Hay tro lai NPC Jerry de hoan thanh nhiem vu.", 3000, 1);
                SendClientMessageEx(playerid, COLOR_WHITE, "Hay su dung /map > NPC Danh vong > Jerry de di den do.");
            }
        }
        case 32:
        {
            if(fameMisson_Task[playerid][0] >= 1)
            {
                GameTextForPlayer(playerid, "Da du diem! Hay tro lai NPC Huong Giang de hoan thanh nhiem vu.", 3000, 1);
                SendClientMessageEx(playerid, COLOR_WHITE, "Hay su dung /map > NPC Danh vong > Huong Giang de di den do.");
            }
        }
    }
    return 1;
}

Function: AdvanceFamed(playerid)
{
    new str[2056];
    switch(PlayerInfo[playerid][pTut])
    {
        case 29:
        {
            format(str, sizeof(str), "{FFFFFF}Tim hieu ve the su tai San Fierro - {8C2ABD}Gap go NPC {8C2ABD}Jerry{FFFFFF}\n\
            {FFFFFF}Huong dan nhiem vu:\n\
            - Bam {FF0000}OK{FFFFFF} de di den NPC {8C2ABD}Jerry{FFFFFF} va tuong tac voi anh ay.\n\
            - Bam phim {FF0000}Y{FFFFFF} de bat dau qua trinh tuong tac.");
        }
        case 30:
        {
            format(str, sizeof(str), "{FFFFFF}Tim hieu ve the su tai San Fierro (2) - {8C2ABD}Gap go NPC {8C2ABD}Jerry{FFFFFF}\n\
            {FFFFFF}Huong dan nhiem vu:\n\
            - Bam {FF0000}OK{FFFFFF} de di den NPC {8C2ABD}Jerry{FFFFFF} va tuong tac voi anh ay.\n\
            - Bam phim {FF0000}Y{FFFFFF} de bat dau qua trinh tuong tac.");
        }
        case 31:
        {
            format(str, sizeof(str), "{FFFFFF}Tim hieu ve the su tai San Fierro (3) - {8C2ABD}Gap go NPC {8C2ABD}Huong Giang{FFFFFF}\n\
            {FFFFFF}Mo ta nhiem vu:\n\
            - Sau khi hoan thanh cuoc gap go voi {8C2ABD}Jerry{FFFFFF}, ban duoc gioi thieu den mot nhan vat moi la {8C2ABD}Huong Giang{FFFFFF} vo cua Tommy.\n\
            - Co ay la mot thuong nhan buon lau kin tieng, dong thoi la mot nha tham hiem va nha phan phoi thiet bi khai thac chuyen nghiep.\n\
            - Nhiem vu chinh cua ban la den gap co ay tai khu {8C2ABD}Benh vien San Fierro{FFFFFF} de duoc huong dan chi tiet ve viec su dung cac dung cu\n\
            ma {8C2ABD}Richard{FFFFFF} da trao truoc do (Ban Do Kho Bau, May Khai Thac, va Can Xang).\n\
            - Cach tuong tac voi NPC {8C2ABD}Huong Giang{FFFFFF} tuong tu nhu cach ban da ap dung voi NPC {8C2ABD}Jerry{FFFFFF} va {8C2ABD}Richard{FFFFFF}.\n\
            - Hay lang nghe ky loi giai thich cua co ay, vi day se la kien thuc can thiet cho cac nhiem vu kho hon sau nay.");
        }
        case 32: // Nhiem vu moi: Tim va Khai thac Khoang san (Huong Giang)
        {
            format(str, sizeof(str), "{FFFFFF}Nhiem vu dau tien ve Khai thac - {8C2ABD}Tim kiem Khoang san{FFFFFF}\n\
            {FFFFFF}Mo ta nhiem vu:\n\
            - Bam {FF0000}OK{FFFFFF} de di den NPC {8C2ABD}Huong Giang{FFFFFF} va tuong tac voi co ay.\n\
            - Co ay se giao cho ban nhiem vu: su dung {8C2ABD}Ban Do Kho Bau{FFFFFF} de tim va khai thac {FF0000}mot quang khoang san{FFFFFF} (1 don vi).\n\
            - Sau khi khai thac thanh cong {FF0000}mot quang khoang san (khong thoat game){FFFFFF}, hay quay lai {8C2ABD}Huong Giang{FFFFFF} de bao cao va nhan thuong.\n\
            - Bam phim {FF0000}Y{FFFFFF} de bat dau qua trinh tuong tac.");
        }
    }
    Dialog_Show(playerid, DIALOG_FAME_TUTORIAL, DIALOG_STYLE_MSGBOX, "Nhiem vu danh vong", str, "OK", "");
    return 1;
}

Function: AdvanceFamed_Action(playerid)
{
    new str[64];
    switch(PlayerInfo[playerid][pTut])
    {
        case 0 .. 28:
        {
            format(str, sizeof(str), "Ban can dat Tut ID 29 de bat dau nhiem vu danh vong!");
            return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", str, "Ok", "");
        }
        case 29, 30, 31, 32: format(str, sizeof(str), "Lam nhiem vu\nHoan thanh nhiem vu\n");
    }
    Dialog_Show(playerid, DIALOG_FAME_CHOICE, DIALOG_STYLE_LIST, "Nhiem vu danh vong", str, "Chon", "Huy");
    return 1;
}

Function: Fame_Accent(playerid)
{
    new interacting_npc = -1;

    for(new i = 0 ; i < MAX_FAME_NPC ; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[i][0], fameNPC_Pos[i][1], fameNPC_Pos[i][2]))
        {
            interacting_npc = i;
            break;
        }
    }
    
    // NPC Error Check
    if(interacting_npc == -1)
    {
        szMiscArray = "{FFFFFF}Chua co nhiem vu gi o NPC nay.";
        return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", szMiscArray, "Chap nhan", "");
    }
    
    // Main Quest Logic
    switch(PlayerInfo[playerid][pTut])
    {
        case 29:
        {
            if(interacting_npc != 0) // Must be Jerry
            {
                szMiscArray = "{FFFFFF}Chua co nhiem vu gi o NPC nay.";
                return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", szMiscArray, "Chap nhan", "");
            }
            
            switch(fameReadPost[playerid])
            {
                case 0:
                {
                    szMiscArray = "{FFFFFF}Chao ban, toi la {8C2ABD}Jerry{FFFFFF}. Toi tung la mot nguoi linh, mot cuu binh den tu New Robada.\n\
                    Moi thu da thay doi nhieu ke tu khi toi tro ve, va hien tai... toi chi dang co gang song sot qua ngay.\n\
                    ";
                }
                case 1:
                {
                    szMiscArray = "{FFFFFF}Toi xin loi vi da hoi, nhung hien tai thanh pho dang rat khon kho can su giup do?";
                }
                case 2:
                {
                    szMiscArray = "{FFFFFF}Ban co muon giup do anh ta khong?";
                    return Dialog_Show(playerid, DIALOG_FAME_SET_MISSION, DIALOG_STYLE_MSGBOX, "Cot truyen - danh vong", szMiscArray, "Dong Y", "Khong");
                }
                case 3:
                {
                    szMiscArray = "{FFFFFF}Cam on long tot cua anh ban! Toi khong chi xin cho ban than minh. \n\
                    Toi da chien dau trong Cuoc Tan The o San Fierro. \n\
                    Gio day, thanh pho nay can cuu tro. Ho dang can thuc an!";
                }
                case 4:
                {
                    szMiscArray = "{FFFFFF}Toi la cuu binh, nhung toi khong co chan de di lai xa. \n\
                    Anh ban hay di den Tiem Banh o gan Downtown San Fierro, Toi da dat truoc mot lo banh rat lon o do. \n\
                    Do la mot chuyen di ngan, nhung rat quan trong.";
                }
                case 5:
                {
                    szMiscArray = "{FFFFFF}Hay di giao 10 chiec banh den nhung can ho co nho, ho dang rat can no, hay thay toi... \n\
                    Di duoc khong, chien huu? Toi rat biet on su giup do cua anh ban.";
                    return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu: Bua An Cuu Tro", szMiscArray, "Chap nhan", "");
                }
            }
        }
        case 30:
        {
            if(interacting_npc == 0) // Interacting with Jerry
            {
                if(fameMission_Ready[playerid]) // Already accepted Richard's quest from Jerry
                {
                    szMiscArray = "{FFFFFF}Anh ban, hay nhanh chong di gap {8C2ABD}Richard{FFFFFF}. Anh ay dang cho cau do. Toi se khong lam mat thoi gian cua cau nua.";
                    return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", szMiscArray, "Chap nhan", "");
                }
                switch(fameReadPost[playerid])
                {
                    case 0: 
                    {
                        szMiscArray = "{FFFFFF}Chao ban, toi la {8C2ABD}Jerry{FFFFFF}. Rat cam on long tot cua cau trong nhiem vu cuu tro thuc an lan truoc!\n\
                        Cau la mot nguoi linh thuc thu, chien huu.\n\
                        ";
                    }
                    case 1:
                    {
                        szMiscArray = "{FFFFFF}Nho co cau ma nhieu gia dinh co duoc bua an. Cong viec hoan thanh rat tot, that su kham phuc.\n\
                        Toi da rat biet on su giup do cua cau.\n\
                        ";
                    }
                    case 2:
                    {
                        szMiscArray = "{FFFFFF}Tuy nhien, gio khong phai luc de nghi ngoi. Thanh pho dang can nhieu hon the.\n\
                        Nhiem vu tiep theo se kho khan va nguy hiem hon rat nhieu.\n\
                        ";
                    }
                    case 3:
                    {
                        szMiscArray = "{FFFFFF}Cau can phai duoc trang bi day du, khong chi ve vu khi ma con ve thong tin mat.\n\
                        De chuan bi, toi muon gioi thieu cau voi mot nguoi quan trong.\n\
                        ";
                    }
                    case 4:
                    {
                        szMiscArray = "{FFFFFF}Hay tim gap {8C2ABD}Richard{FFFFFF}. Anh ay la mot nguoi ban cu, mot cuu binh khac giong toi, den tu New Robada.\n\
                        Richard hien dang o gan Downtown San Fierro, khu vuc Bai Dau Xe Bo Hoang.\n\
                        ";
                    }
                    case 5:
                    {
                        szMiscArray = "{FFFFFF}Toi da sap xep de {8C2ABD}Richard{FFFFFF} chuyen cho cau cac dung cu cuc ky quan trong cho chuyen di sap toi.\n\
                        Day la nhung thu khong the thieu de tim kiem Kho Bau.\n\
                        ";
                    }
                    case 6:
                    {
                        szMiscArray = "{FFFFFF}Mon thu nhat la mot Ban Do Kho Bau chi dan vi tri cac diem dac biet (noi an chua nhieu kho bau).\n\
                        Mon thu hai la mot May Khai Thac de cau su dung.\n\
                        Mon thu ba la mot Can Xang de dam bao may moc cua cau luon hoat dong.\n\
                        ";
                    }
                    case 7:
                    {
                        szMiscArray = "{FFFFFF}Cau chi can noi voi anh ay: 'Jerry gui toi den.'\n\
                        Anh ay se hieu y. Dung lam toi that vong, chien huu!\n\
                        Di gap anh ay ngay lap tuc nhe.\n\
                        ";
                    }
                    case 8:
                    {
                        szMiscArray = "{FFFFFF}Chuc cau may man. Hay lay cac mon do do va quay lai gap toi.\n\
                        Chung ta se chinh phuc nhiem vu Truy Tim Kho Bau.\n\
                        ";
                        return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu: Gap Go Richard", szMiscArray, "Chap nhan", "");
                    }
                }
            }
            else if(interacting_npc == 1) // Interacting with Richard
            {
                if(!fameMission_Ready[playerid])
                {
                    szMiscArray = "{FFFFFF}Chua co nhiem vu gi o NPC nay.";
                    return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - danh vong", szMiscArray, "Ok","");
                }
                switch(fameReadPost[playerid])
                {
                    case 0:
                    {
                        szMiscArray = "{FFFFFF}Chao mung, toi la {8C2ABD}Richard{FFFFFF}. Co ve nhu {8C2ABD}Jerry{FFFFFF} da noi truoc voi cau roi.\n\
                        Cung la mot cuu binh, toi rat hieu nhung gi {8C2ABD}Jerry{FFFFFF} dang co gang lam de giup do thanh pho.\n\
                        ";
                    }
                    case 1:
                    {
                        szMiscArray = "{FFFFFF}Cau can phai nhanh chong. Nhung ke khac cung dang tim kiem Kho Bau, va chung khong he co long tot.\n\
                        Bo ba mon do ma {8C2ABD}Jerry{FFFFFF} da hua da duoc toi chuan bi o day.\n\
                        ";
                    }
                    case 2:
                    {
                        szMiscArray = "{FFFFFF}Mon thu nhat la Ban Do Kho Bau (Map), no se giup cau dinh vi chinh xac nhung noi can khai thac.\n\
                        Mon thu hai la May Khai Thac (Flame), dung de dao nhung chiec ruong bi chon vui.\n\
                        Mon thu ba la mot Can Xang (Jerry Can), dung de dam bao May Khai Thac khong bi het nang luong giua chung.\n\
                        ";
                    }
                    case 3:
                    {
                        szMiscArray = "{FFFFFF}Cau biet day, toi khong the giao nhung mon do nay cho mot ai khong dang tin cay.\n\
                        De xac nhuc lai thong tin, hay cho toi biet thong diep ma {8C2ABD}Jerry{FFFFFF} da gui den cho cau la gi?\n\
                        Toi chi muon chac chan rang cau la nguoi anh ta tin tuong.\n\
                        ";
                    }
                    case 4:
                    {
                        szMiscArray = "{FFFFFF}Hay nhap chinh xac thong diep ma {8C2ABD}Jerry{FFFFFF} da noi voi cau vao o ben duoi de xac minh danh tinh.\n\
                        Chi khi do, cau moi duoc phep nhan nhung dung cu nay.\n\
                        ";
                        return Dialog_Show(playerid, DIALOG_RICHARD_QUEST, DIALOG_STYLE_INPUT, "Xac Nhac Danh Tinh Voi Richard", szMiscArray, "Xac Nhac", "Huy");
                    }
                }
            }
            else
            {
                szMiscArray = "{FFFFFF}Chua co nhiem vu gi o NPC nay.";
                return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - danh vong", szMiscArray, "Ok","");
            }
        }
        case 31:
        {
            if(interacting_npc == 0) // Interacting with Jerry
            {
                if(fameMission_Ready[playerid] && fameReadPost[playerid] < 4) 
                {
                    szMiscArray = "{FFFFFF}Anh ban, hay nhanh chong di gap {8C2ABD}Huong Giang{FFFFFF}. Co ay dang doi cau de huong dan. \n\
                    Hay nhan OK de dat lai Checkpoint (neu bi mat) va den gap co ay.";
                    return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", szMiscArray, "OK", "");
                }
                
                switch(fameReadPost[playerid])
                {
                    case 0:
                    {
                        szMiscArray = "{FFFFFF}Truoc khi bat dau hanh trinh moi, toi muon cau gap mot nguoi dac biet.\n\
                        Co ay ten la {8C2ABD}Huong Giang{FFFFFF}, vo cua Tommy. Mot nguoi phu nu vua sac sao vua nguy hiem.\n\
                        ";
                    }
                    case 1:
                    {
                        szMiscArray = "{FFFFFF}Huong Giang la mot thuong nhan buon lau noi tieng trong gioi ngam,\n\
                        nhung rat it nguoi biet rang co ay con la mot nha tham hiem va nha phan phoi thiet bi khai thac hang dau.\n\
                        Co ay tung tham gia nhieu chien dich dao mo o sa mac Bone County va khu mo da Flint.\n\
                        ";
                    }
                    case 2:
                    {
                        szMiscArray = "{FFFFFF}Voi moi nguoi, co ay chi la mot nguoi ban buon kheo leo,\n\
                        nhung voi toi, {8C2ABD}Huong Giang{FFFFFF} la nguon thong tin quy gia nhat ve cac thiet bi mo rong phuc vu viec tim kiem kho bau.\n\
                        Neu muon hieu sau hon ve cac mon do cau vua nhan, hay den gap co ay.\n\
                        ";
                    }
                    case 3:
                    {
                        szMiscArray = "{FFFFFF}Huong Giang hien dang o mot nha kho bi mat gan khu Docks San Fierro,\n\
                        noi nhung chiec container cu duoc dung lam phong nghien cuu va xuong lap rap.\n\
                        Khi den noi, chi can noi voi co ay rang {8C2ABD}Jerry va Richard da gioi thieu cau{FFFFFF}.\n\
                        Co ay se huong dan chi tiet ve cong dung cua Ban Do Kho Bau, May Khai Thac, va Can Xang.\n\
                        ";
                    }
                    case 4:
                    {
                        szMiscArray = "{FFFFFF}Day la co hoi tot de cau hieu ro hon ve nhung cong cu minh so huu.\n\
                        {8C2ABD}Huong Giang{FFFFFF} la nguoi duy nhat co the giup cau toi uu viec su dung chung.\n\
                        Cau co muon den gap co ay va lam theo huong dan cua co ay khong?\n\
                        ";
                        return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu: Gap Go Huong Giang", szMiscArray, "Dong y", "Khong");
                    }
                }
            }
            else if(interacting_npc == 2) // Interacting with Huong Giang
            {
                if(fameMission_Ready[playerid] && fameReadPost[playerid] == 0) 
                {
                    szMiscArray = "{FFFFFF}Chao mung, toi la {8C2ABD}Huong Giang{FFFFFF}. {8C2ABD}Jerry{FFFFFF} va {8C2ABD}Richard{FFFFFF} da gui cau den day?\n\
                    Hay noi: \"Jerry va Richard gui toi den\" de toi co the huong dan ban cach su dung dung cu.";
                    return Dialog_Show(playerid, DIALOG_HUONGGIANG_QUEST, DIALOG_STYLE_INPUT, "Xac Nhac Danh Tinh Voi Huong Giang", szMiscArray, "Xac Nhac", "Huy");
                }
                else
                {
                    szMiscArray = "{FFFFFF}Chua co nhiem vu gi o NPC nay.";
                    return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", szMiscArray, "Ok", "");
                }
            }
            else // Interacting with other NPCs
            {
                 szMiscArray = "{FFFFFF}Chua co nhiem vu gi o NPC nay.";
                 return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", szMiscArray, "Ok", "");
            }
        }
        case 32: // TUT 32: New quest with Huong Giang
        {
            if(interacting_npc != 2) // Must be Huong Giang
            {
                szMiscArray = "{FFFFFF}Chua co nhiem vu gi o NPC nay.";
                return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu - danh vong", szMiscArray, "Chap nhan", "");
            }
            
            if(fameMission_Ready[playerid])
            {
                 szMiscArray = "{FFFFFF}Ban da nhan nhiem vu. Hay su dung {8C2ABD}Ban Do Kho Bau{FFFFFF} de tim va khai thac {FF0000}mot quang khoang san{FFFFFF}, sau do quay lai day de hoan thanh.";
                 return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", szMiscArray, "Chap nhan", "");
            }

            switch(fameReadPost[playerid])
            {
                case 0:
                {
                    szMiscArray = "{FFFFFF}Chao mung, chien huu. Toi da chuan bi cho ban mot thu thach dau tien de kiem tra su hieu biet ve dung cu moi.\n\
                    Nhiem vu nay se la buoc dem cho nhung cuoc phieu luu san lung kho bau lon hon.";
                }
                case 1:
                {
                    szMiscArray = "{FFFFFF}Ban se can su dung {8C2ABD}Ban Do Kho Bau{FFFFFF} trong tui do (nhan H hoac /tuido) de tim kiem cac diem khai thac. \n\
                    Sau do dung {8C2ABD}May Khai Thac{FFFFFF} de dao len Kho Bau va nhan {FF0000}Khoang san{FFFFFF}.";
                }
                case 2:
                {
                    szMiscArray = "{FFFFFF}Nhiem vu cua ban la khai thac thanh cong {FF0000}mot quang khoang san{FFFFFF} (1 don vi, khong thoat game).\n\
                    Ban da san sang de bat dau thu thach dau tien chua?";
                    return Dialog_Show(playerid, DIALOG_FAME_SET_MSFINAL, DIALOG_STYLE_MSGBOX, "Nhiem vu: Khai Thac Mo Duong", szMiscArray, "Dong Y", "Khong");
                }
            }
        }
    }
    Dialog_Show(playerid, DIALOG_FAME_ACCENT, DIALOG_STYLE_MSGBOX, "Cot truyen - danh vong", szMiscArray, "Tiep tuc", "");
    return 1;
}

Function: ShowFameNPCList(playerid)
{
    new str[256];
    for(new i = 0 ; i < MAX_FAME_NPC ; i++)
    {
        format(str, sizeof(str), "%s\n(%d) %s", str, i, fameNPC_Name[i]);
    }
    Dialog_Show(playerid, DIALOG_FAME_NPC_FIND, DIALOG_STYLE_LIST, "NPC Danh vong", str, "Tim", "Huy");
    return 1;
}

Dialog:DIALOG_RICHARD_QUEST(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if (strcmp(inputtext, "Jerry gui toi den.", true) == 0 || strcmp(inputtext, "Jerry gui toi den", true) == 0)
        {
            new 
                str[356],
                success1 = -1,
                success2 = -1,
                success3 = -1;
            SetPlayerItem(playerid, 8, 1, success1);
            SetPlayerItem(playerid, 21, 100, success2);
            SetPlayerItem(playerid, 43, 1, success3);
            if(success1 == 1) SetPVarInt(playerid, "NormalMachineFuel", 100);
            if(success1 == -1 || success2 == -1 || success3 == -1)
            {
                fameReadPost[playerid] = 0;
                format(str, sizeof(str), "Ban khong the nhan vat pham vao luc nay, hay kiem tra lai kho do va thu lai nhe.");
                return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Loi - Danh vong", str, "Ok", "");
            }
            
            GivePlayerCash(playerid, 10000);
            GivePlayerEA(playerid, 1250);
            PlayerData[playerid][pc_FamedPoint] += 15;
            fameMisson_Task[playerid][0] = 0;
            fameReadPost[playerid] = 0;
            GameTextForPlayer(playerid, "Mission Passed!", 3000, 1);
            PlayerInfo[playerid][pTut]++;
            fameMission_Ready[playerid] = false;
            SendClientMessageEx(playerid, COLOR_WHITE, "[{DAA4F5}Danh Vong{FFFFFF}] Ban nhan duoc $10,000 tien thuong va 1250 EXP Farm, danh vong +15.");
            format(str, sizeof(str), "{FFFFFF}Ban da nhan duoc cac vat pham chinh:\n\
            - Ban do Kho Bau (Map).\n\
            - May khai thac.\n\
            - Can xang (100 lit).");
            Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Thuong - Danh vong", str, "Ok", "");
            DisablePlayerCheckpoint(playerid);
            return 1;
        }
        
        fameReadPost[playerid] = 3;
        GameTextForPlayer(playerid, "Nhiem vu that bai, hay nhap lai", 3000, 1);
        
        new szError[128];
        format(szError, sizeof(szError), "{FF0000}Thong diep khong chinh xac. Hay nhap lai chinh xac mat ma.\n\
        {FFFFFF}Mat ma la: 'Jerry gui toi den.'");
        return Dialog_Show(playerid, DIALOG_RICHARD_QUEST, DIALOG_STYLE_INPUT, "Xac Nhac Danh Tinh Voi Richard", szError, "Xac Nhac", "Huy");
    }
    
    fameReadPost[playerid] = 0;
    GameTextForPlayer(playerid, "Nhiem vu da bi huy bo", 3000, 1);
    fameMission_Ready[playerid] = false;
    return 1;
}

Dialog:DIALOG_HUONGGIANG_QUEST(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if (strcmp(inputtext, "Jerry va Richard gui toi den.", true) == 0 || strcmp(inputtext, "Jerry va Richard gui toi den", true) == 0)
        {
            return Dialog_Show(playerid, DIALOG_HGIntroduction, DIALOG_STYLE_MSGBOX, "{8C2ABD}Huong Giang{FFFFFF}: Kien Thuc Khai Thac", 
                "{FFFFFF}Tot! Vay chung ta bat dau nhe.\n\n\
                {8C2ABD}I. Gioi thieu ve Khoang San (Minerals):{FFFFFF}\n\
                Khoang san ma cau se khai thac tu Kho Bau la nguon nguyen lieu vo cung quan trong. Chung khong chi la tai san ma con la nen tang cho su song con.\n\n\
                Chuc nang chinh cua chung la:\n\
                - {FF0000}Che Tao Vu Khi:{FFFFFF} Ket hop voi cac vat lieu khac de che tao sung ong va hop dan.\n\
                - {FF0000}Nguyen Lieu Xay Dung/Che Tao:{FFFFFF} Dung de tao ra cac cong cu, thiet bi, hoac tham chi la cac cong trinh nho trong tuong lai.\n\n\
                {8C2ABD}II. Vi tri Khoang San (Map Hint):{FFFFFF}\n\
                De bat dau tim kiem, cau chi can mo {FF0000}Tui Do (nhan phim H hoac /tuido){FFFFFF}, sau do chon {8C2ABD}Ban Do Kho Bau{FFFFFF} va bam 'Su Dung'.\n\
                Ban do se chi cho cau diem khai thac dau tien.\n\n\
                {FFFFFF}Hay tap trung va ghi nho thong tin! Cau se co mot bai kiem tra ngan de xac nhan da nam bat duoc kien thuc.\n\
                (Thoi gian gioi han: 30 giay)", "Tiep tuc", "");
        }
        
        fameReadPost[playerid] = 0; 
        GameTextForPlayer(playerid, "Xac nhan that bai, hay nhap lai", 3000, 1);
        
        
        new szError[128];
        format(szError, sizeof(szError), "{FF0000}Thong diep khong chinh xac. Hay nhap lai chinh xac mat ma.\n\
        {FFFFFF}Mat ma la: 'Jerry va Richard gui toi den.'");
        return Dialog_Show(playerid, DIALOG_HUONGGIANG_QUEST, DIALOG_STYLE_INPUT, "Xac Nhac Danh Tinh Voi Huong Giang", szError, "Xac Nhac", "Huy");
    }
    
    fameReadPost[playerid] = 0;
    GameTextForPlayer(playerid, "Nhiem vu da bi huy bo", 3000, 1);
    fameMission_Ready[playerid] = false;
    return 1;
}

Dialog:DIALOG_HGIntroduction(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        return Dialog_Show(playerid, DIALOG_HUONGGIANG_QUIZ, DIALOG_STYLE_INPUT, "{8C2ABD}Huong Giang{FFFFFF}: Kiem Tra Kien Thuc", 
            "{FFFFFF}Hay cho toi biet: {FF0000}Chuc nang chinh cua khoang san ma cau khai thac la gi?{FFFFFF}\n\
            (Vui long nhap mot trong cac chuc nang ma toi da de cap. Chu y chinh ta.)", "Tra loi", "Huy bo");
    }
    
    fameReadPost[playerid] = 0;
    fameMission_Ready[playerid] = false;
    GameTextForPlayer(playerid, "Nhiem vu da bi huy bo", 3000, 1);
    return 1;
}

Dialog:DIALOG_HUONGGIANG_QUIZ(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if (strcmp(inputtext, "Che Tao Vu Khi", true) == 0 ||
            strcmp(inputtext, "Che tao sung ong", true) == 0 ||
            strcmp(inputtext, "Che tao sung", true) == 0 ||
            strcmp(inputtext, "lam nguyen lieu", true) == 0 ||
            strcmp(inputtext, "nguyen lieu che tao", true) == 0 ||
            strcmp(inputtext, "che tao", true) == 0)
        {
            new str[128];
            
            
            GivePlayerCash(playerid, 20000);
            GivePlayerEA(playerid, 3000);
            // Update_Adventures(playerid); // Ham nay khong co trong file, giu nguyen de dam bao khong loi compiler
            PlayerData[playerid][pc_FamedPoint] += 10;
            fameReadPost[playerid] = 0;
            GameTextForPlayer(playerid, "Mission Passed!", 3000, 1);
            PlayerInfo[playerid][pTut]++;
            fameMission_Ready[playerid] = false;
            SendClientMessageEx(playerid, COLOR_WHITE, "[{DAA4F5}Danh Vong{FFFFFF}] Ban nhan duoc $20,000 tien thuong, 3000 EXP Farm va 10 diem Danh vong.");
            format(str, sizeof(str), "{FFFFFF}Chinh xac! Cau da hoan thanh huong dan. Hay bat dau hanh trinh khai thac cua minh.");
            Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Thuong - Danh vong", str, "Ok", "");
            DisablePlayerCheckpoint(playerid);
            return 1;
        }
        else
        {
            new szError[128];
            format(szError, sizeof(szError), "{FF0000}Cau tra loi chua chinh xac. Hay nho lai nhung chuc nang chinh ma toi da de cap!\n\
            {FFFFFF}Hay nhap lai.");
            return Dialog_Show(playerid, DIALOG_HUONGGIANG_QUIZ, DIALOG_STYLE_INPUT, "{8C2ABD}Huong Giang{FFFFFF}: Kiem Tra Kien Thuc (Sai)", szError, "Tra loi", "Huy bo");
        }
    }
    
    fameReadPost[playerid] = 0;
    fameMission_Ready[playerid] = false;
    GameTextForPlayer(playerid, "Nhiem vu da bi huy bo", 3000, 1);
    return 1;
}

Dialog:DIALOG_FAME_SET_MISSION(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        fameReadPost[playerid]++;
        Fame_Accent(playerid);
    }
    else
    {
        fameReadPost[playerid] = 0;
        fameMission_Ready[playerid] = false;
        GameTextForPlayer(playerid, "Nhiem vu that bai", 3000, 1);
    }
    return 1;
}

Dialog:DIALOG_FAME_SET_MSFINAL(playerid, response, listitem, inputtext[])
{

    new i;
    new interacting_npc = -1;
    for(i = 0 ; i < MAX_FAME_NPC ; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[i][0], fameNPC_Pos[i][1], fameNPC_Pos[i][2]))
        {
            interacting_npc = i;
        }
    }

    if(interacting_npc == -1)
    {
        SendClientMessageEx(playerid, COLOR_GRAD3, "** Da co loi xay ra!");
    }

    if(response)
    {
        new str[1024];
        switch(PlayerInfo[playerid][pTut])
        {
            case 29:
            {
                if(interacting_npc == 0) // Jerry
                {
                    if(fameMisson_Task[playerid][0] == 0) fameMisson_Task[playerid][0] = 0;
                    if(!fameMission_Ready[playerid]) fameMission_Ready[playerid] = true;
                    format(str, sizeof(str), "{FFFFFF}Hay giao {FF0000}10 chiec banh {FFFFFF} den nhung can ho co nho thay cho {8C2ABD}Jerry{FFFFFF}\n\
                    - Sau khi hoan thanh hay tro lai va tuong tac voi anh ta, chon Hoan thanh nhiem vu de tu dong hoan thanh.");
                    Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Cot truyen - danh vong", str, "Ok", "");
                    if(CheckPointCheck(playerid)) return 1;
                    else SetPlayerCheckpoint(playerid, -1728.2765,1358.7063,7.1875, 5.0);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAMEMISSION;
                }
            }
            case 30:
            {
                if(interacting_npc == 0) // Jerry
                {
                    if(!fameMission_Ready[playerid]) fameMission_Ready[playerid] = true;
                    format(str, sizeof(str), "{FFFFFF}Hay di den gap NPC {8C2ABD}Richard{FFFFFF} anh ay se cho ban chi dan va mon do ma toi da gui\n\
                    - Nho nhap noi dung ma toi da chi cho ban lam mat ma de anh ay gui do cho ban nhe.");
                    Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Cot truyen - danh vong", str, "Ok", "");
                    if(CheckPointCheck(playerid)) return 1;
                    else SetPlayerCheckpoint(playerid, fameNPC_Pos[1][0], fameNPC_Pos[1][1], fameNPC_Pos[1][2], 5.0);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAMEMISSION;
                }
            }
            case 31:
            {
                if(interacting_npc == 0) // Jerry
                {
                    if(!fameMission_Ready[playerid]) fameMission_Ready[playerid] = true;
                    fameReadPost[playerid] = 0;
                    format(str, sizeof(str),
                        "{FFFFFF}Hay di den gap NPC {8C2ABD}Huong Giang{FFFFFF}, mot nguoi thuong nhan kin tieng va la vo cua Tommy.\n\
                        - Co ay se huong dan ban cach su dung cac dung cu dac biet ma {8C2ABD}Richard{FFFFFF} da trao truoc do.\n\
                        - Khi gap co ay, hay noi rang {8C2ABD}\"Jerry va Richard gui toi den\"{FFFFFF} de co ay biet ban la nguoi duoc gioi thieu."
                    );
                    Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Cot truyen - Danh vong", str, "Ok", "");

                    if(CheckPointCheck(playerid)) return 1;
                    else SetPlayerCheckpoint(playerid, fameNPC_Pos[2][0], fameNPC_Pos[2][1], fameNPC_Pos[2][2], 5.0);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAMEMISSION;
                }
                else if(interacting_npc == 2 && fameMission_Ready[playerid]) // Huong Giang (Reminder)
                {
                    format(str, sizeof(str), "{FFFFFF}Ban da chap nhan nhiem vu {8C2ABD}Huong Giang{FFFFFF}. Hay tuong tac voi co ay (nhan Y) de bat dau phan huong dan.");
                    Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Cot truyen - Danh vong", str, "Ok", "");

                    if(CheckPointCheck(playerid)) return 1;
                    else SetPlayerCheckpoint(playerid, fameNPC_Pos[2][0], fameNPC_Pos[2][1], fameNPC_Pos[2][2], 5.0);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAMEMISSION;
                }
            }
            case 32: // TUT 32: Huong Giang accept mission
            {
                if(interacting_npc == 2) // Huong Giang
                {
                    if(!fameMission_Ready[playerid]) fameMission_Ready[playerid] = true;
                    format(str, sizeof(str), "{FFFFFF}Ban da chap nhan. Hay mo {8C2ABD}Tui Do (H){FFFFFF}, chon {8C2ABD}Ban Do Kho Bau{FFFFFF} va 'Su Dung' de bat dau tim kiem. \n\
                    Nhiem vu yeu cau: {FF0000}mot quang khoang san{FFFFFF}. Sau khi khai thac du, quay lai gap toi de hoan thanh.");
                    Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Cot truyen - Danh vong", str, "Ok", "");
                    
                    DisablePlayerCheckpoint(playerid);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
                }
            }
        }
    }
    return 1;
}

Dialog:DIALOG_FAME_ACCENT(playerid, response, listitem, inputtext[])
{
    if(!response) fameReadPost[playerid] = 0;
    else
    {
        fameReadPost[playerid]++;
        Fame_Accent(playerid);
    }
    return 1;
}

Dialog:DIALOG_FAME_CHOICE(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[124];
        new i;
        new interacting_npc = -1;
        
        for(i = 0 ; i < MAX_FAME_NPC ; i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[i][0], fameNPC_Pos[i][1], fameNPC_Pos[i][2]))
            {
                interacting_npc = i;
                break;
            }
        }
        
        if(interacting_npc == -1) // Should not happen if Y is pressed near an NPC
        {
            format(str, sizeof(str), "{FFFFFF}Chua co nhiem vu gi o NPC nay.");
            return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", str, "Ok","");
        }

        if(strcmp(inputtext, "Lam nhiem vu", true) == 0)
        {
            // The logic inside Fame_Accent will check NPC/Tut/State and display the generic error if no quest step is found.
            fameReadPost[playerid] = 0;
            Fame_Accent(playerid);
        }
        
        else if(strcmp(inputtext, "Hoan thanh nhiem vu", true) == 0)
        {
            switch(PlayerInfo[playerid][pTut])
            {
                case 29:
                {
                    // Validation 1: Must be Jerry
                    if(interacting_npc != 0)
                    {
                        format(str, sizeof(str), "{FFFFFF}Chua co nhiem vu gi o NPC nay.");
                        return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", str, "Ok","");
                    }
                    
                    // Validation 2: Must have accepted the mission
                    if(!fameMission_Ready[playerid])
                    {
                        format(str, sizeof(str), "{FFFFFF}Chua co nhiem vu gi o NPC nay.");
                        return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - danh vong", str, "Ok","");
                    }

                    // Validation 3: Must complete the task count
                    if(fameMisson_Task[playerid][0] < 10)
                    {
                        format(str, sizeof(str), "{FFFFFF}Ban can di giao %d chiec banh nua thi moi du dieu kien hoan thanh nhiem vu", 10 - fameMisson_Task[playerid][0]);
                        return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - danh vong", str, "Ok","");
                    }
                    else // Success
                    {
                        GivePlayerCash(playerid, 15000);
                        GivePlayerEA(playerid, 1250);
                        PlayerData[playerid][pc_FamedPoint] += 10;
                        fameReadPost[playerid] = 0;
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{DAA4F5}Danh Vong{FFFFFF}] Ban nhan duoc $15,000 tien thuong va 1250 EXP Farm.");
                        fameMisson_Task[playerid][0] = 0;
                        GameTextForPlayer(playerid, "Mission Passed!", 3000, 1);
                        PlayerInfo[playerid][pTut]++;
                        fameMission_Ready[playerid] = false;
                        DisablePlayerCheckpoint(playerid);
                    }
                }
                case 30:
                {
                    format(str, sizeof(str), "{FFFFFF}Chua co nhiem vu gi o NPC nay.");
                    return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", str, "Ok", "");
                }
                case 31:
                {
                    format(str, sizeof(str), "{FFFFFF}Chua co nhiem vu gi o NPC nay.");
                    return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", str, "Ok", "");
                }
                case 32: // TUT 32: Complete Huong Giang mission (using index 0)
                {
                    // Validation 1: Must be Huong Giang
                    if(interacting_npc != 2)
                    {
                        format(str, sizeof(str), "{FFFFFF}Chua co nhiem vu gi o NPC nay.");
                        return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - Danh vong", str, "Ok","");
                    }
                    
                    // Validation 2: Must have accepted the mission
                    if(!fameMission_Ready[playerid])
                    {
                        format(str, sizeof(str), "{FFFFFF}Chua co nhiem vu gi o NPC nay.");
                        return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - danh vong", str, "Ok","");
                    }

                    // Validation 3: Must complete the task count (1 unit needed, using index 0)
                    if(fameMisson_Task[playerid][0] < 1)
                    {
                        format(str, sizeof(str), "{FFFFFF}Ban can khai thac thanh cong {FF0000}mot quang khoang san{FFFFFF} (1 don vi) nua moi du dieu kien hoan thanh nhiem vu.");
                        return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Nhiem vu - danh vong", str, "Ok","");
                    }
                    else // Success
                    {
                        GivePlayerCash(playerid, 25000);
                        GivePlayerEA(playerid, 5000);
                        PlayerData[playerid][pc_FamedPoint] += 20;
                        fameReadPost[playerid] = 0;
                        SendClientMessageEx(playerid, COLOR_WHITE, "[{DAA4F5}Danh Vong{FFFFFF}] Ban nhan duoc $25,000 tien thuong, 5000 EXP Farm va 20 diem Danh vong.");
                        fameMisson_Task[playerid][0] = 0; // Reset task progress for this slot
                        GameTextForPlayer(playerid, "Mission Passed!", 3000, 1);
                        PlayerInfo[playerid][pTut]++;
                        fameMission_Ready[playerid] = false;
                        DisablePlayerCheckpoint(playerid);
                    }
                }
            }
        }
    }
    return 1;
}

Dialog:DIALOG_FAME_NPC_FIND(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new str[64];
        format(str, sizeof(str), "[?] Ban da lua chon di den NPC %s.", fameNPC_Name[listitem]);
        SendClientMessageEx(playerid, COLOR_YELLOW, str);

        gFindNPCFame[playerid] = listitem;
        SetPlayerCheckpoint(playerid, fameNPC_Pos[listitem][0], fameNPC_Pos[listitem][1], fameNPC_Pos[listitem][2], 5.0);
        gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAMENPC;
    }
    return 1;
}

Dialog:DIALOG_FAME_TUTORIAL(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(PlayerInfo[playerid][pTut] >= 29)
        {
            if(PlayerInfo[playerid][pTut] == 29) SetPlayerCheckpoint(playerid, fameNPC_Pos[0][0], fameNPC_Pos[0][1], fameNPC_Pos[0][2], 5.0);
            else if(PlayerInfo[playerid][pTut] == 30) SetPlayerCheckpoint(playerid, fameNPC_Pos[0][0], fameNPC_Pos[0][1], fameNPC_Pos[0][2], 5.0);
            else if(PlayerInfo[playerid][pTut] == 31) SetPlayerCheckpoint(playerid, fameNPC_Pos[0][0], fameNPC_Pos[0][1], fameNPC_Pos[0][2], 5.0);
            else if(PlayerInfo[playerid][pTut] == 32) SetPlayerCheckpoint(playerid, fameNPC_Pos[2][0], fameNPC_Pos[2][1], fameNPC_Pos[2][2], 5.0); // Huong Giang for Tut 32
        }
        gPlayerCheckpointStatus[playerid] = CHECKPOINT_FAMEMISSION;
        SendClientMessageEx(playerid, COLOR_GREEN, "** Hay di den dia diem duoc danh dau tren ban do de gap go NPC nhiem vu.");
    }
    return 1;
}

hook OnGameModeInit()
{
    new str[64];
    for(new i = 0 ; i < MAX_FAME_NPC ; i++)
    {
        format(str, sizeof(str), "(%d) NPC %s\nNhan phim Y de tuong tac voi ho.", i, fameNPC_Name[i]);
        CreateDynamic3DTextLabel(str, 0xFFFFFFFF, fameNPC_Pos[i][0], fameNPC_Pos[i][1], fameNPC_Pos[i][2]+0.4, 40.0);
        fameNPC[i] = CreateActor(fameNPC_Model[i], fameNPC_Pos[i][0], fameNPC_Pos[i][1], fameNPC_Pos[i][2], fameNPC_Pos[i][3]);
    }
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    new str[84];
    switch(PlayerInfo[playerid][pTut])
    {
        case 29:
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, -1728.2765,1358.7063,7.1875))
            {
                format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Hay den gan NPC {33CCFF}Pizza Boy{FFFFFF} va nhan nut Y sau do chon {FF0000}Lam nhiem vu{FFFFFF} de lay banh di giao\n\
                Moi luot giao ban duoc + 1 diem hoan thanh nhiem vu, tich luy du {FF0000}10 diem {FFFFFF}hay quay tro lai NPC {8C2ABD}Jerry{FFFFFF} de nhan thuong.");
                DisablePlayerCheckpoint(playerid);
                gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
                return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Huong dan nhiem vu danh vong", szMiscArray, "Ok", "");
            }
        }
        case 30:
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[1][0], fameNPC_Pos[1][1], fameNPC_Pos[1][2]))
            {
                format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Hay den gan NPC {33CCFF}Richard{FFFFFF} va nhan nut Y sau do chon {FF0000}Lam nhiem vu{FFFFFF} de bat dau tuong tac voi anh ta\n\
                Anh ta se cho ban noi ra mat ma cua {8C2ABD}Jerry{FFFFFF} da dua cho ban truoc do, hay lam theo chi dan.");
                DisablePlayerCheckpoint(playerid);
                gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
                return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Huong dan nhiem vu danh vong", szMiscArray, "Ok", "");
            }
        }
        case 31:
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[2][0], fameNPC_Pos[2][1], fameNPC_Pos[2][2]))
            {
                if(fameMission_Ready[playerid])
                {
                    format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Ban da den NPC {33CCFF}Huong Giang{FFFFFF}. Hay tuong tac voi co ay (nhan Y) de hoan tat phan huong dan.");
                    DisablePlayerCheckpoint(playerid);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
                    return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Huong dan nhiem vu danh vong", szMiscArray, "Ok", "");
                }
            }
        }
        case 32:
        {
             if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[2][0], fameNPC_Pos[2][1], fameNPC_Pos[2][2]))
            {
                if(fameMission_Ready[playerid])
                {
                    format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Ban da den NPC {33CCFF}Huong Giang{FFFFFF}. Hay tuong tac voi co ay (nhan Y) de bat dau nhiem vu khai thac.");
                    DisablePlayerCheckpoint(playerid);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
                    return Dialog_Show(playerid, -1, DIALOG_STYLE_MSGBOX, "Huong dan nhiem vu danh vong", szMiscArray, "Ok", "");
                }
            }
        }
    }
    switch(gPlayerCheckpointStatus[playerid])
    {
        case CHECKPOINT_FAMEMISSION:
        {
            new i;
            for(i = 0; i < MAX_FAME_NPC; i++)
            {
                if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[i][0], fameNPC_Pos[i][1], fameNPC_Pos[i][2]))
                {
                    if ((PlayerInfo[playerid][pTut] == 29 && i == 0) ||
                        (PlayerInfo[playerid][pTut] == 30 && i == 0) ||
                        (PlayerInfo[playerid][pTut] == 31 && i == 0) ||
                        (PlayerInfo[playerid][pTut] == 32 && i == 2)) // Huong Giang Check for Tut 32
                    {
                        format(str, sizeof(str), "Ban da den {33CCFF}NPC %s.", fameNPC_Name[i]);
                        SendClientMessageEx(playerid, COLOR_WHITE, str);
                        DisablePlayerCheckpoint(playerid);
                        gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
                        break;
                    }
                }
            }
        }
        case CHECKPOINT_FAMENPC:
        {
            format(str, sizeof(str), "Ban da den {33CCFF}NPC %s.", fameNPC_Name[gFindNPCFame[playerid]]);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
            DisablePlayerCheckpoint(playerid);
            gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_YES))
    {
        for(new i = 0 ; i < MAX_FAME_NPC ; i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, fameNPC_Pos[i][0], fameNPC_Pos[i][1], fameNPC_Pos[i][2]))
            {
                AdvanceFamed_Action(playerid);
                break;
            }
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    gFindNPCFame[playerid] = 0;
    fameReadPost[playerid] = 0;
    fameMission_Ready[playerid] = false;
    new i;
    for(i = 0 ; i < MAX_FAME_PROGRESS ; i++)
    {
        fameMisson_Task[playerid][i] = 0;
    }
    return 1;
}