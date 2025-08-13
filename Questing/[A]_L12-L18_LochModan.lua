-- Loch Modan Questing Profile (10-20)
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
function TunnelRatEars()
    if ItemCount("Tunnel Rat Ear") >= 12 then
        return false
    elseif HasPlayerFinishedQuest(416) then
        return false
    else
        return true
    end
end
function ThelsamarBloodSausage()
    if ItemCount("Bear Meat") >= 3 and ItemCount("Boar Intestines") >= 3 and ItemCount("Spider Ichor") >= 3 then
        return false
    elseif HasPlayerFinishedQuest(418) then
        return false
    else
        return true
    end
end
function StonesplinterTroggItems()
    if ItemCount("Stone Tooth") >= 1 then
        return false
    elseif HasPlayerFinishedQuest(267) then
        return false
    else
        return true
    end
end
function PowerCrystals()
    if ItemCount("Intact Power Crystal") >= 4 then
        return false
    elseif HasPlayerFinishedQuest(298) then
        return false
    else
        return true
    end
end

--Phase 1: Valley of Kings Entry (Levels 10-12)
if not HasPlayerFinishedQuest(414) then
    --Step 1-1: Valley of Kings Setup
        Log("Phase 1: Valley of Kings Entry");
        AcceptQuestUsingDB(267); Log("Accepting: [11]In Defense of the King's Lands");
        AcceptQuestUsingDB(224); Log("Accepting: [12]The Trogg Threat");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Stonesplinter Valley Initial Clear
        Log("Step 1-2: Stonesplinter Valley Initial Clear");
        CompleteObjectiveOfQuest(267,1); Log("Completing Objective: [11]In Defense of the King's Lands - Kill 10 Stonesplinter Troggs");
        CompleteObjectiveOfQuest(267,2); Log("Completing Objective: [11]In Defense of the King's Lands - Kill 10 Stonesplinter Scouts");
        CompleteObjectiveOfQuest(224,1); Log("Completing Objective: [12]The Trogg Threat - Collect Stone Tooth");
        Log("Collecting Stone Tooth and clearing Stonesplinter Valley");
        --[1161]Stonesplinter Trogg,[1162]Stonesplinter Scout,[1163]Stonesplinter Skullthumper
        GrindAndGather(TableToList({1161,1162,1163}),200,TableToFloatArray({-5234.15,-2890.47,325.83}),false,"StonesplinterTroggItems",true);
        TurnInQuestUsingDB(267); Log("Turn-in: [11]In Defense of the King's Lands");
        AcceptQuestUsingDB(353); Log("Accepting: [14]In Defense of the King's Lands");
        TurnInQuestUsingDB(224); Log("Turn-in: [12]The Trogg Threat");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Thelsamar Introduction
        Log("Step 1-3: Thelsamar Introduction");
        if HasPlayerFinishedQuest(414) then
            TurnInQuestUsingDB(414); Log("Turn-in: [9]Stout to Kadrell");
        end
        AcceptQuestUsingDB(416); Log("Accepting: [10]Rat Catching");
        AcceptQuestUsingDB(1338); Log("Accepting: [10]Stormpike's Order");
        AcceptQuestUsingDB(418); Log("Accepting: [10]Thelsamar Blood Sausages");
        GoToNPC(1464,"Innkeeper Hearthstove"); --Set hearthstone
        UseMacro("Gossip01");
        GoToNPC(1572,"Thorgrum Borrelson"); --Get flight path
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Ironforge Trip
        Log("Step 1-4: Ironforge Trip");
        AcceptQuestUsingDB(6388); Log("Accepting: [10]Gryth Thurden");
        -- Fly to Ironforge for training and quest turn-ins
        FlyTo("IRONFORGE");
        TurnInQuestUsingDB(6388); Log("Turn-in: [10]Gryth Thurden");
        AcceptQuestUsingDB(6391); Log("Accepting: [10]Return to Brock");
        Training(); Log("Training at Ironforge");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Return to Loch Modan
        Log("Step 1-5: Return to Loch Modan");
        FlyTo("THELSAMAR");
        TurnInQuestUsingDB(6391); Log("Turn-in: [10]Return to Brock");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Level 11 Check
        Log("Step 1-6: Level 11 Check");
        if(Player.Level < 11) then
            LevelTarget = 11
            Log("Grinding to Level "..LevelTarget.." for better quest access.");
            --[1161]Stonesplinter Trogg,[1162]Stonesplinter Scout,[1205]Loch Frenzy
            GrindAndGather(TableToList({1161,1162,1205}),150,TableToFloatArray({-5234.15,-2890.47,325.83}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 11");
end --End Valley of Kings

--Phase 2: Thelsamar Hub Operations (Levels 11-13)
if not HasPlayerFinishedQuest(416) then
    --Step 2-1: Tunnel Rat Operations
        Log("Phase 2: Thelsamar Hub Operations");
        Log("Collecting Tunnel Rat Ears from Silver Stream Mine");
        --[1270]Tunnel Rat Kobold,[1271]Tunnel Rat Geomancer,[1272]Tunnel Rat Surveyor
        GrindAndGather(TableToList({1270,1271,1272}),150,TableToFloatArray({-5388.85,-2887.15,386.26}),false,"TunnelRatEars",true);
        TurnInQuestUsingDB(416); Log("Turn-in: [10]Rat Catching");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Thelsamar Blood Sausages Collection
        Log("Step 2-2: Thelsamar Blood Sausages Collection");
        Log("Collecting ingredients for Blood Sausages");
        --[1186]Elder Black Bear,[1126]Crag Boar,[1110]Forest Spider
        GrindAndGather(TableToList({1186,1126,1110}),150,TableToFloatArray({-5600.25,-3100.75,355.47}),false,"ThelsamarBloodSausage",true);
        TurnInQuestUsingDB(418); Log("Turn-in: [10]Thelsamar Blood Sausages");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Wetlands Preparation
        Log("Step 2-3: Wetlands Preparation");
        TurnInQuestUsingDB(1338); Log("Turn-in: [10]Stormpike's Order");
        AcceptQuestUsingDB(1339); Log("Accepting: [15]Stormpike's Order");
        AcceptQuestUsingDB(464); Log("Accepting: [17]Plea To The Alliance");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Level 12 Check
        Log("Step 2-4: Level 12 Check");
        if(Player.Level < 12) then
            LevelTarget = 12
            Log("Grinding to Level "..LevelTarget.." for upcoming content.");
            --[1161]Stonesplinter Trogg,[1110]Forest Spider,[1186]Elder Black Bear
            GrindAndGather(TableToList({1161,1110,1186}),200,TableToFloatArray({-5600.25,-3100.75,355.47}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 12");
end --End Thelsamar Hub

--Phase 3: Ironband's Excavation (Levels 12-14)
if not HasPlayerFinishedQuest(436) then
    --Step 3-1: Ironband's Excavation Introduction
        Log("Phase 3: Ironband's Excavation");
        AcceptQuestUsingDB(436); Log("Accepting: [13]Ironband's Excavation");
        TurnInQuestUsingDB(436); Log("Turn-in: [13]Ironband's Excavation");
        AcceptQuestUsingDB(297); Log("Accepting: [15]Excavation Progress Report");
        AcceptQuestUsingDB(298); Log("Accepting: [15]Ironband Wants You!");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: Find Bingles Quest Chain
        Log("Step 3-2: Find Bingles Quest Chain");
        AcceptQuestUsingDB(2038); Log("Accepting: [13]Find Bingles");
        CompleteObjectiveOfQuest(2038,1); Log("Completing Objective: [13]Find Bingles - Locate Bingles");
        TurnInQuestUsingDB(2038); Log("Turn-in: [13]Find Bingles");
        AcceptQuestUsingDB(2039); Log("Accepting: [13]A Pilot's Revenge");
        AcceptQuestUsingDB(2040); Log("Accepting: [13]Bingles' Missing Supplies");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Missing Supplies Collection
        Log("Step 3-3: Missing Supplies Collection");
        CompleteObjectiveOfQuest(2040,1); Log("Completing Objective: [13]Bingles' Missing Supplies - Bingles' Wrench");
        CompleteObjectiveOfQuest(2040,2); Log("Completing Objective: [13]Bingles' Missing Supplies - Bingles' Hammer");
        CompleteObjectiveOfQuest(2040,3); Log("Completing Objective: [13]Bingles' Missing Supplies - Bingles' Screwdriver");
        TurnInQuestUsingDB(2040); Log("Turn-in: [13]Bingles' Missing Supplies");
        AcceptQuestUsingDB(2041); Log("Accepting: [13]Bingles' Blastpowder");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Power Crystal Collection
        Log("Step 3-4: Power Crystal Collection");
        Log("Collecting Intact Power Crystals from excavation site");
        --[1398]Magma Elemental,[1399]Lava Elemental,[1225]Dark Iron Ambusher
        GrindAndGather(TableToList({1398,1399,1225}),200,TableToFloatArray({-5065.85,-3327.45,301.22}),false,"PowerCrystals",true);
        TurnInQuestUsingDB(298); Log("Turn-in: [15]Ironband Wants You!");
        AcceptQuestUsingDB(301); Log("Accepting: [15]Gathering Idols");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Level 13 Check
        Log("Step 3-5: Level 13 Check");
        if(Player.Level < 13) then
            LevelTarget = 13
            Log("Grinding to Level "..LevelTarget.." for better survivability.");
            --[1398]Magma Elemental,[1225]Dark Iron Ambusher,[1226]Dark Iron Saboteur
            GrindAndGather(TableToList({1398,1225,1226}),250,TableToFloatArray({-5065.85,-3327.45,301.22}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 13");
end --End Ironband's Excavation

--Phase 4: Stonewrought Dam and Dark Iron Threat (Levels 13-15)
if not HasPlayerFinishedQuest(257) then
    --Step 4-1: Stonewrought Dam Introduction
        Log("Phase 4: Stonewrought Dam and Dark Iron Threat");
        AcceptQuestUsingDB(257); Log("Accepting: [14]A Dark Threat Looms");
        AcceptQuestUsingDB(258); Log("Accepting: [14]A Dark Threat Looms");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Dark Iron Operations
        Log("Step 4-2: Dark Iron Operations");
        CompleteObjectiveOfQuest(257,1); Log("Completing Objective: [14]A Dark Threat Looms - Kill 8 Dark Iron Dwarves");
        CompleteObjectiveOfQuest(258,1); Log("Completing Objective: [14]A Dark Threat Looms - Kill Foreman Stoneclaw");
        TurnInQuestUsingDB(257); Log("Turn-in: [14]A Dark Threat Looms");
        TurnInQuestUsingDB(258); Log("Turn-in: [14]A Dark Threat Looms");
        AcceptQuestUsingDB(302); Log("Accepting: [16]A Dark Threat Looms");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: Blastpowder Collection
        Log("Step 4-3: Blastpowder Collection");
        CompleteObjectiveOfQuest(2041,1); Log("Completing Objective: [13]Bingles' Blastpowder - Collect Cats Eye Emerald");
        CompleteObjectiveOfQuest(2041,2); Log("Completing Objective: [13]Bingles' Blastpowder - Collect Shadowgem");
        TurnInQuestUsingDB(2041); Log("Turn-in: [13]Bingles' Blastpowder");
        AcceptQuestUsingDB(2042); Log("Accepting: [15]Axes for Krean");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Ironforge Delivery
        Log("Step 4-4: Ironforge Delivery");
        TurnInQuestUsingDB(297); Log("Turn-in: [15]Excavation Progress Report");
        AcceptQuestUsingDB(433); Log("Accepting: [15]Resupplying the Excavation");
        FlyTo("IRONFORGE");
        TurnInQuestUsingDB(433); Log("Turn-in: [15]Resupplying the Excavation");
        AcceptQuestUsingDB(438); Log("Accepting: [15]Resupplying the Excavation");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-5: Level 14 Preparation
        Log("Step 4-5: Level 14 Preparation");
        if(Player.Level < 14) then
            LevelTarget = 14
            Log("Grinding to Level "..LevelTarget.." for upcoming challenges.");
            FlyTo("THELSAMAR");
            --[1225]Dark Iron Ambusher,[1226]Dark Iron Saboteur,[1398]Magma Elemental
            GrindAndGather(TableToList({1225,1226,1398}),250,TableToFloatArray({-5065.85,-3327.45,301.22}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 14");
end --End Stonewrought Dam

--Phase 5: Farstrider Lodge and Advanced Content (Levels 14-16)
if not HasPlayerFinishedQuest(263) then
    --Step 5-1: Farstrider Lodge Setup
        Log("Phase 5: Farstrider Lodge and Advanced Content");
        AcceptQuestUsingDB(263); Log("Accepting: [15]The Loch Modan Challenge: Crocolisk Hunting");
        AcceptQuestUsingDB(1452); Log("Accepting: [17]Rhapsody's Kalimdor Kocktail");
        AcceptQuestUsingDB(1453); Log("Accepting: [17]Rhapsody's Tale");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: Crocolisk Hunting
        Log("Step 5-2: Crocolisk Hunting");
        CompleteObjectiveOfQuest(263,1); Log("Completing Objective: [15]The Loch Modan Challenge: Crocolisk Hunting - Kill 5 Loch Crocolisks");
        TurnInQuestUsingDB(263); Log("Turn-in: [15]The Loch Modan Challenge: Crocolisk Hunting");
        AcceptQuestUsingDB(264); Log("Accepting: [15]The Loch Modan Challenge: Boar Hunting");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: Boar Hunting Challenge
        Log("Step 5-3: Boar Hunting Challenge");
        if IsHardCore == "true" then
            PopMessage("Boar hunting challenge has a time limit - be prepared!");
        end
        CompleteObjectiveOfQuest(264,1); Log("Completing Objective: [15]The Loch Modan Challenge: Boar Hunting - Kill 5 Mountain Boars");
        TurnInQuestUsingDB(264); Log("Turn-in: [15]The Loch Modan Challenge: Boar Hunting");
        AcceptQuestUsingDB(265); Log("Accepting: [15]The Loch Modan Challenge: Buzzard Hunting");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Buzzard Hunting Challenge  
        Log("Step 5-4: Buzzard Hunting Challenge");
        if IsHardCore == "true" then
            PopMessage("Buzzard hunting challenge also has a time limit!");
        end
        CompleteObjectiveOfQuest(265,1); Log("Completing Objective: [15]The Loch Modan Challenge: Buzzard Hunting - Kill 5 Loch Buzzards");
        TurnInQuestUsingDB(265); Log("Turn-in: [15]The Loch Modan Challenge: Buzzard Hunting");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-5: Level 15 Check
        Log("Step 5-5: Level 15 Check");
        if(Player.Level < 15) then
            LevelTarget = 15
            Log("Grinding to Level "..LevelTarget.." for elite content preparation.");
            --[1197]Loch Crocolisk,[1196]Mountain Boar,[1110]Forest Spider
            GrindAndGather(TableToList({1197,1196,1110}),250,TableToFloatArray({-4815.25,-3440.75,305.22}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 15");
end --End Farstrider Lodge

--Phase 6: Mo'grosh Stronghold and Elite Content (Levels 15-17)
if not HasPlayerFinishedQuest(302) then
    --Step 6-1: Mo'grosh Stronghold Preparation
        Log("Phase 6: Mo'grosh Stronghold and Elite Content");
        CompleteObjectiveOfQuest(302,1); Log("Completing Objective: [16]A Dark Threat Looms - Collect Mo'grosh Crystal");
        TurnInQuestUsingDB(302); Log("Turn-in: [16]A Dark Threat Looms");
        AcceptQuestUsingDB(420); Log("Accepting: [18]Sully Balloo's Letter");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Elite Ogre Content
        Log("Step 6-2: Elite Ogre Content");
        if EliteQuests == "true" then
            AcceptQuestUsingDB(268); Log("Accepting: [17]Mercenaries");
            if IsHardCore == "true" then
                PopMessage("Mo'grosh Stronghold has level 17-20 elite ogres! Very dangerous - consider getting help!");
            end
            CompleteObjectiveOfQuest(268,1); Log("Completing Objective: [17]Mercenaries - Kill 10 Mo'grosh Ogres");
            CompleteObjectiveOfQuest(268,2); Log("Completing Objective: [17]Mercenaries - Kill 10 Mo'grosh Enforcers");
            CompleteObjectiveOfQuest(268,3); Log("Completing Objective: [17]Mercenaries - Kill 1 Mo'grosh Shaman");
            TurnInQuestUsingDB(268); Log("Turn-in: [17]Mercenaries");
        else
            Log("Elite Quests disabled - skipping Mo'grosh Stronghold elite content");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Gathering Idols Completion
        Log("Step 6-3: Gathering Idols Completion");
        CompleteObjectiveOfQuest(301,1); Log("Completing Objective: [15]Gathering Idols - Collect 8 Carved Stone Idols");
        TurnInQuestUsingDB(301); Log("Turn-in: [15]Gathering Idols");
        AcceptQuestUsingDB(341); Log("Accepting: [15]Dwarven Justice");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Level 16 Check
        Log("Step 6-4: Level 16 Check");
        if(Player.Level < 16) then
            LevelTarget = 16
            Log("Grinding to Level "..LevelTarget.." for better elite combat capability.");
            --[1225]Dark Iron Ambusher,[1226]Dark Iron Saboteur,[1163]Stonesplinter Skullthumper
            GrindAndGather(TableToList({1225,1226,1163}),300,TableToFloatArray({-5065.85,-3327.45,301.22}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 16");
end --End Mo'grosh Stronghold

--Phase 7: Advanced Quest Chains (Levels 16-18)
if not HasPlayerFinishedQuest(353) then
    --Step 7-1: In Defense of the King's Lands Finale
        Log("Phase 7: Advanced Quest Chains");
        CompleteObjectiveOfQuest(353,1); Log("Completing Objective: [14]In Defense of the King's Lands - Kill 15 Stonesplinter Seers");
        CompleteObjectiveOfQuest(353,2); Log("Completing Objective: [14]In Defense of the King's Lands - Kill 15 Stonesplinter Skullthumpers");
        TurnInQuestUsingDB(353); Log("Turn-in: [14]In Defense of the King's Lands");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Dwarven Justice Chain
        Log("Step 7-2: Dwarven Justice Chain");
        CompleteObjectiveOfQuest(341,1); Log("Completing Objective: [15]Dwarven Justice - Kill Grawmug");
        TurnInQuestUsingDB(341); Log("Turn-in: [15]Dwarven Justice");
        AcceptQuestUsingDB(342); Log("Accepting: [17]Dwarven Justice");
        CompleteObjectiveOfQuest(342,1); Log("Completing Objective: [17]Dwarven Justice - Kill Grawmug's Jaw");
        TurnInQuestUsingDB(342); Log("Turn-in: [17]Dwarven Justice");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Wetlands Preparation
        Log("Step 7-3: Wetlands Preparation");
        TurnInQuestUsingDB(1339); Log("Turn-in: [15]Stormpike's Order");
        AcceptQuestUsingDB(1338); Log("Accepting: [18]Filthy Paws");
        TurnInQuestUsingDB(464); Log("Turn-in: [17]Plea To The Alliance");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Ironforge Final Reporting
        Log("Step 7-4: Ironforge Final Reporting");
        FlyTo("IRONFORGE");
        TurnInQuestUsingDB(438); Log("Turn-in: [15]Resupplying the Excavation");
        AcceptQuestUsingDB(307); Log("Accepting: [15]Protecting the Shipment");
        TurnInQuestUsingDB(420); Log("Turn-in: [18]Sully Balloo's Letter");
        AcceptQuestUsingDB(421); Log("Accepting: [18]Letter to Stormpike");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-5: Level 17 Check
        Log("Step 7-5: Level 17 Check");
        if(Player.Level < 17) then
            LevelTarget = 17
            Log("Grinding to Level "..LevelTarget.." for final zone content.");
            FlyTo("THELSAMAR");
            --[1225]Dark Iron Ambusher,[1163]Stonesplinter Skullthumper,[1164]Stonesplinter Seer
            GrindAndGather(TableToList({1225,1163,1164}),350,TableToFloatArray({-5065.85,-3327.45,301.22}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 17");
end --End Advanced Quest Chains

--Phase 8: Zone Completion and Transition (Levels 17-20)
if not HasPlayerFinishedQuest(307) then
    --Step 8-1: Protecting the Shipment Escort
        Log("Phase 8: Zone Completion and Transition");
        if IsHardCore == "true" then
            PopMessage("Escort quest ahead - protect the NPC carefully from Dark Iron attackers!");
        end
        FlyTo("THELSAMAR");
        CompleteObjectiveOfQuest(307,1); Log("Completing Objective: [15]Protecting the Shipment - Escort Miran");
        TurnInQuestUsingDB(307); Log("Turn-in: [15]Protecting the Shipment");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-2: Final Collection Quests
        Log("Step 8-2: Final Collection Quests");
        if EliteQuests == "true" then
            CompleteObjectiveOfQuest(2039,1); Log("Completing Objective: [13]A Pilot's Revenge - Kill Pilot Longbeard");
            TurnInQuestUsingDB(2039); Log("Turn-in: [13]A Pilot's Revenge");
        end
        TurnInQuestUsingDB(2042); Log("Turn-in: [15]Axes for Krean");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-3: Wetlands and Badlands Preparation
        Log("Step 8-3: Wetlands and Badlands Preparation");
        AcceptQuestUsingDB(1338); Log("Accepting: [18]Filthy Paws - leads to Wetlands");
        AcceptQuestUsingDB(720); Log("Accepting: [30]A King's Tribute - leads to Badlands/Uldaman");
        PopMessage("Loch Modan questing complete! Ready for:");
        PopMessage("- Wetlands (20-30) via Algaz Station");
        PopMessage("- Redridge Mountains (15-25) for variety");
        PopMessage("- Badlands (35-45) much later for Uldaman");
        PopMessage("- Arathi Highlands (30-40) eventually");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-4: Final Level Check
        Log("Step 8-4: Final Level Check");
        if(Player.Level < 18) then
            LevelTarget = 18
            Log("Final grind to Level "..LevelTarget.." for optimal zone completion.");
            --[1225]Dark Iron Ambusher,[1163]Stonesplinter Skullthumper,[1164]Stonesplinter Seer,[1226]Dark Iron Saboteur
            GrindAndGather(TableToList({1225,1163,1164,1226}),400,TableToFloatArray({-5065.85,-3327.45,301.22}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-5: Zone Completion Message
        Log("Step 8-5: Zone Completion Message");
        if IsHardCore == "true" then
            PopMessage("Loch Modan complete! Thelsamar is a key hub for accessing Badlands and Uldaman later");
        end
        if SafetyGrind == "true" then
            LevelTarget = 20
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Loch Modan");
            --[1225]Dark Iron Ambusher,[1163]Stonesplinter Skullthumper,[1164]Stonesplinter Seer,[1226]Dark Iron Saboteur,[1398]Magma Elemental
            GrindAndGather(TableToList({1225,1163,1164,1226,1398}),500,TableToFloatArray({-5065.85,-3327.45,301.22}),false,"LevelCheck",true);
        end
        PopMessage("Loch Modan questing complete at level " .. Player.Level .. "! The Trogg threat has been contained!");
end --End Loch Modan

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();