/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Tutorial System
								Winterfield

				GTA.Network, LLC
	(created by GTA.Network Development Team)
					
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

#include <YSI\y_hooks>

new TutorialTime[MAX_PLAYERS];

AdvanceTutorial(playerid) 
{
	switch(PlayerInfo[playerid][pTut])
	{
		case -1:
		{
			TogglePlayerSpectating(playerid, false);
			SetPlayerPos(playerid, -1704.8635, 1338.0919, 7.1791);
			SetPlayerFacingAngle(playerid, 0);
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetHealth(playerid, 100);
			ClearChatbox(playerid);
		}
		case 0:
		{
			IsSpawned[playerid] = 1;
			ClearChatbox(playerid);
			TogglePlayerSpectating(playerid, 1);

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, playerid + 1);

			InterpolateCameraPos(playerid, 1333.5521, -1388.1493, 67.2808, 1387.4829, -923.4698, 90.6020, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1333.5950, -1387.1521, 67.3258, 1387.7191, -922.5004, 90.4920, 15000, CAMERA_MOVE);

			KillTimer(TutorialTime[playerid]);
			SetPVarInt(playerid, "pTutorialTimer", 15);
			TutorialTime[playerid] = SetTimerEx("TutorialTimer", 1000, true, "i", playerid);
			ShowTutorialDialog(playerid, 0);
		}
		case 1:
		{
			InterpolateCameraPos(playerid, 725.9147, -1610.8770, 3.0359, 734.8999, -1962.6320, -6.3299, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 725.9500, -1611.8734, 3.0057, 734.9311, -1963.6292, -6.5201, 15000, CAMERA_MOVE);

			KillTimer(TutorialTime[playerid]);
			SetPVarInt(playerid, "pTutorialTimer", 15);
			TutorialTime[playerid] = SetTimerEx("TutorialTimer", 1000, true, "i", playerid);
			ShowTutorialDialog(playerid, 1);
		}
		case 2:
		{
			InterpolateCameraPos(playerid, 1104.7491, -1401.8911, 14.6202, 1145.8008, -1471.2203, 27.1695, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1105.5040, -1402.5443, 14.5450, 1145.2341, -1470.3988, 26.7043, 15000, CAMERA_MOVE);

			KillTimer(TutorialTime[playerid]);
			SetPVarInt(playerid, "pTutorialTimer", 15);
			TutorialTime[playerid] = SetTimerEx("TutorialTimer", 1000, true, "i", playerid);
			ShowTutorialDialog(playerid, 2);
		}
		case 3:
		{
			InterpolateCameraPos(playerid, 1517.0358, -1616.2576, 17.8788, 1520.4496, -1715.3738, 18.1261, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1517.4991, -1617.1411, 17.8737, 1521.0973, -1714.6147, 18.0459, 15000, CAMERA_MOVE);

			KillTimer(TutorialTime[playerid]);
			SetPVarInt(playerid, "pTutorialTimer", 15);
			TutorialTime[playerid] = SetTimerEx("TutorialTimer", 1000, true, "i", playerid);
			ShowTutorialDialog(playerid, 3);
		}
		case 4:
		{
			InterpolateCameraPos(playerid, 938.9750, -1324.3108, 14.0205, 1039.5808, -1324.3224, 14.4793, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 939.9739, -1324.3015, 14.0254, 1040.5797, -1324.3134, 14.4891, 15000, CAMERA_MOVE);

			KillTimer(TutorialTime[playerid]);
			SetPVarInt(playerid, "pTutorialTimer", 15);
			TutorialTime[playerid] = SetTimerEx("TutorialTimer", 1000, true, "i", playerid);
			ShowTutorialDialog(playerid, 4);
		}
		case 5:
		{
			InterpolateCameraPos(playerid, 366.2238, -1798.2668, 9.5036, 369.1093, -2030.7736, 8.7837, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 366.3326, -1799.2593, 9.5184, 369.2533, -2031.7618, 8.7687, 15000, CAMERA_MOVE);

			ShowTutorialDialog(playerid, 5);
		}
		case 6 .. 10: ShowTutorialDialog(playerid, PlayerInfo[playerid][pTut]);
		case 11:
		{
			InterpolateCameraPos(playerid, 1457.7699, -870.9628, 63.1767, 1525.9520, -805.8469, 72.9416, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1458.4862, -870.2654, 63.1212, 1526.6012, -805.0862, 72.9162, 15000, CAMERA_MOVE);

			ShowTutorialDialog(playerid, 11);
			SetPlayerInterior(playerid, 0);
		}
		case 12:
		{
			InterpolateCameraPos(playerid, 1569.0149, -1812.5513, 16.1676, 1568.5962, -1889.8837, 13.8242, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1569.0370, -1813.5509, 16.1273, 1568.5488, -1890.8818, 13.7888, 15000, CAMERA_MOVE);

			ShowTutorialDialog(playerid, 12);
		}
		case 13:
		{
			AdjustActor(playerid, 2);
			CharacterCreation(playerid);

			InterpolateCameraPos(playerid, 237.6108, 1822.9670, 7.8454, 224.6772, 1820.0587, 7.6625, 5000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 236.6068, 1822.9495, 7.7454, 223.7760, 1820.5018, 7.6224, 5000, CAMERA_MOVE);
			SetPlayerInterior(playerid, 0);
		}
		case 14: CharacterCreation(playerid);
		case 15:
		{
			if(IsSpawned[playerid] == 0) return 1;
			SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "Nhiem vu : Mua mot chiec xe.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Di den diem danh dau mau do tren radar de chuan bi mua xe nhe.");
			SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");

			SetPlayerCheckpoint(playerid, 1645.9091,-1897.6914,13.5521, 5.0);

		}
		case 16:
		{
			if(IsSpawned[playerid] == 0) return 1;
			SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "Nhiem vu : Bam Y de khoi dong xe va chay den diem danh dau do tren radar.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Di den Ngan Hang diem danh dau do tren radar de rut tien.");
			SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
			SetPlayerCheckpoint(playerid, 1457.0022,-1011.3710,26.8438, 5.0);
		}
		case 17:
		{
			if(IsSpawned[playerid] == 0) return 1;
			SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "Nhiem Vu: Di ra khoi nha bank dung truoc cua bam N de ra ngoai de chuan bi mua dien thoai.");
			SendClientMessageEx(playerid, COLOR_WHITE, "Di den diem danh dau mau do tren ban do de mua dien thoai.");
			SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");

			SetPlayerCheckpoint(playerid, 999.6548,-919.9871,42.3281, 5.0);
		}
		case 18:
		{
			if(IsSpawned[playerid] == 0) return 1;
			SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "Ban da hoan thanh phan huong dan bam phim N gan cua de ra ngoai , Bay gio hay go /map de tim cong viec ban muon lam!");
			SendClientMessageEx(playerid, COLOR_GREY, "Loi khuyen : De kiem nhieu tien hay chon cong viec Pizza hoac Ship Contractor");

			PlayerInfo[playerid][pTut] = -1;
		}
	}
	return 1;
}

