-- PBusiness
net.Receive("PBusinessNotifySystem",function()
  local type = net.ReadFloat()
  local message = net.ReadString()
  local consoleb = net.ReadBool()
  if type == 0 then messagecolor = Color(255,0,0) elseif type == 1 then messagecolor = Color(0,0,255) elseif type == 2 then messagecolor = Color(0,255,0) else messagecolor = Color(0,0,255) end
  chat.AddText(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message)
end)
