net.Receive("PBusinessAddBusinessToClient",function()
    local thebusinesses = net.ReadTable()
    LocalPlayer().PBusinessBusinesses = thebusinesses
end)

net.Receive("PBusinessUpdateBusinessToClient",function()
    local thebusinesses = net.ReadTable()
    for bid, b in pairs(thebusinesses) do
        for k, v in pairs(b.application[1]) do
            if v[1] == "mc" then
                v[7] = "NICE TRY"
            end
        end
        b.applications = nil
    end
    LocalPlayer().PBusinessBusinesses = thebusinesses
end)

function PBusinessOpenApplication(bid)
    local thebussiness = {}
    local DFrame = vgui.Create("DFrame")
    DFrame:SetSize(500,700)
    DFrame:SetTitle("")
    DFrame:ShowCloseButton(false)
    DFrame:SetDraggable(false)
    DFrame:Center()
    DFrame:MakePopup()
    DFrame.Paint = function(s, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
        draw.SimpleText("Job application","PBusinessTitleFont",w / 2,10,Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
    end

    local closeBtn = vgui.Create("DButton", DFrame)
    closeBtn:SetPos(DFrame:GetWide() - 20, 10)
    closeBtn:SetSize(10,10)
    closeBtn:SetText("X")
    closeBtn:SetFont("PBusinessFontClose")
    closeBtn:SetTextColor(Color(0,0,0,255))
    closeBtn.DoClick = function() DFrame:Close() end
    closeBtn.Paint = function() end

    local Application = vgui.Create( "DPanelList", DFrame )
    Application:SetPos(20, 40)
    Application:SetSize(DFrame:GetWide() - 40, DFrame:GetTall() - 80)
    Application:SetSpacing( 2 )
    Application:EnableVerticalScrollbar( true )
    Application.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,70))
    end
    Application.VBar.btnUp.Paint = function( s, w, h ) end
    Application.VBar.btnDown.Paint = function( s, w, h ) end
    Application.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 4, 5, 0, 4, h + 22, Color(0,0,0,70))
    end

    for k, v in pairs(LocalPlayer().PBusinessBusinesses) do
        if v.id == bid then
            thebussiness = v
        end
    end

    for k, v in pairs(thebussiness.application[1]) do
        if v[1] == "ste" then
            local ApplicationQuestion = vgui.Create("DFrame")
            ApplicationQuestion:SetSize(Application:GetWide(), 60)
            ApplicationQuestion:ShowCloseButton(false)
            ApplicationQuestion:SetTitle("")
            ApplicationQuestion.Paint = function(s, w, h)
                draw.RoundedBox(0,0,0,w,h,Color(45,45,45,150))
                draw.SimpleText(v[2], "PBusinessLabelFont",10,10,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            end

            local shortAnswer = vgui.Create("DTextEntry", ApplicationQuestion)
            shortAnswer:SetPos(10, 30)
            shortAnswer:SetSize(ApplicationQuestion:GetWide() - 20, 20)
            shortAnswer:SetValue("Answer")

            Application:AddItem(ApplicationQuestion)
        elseif v[1] == "lte" then
            local ApplicationQuestion = vgui.Create("DFrame")
            ApplicationQuestion:SetSize(Application:GetWide(), 80)
            ApplicationQuestion:ShowCloseButton(false)
            ApplicationQuestion:SetTitle("")
            ApplicationQuestion.Paint = function(s, w, h)
                draw.RoundedBox(0,0,0,w,h,Color(45,45,45,150))
                draw.SimpleText(v[2], "PBusinessLabelFont",10,10,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            end

            local shortAnswer = vgui.Create("DTextEntry", ApplicationQuestion)
            shortAnswer:SetPos(10, 30)
            shortAnswer:SetSize(ApplicationQuestion:GetWide() - 20, 40)
            shortAnswer:SetMultiline(true)
            shortAnswer:SetValue("Answer")

            Application:AddItem(ApplicationQuestion)
        elseif v[1] == "mc" then
            local fourAnswers = {v[3], v[4], v[5], v[6]}

            local function PBMathRand(min, max, exclude)
                thenum = math.random(min, max)
                if istable(exclude) and table.HasValue(exclude,thenum) then
                    PBMathRand(min, max, exclude)
                end
                return thenum
            end

            option1 = PBMathRand(1, 4)
            option2 = PBMathRand(1, 4, {option1})
            option3 = PBMathRand(1, 4, {option1, option2})
            option4 = PBMathRand(1, 4, {option1, option2, option3})

            local ApplicationQuestion = vgui.Create("DFrame")
            ApplicationQuestion:SetSize(Application:GetWide(), 115)
            ApplicationQuestion:ShowCloseButton(false)
            ApplicationQuestion:SetTitle("")
            ApplicationQuestion.Paint = function(s, w, h)
                draw.RoundedBox(0,0,0,w,h,Color(45,45,45,150))
                draw.SimpleText(v[2], "PBusinessLabelFont",10,10,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

                draw.SimpleText(fourAnswers[option1], "PBusinessLabelFont",30,30,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
                draw.SimpleText(fourAnswers[option2], "PBusinessLabelFont",30,50,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
                draw.SimpleText(fourAnswers[option3], "PBusinessLabelFont",30,70,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
                draw.SimpleText(fourAnswers[option4], "PBusinessLabelFont",30,90,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            end

            v.option1Chk = vgui.Create( "DCheckBox", ApplicationQuestion )
            v.option1Chk:SetPos( 10, 30 )
            v.option1Chk:SetValue( 0 )
            v.option1Chk.OnChange = function( bVal )
                if !bVal then return end
                if v.option2Chk:GetChecked() or v.option3Chk:GetChecked() or v.option4Chk:GetChecked() then
                    v.option2Chk:SetChecked(false)
                    v.option3Chk:SetChecked(false)
                    v.option4Chk:SetChecked(false)
                end
            end

            v.option2Chk = vgui.Create( "DCheckBox", ApplicationQuestion )
            v.option2Chk:SetPos( 10, 50 )
            v.option2Chk:SetValue( 0 )
            v.option2Chk.OnChange = function( bVal )
                if !bVal then return end
                if v.option1Chk:GetChecked() or v.option3Chk:GetChecked() or v.option4Chk:GetChecked() then
                    v.option1Chk:SetChecked(false)
                    v.option3Chk:SetChecked(false)
                    v.option4Chk:SetChecked(false)
                end
            end

            v.option3Chk = vgui.Create( "DCheckBox", ApplicationQuestion )
            v.option3Chk:SetPos( 10, 70 )
            v.option3Chk:SetValue( 0 )
            v.option3Chk.OnChange = function( bVal )
                if !bVal then return end
                if v.option1Chk:GetChecked() or v.option2Chk:GetChecked() or v.option4Chk:GetChecked() then
                    v.option1Chk:SetChecked(false)
                    v.option2Chk:SetChecked(false)
                    v.option4Chk:SetChecked(false)
                end
            end

            v.option4Chk = vgui.Create( "DCheckBox", ApplicationQuestion )
            v.option4Chk:SetPos( 10, 90 )
            v.option4Chk:SetValue( 0 )
            v.option4Chk.OnChange = function( bVal )
                if !bVal then return end
                if v.option1Chk:GetChecked() or v.option2Chk:GetChecked() or v.option3Chk:GetChecked() then
                    v.option1Chk:SetChecked(false)
                    v.option2Chk:SetChecked(false)
                    v.option3Chk:SetChecked(false)
                end
            end

            Application:AddItem(ApplicationQuestion)
        end
    end

    local submitApp = vgui.Create("DButton", DFrame)
    submitApp:SetPos(10, DFrame:GetTall() - 30)
    submitApp:SetSize(DFrame:GetWide() - 20, 20)
    submitApp:SetText("Submit application")
    submitApp.DoClick = function()
        for k, v in pairs(thebussiness.application[1]) do
            if v[1] == "mc" then
                v.option1Chk = v.option1Chk:GetChecked()
                v.option2Chk = v.option2Chk:GetChecked()
                v.option3Chk = v.option3Chk:GetChecked()
                v.option4Chk = v.option4Chk:GetChecked()
                v.o1c = nil
                v.o2c = nil
                v.o3c = nil
                v.o4c = nil
            end
        end
        PrintTable(thebussiness.application[1])
        net.Start("PBusinessSubmitApplication")
            net.WriteFloat(bid)
            net.WriteTable(thebussiness.application[1])
        net.SendToServer()
    end
end

net.Receive("PBusinessOpenJobSearch",function()
    local noJobs = false
    local DFrame = vgui.Create("DFrame")
    DFrame:SetSize(500,700)
    DFrame:SetTitle("")
    DFrame:ShowCloseButton(false)
    DFrame:SetDraggable(false)
    DFrame:Center()
    DFrame:MakePopup()
    DFrame.Paint = function(s, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
        draw.SimpleText("Job search","PBusinessTitleFont",w / 2,10,Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if noJobs then
            draw.SimpleText("There are no jobs available! Create a business now!","PBusinessTitleFont",w / 2,h / 2,Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    local closeBtn = vgui.Create("DButton", DFrame)
    closeBtn:SetPos(DFrame:GetWide() - 20, 10)
    closeBtn:SetSize(10,10)
    closeBtn:SetText("X")
    closeBtn:SetFont("PBusinessFontClose")
    closeBtn:SetTextColor(Color(0,0,0,255))
    closeBtn.DoClick = function() DFrame:Close() end
    closeBtn.Paint = function() end

    local JobList = vgui.Create( "DPanelList", DFrame )
    JobList:SetPos(20, 40)
    JobList:SetSize(DFrame:GetWide() - 40, DFrame:GetTall() - 80)
    JobList:SetSpacing( 2 )
    JobList:EnableVerticalScrollbar( true )
    JobList.VBar.Paint = function( s, w, h )
        draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,70))
    end
    JobList.VBar.btnUp.Paint = function( s, w, h ) end
    JobList.VBar.btnDown.Paint = function( s, w, h ) end
    JobList.VBar.btnGrip.Paint = function( s, w, h )
        draw.RoundedBox( 4, 5, 0, 4, h + 22, Color(0,0,0,70))
    end

    if LocalPlayer().PBusinessBusinesses == nil or #LocalPlayer().PBusinessBusinesses <= 0 then
        noJobs = true
        return
    end

    for k, v in pairs(LocalPlayer().PBusinessBusinesses) do
--        PrintTable(v)
        local JobEntry = vgui.Create("DFrame")
        JobEntry:SetSize(JobList:GetWide(), 90)
        JobEntry:ShowCloseButton(false)
        JobEntry:SetTitle("")
        JobEntry.Paint = function(s, w, h)
            draw.RoundedBox(0,0,0,w,h,Color(45,45,45,150))
            draw.SimpleText("Business Name: " .. v.bname, "PBusinessLabelFont",10,10,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            draw.SimpleText("In the " .. v.btype .. " depo.", "PBusinessLabelFont",10,25,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
            draw.SimpleText(#v.employees .. " employee(s).", "PBusinessLabelFont",10,40,Color( 0, 0, 0, 255 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        end

        local OwnerAvatar = vgui.Create( "AvatarImage", JobEntry )
        OwnerAvatar:SetSize( 32, 32 )
        OwnerAvatar:SetPos( JobEntry:GetWide() - 40, 10 )
        OwnerAvatar:SetPlayer( v.employees[1].player, 64 )

        local applyBtn = vgui.Create("DButton", JobEntry)
        applyBtn:SetPos(10, JobEntry:GetTall() - 25)
        applyBtn:SetSize(JobEntry:GetWide() - 20, 20)
        applyBtn:SetText("Apply")
        applyBtn.DoClick = function()
            if #v.application < 1 or #v.application[1] < 1 then
                Derma_Query( "This businesses has not set up their application... What would you like to do next?", "Application failed", "Nothing take me back!", function() end, "Write PB-Mail to business CEO", function()
                    Derma_StringRequest(
                    	"PB-Mail Compose",
                    	"What would you like to say to " .. v.employees[1].player:Nick(),
                    	"",
                    	function( text )
                            net.Start("PBMailCompose")
                                net.WriteEntity(v.employees[1].player:Nick())
                                net.WriteString(text)
                            net.SendToServer()
                        end,
                    	function( text ) end
                     )
                end)
            else
                PBusinessOpenApplication(v.id)
            end
        end

        JobList:AddItem(JobEntry)
    end
end)
