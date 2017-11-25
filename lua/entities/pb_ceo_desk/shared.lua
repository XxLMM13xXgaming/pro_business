ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "CEO Desk"
ENT.Author = "XxLMM13xXgaming"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Category = "Pro Business"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("String", 1, "PBusinessName")
	self:NetworkVar("Table", 2, "PBusinessApplications")
	self:NetworkVar("Table", 3, "PBusinessApplication")
end
