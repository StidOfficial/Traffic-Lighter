AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:SetLight(color)
	self:SetNWString("Light", tostring(color))
end

function ENT:GetLight()
	local ColorOutput = Color(255, 255, 255, 255)
	local TableColor = string.Split(self:GetNWString("Light"), " ")
	if table.Count(TableColor) == 4 then
		ColorOutput = Color(TableColor[1], TableColor[2], TableColor[3], TableColor[4])
	end
	return ColorOutput
end

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/stoplight.mdl")

	self:SetLight(TRAFFIC_LIGHT_START)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	local ENT = self
	local function Traffic()
		if ENT:GetLight() == TRAFFIC_LIGHT_STOP then
			ENT:SetLight(TRAFFIC_LIGHT_START)
		elseif ENT:GetLight() == TRAFFIC_LIGHT_START then
			ENT:SetLight(TRAFFIC_LIGHT_WAIT)
			timer.Simple(TRAFFIC_LIGHTER_CONFIG[self:GetModel()].TimerWait, function()
				ENT:SetLight(TRAFFIC_LIGHT_STOP)
			end)
		end
	end
	timer.Create("TrafficLight_"..self:GetCreationID(), TRAFFIC_LIGHTER_CONFIG[self:GetModel()].Timer, 0, Traffic)
end
 
function ENT:Use(activator, caller)
    return;
end

function ENT:OnRemove()
	timer.Stop("TrafficLight_"..self:GetCreationID())
	timer.Destroy("TrafficLight_"..self:GetCreationID())
end
