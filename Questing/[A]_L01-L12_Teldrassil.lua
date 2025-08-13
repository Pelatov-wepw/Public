-- Teldrassil Questing Profile (1-12)
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
function FelMoss()
    if ItemCount("Fel Moss") >= 6 then
        return false
    elseif HasPlayerFinishedQuest(475) then
        return false
    else
        return true
    end
end
function ZennsBidding()
    if ItemCount("Nightsaber Fang") >= 3 and ItemCount("Strigid Owl Feather") >= 3 and ItemCount("Webwood Spider Silk") >= 3 then
        return false
    elseif HasPlayerFinishedQuest(488) then
        return false
    else
        return true
    end
end
function TimberlingParts()
    if ItemCount("Timberling Seed") >= 8 and ItemCount("Timberling Sprout") >= 12 then
        return false
    elseif HasPlayerFinishedQuest(997) and HasPlayerFinishedQuest(918) then
        return false
    else
        return true
    end
end
function SmallSpiderLegs()
    if ItemCount("Small Spider Leg") >= 7 then
        return false
    elseif HasPlayerFinishedQuest(4161) then
        return false
    else
        return true
    end
end

--Phase 1: Shadowglen (Levels 1-6)
if not HasPlayerFinishedQuest(456) then
    --Step 1-1: Initial Shadowglen Quests
        Log("Phase 1: Shadowglen - Starting Area");
        AcceptQuestUsingDB(456); Log("Accepting: [2]The Balance of Nature");
        CompleteObjectiveOfQuest(456,1); Log("Completing Objective: [2]The Balance of Nature - Kill 4 Young Thistle Boars");
        CompleteObjectiveOfQuest(456,2); Log("Completing Objective: [2]The Balance of Nature - Kill 7 Young Nightsabers");
        TurnInQuestUsingDB(456); Log("Turn-in: [2]The Balance of Nature");
        AcceptQuestUsingDB(457); Log("Accepting: [3]The Balance of Nature");
        AcceptQuestUsingDB(458); Log("Accepting: [1]The Woodland Protector");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Class Quest Collection
        Log("Step 1-2: Class Quest Collection");
        if GetPlayerClass() == "Druid" then
            AcceptQuestUsingDB(3120); Log("Accepting: [1]Verdant Sigil");
        elseif GetPlayerClass() == "Rogue" then
            AcceptQuestUsingDB(3119); Log("Accepting: [1]Encrypted Sigil");
        elseif GetPlayerClass() == "Priest" then
            AcceptQuestUsingDB(3118); Log("Accepting: [1]Hallowed Sigil");
        elseif GetPlayerClass() == "Warrior" then
            AcceptQuestUsingDB(3117); Log("Accepting: [1]Simple Sigil");
        elseif GetPlayerClass() == "Hunter" then
            AcceptQuestUsingDB(3116); Log("Accepting: [1]Etched Sigil");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Woodland Protector Chain
        Log("Step 1-3: Woodland Protector Chain");
        TurnInQuestUsingDB(458); Log("Turn-in: [1]The Woodland Protector");
        AcceptQuestUsingDB(459); Log("Accepting: [3]The Woodland Protector");
        AcceptQuestUsingDB(916); Log("Accepting: [4]A Good Friend");
        AcceptQuestUsingDB(917); Log("Accepting: [4]A Friend in Need");
        CompleteObjectiveOfQuest(459,1); Log("Completing Objective: [3]The Woodland Protector - Collect 6 Fel Moss");
        CompleteObjectiveOfQuest(916,1); Log("Completing Objective: [4]A Good Friend - Speak with Iverron");
        TurnInQuestUsingDB(916); Log("Turn-in: [4]A Good Friend");
        AcceptQuestUsingDB(4495); Log("Accepting: [4]A Friend in Need");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: Webwood Collection
        Log("Step 1-4: Webwood Collection");
        AcceptQuestUsingDB(916); Log("Accepting: [4]Webwood Venom");
        CompleteObjectiveOfQuest(916,1); Log("Completing Objective: [4]Webwood Venom - Collect 10 Webwood Venom Sacs");
        TurnInQuestUsingDB(916); Log("Turn-in: [4]Webwood Venom");
        AcceptQuestUsingDB(918); Log("Accepting: [5]Webwood Egg");
        CompleteObjectiveOfQuest(918,1); Log("Completing Objective: [5]Webwood Egg - Retrieve Webwood Egg");
        TurnInQuestUsingDB(918); Log("Turn-in: [5]Webwood Egg");
        AcceptQuestUsingDB(919); Log("Accepting: [5]Tenaron's Summons");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Balance of Nature Completion
        Log("Step 1-5: Balance of Nature Completion");
        CompleteObjectiveOfQuest(457,1); Log("Completing Objective: [3]The Balance of Nature - Kill 7 Mangy Nightsabers");
        CompleteObjectiveOfQuest(457,2); Log("Completing Objective: [3]The Balance of Nature - Kill 4 Thistle Boars");
        TurnInQuestUsingDB(457); Log("Turn-in: [3]The Balance of Nature");
        -- Class quest turn-ins
        if GetPlayerClass() == "Druid" then
            TurnInQuestUsingDB(3120); Log("Turn-in: [1]Verdant Sigil");
        elseif GetPlayerClass() == "Rogue" then
            TurnInQuestUsingDB(3119); Log("Turn-in: [1]Encrypted Sigil");
        elseif GetPlayerClass() == "Priest" then
            TurnInQuestUsingDB(3118); Log("Turn-in: [1]Hallowed Sigil");
            AcceptQuestUsingDB(5622); Log("Accepting: [4]Garments of the Moon");
        elseif GetPlayerClass() == "Warrior" then
            TurnInQuestUsingDB(3117); Log("Turn-in: [1]Simple Sigil");
        elseif GetPlayerClass() == "Hunter" then
            TurnInQuestUsingDB(3116); Log("Turn-in: [1]Etched Sigil");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Antidote and Crown Chain
        Log("Step 1-6: Antidote and Crown Chain");
        CompleteObjectiveOfQuest(4495,1); Log("Completing Objective: [4]A Friend in Need - Collect Hyacinth Mushrooms");
        TurnInQuestUsingDB(4495); Log("Turn-in: [4]A Friend in Need");
        AcceptQuestUsingDB(930); Log("Accepting: [4]Iverron's Antidote");
        TurnInQuestUsingDB(930); Log("Turn-in: [4]Iverron's Antidote");
        TurnInQuestUsingDB(919); Log("Turn-in: [5]Tenaron's Summons");
        AcceptQuestUsingDB(928); Log("Accepting: [5]Crown of the Earth");
        TurnInQuestUsingDB(459); Log("Turn-in: [3]The Woodland Protector");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-7: Crown of the Earth Phase 1
        Log("Step 1-7: Crown of the Earth Phase 1");
        CompleteObjectiveOfQuest(928,1); Log("Completing Objective: [5]Crown of the Earth - Fill Crystal Phial at Moonwell");
        TurnInQuestUsingDB(928); Log("Turn-in: [5]Crown of the Earth");
        AcceptQuestUsingDB(929); Log("Accepting: [5]Crown of the Earth");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-8: Preparation for Dolanaar
        Log("Step 1-8: Preparation for Dolanaar");
        AcceptQuestUsingDB(2159); Log("Accepting: [5]Dolanaar Delivery");
        if(Player.Level < 6) then
            LevelTarget = 6
            Log("Grinding to Level "..LevelTarget.." before leaving Shadowglen.");
            --[1989]Grell,[1998]Young Nightsaber,[1995]Young Thistle Boar
            GrindAndGather(TableToList({1989,1998,1995}),100,TableToFloatArray({10326.4,831.85,1326.4}),false,"LevelCheck",true);
        end
        Training(); Log("Training before leaving Shadowglen");
