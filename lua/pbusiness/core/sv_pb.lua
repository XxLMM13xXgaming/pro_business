-- PBusiness
util.AddNetworkString("PBusinessNotifySystem")
util.AddNetworkString("PBusinessOpenCreateMenu")
util.AddNetworkString("PBusinessCreateBusiness")
util.AddNetworkString("PBusinessOpenBusinessMenu")
util.AddNetworkString("PBusinessOpenCEOMenu")
util.AddNetworkString("PBusinessBusinessChange")

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

function plymeta:HasBusiness()
    for bid, bv in pairs(PBusiness.Businesses) do
        for k, v in pairs(bv.employees) do
            if v.player == self then
                return true
            end
        end
    end
    return false
end

function plymeta:IsBusinessCEO()
    for bid, bv in pairs(PBusiness.Businesses) do
        for k, v in pairs(bv.employees) do
            if v.player == self and v.rank == "CEO" then
                return true
            end
        end
    end
    return false
end

function plymeta:GetBusinessInfo()
    for bid, bv in pairs(PBusiness.Businesses) do
        for k, v in pairs(bv.employees) do
            if v.player == self then
                return bv
            end
        end
    end
    return false
end

function plymeta:HasCEODesk()
    for k, v in pairs(ents.FindByClass("pb_ceo_desk")) do
        if v:Getowning_ent() == self then
            return true
        end
    end
    return false
end

function plymeta:GetCEODesk()
    for k, v in pairs(ents.FindByClass("pb_ceo_desk")) do
        if v:Getowning_ent() == self then
            return v
        end
    end
    return false
end

hook.Add("PlayerSay","PBusinessPlayerSay",function(ply, text)
    if text:lower():match("[!/:.]createbusiness") then
        if !ply:HasBusiness() then
            local plycurrzone = ply:GetCurrentZone()
            if plycurrzone != nil and plycurrzone.class == "Business Buildings" and !plycurrzone.taken then
                net.Start("PBusinessOpenCreateMenu")
                net.Send(ply)
            elseif plycurrzone != nil and plycurrzone.class == "Business Buildings" and plycurrzone.taken then
                PBusiness.NotifySystem(ply, "error", "This business space has been taken already!")
            else
                PBusiness.NotifySystem(ply, "error", "You can not start a business here! Find a office/wearhouse!")
            end
        else
            PBusiness.NotifySystem(ply, "error", "You either own or are a part of a business! Please go to the business control panel by typing !business")
        end
        return ''
    elseif text:lower():match("[!/:.]business") then
        if ply:HasBusiness() and ply:HasCEODesk() then
            PBusiness.NotifySystem(ply, "success", "To see more about the business go to your desk!")
            local thetabletosend = {}
            for bid, bv in pairs(PBusiness.Businesses) do
                for k, v in pairs(bv.employees) do
                    if v.player == ply then
                        thetabletosend = bv
                    end
                end
            end
            net.Start("PBusinessOpenBusinessMenu")
                net.WriteTable(thetabletosend)
            net.Send(ply)
        elseif ply:HasBusiness() and !ply:HasCEODesk() then
            PBusiness.NotifySystem(ply, "error", "Please purchase a desk!")
        else
            PBusiness.NotifySystem(ply, "error", "You do not own a business... Type !createbusiness to create a business!")
        end
        return ''
    elseif text:lower():match("[!/:.]jobsearch") then
        if ply:HasBusiness() then
            PBusiness.NotifySystem(ply, "error", "You already have a job!")
        else
            net.Start("PBusinessOpenNewsPaper")
                -- coming soon todo
            net.Send(ply)
        end
        return ''
    end
end)

net.Receive("PBusinessCreateBusiness",function(len, ply)
    local infogiven = net.ReadTable()
    PBusiness.NotifySystem(ply, "generic", "Setting some stuff up one moment...")
    if !ply:HasBusiness() and ply:getDarkRPVar("money") >= ply:GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness and string.len(infogiven[1]) <= 25 and infogiven[2] == "Sales" or infogiven[2] == "Service" and ply:GetCurrentZone() != nil then
        ply:addMoney(-(ply:GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness))
        table.insert(PBusiness.Businesses, #PBusiness.Businesses + 1, {id = #PBusiness.Businesses + 1, employees = {{player = ply, rank = "CEO"}}, bname = infogiven[1], btype = infogiven[2], networth = 0, applications = {}, application = {}})
        local plycurrzone = ply:GetCurrentZone()
        plycurrzone.taken = true
        PBusiness.NotifySystem(ply, "success", infogiven[1] .. " is now a registered business!")
    elseif ply:getDarkRPVar("money") < ply:GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness then
        PBusiness.NotifySystem(ply, "error", "You do not have enough money to start this business!")
    end
end)

net.Receive("PBusinessBusinessChange",function(len, ply)
    local newname = net.ReadString()

    if ply:HasBusiness() and ply:IsBusinessCEO() then
        for bid, bv in pairs(PBusiness.Businesses) do
            for k, v in pairs(bv.employees) do
                if v.player == ply and v.rank == "CEO" then
                    bv.bname = newname
                    ply:GetCEODesk():SetPBusinessName(newname)
                end
            end
        end
    end
end)

concommand.Add("testbtable",function(ply)
    PrintTable(ply:GetBusinessInfo())
end)
