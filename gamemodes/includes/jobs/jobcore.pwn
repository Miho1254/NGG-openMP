/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Job System Core

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

stock SendJobMessage(job, color, string[])
{
	foreach(new i: Player)
	{
		if(((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job || PlayerInfo[i][pJob3] == job) && JobDuty[i] == 1) || ((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job || PlayerInfo[i][pJob3] == job) && (job == 7 && GetPVarInt(i, "MechanicDuty") == 1) || (job == 2 && GetPVarInt(i, "LawyerDuty") == 1))) {
			SendClientMessageEx(i, color, string);
		}
	}
}

/*
stock GetJobName(job)
{
	new name[20];
	switch(job)
	{
		case 1: name = "Detective";
		case 2: name = "Lawyer";
		case 3: name = "Whore";
		case 4: name = "Drugs Dealer";
		case 6: name = "News Reporter";
		case 7: name = "Car Mechanic";
		case 8: name = "Bodyguard";
		case 9: name = "Arms Dealer";
		case 10: name = "Car Dealer";
		case 12: name = "Boxer";
		case 14: name = "Drug Smuggler";
		case 15: name = "Paper Boy";
		case 16: name = "Trucker";
		case 17: name = "Taxi Driver";
		case 18: name = "Craftsman";
		case 19: name = "Bartender";
		case 20: name = "Trucker";
		case 21: name = "Pizza Boy";
		default: name = "None";
	}
	return name;
}
*/

