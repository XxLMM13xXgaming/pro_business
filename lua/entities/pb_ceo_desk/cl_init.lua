include("shared.lua")
local entmeta = FindMetaTable("Entity")

function entmeta:PBusinessBuildTableTopDerma(personal)
	if personal == "nonceo" then
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetTitle( "" )
		DFrame:SetPos( 0, 0 )
		DFrame:SetSize( 920, 450 )
		DFrame:SetDraggable(false)
		DFrame:ShowCloseButton(false)
		DFrame.Paint = function(s, w, h)
			draw.SimpleText("The CEO Desk Of " .. self:Getowning_ent():Nick(),"DermaLarge",w / 2,20,Color( 0, 0, 0, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		end
		return
	end

	local thecomponents = {}
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetTitle( "" )
	DFrame:SetPos( 0, 0 )
	DFrame:SetSize( 920, 450 )
	DFrame:SetDraggable(false)
	DFrame:ShowCloseButton(false)
	DFrame.Paint = function(s, w, h)
		draw.SimpleText("The CEO Desk Of " .. self:Getowning_ent():Nick(),"DermaLarge",w / 2,20,Color( 0, 0, 0, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
	end

	local function gobackapage()
		DFrame:Close()
		self:PBusinessBuildTableTopDerma(personal)
	end

	local function addcomponent(comp)
		table.insert(thecomponents,#thecomponents + 1, comp)
	end

	local function showbhirepage()
		for k, v in pairs(thecomponents) do
			v:Remove()
		end
		DFrame.Paint = function(s, w, h)
			draw.SimpleText("Hire form","DermaLarge",w / 2,20,Color( 0, 0, 0, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		end

		local InfoText = vgui.Create("DLabel", DFrame)
		InfoText:SetPos(20, 60)
		InfoText:SetSize(DFrame:GetWide() - 40, DFrame:GetTall() - 70)
		InfoText:SetText("On this page you can hire a new employee!")
		InfoText:SetContentAlignment(7)
		InfoText:SetWrap(true)
		InfoText:SetFont("DermaLarge")

	end

	local function showbeditpage()
		for k, v in pairs(thecomponents) do
			v:Remove()
		end
		DFrame.Paint = function(s, w, h)
			draw.SimpleText("Business Regestration Edit","DermaLarge",w / 2,20,Color( 0, 0, 0, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		end

		local InfoText = vgui.Create("DLabel", DFrame)
		InfoText:SetPos(20, 60)
		InfoText:SetSize(DFrame:GetWide() - 40, DFrame:GetTall() - 70)
		InfoText:SetText("On this page you can edit your business name!")
		InfoText:SetContentAlignment(7)
		InfoText:SetWrap(true)
		InfoText:SetFont("DermaLarge")

		local TheBusinessName = vgui.Create("DLabel", DFrame)
		TheBusinessName:SetPos(20, 110)
		TheBusinessName:SetText(self:GetPBusinessName())
		TheBusinessName:SetFont("DermaLarge")
		timer.Simple(.1,function()
			TheBusinessName:SizeToContents()
			local editbnameMat = Material("icon16/brick_edit.png")
			local EditNBtn = vgui.Create( "DButton", DFrame )
			EditNBtn:SetPos( TheBusinessName:GetWide() + 30, 120 )
			EditNBtn:SetSize( 16, 16 )
			EditNBtn:SetText("")
			EditNBtn.Paint = function( s, w, h )
				surface.SetMaterial( editbnameMat )
				surface.SetDrawColor( color_white )
				surface.DrawTexturedRect( 0, 0, w, h )
			end
			EditNBtn.DoClick = function()
				Derma_StringRequest(
					"PB Business Name Change",
					"What would you like to change your businesses name to?",
					self:GetPBusinessName(),
					function( text )
						net.Start("PBusinessBusinessChange")
							net.WriteString(text)
						net.SendToServer()
						TheBusinessName:SetText(text)
						TheBusinessName:SizeToContents()
						EditNBtn:SetPos( TheBusinessName:GetWide() + 30, 120 )
					end,
					function( text ) end
				 )
			end
		end)

		local backMat = Material("icon16/arrow_left.png")
		local BackBtn = vgui.Create( "DButton", DFrame )
		BackBtn:SetPos( DFrame:GetWide() - 25, DFrame:GetTall() - 25 )
		BackBtn:SetSize( 16, 16 )
		BackBtn:SetText("")
		BackBtn.Paint = function( s, w, h )
		    surface.SetMaterial( backMat )
		    surface.SetDrawColor( color_white )
		    surface.DrawTexturedRect( 0, 0, w, h )
		end
		BackBtn.DoClick = function()
			gobackapage()
		end
	end

	local function showinfopage()
		for k, v in pairs(thecomponents) do
			v:Remove()
		end
		DFrame.Paint = function(s, w, h)
			draw.SimpleText("Info...","DermaLarge",w / 2,20,Color( 0, 0, 0, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		end

		local InfoText = vgui.Create("DLabel", DFrame)
		InfoText:SetPos(20, 60)
		InfoText:SetSize(DFrame:GetWide() - 40, DFrame:GetTall() - 70)
		InfoText:SetText("Welcome to the life of being a CEO! This is your desk where you will be able to sit and control your growing business from its core. You can change your businesses name, pay your bills, hire/fire employees, create new product lines, and even pass your business on to someone else or just retire your business! The GUI of the desk should be simple to use however if it is not you can type 'pbusiness_guihelp' in your console and you will get a link to a youtube video tutorial on how to use this GUI! If there are anymore issues please type 'pbusiness_reportanissue' in your console for more instructions on how to report or get help with an issue!")
		InfoText:SetContentAlignment(7)
		InfoText:SetWrap(true)
		InfoText:SetFont("DermaLarge")

		local backMat = Material("icon16/arrow_left.png")
		local BackBtn = vgui.Create( "DButton", DFrame )
		BackBtn:SetPos( DFrame:GetWide() - 25, DFrame:GetTall() - 25 )
		BackBtn:SetSize( 16, 16 )
		BackBtn:SetText("")
		BackBtn.Paint = function( s, w, h )
		    surface.SetMaterial( backMat )
		    surface.SetDrawColor( color_white )
		    surface.DrawTexturedRect( 0, 0, w, h )
		end
		BackBtn.DoClick = function()
			gobackapage()
		end
	end

	local hireMat = Material("icon16/user_add.png")
	local HireBtn = vgui.Create( "DButton", DFrame )
	HireBtn:SetPos( DFrame:GetWide() - 65, DFrame:GetTall() - 25 )
	HireBtn:SetSize( 16, 16 )
	HireBtn:SetText("")
	HireBtn.Paint = function( s, w, h )
	    surface.SetMaterial( hireMat )
	    surface.SetDrawColor( color_white )
	    surface.DrawTexturedRect( 0, 0, w, h )
	end
	HireBtn.DoClick = function()
		showbhirepage()
	end
	addcomponent(HireBtn)

	local bookMat = Material("icon16/book_edit.png")
	local BookBtn = vgui.Create( "DButton", DFrame )
	BookBtn:SetPos( DFrame:GetWide() - 45, DFrame:GetTall() - 25 )
	BookBtn:SetSize( 16, 16 )
	BookBtn:SetText("")
	BookBtn.Paint = function( s, w, h )
	    surface.SetMaterial( bookMat )
	    surface.SetDrawColor( color_white )
	    surface.DrawTexturedRect( 0, 0, w, h )
	end
	BookBtn.DoClick = function()
		showbeditpage()
	end
	addcomponent(BookBtn)

	local infoMat = Material("icon16/information.png")
	local InfoBtn = vgui.Create( "DButton", DFrame )
	InfoBtn:SetPos( DFrame:GetWide() - 25, DFrame:GetTall() - 25 )
	InfoBtn:SetSize( 16, 16 )
	InfoBtn:SetText("")
	InfoBtn.Paint = function( s, w, h )
	    surface.SetMaterial( infoMat )
	    surface.SetDrawColor( color_white )
	    surface.DrawTexturedRect( 0, 0, w, h )
	end
	InfoBtn.DoClick = function()
		showinfopage()
	end
	addcomponent(InfoBtn)

	self.frame = DFrame
end

function ENT:Initialize()
	if LocalPlayer() != self:Getowning_ent() then
		self:PBusinessBuildTableTopDerma("nonceo")
	end
end

function ENT:Draw()
	self:DrawModel()

	local dist = (LocalPlayer():GetShootPos() - self:GetPos()):Length()
	if dist > 500 then
		self.frame:Remove()
		return
	elseif !IsValid(self.frame) then
		self:PBusinessBuildTableTopDerma()
	end

  	local fix_angles = self:GetAngles()
  	local fix_rotation = Vector(0, 90, 0)

  	fix_angles:RotateAroundAxis(fix_angles:Right(), fix_rotation.x)
  	fix_angles:RotateAroundAxis(fix_angles:Up(), fix_rotation.y)
  	fix_angles:RotateAroundAxis(fix_angles:Forward(), fix_rotation.z)

   	local target_pos = self:GetPos() + ( self:GetAngles():Forward() * 21 ) + ( self:GetAngles():Up() * 31.5  ) - (self:GetAngles():Right() * 46)
    local ang2 = self:GetAngles()
    ang2:RotateAroundAxis(ang2:Up(), 270)

	vgui.Start3D2D( target_pos, ang2, .1)
		self.frame:Paint3D2D() -- here paint the frame
	vgui.End3D2D()
end