CharacterCreation(playerid)
{
	switch(PlayerInfo[playerid][pTut])
	{
		case 13:
		{
			szMiscArray[0] = 0;
			new genderstring[64];

			switch(PlayerInfo[playerid][pSex])
			{
				case 1: genderstring = "Nam";
				case 2: genderstring = "Nu";
				default: genderstring = "Khong xac dinh";
			}

			format(szMiscArray, sizeof(szMiscArray), "Ten:\t%s\n\
				Gioi tinh:\t%s\n\
				Ngay sinh\t%s\n\
				Quoc tinh\t%s\n\
				Giong noi:\t%s\n\
				Trang phuc:\t%i\n\
				Hoan tat",
				GetPlayerNameEx(playerid),
				genderstring,
				PlayerInfo[playerid][pBirthDate],
				GetPlayerNation(playerid),
				GetPlayerAccent(playerid),
				PlayerInfo[playerid][pModel]);
			return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_CREATION, DIALOG_STYLE_TABLIST, "GTA.NETWORK| Tao nhan vat", szMiscArray, "Xac nhan", "");
		}
		case 14: {

			DestroyActor(GetPVarInt(playerid, "pActor"));
			TogglePlayerSpectating(playerid, false);
			SetPlayerPos(playerid, -1704.8635, 1338.0919, 7.1791);
			SetPlayerFacingAngle(playerid, 0);
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetHealth(playerid, 100);
			ClearChatbox(playerid);

			//ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK Huong dan", "Ban co muon lam nhiem vu nguoi choi moi khong?", "Co", "Khong");
			//ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "GTA.NETWORK Huong dan", "Ban hay di lam pizza de kiem tien mua xe", "Ok", "");
		}
	}
	return 1;
}

