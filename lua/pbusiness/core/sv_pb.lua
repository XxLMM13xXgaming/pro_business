-- PBusiness
util.AddNetworkString("PBusinessNotifySystem")
util.AddNetworkString("PBusinessOpenCreateMenu")
util.AddNetworkString("PBusinessCreateBusiness")

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
        PBusiness.MySQL:Escape(string)
    elseif isstring(string) and PBusiness.Config.SavingMethod == "mysqloo" then
        PBusiness.MySQL:escape(string)
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

PBusiness.QueryDatabase = function(thequery, queryid)
    if PBusiness.ServerQuerys == nil then PBusiness.ServerQuerys = {} end
    if PBusiness.Config.SavingMethod == "tmysql4" then
        PBusiness.MySQL:Query(thequery, function(result)
        if result[1].status == false then PBusiness.NotifySystem("staff", 0, "MySQL error! Please fix mysql connection! (" .. result[1].error .. ")") return end
            table.insert(PBusiness.ServerQuerys,{queryid, thequery, result})
        end)
    elseif PBusiness.Config.SavingMethod == "mysqloo" then
        local query2 = PBusiness.MySQL:query(thequery)
        query2.onSuccess = function(q) table.insert(PBusiness.ServerQuerys,{queryid, thequery, query2:getData()}) end
        query2.onError = function(q,e) PBusiness.NotifySystem("staff", 0, "MySQL error! Please fix mysql connection! (" .. e .. ")") end
        query2:start()
    end
end

hook.Add("PlayerSay","PBusinessPlayerSay",function(ply, text)
    if text:lower():match("[!/:.]createbusiness") then
        local plycurrzone = ply:GetCurrentZone()
        if plycurrzone != nil and plycurrzone.class == "Business Buildings" then
            net.Start("PBusinessOpenCreateMenu")
            net.Send(ply)
        else
            PBusiness.NotifySystem(ply, "error", "You can not start a business here! Find a office/wearhouse!")
        end
        return ''
    end
end)

net.Receive("PBusinessCreateBusiness",function(len, ply)
    local infogiven = PBusiness.EscapeString(net.ReadTable())
    local PBusinessCreateBusinessqueryid = math.random(0,9999)
    PBusiness.NotifySystem(ply, "generic", "Lets just set some stuff up one moment...")
    PBusiness.QueryDatabase("SELECT * FROM players WHERE sid=" .. ply:SteamID64(), PBusinessCreateBusinessqueryid)
    timer.Create( "PBusinessQuery" .. PBusinessCreateBusinessqueryid, 1, 0, function()
        for k, v in pairs(PBusiness.ServerQuerys) do
            if v[1] == PBusinessCreateBusinessqueryid then
                timer.Remove( "PBusinessQuery" .. PBusinessCreateBusinessqueryid)
                if !istable(v[2]) and ply:getDarkRPVar("money") >= ply:GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness and string.len(infogiven[1]) <= 25 and infogiven[2] == "Sales" or infogiven[2] == "Service" and ply:GetCurrentZone() != nil then
                ply:addMoney(-ply:GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness)
                PBusiness.QueryDatabase("INSERT INTO businesses (oid, bname, btype) VALUES ('" .. ply:SteamID64() .. "', '" .. infogiven[1] .. "', '" .. infogiven[2] .. "')", math.random())
                PBusiness.QueryDatabase("INSERT INTO players (sid, laststeamname) VALUES ('" .. ply:SteamID64() .. "', '" .. PBusiness.EscapeString(ply:Nick()) .. "')", math.random())
                PBusiness.NotifySystem(ply, "success", infogiven[1] .. " is now a registered business!")
                end
            end
        end
    end)
end)

concommand.Add("pbtest",function(ply)
end)
