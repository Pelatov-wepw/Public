-- Dun Morogh Questing Profile (1-12)
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
function WolfMeat()
    if ItemCount("Tough Wolf Meat") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(179) then
        return false
    else
        return true
    end
end
function BoarRibs()
    if ItemCount("Crag Boar Rib") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(384) then
        return false
    else
        return true
    end
end
function WendigoManes()
    if ItemCount("Wendigo Mane") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(313) then
        return false
    else
        return true
    end
end
function LoperGnomeParts()
    if ItemCount("Restabilization Cog") >= 8 and ItemCount("Gyromechanic Gear") >= 8 then
        return false
    elseif HasPlayerFinishedQuest(412) then
        return false
    else
        return true
    end
end
function ShimmerweedBaskets()
    if ItemCount("Shimmerweed Basket") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(476) then
        return false
    else
        return true
    end
end

--Phase 1: Coldridge Valley (Levels 1-6)
if not HasPlayerFinishedQuest(233) then
    --Step 1-1: Initial Coldridge Valley Quests
        Log("Phase 1: Coldridge Valley - Starting Area");
        AcceptQuestUsingDB(179); Log("Accepting: [1]Dwarven Outfitters");
        CompleteObjectiveOfQuest(179,1); Log("Completing Objective: [1]Dwarven Outfitters - Collect 8 Tough Wolf Meat");
        TurnInQuestUsingDB(179); Log("Turn-in: [1]Dwarven Outfitters");
        AcceptQuestUsingDB(233); Log("Accepting: [1]Coldridge Valley Mail Delivery");
        AcceptQuestUsingDB(170); Log("Accepting: [2]A New Threat");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Class Quest Collection
        Log("Step 1-2: Class Quest Collection");
        if GetPlayerClass() == "Paladin" then
            AcceptQuestUsingDB(3646); Log("Accepting: [1]Consecrated Rune");
        elseif GetPlayerClass() == "Rogue" then
            AcceptQuestUsingDB(3645); Log("Accepting: [1]Encrypted Rune");
        elseif GetPlayerClass() == "Mage" then
            AcceptQuestUsingDB(3647); Log("Accepting: [1]Etched Rune");
        elseif GetPlayerClass() == "Priest" then
            AcceptQuestUsingDB(3644); Log("Accepting: [1]Hallowed Rune");
        elseif GetPlayerClass() == "Warrior" then
            AcceptQuestUsingDB(3648); Log("Accepting: [1]Simple Rune");
        elseif GetPlayerClass() == "Hunter" then
            AcceptQuestUsingDB(3649); Log("Accepting: [1]Etched Rune");
        elseif GetPlayerClass() == "Warlock" then
            AcceptQuestUsingDB(3650); Log("Accepting: [1]Tainted Memorandum");
            AcceptQuestUsingDB(1599); Log("Accepting: [4]Beginnings");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Early Coldridge Completion
        Log("Step 1-3: Early Coldridge Completion");
        CompleteObjectiveOfQuest(170,1); Log("Completing Objective: [2]A New Threat - Kill 6 Rockjaw Troggs");
        CompleteObjectiveOfQuest(170,2); Log("Completing Objective: [2]A New Threat - Kill 6 Burly Rockjaw Troggs");
        TurnInQuestUsingDB(170); Log("Turn-in: [2]A New Threat");
        -- Class quest turn-ins
        if GetPlayerClass() == "Paladin" then
            TurnInQuestUsingDB(3646); Log("Turn-in: [1]Consecrated Rune");
        elseif GetPlayerClass() == "Rogue" then
            TurnInQuestUsingDB(3645); Log("Turn-in: [1]Encrypted Rune");
        elseif GetPlayerClass() == "Mage" then
            TurnInQuestUsingDB(3647); Log("Turn-in: [1]Etched Rune");
        elseif GetPlayerClass() == "Priest" then
            TurnInQuestUsingDB(3644); Log("Turn-in: [1]Hallowed Rune");
            AcceptQuestUsingDB(5621); Log("Accepting: [4]In Favor of the Light");
        elseif GetPlayerClass() == "Warrior" then
            TurnInQuestUsingDB(3648); Log("Turn-in: [1]Simple Rune");
        elseif GetPlayerClass() == "Hunter" then
            TurnInQuestUsingDB(3649); Log("Turn-in: [1]Etched Rune");
        elseif GetPlayerClass() == "Warlock" then
            TurnInQuestUsingDB(3650); Log("Turn-in: [1]Tainted Memorandum");
            if IsHardCore == "true" then
                PopMessage("Warlock Imp quest ahead - may need to clear camp carefully");
            end
            CompleteObjectiveOfQuest(1599,1); Log("Completing Objective: [4]Beginnings - Retrieve Tome of the Cabal");
            TurnInQuestUsingDB(1599); Log("Turn-in: [4]Beginnings");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Mail Delivery Chain Part 1
        Log("Step 1-4: Mail Delivery Chain Part 1");
        TurnInQuestUsingDB(233); Log("Turn-in: [1]Coldridge Valley Mail Delivery");
        AcceptQuestUsingDB(234); Log("Accepting: [3]The Boar Hunter");
        CompleteObjectiveOfQuest(234,1); Log("Completing Objective: [3]The Boar Hunter - Kill 12 Small Crag Boars");
        TurnInQuestUsingDB(234); Log("Turn-in: [3]The Boar Hunter");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Refugee Items Collection
        Log("Step 1-5: Refugee Items Collection");
        AcceptQuestUsingDB(182); Log("Accepting: [4]A Refugee's Quandary");
        CompleteObjectiveOfQuest(182,1); Log("Completing Objective: [4]A Refugee's Quandary - Felix's Box");
        CompleteObjectiveOfQuest(182,2); Log("Completing Objective: [4]A Refugee's Quandary - Felix's Chest");
        CompleteObjectiveOfQuest(182,3); Log("Completing Objective: [4]A Refugee's Quandary - Felix's Bucket of Bolts");
        TurnInQuestUsingDB(182); Log("Turn-in: [4]A Refugee's Quandary");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Mail Delivery Chain Part 2
        Log("Step 1-6: Mail Delivery Chain Part 2");
        AcceptQuestUsingDB(235); Log("Accepting: [4]Coldridge Valley Mail Delivery");
        TurnInQuestUsingDB(235); Log("Turn-in: [4]Coldridge Valley Mail Delivery");
        AcceptQuestUsingDB(183); Log("Accepting: [5]The Troll Cave");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-7: Timed Delivery Quest
        Log("Step 1-7: Timed Delivery Quest");
        if(Player.Level >= 4) then
            AcceptQuestUsingDB(180); Log("Accepting: [5]Scalding Mornbrew Delivery");
            TurnInQuestUsingDB(180); Log("Turn-in: [5]Scalding Mornbrew Delivery");
            AcceptQuestUsingDB(181); Log("Accepting: [4]Bring Back the Mug");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-8: Troll Cave Operations
        Log("Step 1-8: Troll Cave Operations");
        CompleteObjectiveOfQuest(183,1); Log("Completing Objective: [5]The Troll Cave - Kill 14 Frostmane Troll Whelps");
        TurnInQuestUsingDB(183); Log("Turn-in: [5]The Troll Cave");
        AcceptQuestUsingDB(218); Log("Accepting: [5]The Stolen Journal");
        CompleteObjectiveOfQuest(218,1); Log("Completing Objective: [5]The Stolen Journal - Kill Grik'nir the Cold");
        TurnInQuestUsingDB(218); Log("Turn-in: [5]The Stolen Journal");
        AcceptQuestUsingDB(282); Log("Accepting: [6]Senir's Observations");
        TurnInQuestUsingDB(181); Log("Turn-in: [4]Bring Back the Mug");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-9: Preparation for Main Zone
        Log("Step 1-9: Preparation for Main Zone");
        CompleteObjectiveOfQuest(282,1); Log("Completing Objective: [6]Senir's Observations - Deliver to Mountaineer Thalos");
        TurnInQuestUsingDB(282); Log("Turn-in: [6]Senir's Observations");
        AcceptQuestUsingDB(420); Log("Accepting: [6]Senir's Observations");
        AcceptQuestUsingDB(419); Log("Accepting: [6]Supplies to Tannok");
        if(Player.Level < 6) then
            LevelTarget = 6
            Log("Grinding to Level "..LevelTarget.." before leaving Coldridge Valley.");
            --[808]Rockjaw Trogg,[724]Large Crag Boar,[176]Frostmane Troll Whelp
            GrindAndGather(TableToList({808,724,176}),100,TableToFloatArray({-6240.2,-3896.25,383.25}),false,"LevelCheck",true);
        end
        Training(); Log("Training before leaving Coldridge Valley");