ShowTutorialDialog(playerid, stage)
{
	new countstring[10];

	if(GetPVarInt(playerid, "pTutorialTimer") == 0) { format(countstring, 10, "Tiep tuc"); }
	else valstr(countstring, GetPVarInt(playerid, "pTutorialTimer"));

	switch(stage)
	{
		case 0:
		{
			if(betaserver == 0) {
				szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
				strcat(szMiscArray, "{7091B8}Welcome to GTA.Network!{FFFFFF}\n\n");
				strcat(szMiscArray, "Chao ban, de di chuyen nhan vat trong tro choi \n");
				strcat(szMiscArray, "Su dung to hop phim W S A D de di chuyen hoac cac phim mui ten len xuong nhe.\n\n");
				strcat(szMiscArray, "Chuot trai de tan cong , chuot phai de nham hoac tuong tac voi NPC .\n\n");
				strcat(szMiscArray, "{FF0000}Bam T hoac phim ` sat ben so 1 de chat va go lenh{FFFFFF}.\n");
				
				strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
				ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.Network - Welcome", szMiscArray, countstring, "");
			}
			else {
				szMiscArray = "{FFFFFF}___________________________________________________________________________________________\n\n\n";
				strcat(szMiscArray, "{7091B8}Welcome to GTA.Network Beta Server!{FFFFFF}\n\n");
				strcat(szMiscArray, "Ban khong can phai xem qua huong dan vui long chon \"Da hieu\" ngay cai nut.\n");
				strcat(szMiscArray, "Ban da duoc dua toi man hinh tao nhan vat .\n\n");
				strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________");
				ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK - Welcome", szMiscArray, "Da hieu", "");
			}
		}
		case 1:
		{
			szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{F69500}CAC PHIM TAT{FFFFFF}\n\n");
			strcat(szMiscArray, "Bam phim Y de khoi dong xe\n");
			strcat(szMiscArray, "Neu ban muon tat dong co hay nhan lai phim Y hoac dung lenh (/car engine)\n\n");
			strcat(szMiscArray, "Bam phim F hoac Enter.\n\n");
			strcat(szMiscArray, "De ra vao trong mot chiec xe hoac cuop xe cua ai do.");
			strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK", szMiscArray, countstring, "");
		}
		case 2:
		{
			szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{F69500}CAC LENH TRO GIUP{FFFFFF}\n\n");
			strcat(szMiscArray, "Trong khi choi, ban se gap nhung van de khong biet vi vay ban hay dung lenh (/newb) de dat cau hoi, se co nguoi giai dap thac mac giup ban.\n\n");
			strcat(szMiscArray, "Ban cung co the su dung lenh (/yeucautrogiup) de duoc gap Advisor va giai dap nhung thac mac chi tiet hon!");
			strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK", szMiscArray, countstring, "");
		}
		case 3:
		{
			szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{F69500}HUONG DAN TIEP THEO{FFFFFF}\n\n");
			strcat(szMiscArray, "Lenh can biet : /timdiadiem.\n\n");
			strcat(szMiscArray, "/Timdiadiem la lenh de ban co the di khap ban do va tim cong viec, dia diem, noi tap trung can thiet de khong bi lac duong.");
			strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK", szMiscArray, countstring, "");
		}
		case 4:
		{
			szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{F69500}CUA HANG{FFFFFF}\n\n");
			strcat(szMiscArray, "Khi bat dau cac ban nen den cua hang 24/7 (/timdiadiem) de mua cho minh 1 chiec dien thoai va danh ba de lien lac.\n\n");
			strcat(szMiscArray, "De ra vao nha, cua hang,... ban su dung phim \"N\" hoac lenh \"/vao\" \"/ra\".");
			strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK", szMiscArray, countstring, "");
		}
		case 5:
		{
			szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{F69500}LOI KET{FFFFFF}\n\n");
			strcat(szMiscArray, "Tui minh da huong dan xong can ban de ban lam quen thao tac trong game.\n\n");
			strcat(szMiscArray, "Hau het trong tro choi ban phai tu tim hieu nhieu tu nguoi choi truoc hoac GTA.Network\n\n");
			strcat(szMiscArray, "Neu ban muon xem lai phan huong dan thi chon \"Xem lai\" neu khong hay chon \"Tiep tuc\" nhe.\n\n");
			strcat(szMiscArray, "{FF0000}Ban muon xem lai khong?{FFFFFF}");
			strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK", szMiscArray, "Tiep tuc", "Xem lai");
		}
		case 6:
		{
			SetPlayerCameraPos(playerid, -2026.9594, -117.1733, 1036.1282);
			SetPlayerCameraLookAt(playerid, -2026.5365, -116.2688, 1035.9733);
			SetPlayerInterior(playerid, 3);

			SendClientMessage(playerid, -1, "Bay gio se la phan tra loi cau hoi , de biet chac rang ban la nguoi Viet Nam!");

			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_LIST, "Thu do nuoc Viet Nam la?", "Lao.\nCampuchia.\n Ha Noi.", "Tiep tuc", "");
		}
		case 7: ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_LIST, "The nao duoc goi la {FF0000}Gamer Chan Chinh?", "Khong gian lan khong tre trau.\nGap ai cung giet.\nDe nguoi khac ra thong ass.", "Tiep tuc", "");
		case 8: ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_LIST, "The nao la {FF0000}Lai Xe An Toan?", "Phong nhanh va lai xe dam vao nguoi khac.\nLay xe de len nguoi khac.\nLai xe dung chieu ben tay phai, den nga tu nga ba di cham.", "Tiep tuc", "");
		case 9: ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_LIST, "Khi nao su dung vu khi {FF0000}hop le?", "Cu thay thang nao ngua mat la ban.\nThay canh sat la muc.\nChi de tu ve khi ai do tan cong minh.", "Tiep tuc", "");
		case 10: ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_LIST, "Ban se lam gi khi thay ai do {FF0000}vi pham?", "Dung cay shotgun ban vao dau no.\nDung chuc nang bao cao cho Admin xu ly.\nQuay tay.", "Tiep tuc", "");
		case 11:
		{
			szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "{F69500}CAC LENH HUU ICH CAN BIET{FFFFFF}\n\n");
			strcat(szMiscArray, "Cac lenh huu ich:\n\n");
			strcat(szMiscArray, "\t{FF0000}/newb{FFFFFF} - Lenh nay dung de dat cau hoi , se co nguoi tra loi!\n");
			strcat(szMiscArray, "\t{FF0000}/baocao{FFFFFF} - Lien lac voi admin de bao cao cac van de gay roi pham luat.\n");
			strcat(szMiscArray, "\t{FF0000}/thongtin{FFFFFF} - De xem thong tin ca nhan cua ban.\n");
			strcat(szMiscArray, "\t{FF0000}/tuido{FFFFFF} - De xem tui do cua ban co nhung gi.\n");
			strcat(szMiscArray, "\t{FF0000}/timdiadiem{FFFFFF} - De xem thong tin vi tri de ban khong bi lac duong (Lenh nay huu ich lam nha)\n");
			strcat(szMiscArray, "\t{FF0000}/trogiup{FFFFFF} - Xem cac lenh can thiet.\n");
			strcat(szMiscArray, "\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK", szMiscArray, "Tiep tuc", "");
		}
		case 12:
		{
			szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n";
			strcat(szMiscArray, "Ban da hoan thanh xong phan huong dan , hi vong ban thuoc long nhung gi da neu , hay bam \"Tiep tuc\" de tiep tuc .\n\n");
			strcat(szMiscArray, "\t{F69521}Nguoi phat trien:\n");
			strcat(szMiscArray, "\t\t{F69521}{FFFFFF}\n\t\t\tRick Tran\n\n");
			strcat(szMiscArray, "\t\t{F69521}Developers{FFFFFF}:\n\
				\t\t\tJesdy\n\
				\t\t\tHien\n\
				\t\t\tDragon\n\
				\t\t\tKelvin\n\
				\t\t\tLeo\n\
				\t\t\tBububai\n\
				\t\t\tZeru\n\
				\t\t{F69500}Cam on cac ban da xem qua{FFFFFF}.\n");
			strcat(szMiscArray, "\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialogEx(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, "GTA.NETWORK- Developers", szMiscArray, "Tiep tuc", "");
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_TUTORIAL:
		{
			switch(PlayerInfo[playerid][pTut])
			{
				case 0 .. 4:
				{
					if(betaserver == 0) {
						if(GetPVarInt(playerid, "pTutorialTimer") != 0) return ShowTutorialDialog(playerid, PlayerInfo[playerid][pTut]);
						else
						{
							PlayerInfo[playerid][pTut]++;
							AdvanceTutorial(playerid);
						}
					} else {
						PlayerInfo[playerid][pTut] = 13;
						AdvanceTutorial(playerid);
					}
				}
				case 5:
				{
					if(!response)
					{
						PlayerInfo[playerid][pTut] = 0;
						AdvanceTutorial(playerid);

						SendClientMessage(playerid, -1, "Ban da quyet dinh xem lai phan huong dan!");
					}
					else
					{
						PlayerInfo[playerid][pTut]++;
						AdvanceTutorial(playerid);
					}
				}
				case 6:
				{
					if(!response) return AdvanceTutorial(playerid);
					switch(listitem)
					{
						case 0, 1:
						{
							PlayerInfo[playerid][pTut] = 0;
							AdvanceTutorial(playerid);

							SendClientMessage(playerid, -1, "Do la cau tra loi sai! Ban da duoc dua toi phan huong dan lan nua.!");
						}
						default:
						{
							PlayerInfo[playerid][pTut]++;
							AdvanceTutorial(playerid);
						}
					}
				}
				case 7:
				{
					if(!response) return AdvanceTutorial(playerid);
					switch(listitem)
					{
						case 1, 2:
						{
							PlayerInfo[playerid][pTut] = 0;
							AdvanceTutorial(playerid);

							SendClientMessage(playerid, -1, "Do la cau tra loi sai! Ban da duoc dua toi phan huong dan lan nua!");
						}
						default:
						{
							PlayerInfo[playerid][pTut]++;
							AdvanceTutorial(playerid);
						}
					}
				}
				case 8:
				{
					if(!response) return AdvanceTutorial(playerid);
					switch(listitem)
					{
						case 0, 1:
						{
							PlayerInfo[playerid][pTut] = 0;
							AdvanceTutorial(playerid);

							SendClientMessage(playerid, -1, "Do la cau tra loi sai! Ban da duoc dua toi phan huong dan lan nua!");
						}
						default:
						{
							PlayerInfo[playerid][pTut]++;
							AdvanceTutorial(playerid);
						}
					}
				}
				case 9:
				{
					if(!response) return AdvanceTutorial(playerid);
					switch(listitem)
					{
						case 0, 1:
						{
							PlayerInfo[playerid][pTut] = 0;
							AdvanceTutorial(playerid);

							SendClientMessage(playerid, -1, "Do la cau tra loi sai! Ban da duoc dua toi phan huong dan lan nua!");
						}
						default:
						{
							PlayerInfo[playerid][pTut]++;
							AdvanceTutorial(playerid);
						}
					}
				}
				case 10:
				{
					if(!response) return AdvanceTutorial(playerid);
					switch(listitem)
					{
						case 0, 2:
						{
							PlayerInfo[playerid][pTut] = 0;
							AdvanceTutorial(playerid);

							SendClientMessage(playerid, -1, "Do la cau tra loi sai! Ban da duoc dua toi phan huong dan lan nua!");
						}
						default:
						{
							PlayerInfo[playerid][pTut]++;
							AdvanceTutorial(playerid);
						}
					}
				}
				case 11, 12:
				{
					PlayerInfo[playerid][pTut]++;
					AdvanceTutorial(playerid);
				}
				case 13: CharacterCreation(playerid);
				case 14:
				{
					if(!response) 
					{
						PlayerInfo[playerid][pTut] = -1;
						DisablePlayerCheckpoint(playerid);
						return SendClientMessageEx(playerid, -1, "Chao mung den voi GTA.Network! Su dung lenh (/trogiup) de xem cac lenh chinh va su dung lenh (/newb) de dat nhung cau hoi thac mac!");
					}
					else
					{
						PlayerInfo[playerid][pTut]++;
						AdvanceTutorial(playerid);
						SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang duoc lam nhiem vu cho nguoi moi. Neu ban khong muon lam nhiem vu huong dan hay go (/huy nvhuongdan) bat ky luc nao de huy.");
					}
				}
			}
		}
		case DIALOG_REGISTER_CREATION:
		{
			if(!response) return CharacterCreation(playerid);
			switch(listitem)
			{
				case 0: return CharacterCreation(playerid);
				case 1: return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "GTA.NETWORK | Chon gioi tinh", "Nam\nNu", "Chon", "Tro ve");
				case 2: return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Chon ngay sinh", "Thang 1\nThang 2\nThang 3\nThang 4\nThang 5\nThang 6\nThang 7\nThang 8\nThang 9\nThang 10\nThang 11\nThang 12", "Chon", "Tro ve");
				case 3: return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_NATION, DIALOG_STYLE_LIST, "GTA.NETWORK | Chon quoc tich", "San Andreas\nNew Robada", "Xac nhan", "Tro ve");
				case 4:
				{
					szMiscArray[0] = 0;
					szMiscArray = "Mac dinh\n\
					Ha Noi\n\
					Da Nang\n\
					Sai Gon \n\
					Han Quoc\n\
					Tau Khua\n\
					Han Xeng\n\
					Sadboiz\n\
					Trau Tre\n\
					Mien Nam\n\
					Mien Bac\n\
					Mien Trung\n\
					Mien Tay\n\
					Gangsta\n\
					Gay\n\
					Bede\n\
					Mr\n\
					Mrs\n\
					Canh Sat\n\
					Bac Si\n\
					Grab\n\
					Taxi\n\
					HotBoy\n\
					HotGirl\n\
					Dang Cap\n\
					An Xin\n\
					Dan Choi\n\
					Super\n\
					Sieu Nhan";
					return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_ACCENT, DIALOG_STYLE_LIST, "GTA.NETWORK Tao nhan vat | Giong noi", szMiscArray, "Chon", "<<");
				}
				case 5:
				{
					if(PlayerInfo[playerid][pSex] == 0) { 
						SendClientMessage(playerid, COLOR_YELLOW, "Vui long chon gioi tinh truoc.");
						return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "GTA.NETWORK Tao nhan vat | Gioi tinh", "Nam\nNu", "Chon", "<<");
					}

               		ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SKIN, DIALOG_STYLE_INPUT, "GTA.NETWORK Tao nhan vat| Trang phuc", "Hay nhap ID Skin cho nhan vat cua ban.", "Chon", "<<");
               	}
				
				case 6:
				{
					if(PlayerInfo[playerid][pSex] == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Vui long chon gioi tinh.");
						return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "GTA.NETWORK Tao nhan vat | Gioi tinh", "Nam\nNu", "Chon", "<<");

					}
					if(strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00") == 0)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Vui long ghi ro ngay sinh.");
						return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Nhan vat sinh vao thang may?", "Thang1\nThang2\nThang3\nThang4\nThang5\nThang6\nThang7\nThang8\nThang9\nThang10\nThang11\nThang12", "Chon", "Tro ve");
					}

					if(PlayerInfo[playerid][pNation] != 0 && PlayerInfo[playerid][pNation] != 1) return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_NATION, DIALOG_STYLE_LIST, "GTA.NETWORK | Nation", "San Andreas\nNew Robada", "Chon", "Tro ve");

					ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Gioi thieu", "Hay nhap ten nguoi gioi thieu ban den voi Server (VD: Rick_Tran)\n\nNeu khong co hay nhan 'Bo qua'.", "Tiep tuc", "Bo qua");
					return 1;
				}
			}
		}
		case DIALOG_REGISTER_SKIN: {

			if(response && !isnull(inputtext) && IsNumeric(inputtext) && IsValidSkin(strval(inputtext))) {

			    PlayerInfo[playerid][pModel] = strval(inputtext);
				AdjustActor(playerid, strval(inputtext));
			}
			CharacterCreation(playerid);
		}
		case DIALOG_REGISTER_SEX:
	    {
		    if(response)
		    {
			    if(listitem == 0) {
					PlayerInfo[playerid][pSex] = 1;
					PlayerInfo[playerid][pModel] = 2;
					AdjustActor(playerid, 2);
					SendClientMessage(playerid, COLOR_YELLOW2, "Ok, ban la gioi tinh nam!");
					CharacterCreation(playerid);
				}
				else if(listitem == 1) {
					PlayerInfo[playerid][pSex] = 2;
					PlayerInfo[playerid][pModel] = 91;
					AdjustActor(playerid, 91);
					SendClientMessage(playerid, COLOR_YELLOW2, "Ok, ban la gioi tinh nu!");
					CharacterCreation(playerid);
				}
			}
			else ShowPlayerDialogEx(playerid, DIALOG_REGISTER_SEX, DIALOG_STYLE_LIST, "{FF0000}Nhan vat cua ban la Nam hay Nu?", "Nam\nNu", "Dong y", "");
		}
		case DIALOG_REGISTER_NATION: 
		{
			if(response) 
			{
				PlayerInfo[playerid][pNation] = listitem;
				switch(listitem) 
				{
					case 0: SendClientMessageEx(playerid, COLOR_GRAD1, "Bay gio ban da la cong dan cua San Andreas.");
					case 1: SendClientMessageEx(playerid, COLOR_GRAD1, "Bay gio ban da la cong dan cua New Robada.");
				}
			}
			CharacterCreation(playerid);
		}
		case DIALOG_REGISTER_MONTH:
	    {
			if(response)
			{
				szMiscArray[0] = 0;
				new month = listitem+1;
				SetPVarInt(playerid, "RegisterMonth", month);

				new lastdate;
				if(listitem == 0 || listitem == 2 || listitem == 4 || listitem == 6 || listitem == 7 || listitem == 9 || listitem == 11) lastdate = 32;
				else if(listitem == 3 || listitem == 5 || listitem == 8 || listitem == 10) lastdate = 31;
				else lastdate = 29;
				for(new x = 1; x < lastdate; x++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s%d\n", szMiscArray, x);
				}
				ShowPlayerDialogEx(playerid, DIALOG_REGISTER_DAY, DIALOG_STYLE_LIST, "{FF0000}Nhan vat cua ban sinh ngay bao nhieu?", szMiscArray, "Dong y", "");
			}
			else return CharacterCreation(playerid);
		}
		case DIALOG_REGISTER_DAY:
	    {
	    	szMiscArray[0] = 0;
			if(response)
			{
				new setday = listitem+1;
				SetPVarInt(playerid, "RegisterDay", setday);

				new month, day, year;
				getdate(year,month,day);
				new startyear = year-100;
				for(new x = startyear; x < year; x++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s%d\n", szMiscArray, x);
				}
				ShowPlayerDialogEx(playerid, DIALOG_REGISTER_YEAR, DIALOG_STYLE_LIST, "{FF0000}Nhan vat cua ban sinh nam bao nhieu?", szMiscArray, "Dong y", "");
			}
			else ShowPlayerDialogEx(playerid, DIALOG_REGISTER_MONTH, DIALOG_STYLE_LIST, "{FF0000}Nhan vat cua ban sinh thang may?", "Thang1\nThang2\nThang3\nThang4\nThang5\nThang6\nThang7\nThang8\nThang9\nThang10\nThang11\nThang12", "Dong y", "");
		}
		case DIALOG_REGISTER_YEAR:
	    {
	    	szMiscArray[0] = 0;
			new month, day, year;
			getdate(year,month,day);
			new startyear = year-100;
			if(response)
			{
				new setyear = listitem+startyear;
				format(PlayerInfo[playerid][pBirthDate], 11, "%d-%02d-%02d", setyear, GetPVarInt(playerid, "RegisterMonth"), GetPVarInt(playerid, "RegisterDay"));
				DeletePVar(playerid, "RegisterMonth");
				DeletePVar(playerid, "RegisterDay");
				SendClientMessage(playerid, COLOR_LIGHTRED, "Ngay sinh cua ban da duoc dat thanh cong.");
				return CharacterCreation(playerid);
			}
			else
			{
				for(new x = startyear; x < year; x++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s%d\n", szMiscArray, x);
				}
				ShowPlayerDialogEx(playerid, DIALOG_REGISTER_YEAR, DIALOG_STYLE_LIST, "{FF0000}Nguoi choi cua ban sinh nam may?", szMiscArray, "Dong y", "");
			}
		}
		case DIALOG_REGISTER_ACCENT:
		{
			if(response)
			{
				if(listitem == 0) PlayerInfo[playerid][pAccent] = listitem;
				if(listitem > 0) PlayerInfo[playerid][pAccent] = listitem+1;
			}
			return CharacterCreation(playerid);
		}
		case DIALOG_REGISTER_REFERRED:
		{
		    if(response)
		    {
		        if(IsNumeric(inputtext))
		        {
		            ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
				}
				if(strfind(inputtext, "_", true) == -1)
				{
				    ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
		            return 1;
		        }
		        if(strlen(inputtext) > 20)
		        {
		            ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That name is too long\nPlease shorten the name.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
		        if(strcmp(inputtext, GetPlayerNameExt(playerid), true) == 0)
		        {
		            ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error", "You can't add yourself as a referrer.\nPlease enter the referrer name or press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
		            return 1;
		        }
				for(new sz = 0; sz < strlen(inputtext); sz++)
				{
				    if(inputtext[sz] == ' ')
				    {
					    ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
			            return 1;
			        }
			    }
			  	mysql_escape_string(inputtext, szMiscArray);
                format(PlayerInfo[playerid][pReferredBy], MAX_PLAYER_NAME, "%s", szMiscArray);
                mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `Username` FROM `accounts` WHERE `Username` = '%e'", inputtext);
         		mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "iii", MAIN_REFERRAL_THREAD, playerid, g_arrQueryHandle{playerid});
			}
			else
			{
			    format(szMiscArray, sizeof(szMiscArray), "Nobody");
				strmid(PlayerInfo[playerid][pReferredBy], szMiscArray, 0, strlen(szMiscArray), MAX_PLAYER_NAME);
				PlayerInfo[playerid][pTut] = 14;
				AdvanceTutorial(playerid);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Cam on ban da dien day du thong tin!");
			}
		}
	}
	return 0;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerInfo[playerid][pTut] >= 0)
	{
		switch(PlayerInfo[playerid][pTut])
		{
			case 15:
			{
				DisablePlayerCheckpoint(playerid);
				SendClientMessage(playerid, COLOR_WHITE, "Vao bat cu xe nao ma ban co the mua duoc no voi gia tien hop ly!");
			}
			case 16:
			{
				DisablePlayerCheckpoint(playerid);
				SendClientMessage(playerid, COLOR_WHITE, "De vao duoc ben trong bam phim N, sau do bam chuot phai de nham' vao nhan vien ngan hang roi sau do bam Y tuong tac!");
			}
			case 17:
			{
				DisablePlayerCheckpoint(playerid);
				SendClientMessage(playerid, COLOR_WHITE, "Vao trong 24/7 bang phim N vao trong mua dien thoai bang /mua.");
			}
		}
	}
}

