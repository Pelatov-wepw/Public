    -- Ashenvale Questing Profile (18-30)
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
LevelTarget = 18
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end
function AncientStatuettes()
    if ItemCount("Ancient Statuette") >= 10 then
        return false
    elseif HasPlayerFinishedQuest(1007) then
        return false
    else
        return true
    end
end
function BathransHair()
    if ItemCount("Bathran's Hair") >= 5 then
        return false
    elseif HasPlayerFinishedQuest(1010) then
        return false
    else
        return true
    end
end
function NagaHeads()
    if ItemCount("Naga Claws") >= 20 then
        return false
    elseif HasPlayerFinishedQuest(1008) then
        return false
    else
        return true
    end
end
function FurBolgParts()
    if ItemCount("Thistlefur Feather") >= 6 and ItemCount("Thistlefur Dew Gland") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(216) then
        return false
    else
        return true
    end
end

--Phase 1: Astranaar Arrival and Setup (Levels 18-20)
if not HasPlayerFinishedQuest(1008) then
    --Step 1-1: Astranaar Arrival and Registration
        Log("Phase 1: Astranaar Arrival and Setup");
        if HasPlayerFinishedQuest(1134) then
            TurnInQuestUsingDB(1134); Log("Turn-in: [19]The Lost Chalice");
        end
        TurnInQuestUsingDB(1008); Log("Turn-in: [18]The Zoram Strand");
        GoToNPC(6736,"Innkeeper Kimlya"); --Set hearthstone
        UseMacro("Gossip01");
        SleepPlugin(2000);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Initial Quest Collection
        Log("Step 1-2: Initial Quest Collection");
        AcceptQuestUsingDB(216); Log("Accepting: [19]Culling the Threat");
        AcceptQuestUsingDB(991); Log("Accepting: [18]Raene's Cleansing");
        AcceptQuestUsingDB(1054); Log("Accepting: [19]Culling the Threat");
        AcceptQuestUsingDB(1033); Log("Accepting: [21]Elune's Tear");
        AcceptQuestUsingDB(1056); Log("Accepting: [23]Journey to Stonetalon Peak");
        AcceptQuestUsingDB(1016); Log("Accepting: [19]Elemental Bracers");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Thistlefur Village Operations
        Log("Step 1-3: Thistlefur Village Operations");
        CompleteObjectiveOfQuest(216,1); Log("Completing Objective: [19]Culling the Threat - Kill Dal Bloodclaw");
        Log("Collecting Thistlefur parts for Culling the Threat");
        --[3925]Thistlefur Avenger,[3926]Thistlefur Pathfinder,[3924]Thistlefur Shaman
        GrindAndGather(TableToList({3925,3926,3924}),100,TableToFloatArray({4588.2,478.4,58.8}),false,"FurBolgParts",true);
        TurnInQuestUsingDB(216); Log("Turn-in: [19]Culling the Threat");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Elune's Tear Collection
        Log("Step 1-4: Elune's Tear Collection");
        CompleteObjectiveOfQuest(1033,1); Log("Completing Objective: [21]Elune's Tear - Collect Elune's Tear from Iris Lake");
        TurnInQuestUsingDB(1033); Log("Turn-in: [21]Elune's Tear");
        AcceptQuestUsingDB(1034); Log("Accepting: [23]The Ruins of Stardust");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Raene's Cleansing Chain
        Log("Step 1-5: Raene's Cleansing Chain");
        TurnInQuestUsingDB(991); Log("Turn-in: [18]Raene's Cleansing");
        AcceptQuestUsingDB(1021); Log("Accepting: [21]Raene's Cleansing");
        CompleteObjectiveOfQuest(1021,1); Log("Completing Objective: [21]Raene's Cleansing - Find Teronis' Corpse");
        TurnInQuestUsingDB(1021); Log("Turn-in: [21]Raene's Cleansing");
        AcceptQuestUsingDB(1022); Log("Accepting: [25]Raene's Cleansing");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Level 20 Check and Training
        Log("Step 1-6: Level 20 Check and Training");
        if(Player.Level < 20) then
            LevelTarget = 20
            Log("Grinding to Level "..LevelTarget..".");
            --[3925]Thistlefur Avenger,[3926]Thistlefur Pathfinder,[3924]Thistlefur Shaman
            GrindAndGather(TableToList({3925,3926,3924}),150,TableToFloatArray({4588.2,478.4,58.8}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 20");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-7: Mount Acquisition
        Log("Step 1-7: Mount Acquisition");
        if Player.Level >= 20 then
            PopMessage("Level 20 reached! Consider getting your first mount for faster travel.");
            if IsHardCore == "false" then
                Log("Recommend traveling to get mount and riding skill");
            end
        end
end --End Initial Setup

--Phase 2: Maestra's Post and Bathran's Hair (Level 20-22)
if not HasPlayerFinishedQuest(1010) then
    --Step 2-1: Maestra's Post Operations
        Log("Phase 2: Maestra's Post and Bathran's Hair");
        AcceptQuestUsingDB(1010); Log("Accepting: [20]Bathran's Hair");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Bathran's Hair Collection
        Log("Step 2-2: Bathran's Hair Collection");
        Log("Collecting Bathran's Hair from Bathran's Haunt");
        CompleteObjectiveOfQuest(1010,1); Log("Completing Objective: [20]Bathran's Hair - Collect 5 Bathran's Hair");
        TurnInQuestUsingDB(1010); Log("Turn-in: [20]Bathran's Hair");
        AcceptQuestUsingDB(1020); Log("Accepting: [20]Orendil's Cure");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Orendil's Cure Delivery
        Log("Step 2-3: Orendil's Cure Delivery");
        TurnInQuestUsingDB(1020); Log("Turn-in: [20]Orendil's Cure");
        SleepPlugin(15000); -- Wait for cure animation
        AcceptQuestUsingDB(1055); Log("Accepting: [24]Culling the Threat");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Elemental Bracers Quest
        Log("Step 2-4: Elemental Bracers Quest");
        if Player.Level >= 20 and GetPlayerClass() == "Druid" then
            CompleteObjectiveOfQuest(1016,1); Log("Completing Objective: [19]Elemental Bracers - Collect 5 Intact Elemental Bracers");
            TurnInQuestUsingDB(1016); Log("Turn-in: [19]Elemental Bracers");
            AcceptQuestUsingDB(1017); Log("Accepting: [25]Mage Summoner");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Ruins of Stardust
        Log("Step 2-5: Ruins of Stardust");
        CompleteObjectiveOfQuest(1034,1); Log("Completing Objective: [23]The Ruins of Stardust - Collect 5 Handful of Stardust");
        TurnInQuestUsingDB(1034); Log("Turn-in: [23]The Ruins of Stardust");
        AcceptQuestUsingDB(1035); Log("Accepting: [26]Fallen Sky Lake");
end --End Maestra's Post

--Phase 3: Blackfathom Camp and Zoram Strand (Level 21-23)
if not HasPlayerFinishedQuest(1007) then
    --Step 3-1: Blackfathom Camp Setup
        Log("Phase 3: Blackfathom Camp and Zoram Strand");
        AcceptQuestUsingDB(1007); Log("Accepting: [21]The Ancient Statuettes");
        AcceptQuestUsingDB(1008); Log("Accepting: [19]Naga of the Strand");
        if EliteQuests == "true" then
            AcceptQuestUsingDB(1198); Log("Accepting: [22]Blackfathom Deeps");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: Zoram Strand Operations
        Log("Step 3-2: Zoram Strand Operations");
        Log("Starting Naga elimination and statuette collection");
        --[3711]Wrathtail Myrmidon,[3712]Wrathtail Razortail,[3713]Wrathtail Wave Rider
        GrindAndGather(TableToList({3711,3712,3713}),100,TableToFloatArray({1489.5,2678.8,8.5}),false,"NagaHeads",true);
        --Collect Ancient Statuettes while killing Naga
        GrindAndGather(TableToList({3711,3712,3713}),100,TableToFloatArray({1489.5,2678.8,8.5}),false,"AncientStatuettes",true);
        TurnInQuestUsingDB(1008); Log("Turn-in: [19]Naga of the Strand");
        TurnInQuestUsingDB(1007); Log("Turn-in: [21]The Ancient Statuettes");
        AcceptQuestUsingDB(1009); Log("Accepting: [21]Ruuzel");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Ruuzel Quest
        Log("Step 3-3: Ruuzel Quest");
        CompleteObjectiveOfQuest(1009,1); Log("Completing Objective: [21]Ruuzel - Kill Ruuzel");
        TurnInQuestUsingDB(1009); Log("Turn-in: [21]Ruuzel");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Blackfathom Deeps Preparation
        Log("Step 3-4: Blackfathom Deeps Preparation");
        if EliteQuests == "true" then
            if IsHardCore == "true" then
                PopMessage("Blackfathom Deeps dungeon quest available - find a group for safety!");
            else
                PopMessage("Blackfathom Deeps dungeon quest available - great XP and loot!");
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Level 22 Check
        Log("Step 3-5: Level 22 Check");
        if(Player.Level < 22) then
            LevelTarget = 22
            Log("Grinding to Level "..LevelTarget..".");
            --[3711]Wrathtail Myrmidon,[3712]Wrathtail Razortail,[3713]Wrathtail Wave Rider
            GrindAndGather(TableToList({3711,3712,3713}),200,TableToFloatArray({1489.5,2678.8,8.5}),false,"LevelCheck",true);
        end
end --End Zoram Strand

--Phase 4: Forest Song Outpost (Level 22-24)
if not HasPlayerFinishedQuest(1134) then
    --Step 4-1: Forest Song Arrival
        Log("Phase 4: Forest Song Outpost");
        AcceptQuestUsingDB(1025); Log("Accepting: [22]An Aggressive Defense");
        AcceptQuestUsingDB(1134); Log("Accepting: [22]The Lost Chalice");
        AcceptQuestUsingDB(1143); Log("Accepting: [25]The Windshear Crag");
        AcceptQuestUsingDB(1167); Log("Accepting: [24]A Shameful Waste");
        AcceptQuestUsingDB(1031); Log("Accepting: [25]The Branch of Cenarius");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Aggressive Defense
        Log("Step 4-2: Aggressive Defense");
        CompleteObjectiveOfQuest(1025,1); Log("Completing Objective: [22]An Aggressive Defense - Kill Foulweald Warriors");
        CompleteObjectiveOfQuest(1025,2); Log("Completing Objective: [22]An Aggressive Defense - Kill Foulweald Totemic");
        CompleteObjectiveOfQuest(1025,3); Log("Completing Objective: [22]An Aggressive Defense - Kill Foulweald Ursa");
        TurnInQuestUsingDB(1025); Log("Turn-in: [22]An Aggressive Defense");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: The Lost Chalice
        Log("Step 4-3: The Lost Chalice");
        CompleteObjectiveOfQuest(1134,1); Log("Completing Objective: [22]The Lost Chalice - Find the Chalice of Elune");
        TurnInQuestUsingDB(1134); Log("Turn-in: [22]The Lost Chalice");
        AcceptQuestUsingDB(1135); Log("Accepting: [25]The Korrak's Revenge");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Shameful Waste Operations
        Log("Step 4-4: Shameful Waste Operations");
        CompleteObjectiveOfQuest(1167,1); Log("Completing Objective: [24]A Shameful Waste - Kill Forsaken Infiltrators");
        CompleteObjectiveOfQuest(1167,2); Log("Completing Objective: [24]A Shameful Waste - Kill Forsaken Assassins");
        TurnInQuestUsingDB(1167); Log("Turn-in: [24]A Shameful Waste");
        AcceptQuestUsingDB(1168); Log("Accepting: [26]Destroy the Legion");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-5: Branch of Cenarius Chain
        Log("Step 4-5: Branch of Cenarius Chain");
        if EliteQuests == "true" then
            CompleteObjectiveOfQuest(1031,1); Log("Completing Objective: [25]The Branch of Cenarius - Collect Branch of Cenarius");
            TurnInQuestUsingDB(1031); Log("Turn-in: [25]The Branch of Cenarius");
            AcceptQuestUsingDB(1032); Log("Accepting: [28]Satyr Slaying!");
        else
            Log("Elite Quests disabled - skipping Branch of Cenarius");
        end
end --End Forest Song

--Phase 5: Satyrnaar and Demon Hunting (Level 24-26)
if not HasPlayerFinishedQuest(1032) then
    --Step 5-1: Satyr Slaying Operations
        Log("Phase 5: Satyrnaar and Demon Hunting");
        if EliteQuests == "true" then
            if IsHardCore == "true" then
                PopMessage("Satyrnaar has dangerous satyr enemies! Consider getting help.");
            end
            CompleteObjectiveOfQuest(1032,1); Log("Completing Objective: [28]Satyr Slaying! - Kill Geltharis");
            CompleteObjectiveOfQuest(1032,2); Log("Completing Objective: [28]Satyr Slaying! - Kill Satyr enemies");
            TurnInQuestUsingDB(1032); Log("Turn-in: [28]Satyr Slaying!");
            AcceptQuestUsingDB(1033); Log("Accepting: [30]Never Again!");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: Destroy the Legion
        Log("Step 5-2: Destroy the Legion");
        CompleteObjectiveOfQuest(1168,1); Log("Completing Objective: [26]Destroy the Legion - Kill Diabolical Fiends");
        CompleteObjectiveOfQuest(1168,2); Log("Completing Objective: [26]Destroy the Legion - Kill Roaming Felguards");
        TurnInQuestUsingDB(1168); Log("Turn-in: [26]Destroy the Legion");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: Raene's Cleansing Continuation
        Log("Step 5-3: Raene's Cleansing Continuation");
        if HasPlayerFinishedQuest(1022) then
            CompleteObjectiveOfQuest(1022,1); Log("Completing Objective: [25]Raene's Cleansing - Collect Glowing Gem");
            TurnInQuestUsingDB(1022); Log("Turn-in: [25]Raene's Cleansing");
            AcceptQuestUsingDB(1023); Log("Accepting: [27]Raene's Cleansing");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Mage Summoner Quest
        Log("Step 5-4: Mage Summoner Quest");
        if HasPlayerFinishedQuest(1017) and GetPlayerClass() == "Druid" then
            CompleteObjectiveOfQuest(1017,1); Log("Completing Objective: [25]Mage Summoner - Kill Shadethicket Oracle");
            TurnInQuestUsingDB(1017); Log("Turn-in: [25]Mage Summoner");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-5: Level 25 Check and Training
        Log("Step 5-5: Level 25 Check and Training");
        if(Player.Level < 25) then
            LevelTarget = 25
            Log("Grinding to Level "..LevelTarget..".");
            --[3754]Felhound,[3755]Bloodtail,[3752]Bleakheart Hellcaller
            GrindAndGather(TableToList({3754,3755,3752}),250,TableToFloatArray({8150.2,1564.8,45.2}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 25");
end --End Satyr/Demon Hunting

--Phase 6: Stonetalon Mountains Preparation (Level 25-27)
if not HasPlayerFinishedQuest(1056) then
    --Step 6-1: Stonetalon Peak Journey
        Log("Phase 6: Stonetalon Mountains Preparation");
        if HasPlayerFinishedQuest(1056) then
            TurnInQuestUsingDB(1056); Log("Turn-in: [23]Journey to Stonetalon Peak");
            AcceptQuestUsingDB(1057); Log("Accepting: [24]Kayneth Stillwind");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Windshear Crag Operations
        Log("Step 6-2: Windshear Crag Operations");
        if HasPlayerFinishedQuest(1143) then
            CompleteObjectiveOfQuest(1143,1); Log("Completing Objective: [25]The Windshear Crag - Investigate Windshear Crag");
            TurnInQuestUsingDB(1143); Log("Turn-in: [25]The Windshear Crag");
            AcceptQuestUsingDB(1144); Log("Accepting: [27]Pridewings of Stonetalon");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Fallen Sky Lake
        Log("Step 6-3: Fallen Sky Lake");
        if HasPlayerFinishedQuest(1035) then
            CompleteObjectiveOfQuest(1035,1); Log("Completing Objective: [26]Fallen Sky Lake - Investigate the crater");
            TurnInQuestUsingDB(1035); Log("Turn-in: [26]Fallen Sky Lake");
            AcceptQuestUsingDB(1036); Log("Accepting: [30]Return to Raene");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Kayneth Stillwind
        Log("Step 6-4: Kayneth Stillwind");
        if HasPlayerFinishedQuest(1057) then
            TurnInQuestUsingDB(1057); Log("Turn-in: [24]Kayneth Stillwind");
            AcceptQuestUsingDB(1058); Log("Accepting: [26]A Helping Hand");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-5: Helping Hand Quest
        Log("Step 6-5: Helping Hand Quest");
        if HasPlayerFinishedQuest(1058) then
            CompleteObjectiveOfQuest(1058,1); Log("Completing Objective: [26]A Helping Hand - Escort Kayneth to safety");
            TurnInQuestUsingDB(1058); Log("Turn-in: [26]A Helping Hand");
        end
end --End Stonetalon Prep

--Phase 7: High Level Completions (Level 27-29)
if not HasPlayerFinishedQuest(1023) then
    --Step 7-1: Raene's Cleansing Finale
        Log("Phase 7: High Level Completions");
        if HasPlayerFinishedQuest(1023) then
            CompleteObjectiveOfQuest(1023,1); Log("Completing Objective: [27]Raene's Cleansing - Kill Dartol");
            TurnInQuestUsingDB(1023); Log("Turn-in: [27]Raene's Cleansing");
            AcceptQuestUsingDB(1024); Log("Accepting: [30]Raene's Cleansing");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Never Again Quest
        Log("Step 7-2: Never Again Quest");
        if HasPlayerFinishedQuest(1033) and EliteQuests == "true" then
            CompleteObjectiveOfQuest(1033,1); Log("Completing Objective: [30]Never Again! - Destroy Xandivious");
            TurnInQuestUsingDB(1033); Log("Turn-in: [30]Never Again!");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Pridewings Collection
        Log("Step 7-3: Pridewings Collection");
        if HasPlayerFinishedQuest(1144) then
            CompleteObjectiveOfQuest(1144,1); Log("Completing Objective: [27]Pridewings of Stonetalon - Collect 12 Pridewing Venom Sacs");
            TurnInQuestUsingDB(1144); Log("Turn-in: [27]Pridewings of Stonetalon");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Class-Specific Level 25+ Quests
        Log("Step 7-4: Class-Specific Level 25+ Quests");
        if Player.Level >= 25 then
            if GetPlayerClass() == "Druid" then
                AcceptQuestUsingDB(3002); Log("Accepting: [26]Aquatic Form");
            elseif GetPlayerClass() == "Hunter" then
                AcceptQuestUsingDB(6087); Log("Accepting: [26]Taming the Beast");
            elseif GetPlayerClass() == "Priest" then
                AcceptQuestUsingDB(5648); Log("Accepting: [25]Cleansing Felwood");
            elseif GetPlayerClass() == "Warrior" then
                AcceptQuestUsingDB(1718); Log("Accepting: [26]The Islander");
            elseif GetPlayerClass() == "Rogue" then
                AcceptQuestUsingDB(2360); Log("Accepting: [25]Smash and Grab");
            elseif GetPlayerClass() == "Paladin" then
                AcceptQuestUsingDB(1661); Log("Accepting: [25]Tome of Divinity");
            elseif GetPlayerClass() == "Warlock" then
                AcceptQuestUsingDB(1795); Log("Accepting: [25]Succubi and Incubi");
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-5: Level 28 Check
        Log("Step 7-5: Level 28 Check");
        if(Player.Level < 28) then
            LevelTarget = 28
            Log("Grinding to Level "..LevelTarget..".");
            --[3754]Felhound,[3755]Bloodtail,[3752]Bleakheart Hellcaller,[3917]Befouled Water Elemental
            GrindAndGather(TableToList({3754,3755,3752,3917}),350,TableToFloatArray({8150.2,1564.8,45.2}),false,"LevelCheck",true);
        end
end --End High Level

--Phase 8: Final Cleanup and Zone Transition (Level 28-30)
if not HasPlayerFinishedQuest(1024) then
    --Step 8-1: Final Raene's Cleansing
        Log("Phase 8: Final Cleanup and Zone Transition");
        if HasPlayerFinishedQuest(1024) then
            TurnInQuestUsingDB(1024); Log("Turn-in: [30]Raene's Cleansing");
        end
        if HasPlayerFinishedQuest(1036) then
            TurnInQuestUsingDB(1036); Log("Turn-in: [30]Return to Raene");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-2: Korrak's Revenge
        Log("Step 8-2: Korrak's Revenge");
        if HasPlayerFinishedQuest(1135) and EliteQuests == "true" then
            if IsHardCore == "true" then
                PopMessage("Korrak's Revenge involves elite enemies! Consider getting help.");
            end
            CompleteObjectiveOfQuest(1135,1); Log("Completing Objective: [25]Korrak's Revenge - Kill Korrak");
            TurnInQuestUsingDB(1135); Log("Turn-in: [25]Korrak's Revenge");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-3: Final Training Session
        Log("Step 8-3: Final Training Session");
        if(Player.Level < 30) then
            LevelTarget = 30
            Log("Final grind to Level "..LevelTarget.." before leaving Ashenvale.");
            --[3754]Felhound,[3755]Bloodtail,[3752]Bleakheart Hellcaller,[3917]Befouled Water Elemental
            GrindAndGather(TableToList({3754,3755,3752,3917}),400,TableToFloatArray({8150.2,1564.8,45.2}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-4: Zone Transition Preparation
        Log("Step 8-4: Zone Transition Preparation");
        AcceptQuestUsingDB(1192); Log("Accepting: [28]Trouble in Desolace");
        AcceptQuestUsingDB(1193); Log("Accepting: [30]A New Plague");
        AcceptQuestUsingDB(4581); Log("Accepting: [25]Kayneth Stillwind");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-5: Safety Grind Option
        Log("Step 8-5: Safety Grind Option");
        if SafetyGrind == "true" then
            LevelTarget = 32
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Ashenvale");
            --[3754]Felhound,[3755]Bloodtail,[3752]Bleakheart Hellcaller,[3917]Befouled Water Elemental
            GrindAndGather(TableToList({3754,3755,3752,3917}),500,TableToFloatArray({8150.2,1564.8,45.2}),false,"LevelCheck",true);
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-6: Zone Completion Message
        Log("Step 8-6: Zone Completion Message");
        if IsHardCore == "true" then
            PopMessage("Ashenvale complete! Recommended level 28-30 for Stonetalon Mountains or Desolace.");
        end
        PopMessage("Ashenvale questing complete! Ready for Stonetalon Mountains, Desolace, or Thousand Needles at level " .. Player.Level);
        PopMessage("Alternative zones: Wetlands (20-30), Duskwood (20-30), or Redridge Mountains (15-25)");
end --End Ashenvale

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();