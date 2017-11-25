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
		InfoText:SetText("On this page you can hire employees and make an application form!")
		InfoText:SetContentAlignment(7)
		InfoText:SetWrap(true)
		InfoText:SetFont("DermaLarge")

		local EditAppName = vgui.Create("DLabel", DFrame)
		EditAppName:SetPos(20, 110)
		EditAppName:SetText("Click to the right to make/edit your application...")
		EditAppName:SetFont("DermaLarge")
		timer.Simple(.1,function()
			EditAppName:SizeToContents()
			local editappMat = Material("icon16/page_white_edit.png")
			local EditAppBtn = vgui.Create( "DButton", DFrame )
			EditAppBtn:SetPos( EditAppName:GetWide() + 30, 120 )
			EditAppBtn:SetSize( 16, 16 )
			EditAppBtn:SetText("")
			EditAppBtn.Paint = function( s, w, h )
				surface.SetMaterial( editappMat )
				surface.SetDrawColor( color_white )
				surface.DrawTexturedRect( 0, 0, w, h )
			end
			EditAppBtn.DoClick = function()
				newappstuff = LocalPlayer().PBusinessApplication or {}

				local AppMakeForm = vgui.Create("DFrame")
				AppMakeForm:SetSize(500,700)
				AppMakeForm:MakePopup()
				AppMakeForm:Center()
				AppMakeForm:ShowCloseButton(false)
				AppMakeForm:SetTitle("This page will look better for people applying and in the future")

				local AppList = vgui.Create( "DPanelList", AppMakeForm )
				AppList:Dock(FILL)
				AppList:SetSpacing( 2 )
				AppList:EnableVerticalScrollbar( true )
				AppList.VBar.Paint = function( s, w, h )
					draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,70))
				end
				AppList.VBar.btnUp.Paint = function( s, w, h ) end
				AppList.VBar.btnDown.Paint = function( s, w, h ) end
				AppList.VBar.btnGrip.Paint = function( s, w, h )
					draw.RoundedBox( 4, 5, 0, 4, h + 22, Color(0,0,0,70))
				end

				for k, v in pairs(newappstuff) do
					if v[1] == "ste" then
						AppOppSTE = vgui.Create("DFrame")
						AppOppSTE:SetSize(AppList:GetWide(), 50)
						AppOppSTE:ShowCloseButton(false)
						AppOppSTE:SetTitle("")
						AppOppSTE.Paint = function(s, w, h)
							draw.RoundedBox(0,0,0,w,h,Color(45,45,45,150))
						end

						local AppQuestion = vgui.Create("DLabel", AppOppSTE)
						AppQuestion:SetPos(10, 0)
						AppQuestion:SetSize(200, 20)
						AppQuestion:SetText(v[2])

						local AppTextEntryAnswer = vgui.Create("DTextEntry", AppOppSTE)
						AppTextEntryAnswer:SetPos(10, 20)
						AppTextEntryAnswer:SetSize(200, 20)
						AppTextEntryAnswer:SetValue("Answer would be here")

						local removeappopp = vgui.Create("DButton", AppOppSTE)
						removeappopp:SetPos(420, AppOppSTE:GetTall() - 30)
						removeappopp:SetSize(60, 20)
						removeappopp:SetText("Remove")
						removeappopp.DoClick = function()
							table.remove(newappstuff,k)
							AppOppSTE:Remove()
						end
						AppList:AddItem(AppOppSTE)
					elseif v[1] == "lte" then
						AppOppLTE = vgui.Create("DFrame")
						AppOppLTE:SetSize(AppList:GetWide(), 80)
						AppOppLTE:ShowCloseButton(false)
						AppOppLTE:SetTitle("")
						AppOppLTE.Paint = function(s, w, h)
							draw.RoundedBox(0,0,0,w,h,Color(45,45,45,150))
						end

						local AppQuestion = vgui.Create("DLabel", AppOppLTE)
						AppQuestion:SetPos(10, 0)
						AppQuestion:SetSize(200, 20)
						AppQuestion:SetText(v[2])

						local AppTextEntryAnswer = vgui.Create("DTextEntry", AppOppLTE)
						AppTextEntryAnswer:SetPos(10, 20)
						AppTextEntryAnswer:SetSize(200, 50)
						AppTextEntryAnswer:SetMultiline(true)
						AppTextEntryAnswer:SetValue("Answer would be here")

						local removeappopp = vgui.Create("DButton", AppOppLTE)
						removeappopp:SetPos(420, AppOppLTE:GetTall() - 30)
						removeappopp:SetSize(60, 20)
						removeappopp:SetText("Remove")
						removeappopp.DoClick = function()
							table.remove(newappstuff,k)
							AppOppLTE:Remove()
						end
						AppList:AddItem(AppOppLTE)
					elseif v[1] == "mc" then
						AppOppMC = vgui.Create("DFrame")
						AppOppMC:SetSize(AppList:GetWide(), 150)
						AppOppMC:ShowCloseButton(false)
						AppOppMC:SetTitle("")
						AppOppMC.Paint = function(s, w, h)
							draw.RoundedBox(0,0,0,w,h,Color(45,45,45,150))
						end

						local AppQuestion = vgui.Create("DLabel", AppOppMC)
						AppQuestion:SetPos(10, 0)
						AppQuestion:SetSize(200, 20)
						AppQuestion:SetText(v[2])

						local AppCone = vgui.Create("DLabel", AppOppMC)
						AppCone:SetPos(10, 50)
						AppCone:SetSize(200, 20)
						AppCone:SetText(v[3])

						local AppCtwo = vgui.Create("DLabel", AppOppMC)
						AppCtwo:SetPos(10, 70)
						AppCtwo:SetSize(200, 20)
						AppCtwo:SetText(v[4])

						local AppCthree = vgui.Create("DLabel", AppOppMC)
						AppCthree:SetPos(10, 90)
						AppCthree:SetSize(200, 20)
						AppCthree:SetText(v[5])

						local AppCfour = vgui.Create("DLabel", AppOppMC)
						AppCfour:SetPos(10, 110)
						AppCfour:SetSize(200, 20)
						AppCfour:SetText(v[6])

						local AppRA = vgui.Create("DLabel", AppOppMC)
						AppRA:SetPos(10, 130)
						AppRA:SetSize(200, 20)
						AppRA:SetText("Right answer: " .. v[7])

						local removeappopp = vgui.Create("DButton", AppOppMC)
						removeappopp:SetPos(420, AppOppMC:GetTall() - 30)
						removeappopp:SetSize(60, 20)
						removeappopp:SetText("Remove")
						removeappopp.DoClick = function()
							table.remove(newappstuff,k)
							AppOppMC:Remove()
						end
						AppList:AddItem(AppOppMC)
					end
				end

				local CreateNewField = vgui.Create("DButton")
				CreateNewField:SetSize(AppList:GetWide(), 20)
				CreateNewField:SetText("Add New Field")
				CreateNewField.DoClick = function()
					local menu = DermaMenu()
					menu:AddOption( "Small text entry", function()
						Derma_StringRequest(
							"Application editor",
							"What is the small text entry question",
							"",
							function( text )
								table.insert(newappstuff,#newappstuff + 1,{"ste", text})
								chat.AddText(Color(255,0,0), "Hit close editor to see the changes!")
							end,
							function( text ) end
						)
					end )
					menu:AddOption( "Large text entry", function()
						Derma_StringRequest(
							"Application editor",
							"What is the Large text entry question",
							"",
							function( text )
								table.insert(newappstuff,#newappstuff + 1,{"lte", text})
								chat.AddText(Color(255,0,0), "Hit close editor to see the changes!")
							end,
							function( text ) end
						)
					end )
					menu:AddOption( "Multiple choice", function() -- Gonna redo this later so i can optomize this ugly code. Yes i know its ugly right now i dont wanna hear it.
						Derma_StringRequest(
							"Application editor",
							"What is the multiple choice question",
							"",
							function( mcq )
								Derma_StringRequest(
									"Application editor",
									"What is one possible answer... After entering four you will be able to pick what one is the correct answer and we will randomize the test!",
									"",
									function( cone )
										Derma_StringRequest(
											"Application editor",
											"What is one possible answer... After entering four you will be able to pick what one is the correct answer and we will randomize the test!",
											"",
											function( ctwo )
												Derma_StringRequest(
													"Application editor",
													"What is one possible answer... After entering four you will be able to pick what one is the correct answer and we will randomize the test!",
													"",
													function( cthree )
														Derma_StringRequest(
															"Application editor",
															"What is one possible answer... After entering four you will be able to pick what one is the correct answer and we will randomize the test!",
															"",
															function( cfour )
																Derma_Query( "What is the correct answer...\n1.) " .. cone .. "\n2.) " .. ctwo .. "\n3.) " .. cthree .. "\n4.) " .. cfour, "Application editor",
																"#1", function()
																	table.insert(newappstuff,#newappstuff + 1,{"mc", mcq, cone, ctwo, cthree, cfour, 1})
																	chat.AddText(Color(255,0,0), "Hit close editor to see the changes!")
																end,
																"#2", function()
																	table.insert(newappstuff,#newappstuff + 1,{"mc", mcq, cone, ctwo, cthree, cfour, 2})
																	chat.AddText(Color(255,0,0), "Hit close editor to see the changes!")
																end,
																"#3", function()
																	table.insert(newappstuff,#newappstuff + 1,{"mc", mcq, cone, ctwo, cthree, cfour, 3})
																	chat.AddText(Color(255,0,0), "Hit close editor to see the changes!")
																end,
																"#4", function()
																	table.insert(newappstuff,#newappstuff + 1,{"mc", mcq, cone, ctwo, cthree, cfour, 4})
																	chat.AddText(Color(255,0,0), "Hit close editor to see the changes!")
																end)
															end,
															function( text ) end
														)
													end,
													function( text ) end
												)
											end,
											function( text ) end
										)
									end,
									function( text ) end
								)
							end,
							function( text ) end
						)
					end )
					menu:AddOption( "Close", function() end )
					menu:Open()
				end

				local EndEditing = vgui.Create("DButton")
				EndEditing:SetSize(AppList:GetWide(), 20)
				EndEditing:SetText("Close editor")
				EndEditing.DoClick = function()
					net.Start("PBusinessEditApplication")
						net.WriteTable(newappstuff)
					net.SendToServer()
					AppMakeForm:Close()
				end
				AppList:AddItem( CreateNewField )
				AppList:AddItem( EndEditing )
			end
		end)

		local ViewApps = vgui.Create("DButton", DFrame)
		ViewApps:SetSize(500, 20)
		ViewApps:Center()
		ViewApps:SetText("Click here to view job applications!")
		ViewApps:SetTextColor(Color(0,0,0))
		ViewApps.Paint = function( s, w, h )
			s:SetFont("DermaLarge")
		end
		ViewApps.DoClick = function()
			ViewApps:Remove()

			local AppList = vgui.Create( "DListView", DFrame )
			AppList:SetPos(20, 150)
			AppList:SetSize(500, 200)
			AppList:SetMultiSelect( false )
			AppList:AddColumn( "Applicant Name" )
			AppList:AddColumn( "Job Compatibility" )
			AppList:AddColumn( "Application Date" )
--			for k, v in pairs() do
--				AppList:AddLine( "PesterChum", "2mb" )
--			end
		end

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
	self.DataKept = {}
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

net.Receive("PBusinessSendCEODeskData",function()
	local application = net.ReadTable()
	LocalPlayer().PBusinessApplication = application
end)