stock GetJobLevel(playerid, job)
{
	new jlevel;
	switch(job)
	{
		case 1:
		{
			new skilllevel = PlayerInfo[playerid][pDetSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 2:
		{
			new skilllevel = PlayerInfo[playerid][pLawSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 3:
		{
			new skilllevel = PlayerInfo[playerid][pSexSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 7:
		{
			new skilllevel = PlayerInfo[playerid][pMechSkill];
			if(skilllevel >= 0 && skilllevel < 100) jlevel = 1;
			else if(skilllevel >= 100 && skilllevel < 300) jlevel = 2;
			else if(skilllevel >= 300 && skilllevel < 500) jlevel = 3;
			else if(skilllevel >= 500 && skilllevel < 700) jlevel = 4;
			else if(skilllevel >= 700) jlevel = 5;
		}
		case 9:
		{
			new skilllevel = PlayerInfo[playerid][pArmsSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 200) jlevel = 2;
			else if(skilllevel >= 200 && skilllevel < 700) jlevel = 3;
			else if(skilllevel >= 700 && skilllevel < 1200) jlevel = 4;
			else if(skilllevel >= 1200) jlevel = 5;
		}
		case 12:
		{
			new skilllevel = PlayerInfo[playerid][pBoxSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 14:
		{
			new skilllevel = PlayerInfo[playerid][pDrugSmuggler];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 20:
		{
			new skilllevel = PlayerInfo[playerid][pTruckSkill];
			if(skilllevel >= 0 && skilllevel < 100) jlevel = 1;
			else if(skilllevel >= 100 && skilllevel < 400) jlevel = 2;
			else if(skilllevel >= 400 && skilllevel < 1600) jlevel = 3;
			else if(skilllevel >= 1600 && skilllevel < 6400) jlevel = 4;
			else if(skilllevel >= 6400) jlevel = 5;
		}
		case 22:
		{
			new skilllevel = PlayerInfo[playerid][pTreasureSkill];
			if(skilllevel >= 0 && skilllevel <= 24) jlevel = 1;
			else if(skilllevel >= 25 && skilllevel <= 149) jlevel = 2;
			else if(skilllevel >= 150 && skilllevel <= 299) jlevel = 3;
			else if(skilllevel >= 300 && skilllevel <= 599) jlevel = 4;
			else if(skilllevel >= 600) jlevel = 5;
		}
	}
	return jlevel;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case JOBHELPMENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: //Detective
					{
						ShowPlayerDialogEx(playerid, DETECTIVEJOB, DIALOG_STYLE_MSGBOX, "Tham tu", "Thong tin:\n\nCong viec nay giup ban co the dinh vi moi nguoi o quanh thanh pho.\nNo se cho ban biet duoc vi tri cuoi cung cua muc tieu va danh dau vi tri do.", "Tiep tuc", "Huy");
					}
					case 1: //Lawyer
					{
						ShowPlayerDialogEx(playerid, LAWYERJOB, DIALOG_STYLE_MSGBOX, "Luat su", "Thong tin:\n\nCong viec nay ban co the xoa truy na cho nhung toi pham.\nDay la mot cong viec hop phap va ban se khong bi gi lien quan den phap luat.", "Tiep tuc", "Huy");
					}
					case 2: //Whore
					{
						ShowPlayerDialogEx(playerid, WHOREJOB, DIALOG_STYLE_MSGBOX, "Gai diem", "Thong tin:\n\nCong viec nay giup mang lai niem vui cho khach hang va ban se duoc tra cho mot so tien.", "Tiep tuc", "Huy");
					}
					case 3: //Drug Dealer
					{
						ShowPlayerDialogEx(playerid, DRUGDEALERJOB, DIALOG_STYLE_MSGBOX, "Ban thuoc phien", "Thong tin:\n\nCong viec nay co the duoc su dung de ban thuoc phien cho khach hang.\nNo co ich khi nang o cap do cao (/kynang).", "Tiep tuc", "Huy");
					}
					case 4: //Mechanic
					{
						ShowPlayerDialogEx(playerid, MECHANICJOB, DIALOG_STYLE_MSGBOX, "Tho sua xe", "Thong tin:\n\nCong viec nay ban co the sua chua xe & do xang cho nguoi khac.", "Tiep tuc", "Huy");
					}
					case 5: //Bodyguard
					{
						ShowPlayerDialogEx(playerid, BODYGUARDJOB, DIALOG_STYLE_MSGBOX, "Ve si", "Thong tin:\n\nCong viec nay ban co the cung cap cho khach hang 1 nua giap (50 giap).\n", "Tiep tuc", "Huy");
					}
					case 6: //Arms Dealer
					{
						ShowPlayerDialogEx(playerid, ARMSDEALERJOB, DIALOG_STYLE_MSGBOX, "Ban vu khi", "Thong tin:\n\nCong viec nay ban co the che tao vu khi cho chinh minh hoac nguoi choi khac.\nCong viec nay dem lai loi nhuan cao khi dat cap do cao (/kynang)", "Tiep tuc", "Huy");
					}
					case 7: //Taxi Driver
					{
						ShowPlayerDialogEx(playerid, TAXIJOB, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Thong tin:\n\nCong viec nay ban co the cho hang khach di den noi khach yeu cau($1 - $500 / 16 giay).\nHay can than nhung nguoi cuop xe cua ban!", "Tiep tuc", "Huy");
					}
					case 8: //Drug Smuggling
					{
						ShowPlayerDialogEx(playerid, SMUGGLEJOB, DIALOG_STYLE_MSGBOX, "Van chuyen thuoc phien", "Thong tin:\n\nThis job can be used to keep Crack and Cannabis filled in the Crack Lab.\nThis job is very profitable as people usually buy crack and Cannabis, and sometimes they try to steal your Cannabis and crack.\nThis is an ilegal job and you can get busted for doing it.", "Next", "Cancel");
					}
					case 9: //Craftsman
					{
						ShowPlayerDialogEx(playerid, CRAFTJOB, DIALOG_STYLE_MSGBOX, "Tho thu cong", "Thong tin:\nCong viec nay co the che nhung vat pham thu cong.\nCong viec nay rat co loi vi moi nguoi rat can nhung thu ban co the che tao.\n\nLenh:\n/layvatlieu /chetao", "Ok", "Huy");
					}
					case 10: //Bartender
					{
						ShowPlayerDialogEx(playerid, BARTENDERJOB, DIALOG_STYLE_MSGBOX, "Bartender", "Thong tin:\nThis job can be used to sell drinks to other players.\nThis is a legal job and you can not get busted for doing it.\n\nCommands:\n/selldrink\nLocation of job: This job can be obtained in Idlewood inside the Alhambra Club, at the job icon(yellow i).", "Done", "Cancel");
					}
					case 11: //Trucker
					{
						ShowPlayerDialogEx(playerid, TRUCKERJOB, DIALOG_STYLE_MSGBOX, "Trucker","Thong tin:\nCong viec nay co the kiem tien bang cach giao hang.\nNgoai ra ban se nhan duoc 25 phan tram tien thuong neu giao hang bat hop phap. Nhung hay can than canh sat.\n\nLenh:\n/layhang /kiemtrahang /cuophang", "Ok", "Huy");
					}
					case 12: //Pizza Boy
					{
						ShowPlayerDialogEx(playerid, PIZZAJOB, DIALOG_STYLE_MSGBOX, "Pizza Boy","Thong tin:\nCong viec nay co the kiem tien bang cach giao nhung chiec banh pizza cho khach.\n Neu ban giao nhanh thi se cang duoc nhieu tien.\n\nLenh:\n/laybanh.", "Ok", "Huy");
					}
				}
			}
		}
		case SMUGGLEJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, SMUGGLEJOB3, DIALOG_STYLE_MSGBOX, "Van chuyen thuoc phien", "Lenh:\n\n/getdrugs", "Ok", "Huy");
			}
		}
		case SMUGGLEJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, SMUGGLEJOB2, DIALOG_STYLE_MSGBOX, "Van chuyen thuoc phien", "Ghi nho: Khi giao khong gioi han thoi gian. Cap do cong viec cang cao thi tien se tang (/kynang)", "Tiep tuc", "Huy");
			}
		}
		case TAXIJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, TAXIJOB2, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Ghi nho: Khi nhan cuoc, khong gioi han thoi gian den vi tri cua khach hang. Cong viec nay khong co cap do va tien se theo quang duong ma ban di.", "Tiep tuc", "Huy");
			}
		}
		case TAXIJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, TAXIJOB3, DIALOG_STYLE_MSGBOX, "Taxi Driver", "Lenh:\n\n/fare.", "Done", "Cancel");
			}
		}
		case BOXERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, BOXERJOB3, DIALOG_STYLE_MSGBOX, "Boxer", "Lenh:\n\n/fight, /boxstats\n\nLocation of job: This job can be obtained inside the Ganton Gym, at the job icon(yellow circle).", "Done", "Cancel");
			}
		}
		case BOXERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, BOXERJOB2, DIALOG_STYLE_MSGBOX, "Boxer", "Note: There is no reload time for boxing and you don't need to level it up to box people in the gym. There are 3 levels for this job.\n\nLevel 1: Beginner Boxer.\nLevel 2: Amateur Boxer.\nLevel 3: Professional Boxer.", "Next", "Cancel");
			}
		}
		case ARMSDEALERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, ARMSDEALERJOB2, DIALOG_STYLE_MSGBOX, "Ban vu khi", "Ghi nho: Thoi gian che tao vu khi cach nhau 10 giay.\n\nKy nang:\n\nCap do 1: Flowers, Knuckles, SDPistol, 9mm, va Shotgun.\nCap do 2: Baseball Bat, Cane, MP5, va Rifle.\nCap do 3: Shovel va Deagle.\nCap do 4: Poolcue va Golf Club.\nCap do 5: Katana, Dildo, UZI va TEC9.\nGold VIP: AK-47", "Tiep tuc", "Huy");
			}
		}
		case ARMSDEALERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, ARMSDEALERJOB3, DIALOG_STYLE_MSGBOX, "Ban vu khi", "Lenh:\n\n/layvatlieu, /banvukhi", "Ok", "Huy");
			}
		}
		case BODYGUARDJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, BODYGUARDJOB3, DIALOG_STYLE_MSGBOX, "Ve si", "Commands:\n\n/bangiap [player] [gia $2000 - $10000]\n/lucsoat [player]", "Ok", "Huy");
			}
		}
		case MECHANICJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, MECHANICJOB3, DIALOG_STYLE_MSGBOX, "Tho sua xe", "Lenh:\n\n/fix, /suaxe, /doxang, /mechduty", "Ok", "Huy");
			}
		}
		case DRUGDEALERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, DRUGDEALERJOB2, DIALOG_STYLE_MSGBOX, "Buon thuoc phien", "Ky nang:\n\nCap do 1: Ban co the giu duoc 10 Pot va 5 Crack\nCap do 2: Ban co the giu duoc 20 Pot va 15 Crack\nCap do 3: Ban co the giu duoc 30 Pot va 15 Crack\nCap do 4: Ban co the giu duoc 40 Pot va 20 Crack\nCap do 5: Ban co the giu duoc 50 Pot va 25 Crack", "Tiep tuc", "Huy");
			}
		}
		case DRUGDEALERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, DRUGDEALERJOB3, DIALOG_STYLE_MSGBOX, "Buonthuocphien", "Commands:\n\n/sell, /thuoccuatoi, /sudungthuoc, /muapot, /muaopium, /trongpot, /trongopium, /thuhoach, /kiemtrathuoc, /chetaoheroin", "Ok", "Huy");
			}
		}
		case WHOREJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, WHOREJOB3, DIALOG_STYLE_MSGBOX, "Gai diem", "Lenh:\n\n/sex", "Ok", "Huy");
			}
		}
		case LAWYERJOB2:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, LAWYERJOB3, DIALOG_STYLE_MSGBOX, "Luat su", "Lenh:\n\n/defend, /free, /truyna, /lawyerduty, /offerappeal, /finishappeal", "Ok", "Huy");
			}
		}
		case LAWYERJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, LAWYERJOB2, DIALOG_STYLE_MSGBOX, "Luat su", "Ghi nho: Thoi gian bao lanh cach nhau 2 phut, bat ki cap do nao cung vay.\n\nKy nang:\n\nCap do 1: Ban co the giam an tu cho khach hang 1 phut.\nCap do 2: Ban co the giam an tu cho khach hang 2 phut.\nCap do 3: Ban co the giam an tu cho khach hang 3 phut.\nCap do 4: Ban co the giam an tu cho khach hang 4 phut.\nCap do 5: Ban co the giam an tu cho khach hang 5 phut.", "Tiep tuc", "Huy");
			}
		}
		case DETECTIVEJOB:
		{
			if(response)
			{
				ShowPlayerDialogEx(playerid, DETECTIVEJOB2, DIALOG_STYLE_MSGBOX, "Tham tu", "Ky nang:\n\nCap do 1: Ban co the tim ai do trong 3 giay va tim lai sau 2 phut.\nCap do 2: Ban co the tim ai do trong 5 giay va tim lai sau 1 phut 20 giay.\nCap do 3: Ban co the tim ai do trong 7 giay va tim lai sau 1 phut.\nCap do 4: Ban co the tim ai do trong 9 giay va tim lai sau 30 giay.\nCap do 5: Ban co the tim ai do trong 11 giay va tim lai sau 20 giay.\nLenh: /trace", "Ok", "Huy");
			}
		}
	}
	return 0;
}

