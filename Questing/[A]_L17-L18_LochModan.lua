-- Loch Modan Questing Profile (17-18)
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
LevelTarget = 17
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end

function CrocoliskMeat()
    if ItemCount("Crocolisk Meat") >= 5 then
        return false
    elseif HasPlayerFinishedQuest(385) then
        return false
    else
        return true
    end
end

function CrocoliskSkin()
    if ItemCount("Crocolisk Skin") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(385) then
        return false
    else
        return true
    end
end

function CarvedStoneIdols()
    if ItemCount("Carved Stone Idol") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(297) then
        return false
    else
        return true
    end
end

function BinglesSupplies()
    if ItemCount("Bingles' Wrench") >= 1 and ItemCount("Bingles' Screwdriver") >= 1 and 
       ItemCount("Bingles' Hammer") >= 1 and ItemCount("Bingles' Blastencapper") >= 1 then
        return false
    elseif HasPlayerFinishedQuest(2038) then
        return false
    else
        return true
    end
end

--Step 1: Initial Setup and Class Training
if not HasPlayerFinishedQuest(298) then
    --Step 1-1: Class Specific Training
    Log("Step 1: Initial Setup and Class Training");
    if GetPlayerClass() == "Mage" then
        GoToNPC(7312,"Dink"); --Mage trainer in Ironforge
        Training();
    elseif GetPlayerClass() == "Warlock" then
        GoToNPC(5172,"Briarthorn"); --Warlock trainer in Ironforge
        Training();
    elseif GetPlayerClass() == "Paladin" then
        GoToNPC(5149,"Brandur Ironhammer"); --Paladin trainer in Ironforge
        Training();
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-2: Hunter Pet Management
    Log("Step 1-2: Hunter Pet Management");
    if GetPlayerClass() == "Hunter" then
        GoToNPC(9989,"Lina Hearthstove"); --Stable pet
        PopMessage("Stable your permanent pet - you will tame a temporary Wood Lurker for Bite 3");
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-3: Accept Initial Quests
    Log("Step 1-3: Accept Initial Quests");
    AcceptQuestUsingDB(436); Log("Accepting: [17]Ironband's Excavation");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-4: Hunter Wood Lurker Taming
    Log("Step 1-4: Hunter Wood Lurker Taming");
    if GetPlayerClass() == "Hunter" then
        PopMessage("Tame a Wood Lurker (brown spider) - try for level 17. This is temporary for learning Bite 3");
        -- Travel to Wood Lurker area
        QuestGoToPoint(6002.86, 2473.29, 0); -- Approximate Wood Lurker location
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-5: Ironband's Excavation Chain
    Log("Step 1-5: Ironband's Excavation Chain");
    TurnInQuestUsingDB(436); Log("Turn-in: [17]Ironband's Excavation");
    AcceptQuestUsingDB(297); Log("Accepting: [17]Gathering Idols");
    AcceptQuestUsingDB(298); Log("Accepting: [17]Excavation Progress Report");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-6: Trogg Area Collection
    Log("Step 1-6: Trogg Area Collection");
    if IsHardCore == "true" then
        PopMessage("Dangerous trogg area ahead - stick to outskirts, watch for patrols");
    end
    CompleteObjectiveOfQuest(297,1); Log("Completing Objective: [17]Gathering Idols - 8 Carved Stone Idols");
    TurnInQuestUsingDB(297); Log("Turn-in: [17]Gathering Idols");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-7: Thelsamar Quests
    Log("Step 1-7: Thelsamar Quests");
    AcceptQuestUsingDB(385); Log("Accepting: [17]Crocolisk Hunting");
    AcceptQuestUsingDB(257); Log("Accepting: [17]A Hunter's Boast");
    AcceptQuestUsingDB(2038); Log("Accepting: [17]Bingles' Missing Supplies");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-8: Equipment Upgrades
    Log("Step 1-8: Equipment Upgrades");
    if GetPlayerClass() == "Hunter" then
        GoToNPC(1687,"Cliff Hadin"); --Buy bow if affordable
        PopMessage("Buy Fine Longbow if available and affordable, otherwise Reinforced Bow");
    elseif GetPlayerClass() == "Warrior" then
        GoToNPC(222,"Nillen Andemar"); --Buy Heavy Spiked Mace if affordable
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-9: Timed Hunter Quests
    Log("Step 1-9: Timed Hunter Quests");
    CompleteObjectiveOfQuest(257,1); Log("Completing Objective: [17]A Hunter's Boast - 6 Mountain Buzzards");
    TurnInQuestUsingDB(257); Log("Turn-in: [17]A Hunter's Boast");
    AcceptQuestUsingDB(258); Log("Accepting: [17]A Hunter's Challenge");
    CompleteObjectiveOfQuest(258,1); Log("Completing Objective: [17]A Hunter's Challenge - 5 Elder Mountain Boars");
    TurnInQuestUsingDB(258); Log("Turn-in: [17]A Hunter's Challenge");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-1: Crocolisk Hunting
    Log("Step 2-1: Crocolisk Hunting");
    CompleteObjectiveOfQuest(385,1); Log("Completing Objective: [17]Crocolisk Hunting - 5 Crocolisk Meat");
    CompleteObjectiveOfQuest(385,2); Log("Completing Objective: [17]Crocolisk Hunting - 6 Crocolisk Skin");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-2: Bingles' Supplies (Optional)
    Log("Step 2-2: Bingles' Supplies (Optional)");
    if IsHardCore == "true" then
        PopMessage("Bingles' supplies quest is optional but dangerous - may fight 3 enemies at once");
    end
    CompleteObjectiveOfQuest(2038,1); Log("Completing Objective: [17]Bingles' Missing Supplies - Bingles' Wrench");
    CompleteObjectiveOfQuest(2038,2); Log("Completing Objective: [17]Bingles' Missing Supplies - Bingles' Screwdriver");
    CompleteObjectiveOfQuest(2038,3); Log("Completing Objective: [17]Bingles' Missing Supplies - Bingles' Hammer");
    CompleteObjectiveOfQuest(2038,4); Log("Completing Objective: [17]Bingles' Missing Supplies - Bingles' Blastencapper");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-3: Dark Iron Investigation
    Log("Step 2-3: Dark Iron Investigation");
    AcceptQuestUsingDB(250); Log("Accepting: [17]A Dark Threat Looms");
    if IsHardCore == "true" then
        PopMessage("Dark Iron Sappers may self-destruct when low on health - watch for emote and move away");
    end
    CompleteObjectiveOfQuest(250,1); Log("Completing Objective: [17]A Dark Threat Looms - Investigate Suspicious Barrel");
    TurnInQuestUsingDB(250); Log("Turn-in: [17]A Dark Threat Looms");
    AcceptQuestUsingDB(199); Log("Accepting: [17]A Dark Threat Looms");
    TurnInQuestUsingDB(199); Log("Turn-in: [17]A Dark Threat Looms");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-4: Quest Turn-ins and Final Preparations
    Log("Step 2-4: Quest Turn-ins and Final Preparations");
    TurnInQuestUsingDB(2038); Log("Turn-in: [17]Bingles' Missing Supplies");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-5: Level 18 Preparation
    Log("Step 2-5: Level 18 Preparation");
    if(Player.Level < 18) then
        LevelTarget = 18
        Log("Grinding to Level "..LevelTarget..".");
        GrindAndGather(TableToList({1194,1192,1693}),100,TableToFloatArray({7406.51,5192.92,0}),false,"LevelCheck",true);
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-6: Warlock Pet Training
    Log("Step 2-6: Warlock Pet Training");
    if GetPlayerClass() == "Warlock" then
        PopMessage("Teach Voidwalker Consume Shadows (Rank 1) if you have the grimoire");
        -- Assume grimoire was purchased in previous guide
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-7: Final Quest Turn-ins
    Log("Step 2-7: Final Quest Turn-ins");
    TurnInQuestUsingDB(385); Log("Turn-in: [17]Crocolisk Hunting");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-8: Hunter Pet Management Final
    Log("Step 2-8: Hunter Pet Management Final");
    if GetPlayerClass() == "Hunter" then
        GoToNPC(9989,"Lina Hearthstove"); --Get permanent pet back
        PopMessage("Abandon temporary pet and retrieve permanent pet. Teach Bite 3 to permanent pet");
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-9: Complete Excavation Report
    Log("Step 2-9: Complete Excavation Report");
    TurnInQuestUsingDB(298); Log("Turn-in: [17]Excavation Progress Report");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-10: Equipment Upgrades in Ironforge
    Log("Step 2-10: Equipment Upgrades in Ironforge");
    if GetPlayerClass() == "Hunter" then
        GoToNPC(5122,"Skolmin Goldfury"); --Heavy Recurve Bow in Ironforge
    end
    GoToNPC(5175,"Gearcutter Cogspinner"); --Bronze Tube for future Duskwood quest
    GoToNPC(5519,"Billibub Cogspinner"); --Alternative Bronze Tube vendor in Stormwind
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-11: Class Specific Final Steps
    Log("Step 2-11: Class Specific Final Steps");
    if GetPlayerClass() == "Rogue" then
        AcceptQuestUsingDB(2281); Log("Accepting: [17]Redridge Rendezvous");
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-12: Druid Aquatic Form Chain (if applicable)
    Log("Step 2-12: Druid Aquatic Form Chain (if applicable)");
    if GetPlayer().RaceName == "Night Elf" and GetPlayerClass() == "Druid" then
        -- Underwater quest in Westfall for pendant
        CompleteObjectiveOfQuest(272,1); Log("Completing Objective: [10]Trial of the Sea Lion - Collect pendant pieces");
        TurnInQuestUsingDB(272); Log("Turn-in: [10]Trial of the Sea Lion");
        AcceptQuestUsingDB(5061); Log("Accepting: [10]Aquatic Form");
        TurnInQuestUsingDB(5061); Log("Turn-in: [10]Aquatic Form");
    end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-13: Final Training and Preparation
    Log("Step 2-13: Final Training and Preparation");
    Training(); Log("Training Final Skills");
    PopMessage("Loch Modan completed - next destination: Redridge Mountains (18-20)");
    
end --End Loch Modan

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();