forward AdjustActor(playerid, skinid);
public AdjustActor(playerid, skinid) 
{
	new id;
	if(PlayerInfo[playerid][pTut] == 13 && GetPVarType(playerid, "pActor")) 
	{
		id = GetPVarInt(playerid, "pActor");
		if(IsValidActor(id)) DestroyActor(id);
	}

	id = CreateActor(skinid, 221.1730, 1823.6620, 7.5124, 270.0);
	SetPVarInt(playerid, "pActor", id);
	SetActorVirtualWorld(id, playerid + 1);
	SetPlayerSkin(playerid, skinid);
	return 1;
}

forward TutorialTimer(playerid);
public TutorialTimer(playerid)
{
	if(GetPVarInt(playerid, "pTutorialTimer") > 0) 
	{
		SetPVarInt(playerid, "pTutorialTimer", GetPVarInt(playerid, "pTutorialTimer") - 1);
		ShowTutorialDialog(playerid, PlayerInfo[playerid][pTut]);
	}
	else KillTimer(TutorialTime[playerid]);
	return 1;
}

GetPlayerAccent(iPlayerID) 
{
	new accent[64];
	switch(PlayerInfo[iPlayerID][pAccent]) 	
	{
		case 0, 1: accent = "";
		case 2: accent = "Ha Noi";
		case 3: accent = "Da Nang";
		case 4: accent = "Sai Gon";
		case 5: accent = "Han Quoc";
		case 6: accent = "Tau Khua";
		case 7: accent = "Han Xeng";
		case 8: accent = "Sadboiz";
		case 9: accent = "Trau Tre";
		case 10: accent = "Mien Nam";
		case 11: accent = "Mien Bac";
		case 12: accent = "Mien Trung";
		case 13: accent = "Mien Tay";
		case 14: accent = "Gangsta";
		case 15: accent = "Gay";
		case 16: accent = "Bede";
		case 17: accent = "Mr";
		case 18: accent = "Mrs";
		case 19: accent = "Police";
		case 20: accent = "Doctor";
		case 21: accent = "Grab";
		case 22: accent = "Taxi";
		case 23: accent = "HotBoy";
		case 24: accent = "HotGirl";
		case 25: accent = "Dang Cap";
		case 26: accent = "An Xin";
		case 27: accent = "Dan Choi";
		case 28: accent = "Super";
		case 29: accent = "Sieu Nhan";
		case 2003: accent = "{5f773f}Old Member{FFFFFF}";
		case 2013: accent = "{037899}RGVN{FFFFFF}";
		case 2019: accent = "{ffe900}GTA-NETWORK{FFFFFF}";
		case 1319: accent = "{59a6ff}Admin{FFFFFF}";
	}
	return accent;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(GetPVarType(playerid, "pActor")) DestroyActor(GetPVarInt(playerid, "pActor"));
	return 1;
}

