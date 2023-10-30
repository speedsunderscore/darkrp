AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props_interiors/tablecafe_square01.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

    self.nextUse = 0

end

util.AddNetworkString("Mining.UseBench")
function ENT:Use( ply )

    if (IsValid(ply) and ply:GetEyeTrace().Entity == self) then
        
        if (self.nextUse > CurTime())  then return end

        self.nextUse = CurTime() + 1

        net.Start("Mining.UseBench")

        net.Send(ply)

    end

end
