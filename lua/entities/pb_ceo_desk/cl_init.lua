include("shared.lua")

function ENT:Draw()
    self:DrawModel()
    if !IsValid(self.PhoneModel) then
        self.PhoneModel = ents.CreateClientProp()
        self.PhoneModel:SetPos( self:GetPos() + Vector(0,0,35) )
    	self.PhoneModel:SetModel( "models/props/cs_office/phone.mdl" )
    	self.PhoneModel:SetParent( self )
    	self.PhoneModel:Spawn()
    end
end

function ENT:OnRemove()
    if IsValid(self.PhoneModel) then
        self.PhoneModel:Remove()
    end
end
