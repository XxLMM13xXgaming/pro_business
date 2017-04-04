surface.CreateFont( "PBusinessTitleFont", {
	font = "Arial",
	size = 20,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont( "PBusinessFontClose", {
	font = "Arial",
	size = 15,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont( "PBusinessLabelFont", {
	font = "Arial",
	size = 15,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

function PBusinessDarkThemeMain(DFrame, title)
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( title, "PBusinessTitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 5, 5)
	frameclose:SetText("X");
	frameclose:SetTextColor(Color(0,0,0,255))
	frameclose:SetFont("PBusinessFontClose")
	frameclose.hover = false
	frameclose.DoClick = function()
		DFrame:Close()
	end
	frameclose.OnCursorEntered = function(self)
		self.hover = true
	end
	frameclose.OnCursorExited = function(self)
		self.hover = false
	end
	function frameclose:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(255,15,15,250)) or Color(255,255,255,255)) -- Paints on hover
		frameclose:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end
end

function PBusinessDarkThemeBtn(button)
	button.OnCursorEntered = function(self)
		self.hover = true
	end
	button.OnCursorExited = function(self)
		self.hover = false
	end
	button.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, self.hover and Color(0,160,255,250) or Color(255,255,255,255)) -- Paints on hover
		self:SetTextColor(self.hover and Color(255,255,255,255) or Color(0,0,0,250))
	end
end

net.Receive("PBusinessOpenCreateMenu",function()
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 500, 180 )
	DFrame:SetTitle( "" )
	DFrame:SetDraggable( true )
	DFrame:ShowCloseButton( false )
	DFrame:Center()
	DFrame:MakePopup()
	PBusinessDarkThemeMain(DFrame, "Create a business")

	local InfoText = vgui.Create("DLabel",DFrame)
	InfoText:SetPos(0, 0)
	InfoText:SetSize(DFrame:GetWide(), DFrame:GetTall())
	InfoText:SetText("\n\n\n          Welcome to the business creator! Here you can start your business!\nLets not waste any time... Lets start by collecting some infomation about you!\n\nWhat is your business's name?\n\nWhat is the idea catagory is your business in?")
	InfoText:SetFont("PBusinessLabelFont")
	InfoText:SetContentAlignment( 8 )

	local BName = vgui.Create("DTextEntry", DFrame)
	BName:SetPos(210, DFrame:GetTall() / 2 - 2)
	BName:SetSize(100, 20)
	BName:SetText("Business Name")

	local BCat = vgui.Create("DComboBox",DFrame)
	BCat:SetPos(295, DFrame:GetTall() / 2 + 28)
	BCat:SetSize(185, 20)
	BCat:SetValue("Business Catagory")
	BCat:AddChoice( "Sales" )
	BCat:AddChoice( "Service" )

	local CarryOn = vgui.Create("DButton", DFrame)
	CarryOn:SetPos(20, DFrame:GetTall() - 30)
	CarryOn:SetSize(DFrame:GetWide() - 40, 20)
	CarryOn:SetText("Continue")
	PBusinessDarkThemeBtn(CarryOn)
	CarryOn.DoClick = function()
		if string.len(BName:GetValue()) > 25 then
			chat.AddText(Color(255,0,0), "Please make your business name less then 25 charactars!")
		elseif BName:GetValue() == "Business Name" then
			chat.AddText(Color(255,0,0), "Please input a valid business name!")
		elseif BCat:GetValue() == "Business Catagory" then
			chat.AddText(Color(255,0,0), "Please select a business catagory!")
		else
			PBusinessPayments(BName:GetValue(), BCat:GetValue())
			DFrame:Close()
		end
	end
end)

function PBusinessPayments(bname, bcat)
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 500, 200 )
	DFrame:SetTitle( "" )
	DFrame:SetDraggable( true )
	DFrame:ShowCloseButton( false )
	DFrame:Center()
	DFrame:MakePopup()
	PBusinessDarkThemeMain(DFrame, "Create a business")

	local InfoText = {
		"Before we can make your business registered you will have to deal with payments...",
		"There are a few costs of running a business but",
		"soon you will be making some money! So lets finish this up!",
		"Your business will be located in this " .. LocalPlayer():GetCurrentZone().BuildName .. " for " .. DarkRP.formatMoney(LocalPlayer():GetCurrentZone().BuildCost) .. "!",
		"You will also need to pay " .. DarkRP.formatMoney(PBusiness.Config.PaymentToStartBusiness) .. " for a startup fee..."
	}
	local InfoTextPos = 40

	for k, v in pairs(InfoText) do
		local InfoTextLbl = vgui.Create("DLabel",DFrame)
		InfoTextLbl:SetPos(0, InfoTextPos)
		InfoTextLbl:SetSize(DFrame:GetWide(), 20)
		InfoTextLbl:SetText(v)
		InfoTextLbl:SetFont("PBusinessLabelFont")
		InfoTextLbl:SetContentAlignment( 8 )
		InfoTextPos = InfoTextPos + 15
	end

	local CarryOn = vgui.Create("DButton", DFrame)
	CarryOn:SetPos(20, DFrame:GetTall() - 30)
	CarryOn:SetSize(DFrame:GetWide() - 40, 20)
	CarryOn:SetText("Continue")
	PBusinessDarkThemeBtn(CarryOn)
	CarryOn.DoClick = function()
		if LocalPlayer():getDarkRPVar("money") >= LocalPlayer():GetCurrentZone().BuildCost + PBusiness.Config.PaymentToStartBusiness then
			net.Start("PBusinessCreateBusiness")
				net.WriteTable({bname, bcat})
			net.SendToServer()
			DFrame:Close()
		else
			chat.AddText(Color(255,0,0), "You do not have enough money to start a business")
			DFrame:Close()
		end
	end
end

net.Receive("PBusinessOpenBusinessMenu",function()
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 500, 200 )
	DFrame:SetTitle( "" )
	DFrame:SetDraggable( true )
	DFrame:ShowCloseButton( false )
	DFrame:Center()
	DFrame:MakePopup()
	PBusinessDarkThemeMain(DFrame, "Business control panel")

	local InfoText = {"Welcome to the business control panel!", "If you are not inside your business office/wearhouse you will get less options!"}
	local InfoTextPos = 40
	for k, v in pairs(InfoText) do
		local InfoTextLbl = vgui.Create("DLabel",DFrame)
		InfoTextLbl:SetPos(0, InfoTextPos)
		InfoTextLbl:SetSize(DFrame:GetWide(), 20)
		InfoTextLbl:SetText(v)
		InfoTextLbl:SetFont("PBusinessLabelFont")
		InfoTextLbl:SetContentAlignment( 8 )
		InfoTextPos = InfoTextPos + 15
	end



end)

net.Receive("PBusinessNotifySystem",function()
	local type = net.ReadFloat()
	local message = net.ReadString()
	local consoleb = net.ReadBool()
	if type == 0 then messagecolor = Color(255,0,0) elseif type == 1 then messagecolor = Color(0,0,255) elseif type == 2 then messagecolor = Color(0,255,0) else messagecolor = Color(0,0,255) end
	if consoleb then
		MsgC(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message)
	else
		chat.AddText(Color(255,255,255), "[", messagecolor, "Pro Business", Color(255,255,255), "] ", Color(255,255,255), message)
	end
end)
