AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local entmeta = FindMetaTable("Entity")
util.AddNetworkString("PBusinessEditApplication")
util.AddNetworkString("PBusinessSendCEODeskData")

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
		self.PBusinessApplications = businessinfo.applications
		self.PBusinessApplication = businessinfo.application
		net.Start("PBusinessSendCEODeskData")
			net.WriteTable(self.PBusinessApplications)
			net.WriteTable(self.PBusinessApplication)
		net.Send(self:Getowning_ent())
	end
end

function ENT:OnTakeDamage( dmg )
	self:TakePhysicsDamage(dmg)

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		self:Remove()
	end
end

net.Receive("PBusinessEditApplication",function(len, ply)
	local thenewapp = net.ReadTable()
	if ply:HasBusiness() then
		print("Ran")
		PrintTable(thenewapp)
		ply:GetCEODesk().PBusinessApplication = thenewapp
		net.Start("PBusinessSendCEODeskData")
			net.WriteTable(ply:GetCEODesk().PBusinessApplications)
			net.WriteTable(ply:GetCEODesk().PBusinessApplication)
		net.Send(ply)
	end
end)

concommand.Add("removeceodesk",function(ply)
	for k, v in pairs(ents.FindByClass("pb_ceo_desk")) do
		if v:Getowning_ent() == ply then v:Remove() end
	end
end)
