PBusiness.MySQL = nil

PBusiness.ConnectToDatabase = function()
    if PBusiness.Config.SavingMethod == "mysqloo" then
        if tobool(pcall(require, "mysqloo")) then
            PBusiness.MySQL = mysqloo.connect( PBusiness.Config.MySQL.Host, PBusiness.Config.MySQL.Username, PBusiness.Config.MySQL.Password, PBusiness.Config.MySQL.Database, PBusiness.Config.MySQL.Port )
            function PBusiness.MySQL:onConnected()
                PBusiness.NotifySystem("console", 2, "Database has connected!")
                hook.Call("PBusinessConnectedToDatabase")
            end
            function PBusiness.MySQL:onConnectionFailed( err )
                PBusiness.NotifySystem("console", 0, "Connection to database failed!")
                PBusiness.NotifySystem("console", 0, "Error: " .. err .. "!")
                hook.Call("PBusinessConnectedToDatabaseError")
            end
            PBusiness.MySQL:connect()
        end
    elseif PBusiness.Config.SavingMethod == "tmysql4" then
        if pcall(require, "tmysql4") then
            require( "tmysql4" )
            PBusiness.MySQL, PBusiness.MySQLError = tmysql.initialize( PBusiness.Config.MySQL.Host, PBusiness.Config.MySQL.Username, PBusiness.Config.MySQL.Password, PBusiness.Config.MySQL.Database, PBusiness.Config.MySQL.Port, nil, CLIENT_MULTI_STATEMENTS )
            if tostring( type( PBusiness.MySQL ) ) == "boolean" then
                PBusiness.NotifySystem("console", 0, "Connection to database failed!")
                PBusiness.NotifySystem("console", 0, "Error: " .. PBusiness.MySQLError .. "!")
                hook.Call("PBusinessConnectedToDatabaseError")
            else
                PBusiness.NotifySystem("console", 2, "Database has connected!")
                hook.Call("PBusinessConnectedToDatabase")
            end
        end
    end
end

hook.Add("PBusinessConnectedToDatabaseError","PBusinessConnectedToDatabaseErrorRedo",function()
    PBusiness.ConnectToDatabase()
end)
