-- Norhtshire Abbey Questing Profile
StartMobAvoidance()
UseDBToRepair(true)
UseDBToSell(true)
SetQuestRepairAt(30)
SetQuestSellAt(2)
IgnoreLowLevelQuests(false);
--Varibales--
IsHardCore = "false";
EliteQuests = "true"
ManualInteract = "false";
ManualGearCheck = "false";
SafetyGrind = "true";
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
--local _EK_FlightPaths = loadfile("Profiles\\Questing\\Classic\\PelQuesting\\ConfigFiles\\A_EK_FlightPaths.lua")
--local FMloc -- Declare the Test variable in this scope
--FMloc = _EK_FlightPaths()
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
    TrainerID = GetNearestClassTrainer().ID;
    TrainerName = GetNearestClassTrainer().Name;
    GoToNPC(TrainerID,TrainerName);
    UseMacro("Gossip1");
    UseMacro("TrainMe");
end
--------------------------------------------------------------------------------------
LevelTarget = 1
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end
function WestfallDeed()
    if HasItem("Westfall Deed") then
        return false
    elseif HasItem("Furlbrow's Deed") then
        return false
    else
        return true
    end
end
function TheCollector()
    if HasItem("The Collector's Schedule ") then
        return false
    elseif HasItem("Gold Pickup Schedule") then
        return false
    else
        return true
    end
end
--Step 1: Northshire Abbey
if not HasPlayerFinishedQuest(2158) then
    --Step 1-1: Beginning Quests
        Log("Step 1: Northshire Abbey");
        if not HasPlayerFinishedQuest(6) then
            AddNameToAvoidWhiteList("Kobold Vermin")
            AddNameToAvoidWhiteList("Kobold Worker")
            AddNameToAvoidWhiteList("Kobold Laborer")
            AddNameToAvoidWhiteList("Young Wolf")
            AddNameToAvoidWhiteList("Defias Thug")
        end
        AcceptQuestUsingDB(783); --A: A Threat Within
        TurnInQuestUsingDB(783); --T: A Threat Within
        AcceptQuestUsingDB(7); --A: Kobold Camp Cleanup
        AcceptQuestUsingDB(5261); --A: Eagan Peltskinner
        TurnInQuestUsingDB(5261); --T: Eagan Peltskinner
        AcceptQuestUsingDB(33); --A: Wolves Across the Border
        CompleteObjectiveOfQuest(33,1); --Objective:Wolves Across the Border - (8)Tough Wolf Meat
        CompleteObjectiveOfQuest(7,1); --Objective:Kobold Camp Cleanup - (10)Kobold Vermin
        TurnInQuestUsingDB(33); --T: Wolves Across the Border
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        if SafetyGrind == "true" then --Optional Safety Grinding Step
            LevelTarget = 4
            if Player.Level < LevelTarget then
                AddNameToAvoidWhiteList("Kobold Vermin")
                AddNameToAvoidWhiteList("Kobold Worker")
                AddNameToAvoidWhiteList("Kobold Laborer")
                Log("Safety Grind is True: Grinding to Level "..LevelTarget.." before Heading to Goldshire");
                GrindAndGather(TableToList({80,257,6}),150,TableToFloatArray({-8798.813,-116.9492,83.45266}),false,"LevelCheck",true);
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        if HasPlayerFinishedQuest(33) and not HasPlayerFinishedQuest(7) then
            GoToNPC(1213,"Godric Rothgar"); --Manual Sell Step
        end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-2: Class Quests
        Log("Step 1-2: Class Quests");
        if GetPlayer().RaceName == "Human" and GetPlayerClass() == "Mage" then
            TrainerID="198";TrainerName="Khelden Bremen";
            AcceptQuestUsingDB(3104); --A: Glyphic Letter
            TurnInQuestUsingDB(3104); --T: Glyphic Letter
        end
        if GetPlayer().RaceName == "Human" and GetPlayerClass() == "Priest" then
            TrainerID="375";TrainerName="Priestess Anetta";
            AcceptQuestUsingDB(3103); --A: Hallowed Letter
            TurnInQuestUsingDB(3103); --T: Hallowed Letter
        end
        if GetPlayer().RaceName == "Human" and GetPlayerClass() == "Paladin" then
            TrainerID="925";TrainerName="Brother Sammuel";
            AcceptQuestUsingDB(3101); --A: Consecrated Letter
            TurnInQuestUsingDB(3101); --T: Consecrated Letter
        end
        if GetPlayer().RaceName == "Human" and GetPlayerClass() == "Rogue" then
            TrainerID="917";TrainerName="Keryn Sylvius";
            AcceptQuestUsingDB(3102); --A: Encrypted Letter
            TurnInQuestUsingDB(3102); --T: Encrypted Letter
        end
        if GetPlayer().RaceName == "Human" and GetPlayerClass() == "Warlock" then
            TrainerID="459";TrainerName="Drusilla La Salle";
            AcceptQuestUsingDB(3105); --A: Tainted Letter
            TurnInQuestUsingDB(3105); --T: Tainted Letter
            AcceptQuestUsingDB(1598); --A: The Stolen Tome
            CompleteObjectiveOfQuest(1598,1); --Objective:The Stolen Tome - (1)Powers of the Void
            TurnInQuestUsingDB(1598); --T: The Stolen Tome
            --Summon Your Imp |complete warlockpet("Imp") |q 18 |future
        end
        if GetPlayer().RaceName == "Human" and GetPlayerClass() == "Warrior" then
            TrainerID="913";TrainerName="Llane Beshere";
            AcceptQuestUsingDB(3100); --A: Simple Letter
            TurnInQuestUsingDB(3100); --T: Simple Letter
        end
        if IsOnQuest(7) then
            Traning(); --Training Class Skills
        end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-3: Kobolds, Defias, and Grapes Oh My!
        Log("Step 1-3: Kobolds, Defias, and Grapes Oh My!");
        TurnInQuestUsingDB(7); --T: Kobold Camp Cleanup
        AcceptQuestUsingDB(15); --A: Investigate Echo Ridge
        CompleteObjectiveOfQuest(15,1); --Objective:Kobold Camp Cleanup - (10)Kobold Worker
        if HasPlayerFinishedQuest(7) and not HasPlayerFinishedQuest(15) then
            GoToNPC(1213,"Godric Rothgar"); --Manual Sell Step
        end
        if GetPlayer().Level < 6 and not HasPlayerFinishedQuest(15) then
            TrainerID = GetNearestClassTrainer().ID;
            TrainerName = GetNearestClassTrainer().Name;
            GoToNPC(TrainerID,TrainerName);
            UseMacro("Gossip1");
            UseMacro("TrainMe");
        end
        TurnInQuestUsingDB(15); --T: Investigate Echo Ridge
        AcceptQuestUsingDB(21); --A: Skirmish at Echo Ridge
        AcceptQuestUsingDB(18); --A: Brotherhood of Thieves
        if not HasPlayerFinishedQuest(18) then --Updating Temporary Whitelist for Mobs we need to kill
            AddNameToAvoidWhiteList("Defias Thug")
            AddNameToAvoidWhiteList("Garrick Padfoot")
        end
        CompleteObjectiveOfQuest(18,1); --Objective:Brotherhood of Thieves (12)Red Burlap Bandana
        TurnInQuestUsingDB(18); --T: Brotherhood of Thieves
        AcceptQuestUsingDB(6); --A: Bounty on Garrick Padfoot
        AcceptQuestUsingDB(3903); --A: Milly Osworth
        if HasPlayerFinishedQuest(18) and not HasPlayerFinishedQuest(6) then
            GoToNPC(1213,"Godric Rothgar"); --Manual Sell Step
        end
        CompleteObjectiveOfQuest(21,1); --Objective:Kobold Camp Cleanup - (12)Kobold Laborer
        TurnInQuestUsingDB(3903); --T: Milly Osworth
        if IsHardCore ~= "true" then
            AcceptQuestUsingDB(3904); --A: Milly's Harvest
        end
        CompleteObjectiveOfQuest(6,1); --Objective:Bounty on Garrick Padfoot - (1)Garrick's Head
        if IsHardCore ~= "true" then
            CompleteObjectiveOfQuest(3904,1); --Objective:Milly's Harvest - (8)Milly's Harvest
            TurnInQuestUsingDB(3904); --T: Milly's Harvest
            AcceptQuestUsingDB(3905); --A: Grape Manifest
        end
        TurnInQuestUsingDB(6); --T: Bounty on Garrick Padfoot
        if HasPlayerFinishedQuest(6) then --Updating Temporary Whitelist
            RemoveNameFromAvoidWhiteList("Defias Thug")
            RemoveNameFromAvoidWhiteList("Garrick Padfoot")
        end
        if HasPlayerFinishedQuest(6) and not HasPlayerFinishedQuest(21) then
            GoToNPC(1213,"Godric Rothgar"); --Manual Sell Step
        end
        TurnInQuestUsingDB(21); --T: Skirmish at Echo Ridge
        AcceptQuestUsingDB(54); --A: Report to Goldshire
        if IsHardCore ~= "true" and ManualInteract == "true" then
            if not HasPlayerFinishedQuest(3905) then
                PopMessage("Pathing to turn in [4]Grape Manifest is not working. Feel free to turn in manually");
                --TurnInQuestUsingDB(3905); --T: Grape Manifest
            end
        end
        if SafetyGrind == "true" then
            LevelTarget = 7
            AddNameToAvoidWhiteList("Kobold Vermin")
            AddNameToAvoidWhiteList("Kobold Worker")
            AddNameToAvoidWhiteList("Kobold Laborer")
            Log("Safety Grind is True: Grinding to Level "..LevelTarget.." before Heading to Goldshire");
            GrindAndGather(TableToList({80}),200,TableToFloatArray({-8797.063,-171.4275,81.5027}),false,"LevelCheck",true);
        end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 1-3_Priest: Priest Class Dress Quest
        if not HasPlayerFinishedQuest(5623) and GetPlayerClass() == "Priest" then
            AcceptQuestUsingDB(5623); --A: In Favor of the Light
        end
        AcceptQuestUsingDB(2158); --A: Rest and Relaxation
        TurnInQuestUsingDB(54); --T: Report to Goldshire
        if HasPlayerFinishedQuest(54) and not HasPlayerFinishedQuest(85) then
            GoToNPC(151,"Brog Hamfist"); --Clearing Last Target
            GoToNPC(295,"Innkeeper Farley"); --Set Hearthstone
            UseMacro("Gossip01");
        end
        TurnInQuestUsingDB(2158); --T: Rest and Relaxation
