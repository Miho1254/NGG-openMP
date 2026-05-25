-- SQL Script to set up database column and reset locker stock on VPS database.

-- 1. Bổ sung cột pvStolen vào bảng vehicles (Dùng cú pháp MySQL tiêu chuẩn)
ALTER TABLE `vehicles` ADD COLUMN `pvStolen` INT NOT NULL DEFAULT 0;

-- 2. Reset kho vật liệu của tất cả Gang/Faction về 0 (loại trừ Government)
UPDATE `groups` SET `g_iLockerStock` = 0 WHERE `g_iGroupType` != 5;

-- 3. Set kho vật liệu của Government (City Hall) về 10,000
UPDATE `groups` SET `g_iLockerStock` = 10000 WHERE `g_iGroupType` = 5;
