AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local entmeta = FindMetaTable("Entity")

function ENT:Initialize()
	self:SetModel("models/props_combine/breendesk.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:DropToFloor()
	self.damage = 100

	if self:Getowning_ent():HasBusiness() then
		local businessinfo = self:Getowning_ent():GetBusinessInfo()
		self:SetPBusinessName(businessinfo.bname)
	end
end

function ENT:OnTakeDamage( dmg )
	self:TakePhysicsDamage(dmg)

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		self:Remove()
	end
end

concommand.Add("removeceodesk",function(ply)
	for k, v in pairs(ents.FindByClass("pb_ceo_desk")) do
		if v:Getowning_ent() == ply then v:Remove() end
	end
end)
