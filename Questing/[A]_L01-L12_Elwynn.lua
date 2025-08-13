-- Elwynn Forest Questing Profile (1-12)
StartMobAvoidance()
UseDBToRepair(true)
UseDBToSell(true)
SetQuestRepairAt(30)
SetQuestSellAt(2)
IgnoreLowLevelQuests(false);
--Variables--
IsHardCore = "false";
EliteQuests = "true"
ManualInteract = "true";
ManualGearCheck = "false";
SafetyGrind = "false";
Player = GetPlayer();
Log("Current Zone ID: "..GetZoneID());
Log("Current Player Position:"..GetPlayer().Position);
local IDs = {}
local StartingPoint = {}
Log("Neareast Class Trainer is: "..GetNearestClassTrainer().Name);
Log("Neareast Class Trainer ID is: "..GetNearestClassTrainer().ID);
--------------------------------------------------------------------------------------
-----------------------------------Flight Functions-----------------------------------
--------------------------------------------------------------------------------------
function FlyTo(LOCATION)
    Log("Flying to " .. LOCATION)
    for _ = 1, 3 do
        UseMacro("Gossip01")
        SleepPlugin(2000)

        local macroName = "FP" .. LOCATION
        local macroValue = _G[macroName]
        if macroValue then
            UseMacro(macroValue)
        else
            Log("Error: Macro for " .. macroName .. " not found")
            return
        end

        SleepPlugin(2000)
    end

    while IsUnitOnTaxi == true do
        SleepPlugin(1000)
    end
end
--------------------------------------------------------------------------------------
----------------------------------------Travel----------------------------------------
--------------------------------------------------------------------------------------
function GoToNPC(NPCID,NPCName)
    NPCLOC = GetNPCPostionFromDB(NPCID)
    -- Decompose the Vendor location
    NPCX = NPCLOC[0]; NPCY = NPCLOC[1]; NPCZ = NPCLOC[2]
    -- Path to Vendor Location
    QuestGoToPoint(NPCX, NPCY, NPCZ)
    -- Get List of Units and Interact with the Specified Vendor
    Units = GetUnitsList()
    foreach Unit in Units do
        Log(Unit.Name)
        if (Unit.Name == NPCName) and (IsUnitValid(Unit)) then
            Log("Found Vendor! "..NPCName)
            InteractWithUnit(Unit)
            SleepPlugin(5000)
            break -- Exit loop once the vendor is found and interacted with
        end
    end
end
function UseHearthStone()
    UseItem("Hearthstone");
    SleepPlugin(500);
    while(Player.IsChanneling or Player.IsCasting) do
        SleepPlugin(100);
    end;
    while(InGame == false) do
        SleepPlugin(100);
    end;
end;
function Training()
    local trainer = GetNearestClassTrainer()
    if trainer == nil then
        Log("ERROR: No class trainer found nearby. Skipping Training.")
        return
    end
    TrainerID = trainer.ID
    TrainerName = trainer.Name
    GoToNPC(TrainerID, TrainerName)
    SleepPlugin(2000)
    UseMacro("Gossip1")
    SleepPlugin(2000)
    QuestTrainAt(TrainerID)
    SleepPlugin(2000)
end

--------------------------------------------------------------------------------------
--Quest Completion Checker Functions--
--------------------------------------------------------------------------------------
LevelTarget = 1
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end
function BoarMeat()
    if ItemCount("Chunk of Boar Meat") >= 4 then
        return false
    elseif HasPlayerFinishedQuest(106) then
        return false
    else
        return true
    end
end
function KoboldCandles()
    if ItemCount("Kobold Candle") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(60) then
        return false
    else
        return true
    end
end
function GoldDust()
    if ItemCount("Gold Dust") >= 10 then
        return false
    elseif HasPlayerFinishedQuest(47) then
        return false
    else
        return true
    end
end
function CrystalKelp()
    if ItemCount("Crystal Kelp Frond") >= 4 then
        return false
    elseif HasPlayerFinishedQuest(112) then
        return false
    else
        return true
    end
