-- Fix 1: Create account2 table (cac.inc needs this)
CREATE TABLE IF NOT EXISTS `account2` (
    `Id` int(11) NOT NULL AUTO_INCREMENT,
    `UID` int(11) NOT NULL,
    `GP` int(11) DEFAULT 0,
    `Coin` int(11) DEFAULT 0,
    `EA` int(11) DEFAULT 0,
    `FoodBar` int(11) DEFAULT 100,
    `WaterBar` int(11) DEFAULT 100,
    `Job` int(11) DEFAULT 0,
    `Job2` int(11) DEFAULT 0,
    `Job3` int(11) DEFAULT 0,
    `FishmanSkill` int(11) DEFAULT 0,
    `AlcoholSkill` int(11) DEFAULT 0,
    `PizzaBoySkill` int(11) DEFAULT 0,
    `SweeperSkill` int(11) DEFAULT 0,
    `TruckerSkill` int(11) DEFAULT 0,
    `AlcoholLimit` int(11) DEFAULT 0,
    `SweeperLimit` int(11) DEFAULT 0,
    `AlcoholTimer` int(11) DEFAULT 0,
    `SweeperTimer` int(11) DEFAULT 0,
    `CaribbeanTeam` int(11) DEFAULT 0,
    `CaribbeanEvent` int(11) DEFAULT 0,
    `FamedPoint` int(11) DEFAULT 0,
    `LimitEventReward` int(11) DEFAULT 0,
    `ClaimRoseWinter` int(11) DEFAULT 0,
    `CargoTimeOnline` int(11) DEFAULT 0,
    `CargoTimeSeconds` int(11) DEFAULT 0,
    `ItemTradeNeftMiner` int(11) DEFAULT 0,
    `ItemTradeNeftExpireMiner` int(11) DEFAULT 0,
    `pc_Pass0` int(11) DEFAULT 0,
    `pc_Pass1` int(11) DEFAULT 0,
    `pc_Pass2` int(11) DEFAULT 0,
    `pc_Pass3` int(11) DEFAULT 0,
    `pc_PassF` int(11) DEFAULT 0,
    PRIMARY KEY (`Id`),
    UNIQUE KEY `UID` (`UID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fix 2: Add SQLId column to inventory table
-- If inventory table doesn't exist yet, create it with SQLId
-- If it exists without SQLId, alter it

-- Check and add SQLId column
ALTER TABLE `inventory` ADD COLUMN `Id` int(11) NOT NULL AUTO_INCREMENT FIRST, ADD PRIMARY KEY (`Id`);
ALTER TABLE `inventory` ADD COLUMN `SQLId` int(11) NOT NULL DEFAULT 0 AFTER `Id`;
