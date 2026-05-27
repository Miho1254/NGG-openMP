InitiateGamemode()
{
	AddPlayerClass(0, 1715.1201, -1903.1711, 13.5665, 360, 0, 0, 0, 0, 0, 0);
	
	SetGameModeText(SERVER_GM_TEXT);
     
	// MySQL
    g_mysql_LoadMOTD();
 	g_mysql_AccountOnlineReset();
	g_mysql_LoadGiftBox();
	LoadHouses();
	LoadDynamicDoors();
	LoadDynamicMapIcons();
	LoadMailboxes();
	LoadBusinesses();
	LoadAuctions();
	LoadTxtLabels();
	LoadSpeedCameras();
	LoadPayNSprays();
	LoadArrestPoints();
	LoadImpoundPoints();
	LoadRelayForLifeTeams();
	LoadGarages();
	LoadCrimes();
	LoadDynamicSafeZone();
	LoadCustomSkin();
	/*---[Shop Automation]---*/
	
 	g_mysql_LoadSales();
 	g_mysql_LoadPrices();
 	LoadBusinessSales();
 	ToyList = LoadModelSelectionMenu("ToyList.txt");
	CarList = LoadModelSelectionMenu("CarList.txt");
	PlaneList = LoadModelSelectionMenu("PlaneList.txt");
	BoatList = LoadModelSelectionMenu("BoatList.txt");
	ToyList2 = LoadModelSelectionMenu("ToyList.txt");
	CarList2 = LoadModelSelectionMenu("CarList.txt");
	CarList3 = LoadModelSelectionMenu("RestrictedCarList.txt");
	SkinList = LoadModelSelectionMenu("SkinList.txt");
	
	/*---[Miscs]---*/
	NGGShop = CreateDynamicPolygon(shop_vertices);
	InitPaintballArenas();
	LoadPaintballArenas();
	InitEventPoints();
	LoadEventPoints();
	LoadGates();
	LoadPoints();
	InitTurfWars();
    LoadTurfWars();
	LoadPlants();
	LoadElevatorStuff();
	ClearCalls();
	LoadHelp();
	Misc_Load();
	InitPokerTables();
	ResetElevatorQueue();
	Elevator_Initialize();
	AntiDeAMX();
	EnableStuntBonusForAll(0);
	//ShowNameTags(0);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	DisableInteriorEnterExits();
	ClearReports();
	//NationSel_InitTextDraws();
	CountCitizens();
	SetNameTagDrawDistance(40.0);
	AllowInteriorWeapons(1);
	//UsePlayerPedAnims();
	ManualVehicleEngineAndLights();
	GiftAllowed = 1;
	ResetNews();
	ResetVariables();
	FixServerTime();
	LoadVactionsHelper();
	RotateWheel();

	LoadParkingMeters();
	GovGuns_LoadCosts();
	MetDet_LoadMetDets();
	LoadATMPoints();
	LoadCASINOPoints();
	LoadBanks();
	LoadPayPhones();
	
	//LoadCarrier()
	//SelectCharmPoint();
	
	gWeather = random(19) + 1;
	if(gWeather == 1 || gWeather == 8 || gWeather == 9) gWeather=1;
	SetWeather(1);
    
    // Streamer
    Streamer_TickRate(100);
    
    BikeParkourObjectStage[0] = 0; //BikeParkourObjectStage[1] = 0;
    
    // Textdraws
    print("[Textdraws] Loading Textdraws...");
    LoadTextDraws();
    
    // Dynamic Groups
    print("[Dynamic Groups] Loading Dynamic Groups...");
    LoadDynamicGroups();
    print("[Dynamic Groups] Loading Dynamic Groups Vehicles...");
    LoadDynamicGroupVehicles();

    //LoadGCrates();
    LoadCrateBoxes();
    LoadCrateFacilities();
    LoadCrateOrders();
    LoadDynamicCrateVehicles();
	// loadSafes();

    LoadJobPoints();
    GangTag_Load();

    // Bank_LoadBank();
	//LoadFurniture(); Not needed - furniture loads when the player enters the house.
	FurnitureListInit();
    //Poll_LoadPolls();

	print("\n-------------------------------------------");
	print("SAW Community\n");
	print("Copyright (C) SAW, LLC (2010-2014)");
	print("All Rights Reserved");
	print("-------------------------------------------\n");
	print("Successfully initiated the gamemode...");
	return 1;
}		