end --End Northshire Abbey
------------------------------------------------------------------
------------------------------------------------------------------
--Step 2: Elwynn Forest
if not HasPlayerFinishedQuest(1097) then
    if SafetyGrind == "true" then --Additional Safetey Grind to 9
        LevelTarget = 9
        GrindAndGather(TableToList({113}),75,TableToFloatArray({-9911.843,404.8743,35.28589}),true,"LevelCheck",true)
    end
    ----Step 2-1: Questing So Massive you wouldn't believe it
        AcceptQuestUsingDB(62); Log("Accepting: [7]The Fargodeep Mine");
        AcceptQuestUsingDB(60); Log("Accepting: [7]Kobold Candles");
        AcceptQuestUsingDB(47); Log("Accepting: [7]Gold Dust Exchange");
        if (IsOnQuest(47) == true and IsOnQuest(85) ~= true) then
            GoToNPC(54,"Corina Steele"); --Manual Sell Step
        end 
        AcceptQuestUsingDB(85); Log("Accepting: [6]Lost Necklace");
        TurnInQuestUsingDB(85); Log("Completing: [6]Lost Necklace");
        AcceptQuestUsingDB(86); Log("Accepting: [6]Pie for Billy");
        AcceptQuestUsingDB(106); Log("Accepting: [6]Young Lovers");
        CompleteObjectiveOfQuest(86,1); Log("Completing Objective: [6]Pie for Billy");
        TurnInQuestUsingDB(86); Log("Completing: [6]Pie for Billy");
        AcceptQuestUsingDB(84); Log("Accepting: [6]Back to Billy");
        AcceptQuestUsingDB(88); Log("Accepting: [9]Princess Must Die!");
        TurnInQuestUsingDB(106); Log("Completing: [6]Young Lovers");
        AcceptQuestUsingDB(111); Log("Accepting: [6]Speak with Gramma");
        TurnInQuestUsingDB(111); Log("Completing: [6]Speak with Gramma");
        AcceptQuestUsingDB(107); Log("Accepting: [6]Note to William");
        TurnInQuestUsingDB(84); Log("Completing: [6]Back to Billy");
        AcceptQuestUsingDB(87); Log("Accepting: [8]Goldtooth");
        if not HasPlayerFinishedQuest(62) then
            QuestGoToPoint(-9795.689, 160.5919, 0); -- Scout Through the Fargodeep Mine Quest Objective
        end
        CompleteObjectiveOfQuest(87,1); Log("Completing Objective: [8]Goldtooth");
        CompleteObjectiveOfQuest(60,1); Log("Completing Objective: [7]Kobold Candles");
        CompleteObjectiveOfQuest(47,1); Log("Completing Objective: [7]Gold Dust Exchange");
        TurnInQuestUsingDB(87); Log("Completing: [8]Goldtooth");
        TurnInQuestUsingDB(47); Log("Completing: [7]Gold Dust Exchange");
        AcceptQuestUsingDB(40); Log("Accepting: [10]A Fishy Peril");
        TurnInQuestUsingDB(40); Log("Completing: [10]A Fishy Peril");
        AcceptQuestUsingDB(35); Log("Accepting: [10]Further Concerns");
        TurnInQuestUsingDB(62); Log("Completing: [7]The Fargodeep Mine");
        AcceptQuestUsingDB(76); Log("Accepting: [10]The Jasperlode Mine");
        TurnInQuestUsingDB(60); Log("Completing: [7]Kobold Candles");
        if (IsOnQuest(35) == true and IsOnQuest(37) ~= true) then
            GoToNPC(54,"Corina Steele"); --Manual Sell Step
        end 
        AcceptQuestUsingDB(61); Log("Accepting: [7]Shipment to Stormwind");
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-2: Some Murloc Genocide with a Good Dose of Taxidermy Afterwards
        TurnInQuestUsingDB(107); Log("Completing: [6]Note to William");
        AcceptQuestUsingDB(112); Log("Accepting: [7]Collecting Kelp");
        if not HasPlayerFinishedQuest(112) then
            CompleteEntireQuest(112); Log("Completing Objective: [7]Collecting Kelp");
            SleepPlugin(10000);
        end
        AcceptQuestUsingDB(114); Log("Accepting: [7]The Escape");
        if (IsOnQuest(35) == true and IsOnQuest(37) ~= true) then
            GoToNPC(54,"Corina Steele"); --Manual Sell Step
        end 
        if IsOnQuest(35) and not IsOnQuest(37) then
            Training(); Log("Training Class Skills");
        end
        if not HasPlayerFinishedQuest(76) then 
            QuestGoToPoint(-9096.079, -564.0419, 62.24914); -- Scout Through the Jasperlode Mine
            TurnInQuestUsingDB(76); Log("Completing: [10]The Jasperlode Mine");
        end
        TurnInQuestUsingDB(61); Log("Completing: [7]Shipment to Stormwind");
        TurnInQuestUsingDB(35); Log("Completing: [10]Further Concerns");
        AcceptQuestUsingDB(37); Log("Accepting: [10]Find the Lost Guards");
        AcceptQuestUsingDB(52); Log("Accepting: [10]Protect the Frontier");
        TurnInQuestUsingDB(37); Log("Completing: [10]Find the Lost Guards");
        AcceptQuestUsingDB(45); Log("Accepting: [10]Discover Rolf's Fate");
        AcceptQuestUsingDB(5545); Log("Accepting: [9]A Bundle of Trouble");
        CompleteObjectiveOfQuest(5545,1); Log("Completing Objective: [9]A Bundle of Trouble");
        CompleteEntireQuest(52); Log("Completing: [10]Protect the Frontier:Killing Forest Bears");
        TurnInQuestUsingDB(5545); Log("Completing: [9]A Bundle of Trouble");
        AcceptQuestUsingDB(83); Log("Accepting: [9]Red Linen Goods");
        if (IsOnQuest(5545) == true and IsOnQuest(71) ~= true) then
            GoToNPC(1198,"Rallic Finn"); --Manual Sell Step
        end 
        if GetPlayer().Level < 10 then
            LevelTarget = 10
            DefiasRogueWizard = {474} -- Define once outside the loop
            AddNameToAvoidWhiteList("Defias Rogue Wizard");
            GrindAndGather(TableToList(DefiasRogueWizard), 100, TableToFloatArray({-9122.16, -1019.184, 72.52368}),false,"LevelCheck",true)
        end
        TurnInQuestUsingDB(45); Log("Completing: [10]Discover Rolf's Fate");
        AcceptQuestUsingDB(71); Log("Accepting: [10]Report to Thomas");
        if IsOnQuest(5545) and not IsOnQuest(83) then
            GoToNPC(1198,"Rallic Finn"); --Manual Sell Stepend
        end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-3: Cleanup, Gridning for Quest Drops, and Back to Goldshire
        TurnInQuestUsingDB(52); Log("Completing: [10]Protect the Frontier");
        TurnInQuestUsingDB(71); Log("Completing: [10]Report to Thomas");
        AcceptQuestUsingDB(39); Log("Accepting: [10]Deliver Thomas' Report");
        AcceptQuestUsingDB(109); Log("Accepting: [10]Report to Gyran Stoutmantle");
        CompleteObjectiveOfQuest(88,1); Log("Completing Objective: [9]Princess Must Die!");
        CompleteObjectiveOfQuest(83,1); Log("Completing Objective: [9]Red Linen Goods");
        if not HasPlayerFinishedQuest(184) then
           DefiasRogueWizard = {474}
           AddNameToAvoidWhiteList("Defias Rogue Wizard");
           GrindAndGather(TableToList(DefiasRogueWizard),100,TableToFloatArray({-9122.16, -1019.184, 72.52368}),false,"WestfallDeed",true)
           AcceptQuestUsingDB(184); Log("Accepting: [10]Furlbrow's Deed")
        end
        if not HasPlayerFinishedQuest(123) then
           RiverpawGnolls = {97,478}; -- Table to load Riverpaw Gnolls
           AddNameToAvoidWhiteList("Riverpaw Runt");
           AddNameToAvoidWhiteList("Riverpaw Outrunner");
           GrindAndGather(TableToList(RiverpawGnolls),200,TableToFloatArray({-8989.872, -764.0568, 74.30352}),false,"TheCollector",true);
           AcceptQuestUsingDB(123); Log("Accepting: [10]The Collector")
        end
        TurnInQuestUsingDB(83); Log("Completing: [9]Red Linen Goods");
        TurnInQuestUsingDB(76); Log("Completing: [10]The Jasperlode Mine");
        TurnInQuestUsingDB(123); Log("Completing: [10]The Collector");
        TurnInQuestUsingDB(39); Log("Completing: [10]Deliver Thomas' Report");
        AcceptQuestUsingDB(147); Log("Accepting: [10]Manhunt");
        AcceptQuestUsingDB(239); Log("Accepting: [10]Westbrook Garrison Needs Help!");
        AcceptQuestUsingDB(59); Log("Accepting: [10]Cloth and Leather Armor");
        AcceptQuestUsingDB(1097); Log("Accepting: [10]Elmore's Task");
        if IsOnQuest(88) and not IsOnQuest(46) then
            GoToNPC(54,"Corina Steele"); --Manual Sell Step
        end
    ------------------------------------------------------------------
    ------------------------------------------------------------------
    --Step 2-4: Class Quests and Final Steps
        Log("Step 2-4: Class Quests");
        if GetPlayerClass() == "Mage" then
            TrainerID="198";TrainerName="Khelden Bremen";
            AcceptQuestUsingDB(3104); --A: Glyphic Letter
            TurnInQuestUsingDB(3104); --T: Glyphic Letter
        end
        if GetPlayerClass() == "Priest" then
            TrainerID="375";TrainerName="Priestess Anetta";
            AcceptQuestUsingDB(3103); --A: Hallowed Letter
            TurnInQuestUsingDB(3103); --T: Hallowed Letter
        end
        if GetPlayerClass() == "Paladin" and not HasPlayerFinishedQuest(1788) then
            CompleteEntireQuest(2998); --A: Consecrated Letter
            CompleteEntireQuest(1641); --T: Consecrated Letter
            if not HasPlayerFinishedQuest(1642) then
                Log("DEBUG");
                CompleteEntireQuest(1790); --A: The Symbol of Life
                CompleteEntireQuest(1642); --T: The Tome of Divinity
            end
            AcceptQuestUsingDB(1642); --A: The Tome of Divinity
            TurnInQuestUsingDB(1642); --T: The Tome of Divinity
            CompleteEntireQuest(1643); --A: The Tome of Divinity
            CompleteEntireQuest(1644); --A: The Tome of Divinity
            CompleteEntireQuest(1780); --A: The Tome of Divinity
            CompleteEntireQuest(1781); --A: The Tome of Divinity
            CompleteEntireQuest(1786); --A: The Tome of Divinity
            CompleteEntireQuest(1787); --A: The Tome of Divinity
            CompleteEntireQuest(1788); --A: The Tome of Divinity
        end
        if GetPlayerClass() == "Rogue" then
            TrainerID="917";TrainerName="Keryn Sylvius";
            AcceptQuestUsingDB(3102); --A: Encrypted Letter
            TurnInQuestUsingDB(3102); --T: Encrypted Letter
        end
        if GetPlayerClass() == "Warlock" then
            TrainerID="459";TrainerName="Drusilla La Salle";
            AcceptQuestUsingDB(3105); --A: Tainted Letter
            TurnInQuestUsingDB(3105); --T: Tainted Letter
            AcceptQuestUsingDB(1598); --A: The Stolen Tome
            CompleteObjectiveOfQuest(1598,1); --Objective:The Stolen Tome - (1)Powers of the Void
            TurnInQuestUsingDB(1598); --T: The Stolen Tome
            --Summon Your Imp |complete warlockpet("Imp") |q 18 |future
        end
        if GetPlayerClass() == "Warrior" then
            TrainerID="913";TrainerName="Llane Beshere";
            AcceptQuestUsingDB(3100); --A: Simple Letter
            TurnInQuestUsingDB(3100); --T: Simple Letter
        end
        TurnInQuestUsingDB(88); Log("Completing: [9]Princess Must Die!");
        AcceptQuestUsingDB(46); Log("Accepting: [10]Bounty on Murlocs");
        TurnInQuestUsingDB(59); Log("Completing: [10]Cloth and Leather Armor");
        CompleteObjectiveOfQuest(46,1); Log("Completing Objective: [10]Bounty on Murlocs");
        CompleteObjectiveOfQuest(147,1); Log("Completing Objective: [10]Manhunt");
        TurnInQuestUsingDB(46); Log("Completing: [10]Bounty on Murlocs");
        TurnInQuestUsingDB(147); Log("Completing: [10]Manhunt");
        TurnInQuestUsingDB(239); Log("Completing: [10]Westbrook Garrison Needs Help!");
        AcceptQuestUsingDB(11); Log("Accepting: [10]Riverpaw Gnoll Bounty");
        if EliteQuests == "true" then
            AcceptQuestUsingDB(176); Log("Accepting: [10+]Hogger");
            CompleteObjectiveOfQuest(176,1); Log("Completing Objective: [10+]Hogger");
        end
        CompleteObjectiveOfQuest(11,1); Log("Completing Objective: [10]Riverpaw Gnoll Bounty");
        TurnInQuestUsingDB(11); Log("Completing: [10]Riverpaw Gnoll Bounty");
        if EliteQuests == "true" then
            TurnInQuestUsingDB(176); Log("Completing: [10+]Hogger");
        end
        TurnInQuestUsingDB(1097); Log("Completing: [10]Elmore's Task");
        if SafetyGrind == "true" then
            LevelTarget = 14
            AddNameToAvoidWhiteList("Defias Rogue Wizard");
            Log("Safety Grind is True: Grinding to Level "..LevelTarget.." before Heading to Westfall");
            GrindAndGather(TableToList({474}),100,TableToFloatArray({-9122.16, -1019.184, 72.52368}),false,"LevelCheck",true);
        end