end --End Coldridge Valley

--Phase 2: Kharanos Hub (Levels 6-8)
if not HasPlayerFinishedQuest(384) then
    --Step 2-1: Kharanos Arrival and Setup
        Log("Phase 2: Kharanos Hub - Central Operations");
        TurnInQuestUsingDB(420); Log("Turn-in: [6]Senir's Observations");
        GoToNPC(295,"Innkeeper Belm"); --Set hearthstone
        UseMacro("Gossip01");
        TurnInQuestUsingDB(419); Log("Turn-in: [6]Supplies to Tannok");
        AcceptQuestUsingDB(384); Log("Accepting: [6]Beer Basted Boar Ribs");
        AcceptQuestUsingDB(318); Log("Accepting: [6]Tools for Steelgrill");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Boar Rib Collection
        Log("Step 2-2: Boar Rib Collection");
        Log("Collecting Crag Boar Ribs while traveling");
        --[1126]Crag Boar
        GrindAndGather(TableToList({1126}),100,TableToFloatArray({-5601.87,-3310.42,346.97}),false,"BoarRibs",true);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Steelgrill's Depot Introduction
        Log("Step 2-3: Steelgrill's Depot Introduction");
        TurnInQuestUsingDB(318); Log("Turn-in: [6]Tools for Steelgrill");
        AcceptQuestUsingDB(319); Log("Accepting: [7]Stocking Jetsteam");
        AcceptQuestUsingDB(313); Log("Accepting: [7]The Grizzled Den");
        AcceptQuestUsingDB(317); Log("Accepting: [7]Ammo for Rumbleshot");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Collection Quests Phase 1
        Log("Step 2-4: Collection Quests Phase 1");
        CompleteObjectiveOfQuest(317,1); Log("Completing Objective: [7]Ammo for Rumbleshot - Collect Ammo Crate");
        CompleteObjectiveOfQuest(313,1); Log("Completing Objective: [7]The Grizzled Den - Collect 8 Wendigo Manes");
        TurnInQuestUsingDB(317); Log("Turn-in: [7]Ammo for Rumbleshot");
        CompleteObjectiveOfQuest(319,1); Log("Completing Objective: [7]Stocking Jetsteam - Kill 6 Ice Claw Bears");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Level 7 Check and Rhapsody Malt
        Log("Step 2-5: Level 7 Check and Rhapsody Malt");
        if(Player.Level < 7) then
            LevelTarget = 7
            Log("Grinding to Level "..LevelTarget.." for Beer Basted Boar Ribs completion.");
            --[1126]Crag Boar,[1127]Ice Claw Bear
            GrindAndGather(TableToList({1126,1127}),150,TableToFloatArray({-5601.87,-3310.42,346.97}),false,"LevelCheck",true);
        end
        UseHearthStone(); Log("Hearthing to Kharanos");
        GoToNPC(295,"Innkeeper Belm"); --Buy Rhapsody Malt
        UseMacro("Gossip01");
        TurnInQuestUsingDB(384); Log("Turn-in: [6]Beer Basted Boar Ribs");
        AcceptQuestUsingDB(310); Log("Accepting: [8]Frostmane Hold");
        TurnInQuestUsingDB(319); Log("Turn-in: [7]Stocking Jetsteam");
        AcceptQuestUsingDB(321); Log("Accepting: [7]Evershine");
        TurnInQuestUsingDB(313); Log("Turn-in: [7]The Grizzled Den");
        AcceptQuestUsingDB(412); Log("Accepting: [8]Operation Recombobulation");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-6: Class Quest Check (Level 6-8)
        Log("Step 2-6: Class Quest Check (Level 6-8)");
        if GetPlayerClass() == "Priest" and Player.Level >= 5 then
            CompleteObjectiveOfQuest(5621,1); Log("Completing Objective: [4]In Favor of the Light - Healing objective");
            TurnInQuestUsingDB(5621); Log("Turn-in: [4]In Favor of the Light");
        end
        Training(); Log("Training at Level 7-8");
