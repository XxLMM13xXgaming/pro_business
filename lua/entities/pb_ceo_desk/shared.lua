ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "CEO Desk"
ENT.Author = "XxLMM13xXgaming"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Category = "Pro Business"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end
