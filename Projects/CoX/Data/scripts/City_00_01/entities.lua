--- OUTBREAK

LuaBot = {}
LuaBot.spawned = false;
LuaBot.contactDialogs = {}

LuaBot.contact = Contact.new()
    LuaBot.contact.name = "LuaBot"
    LuaBot.contact.currentStanding = 0
    LuaBot.contact.notifyPlayer = true
    LuaBot.contact.npcId = 1144
    LuaBot.contact.hasLocation = true
    LuaBot.contact.taskIndex = 0
    LuaBot.contact.locationDescription = "Outbreak"
    LuaBot.contact.location = Destination.new()
    LuaBot.contact.location.location = vec3.new(-90, 0, 170)
    LuaBot.contact.location.name = "Outbreak"
    LuaBot.contact.location.mapName =  "Outbreak"
    LuaBot.contact.confidantThreshold = 3
    LuaBot.contact.friendThreshold = 2
    LuaBot.contact.completeThreshold = 4
    LuaBot.contact.canUseCell = false

    LuaBot.task = Task.new()
    LuaBot.task.dbId = 1 -- 1939 - 200
    LuaBot.task.taskIdx = 0
    LuaBot.task.description = "Talk with LuaBot"
    LuaBot.task.owner = "LuaBot"
    LuaBot.task.detail = "LuaBot Task testing detail........<br><br>Accessing.......<br><br>Accessing.......<br><br>Accessing.......Data not found"
    LuaBot.task.state = ""
    LuaBot.task.inProgressMaybe = true
    LuaBot.task.isComplete = false
    LuaBot.task.isAbandoned = false
    LuaBot.task.finishTime = 0
    LuaBot.task.unknownInt1 = 1
    LuaBot.task.unknownInt2 = 1
    LuaBot.task.hasLocation = true
    LuaBot.task.boardTrain = false
    LuaBot.task.location = Destination.new()
    LuaBot.task.location.location = vec3.new(20, 0, 586)
    LuaBot.task.location.name  = "Outbreak"
    LuaBot.task.location.mapName = "Outbreak"


