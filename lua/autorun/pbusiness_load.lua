if (SERVER) then
  MsgC(Color(255,255,255), "[", Color(0,0,255), "Pro Business", Color(255,255,255), "] Loading...\n")
    -- Start loading stuff
    AddCSLuaFile("pbusiness/core/cl_pb.lua")
    include("pbusiness/core/sv_pb.lua")
    if !(file.Exists("pbusiness","DATA")) then
      file.CreateDir("pbusiness")
      file.Write("pbusiness/logs.txt","[]")
      file.Write("pbusiness/playerbase.txt","[]")
    end 
     -- Stop loading stuff
  MsgC(Color(255,255,255), "[", Color(0,0,255), "Pro Business", Color(255,255,255), "] Loaded!\n")
end

if (CLIENT) then
  MsgC(Color(255,255,255), "[", Color(0,0,255), "Pro Business", Color(255,255,255), "] Loading...\n")
    -- Start loading stuff
    include("pbusiness/core/cl_pb.lua")
    -- Stop loading stuff
  MsgC(Color(255,255,255), "[", Color(0,0,255), "Pro Business", Color(255,255,255), "] Loaded!\n")
end