end --End Kharanos Initial

--Phase 3: Brewnall Village Operations (Level 8-9)
if not HasPlayerFinishedQuest(321) then
    --Step 3-1: Brewnall Village Setup
        Log("Phase 3: Brewnall Village Operations");
        TurnInQuestUsingDB(321); Log("Turn-in: [7]Evershine");
        AcceptQuestUsingDB(320); Log("Accepting: [8]A Favor for Evershine");
        AcceptQuestUsingDB(315); Log("Accepting: [8]The Perfect Stout");
        AcceptQuestUsingDB(308); Log("Accepting: [8]Bitter Rivals");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: Evershine Collection
        Log("Step 3-2: Evershine Collection");
        CompleteObjectiveOfQuest(320,1); Log("Completing Objective: [8]A Favor for Evershine - Kill 6 Ice Claw Bears");
        CompleteObjectiveOfQuest(320,2); Log("Completing Objective: [8]A Favor for Evershine - Kill 8 Elder Crag Boars");
        CompleteObjectiveOfQuest(320,3); Log("Completing Objective: [8]A Favor for Evershine - Kill 8 Snow Leopards");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Perfect Stout Chain
        Log("Step 3-3: Perfect Stout Chain");
        CompleteObjectiveOfQuest(315,1); Log("Completing Objective: [8]The Perfect Stout - Collect 6 Shimmerweed Baskets");
        CompleteObjectiveOfQuest(315,2); Log("Completing Objective: [8]The Perfect Stout - Kill 6 Frostmane Seers");
        TurnInQuestUsingDB(315); Log("Turn-in: [8]The Perfect Stout");
        AcceptQuestUsingDB(413); Log("Accepting: [8]Shimmer Stout");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Operation Recombobulation
        Log("Step 3-4: Operation Recombobulation");
        CompleteObjectiveOfQuest(412,1); Log("Completing Objective: [8]Operation Recombobulation - Collect 8 Restabilization Cogs");
        CompleteObjectiveOfQuest(412,2); Log("Completing Objective: [8]Operation Recombobulation - Collect 8 Gyromechanic Gears");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Frostmane Hold
        Log("Step 3-5: Frostmane Hold");
        CompleteObjectiveOfQuest(310,1); Log("Completing Objective: [8]Frostmane Hold - Fully explore Frostmane Hold");
        CompleteObjectiveOfQuest(310,2); Log("Completing Objective: [8]Frostmane Hold - Kill 5 Frostmane Headhunters");
        TurnInQuestUsingDB(320); Log("Turn-in: [8]A Favor for Evershine");
        AcceptQuestUsingDB(322); Log("Accepting: [8]Return to Bellowfiz");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-6: Level 8 Check
        Log("Step 3-6: Level 8 Check");
        if(Player.Level < 8) then
            LevelTarget = 8
            Log("Grinding to Level "..LevelTarget.." for upcoming content.");
            --[1129]Elder Crag Boar,[1130]Snow Leopard,[1131]Frostmane Seer
            GrindAndGather(TableToList({1129,1130,1131}),150,TableToFloatArray({-5358.25,-2840.52,341.78}),false,"LevelCheck",true);
        end