end
------------------------------------------------------------------
------------------------------------------------------------------
--Step 3: Westfall
if not HasPlayerFinishedQuest(140) then
    --Step 3-1: Entry in to Westfall
        TurnInQuestUsingDB(184); Log("Completing: [09]Furlbrow's Deed");
        AcceptQuestUsingDB(64); Log("Accepting: [12]The Forgotten Heirloom");
        AcceptQuestUsingDB(36); Log("Accepting: [14]Westfall Stew");
        AcceptQuestUsingDB(151); Log("Accepting: [14]Poor Old Blanchy");
        AcceptQuestUsingDB(9); Log("Accepting: [14]The Killing Fields");
        CompleteObjectiveOfQuest(151,1); Log("Completing Objective of [14]Poor Old Blanchy: Gather 8 bundles of oats");
        TurnInQuestUsingDB(36); Log("Turn-in: [14]Westfall Stew");
        AcceptQuestUsingDB(22); Log("Accepting: [12]Goretusk Liver Pie");
        AcceptQuestUsingDB(38); Log("Accepting: [14]Westfall Stew");
        if IsOnQuest(38) and not IsOnQuest(12) then
            GoToNPC(523,"Thor"); --Discover Westfall Flight Point
        end
        --DiscoverFlightPoint("Sentinel Hill"); Log("Discovering Flight Point: Sentinel Hill");
        AcceptQuestUsingDB(153); Log("Accepting: [12]Red Leather Bandanas");
        TurnInQuestUsingDB(109); Log("Turn-in: [12]Report to Gryan Stoutmantle");
        AcceptQuestUsingDB(12); Log("Accepting: [12]The People's Militia");
        AcceptQuestUsingDB(102); Log("Accepting: [14]Patrolling Westfall");
        CompleteObjectiveOfQuest(64,1); Log("Completing Objective of [12]The Forgotten Heirloom: Retrieve the pocket watch");
        if not HasPlayerFinishedQuest(153) then
            AddNameToAvoidWhiteList("Defias Trapper");
            AddNameToAvoidWhiteList("Defias Smuggler");
            function KillDefiasUntilBandanas()
                if ItemCount("Red Linen Bandana") >= 15 then
                    return false; -- Stop grinding when we have enough bandanas
                else
                    return true; -- Continue grinding until we have enough bandanas
                end
            end
            GrindAndGather(TableToList({504,95}),200,TableToFloatArray({-10007.86, 1406.651, 40.75225}),false,"KillDefiasUntilBandanas",true);
        end
        CompleteObjectiveOfQuest(12,1); Log("Completing Objective of [12]The People's Militia: Defeat 15 Defias Bandits");
        CompleteObjectiveOfQuest(12,2); Log("Completing Objective of [12]The People's Militia: Defeat 15 Defias Bandits");
        CompleteObjectiveOfQuest(22,1); Log("Completing Objective of [12]Goretusk Liver Pie: Collect 8 Goretusk Livers");
        CompleteObjectiveOfQuest(38,1); Log("Completing Objective of [14]Westfall Stew: Gather ingredients");
        CompleteObjectiveOfQuest(38,2); Log("Completing Objective of [14]Westfall Stew: Gather ingredients");
        CompleteObjectiveOfQuest(38,3); Log("Completing Objective of [14]Westfall Stew: Gather ingredients");
        CompleteObjectiveOfQuest(38,4); Log("Completing Objective of [14]Westfall Stew: Gather ingredients");
        CompleteObjectiveOfQuest(102,1); Log("Completing Objective of [14]Patrolling Westfall: Defeat Gnolls");
        TurnInQuestUsingDB(12); Log("Turn-in: [12]The People's Militia");
        AcceptQuestUsingDB(13); Log("Accepting: [14]The People's Militia");
        TurnInQuestUsingDB(153); Log("Turn-in: [15]Red Leather Bandanas");
        if (IsOnQuest(64) == true and IsOnQuest(153) ~= true) then
            GoToNPC(1668,"William MacGregor"); --Manual Sell Step
        end
    --Step 3-2: Zoom zoom zoom zoom, Stormwind HO!!!!!!!!!!
        AcceptQuestUsingDB(6181); Log("Accepting: [10]A Swift Message");
        TurnInQuestUsingDB(6181); Log("Turn-in: [10]A Swift Message");
        AcceptQuestUsingDB(6281); Log("Accepting: [10]Continue to Stormwind");
        if IsOnQuest(6281) == true and IsOnQuest(6261) ~= true then
            GoToNPC(523,"Thor"); --Westfall FlightMaster
            SleepPlugin(1000); -- Slight Pause to ensure the flight master is ready
            UseMacro("Stormwind");
        end
        TurnInQuestUsingDB(6281); Log("Turn-in: [10]Continue to Stormwind");
        AcceptQuestUsingDB(6261); Log("Accepting: [10]Dungar Longdrink");
        if IsOnQuest(6261) and not IsOnQuest(6285)  then
            Training(); Log("Training Class Skills");
        end
        TurnInQuestUsingDB(6261); Log("Turn-in: [10]Dungar Longdrink");
        AcceptQuestUsingDB(6285); Log("Accepting: [10]Return to Lewis");
        --Step 2.5: Whoops, still stuck on the plains of Westfall
        if IsOnQuest(6285) == true and IsOnQuest(14) ~= true then
            GoToNPC(352,"Dungar Longdrink"); --Westfall FlightMaster
            SleepPlugin(1000); -- Slight Pause to ensure the flight master is ready
            UseMacro("Sentinel Hill"); Log("Flying to: Westfall");
        end
        TurnInQuestUsingDB(6285); Log("Turn-in: [10]Return to Lewis");
        TurnInQuestUsingDB(64); Log("Turn-in: [12]The Forgotten Heirloom");
        TurnInQuestUsingDB(151); Log("Turn-in: [14]Poor Old Blanchy");
        CompleteObjectiveOfQuest(9,1); Log("Completing Objective of [14]The Killing Fields: Destroy Harvest Watchers");
        if (ItemCount ("Hops") < 5 and HasItem("Keg of Thunderbrew") ~= true and HasPlayerFinishedQuest(116) ~= true) then
            HarvestWatcher = {}; 
            HarvestWatcher[1] = 480; 
            HopsFarm = CreateObjective("KillMobsAndLoot",1,1,1,103,TableToList(HarvestWatcher));
            KillMobsUntilItem("Hops",HopsFarm,5);
        end
        TurnInQuestUsingDB(9); Log("Turn-in: [14]The Killing Fields");
        TurnInQuestUsingDB(22); Log("Turn-in: [12]Goretusk Liver Pie");
        TurnInQuestUsingDB(38); Log("Turn-in: [14]Westfall Stew");
        TurnInQuestUsingDB(102); Log("Turn-in: [14]Patrolling Westfall");
        --Its the Eye of the Grinder its the Thrill of the Fight, gonna shank crabs until Level 19!
        if SafetyGrind == "true" then
            LevelTarget = 18
            AddNameToAvoidWhiteList("Sea Crawler");
            Log("Safety Grind is True: Grinding to Level "..LevelTarget.." before Heading to Westfall");
            GrindAndGather(TableToList({831}),50,TableToFloatArray({-9942.369, 1884.301, 6.7357328}),false,"LevelCheck",true);
        end
        --
    --Step 3-3: The Militant People
        CompleteObjectiveOfQuest(13,1); Log("Completing Objective of [14]The People's Militia: Defeat 15 Defias Pillagers and 15 Defias Looters");
        CompleteObjectiveOfQuest(13,2); Log("Completing Objective of [14]The People's Militia: Defeat 15 Defias Pillagers and 15 Defias Looters");
        TurnInQuestUsingDB(13); Log("Turn-in: [14]The People's Militia");
        AcceptQuestUsingDB(14); Log("Accepting: [17]The People's Militia");
        AcceptQuestUsingDB(65); Log("Accepting: [18]The Defias Brotherhood"); --Turnin in RR
        CompleteObjectiveOfQuest(14,1); Log("Completing Objective of [17]The People's Militia: Defeat 15 Defias Highwaymen, 5 Defias Pathstalkers, and 5 Defias Knuckledusters");
        CompleteObjectiveOfQuest(14,2); Log("Completing Objective of [17]The People's Militia: Defeat 15 Defias Highwaymen, 5 Defias Pathstalkers, and 5 Defias Knuckledusters");
        CompleteObjectiveOfQuest(14,3); Log("Completing Objective of [17]The People's Militia: Defeat 15 Defias Highwaymen, 5 Defias Pathstalkers, and 5 Defias Knuckledusters");
        if ItemCount("Hops") >= 5 then
            AcceptQuestUsingDB(117);
            TurnInQuestUsingDB(117);
        end
        TurnInQuestUsingDB(14); Log("Turn-in: [17]The People's Militia");
    --Step 3-4: In Loch Step
        AcceptQuestUsingDB(353); Log("Accept: [15]Stormpike's Delivery");
        if IsOnQuest(353) and not IsOnQuest(2039) then
            if GetZoneID() == 1453 then
                GoToNPC(352,"Dungar Longdrink"); --Stormwind FlightMaster
                UseMacro("Ironforge"); --Flying to Ironforge
            else
                QuestGoToPoint(-8395.126, 568.393, 91.53883); --SW Deeprun Tram Entrance
                PopMessage("Please Manually Navigate to the Deeprun Tram.  If you already have the Ironforge Flightpoint, that is fine too");
            end
        end
        if IsOnQuest(353) and not IsOnQuest(2039) and GetZoneID() == 1455 then
            GoToNPC(1573,"Gryth Thurden"); --Ironforge FlightMaster
        end
        AcceptQuestUsingDB(2039); Log("Accept: [15]Find Bingles");
        AcceptQuestUsingDB(467); Log("Accept: [23]Stonegear's Search");
        TurnInQuestUsingDB(467); Log("Turn-in: [23]Stonegear's Search");
        AcceptQuestUsingDB(466); Log("Accept: [22]Search for Incendicite");
        if EliteQuests == "true" then
            AcceptQuestUsingDB(314); Log("Accept: [12+]Protecting the Herd");
            CompleteObjectiveOfQuest(314,1); Log("Completing Objective of [12+]Protecting the Herd: (1)Fang of Vagash");
            TurnInQuestUsingDB(314); Log("Turn-in: [12+]Protecting the Herd");
        end
        AcceptQuestUsingDB(432); Log("Accept: [9]Those Blasted Troggs!");
        AcceptQuestUsingDB(433); Log("Accept: [11]The Public Servant");
        CompleteObjectiveOfQuest(432,1); Log("Completing Objective of [9]Those Blasted Troggs!: (6)Rockjaw Skullthumpers");
        CompleteObjectiveOfQuest(433,1); Log("Completing Objective of [11]The Public Servant: (10)Rockjaw Bonesnappers");
        TurnInQuestUsingDB(432); Log("Turn-in: [9]Those Blasted Troggs!");
        TurnInQuestUsingDB(433); Log("Turn-in: [11]The Public Servant");
        AcceptQuestUsingDB(419); Log("Accept: [10]The Lost Pilot");
        TurnInQuestUsingDB(419); Log("Turn-in: [10]The Lost Pilot");
        AcceptQuestUsingDB(417); Log("Accept: [11]A Pilot's Revenge");
        CompleteObjectiveOfQuest(417,1); Log("Completing Objective of [11]A Pilot's Revenge: (1)");
        TurnInQuestUsingDB(417); Log("Turn-in: [11]A Pilot's Revenge");
    --Step 3-5: Now on to the real bear meat and spider ichor and boar intestines of the situation
        TurnInQuestUsingDB(353); Log("Turn-in: [15]Stormpike's Delivery");
        AcceptQuestUsingDB(307); Log("Accept: [15]Filthy Paws");
        if (ItemCount("Bear Meat") < 3) and HasPlayerFinishedQuest(418) ~= true then
            ElderBlackBear = {1186,1195,1190}; --I can Bearly stand the sheer animal murder anymore, or can I?
            KillElderBlackBear = CreateObjective("KillMobsAndLoot",1,10,1,418,TableToList(ElderBlackBear));
            KillMobsUntilItem("Bear Meat",KillElderBlackBear,3);
        end
        if (ItemCount("Boar Intestines") < 3) and HasPlayerFinishedQuest(418) ~= true then
            MountainBoar = {1190,1195,1186}; --Do you have the Intestinal Fortitude to seperate a boar from his family? Do you punk?
            KillMountainBoar = CreateObjective("KillMobsAndLoot",1,10,1,418,TableToList(MountainBoar));
            KillMobsUntilItem("Boar Intestines",KillMountainBoar,3);
        end
        if (ItemCount("Spider Ichor") < 3) and HasPlayerFinishedQuest(418) ~= true then
            ForestLurker = {1195,1190,1186}; --Its the Eye of the Spider is the thrill of the bite
            KillForestLurker = CreateObjective("KillMobsAndLoot",1,10,1,418,TableToList(ForestLurker));
            KillMobsUntilItem("Spider Ichor",KillForestLurker,3);
        end
        AcceptQuestUsingDB(418); Log("Accept: [11]Thelsamar Blood Sausages");
        CompleteEntireQuest(418); Log("Completing Objective of [11]Thelsamar Blood Sausages: (3)Bear Meat, (3)Boar Intestines, (3)Spider Ichor");
        --AcceptQuestUsingDB(1339); Log("Accept: [15]Mountaineer Stormpike's Task");
        AcceptQuestUsingDB(416); Log("Accept: [11]Rat Catching"); --THis is trying to use Option 2 even though there's no option 2 available....
        --See if I can drop quest 
        --AcceptQuestUsingDB(1339); Log("Accept: [15]Mountaineer Stormpike's Task");
        CompleteObjectiveOfQuest(416,1); Log("Complete Obective [11]Rat Catching: (12)Tunnel Rat Ears");
        CompleteObjectiveOfQuest(307,1); Log("Complete Obective [15]Filthy Paws: (4)Miners' Gear");
        if ItemCount("Linen Cloth") < 7 then
            KillKobolds = CreateObjective("KillMobsAndLoot",1,1,1,999,TableToList({1201,1172}));
            KillMobsUntilItem("Linen Cloth",KillKobolds,7);
        end
        TurnInQuestUsingDB(307); Log("Turn-in [15]Filthy Paws");
        TurnInQuestUsingDB(416); Log("Turn-in: [15]Mountaineer Stormpike's Task");
        AcceptQuestUsingDB(1338); Log("Accept: [14]Stormpike's Order");
        TurnInQuestUsingDB(416); Log("Turn-in: [11]Rat Catching");
        
        
        --Step 3: Troggs on the King's Land, meh....I guess they're worth XP and rep
        AcceptQuestUsingDB(267); Log("Accept: [12]The Trogg Threat");
        AcceptQuestUsingDB(224); Log("Accept: [12]In Defense of the King's Land");
        CompleteObjectiveOfQuest(267,1); Log("Completing Objective [12]The Trogg Threat: (8)Trogg Stone Tooth");
        CompleteObjectiveOfQuest(224,1); Log("Completing Objective [12]In Defense of the King's Land: (10)Stonesplinter Trogg slain");
        CompleteObjectiveOfQuest(224,2); Log("Completing Objective [12]In Defense of the King's Land: (10)Stonesplinter Scout slain");
        TurnInQuestUsingDB(267); Log("Turn-in: [12]The Trogg Threat");
        TurnInQuestUsingDB(224); Log("Turn-in: [12]In Defense of the King's Land");
        AcceptQuestUsingDB(237); Log("Accept: [15]In Defense of the King's Land");
        CompleteObjectiveOfQuest(237,1); Log("Completing Objective [15]In Defense of the King's Land: (10)Stonesplinter Skullthumper slain");
        CompleteObjectiveOfQuest(237,2); Log("Completing Objective [15]In Defense of the King's Land: (10)Stonesplinter Seer slain");
        TurnInQuestUsingDB(237); Log("Turn-in: [15]In Defense of the King's Land");
        AcceptQuestUsingDB(263); Log("Accept: [15]In Defense of the King's Land");
        Troggs = {}; -- Table to load Troggs
        Troggs[1] = 1197; Troggs[2] = 1164; --Stonesplinter Shaman -- Stonesplinter Bonesnapper
        TroggsShaman = CreateObjective("KillMobsAndLoot",1,10,2,263,TableToList(Troggs));
        TroggsBonesnapper = CreateObjective("KillMobsAndLoot",2,10,2,263,TableToList(Troggs));
        DoObjective(TroggsShaman); DoObjective(TroggsBonesnapper);-- Quest Objective(s):Log("Completing Objective [15]In Defense of the King's Land
        TurnInQuestUsingDB(263); Log("Turn-in: [15]In Defense of the King's Land");
    --Step 3-5: And I would walk 500 miles, and I would walk 500 more
        if IsOnQuest(65) and not IsOnQuest(132) then
            GoToNPC(1572,"Thorgrum Borrelson"); --Westfall FlightMaster
            SleepPlugin(1000); -- Slight Pause to ensure the flight master is ready
            UseMacro("Redridge"); Log("Flying to: Redridge Mountains");
        end
        if not HasPlayerFinishedQuest(65) then
            GoToNPC(6727,"Innkeeper Brianna"); --Redridge Mountains Innkeeper
            PopMessage("Wiley the Black is Upstairs and pathing to him is not working.  Please compelte mauinally.");
            TurnInQuestUsingDB(65); Log("Turn-in: [18]The Defias Brotherhood");
            AcceptQuestUsingDB(132); Log("Accepting: [18]The Defias Brotherhood"); --Turnin in WF
        end
        --While in Redridge
        AcceptQuestUsingDB(244); Log("Accepting: [16]Encroaching Gnolls");
        if not HasPlayerFinishedQuest(3741) or not HasPlayerFinishedQuest(125) then
            if HasItem("Elixir of Water Breathing") then
                UseItem("Elixir of Water Breathing");
            end
            --PopMessage("Quests (3741)Hillary's Necklace and (125)The Lost Tools Need Manual Completion.  Please complete now.");
            CompleteEntireQuest(3741); Log("Completing: [16]Hillary's Necklace");
            CompleteEntireQuest(125); Log("Completing: [16]The Lost Tools");
        end
        TurnInQuestUsingDB(244); Log("Turn-in: [16]Encroaching Gnolls");
        AcceptQuestUsingDB(246); Log("Accepting: [17]Assessing the Threat");
        CompleteObjectiveOfQuest(246,1); Log("Completing Objective of [17]Assessing the Threat: Redridge Mongrel 0/10");
        CompleteObjectiveOfQuest(246,2); Log("Completing Objective of [17]Assessing the Threat: Redridge Poacher 0/6");
        TurnInQuestUsingDB(246); Log("Turn-in: [17]Assessing the Threat");
        AcceptQuestUsingDB(116); Log("Accepting: [15]Dry Times"); --Need to think on this one......
    --CompleteObjectiveOfQuest(116,1); --(1262)Keg of Thunderbrew, Quest Reward from (117)Thunderbrew, in Westfall (5 Hops)
    --CompleteObjectiveOfQuest(116,2); --(1941)Cask of Merlot, Sold by (277)Roberto Pupellyverbos, in SW
    --CompleteObjectiveOfQuest(116,3); --(1942)Bottle of Moonshine, Sold by (274)Barkeep Hann, in Darkshire Inn
    --CompleteObjectiveOfQuest(116,4); --(1939)Skin of Sweet Rum, Sold by (465)Barkeep Dobbins, In Goldshire Inn
    AcceptQuestUsingDB(129); Log("Accepting: [15]A Free Lunch");
    TurnInQuestUsingDB(129); Log("Turn-in: [15]A Free Lunch");
    AcceptQuestUsingDB(130); Log("Accepting: [15]Visit the Herbalist");
    TurnInQuestUsingDB(130); Log("Turn-in: [15]Visit the Herbalist");
    AcceptQuestUsingDB(131); Log("Accepting: [15]Delivering Daffodils");
    TurnInQuestUsingDB(131); Log("Turn-in: [15]Delivering Daffodils");
    --What the Redridge
    if CanTurnInQuest(132) then
        GoToNPC(931,"Ariena Stormfeather");
        UseMacro("Sentinel Hill"); --Flying to Westfall
    end
    TurnInQuestUsingDB(132); Log("Turn-in: [18]The Defias Brotherhood");
    AcceptQuestUsingDB(135); Log("Accepting: [18]The Defias Brotherhood"); --Turnin SW
    if (CanTurnInQuest(135) == true and GetZoneID() == 1432) then
        GoToNPC(523,"Thor"); --Westfall FlightMaster
        UseMacro("Stormwind");
    end
    TurnInQuestUsingDB(135); Log("Turn-in: [18]The Defias Brotherhood");
    AcceptQuestUsingDB(141); Log("Accepting: [18]The Defias Brotherhood"); --Turnin WF
    TurnInQuestUsingDB(141); Log("Turn-in: [18]The Defias Brotherhood");
    AcceptQuestUsingDB(142); Log("Accepting: [18]The Defias Brotherhood");
    CompleteObjectiveOfQuest(142,1); Log("Completing Objective of [18]The Defias Brotherhood: Retrieve the Defias Orders");
    TurnInQuestUsingDB(142); Log("Turn-in: [18]The Defias Brotherhood");
    AcceptQuestUsingDB(155); Log("Accepting: [18]The Defias Brotherhood");
    --Step 4.5: Just to be the man who walked 1000 miles to meet you at the Deadmines
    if not HasPlayerFinishedQuest(155) and not CanTurnInQuest(155) then    
        PopMessage("Quest 155-[18]The Defias Brotherhood: Escort the Defias Traitor needs to be done manually.");
        PopMessage("If you don't want to do this manually, then you'll need to grind to L20/L21 to make up for the rest of Westfall");
    end
    TurnInQuestUsingDB(155); Log("Turn-in: [18]The Defias Brotherhood");
    AcceptQuestUsingDB(166); Log("Accept: [22]The Defias Brotherhood"); --Dungeon Quest: Shank Van Cleef, leaving the chain here.
    --Step 5: The Lighthouse Murloc Shanking Finale
    if (HasPlayerFinishedQuest(103) ~= true and ItemCount("Flask of Oil") < 5) then
        HarvestWatcher = {}; 
        HarvestWatcher[1] = 480; 
        OilFarm = CreateObjective("KillMobsAndLoot",1,1,1,103,TableToList(HarvestWatcher));
        KillMobsUntilItem("Flask of Oil",OilFarm,5);
    end
    if HasPlayerFinishedQuest(104) ~= true then    
        QuestGoToPoint(-11326.05, 1789.546, 22.20564);    
        --PopMessage("Captain Grayson Lighthouse Quests: Pickup and turn-in needs to be done manually.");
        --PopMessage("Profile will get you to just before the swim, go pick up then swim back to shore.  Bot will then go and do its thing.  Once all are done, swim back to island manually and turn-in.");
        AcceptQuestUsingDB(104); Log("Accept: [20]The Coastal Menance");
        AcceptQuestUsingDB(103); Log("Accept: [16]Keeper of the Flame");
        TurnInQuestUsingDB(103); Log("Turn-in: [16]Keeper of the Flame");
        AcceptQuestUsingDB(152); Log("Accept: [19]The Coast Isn't Clear");
        CompleteObjectiveOfQuest(104,1); Log("Completing Objective [20]The Coastal Menance: Scale of Old Murk-Eye");
        CompleteObjectiveOfQuest(152,1); Log("Completing All Objectives: [19]The Coast Isn't Clear");
        CompleteObjectiveOfQuest(152,2); Log("Completing All Objectives: [19]The Coast Isn't Clear");
        CompleteObjectiveOfQuest(152,3); Log("Completing All Objectives: [19]The Coast Isn't Clear");
        CompleteObjectiveOfQuest(152,4); Log("Completing All Objectives: [19]The Coast Isn't Clear");
        QuestGoToPoint(-11326.05, 1789.546, 22.20564);
        PopMessage("Time to Swim Back Across to Turn-in");
        TurnInQuestUsingDB(152); Log("Turn-in: [19]The Coast Isn't Clear");
        TurnInQuestUsingDB(104); Log("Turn-in: [20]The Coastal Menance");
    end
    if not HasPlayerFinishedQuest(136) then
        function GetTheMap()
            if HasItem("Captain Sander's Treasure Map") then
                return false -- Stop grinding when we have the map
            elseif IsOnQuest(136) then
                return false -- Stop grinding if we are on the quest
            else
                return true
            end
        end
        Murlocs={458,171};
        AddNameToAvoidWhiteList("Murloc Hunter");
        AddNameToAvoidWhiteList("Murloc Warrior");
        GrindAndGather(TableToList(Murlocs),200,TableToFloatArray({-8989.872, -764.0568, 74.30352}),false,"GetTheMap",true);
        AcceptQuestUsingDB(123); Log("Accepting: [10]Captain Sander's Hidden Treasure")
    end
    AcceptQuestUsingDB(136); -- [16] Captain Sanders' Hidden Treasure
    if not HasPlayerFinishedQuest(136) then
        QuestGoToPoint(-10512.88, 2110.36, 2.696788);
        function UseFootLocker() 
            local Objects = GetObjectList();
            foreach Object in Objects do
                if Object.Name == "Captain's Footlocker" then
                    Log("Found the Captain's Footlocker!");
                    InteractWithObject(Object);
                    SleepPlugin(5000);
                end; -- IF
            end; -- For Each
        end; -- Function
        UseFootLocker();
    end;AcceptQuestUsingDB(138); Log("Accepting: [16] Captain Sanders' Hidden Treasure");
    if HasPlayerFinishedQuest(138)==false then
        QuestGoToPoint(-10514.52, 1598.402, 44.1889);
        function UseBarrel() 
            local Objects = GetObjectList();
            foreach Object in Objects do
                if Object.Name == "Broken Barrel" then
                    Log("Found the Barrel!");
                    InteractWithObject(Object);
                    SleepPlugin(5000);
                end; -- IF
            end; -- For Each
        end; -- Function
        UseBarrel();
    end;
    AcceptQuestUsingDB(139); Log("Accepting: [16] Captain Sanders' Hidden Treasure");
    if HasPlayerFinishedQuest(139)==false then
        QuestGoToPoint(-9798.028, 1594.697, 39.77632);
        function UseJug() 
            local Objects = GetObjectList();
            foreach Object in Objects do
                if Object.Name == "Old Jug" then
                    Log("Found the Jug!");
                    InteractWithObject(Object);
                    SleepPlugin(5000);
                end; -- IF
            end; -- For Each
        end; -- Function
        UseJug();
    end;
    AcceptQuestUsingDB(140); Log("Accepting: [16] Captain Sanders' Hidden Treasure");
    --CompleteEntireQuest(140); Log("Completing: [16] Captain Sanders' Hidden Treasure"); -- Can't Complete at this time due to Mesh issues with water
    if Player.Race == "Human" then
        FMloc.Westfall();
        FlyTo.Ironforge();
    end
end
StopQuestProfile();
------------------------------------------------------------------
------------------------------------------------------------------