end

--Phase 1: Northshire Valley (Levels 1-5)
if not HasPlayerFinishedQuest(54) then
    --Step 1-1: Initial Northshire Abbey Quests
        Log("Phase 1: Northshire Valley - Starting Area");
        AcceptQuestUsingDB(783); Log("Accepting: [1]A Threat Within");
        AcceptQuestUsingDB(7); Log("Accepting: [2]Kobold Camp Cleanup");
        AcceptQuestUsingDB(5261); Log("Accepting: [1]Eagan Peltskinner");
        AcceptQuestUsingDB(33); Log("Accepting: [2]Wolves Across the Border");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Class Quest Collection
        Log("Step 1-2: Class Quest Collection");
        if GetPlayerClass() == "Paladin" then
            AcceptQuestUsingDB(3100); Log("Accepting: [1]Consecrated Letter");
        elseif GetPlayerClass() == "Rogue" then
            AcceptQuestUsingDB(3102); Log("Accepting: [1]Encrypted Letter");
        elseif GetPlayerClass() == "Mage" then
            AcceptQuestUsingDB(3103); Log("Accepting: [1]Glyphic Letter");
        elseif GetPlayerClass() == "Priest" then
            AcceptQuestUsingDB(3101); Log("Accepting: [1]Hallowed Letter");
        elseif GetPlayerClass() == "Warrior" then
            AcceptQuestUsingDB(3104); Log("Accepting: [1]Simple Letter");
        elseif GetPlayerClass() == "Warlock" then
            AcceptQuestUsingDB(3105); Log("Accepting: [1]Tainted Letter");
            AcceptQuestUsingDB(1598); Log("Accepting: [4]The Stolen Tome");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Initial Northshire Completion
        Log("Step 1-3: Initial Northshire Completion");
        CompleteObjectiveOfQuest(783,1); Log("Completing Objective: [1]A Threat Within - Report to Deputy Willem");
        TurnInQuestUsingDB(783); Log("Turn-in: [1]A Threat Within");
        AcceptQuestUsingDB(7); Log("Accepting: [2]Brotherhood of Thieves");
        CompleteObjectiveOfQuest(7,1); Log("Completing Objective: [2]Kobold Camp Cleanup - Kill 10 Kobold Vermin");
        CompleteObjectiveOfQuest(33,1); Log("Completing Objective: [2]Wolves Across the Border - Kill 8 Timber Wolves");
        CompleteObjectiveOfQuest(5261,1); Log("Completing Objective: [1]Eagan Peltskinner - Deliver Letter to Eagan");
        TurnInQuestUsingDB(7); Log("Turn-in: [2]Kobold Camp Cleanup");
        TurnInQuestUsingDB(33); Log("Turn-in: [2]Wolves Across the Border");
        TurnInQuestUsingDB(5261); Log("Turn-in: [1]Eagan Peltskinner");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Brotherhood and Garrick Phase
        Log("Step 1-4: Brotherhood and Garrick Phase");
        AcceptQuestUsingDB(15); Log("Accepting: [4]Brotherhood of Thieves");
        AcceptQuestUsingDB(18); Log("Accepting: [5]Bounty on Garrick Padfoot");
        if GetPlayerClass() == "Warlock" then
            CompleteObjectiveOfQuest(1598,1); Log("Completing Objective: [4]The Stolen Tome - Retrieve Stolen Tome");
            TurnInQuestUsingDB(1598); Log("Turn-in: [4]The Stolen Tome");
        end
        CompleteObjectiveOfQuest(15,1); Log("Completing Objective: [4]Brotherhood of Thieves - Kill 12 Defias Thieves");
        CompleteObjectiveOfQuest(18,1); Log("Completing Objective: [5]Bounty on Garrick Padfoot - Kill Garrick Padfoot");
        TurnInQuestUsingDB(15); Log("Turn-in: [4]Brotherhood of Thieves");
        TurnInQuestUsingDB(18); Log("Turn-in: [5]Bounty on Garrick Padfoot");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Milly Osworth Chain
        Log("Step 1-5: Milly Osworth Chain");
        AcceptQuestUsingDB(3903); Log("Accepting: [4]Milly Osworth");
        CompleteObjectiveOfQuest(3903,1); Log("Completing Objective: [4]Milly Osworth - Speak with Milly");
        TurnInQuestUsingDB(3903); Log("Turn-in: [4]Milly Osworth");
        AcceptQuestUsingDB(3904); Log("Accepting: [4]Milly's Harvest");
        CompleteObjectiveOfQuest(3904,1); Log("Completing Objective: [4]Milly's Harvest - Collect 8 Milly's Harvest");
        TurnInQuestUsingDB(3904); Log("Turn-in: [4]Milly's Harvest");
        AcceptQuestUsingDB(3905); Log("Accepting: [4]Grape Manifest");
        CompleteObjectiveOfQuest(3905,1); Log("Completing Objective: [4]Grape Manifest - Deliver to Brother Neale");
        TurnInQuestUsingDB(3905); Log("Turn-in: [4]Grape Manifest");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Echo Ridge Mine
        Log("Step 1-6: Echo Ridge Mine");
        AcceptQuestUsingDB(3100); Log("Accepting: [4]Investigate Echo Ridge");
        AcceptQuestUsingDB(3101); Log("Accepting: [5]Skirmish at Echo Ridge");
        CompleteObjectiveOfQuest(3100,1); Log("Completing Objective: [4]Investigate Echo Ridge - Investigate Echo Ridge Mine");
        CompleteObjectiveOfQuest(3101,1); Log("Completing Objective: [5]Skirmish at Echo Ridge - Kill 12 Kobold Workers");
        TurnInQuestUsingDB(3100); Log("Turn-in: [4]Investigate Echo Ridge");
        TurnInQuestUsingDB(3101); Log("Turn-in: [5]Skirmish at Echo Ridge");
        AcceptQuestUsingDB(54); Log("Accepting: [5]Report to Goldshire");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-7: Class Quest Turn-ins
        Log("Step 1-7: Class Quest Turn-ins");
        if GetPlayerClass() == "Paladin" then
            TurnInQuestUsingDB(3100); Log("Turn-in: [1]Consecrated Letter");
        elseif GetPlayerClass() == "Rogue" then
            TurnInQuestUsingDB(3102); Log("Turn-in: [1]Encrypted Letter");
        elseif GetPlayerClass() == "Mage" then
            TurnInQuestUsingDB(3103); Log("Turn-in: [1]Glyphic Letter");
        elseif GetPlayerClass() == "Priest" then
            TurnInQuestUsingDB(3101); Log("Turn-in: [1]Hallowed Letter");
            if Player.Level >= 4 then
                AcceptQuestUsingDB(5623); Log("Accepting: [4]In Favor of the Light");
                AcceptQuestUsingDB(5624); Log("Accepting: [4]Garments of the Light");
            end
        elseif GetPlayerClass() == "Warrior" then
            TurnInQuestUsingDB(3104); Log("Turn-in: [1]Simple Letter");
        elseif GetPlayerClass() == "Warlock" then
            TurnInQuestUsingDB(3105); Log("Turn-in: [1]Tainted Letter");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-8: Preparation for Goldshire
        Log("Step 1-8: Preparation for Goldshire");
        if(Player.Level < 5) then
            LevelTarget = 5
            Log("Grinding to Level "..LevelTarget.." before leaving Northshire.");
            --[40]Kobold Vermin,[80]Timber Wolf,[38]Defias Thug
            GrindAndGather(TableToList({40,80,38}),100,TableToFloatArray({-8947.52,-132.54,83.5}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Northshire before departure");
end --End Northshire Valley

--Phase 2: Goldshire Hub (Levels 5-7)
if not HasPlayerFinishedQuest(40) then
    --Step 2-1: Goldshire Arrival and Setup
        Log("Phase 2: Goldshire Hub - Central Operations");
        TurnInQuestUsingDB(54); Log("Turn-in: [5]Report to Goldshire");
        AcceptQuestUsingDB(62); Log("Accepting: [5]The Fargodeep Mine");
        AcceptQuestUsingDB(2158); Log("Accepting: [6]Rest and Relaxation");
        GoToNPC(295,"Innkeeper Farley"); --Set hearthstone
        UseMacro("Gossip01");
        AcceptQuestUsingDB(47); Log("Accepting: [5]Gold Dust Exchange");
        AcceptQuestUsingDB(60); Log("Accepting: [5]Kobold Candles");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Stonefield Farm Quests
        Log("Step 2-2: Stonefield Farm Quests");
        AcceptQuestUsingDB(85); Log("Accepting: [6]Lost Necklace");
        AcceptQuestUsingDB(88); Log("Accepting: [8]Princess Must Die!");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Maclure Vineyards Chain
        Log("Step 2-3: Maclure Vineyards Chain");
        TurnInQuestUsingDB(85); Log("Turn-in: [6]Lost Necklace");
        AcceptQuestUsingDB(106); Log("Accepting: [7]Pie for Billy");
        AcceptQuestUsingDB(104); Log("Accepting: [7]Young Lovers");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Love Story Chain
        Log("Step 2-4: Love Story Chain");
        TurnInQuestUsingDB(104); Log("Turn-in: [7]Young Lovers");
        AcceptQuestUsingDB(117); Log("Accepting: [7]Speak with Gramma");
        -- Grind Boar Meat while traveling
        Log("Collecting Chunk of Boar Meat while traveling");
        --[113]Stonetusk Boar
        GrindAndGather(TableToList({113}),100,TableToFloatArray({-9803.78,-56.77,33.9}),false,"BoarMeat",true);
        TurnInQuestUsingDB(117); Log("Turn-in: [7]Speak with Gramma");
        AcceptQuestUsingDB(118); Log("Accepting: [7]Note to William");
        CompleteObjectiveOfQuest(106,1); Log("Completing Objective: [7]Pie for Billy - Collect 4 Chunk of Boar Meat");
        TurnInQuestUsingDB(106); Log("Turn-in: [7]Pie for Billy");
        AcceptQuestUsingDB(111); Log("Accepting: [7]Back to Billy");
        TurnInQuestUsingDB(111); Log("Turn-in: [7]Back to Billy");
        AcceptQuestUsingDB(107); Log("Accepting: [8]Goldtooth");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Level 6 Safety Check
        Log("Step 2-5: Level 6 Safety Check");
        if(Player.Level < 6) then
            LevelTarget = 6
            Log("Grinding to Level "..LevelTarget.." for safety.");
            --[113]Stonetusk Boar,[17]Surena Caledon
            GrindAndGather(TableToList({113,17}),100,TableToFloatArray({-9803.78,-56.77,33.9}),false,"LevelCheck",true);
        end
end --End Goldshire Initial

--Phase 3: Mine Operations (Level 6-7)
if not HasPlayerFinishedQuest(107) then
    --Step 3-1: Fargodeep Mine Operations
        Log("Phase 3: Fargodeep Mine Operations");
        CompleteObjectiveOfQuest(107,1); Log("Completing Objective: [8]Goldtooth - Kill Goldtooth");
        CompleteObjectiveOfQuest(60,1); Log("Completing Objective: [5]Kobold Candles - Collect 8 Kobold Candles");
        CompleteObjectiveOfQuest(47,1); Log("Completing Objective: [5]Gold Dust Exchange - Collect 10 Gold Dust");
        TurnInQuestUsingDB(107); Log("Turn-in: [8]Goldtooth");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: Goldshire Return and New Quests
        Log("Step 3-2: Goldshire Return and New Quests");
        TurnInQuestUsingDB(62); Log("Turn-in: [5]The Fargodeep Mine");
        TurnInQuestUsingDB(60); Log("Turn-in: [5]Kobold Candles");
        TurnInQuestUsingDB(47); Log("Turn-in: [5]Gold Dust Exchange");
        TurnInQuestUsingDB(118); Log("Turn-in: [7]Note to William");
        AcceptQuestUsingDB(61); Log("Accepting: [9]Shipment to Stormwind");
        AcceptQuestUsingDB(112); Log("Accepting: [8]Collecting Kelp");
        AcceptQuestUsingDB(52); Log("Accepting: [8]Protect the Frontier");
        AcceptQuestUsingDB(76); Log("Accepting: [8]The Jasperlode Mine");
        AcceptQuestUsingDB(239); Log("Accepting: [8]Westbrook Garrison Needs Help!");
        AcceptQuestUsingDB(1667); Log("Accepting: [8]Further Concerns");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Class Quest Check (Level 6)
        Log("Step 3-3: Class Quest Check (Level 6)");
        if GetPlayerClass() == "Priest" and Player.Level >= 5 then
            CompleteObjectiveOfQuest(5624,1); Log("Completing Objective: [4]Garments of the Light - Healing objective");
            TurnInQuestUsingDB(5624); Log("Turn-in: [4]Garments of the Light");
        end
        Training(); Log("Training at Level 6");
end --End Fargodeep Mine

--Phase 4: Eastern Elwynn (Level 7-8)
if not HasPlayerFinishedQuest(76) then
    --Step 4-1: Crystal Lake Collection
        Log("Phase 4: Eastern Elwynn Exploration");
        CompleteObjectiveOfQuest(112,1); Log("Completing Objective: [8]Collecting Kelp - Collect 4 Crystal Kelp Fronds");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Jasperlode Mine
        Log("Step 4-2: Jasperlode Mine Operations");
        CompleteObjectiveOfQuest(76,1); Log("Completing Objective: [8]The Jasperlode Mine - Kill Foreman Thistlenettle");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: Eastvale Logging Camp
        Log("Step 4-3: Eastvale Logging Camp");
        TurnInQuestUsingDB(1667); Log("Turn-in: [8]Further Concerns");
        AcceptQuestUsingDB(1665); Log("Accepting: [8]Find the Lost Guards");
        AcceptQuestUsingDB(244); Log("Accepting: [8]Encroaching Gnolls");
        CompleteObjectiveOfQuest(1665,1); Log("Completing Objective: [8]Find the Lost Guards - Find Guard Thomas");
        CompleteObjectiveOfQuest(1665,2); Log("Completing Objective: [8]Find the Lost Guards - Find Guard Adams");
        CompleteObjectiveOfQuest(1665,3); Log("Completing Objective: [8]Find the Lost Guards - Find Guard Hiett");
        TurnInQuestUsingDB(1665); Log("Turn-in: [8]Find the Lost Guards");
        AcceptQuestUsingDB(37); Log("Accepting: [8]A Bundle of Trouble");
        CompleteObjectiveOfQuest(37,1); Log("Completing Objective: [8]A Bundle of Trouble - Recover Rolf's body");
        TurnInQuestUsingDB(37); Log("Turn-in: [8]A Bundle of Trouble");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Level 8 Preparation
        Log("Step 4-4: Level 8 Preparation");
        if(Player.Level < 8) then
            LevelTarget = 8
            Log("Grinding to Level "..LevelTarget.." for Princess fight.");
            --[518]Prowler,[547]Murloc Warrior
            GrindAndGather(TableToList({518,547}),100,TableToFloatArray({-9064.58,427.21,93.0}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 8");
end --End Eastern Elwynn

--Phase 5: Mid-Level Content (Level 8-9)
if not HasPlayerFinishedQuest(88) then
    --Step 5-1: Return to Goldshire
        Log("Phase 5: Mid-Level Content and Elite Encounters");
        TurnInQuestUsingDB(112); Log("Turn-in: [8]Collecting Kelp");
        AcceptQuestUsingDB(114); Log("Accepting: [8]The Escape");
        TurnInQuestUsingDB(76); Log("Turn-in: [8]The Jasperlode Mine");
        AcceptQuestUsingDB(239); Log("Accepting: [8]Deliver Thomas' Report");
        AcceptQuestUsingDB(83); Log("Accepting: [8]Red Linen Goods");
        AcceptQuestUsingDB(123); Log("Accepting: [8]The Collector");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: The Escape Chain
        Log("Step 5-2: The Escape Chain");
        TurnInQuestUsingDB(114); Log("Turn-in: [8]The Escape");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: Princess Must Die Fight
        Log("Step 5-3: Princess Must Die Fight");
        if IsHardCore == "true" then
            PopMessage("Princess is level 8 with 2 boar adds - consider getting help if hardcore");
        end
        CompleteObjectiveOfQuest(88,1); Log("Completing Objective: [8]Princess Must Die! - Kill Princess");
        TurnInQuestUsingDB(88); Log("Turn-in: [8]Princess Must Die!");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Equipment Check
        Log("Step 5-4: Equipment Check");
        if ManualGearCheck == "true" then
            PopMessage("Check for gear upgrades at vendors - especially weapons and armor");
        end
end --End Mid-Level Content

--Phase 6: Westbrook Garrison & Elite Content (Level 9-10)
if not HasPlayerFinishedQuest(176) then
    --Step 6-1: Westbrook Garrison Setup
        Log("Phase 6: Westbrook Garrison and Elite Encounters");
        TurnInQuestUsingDB(239); Log("Turn-in: [8]Westbrook Garrison Needs Help!");
        AcceptQuestUsingDB(11); Log("Accepting: [9]Riverpaw Gnoll Bounty");
        AcceptQuestUsingDB(176); Log("Accepting: [11]Wanted: Hogger");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Gnoll Hunting
        Log("Step 6-2: Gnoll Hunting");
        CompleteObjectiveOfQuest(11,1); Log("Completing Objective: [9]Riverpaw Gnoll Bounty - Kill 8 Riverpaw Gnolls");
        TurnInQuestUsingDB(11); Log("Turn-in: [9]Riverpaw Gnoll Bounty");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Level 10 Preparation for Hogger
        Log("Step 6-3: Level 10 Preparation for Hogger");
        if(Player.Level < 10) then
            LevelTarget = 10
            Log("Grinding to Level "..LevelTarget.." for Hogger fight.");
            --[124]Riverpaw Gnoll,[506]Riverpaw Outrunner
            GrindAndGather(TableToList({124,506}),200,TableToFloatArray({-10374.60,196.49,35.85}),false,"LevelCheck",true);
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Hogger Fight
        Log("Step 6-4: Hogger Fight");
        if IsHardCore == "true" then
            PopMessage("Hogger is level 11 Elite - VERY dangerous solo. Consider getting a group!");
        end
        if EliteQuests == "true" then
            CompleteObjectiveOfQuest(176,1); Log("Completing Objective: [11]Wanted: Hogger - Kill Hogger");
            TurnInQuestUsingDB(176); Log("Turn-in: [11]Wanted: Hogger");
        else
            Log("Elite Quests disabled - skipping Hogger");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-5: Level 10 Class Quests
        Log("Step 6-5: Level 10 Class Quests");
        if Player.Level >= 10 then
            Training(); Log("Training Level 10 Abilities");
            if GetPlayerClass() == "Mage" then
                AcceptQuestUsingDB(1860); Log("Accepting: [10]Speak with Jennea");
            elseif GetPlayerClass() == "Paladin" then
                AcceptQuestUsingDB(1642); Log("Accepting: [10]The Tome of Divinity");
            elseif GetPlayerClass() == "Warlock" then
                AcceptQuestUsingDB(1688); Log("Accepting: [10]Surena Caledon");
            elseif GetPlayerClass() == "Priest" then
                AcceptQuestUsingDB(5635); Log("Accepting: [10]The Temple of the Moon");
            end
        end
end --End Westbrook Garrison

--Phase 7: Optional Collection Quests (Level 10-11)
if not HasPlayerFinishedQuest(83) then
    --Step 7-1: Defias and Collection Quests
        Log("Phase 7: Optional Collection and Rare Drop Quests");
        -- Red Linen Goods is a rare drop quest
        if HasItem("Red Linen Goods") then
            TurnInQuestUsingDB(83); Log("Turn-in: [8]Red Linen Goods");
        end
        -- The Collector chain from rare drop
        if HasItem("The Collector's Schedule") then
            AcceptQuestUsingDB(123); Log("Accepting: [8]The Collector");
            TurnInQuestUsingDB(123); Log("Turn-in: [8]The Collector");
            AcceptQuestUsingDB(147); Log("Accepting: [8]A Dark Threat Looms");
            CompleteObjectiveOfQuest(147,1); Log("Completing Objective: [8]A Dark Threat Looms - Kill Morgan the Collector");
            TurnInQuestUsingDB(147); Log("Turn-in: [8]A Dark Threat Looms");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Murloc Hunting (Optional)
        Log("Step 7-2: Murloc Hunting (Optional)");
        AcceptQuestUsingDB(150); Log("Accepting: [8]A Fishy Peril");
        CompleteObjectiveOfQuest(150,1); Log("Completing Objective: [8]A Fishy Peril - Kill 10 Murloc Forrunners");
        CompleteObjectiveOfQuest(150,2); Log("Completing Objective: [8]A Fishy Peril - Kill 8 Murloc Warriors");
        TurnInQuestUsingDB(150); Log("Turn-in: [8]A Fishy Peril");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Rare Drop Grinding (Optional)
        Log("Step 7-3: Rare Drop Grinding (Optional)");
        if SafetyGrind == "true" then
            Log("Safety Grind: Farming for rare drop quests");
            --[590]Defias Bandit,[6]Kobold Worker,[124]Riverpaw Gnoll
            GrindAndGather(TableToList({590,6,124}),300,TableToFloatArray({-9463.24,87.56,56.95}),false,"",true);
        end
end --End Optional Collection

--Phase 8: Preparation for Next Zone (Level 11-12)
if not HasPlayerFinishedQuest(61) then
    --Step 8-1: Stormwind Delivery
        Log("Phase 8: Final Preparations and Zone Transition");
        -- Travel to Stormwind for Shipment delivery
        QuestGoToPoint(-8869.03,676.46,97.90); -- Stormwind Gates
        TurnInQuestUsingDB(61); Log("Turn-in: [9]Shipment to Stormwind");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-2: Westfall Preparation
        Log("Step 8-2: Westfall Preparation");
        AcceptQuestUsingDB(109); Log("Accepting: [10]Report to Gryan Stoutmantle");
        -- If you have Furlbrow's Deed (rare drop)
        if HasItem("Furlbrow's Deed") then
            AcceptQuestUsingDB(184); Log("Accepting: [8]Furlbrow's Deed");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-3: Final Training and Level Check
        Log("Step 8-3: Final Training and Level Check");
        if(Player.Level < 12) then
            LevelTarget = 12
            Log("Final grind to Level "..LevelTarget.." before leaving Elwynn.");
            --[590]Defias Bandit,[299]Young Forest Bear,[40]Kobold Vermin
            GrindAndGather(TableToList({590,299,40}),200,TableToFloatArray({-9803.78,-56.77,33.9}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-4: Zone Transition Setup
        Log("Step 8-4: Zone Transition Setup");
        if IsHardCore == "true" then
            PopMessage("Elwynn Forest complete! Recommended level 10-12 for Westfall. Keep hearthstone in Goldshire.");
        end
        PopMessage("Elwynn Forest questing complete! Ready for Westfall at level " .. Player.Level);
        if SafetyGrind == "true" then
            LevelTarget = 13
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Elwynn Forest");
            --[590]Defias Bandit,[299]Young Forest Bear,[124]Riverpaw Gnoll,[40]Kobold Vermin
            GrindAndGather(TableToList({590,299,124,40}),300,TableToFloatArray({-9803.78,-56.77,33.9}),false,"LevelCheck",true);
        end
end --End Elwynn Forest

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();