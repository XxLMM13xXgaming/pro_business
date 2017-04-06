-- PBusiness
util.AddNetworkString("PBusinessNotifySystem")
util.AddNetworkString("PBusinessOpenCreateMenu")
util.AddNetworkString("PBusinessCreateBusiness")
util.AddNetworkString("PBusinessOpenControlPanel")
util.AddNetworkString("PBusinessOpenBusinessMenu")

local plymeta = FindMetaTable("Player")

PBusiness.NotifySystem = function(ply, type, message)
    if isstring(type) then
        if type == "error" then messagecolor = Color(255,0,0) type = 0 elseif type == "generic" then messagecolor = Color(0,0,255) type = 1 elseif type == "success" then messagecolor = Color(0,255,0) type = 2 else messagecolor = Color(0,0,255) type = 1 end
    elseif isnumber(type) then
        if type == 0 then messagecolor = Color(255,0,0) elseif type == 1 then messagecolor = Color(0,0,255) elseif type == 2 then messagecolor = Color(0,255,0) else messagecolor = Color(0,0,255) end
    end
    if ply == "*" then
        net.Start("PBusinessNotifySystem")
            net.WriteFloat(type)
            net.WriteString(message)
            net.WriteBool(false)
        net.Broadcast()
        MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message .. "\n")
    elseif ply == "console" then
        MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message  .. "\n")
        net.Start("PBusinessNotifySystem")
            net.WriteFloat(type)
            net.WriteString(message)
            net.WriteBool(true)
        net.Broadcast()
    elseif ply == "staff" then
        MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message .. "\n")
        for k, v in pairs(player.GetAll()) do
            if v:IsSuperAdmin() then
                net.Start("PBusinessNotifySystem")
                    net.WriteFloat(type)
                    net.WriteString(message)
                    net.WriteBool(false)
                net.Send(v)
            end
        end
    elseif IsValid(ply) then
        net.Start("PBusinessNotifySystem")
            net.WriteFloat(type)
            net.WriteString(message)
            net.WriteBool(false)
        net.Send(ply)
        MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message .. "\n")
    end
end