CMD:join(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this while being inside chiec xe.");
	if(GetPlayerState(playerid) == 1 && PlayerInfo[playerid][pJob] == 0 || (PlayerInfo[playerid][pJob2] == 0 && (PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0)) || (PlayerInfo[playerid][pJob3] == 0 && PlayerInfo[playerid][pDonateRank] >= 3)) {
		if(IsPlayerInRangeOfPoint(playerid,3.0,251.99, 117.36, 1003.22) || IsPlayerInRangeOfPoint(playerid,3.0, 1478.9515, -1755.7147, 3285.2859) || IsPlayerInRangeOfPoint(playerid,3.0,301.042633, 178.700408, 1007.171875) || IsPlayerInRangeOfPoint(playerid,3.0,-1385.6786,2625.6636,55.5572)) {
			if(PlayerInfo[playerid][pJob] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Detective, Go lenh /chapnhan job.");
				GettingJob[playerid] = 1;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Detective, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 1;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Detective, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 1;
				return 1;
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1469.5247, -1755.7039, 3285.2859)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Lawyer, Go lenh /chapnhan job.");
				GettingJob[playerid] = 2;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Lawyer, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 2;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Lawyer, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 2;
				return 1;
			}
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,1215.1304,-11.8431,1000.9219)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Whore, Go lenh /chapnhan job.");
				GettingJob[playerid] = 3;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Whore, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 3;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Whore, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 3;
				return 1;
			}
		}
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,2166.3772,-1675.3829,15.0859) || IsPlayerInRangeOfPoint(playerid,3.0,-2089.344970, 87.800231, 35.320312) || IsPlayerInRangeOfPoint(playerid,3.0,-1528.0924,2688.7837,55.8359)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Drug Dealer, Go lenh /accept job.");
				GettingJob[playerid] = 4;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Drug Dealer, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 4;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Drug Dealer, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 4;
				return 1;
			}
		}*/
		else if (IsPlayerInRangeOfPoint(playerid,3.0,161.92, -25.70, 1.57) || IsPlayerInRangeOfPoint(playerid,3.0,-2032.601928, 143.866592, 28.835937) || IsPlayerInRangeOfPoint(playerid,3.0,-1475.4224,1877.3550,32.6328) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2279.8159, 4.8137)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Mechanic, Go lenh /chapnhan job.");
				GettingJob[playerid] = 7;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Mechanic, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 7;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Mechanic, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 7;
				return 1;
			}
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,1224.13, 267.98, 19.55) || IsPlayerInRangeOfPoint(playerid,3.0,-2269.256103, -158.054321, 35.320312) || IsPlayerInRangeOfPoint(playerid,3.0,2226.1716,-1718.1792,13.5165) || IsPlayerInRangeOfPoint(playerid,3.0,1099.73,-1504.67,15.800) || IsPlayerInRangeOfPoint(playerid,3.0,-821.3508,1574.9393,27.1172) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2293.3923, 4.8137)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Bodyguard, Go lenh /chapnhan job.");
				GettingJob[playerid] = 8;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Bodyguard, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 8;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Bodyguard, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 8;
				return 1;
			}
		}
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,1366.4325,-1275.2096,13.5469) || IsPlayerInRangeOfPoint(playerid,3.0,-2623.333984, 209.235931, 4.684767) || IsPlayerInRangeOfPoint(playerid,3.0,-1513.4904,2614.3591,55.8078)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh motn Arms Dealer, Go lenh /accept job.");
				GettingJob[playerid] = 9;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh motn Arms Dealer, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 9;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh motn Arms Dealer, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 9;
				return 1;
			}
		}*/
		/*else if (PlayerInfo[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid,3.0,531.7930,-1292.4044,17.2422)) {
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Car Dealer, Go lenh /accept job.");
			GettingJob[playerid] = 10;
			return 1;
		}*/
		else if (IsPlayerInRangeOfPoint(playerid,3.0,766.0804,14.5133,1000.7004) || IsPlayerInRangeOfPoint(playerid,3.0,758.98, -60.32, 1000.78)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Boxer, Go lenh /chapnhan job.");
				GettingJob[playerid] = 12;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Boxer, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 12;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Boxer, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 12;
				return 1;
			}
		}
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,2354.2808,-1169.2959,28.0066) || IsPlayerInRangeOfPoint(playerid,3.0,-2630.7375,2349.3994,8.4892)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Drug Smuggler, Go lenh /accept job.");
				GettingJob[playerid] = 14;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Drug Smuggler, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 14;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Drug Smuggler, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 14;
				return 1;
			}
		}*/
		/*else if (PlayerInfo[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid,3.0,-2040.9436,456.2395,35.1719)) {
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Paper Boy, Go lenh /accept job.");
			GettingJob[playerid] = 15;
			return 1;
		}*/
		/*else if (PlayerInfo[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid,3.0,-77.7288,-1136.3896,1.0781)) {
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Trucker, Go lenh /accept job.");
			GettingJob[playerid] = 16;
			return 1;
		}*/
		/*else if (IsPlayerInRangeOfPoint(playerid,3.0,1741.5199,-1863.4615,13.5750) || IsPlayerInRangeOfPoint(playerid,3.0,-1981.144775, 133.063293, 27.687500)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Taxi Driver, Go lenh /accept job.");
				GettingJob[playerid] = 17;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Taxi Driver, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 17;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Taxi Driver, Go lenh /accept job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 17;
				return 1;
			}
		}*/
		else if (IsPlayerInRangeOfPoint(playerid,3.0,2195.8335,-1973.0638,13.5589) || IsPlayerInRangeOfPoint(playerid,3.0,-1356.7195,2065.3450,52.4677) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2246.2598, 4.8137)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Craftsman, Go lenh /chapnhan job.");
				GettingJob[playerid] = 18;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Craftsman, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 18;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Craftsman, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 18;
				return 1;
			}
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,502.6696,-11.6603,1000.6797) || IsPlayerInRangeOfPoint(playerid,3.0,-864.3550,1536.9703,22.5870)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Bartender, Go lenh /chapnhan job.");
				GettingJob[playerid] = 19;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Bartender, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 19;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Bartender, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 19;
				return 1;
			}
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,-1560.963867, 127.491157, 3.554687) || IsPlayerInRangeOfPoint(playerid,3.0,-2412.5095, 2240.7227, 4.8137)) {
			if(PlayerInfo[playerid][pLevel] >= 2)
			{
				if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Trucker, Go lenh /chapnhan job.");
				GettingJob[playerid] = 20;
				return 1;
				}
				if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Trucker, Go lenh /chapnhan job.");
					SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
					GettingJob2[playerid] = 20;
					return 1;
				}
				if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Trucker, Go lenh /chapnhan job.");
					SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
					GettingJob3[playerid] = 20;
					return 1;
				}
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 2 to become a Trucker.");
		}
		else if (IsPlayerInRangeOfPoint(playerid,3.0,-1720.962646, 1364.456176, 7.187500)) {
			if(PlayerInfo[playerid][pJob] == 0){
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Pizza Boy, Go lenh /chapnhan job.");
				GettingJob[playerid] = 21;
				return 1;
			}
			if((PlayerInfo[playerid][pDonateRank] > 0 || PlayerInfo[playerid][pFamed] > 0) && PlayerInfo[playerid][pJob2] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Pizza Boy, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a secondary job. Only VIP/Famed can do this.");
				GettingJob2[playerid] = 21;
				return 1;
			}
			if(PlayerInfo[playerid][pDonateRank] >= 3 && PlayerInfo[playerid][pJob3] == 0) {
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Neu ban chac rang muon tro thanh mot Pizza Boy, Go lenh /chapnhan job.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are getting a third job. Only Gold VIP+ can do this.");
				GettingJob3[playerid] = 21;
				return 1;
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_GREY, "You are not even near a place to get a Job!");
		}
	}
	else {
		if(PlayerInfo[playerid][pDonateRank] == 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "Ban da co cong viec nao do roi, su dung /nghiviec truoc neu muon nhan cong viec khac!");
            SendClientMessageEx(playerid, COLOR_YELLOW, "Chi co VIP/Famed moi nhan dc 2 cong viec cung luc, Gold VIP+ co the nhan 3 cong viec!");
		}
		else if(PlayerInfo[playerid][pDonateRank] < 3 && PlayerInfo[playerid][pJob2] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban da co 2 cong viec san roi, hay su dung /nghiviec de nhan cong viec khac!");
			SendClientMessageEx(playerid, COLOR_YELLOW, " Gold VIP+ co the nhan 3 cong viec!");
		}
		else {
			SendClientMessageEx(playerid, COLOR_GREY, "Ban hien tai da co 3 cong viec roi, su dung /nghiviec de thoat cong viec hien tai!");
		}
	}
    return 1;
}

