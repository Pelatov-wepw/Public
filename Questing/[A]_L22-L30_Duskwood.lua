-- Duskwood Questing Profile (20-30)
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
LevelTarget = 20
function LevelCheck()
    if Player.Level >= LevelTarget then
        return false
    else
        return true
    end
end
function NightWatchParts()
    if ItemCount("Skeleton Finger") >= 10 and ItemCount("Zombie Skin") >= 10 then
        return false
    elseif HasPlayerFinishedQuest(57) then
        return false
    else
        return true
    end
end
function GhoulParts()
    if ItemCount("Ghoul Fang") >= 10 and ItemCount("Ghoul Rib") >= 5 then
        return false
    elseif HasPlayerFinishedQuest(101) and HasPlayerFinishedQuest(148) then
        return false
    else
        return true
    end
end
function WorgenFurs()
    if ItemCount("Black Ravager Pelt") >= 5 and ItemCount("Nightbane Shadow Weaver Mane") >= 5 then
        return false
    elseif HasPlayerFinishedQuest(221) then
        return false
    else
        return true
    end
end
function SpiderSilk()
    if ItemCount("Spider Silk") >= 15 then
        return false
    elseif HasPlayerFinishedQuest(93) then
        return false
    else
        return true
    end
end

--Phase 1: Darkshire Arrival and Setup (Levels 20-22)
if not HasPlayerFinishedQuest(131) then
    --Step 1-1: Darkshire Arrival and Registration
        Log("Phase 1: Darkshire Arrival and Setup");
        TurnInQuestUsingDB(131); Log("Turn-in: [17]Messenger to Darkshire");
        GetFlightPath(); Log("Getting Darkshire flight path");
        GoToNPC(6738,"Innkeeper Trelayne"); --Set hearthstone
        UseMacro("Gossip01");
        SleepPlugin(2000);
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-2: Initial Quest Collection
        Log("Step 1-2: Initial Quest Collection");
        AcceptQuestUsingDB(58); Log("Accepting: [20]Raven Hill");
        AcceptQuestUsingDB(149); Log("Accepting: [20]Jitters' Growling Gut");
        AcceptQuestUsingDB(93); Log("Accepting: [20]Dusky Crab Cakes");
        AcceptQuestUsingDB(57); Log("Accepting: [24]The Night Watch");
        AcceptQuestUsingDB(165); Log("Accepting: [21]The Hermit");
        AcceptQuestUsingDB(253); Log("Accepting: [25]Bride of the Embalmer");
        AcceptQuestUsingDB(337); Log("Accepting: [25]An Old History Book");
        AcceptQuestUsingDB(221); Log("Accepting: [22]Worgen in the Woods");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-3: Eight Legged Menaces
        Log("Step 1-3: Eight Legged Menaces");
        AcceptQuestUsingDB(93); Log("Accepting: [18]Eight Legged Menaces");
        Log("Starting spider elimination for silk collection");
        --[930]Black Widow Hatchling,[217]Venom Web Spider,[1009]Mosshide Gnoll
        GrindAndGather(TableToList({930,217,1009}),100,TableToFloatArray({-10456.2,1324.8,41.2}),false,"SpiderSilk",true);
        TurnInQuestUsingDB(93); Log("Turn-in: [18]Eight Legged Menaces");
        AcceptQuestUsingDB(154); Log("Accepting: [20]Return to Jitters");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-4: The Hermit Chain
        Log("Step 1-4: The Hermit Chain");
        TurnInQuestUsingDB(165); Log("Turn-in: [21]The Hermit");
        AcceptQuestUsingDB(148); Log("Accepting: [21]Supplies from Darkshire");
        TurnInQuestUsingDB(148); Log("Turn-in: [21]Supplies from Darkshire");
        AcceptQuestUsingDB(149); Log("Accepting: [21]Ghost Hair Thread");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-5: Raven Hill Introduction
        Log("Step 1-5: Raven Hill Introduction");
        TurnInQuestUsingDB(58); Log("Turn-in: [20]Raven Hill");
        TurnInQuestUsingDB(154); Log("Turn-in: [20]Return to Jitters");
        AcceptQuestUsingDB(5); Log("Accepting: [22]Juice Delivery");
        AcceptQuestUsingDB(163); Log("Accepting: [30]Raven Hill");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 1-6: Level 22 Check and Training
        Log("Step 1-6: Level 22 Check and Training");
        if(Player.Level < 22) then
            LevelTarget = 22
            Log("Grinding to Level "..LevelTarget..".");
            --[930]Black Widow Hatchling,[217]Venom Web Spider,[1009]Mosshide Gnoll
            GrindAndGather(TableToList({930,217,1009}),150,TableToFloatArray({-10456.2,1324.8,41.2}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 22");
end --End Initial Setup

--Phase 2: Night Watch Operations (Level 22-24)
if not HasPlayerFinishedQuest(57) then
    --Step 2-1: The Night Watch Campaign
        Log("Phase 2: Night Watch Operations");
        Log("Starting Night Watch skeleton elimination");
        --[531]Skeletal Fiend,[202]Skeletal Horror,[1110]Skeletal Raider
        GrindAndGather(TableToList({531,202,1110}),100,TableToFloatArray({-10948.2,1554.8,42.8}),false,"NightWatchParts",true);
        TurnInQuestUsingDB(57); Log("Turn-in: [24]The Night Watch");
        AcceptQuestUsingDB(58); Log("Accepting: [26]The Night Watch");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-2: Ghost Hair Thread Collection
        Log("Step 2-2: Ghost Hair Thread Collection");
        CompleteObjectiveOfQuest(149,1); Log("Completing Objective: [21]Ghost Hair Thread - Collect Ghost Hair Thread");
        TurnInQuestUsingDB(149); Log("Turn-in: [21]Ghost Hair Thread");
        AcceptQuestUsingDB(154); Log("Accepting: [21]Return the Comb");
        TurnInQuestUsingDB(154); Log("Turn-in: [21]Return the Comb");
        AcceptQuestUsingDB(157); Log("Accepting: [21]Deliver the Thread");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-3: Zombie Juice Collection
        Log("Step 2-3: Zombie Juice Collection");
        TurnInQuestUsingDB(157); Log("Turn-in: [21]Deliver the Thread");
        AcceptQuestUsingDB(158); Log("Accepting: [21]Zombie Juice");
        Log("Collecting ghoul parts for Abercrombie");
        --[1270]Fetid Corpse,[570]Brain Eater,[217]Rotting Corpse
        GrindAndGather(TableToList({1270,570,217}),100,TableToFloatArray({-10523.8,1881.2,38.5}),false,"GhoulParts",true);
        TurnInQuestUsingDB(158); Log("Turn-in: [21]Zombie Juice");
        AcceptQuestUsingDB(149); Log("Accepting: [22]Gather Rot Blossoms");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-4: Juice Delivery
        Log("Step 2-4: Juice Delivery");
        TurnInQuestUsingDB(5); Log("Turn-in: [22]Juice Delivery");
        AcceptQuestUsingDB(93); Log("Accepting: [22]Ghoulish Effigy");
        CompleteObjectiveOfQuest(93,1); Log("Completing Objective: [22]Ghoulish Effigy - Create Ghoulish Effigy");
        TurnInQuestUsingDB(93); Log("Turn-in: [22]Ghoulish Effigy");
        AcceptQuestUsingDB(7); Log("Accepting: [22]Ogre Thieves");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 2-5: Ogre Thieves
        Log("Step 2-5: Ogre Thieves");
        CompleteObjectiveOfQuest(7,1); Log("Completing Objective: [22]Ogre Thieves - Retrieve Abercrombie's Crate");
        TurnInQuestUsingDB(7); Log("Turn-in: [22]Ogre Thieves");
        AcceptQuestUsingDB(101); Log("Accepting: [22]Note to the Mayor");
end --End Night Watch

--Phase 3: Worgen and Darkshore Beasts (Level 24-26)
if not HasPlayerFinishedQuest(221) then
    --Step 3-1: Worgen in the Woods
        Log("Phase 3: Worgen and Darkshore Beasts");
        Log("Starting worgen elimination campaign");
        --[533]Nightbane Dark Runner,[205]Nightbane Shadow Weaver,[892]Nightbane Vile Fang
        GrindAndGather(TableToList({533,205,892}),100,TableToFloatArray({-10223.8,1632.4,39.8}),false,"WorgenFurs",true);
        TurnInQuestUsingDB(221); Log("Turn-in: [22]Worgen in the Woods");
        AcceptQuestUsingDB(222); Log("Accepting: [24]Worgen in the Woods");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-2: Note to the Mayor
        Log("Step 3-2: Note to the Mayor");
        TurnInQuestUsingDB(101); Log("Turn-in: [22]Note to the Mayor");
        AcceptQuestUsingDB(102); Log("Accepting: [22]Translate Abercrombie's Note");
        TurnInQuestUsingDB(102); Log("Turn-in: [22]Translate Abercrombie's Note");
        AcceptQuestUsingDB(103); Log("Accepting: [22]Wait for Sirra to Finish");
        TurnInQuestUsingDB(103); Log("Turn-in: [22]Wait for Sirra to Finish");
        AcceptQuestUsingDB(104); Log("Accepting: [22]Translation to Ello");
        TurnInQuestUsingDB(104); Log("Turn-in: [22]Translation to Ello");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-3: Gather Rot Blossoms
        Log("Step 3-3: Gather Rot Blossoms");
        CompleteObjectiveOfQuest(149,1); Log("Completing Objective: [22]Gather Rot Blossoms - Collect 8 Rot Blossoms");
        TurnInQuestUsingDB(149); Log("Turn-in: [22]Gather Rot Blossoms");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-4: Dusky Crab Cakes
        Log("Step 3-4: Dusky Crab Cakes");
        if HasPlayerFinishedQuest(93) then
            CompleteObjectiveOfQuest(93,1); Log("Completing Objective: [20]Dusky Crab Cakes - Collect 8 Dusky Crab Cakes");
            TurnInQuestUsingDB(93); Log("Turn-in: [20]Dusky Crab Cakes");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 3-5: Level 25 Check
        Log("Step 3-5: Level 25 Check");
        if(Player.Level < 25) then
            LevelTarget = 25
            Log("Grinding to Level "..LevelTarget..".");
            --[533]Nightbane Dark Runner,[205]Nightbane Shadow Weaver,[892]Nightbane Vile Fang
            GrindAndGather(TableToList({533,205,892}),200,TableToFloatArray({-10223.8,1632.4,39.8}),false,"LevelCheck",true);
        end
        Training(); Log("Training at Level 25");
end --End Worgen Phase

--Phase 4: The Legend of Stalvan (Level 25-27)
if not HasPlayerFinishedQuest(74) then
    --Step 4-1: The Legend of Stalvan Chain
        Log("Phase 4: The Legend of Stalvan");
        AcceptQuestUsingDB(74); Log("Accepting: [25]The Legend of Stalvan");
        CompleteObjectiveOfQuest(74,1); Log("Completing Objective: [25]The Legend of Stalvan - Investigate Stalvan");
        TurnInQuestUsingDB(74); Log("Turn-in: [25]The Legend of Stalvan");
        AcceptQuestUsingDB(75); Log("Accepting: [27]The Legend of Stalvan");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-2: Stalvan Investigation
        Log("Step 4-2: Stalvan Investigation");
        CompleteObjectiveOfQuest(75,1); Log("Completing Objective: [27]The Legend of Stalvan - Read Stalvan's Journal");
        TurnInQuestUsingDB(75); Log("Turn-in: [27]The Legend of Stalvan");
        AcceptQuestUsingDB(78); Log("Accepting: [30]The Legend of Stalvan");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-3: The Shadowy Figure
        Log("Step 4-3: The Shadowy Figure");
        AcceptQuestUsingDB(55); Log("Accepting: [25]The Shadowy Figure");
        CompleteObjectiveOfQuest(55,1); Log("Completing Objective: [25]The Shadowy Figure - Find the Shadowy Figure");
        TurnInQuestUsingDB(55); Log("Turn-in: [25]The Shadowy Figure");
        AcceptQuestUsingDB(56); Log("Accepting: [27]The Shadowy Search Continues");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-4: Inquire at the Inn
        Log("Step 4-4: Inquire at the Inn");
        TurnInQuestUsingDB(56); Log("Turn-in: [27]The Shadowy Search Continues");
        AcceptQuestUsingDB(52); Log("Accepting: [30]Inquire at the Inn");
        TurnInQuestUsingDB(52); Log("Turn-in: [30]Inquire at the Inn");
        AcceptQuestUsingDB(53); Log("Accepting: [30]Finding the Shadowy Figure");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 4-5: The Daughter Who Lived
        Log("Step 4-5: The Daughter Who Lived");
        AcceptQuestUsingDB(231); Log("Accepting: [28]The Daughter Who Lived");
        CompleteObjectiveOfQuest(231,1); Log("Completing Objective: [28]The Daughter Who Lived - Learn about Sarah Ladimore");
        TurnInQuestUsingDB(231); Log("Turn-in: [28]The Daughter Who Lived");
        AcceptQuestUsingDB(1); Log("Accepting: [30]A Daughter's Love");
end --End Stalvan Chain

--Phase 5: Look to the Stars (Level 26-28)
if not HasPlayerFinishedQuest(174) then
    --Step 5-1: Look to the Stars Chain
        Log("Phase 5: Look to the Stars");
        AcceptQuestUsingDB(174); Log("Accepting: [25]Look to the Stars");
        CompleteObjectiveOfQuest(174,1); Log("Completing Objective: [25]Look to the Stars - Collect Ogre's Monocle");
        TurnInQuestUsingDB(174); Log("Turn-in: [25]Look to the Stars");
        AcceptQuestUsingDB(175); Log("Accepting: [25]Look to the Stars");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-2: Star Chart Collection
        Log("Step 5-2: Star Chart Collection");
        CompleteObjectiveOfQuest(175,1); Log("Completing Objective: [25]Look to the Stars - Collect Tarot of Elemental Bindings");
        TurnInQuestUsingDB(175); Log("Turn-in: [25]Look to the Stars");
        AcceptQuestUsingDB(177); Log("Accepting: [25]Look to the Stars");
        CompleteObjectiveOfQuest(177,1); Log("Completing Objective: [25]Look to the Stars - Collect Star Chart");
        TurnInQuestUsingDB(177); Log("Turn-in: [25]Look to the Stars");
        AcceptQuestUsingDB(181); Log("Accepting: [30]Look to the Stars");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-3: Zzarc'Vul Confrontation
        Log("Step 5-3: Zzarc'Vul Confrontation");
        if EliteQuests == "true" then
            if IsHardCore == "true" then
                PopMessage("Zzarc'Vul is a level 34 elite ogre! Consider getting help.");
            end
            CompleteObjectiveOfQuest(181,1); Log("Completing Objective: [30]Look to the Stars - Kill Zzarc'Vul");
            TurnInQuestUsingDB(181); Log("Turn-in: [30]Look to the Stars");
        else
            Log("Elite Quests disabled - skipping Zzarc'Vul");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 5-4: Level 27 Check
        Log("Step 5-4: Level 27 Check");
        if(Player.Level < 27) then
            LevelTarget = 27
            Log("Grinding to Level "..LevelTarget..".");
            --[533]Nightbane Dark Runner,[205]Nightbane Shadow Weaver,[892]Nightbane Vile Fang
            GrindAndGather(TableToList({533,205,892}),250,TableToFloatArray({-10223.8,1632.4,39.8}),false,"LevelCheck",true);
        end
end --End Look to the Stars

--Phase 6: Elite Quest Chains (Level 27-29)
if not HasPlayerFinishedQuest(228) then
    --Step 6-1: Morbent Fel Chain
        Log("Phase 6: Elite Quest Chains");
        if EliteQuests == "true" then
            AcceptQuestUsingDB(55); Log("Accepting: [25]Armed and Ready");
            CompleteObjectiveOfQuest(55,1); Log("Completing Objective: [25]Armed and Ready - Get Lightforge Ingot");
            TurnInQuestUsingDB(55); Log("Turn-in: [25]Armed and Ready");
            AcceptQuestUsingDB(228); Log("Accepting: [32]Morbent Fel");
            if IsHardCore == "true" then
                PopMessage("Morbent Fel is a level 32 elite necromancer! Get a group for safety!");
            end
            CompleteObjectiveOfQuest(228,1); Log("Completing Objective: [32]Morbent Fel - Kill Morbent Fel");
            TurnInQuestUsingDB(228); Log("Turn-in: [32]Morbent Fel");
        else
            Log("Elite Quests disabled - skipping Morbent Fel");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-2: Mor'Ladim Chain
        Log("Step 6-2: Mor'Ladim Chain");
        if EliteQuests == "true" then
            AcceptQuestUsingDB(229); Log("Accepting: [30]Mor'Ladim");
            if IsHardCore == "true" then
                PopMessage("Mor'Ladim is a level 35 elite skeleton! Extremely dangerous!");
            end
            CompleteObjectiveOfQuest(229,1); Log("Completing Objective: [30]Mor'Ladim - Kill Mor'Ladim");
            TurnInQuestUsingDB(229); Log("Turn-in: [30]Mor'Ladim");
            AcceptQuestUsingDB(231); Log("Accepting: [30]The Daughter Who Lived");
        else
            Log("Elite Quests disabled - skipping Mor'Ladim");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-3: The Night Watch Finale
        Log("Step 6-3: The Night Watch Finale");
        if HasPlayerFinishedQuest(58) then
            CompleteObjectiveOfQuest(58,1); Log("Completing Objective: [26]The Night Watch - Kill 15 Plague Spreaders");
            TurnInQuestUsingDB(58); Log("Turn-in: [26]The Night Watch");
            AcceptQuestUsingDB(59); Log("Accepting: [30]The Night Watch");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-4: Bride of the Embalmer
        Log("Step 6-4: Bride of the Embalmer");
        if EliteQuests == "true" and HasPlayerFinishedQuest(253) then
            if IsHardCore == "true" then
                PopMessage("Bride of the Embalmer involves elite enemies! Get help!");
            end
            CompleteObjectiveOfQuest(253,1); Log("Completing Objective: [25]Bride of the Embalmer - Kill Eliza");
            TurnInQuestUsingDB(253); Log("Turn-in: [25]Bride of the Embalmer");
        else
            Log("Elite Quests disabled or not available - skipping Bride");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 6-5: Training Session
        Log("Step 6-5: Training Session");
        Training(); Log("Training at Level 27+");
end --End Elite Chains

--Phase 7: Stalvan Finale and Final Operations (Level 28-30)
if not HasPlayerFinishedQuest(78) then
    --Step 7-1: Stalvan Confrontation
        Log("Phase 7: Stalvan Finale and Final Operations");
        if EliteQuests == "true" and HasPlayerFinishedQuest(78) then
            if IsHardCore == "true" then
                PopMessage("Stalvan is a level 35 non-elite but very tough! Be careful!");
            end
            CompleteObjectiveOfQuest(78,1); Log("Completing Objective: [30]The Legend of Stalvan - Kill Stalvan");
            TurnInQuestUsingDB(78); Log("Turn-in: [30]The Legend of Stalvan");
        else
            Log("Elite Quests disabled or not ready - skipping Stalvan");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-2: Finding the Shadowy Figure
        Log("Step 7-2: Finding the Shadowy Figure");
        if HasPlayerFinishedQuest(53) then
            TurnInQuestUsingDB(53); Log("Turn-in: [30]Finding the Shadowy Figure");
            AcceptQuestUsingDB(54); Log("Accepting: [30]Return to Sven");
            TurnInQuestUsingDB(54); Log("Turn-in: [30]Return to Sven");
            AcceptQuestUsingDB(55); Log("Accepting: [30]Proving Your Worth");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-3: A Daughter's Love
        Log("Step 7-3: A Daughter's Love");
        if HasPlayerFinishedQuest(1) then
            CompleteObjectiveOfQuest(1,1); Log("Completing Objective: [30]A Daughter's Love - Place Sarah's Ring");
            TurnInQuestUsingDB(1); Log("Turn-in: [30]A Daughter's Love");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-4: Worgen in the Woods Finale
        Log("Step 7-4: Worgen in the Woods Finale");
        if HasPlayerFinishedQuest(222) then
            CompleteObjectiveOfQuest(222,1); Log("Completing Objective: [24]Worgen in the Woods - Kill Gutspill");
            TurnInQuestUsingDB(222); Log("Turn-in: [24]Worgen in the Woods");
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 7-5: An Old History Book
        Log("Step 7-5: An Old History Book");
        if HasPlayerFinishedQuest(337) then
            TurnInQuestUsingDB(337); Log("Turn-in: [25]An Old History Book");
            AcceptQuestUsingDB(538); Log("Accepting: [30]Southshore");
        end
end --End Final Operations

--Phase 8: Zone Completion and Transition (Level 29-30)
if Player.Level >= 28 then
    --Step 8-1: Final Level Check
        Log("Phase 8: Zone Completion and Transition");
        if(Player.Level < 30) then
            LevelTarget = 30
            Log("Final grind to Level "..LevelTarget.." before leaving Duskwood.");
            --[533]Nightbane Dark Runner,[205]Nightbane Shadow Weaver,[892]Nightbane Vile Fang,[531]Skeletal Fiend
            GrindAndGather(TableToList({533,205,892,531}),300,TableToFloatArray({-10223.8,1632.4,39.8}),false,"LevelCheck",true);
        end
        Training(); Log("Final Training Session");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-2: Class-Specific Level 30 Quests
        Log("Step 8-2: Class-Specific Level 30 Quests");
        if Player.Level >= 30 then
            if GetPlayerClass() == "Warrior" then
                AcceptQuestUsingDB(1718); Log("Accepting: [30]The Cyclonian");
            elseif GetPlayerClass() == "Paladin" then
                AcceptQuestUsingDB(1661); Log("Accepting: [30]The Test of Righteousness");
            elseif GetPlayerClass() == "Hunter" then
                AcceptQuestUsingDB(6102); Log("Accepting: [30]The Pledge of Secrecy");
            elseif GetPlayerClass() == "Rogue" then
                AcceptQuestUsingDB(2359); Log("Accepting: [30]Klaven's Tower");
            elseif GetPlayerClass() == "Priest" then
                AcceptQuestUsingDB(5635); Log("Accepting: [30]Blessing of Elune");
            elseif GetPlayerClass() == "Mage" then
                AcceptQuestUsingDB(1860); Log("Accepting: [30]Magecraft");
            elseif GetPlayerClass() == "Warlock" then
                AcceptQuestUsingDB(1795); Log("Accepting: [30]Components for the Enchanted Gold Bloodrobe");
            end
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-3: Zone Transition Preparation
        Log("Step 8-3: Zone Transition Preparation");
        AcceptQuestUsingDB(1); Log("Accepting: [30]To Stranglethorn!");
        AcceptQuestUsingDB(377); Log("Accepting: [28]Crime and Punishment");
        AcceptQuestUsingDB(393); Log("Accepting: [32]Mazen's Behest");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-4: Safety Grind Option
        Log("Step 8-4: Safety Grind Option");
        if SafetyGrind == "true" then
            LevelTarget = 32
            Log("Safety Grind: Grinding to Level "..LevelTarget.." before leaving Duskwood");
            --[533]Nightbane Dark Runner,[205]Nightbane Shadow Weaver,[892]Nightbane Vile Fang,[531]Skeletal Fiend
            GrindAndGather(TableToList({533,205,892,531}),400,TableToFloatArray({-10223.8,1632.4,39.8}),false,"LevelCheck",true);
        end
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-5: Zone Completion Messages
        Log("Step 8-5: Zone Completion Messages");
        if IsHardCore == "true" then
            PopMessage("Duskwood complete! Recommended level 28-30 for Stranglethorn Vale or Wetlands.");
        end
        PopMessage("Duskwood questing complete! Ready for Stranglethorn Vale (30-45), Wetlands (20-30), or Arathi Highlands (30-40) at level " .. Player.Level);
        PopMessage("Alternative zones: Hillsbrad Foothills (20-30), Thousand Needles (25-35), or Desolace (30-40)");
        ------------------------------------------------------------------
        ------------------------------------------------------------------
        --Step 8-6: Final Recommendations
        Log("Step 8-6: Final Recommendations");
        PopMessage("Recommended next zones based on level:");
        PopMessage("Level 28-30: Wetlands completion or start Stranglethorn Vale");
        PopMessage("Level 30-32: Stranglethorn Vale or Arathi Highlands");
        PopMessage("Level 32+: Continue Stranglethorn Vale or try Desolace/Thousand Needles");
        if EliteQuests == "true" then
            PopMessage("Consider Stockade dungeon runs (22-30) for excellent XP and gear!");
        end
end --End Zone Completion

------------------------------------------------------------------
------------------------------------------------------------------
StopQuestProfile();