end --End Brewnall Village

--Phase 4: Thunder Ale Heist (Level 8-9)
if not HasPlayerFinishedQuest(308) then
    --Step 4-1: Thunder Ale Heist Setup
        Log("Phase 4: Thunder Ale Heist");
        UseHearthStone(); Log("Hearthing to Kharanos for Thunder Ale quest");
        GoToNPC(295,"Innkeeper Belm"); --Buy Thunder Ale
        UseMacro("Gossip01");
        CompleteObjectiveOfQuest(308,1); Log("Completing Objective: [8]Bitter Rivals - Unguarded Thunder Ale");
        TurnInQuestUsingDB(308); Log("Turn-in: [8]Bitter Rivals");
        AcceptQuestUsingDB(309); Log("Accepting: [8]Return to Marleth");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Return to Brewnall
        Log("Step 4-2: Return to Brewnall");
        TurnInQuestUsingDB(309); Log("Turn-in: [8]Return to Marleth");
        TurnInQuestUsingDB(310); Log("Turn-in: [8]Frostmane Hold");
        TurnInQuestUsingDB(412); Log("Turn-in: [8]Operation Recombobulation");
        TurnInQuestUsingDB(322); Log("Turn-in: [8]Return to Bellowfiz");
        AcceptQuestUsingDB(400); Log("Accepting: [8]The Reports");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: Optional Elite Content
        Log("Step 4-3: Optional Elite Content");
        if EliteQuests == "true" then
            AcceptQuestUsingDB(314); Log("Accepting: [9]Protecting the Herd");
            if IsHardCore == "true" then
                PopMessage("Vagash is level 11 Elite - very dangerous solo!");
            end
            CompleteObjectiveOfQuest(314,1); Log("Completing Objective: [9]Protecting the Herd - Kill Vagash");
            TurnInQuestUsingDB(314); Log("Turn-in: [9]Protecting the Herd");
        else
            Log("Elite Quests disabled - skipping Vagash");
        end