CMD:skill(playerid, params[])
{
	if(isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /kynang [number]");
		SendClientMessageEx(playerid, COLOR_GREY, "| 1: Tham tu\t\t\t\t\t\t\t\t\t\t\t\t6: Tho sua xe");
		SendClientMessageEx(playerid, COLOR_GREY, "| 2: Luat su\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t7: Boxing");
		SendClientMessageEx(playerid, COLOR_GREY, "| 3: Gai diem\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t8: Cau ca");
		SendClientMessageEx(playerid, COLOR_GREY, "| 4: Van chuyen thuoc phien\t\t\t\t\t9: Trucker");
		SendClientMessageEx(playerid, COLOR_GREY, "| 5: Ban vu khi\t\t\t\t\t\t\t");
		return 1;
	}
	else switch(strval(params)) {
		case 1: //Detective
		{
			new level = PlayerInfo[playerid][pDetSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tham tu cap do: 1."); format(string, sizeof(string), "Ban can phai tim %d nguoi nua de len cap.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tham tu cap do: 2."); format(string, sizeof(string), "Ban can phai tim %d nguoi nua de len cap.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tham tu cap do: 3."); format(string, sizeof(string), "Ban can phai tim %d nguoi nua de len cap.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tham tu cap do: 4."); format(string, sizeof(string), "Ban can phai tim %d nguoi nua de len cap.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tham tu cap do: 5."); }
		}
		case 2://Lawyer
		{
			new level = PlayerInfo[playerid][pLawSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Luat su cap do: 1."); format(string, sizeof(string), "Ban can phai bao chua %d nguoi nua de len cap.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Luat su cap do: 2."); format(string, sizeof(string), "Ban can phai bao chua %d nguoi nua de len cap.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Luat su cap do: 3."); format(string, sizeof(string), "Ban can phai bao chua %d nguoi nua de len cap.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Luat su cap do: 4."); format(string, sizeof(string), "Ban can phai bao chua %d nguoi nua de len cap.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Luat su cap do: 5."); }
		}
		case 3://Whore
		{
			new level = PlayerInfo[playerid][pSexSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Gai diem cap do: 1."); format(string, sizeof(string), "Ban can phai lam tinh %d lan nua de len cap.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Gai diem cap do: 2."); format(string, sizeof(string), "Ban can phai lam tinh %d lan nua de len cap.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Gai diem cap do: 3."); format(string, sizeof(string), "Ban can phai lam tinh %d lan nua de len cap.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Gai diem cap do: 4."); format(string, sizeof(string), "Ban can phai lam tinh %d lan nua de len cap.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Gai diem cap do: 5."); }
		}
		case 4://Drug Smuggling
		{
			new level = PlayerInfo[playerid][pDrugSmuggler], string[61];
            if(level >=0 && level < 50) SendClientMessageEx(playerid, COLOR_YELLOW, "Van chuyen thuoc phien cap do: 1"), format(string, sizeof(string), "Ban can phai hoan thanh van chuyen %d chuyen nua de len cap.", 50 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 50 && level < 100) SendClientMessageEx(playerid, COLOR_YELLOW, "Van chuyen thuoc phien cap do: 2"), format(string, sizeof(string), "Ban can phai hoan thanh van chuyen %d chuyen nua de len cap.", 100 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=100 && level < 200) SendClientMessageEx(playerid, COLOR_YELLOW, "Van chuyen thuoc phien cap do: 3"), format(string, sizeof(string), "Ban can phai hoan thanh van chuyen %d chuyen nua de len cap.", 200 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=200 && level < 400) SendClientMessageEx(playerid, COLOR_YELLOW, "Van chuyen thuoc phien cap do: 4"), format(string, sizeof(string), "Ban can phai hoan thanh van chuyen %d chuyen nua de len cap.", 400 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=400 && level < 885) SendClientMessageEx(playerid, COLOR_YELLOW, "Van chuyen thuoc phien cap do: 5");
		}
		case 5://Arms Dealer
		{
			new level = PlayerInfo[playerid][pArmsSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Ban vu khi cap do: 1."); format(string, sizeof(string), "Ban can phai ban vu khi %d lan nua de len cap.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Ban vu khi cap do: 2."); format(string, sizeof(string), "Ban can phai ban vu khi %d lan nua de len cap.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 700) { SendClientMessageEx(playerid, COLOR_YELLOW, "Ban vu khi cap do: 3."); format(string, sizeof(string), "Ban can phai ban vu khi %d lan nua de len cap.", 700 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 700 && level < 1200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Ban vu khi cap do: 4."); format(string, sizeof(string), "Ban can phai ban vu khi %d lan nua de len cap ", 1200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 1200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Ban vu khi cap do: 5."); }
		}
		case 6://Car Mechanic
		{
			new level = PlayerInfo[playerid][pMechSkill], string[64];
			if(level >= 0 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tho sua xe cap do: 1."); format(string, sizeof(string), "Ban can phai sua xe hoac do xang %d lan nua de len", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 300) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tho sua xe cap do: 2."); format(string, sizeof(string), "Ban can phai sua xe hoac do xang %d lan nua de len cap.", 300 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 300 && level < 500) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tho sua xe cap do: 3."); format(string, sizeof(string), "Ban can phai sua xe hoac do xang %d lan nua de len cap.", 500 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 500 && level < 700) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tho sua xe cap do: 4."); format(string, sizeof(string), "Ban can phai sua xe hoac do xang %d lan nua de len cap.", 700 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 700) { SendClientMessageEx(playerid, COLOR_YELLOW, "Tho sua xe cap do: 5."); }
		}
		case 7://Boxer
		{
			new level = PlayerInfo[playerid][pBoxSkill], string[48];
			if(level >= 0 && level < 50) { SendClientMessageEx(playerid, COLOR_YELLOW, "Boxing cap do: 1."); format(string, sizeof(string), "Ban can phai thang %d tran nua de len cap.", 50 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 50 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Boxing cap do: 2."); format(string, sizeof(string), "Ban can phai thang %d tran nua de len cap.", 100 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 200) { SendClientMessageEx(playerid, COLOR_YELLOW, "Boxing cap do: 3."); format(string, sizeof(string), "Ban can phai thang %d tran nua de len cap.", 200 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 200 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Boxing cap do: 4."); format(string, sizeof(string), "Ban can phai thang %d tran nua de len cap.", 400 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Boxing cap do: 5."); }
		}
		case 8: //Fishing
		{
		    new level = PlayerInfo[playerid][pFishingSkill], string[61];
            if(level >=0 && level < 50) SendClientMessageEx(playerid, COLOR_YELLOW, "Cau ca cap do: 1."), format(string, sizeof(string), "Ban can phai cau ca thanh cong %d lan nua de len cap.", 50 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 50 && level < 100) SendClientMessageEx(playerid, COLOR_YELLOW, "Cau ca cap do: 2."), format(string, sizeof(string), "Ban can phai cau ca thanh cong %d lan nua de len cap.", 100 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=100 && level < 200) SendClientMessageEx(playerid, COLOR_YELLOW, "Cau ca cap do: 3."), format(string, sizeof(string), "Ban can phai cau ca thanh cong %d lan nua de len cap.", 200 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=200 && level < 400) SendClientMessageEx(playerid, COLOR_YELLOW, "Cau ca cap do: 4."), format(string, sizeof(string), "Ban can phai cau ca thanh cong %d lan nua de len cap.", 400 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=400) SendClientMessageEx(playerid, COLOR_YELLOW, "Cau ca cap do: 5.");
		}
		case 9://Trucker
		{
			new level = PlayerInfo[playerid][pTruckSkill], string[50];
			if(level >= 0 && level < 100) { SendClientMessageEx(playerid, COLOR_YELLOW, "Trucker cap do: 1."); format(string, sizeof(string), "Ban can phai giao hang %d chuyen nua de len cap.", 101 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 100 && level < 400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Trucker cap do: 2."); format(string, sizeof(string), "Ban can phai giao hang %d chuyen nua de len cap.", 401 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 400 && level < 1600) { SendClientMessageEx(playerid, COLOR_YELLOW, "Trucker cap do: 3."); format(string, sizeof(string), "Ban can phai giao hang %d chuyen nua de len cap.", 1601 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 1600 && level < 6400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Trucker cap do: 4."); format(string, sizeof(string), "Ban can phai giao hang %d chuyen nua de len cap.", 6401 - level); SendClientMessageEx(playerid, COLOR_YELLOW, string); }
			else if(level >= 6400) { SendClientMessageEx(playerid, COLOR_YELLOW, "Trucker cap do: 5."); }
		}
	//	case 11://Treasure Hunter
	//	{
	//	    new level = PlayerInfo[playerid][pTreasureSkill], string[50];
    //        if(level >=0 && level <= 24) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 1"), format(string, sizeof(string), "Ban can phai tim %d kho bau times to level up.", 25 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
    //        else if(level >= 25 && level <= 149) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 2"), format(string, sizeof(string), "BaBan can phai tim %d kho bau times to level up.", 150 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
	//		else if(level >=150 && level <= 299) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 3"), format(string, sizeof(string), "Ban can phai tim %d kho bau times to level up.", 300 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
	//		else if(level >=300 && level <= 599) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 4"), format(string, sizeof(string), "Ban can phai tim %d kho bau times to level up.", 600 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
	//		else if(level >=600) SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunting Skill Level = 5");
	//	}
		case 10: //Lock Picking
		{
		    new level = PlayerInfo[playerid][pCarLockPickSkill], string[61];
            if(level >=0 && level <= 49) SendClientMessageEx(playerid, COLOR_YELLOW, "Lock Picking cap do: 1."), format(string, sizeof(string), "Ban can phai pha khoa thanh cong %d phuong tien nua de len cap.", 50 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
            else if(level >= 50 && level <= 124) SendClientMessageEx(playerid, COLOR_YELLOW, "Lock Picking cap do: 2."), format(string, sizeof(string), "Ban can phai pha khoa thanh cong %d phuong tien nua de len cap.", 125 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=125 && level <= 224) SendClientMessageEx(playerid, COLOR_YELLOW, "Lock Picking cap do: 3."), format(string, sizeof(string), "Ban can phai pha khoa thanh cong %d phuong tien nua de len cap.", 225 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=225 && level <= 349) SendClientMessageEx(playerid, COLOR_YELLOW, "Lock Picking cap do: 4."), format(string, sizeof(string), "Ban can phai pha khoa thanh cong %d phuong tien nua de len cap.", 350 - level), SendClientMessageEx(playerid, COLOR_YELLOW, string);
			else if(level >=350) SendClientMessageEx(playerid, COLOR_YELLOW, "Lock Picking cap do: 5.");
		}
		default:
		{
			SendClientMessageEx(playerid, COLOR_GREY, "ID Job khong hop le!");
		}
	}
	return 1;
}

CMD:jobhelp(playerid, params[]) {
    return ShowPlayerDialogEx(playerid, JOBHELPMENU, DIALOG_STYLE_LIST, "Ban giup do cong viec nao?","Tham tu\nLuat su\nGai diem\nBan thuoc phien\nTho sua xe\nVe si\nBan vu khi\nTaxi Driver\nVan chuyen thuoc phien\nTho thu cong\nBartender\nTrucker\nPizza Boy", "Chon", "Huy");
}

CMD:quitjob(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] >= 1 || PlayerInfo[playerid][pFamed] >= 1)
	{
		new jobid;
		if(sscanf(params, "d", jobid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /nghiviec [jobid]");
			SendClientMessageEx(playerid, COLOR_GREY, "TUY CHON: 1, 2, 3 (Ban so huu VIP/Famed se co cong viec 2,3)");
			return 1;
		}

		switch(jobid)
		{
		case 1:
			{
				if(PlayerInfo[playerid][pJob] > 0 ) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da nghi cong viec.");
					if(PlayerInfo[playerid][pJob] == 2)
					{
						if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
						SetPVarInt(playerid, "LawyerDuty", 0);
					}
					if(PlayerInfo[playerid][pJob] == 7)
					{
						if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
						SetPVarInt(playerid, "MechanicDuty", 0);
					}
					PlayerInfo[playerid][pJob] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co cong viec nao!");
				}
			}
		case 2:
			{
				if(PlayerInfo[playerid][pJob2] > 0 ) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da nghi cong viec thu 2.");
					if(PlayerInfo[playerid][pJob2] == 2)
					{
						if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
						SetPVarInt(playerid, "LawyerDuty", 0);
					}
					if(PlayerInfo[playerid][pJob2] == 7)
					{
						if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
						SetPVarInt(playerid, "MechanicDuty", 0);
					}
					PlayerInfo[playerid][pJob2] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co cong viec thu 2.");
				}
			}
		case 3:
			{
				if(PlayerInfo[playerid][pJob3] > 0 ) {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da nghi cong viec thu 3.");
					if(PlayerInfo[playerid][pJob3] == 2)
					{
						if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
						SetPVarInt(playerid, "LawyerDuty", 0);
					}
					if(PlayerInfo[playerid][pJob3] == 7)
					{
						if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
						SetPVarInt(playerid, "MechanicDuty", 0);
					}
					PlayerInfo[playerid][pJob3] = 0;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Ban khong co cong viec thu 3.");
				}
			}
		default:
			{
				SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /nghiviec [jobid]");
				SendClientMessageEx(playerid, COLOR_GREY, "TUY CHON: 1, 2, 3 (Ban so huu VIP/Famed se co cong viec 2,3)");
			}
		}
	}
	else
	{
		if(PlayerInfo[playerid][pJob] > 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Ban da nghi cong viec nay.");
			if(PlayerInfo[playerid][pJob] == 2)
			{
				if(GetPVarInt(playerid, "LawyerDuty") == 1) Lawyers--;
				SetPVarInt(playerid, "LawyerDuty", 0);
			}
			if(PlayerInfo[playerid][pJob] == 7)
			{
				if(GetPVarInt(playerid, "MechanicDuty") == 1) Mechanics--;
				SetPVarInt(playerid, "MechanicDuty", 0);
			}
			PlayerInfo[playerid][pJob] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Ban dang that nghiep!!!");
		}
	}
	return 1;
}
