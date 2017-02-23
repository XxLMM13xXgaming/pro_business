if (SERVER) then
  MsgC(Color(255,0,0,255), "Pro Business Loaded!\n")
  include("pbusiness/core/sv_core.lua")
  AddCSLuaFile("pbusiness/core/cl_core.lua")
  include("pbusiness/config/pb_mysqlconfig.lua")
  include("pbusiness/config/pb_config.lua")
  AddCSLuaFile("pbusiness/config/pb_config.lua")
  require("tmysql4")
  PBusinessMySQL, PBusinessErr = tmysql.initialize(PBusinessMySQLConfig.PBusinessMySQLHost, PBusinessMySQLConfig.PBusinessMySQLUsername, PBusinessMySQLConfig.PBusinessMySQLPassword, PBusinessMySQLConfig.PBusinessMySQLDatabase, PBusinessMySQLConfig.PBusinessMySQLPort, nil, CLIENT_MULTI_STATEMENTS )
  if PBusinessErr != nil or tostring( type( PBusinessMySQL ) ) == "boolean" then
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "PBusiness", Color(255, 255, 255), "] Error connecting to the database...\n")
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "PBusiness", Color(255, 255, 255), "] Error: ", Color(255,0,0), PBusinessErr.."\n")
  else
    MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "PBusiness", Color(255, 255, 255), "] Connected to database...\n")
  end

end
if (CLIENT) then
  MsgC(Color(255,0,0,255), "Pro Business Loaded!\n")
  include("pbusiness/core/cl_core.lua")
  include("pbusiness/config/pb_config.lua")
end
