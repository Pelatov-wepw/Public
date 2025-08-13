-- Darkshore Questing Profile (13-17)
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
LevelTarget = 13
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end
function CrawlerLegs()
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
    elseif HasPlayerFinishedQuest(1002) then
        return false
    else
        return true
    end
end
function FineCrabChunks()
    if ItemCount("Fine Crab Chunks") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(1138) then
        return false
    else
        return true
    end
end
function GrellEarrings()
    if ItemCount("Grell Earring") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(955) then
        return false
    else
        return true
    end
end
function HighborneRelics()
    if ItemCount("Highborne Relic") >= 7 then
        return false
    elseif HasPlayerFinishedQuest(958) then
        return false
    else
        return true
    end
end
--Step 1: Auberdine Setup
if not HasPlayerFinishedQuest(4762) then
    --Step 1-1: Initial Auberdine Quests
        Log("Step 1: Auberdine Setup - Initial Quests");
        AcceptQuestUsingDB(963); Log("Accepting: [13]For Love Eternal");
        AcceptQuestUsingDB(983); Log("Accepting: [13]Buzzbox 827");
        AcceptQuestUsingDB(3524); Log("Accepting: [13]Washed Ashore");
        GoToNPC(3841,"Caylais Moonfeather"); --Get flight path
        if IsHardCore == "true" then
            PopMessage("Cave Mushrooms quest is optional but worth 6,660 XP - you may skip if uncomfortable with cave");
        end
        AcceptQuestUsingDB(947); Log("Accepting: [13]Cave Mushrooms");
        AcceptQuestUsingDB(4811); Log("Accepting: [13]The Red Crystal");
        GoToNPC(4182,"Dalmond"); --Buy bags
        AcceptQuestUsingDB(954); Log("Accepting: [13]Bashal'Aran");
        AcceptQuestUsingDB(958); Log("Accepting: [13]Tools of the Highborne");
        AcceptQuestUsingDB(2118); Log("Accepting: [13]Plagued Lands");
        AcceptQuestUsingDB(984); Log("Accepting: [13]How Big a Threat?");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Initial Collection Phase
        Log("Step 1-2: Initial Collection Phase");
        CompleteObjectiveOfQuest(3524,1); Log("Completing Objective: [13]Washed Ashore - Sea Creature Bones");
        CompleteObjectiveOfQuest(983,1); Log("Completing Objective: [13]Buzzbox 827 - 6 Crawler Legs");
        CompleteObjectiveOfQuest(984,1); Log("Completing Objective: [13]How Big a Threat? - Find Corrupt Furbolg Camp");
        CompleteObjectiveOfQuest(2118,1); Log("Completing Objective: [13]Plagued Lands - Capture Rabid Thistle Bear");
        TurnInQuestUsingDB(983); Log("Turn-in: [13]Buzzbox 827");
        AcceptQuestUsingDB(1001); Log("Accepting: [13]Buzzbox 411");
        TurnInQuestUsingDB(3524); Log("Turn-in: [13]Washed Ashore");
        AcceptQuestUsingDB(4681); Log("Accepting: [13]Washed Ashore");
        CompleteObjectiveOfQuest(4681,1); Log("Completing Objective: [13]Washed Ashore - Sea Turtle Remains");
        TurnInQuestUsingDB(4681); Log("Turn-in: [13]Washed Ashore");
        GoToNPC(6737,"Innkeeper Shaussiy"); --Set hearthstone
        UseMacro("Gossip01");
        TurnInQuestUsingDB(2118); Log("Turn-in: [13]Plagued Lands");
        AcceptQuestUsingDB(2138); Log("Accepting: [13]Cleansing of the Infected");
        TurnInQuestUsingDB(984); Log("Turn-in: [13]How Big a Threat?");
        AcceptQuestUsingDB(985); Log("Accepting: [13]How Big a Threat?");
        AcceptQuestUsingDB(4761); Log("Accepting: [13]Thundris Windweaver");
        AcceptQuestUsingDB(982); Log("Accepting: [13]Deep Ocean, Vast Sea");
        GoToNPC(4182,"Dalmond"); --Buy bags
        TurnInQuestUsingDB(4761); Log("Turn-in: [13]Thundris Windweaver");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Level 14 Preparation and Underwater Quests
        Log("Step 1-3: Level 14 Preparation and Underwater Quests");
        if(Player.Level < 14) then
            LevelTarget = 14
            Log("Grinding to Level "..LevelTarget..".");
            GrindAndGather(TableToList({2069,2070,2071}),200,TableToFloatArray({6840.01,384.18,7.93}),false,"LevelCheck",true);
        end
        if IsHardCore == "true" then
            PopMessage("Underwater quest ahead - consider Elixir of Water Breathing. Quest is optional.");
        end
        CompleteObjectiveOfQuest(982,1); Log("Completing Objective: [13]Deep Ocean, Vast Sea - Silver Dawning's Lockbox");
        CompleteObjectiveOfQuest(982,2); Log("Completing Objective: [13]Deep Ocean, Vast Sea - Mist Veil's Lockbox");
        CompleteObjectiveOfQuest(1001,1); Log("Completing Objective: [13]Buzzbox 411 - 3 Thresher Eyes");
        TurnInQuestUsingDB(1001); Log("Turn-in: [13]Buzzbox 411");
        AcceptQuestUsingDB(1002); Log("Accepting: [13]Buzzbox 323");
        AcceptQuestUsingDB(4723); Log("Accepting: [13]Beached Sea Creature");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Bashal'Aran Quest Chain
        Log("Step 1-4: Bashal'Aran Quest Chain");
        TurnInQuestUsingDB(954); Log("Turn-in: [13]Bashal'Aran");
        AcceptQuestUsingDB(955); Log("Accepting: [13]Bashal'Aran");
        CompleteObjectiveOfQuest(955,1); Log("Completing Objective: [13]Bashal'Aran - 8 Grell Earrings");
        TurnInQuestUsingDB(955); Log("Turn-in: [13]Bashal'Aran");
        AcceptQuestUsingDB(956); Log("Accepting: [13]Bashal'Aran");
        CompleteObjectiveOfQuest(956,1); Log("Completing Objective: [13]Bashal'Aran - Ancient Moonstone Seal");
        TurnInQuestUsingDB(956); Log("Turn-in: [13]Bashal'Aran");
        AcceptQuestUsingDB(957); Log("Accepting: [13]Bashal'Aran");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Red Crystal Chain
        Log("Step 1-5: Red Crystal Chain");
        CompleteObjectiveOfQuest(4811,1); Log("Completing Objective: [13]The Red Crystal - Locate Large Red Crystal");
        TurnInQuestUsingDB(4723); Log("Turn-in: [13]Beached Sea Creature");
        TurnInQuestUsingDB(4811); Log("Turn-in: [13]The Red Crystal");
        AcceptQuestUsingDB(4812); Log("Accepting: [13]As Water Cascades");
        CompleteObjectiveOfQuest(4812,1); Log("Completing Objective: [13]As Water Cascades - Moonwell Water Tube");
        GoToNPC(4182,"Dalmond"); --Buy bags
        TurnInQuestUsingDB(982); Log("Turn-in: [13]Deep Ocean, Vast Sea");
        if GetPlayer().RaceName == "Night Elf" and GetPlayerClass() == "Druid" then
            CompleteObjectiveOfQuest(6001,1); Log("Completing Objective: [1]Body and Heart - Face Lunaclaw");
        end
        TurnInQuestUsingDB(4812); Log("Turn-in: [13]As Water Cascades");
        AcceptQuestUsingDB(4813); Log("Accepting: [13]The Fragments Within");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Level 15 Grind and Fragment Quest
        Log("Step 1-6: Level 15 Grind and Fragment Quest");
        if(Player.Level < 15) then
            LevelTarget = 15
            Log("Grinding to Level "..LevelTarget..".");
            GrindAndGather(TableToList({2069,2070,2071,2237}),200,TableToFloatArray({7840.53,1746.29,42.93}),false,"LevelCheck",true);
        end
        TurnInQuestUsingDB(4813); Log("Turn-in: [13]The Fragments Within");
        AcceptQuestUsingDB(953); Log("Accepting: [13]The Fall of Ameth'Aran");
        CompleteObjectiveOfQuest(953,1); Log("Completing Objective: [13]The Fall of Ameth'Aran - Read Lay of Ameth'Aran");
        CompleteObjectiveOfQuest(957,1); Log("Completing Objective: [13]Bashal'Aran - Destroy Seal at Ancient Flame");
        CompleteObjectiveOfQuest(953,2); Log("Completing Objective: [13]The Fall of Ameth'Aran - Read Fall of Ameth'Aran");
        CompleteObjectiveOfQuest(958,1); Log("Completing Objective: [13]Tools of the Highborne - 7 Highborne Relics");
        CompleteObjectiveOfQuest(963,1); Log("Completing Objective: [13]For Love Eternal - Anaya's Pendant");
        TurnInQuestUsingDB(953); Log("Turn-in: [13]The Fall of Ameth'Aran");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-7: Moonstalker and Bear Hunting
        Log("Step 1-7: Moonstalker and Bear Hunting");
        if GetPlayerClass() == "Hunter" then
            PopMessage("Tame a Moonstalker (blue/black striped tiger) as your permanent pet - try for level 15");
        end
        AcceptQuestUsingDB(4728); Log("Accepting: [13]Beached Sea Creature");
        CompleteObjectiveOfQuest(1002,1); Log("Completing Objective: [13]Buzzbox 323 - 6 Moonstalker Fangs");
        CompleteObjectiveOfQuest(2138,1); Log("Completing Objective: [13]Cleansing of the Infected - 20 Rabid Thistle Bears");
        if GetPlayer().RaceName == "Night Elf" then
            TurnInQuestUsingDB(952); Log("Turn-in: [1]Grove of the Ancients");
        end
        AcceptQuestUsingDB(4722); Log("Accepting: [13]Beached Sea Turtle");
        CompleteObjectiveOfQuest(985,1); Log("Completing Objective: [13]How Big a Threat? - 8 Blackwood Pathfinders");
        CompleteObjectiveOfQuest(985,2); Log("Completing Objective: [13]How Big a Threat? - 5 Blackwood Windtalkers");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-8: Level 16 Preparation
        Log("Step 1-8: Level 16 Preparation");
        if(Player.Level < 16) then
            LevelTarget = 16
            Log("Grinding to Level "..LevelTarget..".");
            GrindAndGather(TableToList({2167,2324}),200,TableToFloatArray({6992.93,1256.19,42.87}),false,"LevelCheck",true);
        end
        if GetPlayerClass() == "Warlock" then
            PopMessage("Teach your Voidwalker Sacrifice ability if available");
        end
        TurnInQuestUsingDB(963); Log("Turn-in: [13]For Love Eternal");
        AcceptQuestUsingDB(1138); Log("Accepting: [13]Fruit of the Sea");
        TurnInQuestUsingDB(4722); Log("Turn-in: [13]Beached Sea Turtle");
        TurnInQuestUsingDB(4728); Log("Turn-in: [13]Beached Sea Creature");
        TurnInQuestUsingDB(2138); Log("Turn-in: [13]Cleansing of the Infected");
        TurnInQuestUsingDB(985); Log("Turn-in: [13]How Big a Threat?");
        GoToNPC(4182,"Dalmond"); --Buy bags
        TurnInQuestUsingDB(958); Log("Turn-in: [13]Tools of the Highborne");
        AcceptQuestUsingDB(4762); Log("Accepting: [13]The Cliffspring River");
        TurnInQuestUsingDB(957); Log("Turn-in: [13]Bashal'Aran");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-9: Druid Class Chain (if applicable)
        Log("Step 1-9: Druid Class Chain (if applicable)");
        if GetPlayer().RaceName == "Night Elf" and GetPlayerClass() == "Druid" then
            AcceptQuestUsingDB(26); Log("Accepting: [10]A Lesson to Learn");
            AcceptQuestUsingDB(6121); Log("Accepting: [10]Lessons Anew");
            TurnInQuestUsingDB(26); Log("Turn-in: [10]A Lesson to Learn");
            AcceptQuestUsingDB(29); Log("Accepting: [10]Trial of the Lake");
            TurnInQuestUsingDB(6121); Log("Turn-in: [10]Lessons Anew");
            AcceptQuestUsingDB(6122); Log("Accepting: [10]The Principal Source");
            CompleteObjectiveOfQuest(29,1); Log("Completing Objective: [10]Trial of the Lake - Complete Trial");
            TurnInQuestUsingDB(29); Log("Turn-in: [10]Trial of the Lake");
            AcceptQuestUsingDB(272); Log("Accepting: [10]Trial of the Sea Lion");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-1: Cave Exploration (Optional)
        Log("Step 2-1: Cave Exploration (Optional)");
        if IsHardCore == "true" then
            PopMessage("Dangerous cave ahead - 6,660 XP quest chain but can be skipped");
        end
        CompleteObjectiveOfQuest(947,1); Log("Completing Objective: [13]Cave Mushrooms - 5 Scaber Stalks");
        CompleteObjectiveOfQuest(947,2); Log("Completing Objective: [13]Cave Mushrooms - Death Cap");
        if GetPlayer().RaceName == "Night Elf" and GetPlayerClass() == "Druid" then
            CompleteObjectiveOfQuest(6122,1); Log("Completing Objective: [10]The Principal Source - Filled Cliffspring Falls Sampler");
        end
        TurnInQuestUsingDB(1002); Log("Turn-in: [13]Buzzbox 323");
        AcceptQuestUsingDB(1003); Log("Accepting: [13]Buzzbox 525");
        CompleteObjectiveOfQuest(4762,1); Log("Completing Objective: [13]The Cliffspring River - Cliffspring River Sample");
        AcceptQuestUsingDB(4727); Log("Accepting: [13]Beached Sea Turtle");
        AcceptQuestUsingDB(4725); Log("Accepting: [13]Beached Sea Turtle");
        CompleteObjectiveOfQuest(1138,1); Log("Completing Objective: [13]Fruit of the Sea - 6 Fine Crab Chunks");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Final Collection and Level 17 Preparation
        Log("Step 2-2: Final Collection and Level 17 Preparation");
        if(Player.Level < 17) then
            LevelTarget = 17
            if Player.Level < 16 or Player.Level < LevelTarget then
                Log("Grinding for Level 17 preparation");
                GrindAndGather(TableToList({2235}),100,TableToFloatArray({8692.51,521.27,8.93}),false,"LevelCheck",true);
            end
        end
        if GetPlayer().RaceName == "Night Elf" and GetPlayerClass() == "Druid" then
            CompleteObjectiveOfQuest(272,1); Log("Completing Objective: [10]Trial of the Sea Lion - Half Pendant of Aquatic Agility");
        end
        TurnInQuestUsingDB(1138); Log("Turn-in: [13]Fruit of the Sea");
        TurnInQuestUsingDB(4727); Log("Turn-in: [13]Beached Sea Turtle");
        TurnInQuestUsingDB(4725); Log("Turn-in: [13]Beached Sea Turtle");
        TurnInQuestUsingDB(947); Log("Turn-in: [13]Cave Mushrooms");
        AcceptQuestUsingDB(948); Log("Accepting: [13]Onu");
        GoToNPC(4182,"Dalmond"); --Buy bags
        TurnInQuestUsingDB(4762); Log("Turn-in: [13]The Cliffspring River");
        PopMessage("Leaving Darkshore - keep hearthstone set to Auberdine for easy return");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Equipment Upgrades (if needed)
        Log("Step 2-3: Equipment Upgrades (if needed)");
        if GetPlayerClass() == "Hunter" then
            GoToNPC(1459,"Naela Trance"); --Buy bow upgrades in Menethil Harbor
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Druid Continuation (if applicable)
        Log("Step 2-4: Druid Continuation (if applicable)");
        if GetPlayer().RaceName == "Night Elf" and GetPlayerClass() == "Druid" then
            TurnInQuestUsingDB(6122); Log("Turn-in: [10]The Principal Source");
            AcceptQuestUsingDB(6123); Log("Accepting: [10]Gathering the Cure");
            CompleteObjectiveOfQuest(6123,2); Log("Completing Objective: [10]Gathering the Cure - 12 Lunar Fungus");
            TurnInQuestUsingDB(6123); Log("Turn-in: [10]Gathering the Cure");
            AcceptQuestUsingDB(6124); Log("Accepting: [10]Curing the Sick");
            CompleteObjectiveOfQuest(6124,1); Log("Completing Objective: [10]Curing the Sick - Cure 10 Sickly Deer");
            TurnInQuestUsingDB(6124); Log("Turn-in: [10]Curing the Sick");
            AcceptQuestUsingDB(6125); Log("Accepting: [10]Power over Poison");
            TurnInQuestUsingDB(6125); Log("Turn-in: [10]Power over Poison");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Final Training and Preparation
        Log("Step 2-5: Final Training and Preparation");
        if GetPlayerClass() == "Rogue" then
            GoToNPC(4163,"Syurna"); --Train Lockpicking
        end
        Training(); Log("Training Final Skills");
        if SafetyGrind == "true" then
            LevelTarget = 18
            Log("Safety Grind is True: Grinding to Level "..LevelTarget.." before leaving Darkshore");
            GrindAndGather(TableToList({2164,2069,2070,2071}),100,TableToFloatArray({6840.01,1584.18,42.93}),false,"LevelCheck",true);
        end
end --End Darkshore
------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();