end --End Shadowglen

--Phase 2: Dolanaar Hub (Levels 6-8)
if not HasPlayerFinishedQuest(997) then
    --Step 2-1: Dolanaar Arrival and Setup
        Log("Phase 2: Dolanaar Hub - Central Operations");
        AcceptQuestUsingDB(488); Log("Accepting: [5]Zenn's Bidding");
        TurnInQuestUsingDB(2159); Log("Turn-in: [5]Dolanaar Delivery");
        GoToNPC(6736,"Innkeeper Keldamyr"); --Set hearthstone
        UseMacro("Gossip01");
        TurnInQuestUsingDB(929); Log("Turn-in: [5]Crown of the Earth");
        AcceptQuestUsingDB(933); Log("Accepting: [6]Crown of the Earth");
        AcceptQuestUsingDB(475); Log("Accepting: [6]A Troubling Breeze");
        AcceptQuestUsingDB(932); Log("Accepting: [6]Twisted Hatred");
        AcceptQuestUsingDB(2438); Log("Accepting: [6]The Emerald Dreamcatcher");
        AcceptQuestUsingDB(997); Log("Accepting: [7]Denalan's Earth");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Profession Training
        Log("Step 2-2: Profession Training");
        AcceptQuestUsingDB(4161); Log("Accepting: [6]Recipe of the Kaldorei");
        -- First Aid and Cooking available here
        if GetPlayerClass() == "Priest" and Player.Level >= 5 then
            CompleteObjectiveOfQuest(5622,1); Log("Completing Objective: [4]Garments of the Moon - Healing objective");
            TurnInQuestUsingDB(5622); Log("Turn-in: [4]Garments of the Moon");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Lake Al'Ameth Operations
        Log("Step 2-3: Lake Al'Ameth Operations");
        TurnInQuestUsingDB(997); Log("Turn-in: [7]Denalan's Earth");
        AcceptQuestUsingDB(918); Log("Accepting: [7]Timberling Seeds");
        AcceptQuestUsingDB(919); Log("Accepting: [7]Timberling Sprouts");
        CompleteObjectiveOfQuest(918,1); Log("Completing Objective: [7]Timberling Seeds - Collect 8 Timberling Seeds");
        CompleteObjectiveOfQuest(919,1); Log("Completing Objective: [7]Timberling Sprouts - Collect 12 Timberling Sprouts");
        TurnInQuestUsingDB(918); Log("Turn-in: [7]Timberling Seeds");
        TurnInQuestUsingDB(919); Log("Turn-in: [7]Timberling Sprouts");
        AcceptQuestUsingDB(927); Log("Accepting: [8]Rellian Greenspyre");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Zenn's Bidding Collection
        Log("Step 2-4: Zenn's Bidding Collection");
        Log("Collecting items for Zenn's Bidding while traveling");
        --[1984]Nightsaber,[2030]Webwood Spider,[1986]Strigid Owl
        GrindAndGather(TableToList({1984,2030,1986}),100,TableToFloatArray({9951.52,636.84,1294.23}),false,"ZennsBidding",true);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Starbreeze Village Operations
        Log("Step 2-5: Starbreeze Village Operations");
        CompleteObjectiveOfQuest(933,1); Log("Completing Objective: [6]Crown of the Earth - Fill Jade Phial at Starbreeze Moonwell");
        TurnInQuestUsingDB(475); Log("Turn-in: [6]A Troubling Breeze");
        AcceptQuestUsingDB(476); Log("Accepting: [7]Gnarlpine Corruption");
        CompleteObjectiveOfQuest(2438,1); Log("Completing Objective: [6]The Emerald Dreamcatcher - Loot Tallonkai's Dresser");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-6: Level 7 Check
        Log("Step 2-6: Level 7 Check");
        if(Player.Level < 7) then
            LevelTarget = 7
            Log("Grinding to Level "..LevelTarget..".");
            --[1984]Nightsaber,[2030]Webwood Spider,[1986]Strigid Owl,[2032]Gnarlpine Defender
            GrindAndGather(TableToList({1984,2030,1986,2032}),150,TableToFloatArray({9855.39,878.20,1294.65}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 7");
end --End Dolanaar Initial

--Phase 3: Quest Completion Phase (Level 7-8)
if not HasPlayerFinishedQuest(488) then
    --Step 3-1: Zenn's Bidding Completion
        Log("Phase 3: Quest Completion Phase");
        TurnInQuestUsingDB(488); Log("Turn-in: [5]Zenn's Bidding");
        AcceptQuestUsingDB(489); Log("Accepting: [6]Seek Redemption!");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: Fel Cone Collection
        Log("Step 3-2: Fel Cone Collection");
        CompleteObjectiveOfQuest(489,1); Log("Completing Objective: [6]Seek Redemption! - Collect 3 Fel Cones");
        TurnInQuestUsingDB(489); Log("Turn-in: [6]Seek Redemption!");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Twisted Hatred Quest
        Log("Step 3-3: Twisted Hatred Quest");
        CompleteObjectiveOfQuest(932,1); Log("Completing Objective: [6]Twisted Hatred - Kill Lord Melenas");
        TurnInQuestUsingDB(932); Log("Turn-in: [6]Twisted Hatred");
        AcceptQuestUsingDB(2499); Log("Accepting: [8]The Relics of Wakening");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Dolanaar Return and Quest Turn-ins
        Log("Step 3-4: Dolanaar Return and Quest Turn-ins");
        TurnInQuestUsingDB(476); Log("Turn-in: [7]Gnarlpine Corruption");
        TurnInQuestUsingDB(2438); Log("Turn-in: [6]The Emerald Dreamcatcher");
        AcceptQuestUsingDB(2459); Log("Accepting: [8]Ferocitas the Dream Eater");
        TurnInQuestUsingDB(933); Log("Turn-in: [6]Crown of the Earth");
        AcceptQuestUsingDB(7383); Log("Accepting: [8]Crown of the Earth");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Small Spider Legs Collection
        Log("Step 3-5: Small Spider Legs Collection");
        if ItemCount("Small Spider Leg") >= 7 then
            TurnInQuestUsingDB(4161); Log("Turn-in: [6]Recipe of the Kaldorei");
        else
            Log("Collecting Small Spider Legs for cooking quest");
            --[1986]Strigid Owl,[2030]Webwood Spider
            GrindAndGather(TableToList({1986,2030}),100,TableToFloatArray({9951.52,636.84,1294.23}),false,"SmallSpiderLegs",true);
            TurnInQuestUsingDB(4161); Log("Turn-in: [6]Recipe of the Kaldorei");
        end
end --End Quest Completion

--Phase 4: Ban'ethil Barrow Den (Level 8-9) - Optional Elite Content
if not HasPlayerFinishedQuest(2499) then
    --Step 4-1: Road to Darnassus
        Log("Phase 4: Ban'ethil Barrow Den - Elite Content");
        AcceptQuestUsingDB(487); Log("Accepting: [8]The Road to Darnassus");
        CompleteObjectiveOfQuest(487,1); Log("Completing Objective: [8]The Road to Darnassus - Kill 6 Gnarlpine Ambushers");
        TurnInQuestUsingDB(487); Log("Turn-in: [8]The Road to Darnassus");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Ferocitas the Dream Eater
        Log("Step 4-2: Ferocitas the Dream Eater");
        CompleteObjectiveOfQuest(2459,1); Log("Completing Objective: [8]Ferocitas the Dream Eater - Kill 7 Gnarlpine Mystics");
        CompleteObjectiveOfQuest(2459,2); Log("Completing Objective: [8]Ferocitas the Dream Eater - Kill Ferocitas the Dream Eater");
        TurnInQuestUsingDB(2459); Log("Turn-in: [8]Ferocitas the Dream Eater");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: Ban'ethil Barrow Den (Optional)
        Log("Step 4-3: Ban'ethil Barrow Den (Optional)");
        if EliteQuests == "true" then
            if IsHardCore == "true" then
                PopMessage("Ban'ethil Barrow Den has elite furbolgs - very dangerous! Consider skipping or getting help.");
            end
            AcceptQuestUsingDB(2518); Log("Accepting: [9]The Sleeping Druid");
            CompleteObjectiveOfQuest(2499,1); Log("Completing Objective: [8]The Relics of Wakening - Collect Rune of Nesting");
            CompleteObjectiveOfQuest(2499,2); Log("Completing Objective: [8]The Relics of Wakening - Collect Black Feather Quill");
            CompleteObjectiveOfQuest(2499,3); Log("Completing Objective: [8]The Relics of Wakening - Collect Sapphire of Sky");
            CompleteObjectiveOfQuest(2499,4); Log("Completing Objective: [8]The Relics of Wakening - Collect Raven Claw Talisman");
            CompleteObjectiveOfQuest(2518,1); Log("Completing Objective: [9]The Sleeping Druid - Collect Shaman Voodoo Charm");
            TurnInQuestUsingDB(2518); Log("Turn-in: [9]The Sleeping Druid");
            AcceptQuestUsingDB(2520); Log("Accepting: [10]Druid of the Claw");
            CompleteObjectiveOfQuest(2520,1); Log("Completing Objective: [10]Druid of the Claw - Use Voodoo Charm on Rageclaw");
            TurnInQuestUsingDB(2520); Log("Turn-in: [10]Druid of the Claw");
            TurnInQuestUsingDB(2499); Log("Turn-in: [8]The Relics of Wakening");
            AcceptQuestUsingDB(2500); Log("Accepting: [9]Ursal the Mauler");
        else
            Log("Elite Quests disabled - skipping Barrow Den");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Level 8 Check
        Log("Step 4-4: Level 8 Check");
        if(Player.Level < 8) then
            LevelTarget = 8
            Log("Grinding to Level "..LevelTarget..".");
            --[2032]Gnarlpine Defender,[2022]Gnarlpine Warrior,[2025]Gnarlpine Mystic
            GrindAndGather(TableToList({2032,2022,2025}),150,TableToFloatArray({9460.21,1534.85,1255.38}),false,"LevelCheck",true);
        end
end --End Barrow Den

--Phase 5: Oracle Glade and Western Teldrassil (Level 9-10)
if not HasPlayerFinishedQuest(7383) then
    --Step 5-1: Crown of the Earth - Pools of Arlithrien
        Log("Phase 5: Oracle Glade and Western Teldrassil");
        CompleteObjectiveOfQuest(7383,1); Log("Completing Objective: [8]Crown of the Earth - Fill Tourmaline Phial at Pools of Arlithrien");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: Oracle Glade Setup
        Log("Step 5-2: Oracle Glade Setup");
        AcceptQuestUsingDB(937); Log("Accepting: [9]The Enchanted Glade");
        CompleteObjectiveOfQuest(937,1); Log("Completing Objective: [9]The Enchanted Glade - Fill Amethyst Phial at Oracle Glade Moonwell");
        AcceptQuestUsingDB(938); Log("Accepting: [10]Mist");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: Optional Elite Content - Ursal the Mauler
        Log("Step 5-3: Optional Elite Content - Ursal the Mauler");
        if EliteQuests == "true" and HasPlayerFinishedQuest(2499) then
            CompleteObjectiveOfQuest(2500,1); Log("Completing Objective: [9]Ursal the Mauler - Kill Ursal the Mauler");
            TurnInQuestUsingDB(2500); Log("Turn-in: [9]Ursal the Mauler");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Timberling Operations
        Log("Step 5-4: Timberling Operations");
        AcceptQuestUsingDB(2439); Log("Accepting: [9]The Glowing Fruit");
        AcceptQuestUsingDB(2382); Log("Accepting: [9]Tears of the Moon");
        AcceptQuestUsingDB(2381); Log("Accepting: [9]The Emerald Dreamcatcher");
        AcceptQuestUsingDB(2458); Log("Accepting: [9]Tumors");
        CompleteObjectiveOfQuest(2439,1); Log("Completing Objective: [9]The Glowing Fruit - Collect Glowing Fruit");
        CompleteObjectiveOfQuest(2382,1); Log("Completing Objective: [9]Tears of the Moon - Kill Lady Sathrah");
        CompleteObjectiveOfQuest(2458,1); Log("Completing Objective: [9]Tumors - Collect 5 Timberling Tumors");
        -- Optional rare mob
        if HasItem("Mossy Tumor") then
            AcceptQuestUsingDB(2460); Log("Accepting: [9]The Moss-twined Heart");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-5: Level 9 Check
        Log("Step 5-5: Level 9 Check");
        if(Player.Level < 9) then
            LevelTarget = 9
            Log("Grinding to Level "..LevelTarget..".");
            --[2029]Timberling,[2027]Timberling Mire Beast,[2028]Timberling Bark Ripper
            GrindAndGather(TableToList({2029,2027,2028}),200,TableToFloatArray({8553.94,1661.97,1324.46}),false,"LevelCheck",true);
        end
end --End Oracle Glade

--Phase 6: Darnassus and Mist Escort (Level 9-10)
if not HasPlayerFinishedQuest(938) then
    --Step 6-1: Darnassus Visit
        Log("Phase 6: Darnassus and Final Preparations");
        TurnInQuestUsingDB(927); Log("Turn-in: [8]Rellian Greenspyre");
        AcceptQuestUsingDB(928); Log("Accepting: [8]Tumors");
        AcceptQuestUsingDB(940); Log("Accepting: [8]Teldrassil: The Burden of the Kaldorei");
        -- Get Darnassus flight path
        GoToNPC(3838,"Vesprystus"); --Get flight path
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Mist Escort Quest
        Log("Step 6-2: Mist Escort Quest");
        if IsHardCore == "true" then
            PopMessage("Mist escort quest ahead - protect the nightsaber carefully!");
        end
        CompleteObjectiveOfQuest(938,1); Log("Completing Objective: [10]Mist - Escort Mist to Oracle Glade");
        TurnInQuestUsingDB(938); Log("Turn-in: [10]Mist");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: Level 10 Class Quests
        Log("Step 6-3: Level 10 Class Quests");
        if Player.Level >= 10 then
            Training(); Log("Training Level 10 Abilities");
            if GetPlayerClass() == "Druid" then
                AcceptQuestUsingDB(26); Log("Accepting: [10]A Lesson to Learn");
            elseif GetPlayerClass() == "Hunter" then
                AcceptQuestUsingDB(6063); Log("Accepting: [10]Taming the Beast");
            elseif GetPlayerClass() == "Priest" then
                AcceptQuestUsingDB(5635); Log("Accepting: [10]The Temple of the Moon");
            elseif GetPlayerClass() == "Warrior" then
                AcceptQuestUsingDB(1684); Log("Accepting: [10]Elanaria");
            elseif GetPlayerClass() == "Rogue" then
                AcceptQuestUsingDB(2259); Log("Accepting: [10]Speak with Anselm");
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Final Quest Turn-ins
        Log("Step 6-4: Final Quest Turn-ins");
        TurnInQuestUsingDB(7383); Log("Turn-in: [8]Crown of the Earth");
        AcceptQuestUsingDB(935); Log("Accepting: [10]Crown of the Earth");
        TurnInQuestUsingDB(2439); Log("Turn-in: [9]The Glowing Fruit");
        TurnInQuestUsingDB(2382); Log("Turn-in: [9]Tears of the Moon");
        TurnInQuestUsingDB(2458); Log("Turn-in: [9]Tumors");
        if HasPlayerFinishedQuest(2460) then
            TurnInQuestUsingDB(2460); Log("Turn-in: [9]The Moss-twined Heart");
        end
end --End Darnassus

--Phase 7: Final Zone Completion (Level 10-12)
if not HasPlayerFinishedQuest(935) then
    --Step 7-1: Crown of the Earth Finale
        Log("Phase 7: Final Zone Completion");
        CompleteObjectiveOfQuest(935,1); Log("Completing Objective: [10]Crown of the Earth - Use Filled Vessel at Teldrassil");
        TurnInQuestUsingDB(935); Log("Turn-in: [10]Crown of the Earth");
        AcceptQuestUsingDB(2242); Log("Accepting: [10]The Shimmering Frond");
        AcceptQuestUsingDB(940); Log("Accepting: [10]Teldrassil: The Burden of the Kaldorei");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Corruption Cleansing
        Log("Step 7-2: Corruption Cleansing");
        CompleteObjectiveOfQuest(2242,1); Log("Completing Objective: [10]The Shimmering Frond - Kill Oakenscowl");
        TurnInQuestUsingDB(2242); Log("Turn-in: [10]The Shimmering Frond");
        AcceptQuestUsingDB(929); Log("Accepting: [11]Flute of Xavaric");
        CompleteObjectiveOfQuest(929,1); Log("Completing Objective: [11]Flute of Xavaric - Use Flute to summon Xavaric");
        CompleteObjectiveOfQuest(929,2); Log("Completing Objective: [11]Flute of Xavaric - Kill Xavaric");
        TurnInQuestUsingDB(929); Log("Turn-in: [11]Flute of Xavaric");
        AcceptQuestUsingDB(2258); Log("Accepting: [11]Cleansing of the Infected");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: Final Corruption Source
        Log("Step 7-3: Final Corruption Source");
        CompleteObjectiveOfQuest(2258,1); Log("Completing Objective: [11]Cleansing of the Infected - Destroy Teldrassil Bough of Corruption");
        TurnInQuestUsingDB(2258); Log("Turn-in: [11]Cleansing of the Infected");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Darkshore Preparation
        Log("Step 7-4: Darkshore Preparation");
        AcceptQuestUsingDB(6344); Log("Accepting: [10]Breaking Waves of Change");
        TurnInQuestUsingDB(940); Log("Turn-in: [10]Teldrassil: The Burden of the Kaldorei");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-5: Final Training and Level Check
        Log("Step 7-5: Final Training and Level Check");
        if(Player.Level < 11) then
            LevelTarget = 11
            Log("Final grind to Level "..LevelTarget.." before leaving Teldrassil.");
            --[2029]Timberling,[2027]Timberling Mire Beast,[2028]Timberling Bark Ripper,[2025]Gnarlpine Mystic
            GrindAndGather(TableToList({2029,2027,2028,2025}),200,TableToFloatArray({8553.94,1661.97,1324.46}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-6: Zone Transition Setup
        Log("Step 7-6: Zone Transition Setup");
        if IsHardCore == "true" then
            PopMessage("Teldrassil complete! Recommended level 10-12 for Darkshore. Take boat from Rut'theran Village.");
        end
        PopMessage("Teldrassil questing complete! Ready for Darkshore at level " .. Player.Level);
        if SafetyGrind == "true" then
            LevelTarget = 12
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Teldrassil");
            --[2029]Timberling,[2027]Timberling Mire Beast,[2028]Timberling Bark Ripper,[2025]Gnarlpine Mystic,[2022]Gnarlpine Warrior
            GrindAndGather(TableToList({2029,2027,2028,2025,2022}),300,TableToFloatArray({8553.94,1661.97,1324.46}),false,"LevelCheck",true);
        end
end --End Teldrassil

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();