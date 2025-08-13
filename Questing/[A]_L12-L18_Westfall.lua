-- Westfall Questing Profile (10-20)
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
LevelTarget = 10
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end
function WestfallStewIngredients()
    if ItemCount("Goretusk Liver") >= 3 and ItemCount("Okra") >= 3 then
        return false
    elseif HasPlayerFinishedQuest(36) then
        return false
    else
        return true
    end
end
function PoorOldBlanchyIngredients()
    if ItemCount("Sack of Oats") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(151) then
        return false
    else
        return true
    end
end
function RedLeatherBandanas()
    if ItemCount("Red Leather Bandana") >= 15 then
        return false
    elseif HasPlayerFinishedQuest(214) then
        return false
    else
        return true
    end
end
function GnollPaws()
    if ItemCount("Gnoll Paw") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(109) then
        return false
    else
        return true
    end
end

--Phase 1: Westfall Entry and Furlbrow's Farm (Levels 10-12)
if not HasPlayerFinishedQuest(184) then
    --Step 1-1: Westfall Entry
        Log("Phase 1: Westfall Entry and Setup");
        if HasItem("Furlbrow's Deed") then
            TurnInQuestUsingDB(184); Log("Turn-in: [8]Furlbrow's Deed");
        end
        AcceptQuestUsingDB(151); Log("Accepting: [9]Poor Old Blanchy");
        AcceptQuestUsingDB(36); Log("Accepting: [9]Westfall Stew");
        AcceptQuestUsingDB(64); Log("Accepting: [10]The Forgotten Heirloom");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Furlbrow's Farm Operations
        Log("Step 1-2: Furlbrow's Farm Operations");
        CompleteObjectiveOfQuest(64,1); Log("Completing Objective: [10]The Forgotten Heirloom - Furlbrow's Pocket Watch");
        Log("Collecting Sack of Oats while in the area");
        --[458]Harvest Watcher,[715]Riverpaw Gnoll,[171]Defias Looter
        GrindAndGather(TableToList({458,715,171}),100,TableToFloatArray({-10368.7,1258.32,35.27}),false,"PoorOldBlanchyIngredients",true);
        TurnInQuestUsingDB(64); Log("Turn-in: [10]The Forgotten Heirloom");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Saldean's Farm Introduction
        Log("Step 1-3: Saldean's Farm Introduction");
        TurnInQuestUsingDB(36); Log("Turn-in: [9]Westfall Stew");
        AcceptQuestUsingDB(38); Log("Accepting: [14]Westfall Stew");
        AcceptQuestUsingDB(103); Log("Accepting: [11]Goretusk Liver Pie");
        TurnInQuestUsingDB(151); Log("Turn-in: [9]Poor Old Blanchy");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Initial Ingredient Collection
        Log("Step 1-4: Initial Ingredient Collection");
        Log("Collecting Goretusk Liver and other ingredients");
        --[454]Young Goretusk,[157]Goretusk,[547]Murloc Warrior
        GrindAndGather(TableToList({454,157,547}),150,TableToFloatArray({-10678.2,1166.89,33.25}),false,"WestfallStewIngredients",true);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Level 11 Check
        Log("Step 1-5: Level 11 Check");
        if(Player.Level < 11) then
            LevelTarget = 11
            Log("Grinding to Level "..LevelTarget.." for better quest access.");
            --[454]Young Goretusk,[157]Goretusk,[458]Harvest Watcher
            GrindAndGather(TableToList({454,157,458}),150,TableToFloatArray({-10678.2,1166.89,33.25}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 11");
end --End Furlbrow's Farm

--Phase 2: Sentinel Hill Hub (Levels 11-13)
if not HasPlayerFinishedQuest(109) then
    --Step 2-1: Sentinel Hill Arrival
        Log("Phase 2: Sentinel Hill Hub - Central Operations");
        AcceptQuestUsingDB(109); Log("Accepting: [10]Report to Gryan Stoutmantle");
        TurnInQuestUsingDB(109); Log("Turn-in: [10]Report to Gryan Stoutmantle");
        AcceptQuestUsingDB(12); Log("Accepting: [14]The People's Militia");
        AcceptQuestUsingDB(102); Log("Accepting: [10]Patrolling Westfall");
        AcceptQuestUsingDB(6181); Log("Accepting: [10]A Swift Message");
        GoToNPC(1571,"Thor"); --Get flight path
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Set Hearthstone and Accept More Quests
        Log("Step 2-2: Set Hearthstone and Accept More Quests");
        GoToNPC(6790,"Innkeeper Heather"); --Set hearthstone
        UseMacro("Gossip01");
        AcceptQuestUsingDB(214); Log("Accepting: [10]Red Leather Bandanas");
        AcceptQuestUsingDB(153); Log("Accepting: [10]The Killing Fields");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Stormwind City Quick Trip
        Log("Step 2-3: Stormwind City Quick Trip");
        TurnInQuestUsingDB(6181); Log("Turn-in: [10]A Swift Message");
        AcceptQuestUsingDB(6281); Log("Accepting: [10]Continue to Stormwind");
        TurnInQuestUsingDB(6281); Log("Turn-in: [10]Continue to Stormwind");
        AcceptQuestUsingDB(6261); Log("Accepting: [10]Dungar Longdrink");
        TurnInQuestUsingDB(6261); Log("Turn-in: [10]Dungar Longdrink");
        AcceptQuestUsingDB(6285); Log("Accepting: [10]Return to Lewis");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Return to Westfall
        Log("Step 2-4: Return to Westfall");
        UseHearthStone(); Log("Hearthing back to Sentinel Hill");
        TurnInQuestUsingDB(6285); Log("Turn-in: [10]Return to Lewis");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Initial Collection Phase
        Log("Step 2-5: Initial Collection Phase");
        Log("Starting collection of Red Leather Bandanas and Gnoll Paws");
        --[715]Riverpaw Gnoll,[590]Defias Bandit,[171]Defias Looter
        GrindAndGather(TableToList({715,590,171}),200,TableToFloatArray({-9960.7,1318.75,40.33}),false,"RedLeatherBandanas",true);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-6: Gnoll Paw Collection
        Log("Step 2-6: Gnoll Paw Collection");
        --[715]Riverpaw Gnoll,[506]Riverpaw Outrunner,[124]Riverpaw Mystic
        GrindAndGather(TableToList({715,506,124}),150,TableToFloatArray({-11185.4,1470.60,90.26}),false,"GnollPaws",true);
        TurnInQuestUsingDB(102); Log("Turn-in: [10]Patrolling Westfall");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-7: Level 12 Check
        Log("Step 2-7: Level 12 Check");
        if(Player.Level < 12) then
            LevelTarget = 12
            Log("Grinding to Level "..LevelTarget.." for upcoming content.");
            --[590]Defias Bandit,[171]Defias Looter,[458]Harvest Watcher
            GrindAndGather(TableToList({590,171,458}),200,TableToFloatArray({-10368.7,1258.32,35.27}),false,"LevelCheck",true);
        end
end --End Sentinel Hill Initial

--Phase 3: The People's Militia Chain (Levels 12-14)
if not HasPlayerFinishedQuest(12) then
    --Step 3-1: People's Militia Preparation
        Log("Phase 3: The People's Militia Chain");
        Log("Continuing Defias Bandit elimination");
        --[171]Defias Looter,[590]Defias Bandit,[456]Defias Pillager
        GrindAndGather(TableToList({171,590,456}),300,TableToFloatArray({-11138.5,664.69,21.32}),false,"",true);
        TurnInQuestUsingDB(214); Log("Turn-in: [10]Red Leather Bandanas");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: The People's Militia Completion
        Log("Step 3-2: The People's Militia Completion");
        TurnInQuestUsingDB(12); Log("Turn-in: [14]The People's Militia");
        AcceptQuestUsingDB(13); Log("Accepting: [14]The People's Militia");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Westfall Stew Ingredients Collection
        Log("Step 3-3: Westfall Stew Ingredients Collection");
        CompleteObjectiveOfQuest(38,1); Log("Completing Objective: [14]Westfall Stew - Collect 3 Goretusk Snouts");
        CompleteObjectiveOfQuest(38,2); Log("Completing Objective: [14]Westfall Stew - Collect 3 Murloc Eyes");
        CompleteObjectiveOfQuest(38,3); Log("Completing Objective: [14]Westfall Stew - Collect 3 Stringy Vulture Meat");
        TurnInQuestUsingDB(38); Log("Turn-in: [14]Westfall Stew");
        AcceptQuestUsingDB(39); Log("Accepting: [15]Westfall Stew");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Goretusk Liver Pie
        Log("Step 3-4: Goretusk Liver Pie");
        CompleteObjectiveOfQuest(103,1); Log("Completing Objective: [11]Goretusk Liver Pie - Collect 8 Goretusk Livers");
        TurnInQuestUsingDB(103); Log("Turn-in: [11]Goretusk Liver Pie");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Level 13 Safety Check
        Log("Step 3-5: Level 13 Safety Check");
        if(Player.Level < 13) then
            LevelTarget = 13
            Log("Grinding to Level "..LevelTarget.." for better survivability.");
            --[157]Goretusk,[547]Murloc Warrior,[51]Diseased Vulture
            GrindAndGather(TableToList({157,547,51}),200,TableToFloatArray({-10885.3,1018.75,6.85}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 13");
end --End People's Militia

--Phase 4: Defias Brotherhood Chain (Levels 13-16)
if not HasPlayerFinishedQuest(155) then
    --Step 4-1: The People's Militia Part 2
        Log("Phase 4: Defias Brotherhood Investigation");
        TurnInQuestUsingDB(13); Log("Turn-in: [14]The People's Militia");
        AcceptQuestUsingDB(214); Log("Accepting: [14]The Defias Brotherhood");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Redridge Mountains Trip
        Log("Step 4-2: Redridge Mountains Trip");
        -- Travel to Redridge Mountains for quest continuation
        QuestGoToPoint(-9431.37,-2174.83,93.22); -- Redridge Mountains
        AcceptQuestUsingDB(219); Log("Accepting: [14]The Defias Brotherhood");
        TurnInQuestUsingDB(219); Log("Turn-in: [14]The Defias Brotherhood");
        AcceptQuestUsingDB(155); Log("Accepting: [16]The Defias Brotherhood");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: Stormwind Investigation
        Log("Step 4-3: Stormwind Investigation");
        -- Travel to Stormwind for investigation
        QuestGoToPoint(-8869.03,676.46,97.90); -- Stormwind Gates
        TurnInQuestUsingDB(155); Log("Turn-in: [16]The Defias Brotherhood");
        AcceptQuestUsingDB(166); Log("Accepting: [16]The Defias Brotherhood");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Return to Westfall
        Log("Step 4-4: Return to Westfall");
        UseHearthStone(); Log("Hearthing back to Sentinel Hill");
        TurnInQuestUsingDB(166); Log("Turn-in: [16]The Defias Brotherhood");
        AcceptQuestUsingDB(1948); Log("Accepting: [16]The Defias Brotherhood");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-5: Moonbrook Preparation
        Log("Step 4-5: Moonbrook Preparation");
        if IsHardCore == "true" then
            PopMessage("Moonbrook has high-level Defias - very dangerous area! Consider getting help or being level 16+");
        end
        CompleteObjectiveOfQuest(1948,1); Log("Completing Objective: [16]The Defias Brotherhood - Kill Defias Messenger");
        TurnInQuestUsingDB(1948); Log("Turn-in: [16]The Defias Brotherhood");
        AcceptQuestUsingDB(139); Log("Accepting: [18]The Defias Brotherhood");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-6: Level 14 Check
        Log("Step 4-6: Level 14 Check");
        if(Player.Level < 14) then
            LevelTarget = 14
            Log("Grinding to Level "..LevelTarget.." for class training and better survival.");
            --[590]Defias Bandit,[171]Defias Looter,[456]Defias Pillager
            GrindAndGather(TableToList({590,171,456}),250,TableToFloatArray({-11138.5,664.69,21.32}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 14");
end --End Defias Investigation

--Phase 5: Westfall Lighthouse and Collection (Levels 14-16)
if not HasPlayerFinishedQuest(104) then
    --Step 5-1: Westfall Lighthouse
        Log("Phase 5: Westfall Lighthouse and Collection Quests");
        AcceptQuestUsingDB(104); Log("Accepting: [13]The Coast Isn't Clear");
        AcceptQuestUsingDB(105); Log("Accepting: [16]Keeper of the Flame");
        AcceptQuestUsingDB(1024); Log("Accepting: [13]Coastal Menace");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: Captain Sanders' Treasure Map (Optional)
        Log("Step 5-2: Captain Sanders' Treasure Map (Optional)");
        if HasItem("Captain Sanders' Treasure Map") then
            AcceptQuestUsingDB(138); Log("Accepting: [13]Captain Sanders' Hidden Treasure");
            CompleteObjectiveOfQuest(138,1); Log("Completing Objective: [13]Captain Sanders' Hidden Treasure - First Treasure");
            TurnInQuestUsingDB(138); Log("Turn-in: [13]Captain Sanders' Hidden Treasure");
            AcceptQuestUsingDB(1284); Log("Accepting: [13]Captain Sanders' Hidden Treasure");
            CompleteObjectiveOfQuest(1284,1); Log("Completing Objective: [13]Captain Sanders' Hidden Treasure - Second Treasure");
            TurnInQuestUsingDB(1284); Log("Turn-in: [13]Captain Sanders' Hidden Treasure");
            AcceptQuestUsingDB(1285); Log("Accepting: [13]Captain Sanders' Hidden Treasure");
            CompleteObjectiveOfQuest(1285,1); Log("Completing Objective: [13]Captain Sanders' Hidden Treasure - Final Treasure");
            TurnInQuestUsingDB(1285); Log("Turn-in: [13]Captain Sanders' Hidden Treasure");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: Murloc and Coastal Operations
        Log("Step 5-3: Murloc and Coastal Operations");
        CompleteObjectiveOfQuest(104,1); Log("Completing Objective: [13]The Coast Isn't Clear - Kill 12 Murloc Coastrunners");
        CompleteObjectiveOfQuest(104,2); Log("Completing Objective: [13]The Coast Isn't Clear - Kill 10 Murloc Warriors");
        CompleteObjectiveOfQuest(1024,1); Log("Completing Objective: [13]Coastal Menace - Kill Old Murk-Eye");
        TurnInQuestUsingDB(104); Log("Turn-in: [13]The Coast Isn't Clear");
        TurnInQuestUsingDB(1024); Log("Turn-in: [13]Coastal Menace");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Oil Collection for Lighthouse
        Log("Step 5-4: Oil Collection for Lighthouse");
        CompleteObjectiveOfQuest(105,1); Log("Completing Objective: [16]Keeper of the Flame - Collect 5 Flasks of Oil");
        TurnInQuestUsingDB(105); Log("Turn-in: [16]Keeper of the Flame");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-5: Level 15 Check
        Log("Step 5-5: Level 15 Check");
        if(Player.Level < 15) then
            LevelTarget = 15
            Log("Grinding to Level "..LevelTarget.." for upcoming elite content.");
            --[171]Defias Looter,[590]Defias Bandit,[547]Murloc Warrior
            GrindAndGather(TableToList({171,590,547}),250,TableToFloatArray({-11138.5,664.69,21.32}),false,"LevelCheck",true);
        end
end --End Lighthouse

--Phase 6: The Killing Fields and Advanced Content (Levels 15-17)
if not HasPlayerFinishedQuest(153) then
    --Step 6-1: The Killing Fields
        Log("Phase 6: The Killing Fields and Advanced Content");
        CompleteObjectiveOfQuest(153,1); Log("Completing Objective: [10]The Killing Fields - Kill 20 Harvest Watchers");
        TurnInQuestUsingDB(153); Log("Turn-in: [10]The Killing Fields");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Westfall Stew Completion
        Log("Step 6-2: Westfall Stew Completion");
        TurnInQuestUsingDB(39); Log("Turn-in: [15]Westfall Stew");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Level 16 Preparation for Deadmines
        Log("Step 6-3: Level 16 Preparation for Deadmines");
        if(Player.Level < 16) then
            LevelTarget = 16
            Log("Grinding to Level "..LevelTarget.." for Deadmines preparation.");
            --[456]Defias Pillager,[590]Defias Bandit,[458]Harvest Watcher
            GrindAndGather(TableToList({456,590,458}),300,TableToFloatArray({-11138.5,664.69,21.32}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 16");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Deadmines Preparation Quests
        Log("Step 6-4: Deadmines Preparation Quests");
        AcceptQuestUsingDB(167); Log("Accepting: [14]Red Silk Bandanas");
        AcceptQuestUsingDB(214); Log("Accepting: [15]Oh Brother...");
        if GetPlayerClass() == "Paladin" and Player.Level >= 20 then
            AcceptQuestUsingDB(1642); Log("Accepting: [20]The Test of Righteousness");
        end
end --End Killing Fields

--Phase 7: Deadmines Escort and Preparation (Levels 16-18)
if not HasPlayerFinishedQuest(139) then
    --Step 7-1: The Defias Brotherhood Escort
        Log("Phase 7: Deadmines Escort and Preparation");
        if IsHardCore == "true" then
            PopMessage("Escort quest to Moonbrook ahead - protect the NPC carefully! Defias will attack!");
        end
        CompleteObjectiveOfQuest(139,1); Log("Completing Objective: [18]The Defias Brotherhood - Escort Defias Traitor");
        TurnInQuestUsingDB(139); Log("Turn-in: [18]The Defias Brotherhood");
        AcceptQuestUsingDB(155); Log("Accepting: [22]The Defias Brotherhood");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Pre-Deadmines Quests
        Log("Step 7-2: Pre-Deadmines Quests");
        if EliteQuests == "true" then
            -- These are Deadmines dungeon quests
            Log("Deadmines dungeon quests available - group content recommended");
            if IsHardCore == "true" then
                PopMessage("Deadmines is a level 18-23 dungeon. Form a group for safety!");
            end
        else
            Log("Elite/Dungeon quests disabled - skipping Deadmines preparation");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Level 17 Check
        Log("Step 7-3: Level 17 Check");
        if(Player.Level < 17) then
            LevelTarget = 17
            Log("Grinding to Level "..LevelTarget.." for dungeon preparation.");
            --[590]Defias Bandit,[456]Defias Pillager,[171]Defias Looter
            GrindAndGather(TableToList({590,456,171}),350,TableToFloatArray({-11138.5,664.69,21.32}),false,"LevelCheck",true);
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Optional Grinding for Better Preparation
        Log("Step 7-4: Optional Grinding for Better Preparation");
        if SafetyGrind == "true" then
            LevelTarget = 18
            Log("Safety Grind: Grinding to Level "..LevelTarget.." for better Deadmines success");
            --[590]Defias Bandit,[456]Defias Pillager,[458]Harvest Watcher,[171]Defias Looter
            GrindAndGather(TableToList({590,456,458,171}),400,TableToFloatArray({-11138.5,664.69,21.32}),false,"LevelCheck",true);
        end
end --End Escort Preparation

--Phase 8: Zone Completion and Transition (Levels 17-20)
if not HasPlayerFinishedQuest(155) or not Player.Level >= 18 then
    --Step 8-1: Final Quest Cleanup
        Log("Phase 8: Zone Completion and Transition Preparation");
        if EliteQuests == "true" then
            Log("Deadmines dungeon completion - group required");
            -- The final Defias Brotherhood quest requires killing Edwin VanCleef in Deadmines
            PopMessage("Complete Deadmines dungeon to finish The Defias Brotherhood quest chain");
            PopMessage("Recommended group: Tank, Healer, 3 DPS. Level 18-23 dungeon.");
            PopMessage("Key bosses: Rhahk'Zor, Sneed, Gilnid, Mr. Smite, Edwin VanCleef");
        else
            Log("Elite quests disabled - Deadmines completion skipped");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-2: Level 18 Final Preparation
        Log("Step 8-2: Level 18 Final Preparation");
        if(Player.Level < 18) then
            LevelTarget = 18
            Log("Final grind to Level "..LevelTarget.." for optimal zone completion.");
            --[590]Defias Bandit,[456]Defias Pillager,[458]Harvest Watcher,[171]Defias Looter
            GrindAndGather(TableToList({590,456,458,171}),400,TableToFloatArray({-11138.5,664.69,21.32}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-3: Next Zone Preparation
        Log("Step 8-3: Next Zone Preparation");
        AcceptQuestUsingDB(1477); Log("Accepting: [18]Vital Supplies - leads to Redridge Mountains");
        AcceptQuestUsingDB(65); Log("Accepting: [20]The Hermit - leads to Dustwallow Marsh");
        PopMessage("Westfall questing complete! Ready for:");
        PopMessage("- Redridge Mountains (15-25) for continued leveling");
        PopMessage("- Loch Modan (10-20) if not completed");
        PopMessage("- Darkshore (10-20) for variety");
        PopMessage("- Deadmines dungeon (18-23) for gear and experience");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-4: Zone Completion Message
        Log("Step 8-4: Zone Completion Message");
        if IsHardCore == "true" then
            PopMessage("Westfall complete! Take boat from Menethil Harbor to continue in Eastern Kingdoms or explore Kalimdor");
        end
        if SafetyGrind == "true" then
            LevelTarget = 20
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Westfall");
            --[590]Defias Bandit,[456]Defias Pillager,[458]Harvest Watcher,[171]Defias Looter,[157]Goretusk
            GrindAndGather(TableToList({590,456,458,171,157}),500,TableToFloatArray({-11138.5,664.69,21.32}),false,"LevelCheck",true);
        end
        PopMessage("Westfall questing complete at level " .. Player.Level .. "! Defias Brotherhood awaits in the Deadmines!");
end --End Westfall

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();