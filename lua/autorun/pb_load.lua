if (SERVER) then
  MsgC(Color(255,0,0,255), "Pro Business Loaded!\n")
  include("pbusiness/core/sv_core.lua")
  AddCSLuaFile("pbusiness/core/cl_core.lua")
end
if (CLIENT) then
  MsgC(Color(255,0,0,255), "Pro Business Loaded!\n")
  include("pbusiness/core/cl_core.lua")
end