CMD:forcetutorial(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		new id;
		if(sscanf(params, "u", id)) return SendClientMessageEx(playerid, COLOR_WHITE, "SYNTAX: /forcetutorial [playerid]");

		if(IsPlayerConnected(id))
		{
			szMiscArray[0] = 0;
			switch(PlayerInfo[id][pTut])
			{
				case 0 .. 12:
				{
					PlayerInfo[id][pTut] = 13;
					AdvanceTutorial(id);

					format(szMiscArray, 128, "You have sent %s to the Character Creation Menu.", GetPlayerNameEx(id));
					SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, 128, "Administrator %s has sent you to the Character Creation Menu.", GetPlayerNameEx(playerid));
					SendClientMessage(id, COLOR_WHITE, szMiscArray);
				}
				case 13: return SendClientMessage(playerid, COLOR_WHITE, "This player is currently in the character creation menu, please wait.");
				case 14 .. 18:
				{
					PlayerInfo[id][pTut] = -1;
					AdvanceTutorial(id);

					format(szMiscArray, 128, "You have forced %s out of the tutorial.", GetPlayerNameEx(id));
					SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
					format(szMiscArray, 128, "Administrator %s has forced you out of the tutorial.", GetPlayerNameEx(playerid));
					SendClientMessage(id, COLOR_WHITE, szMiscArray);
				}
				default: return SendClientMessage(playerid, COLOR_WHITE, "This player is not in the tutorial.");
			}
		}
		else return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	}
	else SendClientMessage(playerid, COLOR_WHITE, "Ban khong phai lauthorized to perform this command!");
	return 1;
}
