-- Darkshore Questing Profile (10-20)
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
function BuzzboxItems()
    if ItemCount("Crawler Leg") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(983) then
        return false
    else
        return true
    end
end
function ThresherEyes()
    if ItemCount("Thresher Eye") >= 3 then
        return false
    elseif HasPlayerFinishedQuest(1001) then
        return false
    else
        return true
    end
end
function MoonstalkerFangs()
    if ItemCount("Moonstalker Fang") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(986) then
        return false
    else
        return true
    end
end
function CorruptedBrainStems()
    if ItemCount("Corrupted Brain Stem") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(1275) then
        return false
    else
        return true
    end
end

--Phase 1: Auberdine Arrival and Setup (Levels 10-12)
if not HasPlayerFinishedQuest(6344) then
    --Step 1-1: Auberdine Arrival and Registration
        Log("Phase 1: Auberdine Arrival and Setup");
        TurnInQuestUsingDB(6344); Log("Turn-in: [10]Breaking Waves of Change");
        GoToNPC(6736,"Innkeeper Keldamyr"); --Set hearthstone
        UseMacro("Gossip01");
        SleepPlugin(2000);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Initial Quest Collection
        Log("Step 1-2: Initial Quest Collection");
        AcceptQuestUsingDB(4681); Log("Accepting: [12]Washed Ashore");
        AcceptQuestUsingDB(983); Log("Accepting: [12]Buzzbox 827");
        AcceptQuestUsingDB(963); Log("Accepting: [15]For Love Eternal");
        AcceptQuestUsingDB(948); Log("Accepting: [16]The Corruption Abroad");
        AcceptQuestUsingDB(947); Log("Accepting: [16]Cave Mushrooms");
        AcceptQuestUsingDB(954); Log("Accepting: [11]Bashal'Aran");
        AcceptQuestUsingDB(958); Log("Accepting: [16]Tools of the Highborne");
        AcceptQuestUsingDB(4811); Log("Accepting: [13]How Big a Threat?");
        AcceptQuestUsingDB(4813); Log("Accepting: [13]Plagued Lands");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Night Elf Specific Quests
        Log("Step 1-3: Night Elf Specific Quests");
        if GetPlayerClass() == "Night Elf" then
            AcceptQuestUsingDB(928); Log("Accepting: [11]Grove of the Ancients");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Coastal Collection Phase
        Log("Step 1-4: Coastal Collection Phase");
        Log("Starting coastal creature collection");
        --[2091]Elder Darkshore Thresher,[2234]Young Reef Crawler,[2235]Reef Crawler
        GrindAndGather(TableToList({2091,2234,2235}),100,TableToFloatArray({8250.2,864.61,22.55}),false,"BuzzboxItems",true);
        CompleteObjectiveOfQuest(4681,1); Log("Completing Objective: [12]Washed Ashore - Collect Sea Creature Bones");
        TurnInQuestUsingDB(983); Log("Turn-in: [12]Buzzbox 827");
        AcceptQuestUsingDB(1001); Log("Accepting: [12]Buzzbox 411");
        TurnInQuestUsingDB(4681); Log("Turn-in: [12]Washed Ashore");
        AcceptQuestUsingDB(4681); Log("Accepting: [12]Washed Ashore");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Thresher Eye Collection
        Log("Step 1-5: Thresher Eye Collection");
        CompleteObjectiveOfQuest(4681,1); Log("Completing Objective: [12]Washed Ashore - Collect Sea Turtle Remains");
        Log("Collecting Thresher Eyes for Buzzbox 411");
        --[2091]Elder Darkshore Thresher
        GrindAndGather(TableToList({2091}),100,TableToFloatArray({8442.12,1228.54,8.85}),false,"ThresherEyes",true);
        TurnInQuestUsingDB(1001); Log("Turn-in: [12]Buzzbox 411");
        AcceptQuestUsingDB(1002); Log("Accepting: [15]Buzzbox 323");
        TurnInQuestUsingDB(4681); Log("Turn-in: [12]Washed Ashore");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Level 12 Check and Training
        Log("Step 1-6: Level 12 Check and Training");
        if(Player.Level < 12) then
            LevelTarget = 12
            Log("Grinding to Level "..LevelTarget..".");
            --[2091]Elder Darkshore Thresher,[2234]Young Reef Crawler,[2235]Reef Crawler
            GrindAndGather(TableToList({2091,2234,2235}),150,TableToFloatArray({8250.2,864.61,22.55}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 12");
end --End Initial Setup

--Phase 2: Bashal'Aran Operations (Level 12-14)
if not HasPlayerFinishedQuest(954) then
    --Step 2-1: Bashal'Aran Investigation
        Log("Phase 2: Bashal'Aran Operations");
        TurnInQuestUsingDB(954); Log("Turn-in: [11]Bashal'Aran");
        AcceptQuestUsingDB(955); Log("Accepting: [14]Bashal'Aran");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Grell and Sprite Elimination
        Log("Step 2-2: Grell and Sprite Elimination");
        CompleteObjectiveOfQuest(955,1); Log("Completing Objective: [14]Bashal'Aran - Collect 4 Grell Earrings");
        CompleteObjectiveOfQuest(955,2); Log("Completing Objective: [14]Bashal'Aran - Kill 8 Vile Sprites");
        TurnInQuestUsingDB(955); Log("Turn-in: [14]Bashal'Aran");
        AcceptQuestUsingDB(956); Log("Accepting: [17]Bashal'Aran");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Satyr Hunt
        Log("Step 2-3: Satyr Hunt");
        CompleteObjectiveOfQuest(956,1); Log("Completing Objective: [17]Bashal'Aran - Kill Deth'ryll Satyr");
        TurnInQuestUsingDB(956); Log("Turn-in: [17]Bashal'Aran");
        AcceptQuestUsingDB(957); Log("Accepting: [17]Bashal'Aran");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Crystal Activation
        Log("Step 2-4: Crystal Activation");
        CompleteObjectiveOfQuest(957,1); Log("Completing Objective: [17]Bashal'Aran - Touch the Mysterious Red Crystal");
        TurnInQuestUsingDB(957); Log("Turn-in: [17]Bashal'Aran");
        AcceptQuestUsingDB(970); Log("Accepting: [18]The Fall of Ameth'Aran");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Plagued Lands Collection
        Log("Step 2-5: Plagued Lands Collection");
        CompleteObjectiveOfQuest(4813,1); Log("Completing Objective: [13]Plagued Lands - Use Reliquary on 8 Rabid Thistle Bears");
        CompleteObjectiveOfQuest(4811,1); Log("Completing Objective: [13]How Big a Threat? - Assess Furbolg Threat");
        TurnInQuestUsingDB(4813); Log("Turn-in: [13]Plagued Lands");
        AcceptQuestUsingDB(4812); Log("Accepting: [15]Cleansing of the Infected");
end --End Bashal'Aran

--Phase 3: Central Darkshore Operations (Level 14-16)
if not HasPlayerFinishedQuest(947) then
    --Step 3-1: Cave Mushroom Collection
        Log("Phase 3: Central Darkshore Operations");
        CompleteObjectiveOfQuest(947,1); Log("Completing Objective: [16]Cave Mushrooms - Collect 5 Scaber Stalks");
        CompleteObjectiveOfQuest(947,2); Log("Completing Objective: [16]Cave Mushrooms - Collect 1 Death Cap");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: The Red Crystal Quest
        Log("Step 3-2: The Red Crystal Quest");
        AcceptQuestUsingDB(4812); Log("Accepting: [14]The Red Crystal");
        TurnInQuestUsingDB(4812); Log("Turn-in: [14]The Red Crystal");
        AcceptQuestUsingDB(4813); Log("Accepting: [16]As Water Cascades");
        CompleteObjectiveOfQuest(4813,1); Log("Completing Objective: [16]As Water Cascades - Fill Empty Water Tube");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Cleansing Bowl Ritual
        Log("Step 3-3: Cleansing Bowl Ritual");
        CompleteObjectiveOfQuest(4812,1); Log("Completing Objective: [15]Cleansing of the Infected - Fill Empty Cleansing Bowl");
        TurnInQuestUsingDB(4812); Log("Turn-in: [15]Cleansing of the Infected");
        TurnInQuestUsingDB(4811); Log("Turn-in: [13]How Big a Threat?");
        AcceptQuestUsingDB(4821); Log("Accepting: [17]How Big a Threat?");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Thundris Windweaver Chain
        Log("Step 3-4: Thundris Windweaver Chain");
        AcceptQuestUsingDB(4813); Log("Accepting: [15]Thundris Windweaver");
        TurnInQuestUsingDB(4813); Log("Turn-in: [15]Thundris Windweaver");
        AcceptQuestUsingDB(4762); Log("Accepting: [15]The Cliffspring River");
        AcceptQuestUsingDB(958); Log("Accepting: [15]Tools of the Highborne");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Moonstalker Collection
        Log("Step 3-5: Moonstalker Collection");
        Log("Starting Moonstalker Fang collection for A Lost Master");
        --[2237]Moonstalker Sire,[2238]Moonstalker Matriarch,[2164]Moonstalker
        GrindAndGather(TableToList({2237,2238,2164}),100,TableToFloatArray({7888.26,1386.49,36.70}),false,"MoonstalkerFangs",true);
        TurnInQuestUsingDB(1002); Log("Turn-in: [15]Buzzbox 323");
        AcceptQuestUsingDB(1003); Log("Accepting: [17]Buzzbox 525");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-6: Level 15 Check and Training
        Log("Step 3-6: Level 15 Check and Training");
        if(Player.Level < 15) then
            LevelTarget = 15
            Log("Grinding to Level "..LevelTarget..".");
            --[2237]Moonstalker Sire,[2238]Moonstalker Matriarch,[2164]Moonstalker,[2212]Raging Thistle Bear
            GrindAndGather(TableToList({2237,2238,2164,2212}),200,TableToFloatArray({7888.26,1386.49,36.70}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 15");
end --End Central Operations

--Phase 4: The Corruption Abroad and Research (Level 15-17)
if not HasPlayerFinishedQuest(948) then
    --Step 4-1: Corruption Research Setup
        Log("Phase 4: The Corruption Abroad and Research");
        TurnInQuestUsingDB(948); Log("Turn-in: [16]The Corruption Abroad");
        AcceptQuestUsingDB(1275); Log("Accepting: [18]Researching the Corruption");
        AcceptQuestUsingDB(984); Log("Accepting: [16]A Lost Master");
        AcceptQuestUsingDB(4723); Log("Accepting: [16]The Absent Minded Prospector");
        AcceptQuestUsingDB(4761); Log("Accepting: [16]The Blackwood Corrupted");
        AcceptQuestUsingDB(4764); Log("Accepting: [18]Tharnariun's Hope");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Grove of the Ancients
        Log("Step 4-2: Grove of the Ancients");
        if HasPlayerFinishedQuest(928) then
            TurnInQuestUsingDB(928); Log("Turn-in: [11]Grove of the Ancients");
            AcceptQuestUsingDB(929); Log("Accepting: [19]The Master's Glaive");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: Buzzbox 525 Collection
        Log("Step 4-3: Buzzbox 525 Collection");
        CompleteObjectiveOfQuest(1003,1); Log("Completing Objective: [17]Buzzbox 525 - Collect 4 Grizzled Scalps");
        TurnInQuestUsingDB(1003); Log("Turn-in: [17]Buzzbox 525");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Master's Glaive Operations
        Log("Step 4-4: Master's Glaive Operations");
        if HasPlayerFinishedQuest(929) then
            CompleteObjectiveOfQuest(929,1); Log("Completing Objective: [19]The Master's Glaive - Explore the Master's Glaive");
            TurnInQuestUsingDB(929); Log("Turn-in: [19]The Master's Glaive");
            AcceptQuestUsingDB(930); Log("Accepting: [19]The Twilight Camp");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-5: Cliffspring River Operations
        Log("Step 4-5: Cliffspring River Operations");
        CompleteObjectiveOfQuest(4762,1); Log("Completing Objective: [15]The Cliffspring River - Fill Cliffspring River Sample");
        TurnInQuestUsingDB(4762); Log("Turn-in: [15]The Cliffspring River");
        AcceptQuestUsingDB(4763); Log("Accepting: [17]The Cliffspring River");
        CompleteObjectiveOfQuest(4763,1); Log("Completing Objective: [17]The Cliffspring River - Collect The Fragments Within");
        TurnInQuestUsingDB(4763); Log("Turn-in: [17]The Cliffspring River");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-6: Sea Creature Collections
        Log("Step 4-6: Sea Creature Collections");
        Log("Collecting beached sea creatures");
        CompleteObjectiveOfQuest(4681,1); Log("Completing Objective: [16]Beached Sea Creature");
        CompleteObjectiveOfQuest(4681,2); Log("Completing Objective: [16]Beached Sea Turtle");
        CompleteObjectiveOfQuest(4681,3); Log("Completing Objective: [16]Beached Sea Creature");
        CompleteObjectiveOfQuest(4681,4); Log("Completing Objective: [16]Beached Sea Creature");
end --End Corruption Research

--Phase 5: Tower of Althalaxx Chain (Level 17-18) - Elite Content
if not HasPlayerFinishedQuest(981) then
    --Step 5-1: Tower of Althalaxx Introduction
        Log("Phase 5: Tower of Althalaxx Chain - Elite Content");
        AcceptQuestUsingDB(965); Log("Accepting: [17]The Tower of Althalaxx");
        if EliteQuests == "true" then
            if IsHardCore == "true" then
                PopMessage("Tower of Althalaxx has dangerous elite enemies! Consider getting help.");
            end
            CompleteObjectiveOfQuest(965,1); Log("Completing Objective: [17]The Tower of Althalaxx - Kill Ilkrud Magthrull");
            TurnInQuestUsingDB(965); Log("Turn-in: [17]The Tower of Althalaxx");
            AcceptQuestUsingDB(966); Log("Accepting: [18]The Tower of Althalaxx");
            ------------------------------------------------------------------
            ------------------------------------------------------------------
            --Step 5-2: Tome Recovery
            Log("Step 5-2: Tome Recovery");
            CompleteObjectiveOfQuest(966,1); Log("Completing Objective: [18]The Tower of Althalaxx - Loot Ilkrud Magthrull's Tome");
            TurnInQuestUsingDB(966); Log("Turn-in: [18]The Tower of Althalaxx");
            AcceptQuestUsingDB(967); Log("Accepting: [22]The Tower of Althalaxx");
            ------------------------------------------------------------------
            ------------------------------------------------------------------
            --Step 5-3: Balthule Shadowstrike Chain
            Log("Step 5-3: Balthule Shadowstrike Chain");
            CompleteObjectiveOfQuest(967,1); Log("Completing Objective: [22]The Tower of Althalaxx - Find Balthule Shadowstrike");
            TurnInQuestUsingDB(967); Log("Turn-in: [22]The Tower of Althalaxx");
            AcceptQuestUsingDB(968); Log("Accepting: [22]The Tower of Althalaxx");
            CompleteObjectiveOfQuest(968,1); Log("Completing Objective: [22]The Tower of Althalaxx - Kill Arugal's Voidwalkers");
            TurnInQuestUsingDB(968); Log("Turn-in: [22]The Tower of Althalaxx");
            AcceptQuestUsingDB(969); Log("Accepting: [25]The Tower of Althalaxx");
            ------------------------------------------------------------------
            ------------------------------------------------------------------
            --Step 5-4: Elite Tower Operations
            Log("Step 5-4: Elite Tower Operations");
            CompleteObjectiveOfQuest(969,1); Log("Completing Objective: [25]The Tower of Althalaxx - Kill Athrikus Narassin");
            TurnInQuestUsingDB(969); Log("Turn-in: [25]The Tower of Althalaxx");
            AcceptQuestUsingDB(981); Log("Accepting: [26]The Tower of Althalaxx");
        else
            Log("Elite Quests disabled - skipping Tower of Althalaxx");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-5: Level 17 Check
        Log("Step 5-5: Level 17 Check");
        if(Player.Level < 17) then
            LevelTarget = 17
            Log("Grinding to Level "..LevelTarget..".");
            --[2164]Moonstalker,[2212]Raging Thistle Bear,[2237]Moonstalker Sire
            GrindAndGather(TableToList({2164,2212,2237}),250,TableToFloatArray({7888.26,1386.49,36.70}),false,"LevelCheck",true);
        end
end --End Tower Chain

--Phase 6: Major Quest Completions (Level 17-19)
if not HasPlayerFinishedQuest(984) then
    --Step 6-1: A Lost Master Completion
        Log("Phase 6: Major Quest Completions");
        TurnInQuestUsingDB(984); Log("Turn-in: [16]A Lost Master");
        AcceptQuestUsingDB(985); Log("Accepting: [20]Onu");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Blackwood Corrupted Chain
        Log("Step 6-2: Blackwood Corrupted Chain");
        CompleteObjectiveOfQuest(4761,1); Log("Completing Objective: [16]The Blackwood Corrupted - Use Filled Cleansing Bowl");
        CompleteObjectiveOfQuest(4761,2); Log("Completing Objective: [16]The Blackwood Corrupted - Kill Xabraxxis");
        CompleteObjectiveOfQuest(4761,3); Log("Completing Objective: [16]The Blackwood Corrupted - Collect Blackwood Grain/Nut/Fruit");
        TurnInQuestUsingDB(4761); Log("Turn-in: [16]The Blackwood Corrupted");
        AcceptQuestUsingDB(4762); Log("Accepting: [18]The Blackwood Corrupted");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Twilight Camp Operations
        Log("Step 6-3: Twilight Camp Operations");
        if HasPlayerFinishedQuest(930) then
            CompleteObjectiveOfQuest(930,1); Log("Completing Objective: [19]The Twilight Camp - Kill Twilight Acolytes");
            TurnInQuestUsingDB(930); Log("Turn-in: [19]The Twilight Camp");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Research Completion
        Log("Step 6-4: Research Completion");
        if ItemCount("Corrupted Brain Stem") >= 8 then
            TurnInQuestUsingDB(1275); Log("Turn-in: [18]Researching the Corruption");
        else
            Log("Need to collect more Corrupted Brain Stems");
            --Various Murlocs and Naga
            GrindAndGather(TableToList({2242,2243,2244}),150,TableToFloatArray({8050.12,1650.84,12.45}),false,"CorruptedBrainStems",true);
            TurnInQuestUsingDB(1275); Log("Turn-in: [18]Researching the Corruption");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-5: Level 18 Check and Training
        Log("Step 6-5: Level 18 Check and Training");
        if(Player.Level < 18) then
            LevelTarget = 18
            Log("Grinding to Level "..LevelTarget..".");
            --[2164]Moonstalker,[2212]Raging Thistle Bear,[2237]Moonstalker Sire,[2242]Syndicate Spy
            GrindAndGather(TableToList({2164,2212,2237,2242}),300,TableToFloatArray({7888.26,1386.49,36.70}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 18");
end --End Major Completions

--Phase 7: For Love Eternal and Final Operations (Level 18-20)
if not HasPlayerFinishedQuest(963) then
    --Step 7-1: Ameth'Aran Ghost Story
        Log("Phase 7: For Love Eternal and Final Operations");
        CompleteObjectiveOfQuest(970,1); Log("Completing Objective: [18]The Fall of Ameth'Aran - Examine Ancient Flame");
        TurnInQuestUsingDB(970); Log("Turn-in: [18]The Fall of Ameth'Aran");
        AcceptQuestUsingDB(971); Log("Accepting: [18]For Love Eternal");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Love Eternal Completion
        Log("Step 7-2: Love Eternal Completion");
        CompleteObjectiveOfQuest(971,1); Log("Completing Objective: [18]For Love Eternal - Find Anaya Dawnrunner");
        CompleteObjectiveOfQuest(971,2); Log("Completing Objective: [18]For Love Eternal - Collect Anaya's Pendant");
        TurnInQuestUsingDB(971); Log("Turn-in: [18]For Love Eternal");
        TurnInQuestUsingDB(963); Log("Turn-in: [15]For Love Eternal");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Absent Minded Prospector
        Log("Step 7-3: Absent Minded Prospector");
        if IsHardCore == "true" then
            PopMessage("Absent Minded Prospector escort quest ahead - protect Remtravel carefully!");
        end
        CompleteObjectiveOfQuest(4723,1); Log("Completing Objective: [16]The Absent Minded Prospector - Escort Remtravel");
        TurnInQuestUsingDB(4723); Log("Turn-in: [16]The Absent Minded Prospector");
        AcceptQuestUsingDB(4725); Log("Accepting: [18]Beware of Pterrordax");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Tharnariun's Hope
        Log("Step 7-4: Tharnariun's Hope");
        CompleteObjectiveOfQuest(4764,1); Log("Completing Objective: [18]Tharnariun's Hope - Find Volcor");
        TurnInQuestUsingDB(4764); Log("Turn-in: [18]Tharnariun's Hope");
        AcceptQuestUsingDB(4765); Log("Accepting: [20]Tharnariun's Hope");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-5: Tools of the Highborne
        Log("Step 7-5: Tools of the Highborne");
        CompleteObjectiveOfQuest(958,1); Log("Completing Objective: [16]Tools of the Highborne - Collect Highborne Relic");
        CompleteObjectiveOfQuest(958,2); Log("Completing Objective: [16]Tools of the Highborne - Collect Chest of Containment Coffers");
        TurnInQuestUsingDB(958); Log("Turn-in: [16]Tools of the Highborne");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-6: Level 19 Check
        Log("Step 7-6: Level 19 Check");
        if(Player.Level < 19) then
            LevelTarget = 19
            Log("Grinding to Level "..LevelTarget..".");
            --[2164]Moonstalker,[2212]Raging Thistle Bear,[2237]Moonstalker Sire,[2156]Gargoyle
            GrindAndGather(TableToList({2164,2212,2237,2156}),350,TableToFloatArray({7888.26,1386.49,36.70}),false,"LevelCheck",true);
        end
end --End For Love Eternal

--Phase 8: Final Cleanup and Ashenvale Preparation (Level 19-20)
if not HasPlayerFinishedQuest(985) then
    --Step 8-1: Onu and Ancient Connections
        Log("Phase 8: Final Cleanup and Ashenvale Preparation");
        TurnInQuestUsingDB(985); Log("Turn-in: [20]Onu");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-2: Class-Specific Level 20 Quests
        Log("Step 8-2: Class-Specific Level 20 Quests");
        if Player.Level >= 20 then
            Training(); Log("Training Level 20 Abilities");
            if GetPlayerClass() == "Druid" then
                AcceptQuestUsingDB(1580); Log("Accepting: [20]Elemental Bracers");
            elseif GetPlayerClass() == "Hunter" then
                AcceptQuestUsingDB(6084); Log("Accepting: [20]Taming the Beast");
            elseif GetPlayerClass() == "Priest" then
                AcceptQuestUsingDB(5641); Log("Accepting: [20]Shadowguard");
            elseif GetPlayerClass() == "Warrior" then
                AcceptQuestUsingDB(1718); Log("Accepting: [20]The Affray");
            elseif GetPlayerClass() == "Rogue" then
                AcceptQuestUsingDB(2298); Log("Accepting: [20]Encrypted Letter");
            elseif GetPlayerClass() == "Paladin" then
                AcceptQuestUsingDB(1641); Log("Accepting: [20]The Tome of Valor");
            elseif GetPlayerClass() == "Warlock" then
                AcceptQuestUsingDB(1758); Log("Accepting: [20]Tome of the Cabal");
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-3: Final Quest Turn-ins
        Log("Step 8-3: Final Quest Turn-ins");
        if HasPlayerFinishedQuest(4725) then
            TurnInQuestUsingDB(4725); Log("Turn-in: [18]Beware of Pterrordax");
        end
        if HasPlayerFinishedQuest(4765) then
            TurnInQuestUsingDB(4765); Log("Turn-in: [20]Tharnariun's Hope");
        end
        if HasPlayerFinishedQuest(4762) then
            TurnInQuestUsingDB(4762); Log("Turn-in: [18]The Blackwood Corrupted");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-4: Ashenvale Preparation
        Log("Step 8-4: Ashenvale Preparation");
        AcceptQuestUsingDB(1008); Log("Accepting: [18]The Zoram Strand");
        AcceptQuestUsingDB(1134); Log("Accepting: [19]The Lost Chalice");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-5: Final Level Check and Training
        Log("Step 8-5: Final Level Check and Training");
        if(Player.Level < 20) then
            LevelTarget = 20
            Log("Final grind to Level "..LevelTarget.." before leaving Darkshore.");
            --[2164]Moonstalker,[2212]Raging Thistle Bear,[2237]Moonstalker Sire,[2156]Gargoyle,[2242]Syndicate Spy
            GrindAndGather(TableToList({2164,2212,2237,2156,2242}),400,TableToFloatArray({7888.26,1386.49,36.70}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-6: Zone Transition Setup
        Log("Step 8-6: Zone Transition Setup");
        if IsHardCore == "true" then
            PopMessage("Darkshore complete! Recommended level 18-20 for Ashenvale. Travel south through the zone border.");
        end
        PopMessage("Darkshore questing complete! Ready for Ashenvale at level " .. Player.Level);
        if SafetyGrind == "true" then
            LevelTarget = 21
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Darkshore");
            --[2164]Moonstalker,[2212]Raging Thistle Bear,[2237]Moonstalker Sire,[2156]Gargoyle,[2242]Syndicate Spy
            GrindAndGather(TableToList({2164,2212,2237,2156,2242}),500,TableToFloatArray({7888.26,1386.49,36.70}),false,"LevelCheck",true);
        end
end --End Darkshore

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();