stock LoadCustomSkin()
{
	//AddCharModel(193, 21088, "Elaina.dff", "Elaina.txd");
    return 1; // Thêm đúng dòng này để chặn server load model rác
    
    // AddCharModel(1, 21001, "sindaco.dff", "sindaco.txd");
    // AddCharModel(193, 21002, "swfyri.dff", "swfyri.txd");
    // AddCharModel(0, 21003, "wfyclot.dff", "wfyclot.txd");
    // AddCharModel(1, 21004, "zero.dff", "zero.txd");
    // AddCharModel(1, 21005, "dnb2.dff", "dnb2.txd");
    // AddCharModel(1, 21006, "zero1.dff", "zero1.txd");
    // AddCharModel(1, 21014, "rickstatham.dff", "rickstatham.txd");
    // AddCharModel(0, 21015, "bibi.dff", "bibi.txd");
    // AddCharModel(1, 21016, "rickstatham2.dff", "rickstatham2.txd");
    // AddCharModel(1, 21017, "ngoctienn.dff", "ngoctienn.txd");
    // AddCharModel(1, 21018, "quanghacboy.dff", "quanghacboy.txd");
    // AddCharModel(0, 21019, "quanghacgirl.dff", "quanghacgirl.txd");
    // AddCharModel(1, 21020, "bryanmills.dff", "bryanmills.txd");
    // AddCharModel(1, 21021, "temiravo.dff", "temiravo.txd");
    // AddCharModel(1, 21023, "temiravo3.dff", "temiravo3.txd");
    // AddCharModel(1, 21024, "temiravo4.dff", "temiravo4.txd");
    // AddCharModel(1, 21025, "kenhydra.dff", "kenhydra.txd"); 
    // AddCharModel(1, 21051, "maleFD1.dff", "maleFD1.txd");
    // AddCharModel(193, 21052, "femaleFD1.dff", "femaleFD1.txd");
    // AddCharModel(1, 21053, "lssag.dff", "lssag.txd");
    // AddCharModel(193, 21054, "lssag1.dff", "lssag1.txd");
    // AddCharModel(1, 21055, "sanewsmale.dff", "sanewsmale.txd");
    // AddCharModel(1, 21056, "Marshmello.dff", "Marshmello.txd");
    // AddCharModel(1, 21083, "pizzaboy1.dff", "pizzaboy1.txd");
    // AddCharModel(1, 21084, "gtanetwork1.dff", "gtanetwork1.txd");
    // AddCharModel(1, 21085, "gtanetwork2.dff", "gtanetwork2.txd");
    // AddCharModel(193, 21086, "gucci.dff", "gucci.txd");
    // AddCharModel(193, 21087, "gucci1.dff", "gucci1.txd");
    // AddCharModel(193, 21087, "girlprivate.dff", "girlprivate.txd");
    // AddSimpleModel(-1,19379, -2002, "object.dff", "gtanetwork.txd");
}

/*
new SERVER_DOWNLOAD[] = "http://gta.network/models/"; 
public OnPlayerRequestDownload(playerid, type, crc) 
{ 
    if(!IsPlayerConnected(playerid)) return 0; 
     
    new filename[64], filefound, url_final[256]; 
     
    if(type == DOWNLOAD_REQUEST_TEXTURE_FILE) 
        filefound = FindTextureFileNameFromCRC(crc, filename, sizeof(filename)); 
    else if(type == DOWNLOAD_REQUEST_MODEL_FILE) 
        filefound = FindModelFileNameFromCRC(crc, filename, sizeof(filename)); 

    if(filefound) 
    { 
        if(strfind(filename, "Elaina", true) != -1)
        {
            return 1; // Chap nhan tai xuong va de open.mp tu dong serve qua built-in HTTP server
        }
        format(url_final, sizeof(url_final), "%s%s", SERVER_DOWNLOAD, filename); 
        RedirectDownload(playerid, url_final); 
    } 
    return 1; 
}  
*/