end --End Thunder Ale

--Phase 5: Eastern Dun Morogh (Level 9-10)
if not HasPlayerFinishedQuest(400) then
    --Step 5-1: Gol'Bolar Quarry
        Log("Phase 5: Eastern Dun Morogh Operations");
        AcceptQuestUsingDB(433); Log("Accepting: [9]The Public Servant");
        AcceptQuestUsingDB(432); Log("Accepting: [9]Those Blasted Troggs!");
        CompleteObjectiveOfQuest(433,1); Log("Completing Objective: [9]The Public Servant - Kill Senator Mehr Stonehallow");
        CompleteObjectiveOfQuest(432,1); Log("Completing Objective: [9]Those Blasted Troggs! - Kill 6 Rockjaw Bonesnapper");
        CompleteObjectiveOfQuest(432,2); Log("Completing Objective: [9]Those Blasted Troggs! - Kill 10 Rockjaw Skullthumper");
        TurnInQuestUsingDB(433); Log("Turn-in: [9]The Public Servant");
        TurnInQuestUsingDB(432); Log("Turn-in: [9]Those Blasted Troggs!");
        TurnInQuestUsingDB(400); Log("Turn-in: [8]The Reports");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: North Gate Outpost
        Log("Step 5-2: North Gate Outpost");
        AcceptQuestUsingDB(416); Log("Accepting: [9]The Lost Pilot");
        CompleteObjectiveOfQuest(416,1); Log("Completing Objective: [9]The Lost Pilot - Find Pilot Hammerfoot");
        TurnInQuestUsingDB(416); Log("Turn-in: [9]The Lost Pilot");
        AcceptQuestUsingDB(417); Log("Accepting: [10]A Pilot's Revenge");
        CompleteObjectiveOfQuest(417,1); Log("Completing Objective: [10]A Pilot's Revenge - Kill Mangeclaw");
        TurnInQuestUsingDB(417); Log("Turn-in: [10]A Pilot's Revenge");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: Shimmer Stout Delivery
        Log("Step 5-3: Shimmer Stout Delivery");
        TurnInQuestUsingDB(413); Log("Turn-in: [8]Shimmer Stout");
        AcceptQuestUsingDB(414); Log("Accepting: [9]Stout to Kadrell");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Level 9-10 Check
        Log("Step 5-4: Level 9-10 Check");
        if(Player.Level < 9) then
            LevelTarget = 9
            Log("Grinding to Level "..LevelTarget.." for zone completion.");
            --[1183]Rockjaw Bonesnapper,[1184]Rockjaw Skullthumper,[1185]Rockjaw Ambusher
            GrindAndGather(TableToList({1183,1184,1185}),200,TableToFloatArray({-5048.87,-1717.42,501.78}),false,"LevelCheck",true);
        end
end --End Eastern Dun Morogh

