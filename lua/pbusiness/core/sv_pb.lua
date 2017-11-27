-- PBusiness
util.AddNetworkString("PBusinessNotifySystem")
util.AddNetworkString("PBusinessOpenCreateMenu")
util.AddNetworkString("PBusinessCreateBusiness")
util.AddNetworkString("PBusinessOpenBusinessMenu")
util.AddNetworkString("PBusinessOpenCEOMenu")
util.AddNetworkString("PBusinessBusinessChange")
util.AddNetworkString("PBusinessOpenJobSearch")
util.AddNetworkString("PBusinessAddBusinessToClient")
util.AddNetworkString("PBusinessUpdateBusinessToClient")
util.AddNetworkString("PBMailCompose")
util.AddNetworkString("PBusinessSubmitApplication")

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
    return false -- Gotta change to
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

function PBusinessUpdateBusinesses()
    net.Start("PBusinessUpdateBusinessToClient")
        net.WriteTable(PBusiness.Businesses)
    net.Broadcast()
end

function plymeta:PBusinessShipApplication(tbid, theapplication)
    local thebusiness = nil
    local infotoship = {}
    for bid, bv in pairs(PBusiness.Businesses) do
        if bv.id == tbid then
            thebusiness = bv
        end
    end

    for k, v in pairs(theapplication) do
        if v[1] == "ste" then
            table.insert(infotoship,#infotoship + 1, {"Short answer responce", "Question: " .. v[2], "Responce: " .. v.shortAnswer})
        elseif v[1] == "lte" then
            table.insert(infotoship,#infotoship + 1, {"Long answer responce", "Question: " .. v[2], "Responce: " .. v.longAnswer})
        elseif v[1] == "mc" then
            PrintTable(v)
            if v.option1Chk then
                responce = v.option1ChkOp
            elseif v.option2Chk then
                responce = v.option2ChkOp
            elseif v.option3Chk then
                responce = v.option3ChkOp
            elseif v.option4Chk then
                responce = v.option4ChkOp
            end
            if thebusiness.application[1][k][7] == 1 then
                theca =  3
            elseif thebusiness.application[1][k][7] == 2 then
                theca =  4
            elseif thebusiness.application[1][k][7] == 3 then
                theca =  5
            elseif thebusiness.application[1][k][7] == 4 then
                theca =  6
            end
            table.insert(infotoship,#infotoship + 1, {"Multi choice responce", "Question: " .. v[2], "Responce: " .. responce, "Correct answer: " .. thebusiness.application[1][k][theca], responce == thebusiness.application[1][k][theca]})
        end
    end
    table.insert(thebusiness.applications,#thebusiness.applications + 1,{self, infotoship})
    net.Start("PBusinessSendCEODeskData")
        net.WriteTable(thebusiness.application)
        net.WriteTable(thebusiness.applications)
    net.Send(thebusiness.employees[1].player)
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
--        if ply:HasBusiness() then
--            PBusiness.NotifySystem(ply, "error", "You already have a job!")
--        else
            net.Start("PBusinessOpenJobSearch")
            net.Send(ply)
--        end
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
        net.Start("PBusinessAddBusinessToClient")
            net.WriteTable(PBusiness.Businesses)
        net.Broadcast()
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

net.Receive("PBMailCompose",function(len, ply)
    -- Coming soon
end)

-- Gotta finish
net.Receive("PBusinessSubmitApplication",function(len, ply)
    local bid = net.ReadFloat()
    local newappdata = net.ReadTable()
--    if !ply:HasBusiness() then
        for k, v in pairs(PBusiness.Businesses) do
            if bid == v.id and #v.application >= 1 or #v.application[1] >= 1 then
                ply:PBusinessShipApplication(bid, newappdata)
            end
        end
--    end
end)

concommand.Add("testbtable",function(ply)
    PrintTable(PBusiness.Businesses)
end)
