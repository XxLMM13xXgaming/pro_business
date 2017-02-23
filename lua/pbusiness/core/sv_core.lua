-- PBusiness
AddCSLuaFile("pbusiness/ui/cl_main.lua")
local plymeta = FindMetaTable("Player")

util.AddNetworkString("PBusinessOpenMainMenu")
util.AddNetworkString("PBusinessCreateBusinessPicked")
util.AddNetworkString("PBusinessCreateBusiness")
util.AddNetworkString("PBusinessCreateBusinessCreated")

hook.Add("PlayerSay","PBusinessChatCommand",function(ply, text)
  if text:lower():match('[!/:.]pbusiness') then
    net.Start("PBusinessOpenMainMenu")
    net.Send(ply)
    return ''
  end
end)

hook.Add("PlayerInitialSpawn","PBusinessPlayerInitialSpawn",function(ply)
  PBusinessMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(playerexist)
    if playerexist[1].affected > 0 then
      ply:PBusinessRefreshPlayerData()
    else
      PBusinessMySQL:Query("INSERT INTO players (sid, sname, bid) VALUES ('"..ply:SteamID64().."', '"..PBBusinessEscapeMySQL(ply:Nick()).."', '0')", function(createplayer)
        MsgC(Color(255,0,0,255), "ProBusiness Logged "..ply:Nick())
        ply:PBusinessRefreshPlayerData()
      end)
    end
  end)
end)

function PBBusinessEscapeMySQL(string)
  return PBusinessMySQL:Escape(string)
end

function plymeta:PBusinessRefreshPlayerData()
  PBusinessMySQL:Query("SELECT * FROM players WHERE sid="..self:SteamID64(), function(playerdata)
    if playerdata[1].affected > 0 then
      local pdata = playerdata[1].data[1]
      self.PBPlayerID = pdata.id
      self.PBPlayerName = pdata.sname
      self.PBBusinessID = pdata.bid
    end
  end)
end

function plymeta:HasBusiness()
  if self.PBBusinessID > 0 then
    return true
  else
    return false
  end
  return false
end

net.Receive("PBusinessCreateBusinessPicked",function(len, ply)
  if !ply:HasBusiness() then
    net.Start("PBusinessCreateBusiness")
    net.Send(ply)
  else
    -- Error
  end
end)

net.Receive("PBusinessCreateBusinessCreated",function(len, ply)
  local bname = PBBusinessEscapeMySQL(net.ReadString())
  local bdesc = PBBusinessEscapeMySQL(net.ReadString())

  if string.len(bname) <= 20 and string.len(bdesc) <= 80 and !ply:HasBusiness() then
    PBusinessMySQL:Query("INSERT INTO businesses (sidowner, bname, bdesc) VALUES ('"..ply:SteamID64().."', '"..bname.."', '"..bdesc.."')", function(createbusiness)
      PBusinessMySQL:Query("UPDATE players SET bid='"..createbusiness[1].lastid.."' WHERE sid="..ply:SteamID64(), function(updateplayer)
        ply:PBusinessRefreshPlayerData()
        ply:ChatPrint("Your business has been created!")
      end)
    end)
  end
end)

concommand.Add("pbtest",function(ply)
  ply:PBusinessRefreshPlayerData()
end)
