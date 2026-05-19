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

    // Nhóm các lệnh quan trọng nhất (Thường hay bị lỗi 6 dòng)
    SafeRegAlias("ohelp", "hotro");
    SafeRegAlias("ohelp", "trogiup");
    SafeRegAlias("loadshipment", "layhang");
    SafeRegAlias("checkcargo", "kiemtrahang");
    SafeRegAlias("hijackcargo", "cuophang");
    SafeRegAlias("quitjob", "nghiviec");

    // Nhóm lệnh thông tin cá nhân
    SafeRegAlias("skill", "kynang");
    SafeRegAlias("stats", "thongtin");
    SafeRegAlias("inv", "tuido");
    SafeRegAlias("myguns", "sungcuatoi");
    SafeRegAlias("licenses", "xembanglai");
    SafeRegAlias("showlicenses", "trinhbanglai");
    SafeRegAlias("nextpaycheck", "xempaycheck");

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

    // Nhóm lệnh Job và Items
    SafeRegAlias("getpizza", "laybanh");
    SafeRegAlias("buyclothes", "muaquanao");
    SafeRegAlias("buytoys", "muadochoi");
    SafeRegAlias("craft", "chetao");
    SafeRegAlias("fish", "cauca");
    SafeRegAlias("sellfish", "banca");
    SafeRegAlias("usedrug", "sudungthuoc");

    // Lệnh cho Staff/Admin
    SafeRegAlias("staff", "c");
    SafeRegAlias("destroycar", "dtc");
    SafeRegAlias("destroycars", "dtcs");

    // Cần thêm lệnh nào ông cứ SafeRegAlias tiếp vào đây...

    printf("[Pawn.CMD] Hoan tat nap Alias.");
    return 1;
}