--Phase 6: Ironforge and MacGrann's Cache (Level 9-10)
if not HasPlayerFinishedQuest(312) then
    --Step 6-1: MacGrann's Stolen Stash
        Log("Phase 6: MacGrann's Cache and Ironforge");
        AcceptQuestUsingDB(312); Log("Accepting: [8]Tundra MacGrann's Stolen Stash");
        if IsHardCore == "true" then
            PopMessage("Level 11 Elite Yeti patrols near MacGrann's cache - be very careful!");
        end
        CompleteObjectiveOfQuest(312,1); Log("Completing Objective: [8]Tundra MacGrann's Stolen Stash - MacGrann's Meat Locker");
        TurnInQuestUsingDB(312); Log("Turn-in: [8]Tundra MacGrann's Stolen Stash");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Ironforge Visit
        Log("Step 6-2: Ironforge Visit");
        AcceptQuestUsingDB(411); Log("Accepting: [9]The Brassbolts Brothers");
        -- Get Ironforge flight path if not already obtained
        GoToNPC(1573,"Gryth Thurden"); --Get flight path
        if GetPlayer().RaceName != "Dwarf" and GetPlayer().RaceName != "Gnome" then
            Log("Getting Ironforge flight path for non-Dwarf/Gnome");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Level 10 Class Quests
        Log("Step 6-3: Level 10 Class Quests");
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
            elseif GetPlayerClass() == "Hunter" then
                AcceptQuestUsingDB(6074); Log("Accepting: [10]Taming the Beast");
            end
        end
end --End Ironforge

--Phase 7: Zone Completion and Preparation (Level 10-12)
if not HasPlayerFinishedQuest(414) then
    --Step 7-1: Final Quest Cleanup
        Log("Phase 7: Final Quest Cleanup and Zone Completion");
        if HasItem("Undelivered Letter") then
            AcceptQuestUsingDB(430); Log("Accepting: [8]Deliver Letter to Ironforge");
            TurnInQuestUsingDB(430); Log("Turn-in: [8]Deliver Letter to Ironforge");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Loch Modan Preparation
        Log("Step 7-2: Loch Modan Preparation");
        -- Travel to Loch Modan for Stout delivery
        QuestGoToPoint(-4627.87,-2149.42,328.78); -- Loch Modan entrance
        TurnInQuestUsingDB(414); Log("Turn-in: [9]Stout to Kadrell");
        AcceptQuestUsingDB(1338); Log("Accepting: [10]Stormpike's Order");
        AcceptQuestUsingDB(416); Log("Accepting: [10]Rat Catching");
        AcceptQuestUsingDB(418); Log("Accepting: [10]Thelsamar Blood Sausages");
        -- Set hearthstone to Thelsamar
        GoToNPC(1464,"Innkeeper Hearthstove");
        UseMacro("Gossip01");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Final Training and Level Check
        Log("Step 7-3: Final Training and Level Check");
        if(Player.Level < 11) then
            LevelTarget = 11
            Log("Final grind to Level "..LevelTarget.." before leaving Dun Morogh.");
            --[1183]Rockjaw Bonesnapper,[1184]Rockjaw Skullthumper,[1185]Rockjaw Ambusher,[1126]Crag Boar
            GrindAndGather(TableToList({1183,1184,1185,1126}),200,TableToFloatArray({-5048.87,-1717.42,501.78}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Zone Transition Setup
        Log("Step 7-4: Zone Transition Setup");
        if IsHardCore == "true" then
            PopMessage("Dun Morogh complete! Recommended level 10-12 for Loch Modan. Hearthstone set to Thelsamar.");
        end
        PopMessage("Dun Morogh questing complete! Ready for Loch Modan at level " .. Player.Level);
        if SafetyGrind == "true" then
            LevelTarget = 12
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Dun Morogh");
            --[1183]Rockjaw Bonesnapper,[1184]Rockjaw Skullthumper,[1185]Rockjaw Ambusher,[1126]Crag Boar,[1127]Ice Claw Bear
            GrindAndGather(TableToList({1183,1184,1185,1126,1127}),300,TableToFloatArray({-5048.87,-1717.42,501.78}),false,"LevelCheck",true);
        end
end --End Dun Morogh

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();