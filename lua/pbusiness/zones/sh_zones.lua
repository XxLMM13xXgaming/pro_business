--This is an example usage of the zones system.
AddCSLuaFile("zones.lua")
include("zones.lua")

zones.RegisterClass("Business Buildings",Color(0,0,255,255))

--Use this to set default properties. Only called on server.
hook.Add("OnZoneCreated","PBusinessOnZoneCreated",function(zone,class,zoneID)
	if class == "Business Buildings" then
		zone.BuildName = "Standard Business Office"
		zone.BuildCost = 100
	end
end)

hook.Add("ShowZoneOptions","PBusinessShowZoneOptions",function(zone,class,DPanel,zoneID,DFrame)
	if class == "Business Buildings" then
		local bbnlbl = Label("Business Building Name:")
		bbnlbl:SetParent(DPanel)
		bbnlbl:SetPos(5,5)
		bbnlbl:SetTextColor(color_black)
		bbnlbl:SizeToContents()

		local bbn = vgui.Create("DTextEntry",DPanel) --parent to the panel.
		bbn:SetPos(5,bbnlbl:GetTall() + 10)
		bbn:SetSize(200,20)
		bbn:SetText(zone.BuildName)

		local bbclbl = Label("Business Building Price:")
		bbclbl:SetParent(DPanel)
		bbclbl:SetPos(5,50)
		bbclbl:SetTextColor(color_black)
		bbclbl:SizeToContents()

		local bbc = vgui.Create("DNumberWang",DPanel) --parent to the panel.
		bbc:SetPos(5,70)
		bbc:SetValue(zone.BuildCost)
		bbc:SetDecimals(1)

		local bbd = vgui.Create("DButton",DPanel)
		bbd:SetPos(5,100)
		bbd:SetText("Save zone info")
		bbd:SetSize(200,20)
		bbd.DoClick = function()
			net.Start("arena_zone")
				net.WriteFloat(zoneID)
				net.WriteString(bbn:GetValue())
				net.WriteFloat(bbc:GetValue())
			net.SendToServer()
			chat.AddText(Color(0,255,0), "Zone info saved!")
		end


		return 500, 400 -- Specify the width and height for the DPanel container. The frame will resize accordingly.
	end
end)

if SERVER then
	util.AddNetworkString("arena_zone")
	net.Receive("arena_zone",function(len,ply)
		local id, new, new2 = net.ReadFloat(), net.ReadString(), net.ReadFloat()
		if not ply:IsAdmin() then return end

		zones.List[id].BuildName = new
		zones.List[id].BuildCost = new2
		zones.Sync()

	end)
end
