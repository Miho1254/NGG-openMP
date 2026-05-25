#include <YSI_Coding\y_hooks>

// =============================================================================
// HÀM ĐĂNG KÝ ALIAS AN TOÀN (FIXED)
// =============================================================================
stock SafeRegAlias(const target[], const alias[])
{
    // Kiểm tra xem lệnh gốc có tồn tại trong bộ nhớ không
    if(PC_CommandExists(target)) 
    {
        // GỌI HÀM CỦA PLUGIN (PC_RegAlias) - KHÔNG ĐƯỢC GỌI LẠI SafeRegAlias
        PC_RegAlias(target, alias);
    } 
    else 
    {
        // Nếu không thấy lệnh gốc, in ra log để ông đi tìm file include bị thiếu
        printf("[Pawn.CMD Warning] Lenh goc /%s CHUA TON TAI. Khong the tao alias /%s", target, alias);
    }
}

// =============================================================================
// SỬ DỤNG CALLBACK CHUẨN CỦA PAWN.CMD
// Callback này chạy khi Plugin đã nạp xong toàn bộ lệnh từ script
// =============================================================================
public PC_OnInit()
{
    printf("[Pawn.CMD] Dang tien hanh viet hoa (alias) toan bo he thong lenh...");

    // Nhóm các lệnh quan trọng nhất
    SafeRegAlias("ohelp", "hotro");
    SafeRegAlias("ohelp", "trogiup");
    SafeRegAlias("loadshipment", "layhang");
    SafeRegAlias("checkcargo", "kiemtrahang");
    SafeRegAlias("hijackcargo", "cuophang");
    SafeRegAlias("quitjob", "nghiviec");
    SafeRegAlias("killcheckpoint", "xoamuctieu");
    SafeRegAlias("map", "timdiadiem");
    SafeRegAlias("map", "timduong");
    SafeRegAlias("garbagerun", "donrac");

    // Nhóm lệnh thông tin cá nhân
    SafeRegAlias("skill", "kynang");
    SafeRegAlias("stats", "thongtin");
    SafeRegAlias("inv", "tuido");
    SafeRegAlias("myguns", "sungcuatoi");
    SafeRegAlias("licenses", "xembanglai");
    SafeRegAlias("showlicenses", "trinhbanglai");
    SafeRegAlias("nextpaycheck", "xempaycheck");
    SafeRegAlias("speedo", "xemtocdo");
    SafeRegAlias("myangle", "toadocuatoi");
    SafeRegAlias("newbquestions", "Xemcauhoi");
    SafeRegAlias("mydrugs", "thuoccuatoi");
    SafeRegAlias("myfish", "cacuatoi");

    // Nhóm lệnh tương tác phương tiện
    SafeRegAlias("vstorage", "chinhxe");
    SafeRegAlias("refuel", "bomxang");
    SafeRegAlias("repair", "suaxe");
    SafeRegAlias("refill", "doxang");
    SafeRegAlias("eject", "duoiraxe");
    SafeRegAlias("park", "dauxe");
    SafeRegAlias("colorcar", "mauxe");
    SafeRegAlias("pvlock", "khoaxe");
    SafeRegAlias("trackcar", "timxe");
    SafeRegAlias("deletecar", "xoaxe");
    SafeRegAlias("unmodcar", "xoamodxe");
    SafeRegAlias("givekeys", "duachiakhoa");
    SafeRegAlias("carkeys", "laychiakhoa");
    SafeRegAlias("checkbelt", "kiemtrasb");

    // Nhóm lệnh Nhà cửa (House)
    SafeRegAlias("hwithdraw", "hlay");
    SafeRegAlias("hdeposit", "hcat");
    SafeRegAlias("houselights", "hbatden");
    SafeRegAlias("lockhouse", "khoanha");
    SafeRegAlias("evict", "hduoi");
    SafeRegAlias("evictall", "hduoitatca");
    SafeRegAlias("buyhouse", "muanha");
    SafeRegAlias("rentroom", "thuenha");
    SafeRegAlias("hbalance", "hkiemtra");
    SafeRegAlias("sellmyhouse", "bannha");
    SafeRegAlias("houseinvite", "hmoivaonha");
    SafeRegAlias("ringbell", "bamchuong");
    SafeRegAlias("placemailbox", "dathopthu");
    SafeRegAlias("destroymailbox", "xoahopthu");
    SafeRegAlias("movemailbox", "movehopthu");
    SafeRegAlias("setrent", "giathuenha");
    SafeRegAlias("setrentable", "chothuenha");
    SafeRegAlias("setgatepass", "doipassgate");
    SafeRegAlias("unrent", "huythuenha");
    SafeRegAlias("sellmycar", "banxe");
    SafeRegAlias("getgun", "hlaysung");
    SafeRegAlias("storegun", "hcatsung");
    SafeRegAlias("sendmail", "guithu");
    SafeRegAlias("getmail", "nhanthu");

    // Nhóm lệnh Nhà đất (House Listings)
    SafeRegAlias("houselistings", "danhsachnha");
    SafeRegAlias("deletelisting", "huybannha");
    SafeRegAlias("listingdate", "thoihanbannha");
    SafeRegAlias("renewlisting", "giahanbannha");
    SafeRegAlias("listhouse", "raobannha");
    SafeRegAlias("listingdetails", "athongtinnha");
    SafeRegAlias("pendinglistings", "adanhsachnha");
    SafeRegAlias("adeletelisting", "axoadanhsach");
    SafeRegAlias("houselistinghelp", "tgbannha");

    // Nhóm lệnh hành động / tương tác
    SafeRegAlias("accept", "chapnhan");
    SafeRegAlias("cancel", "huy");
    SafeRegAlias("enter", "vao");
    SafeRegAlias("exit", "ra");
    SafeRegAlias("tie", "troi");
    SafeRegAlias("untie", "coitroi");
    SafeRegAlias("cuff", "congtay");
    SafeRegAlias("uncuff", "thaocong");
    SafeRegAlias("drag", "dandi");
    SafeRegAlias("detain", "dualenxe");
    SafeRegAlias("revive", "hoisinh");
    SafeRegAlias("release", "thatu");
    SafeRegAlias("service", "dichvu");
    SafeRegAlias("buy", "mua");
    SafeRegAlias("se", "datmota");
    SafeRegAlias("examine", "mota");
    SafeRegAlias("changename", "doiten");
    SafeRegAlias("drop", "vut");
    SafeRegAlias("fix", "sua");
    SafeRegAlias("guard", "bangiap");
	SafeRegAlias("frisk", "lucsoat");
	SafeRegAlias("lucsoatbalo", "friskbalo");
	SafeRegAlias("takebalo", "thugiu");
	SafeRegAlias("banca_ngudan", "sellfishngudan");
	SafeRegAlias("haican", "harvest");
	SafeRegAlias("blackmarket", "chodendoi");
	SafeRegAlias("chebiencansa", "processweed");
	SafeRegAlias("bancansa", "sellweed");
    SafeRegAlias("blindfold", "bitmat");
    SafeRegAlias("arrest", "batgiam");
    SafeRegAlias("wanted", "danhsachtruyna");

    // Nhóm lệnh Job và Items
    SafeRegAlias("getpizza", "laybanh");
    SafeRegAlias("buyclothes", "muaquanao");
    SafeRegAlias("buytoys", "muadochoi");
    SafeRegAlias("craft", "chetao");
    SafeRegAlias("fish", "cauca");
    SafeRegAlias("sellfish", "banca");
    SafeRegAlias("usedrug", "sudungthuoc");
    SafeRegAlias("sellgun", "banvukhi");
    SafeRegAlias("offeritem", "banhang");
    SafeRegAlias("buyfood", "muathucan");
    SafeRegAlias("selldrink", "bannuoc");
    SafeRegAlias("getmats", "layvatlieu");
    SafeRegAlias("train", "hocvo");
    SafeRegAlias("sell", "buonban");
    SafeRegAlias("show", "choxem");
    SafeRegAlias("giveweapon", "duavukhi");
    SafeRegAlias("trunkput", "catsung");
    SafeRegAlias("trunktake", "laysung");
    SafeRegAlias("listguns", "checkgun");

    // Nhóm lệnh Buôn bán / Chế tạo thuốc
    SafeRegAlias("buypot", "muapot");
    SafeRegAlias("buyopium", "muaopium");
    SafeRegAlias("makeheroin", "chetaoheroin");
    SafeRegAlias("checkplant", "kiemtrathuoc");
    SafeRegAlias("pickplant", "thuhoach");
    SafeRegAlias("plantpot", "trongpot");
    SafeRegAlias("plantopium", "trongopium");
    SafeRegAlias("odrughelp", "tgdrug");

    // Nhóm lệnh Boxing / Swimming / Arena
    SafeRegAlias("beginswimming", "batdauboi");
    SafeRegAlias("stopswimming", "dungboi");
    SafeRegAlias("leaveboxing", "roiboxing");
    SafeRegAlias("joinboxing", "thamgiaboxing");
    SafeRegAlias("joinarena", "thamgiaarena");

    // Nhóm lệnh Mail / Reply
    SafeRegAlias("reply", "traloi");
    SafeRegAlias("cancelcall", "huycuocgoi");

    // Nhóm lệnh Gift / VIP
    SafeRegAlias("nextgift", "xemqua");
    SafeRegAlias("dynamicgift", "dathopqua");
    SafeRegAlias("giftbox", "vitrihopqua");
    SafeRegAlias("getgift", "nhanqua");
    SafeRegAlias("buddyinvite", "moidungvip");
    SafeRegAlias("denyvoucher", "tuchoivoucher");
    SafeRegAlias("myvouchers", "phieucuatoi");
    SafeRegAlias("checkvouchers", "kiemtravoucher");

    // Nhóm lệnh Event / Contract / Misc
    SafeRegAlias("joinevent", "thamgiasukien");
    SafeRegAlias("quitevent", "thoatsukien");
    SafeRegAlias("writecheck", "vietsec");
    SafeRegAlias("contract", "hopdong");
    SafeRegAlias("droplicense", "vutbanglai");
    SafeRegAlias("apply", "doiquoctich");
    SafeRegAlias("calculate", "maytinh");
    SafeRegAlias("report", "baocao");
    SafeRegAlias("cancelreport", "huybaocao");
    SafeRegAlias("togglehealthcare", "chamsocsuckhoe");
    SafeRegAlias("sex", "lamtinh");
    SafeRegAlias("resign", "quitbusiness");
    SafeRegAlias("charity", "tuthien");
    SafeRegAlias("propose", "cauhon");
    SafeRegAlias("witness", "lamchung");
    SafeRegAlias("divorce", "lyhon");
    SafeRegAlias("ads", "quangcao");
    SafeRegAlias("accent", "giongnoi");
    SafeRegAlias("ticket", "vephat");
    SafeRegAlias("radargun", "sungtocdo");
    SafeRegAlias("placefirework", "datphaohoa");
    SafeRegAlias("placeboombox", "datboombox");
    SafeRegAlias("issuegunlicense", "capgiayphepsung");
    SafeRegAlias("setfreq", "tanso");
    SafeRegAlias("cancelnewbie", "huycauhoi");
    SafeRegAlias("viewmotd", "xemtin");
    SafeRegAlias("viewmotd", "xemthongbao");
    SafeRegAlias("accepthelp", "chapnhantrogiup");
    SafeRegAlias("finishhelp", "ketthuctrogiup");
    SafeRegAlias("requesthelp", "yeucautrogiup");
    SafeRegAlias("leaveshop", "roignshop");
    SafeRegAlias("locker", "tudo");
    SafeRegAlias("jetpack", "jet");
    SafeRegAlias("families", "bangdang");

    // Nhóm lệnh Help toggles
    SafeRegAlias("ocellphonehelp", "tgdienthoai");
    SafeRegAlias("ocarhelp", "tgxe");
    SafeRegAlias("ohousehelp", "tgnha");
    SafeRegAlias("otoyhelp", "tgtoy");
    SafeRegAlias("orenthelp", "tgthuenha");
    SafeRegAlias("animlist", "hanhdong");
    SafeRegAlias("ojobhelp", "tgcongviec");
    SafeRegAlias("ofishhelp", "tgcauca");
    SafeRegAlias("omailhelp", "tgmail");
    SafeRegAlias("ovoucherhelp", "tgvoucher");
    SafeRegAlias("businesshelp", "tgbiz");
    SafeRegAlias("rules", "luatle");
    SafeRegAlias("settings", "caidat");
    SafeRegAlias("jobhelp", "tgcongviec");
    SafeRegAlias("phone", "dienthoai");
    SafeRegAlias("contacts", "danhba");

    // Lệnh cho Staff/Admin
    SafeRegAlias("staff", "c");
    SafeRegAlias("oah", "ch");
    SafeRegAlias("destroycar", "dtc");
    SafeRegAlias("destroycars", "dtcs");
    SafeRegAlias("addcrime", "themtoi");
    SafeRegAlias("deletecrime", "xoatoi");
    SafeRegAlias("createfamily", "taofamily");
    SafeRegAlias("createfaction", "taofaction");

    printf("[Pawn.CMD] Hoan tat nap Alias.");
    return 1;
}
