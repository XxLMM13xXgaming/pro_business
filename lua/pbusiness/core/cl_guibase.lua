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
