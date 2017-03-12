-- PBusiness
util.AddNetworkString("PBusinessNotifySystem")
local plymeta = FindMetaTable("Player")
PBusiness = {} -- This will give us a table to localize some stuff!
PBusiness.Config = {} -- This will give us a table to localize some stuff!
PBusiness.Config.SavingMethod = "text"

PBusiness.InsertLog = function(type, entry)
  local InsertLogT = util.JSONToTable(file.Read("pbusiness/logs.txt","DATA"))
  if type == "BAddPlayer" then
    table.insert(InsertLogT,#InsertLogT + 1, {type, entry[1], entry[2], os.time()})
  elseif type == "BCreate" then
    table.insert(InsertLogT,#InsertLogT + 1, {type, entry[1], entry[2], os.time()})
  elseif type == "BDelete" then
    table.insert(InsertLogT,#InsertLogT + 1, {type, entry[1], entry[2], os.time()})
  else
    table.insert(InsertLogT,#InsertLogT + 1, {"BOther", entry, os.time()})
  end
  file.Write("pbusiness/logs.txt", util.TableToJSON(InsertLogT))
end

PBusiness.NotifySystem = function(ply, type, message)
  if type == 0 then messagecolor = Color(255,0,0) elseif type == 1 then messagecolor = Color(0,0,255) elseif type == 2 then messagecolor = Color(0,255,0) else messagecolor = Color(0,0,255) end
  if ply == "*" then
    net.Start("PBusinessNotifySystem")
      net.WriteFloat(type)
      net.WriteString(message)
      net.WriteBool(false)
    net.Broadcast()
    MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message.."\n")
  elseif ply == "console" then
    MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message.."\n")
  elseif IsValid(ply) then
    net.Start("PBusinessNotifySystem")
      net.WriteFloat(type)
      net.WriteString(message)
      net.WriteBool(false)
    net.Send(ply)
    MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message.."\n")
  end
end

PBusiness.InsertInfomation = function(type, data)
  if PBusiness.Config.SavingMethod == "text" then
    if type == "BAddPlayer" then
      local playersonfile = util.JSONToTable(file.Read("pbusiness/playerbase.txt", "DATA"))
      table.insert(playersonfile,{data})
      file.Write("pbusiness/playerbase.txt",util.TableToJSON(playersonfile))
    elseif type == "BCreate" then
      local PBusinessesonfile = util.JSONToTable(file.Read("pbusiness/business.txt", "DATA"))
      table.insert(PBusinessesonfile,#PBusinessesonfile + 1,{data})
      file.Write("pbusiness/business.txt",util.TableToJSON(PBusinessesonfile))
    end
  elseif PBusiness.Config.SavingMethod == "tmysql4" then

  elseif PBusiness.Config.SavingMethod == "mysqloo" then

  else
    PBusiness.Config.SavingMethod = "text"
    PBusiness.InsertInfomation(type, data)
  end
end

hook.Add("PlayerInitialSpawn","PBusinessPlayerInitialSpawn",function(ply)
  PBusiness.InsertInfomation("BAddPlayer", {ply:SteamID64(), ply:Nick()})
  PBusiness.NotifySystem("console", 2, ply:Nick().."("..ply:SteamID64()..") has been logged in the player database!\n")
end)
