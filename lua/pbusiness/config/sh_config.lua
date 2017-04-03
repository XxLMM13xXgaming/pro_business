local config = PBusiness.Config
config.DevMode = true -- LEAVE THIS FALSE
/*
    Made By: XxLMM13xXgaming
*/

PBusiness.Config.PaymentToStartBusiness = 1000 -- The starting price for opening a business
PBusiness.Config.SavingMethod = "mysqloo" -- 'mysqloo' or 'tmysql4'


if (SERVER) then
    PBusiness.Config.MySQL = {}
    PBusiness.Config.MySQL.Host = ""
    PBusiness.Config.MySQL.Username = ""
    PBusiness.Config.MySQL.Password = ""
    PBusiness.Config.MySQL.Database = ""
    PBusiness.Config.MySQL.Port = 3306
end