PBusiness.EscapeString = function(string)
    if isstring(string) and PBusiness.Config.SavingMethod == "tmysql4" then
        return PBusiness.MySQL:Escape(string)
    elseif isstring(string) and PBusiness.Config.SavingMethod == "mysqloo" then
        return PBusiness.MySQL:escape(string)
    elseif istable(string) and PBusiness.Config.SavingMethod == "mysqloo" then
        local newtable = {}
        for k, v in pairs(string) do
            if istable(v) then
                table.insert(newtable,#newtable + 1,PBusiness.EscapeString(v))
            else
                table.insert(newtable,#newtable + 1,PBusiness.MySQL:escape(v))
            end
        end
        return newtable
    elseif istable(string) and PBusiness.Config.SavingMethod == "tmysql4" then
        local newtable = {}
        for k, v in pairs(string) do
            if istable(v) then
                table.insert(newtable,#newtable + 1,PBusiness.EscapeString(v))
            else
                table.insert(newtable,#newtable + 1,PBusiness.MySQL:Escape(v))
            end
        end
        return newtable
    end
end

PBusiness.QueryDatabase = function(thequery, callback)
    if thequery == nil then return end
    if callback == nil then return end
    if PBusiness.MySQL == nil then
        PBusiness.ConnectToDatabase()
    end
    if PBusiness.Config.SavingMethod == "tmysql4" then
        PBusiness.MySQL:Query(thequery, function(result)
            if result[1].status then
                callback(true, result, nil)
            else
                callback(false, result[1].error, result[1].lastid)
            end
        end)
    elseif PBusiness.Config.SavingMethod == "mysqloo" then
        local query2 = PBusiness.MySQL:query(thequery)
        query2.onSuccess = function(q) callback(true, q:getData(), q:lastInsert()) end
        query2.onError = function(q,e) callback(false, e, nil) end
        query2:start()
    end
end

function plymeta:HasBusiness()
    for k, v in pairs(PBusiness.Players) do
        if v.sid == self:SteamID64() and v.bid != nil and v.bid != 0 then
            return true
        end
    end
    return false
end

function plymeta:GetBusinessRank()
    for k, v in pairs(PBusiness.Players) do
        if v.sid == self:SteamID64() then
            return v.brank
        end
    end
    return nil
end

hook.Add("PlayerSay","PBusinessPlayerSay",function(ply, text)
    if text:lower():match("[!/:.]createbusiness") then
        if !ply:HasBusiness() then
            local plycurrzone = ply:GetCurrentZone()
            if plycurrzone != nil and plycurrzone.class == "Business Buildings" then
                net.Start("PBusinessOpenCreateMenu")
                net.Send(ply)
            else
                PBusiness.NotifySystem(ply, "error", "You can not start a business here! Find a office/wearhouse!")
            end
        else
            PBusiness.NotifySystem(ply, "error", "You either own or are a part of a business! Please go to the business control panel by typing !business")
        end
        return ''
    elseif text:lower():match("[!/:.]business") then
        if ply:HasBusiness() then
            PBusiness.NotifySystem(ply, "generic", "Please purchase a desk!")
        else
            PBusiness.NotifySystem(ply, "error", "You do not own a business... Type !createbusiness to create a business!")
        end
        return ''
    end
end)

hook.Add("PBusinessConnectedToDatabase","PBusinessConnectedToDatabaseCreateTable",function()
    PBusiness.Players = {}
    PBusiness.Businesses = {}
    PBusiness.QueryDatabase("SELECT * FROM players", function(ran, result)
        if !ran then
            PBusiness.NotifySystem("console", "error", "MySQl error: " .. result)
        else
            for k, v in pairs(result) do
                table.insert(PBusiness.Players,#PBusiness.Players + 1,v)
            end
        end
    end)
    PBusiness.QueryDatabase("SELECT * FROM businesses", function(ran, result)
        if !ran then
            PBusiness.NotifySystem("console", "error", "MySQl error: " .. result)
        else
            for k, v in pairs(result) do
                table.insert(PBusiness.Businesses,#PBusiness.Businesses + 1,v)
            end
        end
    end)
end)

hook.Add("PlayerInitialSpawn","PBusinessPlayerInitialSpawn",function(ply)
    local ishere = false
    for k, v in pairs(PBusiness.Players) do
        if v.sid == ply:SteamID64() then
            ishere = true
        end
    end
    if !ishere then
        PBusiness.QueryDatabase("INSERT INTO players (sid, laststeamname) VALUES ('" .. ply:SteamID64() .. "', '" .. PBusiness.EscapeString(ply:Nick()) .. "')", function(ran, result)
            if !ran then
                PBusiness.NotifySystem("console", "error", "MySQl error: " .. result)
            end
            table.insert(PBusiness.Players,#PBusiness.Players + 1,{sid = ply:SteamID64(), laststeamname = ply:Nick()})
        end)
    end
end)

net.Receive("PBusinessCreateBusiness",function(len, ply)
    local infogiven = PBusiness.EscapeString(net.ReadTable())
    PBusiness.NotifySystem(ply, "generic", "Setting some stuff up one moment...")
    if !ply:HasBusiness() and ply:getDarkRPVar("money") >= ply:GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness and string.len(infogiven[1]) <= 25 and infogiven[2] == "Sales" or infogiven[2] == "Service" and ply:GetCurrentZone() != nil then
        ply:addMoney(-ply:GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness)
        PBusiness.QueryDatabase("INSERT INTO businesses (oid, bname, btype) VALUES ('" .. ply:SteamID64() .. "', '" .. infogiven[1] .. "', '" .. infogiven[2] .. "')", function(ran, result, lid)
            if !ran then
                PBusiness.NotifySystem("console", "error", "MySQl error: " .. result)
                return
            end
            for k, v in pairs(PBusiness.Players) do
                if v.sid == ply:SteamID64() then
                    v.bid = lid
                    v.brank = "ceo"
                end
            end
            PBusiness.QueryDatabase("UPDATE players SET brank='ceo', bid='" .. lid .. "' WHERE sid=" .. ply:SteamID64(), function(upran, theresult)
                if upran then
                    print("Worked")
                else
                    print(theresult)
                end
            end)
            PBusiness.QueryDatabase("INSERT INTO businesses (oid, bname, btype, networth) VALUES ('" .. ply:SteamID64() .. "', '" .. infogiven[1] .. "', '" .. infogiven[2] .. "', '0')")
            table.insert(PBusiness.Businesses, #PBusiness.Businesses + 1, {id = lid, oid = ply:SteamID64(), bname = infogiven[1], btype = infogiven[2], networth = 0})
        end)
        PBusiness.NotifySystem(ply, "success", infogiven[1] .. " is now a registered business!")
    end
end)

concommand.Add("pbtest",function(ply)
    PrintTable(PBusiness.Players)
    PrintTable(PBusiness.Businesses)
end)

concommand.Add("pbtest2",function(ply)
    PBusiness.ConnectToDatabase()
end)
