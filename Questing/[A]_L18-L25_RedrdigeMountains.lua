-- Redridge Mountains Questing Profile (15-25)
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
LevelTarget = 15
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end
function RedridgeGoulash()
    if ItemCount("Goretusk Kidney") >= 5 and ItemCount("Great Goretusk Snout") >= 3 and ItemCount("Condor Giblets") >= 5 then
        return false
    elseif HasPlayerFinishedQuest(92) then
        return false
    else
        return true
    end
end
function GnollParts()
    if ItemCount("Redridge Gnoll Collar") >= 15 then
        return false
    elseif HasPlayerFinishedQuest(126) then
        return false
    else
        return true
    end
end
function OrcParts()
    if ItemCount("Black Dragonscale") >= 6 and ItemCount("Blackrock Medallion") >= 15 then
        return false
    elseif HasPlayerFinishedQuest(19) and HasPlayerFinishedQuest(20) then
        return false
    else
        return true
    end
end
function MurlocFins()
    if ItemCount("Murloc Fin") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(150) then
        return false
    else
        return true
    end
end

--Phase 1: Three Corners Arrival and Setup (Levels 15-17)
if not HasPlayerFinishedQuest(244) then
    --Step 1-1: Three Corners Entry
        Log("Phase 1: Three Corners Arrival and Setup");
        TurnInQuestUsingDB(244); Log("Turn-in: [16]Encroaching Gnolls");
        AcceptQuestUsingDB(246); Log("Accepting: [18]Assessing the Threat");
        GetFlightPath(); Log("Getting Redridge Mountains flight path");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Initial Quest Collection
        Log("Step 1-2: Initial Quest Collection");
        AcceptQuestUsingDB(125); Log("Accepting: [15]The Lost Tools");
        AcceptQuestUsingDB(118); Log("Accepting: [15]A Fishy Peril");
        AcceptQuestUsingDB(126); Log("Accepting: [20]Wanted: Redridge Gnolls");
        AcceptQuestUsingDB(92); Log("Accepting: [18]Redridge Goulash");
        AcceptQuestUsingDB(129); Log("Accepting: [16]A Baying of Gnolls");
        AcceptQuestUsingDB(89); Log("Accepting: [17]The Price of Shoes");
        AcceptQuestUsingDB(347); Log("Accepting: [15]Return to Verner");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Lake Everstill Operations
        Log("Step 1-3: Lake Everstill Operations");
        CompleteObjectiveOfQuest(125,1); Log("Completing Objective: [15]The Lost Tools - Find Oslow's Toolbox");
        CompleteObjectiveOfQuest(150,1); Log("Completing Objective: [15]Hilary's Necklace - Find Hilary's Necklace");
        Log("Starting Murloc Fin collection for Selling Fish");
        --[578]Murloc Scout,[579]Murloc Warrior,[580]Murloc Forager
        GrindAndGather(TableToList({578,579,580}),100,TableToFloatArray({2645.8,-1875.4,72.5}),false,"MurlocFins",true);
        TurnInQuestUsingDB(125); Log("Turn-in: [15]The Lost Tools");
        TurnInQuestUsingDB(150); Log("Turn-in: [15]Hilary's Necklace");
        AcceptQuestUsingDB(131); Log("Accepting: [17]Messenger to Darkshire");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Lakeshire Setup
        Log("Step 1-4: Lakeshire Setup");
        GoToNPC(6736,"Innkeeper Brianna"); --Set hearthstone
        UseMacro("Gossip01");
        SleepPlugin(2000);
        TurnInQuestUsingDB(347); Log("Turn-in: [15]Return to Verner");
        AcceptQuestUsingDB(345); Log("Accepting: [18]Underbelly Scales");
        TurnInQuestUsingDB(131); Log("Turn-in: [17]Messenger to Darkshire");
        AcceptQuestUsingDB(132); Log("Accepting: [17]Messenger to Westfall");
        AcceptQuestUsingDB(116); Log("Accepting: [15]Dry Times");
        AcceptQuestUsingDB(91); Log("Accepting: [15]Solomon's Law");
        TurnInQuestUsingDB(118); Log("Turn-in: [15]A Fishy Peril");
        AcceptQuestUsingDB(150); Log("Accepting: [18]Selling Fish");
        AcceptQuestUsingDB(120); Log("Accepting: [15]Messenger to Stormwind");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Delivering Daffodils Chain
        Log("Step 1-5: Delivering Daffodils Chain");
        AcceptQuestUsingDB(130); Log("Accepting: [15]Visit the Herbalist");
        TurnInQuestUsingDB(130); Log("Turn-in: [15]Visit the Herbalist");
        AcceptQuestUsingDB(133); Log("Accepting: [15]Delivering Daffodils");
        TurnInQuestUsingDB(133); Log("Turn-in: [15]Delivering Daffodils");
        AcceptQuestUsingDB(143); Log("Accepting: [16]Letter to Stormpike");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Level 17 Check
        Log("Step 1-6: Level 17 Check");
        if(Player.Level < 17) then
            LevelTarget = 17
            Log("Grinding to Level "..LevelTarget..".");
            --[578]Murloc Scout,[579]Murloc Warrior,[580]Murloc Forager
            GrindAndGather(TableToList({578,579,580}),150,TableToFloatArray({2645.8,-1875.4,72.5}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 17");
end --End Initial Setup

--Phase 2: Gnoll and Wildlife Collection (Level 17-19)
if not HasPlayerFinishedQuest(126) then
    --Step 2-1: Redridge Wildlife Collection
        Log("Phase 2: Gnoll and Wildlife Collection");
        Log("Starting collection of Redridge Goulash ingredients");
        --[547]Great Goretusk,[423]Dire Condor,[712]Redridge Tarantula
        GrindAndGather(TableToList({547,423,712}),100,TableToFloatArray({2534.2,-1654.8,104.3}),false,"RedridgeGoulash",true);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Gnoll Elimination Campaign
        Log("Step 2-2: Gnoll Elimination Campaign");
        Log("Starting Gnoll elimination for bounty and threat assessment");
        --[426]Redridge Mystic,[430]Redridge Brute,[584]Redridge Alpha
        GrindAndGather(TableToList({426,430,584}),100,TableToFloatArray({2156.4,-1526.8,64.8}),false,"GnollParts",true);
        CompleteObjectiveOfQuest(129,1); Log("Completing Objective: [16]A Baying of Gnolls - Kill 10 Redridge Mystics");
        CompleteObjectiveOfQuest(246,1); Log("Completing Objective: [18]Assessing the Threat - Gather Gnoll Intelligence");
        TurnInQuestUsingDB(126); Log("Turn-in: [20]Wanted: Redridge Gnolls");
        TurnInQuestUsingDB(129); Log("Turn-in: [16]A Baying of Gnolls");
        TurnInQuestUsingDB(246); Log("Turn-in: [18]Assessing the Threat");
        AcceptQuestUsingDB(193); Log("Accepting: [20]The Everstill Bridge");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Redridge Goulash Completion
        Log("Step 2-3: Redridge Goulash Completion");
        TurnInQuestUsingDB(92); Log("Turn-in: [18]Redridge Goulash");
        AcceptQuestUsingDB(93); Log("Accepting: [20]A Free Lunch");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Selling Fish Quest
        Log("Step 2-4: Selling Fish Quest");
        TurnInQuestUsingDB(150); Log("Turn-in: [18]Selling Fish");
        AcceptQuestUsingDB(154); Log("Accepting: [20]Murloc Poachers");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Solomon's Law
        Log("Step 2-5: Solomon's Law");
        CompleteObjectiveOfQuest(91,1); Log("Completing Objective: [15]Solomon's Law - Kill Yowler");
        TurnInQuestUsingDB(91); Log("Turn-in: [15]Solomon's Law");
end --End Wildlife/Gnoll Phase

--Phase 3: Blackrock Orc Campaign (Level 19-21)
if not HasPlayerFinishedQuest(20) then
    --Step 3-1: Blackrock Stronghold Assault
        Log("Phase 3: Blackrock Orc Campaign");
        Log("Beginning assault on Blackrock Stronghold");
        --[615]Blackrock Tracker,[4065]Blackrock Sentry,[435]Blackrock Champion
        GrindAndGather(TableToList({615,4065,435}),100,TableToFloatArray({2754.8,-1287.4,123.8}),false,"OrcParts",true);
        CompleteObjectiveOfQuest(20,1); Log("Completing Objective: [18]Blackrock Menace - Kill 15 Blackrock Orcs");
        CompleteObjectiveOfQuest(193,1); Log("Completing Objective: [20]The Everstill Bridge - Collect Keeshan's Bow");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: Dragon Whelp Hunting
        Log("Step 3-2: Dragon Whelp Hunting");
        CompleteObjectiveOfQuest(19,1); Log("Completing Objective: [20]Tharil'zun - Kill Black Dragon Whelps");
        TurnInQuestUsingDB(20); Log("Turn-in: [18]Blackrock Menace");
        TurnInQuestUsingDB(19); Log("Turn-in: [20]Tharil'zun");
        TurnInQuestUsingDB(193); Log("Turn-in: [20]The Everstill Bridge");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Underbelly Scales Collection
        Log("Step 3-3: Underbelly Scales Collection");
        CompleteObjectiveOfQuest(345,1); Log("Completing Objective: [18]Underbelly Scales - Collect 6 Underbelly Scales");
        TurnInQuestUsingDB(345); Log("Turn-in: [18]Underbelly Scales");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Murloc Poachers
        Log("Step 3-4: Murloc Poachers");
        CompleteObjectiveOfQuest(154,1); Log("Completing Objective: [20]Murloc Poachers - Kill 12 Murloc Poachers");
        TurnInQuestUsingDB(154); Log("Turn-in: [20]Murloc Poachers");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Level 20 Check and Training
        Log("Step 3-5: Level 20 Check and Training");
        if(Player.Level < 20) then
            LevelTarget = 20
            Log("Grinding to Level "..LevelTarget..".");
            --[615]Blackrock Tracker,[4065]Blackrock Sentry,[435]Blackrock Champion
            GrindAndGather(TableToList({615,4065,435}),200,TableToFloatArray({2754.8,-1287.4,123.8}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 20");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-6: Mount Acquisition
        Log("Step 3-6: Mount Acquisition");
        if Player.Level >= 20 then
            PopMessage("Level 20 reached! Consider getting your first mount for faster travel.");
            if IsHardCore == "false" then
                Log("Recommend traveling to Stormwind or Goldshire for mount and riding skill");
            end
        end
end --End Blackrock Campaign

--Phase 4: Messenger Quests and Connections (Level 20-22)
if not HasPlayerFinishedQuest(132) then
    --Step 4-1: Messenger to Stormwind
        Log("Phase 4: Messenger Quests and Connections");
        TurnInQuestUsingDB(120); Log("Turn-in: [15]Messenger to Stormwind");
        AcceptQuestUsingDB(121); Log("Accepting: [16]Messenger to Darkshire");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Messenger to Westfall
        Log("Step 4-2: Messenger to Westfall");
        TurnInQuestUsingDB(132); Log("Turn-in: [17]Messenger to Westfall");
        AcceptQuestUsingDB(135); Log("Accepting: [17]Messenger to Darkshire");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: Letter to Stormpike
        Log("Step 4-3: Letter to Stormpike");
        TurnInQuestUsingDB(143); Log("Turn-in: [16]Letter to Stormpike");
        AcceptQuestUsingDB(144); Log("Accepting: [18]Stormpike's Order");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Dry Times Quest
        Log("Step 4-4: Dry Times Quest");
        CompleteObjectiveOfQuest(116,1); Log("Completing Objective: [15]Dry Times - Find Missing Shipment");
        TurnInQuestUsingDB(116); Log("Turn-in: [15]Dry Times");
        AcceptQuestUsingDB(117); Log("Accepting: [20]Visit the Herbalist");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-5: Price of Shoes
        Log("Step 4-5: Price of Shoes");
        CompleteObjectiveOfQuest(89,1); Log("Completing Objective: [17]The Price of Shoes - Collect 4 Tough Condor Meat");
        TurnInQuestUsingDB(89); Log("Turn-in: [17]The Price of Shoes");
        AcceptQuestUsingDB(90); Log("Accepting: [20]Return to Verner");
end --End Messenger Phase

--Phase 5: Elite Quests and Special Operations (Level 21-23)
if not HasPlayerFinishedQuest(19) then
    --Step 5-1: Tharil'zun Elite Quest
        Log("Phase 5: Elite Quests and Special Operations");
        if EliteQuests == "true" then
            if IsHardCore == "true" then
                PopMessage("Tharil'zun is an elite dragon! Consider getting help or waiting until higher level.");
            end
            AcceptQuestUsingDB(19); Log("Accepting: [20]Tharil'zun");
            CompleteObjectiveOfQuest(19,1); Log("Completing Objective: [20]Tharil'zun - Kill Tharil'zun");
            TurnInQuestUsingDB(19); Log("Turn-in: [20]Tharil'zun");
        else
            Log("Elite Quests disabled - skipping Tharil'zun");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: Deadmines Preparation
        Log("Step 5-2: Deadmines Preparation");
        AcceptQuestUsingDB(168); Log("Accepting: [17]Collecting Memories");
        AcceptQuestUsingDB(167); Log("Accepting: [18]Oh Brother...");
        if EliteQuests == "true" then
            PopMessage("Deadmines dungeon quests available! Great for groups at level 18-22.");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: A Free Lunch Completion
        Log("Step 5-3: A Free Lunch Completion");
        if HasPlayerFinishedQuest(93) then
            CompleteObjectiveOfQuest(93,1); Log("Completing Objective: [20]A Free Lunch - Deliver Lunch to Linnea");
            TurnInQuestUsingDB(93); Log("Turn-in: [20]A Free Lunch");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Visit the Herbalist
        Log("Step 5-4: Visit the Herbalist");
        if HasPlayerFinishedQuest(117) then
            TurnInQuestUsingDB(117); Log("Turn-in: [20]Visit the Herbalist");
            AcceptQuestUsingDB(122); Log("Accepting: [20]Return to Verner");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-5: Level 22 Check
        Log("Step 5-5: Level 22 Check");
        if(Player.Level < 22) then
            LevelTarget = 22
            Log("Grinding to Level "..LevelTarget..".");
            --[615]Blackrock Tracker,[4065]Blackrock Sentry,[435]Blackrock Champion,[547]Great Goretusk
            GrindAndGather(TableToList({615,4065,435,547}),250,TableToFloatArray({2754.8,-1287.4,123.8}),false,"LevelCheck",true);
        end
end --End Elite Operations

--Phase 6: Class-Specific and Professional Quests (Level 22-24)
if not HasPlayerFinishedQuest(90) then
    --Step 6-1: Return to Verner Chain
        Log("Phase 6: Class-Specific and Professional Quests");
        TurnInQuestUsingDB(90); Log("Turn-in: [20]Return to Verner");
        if HasPlayerFinishedQuest(122) then
            TurnInQuestUsingDB(122); Log("Turn-in: [20]Return to Verner");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Class-Specific Level 20+ Quests
        Log("Step 6-2: Class-Specific Level 20+ Quests");
        if Player.Level >= 20 then
            if GetPlayerClass() == "Warrior" then
                AcceptQuestUsingDB(1718); Log("Accepting: [20]The Affray");
            elseif GetPlayerClass() == "Paladin" then
                AcceptQuestUsingDB(1641); Log("Accepting: [20]The Tome of Valor");
            elseif GetPlayerClass() == "Hunter" then
                AcceptQuestUsingDB(6084); Log("Accepting: [20]Taming the Beast");
            elseif GetPlayerClass() == "Rogue" then
                AcceptQuestUsingDB(2359); Log("Accepting: [20]Klaven's Tower");
            elseif GetPlayerClass() == "Priest" then
                AcceptQuestUsingDB(5635); Log("Accepting: [20]The Temple of the Moon");
            elseif GetPlayerClass() == "Mage" then
                AcceptQuestUsingDB(1860); Log("Accepting: [20]Speak with Anastasia");
            elseif GetPlayerClass() == "Warlock" then
                AcceptQuestUsingDB(1758); Log("Accepting: [20]Tome of the Cabal");
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Collecting Memories
        Log("Step 6-3: Collecting Memories");
        if HasPlayerFinishedQuest(168) then
            CompleteObjectiveOfQuest(168,1); Log("Completing Objective: [17]Collecting Memories - Find Corporal Keeshan's belongings");
            TurnInQuestUsingDB(168); Log("Turn-in: [17]Collecting Memories");
            AcceptQuestUsingDB(169); Log("Accepting: [20]Jorgensen");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Oh Brother Quest
        Log("Step 6-4: Oh Brother Quest");
        if HasPlayerFinishedQuest(167) then
            CompleteObjectiveOfQuest(167,1); Log("Completing Objective: [18]Oh Brother... - FindRol'dan's corpse");
            TurnInQuestUsingDB(167); Log("Turn-in: [18]Oh Brother...");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-5: Training Session
        Log("Step 6-5: Training Session");
        Training(); Log("Training at Level 22+");
end --End Class/Professional

--Phase 7: Zone Completion and Preparation (Level 23-25)
if not HasPlayerFinishedQuest(121) then
    --Step 7-1: Messenger to Darkshire
        Log("Phase 7: Zone Completion and Preparation");
        TurnInQuestUsingDB(121); Log("Turn-in: [16]Messenger to Darkshire");
        if HasPlayerFinishedQuest(135) then
            TurnInQuestUsingDB(135); Log("Turn-in: [17]Messenger to Darkshire");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Stormpike's Order
        Log("Step 7-2: Stormpike's Order");
        if HasPlayerFinishedQuest(144) then
            TurnInQuestUsingDB(144); Log("Turn-in: [18]Stormpike's Order");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Jorgensen Quest
        Log("Step 7-3: Jorgensen Quest");
        if HasPlayerFinishedQuest(169) then
            TurnInQuestUsingDB(169); Log("Turn-in: [20]Jorgensen");
            AcceptQuestUsingDB(170); Log("Accepting: [22]Beat Bartleby");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Beat Bartleby
        Log("Step 7-4: Beat Bartleby");
        if HasPlayerFinishedQuest(170) then
            CompleteObjectiveOfQuest(170,1); Log("Completing Objective: [22]Beat Bartleby - Defeat Bartleby");
            TurnInQuestUsingDB(170); Log("Turn-in: [22]Beat Bartleby");
            AcceptQuestUsingDB(171); Log("Accepting: [22]Bartleby the Drunk");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-5: Final Level Check
        Log("Step 7-5: Final Level Check");
        if(Player.Level < 24) then
            LevelTarget = 24
            Log("Final grind to Level "..LevelTarget.." before leaving Redridge.");
            --[615]Blackrock Tracker,[4065]Blackrock Sentry,[435]Blackrock Champion,[547]Great Goretusk
            GrindAndGather(TableToList({615,4065,435,547}),300,TableToFloatArray({2754.8,-1287.4,123.8}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
end --End Zone Completion

--Phase 8: Zone Transition and Final Preparations (Level 24-25)
if Player.Level >= 24 then
    --Step 8-1: Zone Transition Preparation
        Log("Phase 8: Zone Transition and Final Preparations");
        AcceptQuestUsingDB(65); Log("Accepting: [20]The Hermit");
        AcceptQuestUsingDB(127); Log("Accepting: [23]Camped Tarren Mill");
        AcceptQuestUsingDB(1); Log("Accepting: [25]Miscellaneous quests");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-2: Deadmines Final Check
        Log("Step 8-2: Deadmines Final Check");
        if EliteQuests == "true" and Player.Level >= 18 then
            PopMessage("Consider running Deadmines dungeon before leaving zone - great XP and gear!");
            if IsHardCore == "true" then
                PopMessage("Deadmines recommended with full group for safety!");
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-3: Safety Grind Option
        Log("Step 8-3: Safety Grind Option");
        if SafetyGrind == "true" then
            LevelTarget = 25
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Redridge");
            --[615]Blackrock Tracker,[4065]Blackrock Sentry,[435]Blackrock Champion,[547]Great Goretusk
            GrindAndGather(TableToList({615,4065,435,547}),400,TableToFloatArray({2754.8,-1287.4,123.8}),false,"LevelCheck",true);
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-4: Zone Completion Messages
        Log("Step 8-4: Zone Completion Messages");
        if IsHardCore == "true" then
            PopMessage("Redridge Mountains complete! Recommended level 20-25 for Duskwood or Wetlands.");
        end
        PopMessage("Redridge Mountains questing complete! Ready for Duskwood (20-30), Wetlands (20-30), or Ashenvale (18-30) at level " .. Player.Level);
        PopMessage("Alternative options: Deadmines dungeon (18-23), Stranglethorn Vale (30+), or return to Westfall cleanup");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-5: Final Recommendations
        Log("Step 8-5: Final Recommendations");
        PopMessage("Recommended next zones based on level:");
        PopMessage("Level 20-22: Duskwood or finish Westfall");
        PopMessage("Level 22-25: Wetlands or start Ashenvale");
        PopMessage("Level 25+: Stranglethorn Vale or Thousand Needles");
end --End Final Preparations

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();