-- Called after MOTD for now.
function player_connected(id)
    --Id is player entity Id
    printDebug('player_connected Id: ' .. tostring(id))

    UpdateTasksForZone('OutBreak')

    --Spawn LuaBot  NPCID = 1144
    if not LuaBot.spawned then
        LuaBot.expected = true
        MapClientSession.addNpc(client, 'Jumpbot_02', vec3.new(-90, 0, 170), 1, 'LuaBot')
    end

    -- Dialogs that use heroName need to wait till a function is called by `callFuncWithClientContext` to update the heroName variable
    LuaBot.contactDialogs[1] = { 
        message = string.format([[<img src="npc:1144" align="left">Hello, {HeroName}.....bzzt.....I mean %s. I am LuaBot. Here to assist you in testing the
                Lua scripting interface.<br><br>Please select an option below to test.]], heroName),
        buttons =  {
            button1 = {"Player Stats","CONTACTLINK_HELLO"},
            button2 = {"Contacts","CONTACTLINK_MAIN"},
            button3 = {"Tasks","CONTACTLINK_MISSIONS"}, -- 4
            button4 = {"MapMenu","CONTACTLINK_LONGMISSION"}, -- 4
            button5 = {"",""} ,
            button6 = {"Leave","CONTACTLINK_BYE"} ,
        }
    }

    LuaBot.contactDialogs[20] = {
        message = [[<img src="npc:1144" align="left"><b>Player Stats</b><br><br>Choose an item below to adjust the corresponding player stat.<br>
                    Don't worry these will not kill you.....permanently.<br>]],
        buttons = {
            button01 = {"Set Hp to 1","CONTACTLINK_HELLO"},
            button02 = {"Set Hp to max","CONTACTLINK_MAIN"},
            button03 = {"Set End to 1","CONTACTLINK_DONTKNOW"},
            button04 = {"Set End to Max","CONTACTLINK_MISSIONS"} ,
            button05 = {"Give 1000 XP","CONTACTLINK_LONGMISSION"} ,
            button06 = {"Give 1000 Debt","CONTACTLINK_SHORTMISSION"} ,
            button07 = {"Give 1000 Inf","CONTACTLINK_ACCEPTLONG"} ,
            button08 = {"Level up/Train","CONTACTLINK_ACCEPTSHORT"} ,
            button09 = {"Reset Stats","CONTACTLINK_INTRODUCE"} ,
            button10 = {"More","CONTACTLINK_NOTLEADER"} ,
            button11 = {"Back","CONTACTLINK_WRONGMODE"} 
        }
    } 

    LuaBot.contactDialogs[21] = {
        message = [[<img src="npc:1144" align="left"><b>Player Stats Page 2</b><br><br>Choose an item below to adjust the corresponding player stat.<br>
                    Don't worry these will not kill you.....permanently.<br>]],
        buttons = {
            button01 = {"Give Random Inspiration","CONTACTLINK_HELLO"},
            button02 = {"Give Random Enhancement","CONTACTLINK_MAIN"},
            button03 = {"Set Title","CONTACTLINK_MISSIONS"},
            button04 = {"Give Temp Power","CONTACTLINK_LONGMISSION"} ,
            --button05 = {"Give 1000 XP","CONTACTLINK_LONGMISSION"} ,
            --button06 = {"Give 1000 Debt","CONTACTLINK_SHORTMISSION"} ,
            --button07 = {"Give 1000 Inf","CONTACTLINK_ACCEPTLONG"} ,
            --button08 = {"Give Random Inspiration","CONTACTLINK_ACCEPTSHORT"} ,
            --button09 = {"Give Random Enhancement","CONTACTLINK_INTRODUCE"} ,
            --button10 = {"Reset Stats","CONTACTLINK_NOTLEADER"} ,
            button11 = {"Back","CONTACTLINK_WRONGMODE"} 
        }
    } 

    LuaBot.contactDialogs[3] = {
        message = [[<img src="npc:1144" align="left"><b>Contacts</b><br><br>Choose an item below to test contacts.<br><br>
                    <color #2189b9>Open the contact list to see the changes.</color>]],
        buttons = {
            button01 = {"Add LuaBot Contact","CONTACTLINK_HELLO"},
            button02 = {"Increase standing","CONTACTLINK_MAIN"},
            button03 = {"Lower standing","CONTACTLINK_MISSIONS"}, 
            button04 = {"Add Call button","CONTACTLINK_LONGMISSION"} ,
            button05 = {"Remove Call button","CONTACTLINK_SHORTMISSION"} ,
            button06 = {"Remove Contact","CONTACTLINK_ACCEPTLONG"} ,
            button07 = {"Back","CONTACTLINK_INTRODUCE"}
        }
    } 

    LuaBot.contactDialogs[4] = {
        message = [[<img src="npc:1144" align="left"><b>Contacts</b><br><br>I'm sorry. Removing contacts is currently not supported.<br><br>
                    Contact reset...<br><br>
                    <color #2189b9>I don't remember ever removing a contact.</color>]],
        buttons = {
            button01 = {"Add LuaBot Contact","CONTACTLINK_HELLO"},
            button02 = {"Increase standing","CONTACTLINK_MAIN"},
            button03 = {"Lower standing","CONTACTLINK_MISSIONS"}, 
            button04 = {"Add Call button","CONTACTLINK_LONGMISSION"} ,
            button05 = {"Remove Call button","CONTACTLINK_SHORTMISSION"} ,
            button06 = {"Remove Contact","CONTACTLINK_ACCEPTLONG"} ,
            button07 = {"Back","CONTACTLINK_INTRODUCE"}
        }
    } 

    LuaBot.contactDialogs[5] = {
        message = [[<img src="npc:1144" align="left"><b>Tasks</b><br><br>Choose an item below to test tasks.<br><br>
                    Tasks require a contact to be listed. I'll add one for you.<br><br>
                    <color #2189b9>Open the tasks list to see some of the changes.</color>]],
        buttons = {
            button01 = {"Add Task","CONTACTLINK_HELLO"},
            button02 = {"Select Task","CONTACTLINK_MAIN"},
            button03 = {"Update Task Name","CONTACTLINK_MISSIONS"}, 
            button04 = {"Set Task to another zone","CONTACTLINK_LONGMISSION"} , -- Test mission complete sounds?
            button05 = {"Complete Task","CONTACTLINK_SHORTMISSION"} ,
            button06 = {"Remove Task","CONTACTLINK_ACCEPTLONG"} ,
            button07 = {"Task to Atlas Park","CONTACTLINK_ACCEPTSHORT"},
            button08 = {"Back","CONTACTLINK_INTRODUCE"}
        }
    } 

   
    
    return  ''
end

function npc_added(id)
    printDebug('npc_added Id: ' .. tostring(id))

    -- Add flags to catch the npc you spawned?
    if LuaBot.expected then
        LuaBot.id = id
        LuaBot.expected = false
        LuaBot.spawned = true
    end

    return ''
end

entity_interact = function(id, location)

    if location ~= nil then
        printDebug("entity id " .. tostring(id) .. " location info:  x: " .. tostring(location.x) .. " y: " .. tostring(location.y) .. " z: " .. tostring(location.z))
    else
        printDebug("entity id " .. tostring(id))
    end

    if (id == LuaBot.id) then
        MapClientSession.contact_dialog(client, LuaBot.contactDialogs[1].message, LuaBot.contactDialogs[1].buttons)
    end

    return ""
end

dialog_button = function(id)
    printDebug("buttonId: " .. tostring(id))

    if (LuaBot.id ~= nil) then
        if(LuaBot.settingTitle) then -- Title selection buttons trigger dialog_button
            LuaBot.settingTitle = false
            LuaBot.Mode = nil
        elseif(LuaBot.Mode == nil) then -- using mode to reuse button Ids
            if (id == 1) then
                printDebug("LuaBot moving to stat mode: " .. tostring(id))
                LuaBot.Mode = 1 -- Player stats
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[20].message, LuaBot.contactDialogs[20].buttons)
                
                local LuaBotMission = FindTaskByTaskIdx(0)
                if(LuaBotMission ~= false) then
                    resetTask()
                end
            elseif (id == 2) then
                printDebug("LuaBot moving to contact mode: " .. tostring(id))
                LuaBot.Mode = 2 -- Contacts
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[3].message, LuaBot.contactDialogs[3].buttons)
            elseif (id == 3) then
                LuaBot.Mode = nil
            elseif (id == 4) then
                printDebug("LuaBot moving to task mode: " .. tostring(id))
                LuaBot.Mode = 4
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[5].message, LuaBot.contactDialogs[5].buttons)
                Player.AddUpdateContact(LuaBot.contact)
            elseif (id == 5) then
                MapClientSession.mapMenu(client)
            end
        elseif (LuaBot.Mode == 1) then
            printDebug("LuaBot in stat mode: " .. tostring(id))
            if (id == 1) then
                Player.SetHp(1)
            elseif (id == 2) then
                Player.GiveHp(99999) -- Should be max
            elseif (id == 3) then
                LuaBot.Mode = nil
            elseif (id == 17) then
                Player.SetEnd(1)
            elseif (id == 4) then
                Player.GiveEnd(100)
            elseif (id == 5) then
                Player.GiveXp(1000)
            elseif (id == 6) then
                Player.GiveDebt(1000)
            elseif (id == 7) then
                Player.GiveInf(1000)
            elseif (id == 8) then
                --Train/Level
                Player.LevelUp()
            elseif (id == 9) then
                --reset stats
                Player.GiveHp(99999)
                Player.GiveEnd(100)
                Player.SetXp(0)
                Player.SetDebt(0)
                Player.SetInf(0)
            elseif (id == 16 or id == 3) then
                -- Back
                LuaBot.Mode = nil
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[1].message, LuaBot.contactDialogs[1].buttons)
            elseif (id == 18) then
                --More 
                LuaBot.Mode = 21
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[21].message, LuaBot.contactDialogs[21].buttons)
            end
        elseif (LuaBot.Mode == 21) then
            if (id == 1) then
                Player.GiveRandomInsp()
            elseif (id == 2) then
                Player.GiveRandomEnhancement(1)
            elseif (id == 3) then
                LuaBot.Mode = nil
            elseif (id == 4) then
                Player.SetTitle("You're a hero!")
                LuaBot.settingTitle = true
            elseif (id == 5) then
                --  Not added
                --Player.GiveTempPower()
            elseif (id == 16 or id == 3) then
                -- Back
                LuaBot.Mode = 1
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[20].message, LuaBot.contactDialogs[20].buttons)
            end

        elseif (LuaBot.Mode == 2) then -- Contacts
            printDebug("LuaBot in contact mode: " .. tostring(id))
            if (id == 1) then
                Player.AddUpdateContact(LuaBot.contact)
            elseif (id == 2) then
                LuaBot.contact.currentStanding = LuaBot.contact.currentStanding + 1
                Player.AddUpdateContact(LuaBot.contact)
            elseif (id == 3) then
                LuaBot.Mode = nil
            elseif (id == 4) then
                LuaBot.contact.currentStanding = LuaBot.contact.currentStanding - 1
                Player.AddUpdateContact(LuaBot.contact)
            elseif (id == 5) then
                LuaBot.contact.canUseCell = true
                Player.AddUpdateContact(LuaBot.contact)
            elseif (id == 6) then
                LuaBot.contact.canUseCell = false
                Player.AddUpdateContact(LuaBot.contact)
            elseif (id == 7) then
                --reset contact
                LuaBot.contact = Contact.new()
                LuaBot.contact.name = "LuaBot"
                LuaBot.contact.currentStanding = 0
                LuaBot.contact.notifyPlayer = true
                LuaBot.contact.npcId = 1144
                LuaBot.contact.hasLocation = true
                LuaBot.contact.taskIndex = 0
                LuaBot.contact.locationDescription = "Outbreak"
                LuaBot.contact.location = Destination.new()
                LuaBot.contact.location.location = vec3.new(-90, 0, 170)
                LuaBot.contact.location.name = "Outbreak"
                LuaBot.contact.location.mapName =  "Outbreak"
                LuaBot.contact.confidantThreshold = 3
                LuaBot.contact.friendThreshold = 2
                LuaBot.contact.completeThreshold = 4
                LuaBot.contact.canUseCell = false

                Player.AddUpdateContact(LuaBot.contact)
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[4].message, LuaBot.contactDialogs[4].buttons)
            elseif (id == 9) then
                LuaBot.Mode = nil
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[1].message, LuaBot.contactDialogs[1].buttons)
            end
        elseif (LuaBot.Mode == 4) then -- Tasks
            printDebug("LuaBot in task mode: " .. tostring(id))
            if (id == 1) then
                Player.AddUpdateTask(LuaBot.task)
            elseif (id == 2) then
                Player.SelectTask(LuaBot.task)
            elseif (id == 3) then
                LuaBot.Mode = nil
            elseif (id == 4) then
                LuaBot.task.description = 'Task Updated - Talked to LuaBot'
                Player.AddUpdateTask(LuaBot.task)
            elseif (id == 5) then
                LuaBot.task.boardTrain = true
                LuaBot.task.location.name  = "Atlas park"
                LuaBot.task.location.mapName = "Atlas park"
                Player.AddUpdateTask(LuaBot.task)
            elseif (id == 6) then
                LuaBot.task.isComplete = true
                LuaBot.task.state = 'Return to LuaBot'
                Player.AddUpdateTask(LuaBot.task)
            elseif (id == 7) then
                LuaBot.task = Task.new() -- empty task
                Player.AddUpdateTask(LuaBot.task)
            elseif (id == 8) then
                -- Task to LuaBot in Atlas

                LuaBot.task = Task.new()
                LuaBot.task.dbId = 1 -- 1939 - 200
                LuaBot.task.taskIdx = 0
                LuaBot.task.description = "Deliver Bit to LuaBot in Atlas Park"
                LuaBot.task.owner = "LuaBot"
                LuaBot.task.detail = "LuaBot in Outbreak requests you to deliver a test bit to LuaBot in Atlas Park. Use the /mapmenu or the mapmenu in LuaBot's contact dialog to travel."
                LuaBot.task.state = ""
                LuaBot.task.inProgressMaybe = true
                LuaBot.task.isComplete = false
                LuaBot.task.isAbandoned = false
                LuaBot.task.finishTime = 0
                LuaBot.task.unknownInt1 = 1
                LuaBot.task.unknownInt2 = 1
                LuaBot.task.hasLocation = true
                LuaBot.task.boardTrain = true
                LuaBot.task.location = Destination.new()
                LuaBot.task.location.location = vec3.new(112, 16, -216)
                LuaBot.task.location.name  = "City_01_01"
                LuaBot.task.location.mapName = "Atlas Park"
                Player.AddUpdateTask(LuaBot.task)

            elseif (id == 9) then
                --Reset task - Back
                resetTask()

                LuaBot.Mode = nil
                MapClientSession.contact_dialog(client, LuaBot.contactDialogs[1].message, LuaBot.contactDialogs[1].buttons)
            end
        end
    end

    return ""
end

function resetTask()
     --Reset task - Back
     LuaBot.task = Task.new()
     LuaBot.task.dbId = 1 -- 1939 - 200
     LuaBot.task.taskIdx = 0
     LuaBot.task.description = "Talk with LuaBot"
     LuaBot.task.owner = "LuaBot"
     LuaBot.task.detail = "LuaBot Task testing detail........<br><br>Accessing.......<br><br>Accessing.......<br><br>Accessing.......Data not found"
     LuaBot.task.state = ""
     LuaBot.task.inProgressMaybe = true
     LuaBot.task.isComplete = false
     LuaBot.task.isAbandoned = false
     LuaBot.task.finishTime = 0
     LuaBot.task.unknownInt1 = 1
     LuaBot.task.unknownInt2 = 1
     LuaBot.task.hasLocation = true
     LuaBot.task.boardTrain = false
     LuaBot.task.location = Destination.new()
     LuaBot.task.location.location = vec3.new(20, 0, 586)
     LuaBot.task.location.name  = "Outbreak"
     LuaBot.task.location.mapName = "Outbreak"
     Player.AddUpdateTask(LuaBot.task)
end


--Not used but needed for scripting Engine
set_target = function(id) 
    printDebug("target id " .. tostring(id))
    
    return ""
end

contact_call = function(contactIndex)
    printDebug("Contact Call. contactIndex: " .. tostring(contactIndex))

    return ""
end
