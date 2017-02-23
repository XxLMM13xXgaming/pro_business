net.Receive("PBusinessOpenMainMenu",function()
  local DFrame = vgui.Create( "DFrame" )
  DFrame:SetSize( 300, 200 )
  DFrame:SetTitle( "" )
  DFrame:Center()
  DFrame:SetDraggable( true )
  DFrame:ShowCloseButton(true)
  DFrame:MakePopup()

  CreateBus = vgui.Create("DButton", DFrame)
  CreateBus:SetPos(10, 50)
  CreateBus:SetSize(DFrame:GetWide() - 20, 20)
  CreateBus:SetText("Create Business")
  CreateBus.DoClick = function()
    net.Start("PBusinessCreateBusinessPicked")
    net.SendToServer()
    DFrame:Close()
  end
end)

net.Receive("PBusinessCreateBusiness",function()
  local DFrame = vgui.Create( "DFrame" )
  DFrame:SetSize( 300, 200 )
  DFrame:SetTitle( "" )
  DFrame:Center()
  DFrame:SetDraggable( true )
  DFrame:ShowCloseButton(true)
  DFrame:MakePopup()

  local BNameLabel = vgui.Create("DLabel", DFrame)
  BNameLabel:SetPos(10, 50)
  BNameLabel:SetSize(DFrame:GetWide(), 20)
  BNameLabel:SetText("What will be your businesses name?")

  local BNameTE = vgui.Create("DTextEntry", DFrame)
  BNameTE:SetPos(10, 75)
  BNameTE:SetSize(DFrame:GetWide() - 20, 20)
  BNameTE:SetText("Business Name")

  local BDescLabel = vgui.Create("DLabel", DFrame)
  BDescLabel:SetPos(10, 105)
  BDescLabel:SetSize(DFrame:GetWide(), 20)
  BDescLabel:SetText("What will be your businesses description?")

  local BDescTE = vgui.Create("DTextEntry", DFrame)
  BDescTE:SetPos(10, 130)
  BDescTE:SetSize(DFrame:GetWide() - 20, 40)
  BDescTE:SetMultiline(true)
  BDescTE:SetText("Business Description")

  local CreateBtn = vgui.Create("DButton", DFrame)
  CreateBtn:SetPos(10, 175)
  CreateBtn:SetSize(DFrame:GetWide() - 20, 20)
  CreateBtn:SetText("Create Business")
  CreateBtn.DoClick = function()
    if string.len(BNameTE:GetValue()) > 20 then
      LocalPlayer():ChatPrint("Please make sure the business name is less than 20 characters!")
    elseif string.len(BDescTE:GetValue()) > 80 then
      LocalPlayer():ChatPrint("Please make sure the business description is less than 80 characters!")
    else
      net.Start("PBusinessCreateBusinessCreated")
        net.WriteString(BNameTE:GetValue())
        net.WriteString(BDescTE:GetValue())
      net.SendToServer()
      DFrame:Close()
    end
  end
end)
