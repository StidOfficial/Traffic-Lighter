AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ColorToTable(color)
	local ColorOutput = Color(255, 255, 255, 255)
	local TableColor = string.Split(color, " ")
	if table.Count(TableColor) == 4 then
		ColorOutput = Color(TableColor[1], TableColor[2], TableColor[3], TableColor[4])
	end
	return ColorOutput
end

function ENT:Initialize()
	self:SetModel("models/props_c17/traffic_light001a.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self:SetTimer(TRAFFIC_LIGHTER_CONFIG[self:GetClass()].Timer)
	self:SetTimerWait(TRAFFIC_LIGHTER_CONFIG[self:GetClass()].TimerWait)
	
	self:SetLightStop(tostring(Color(255, 0, 0, 255)))
	self:SetLightWait(tostring(Color(255, 128, 0, 255)))
	self:SetLightStart(tostring(Color(0, 150, 0, 255)))
	
	self:SetLight(self:GetLightStart())
	
	local function Traffic()
		if self:GetLight() == self:GetLightStop() then
			self:SetLight(self:GetLightStart())
		elseif self:GetLight() == self:GetLightStart() then
			self:SetLight(self:GetLightWait())
			timer.Simple(self:GetTimerWait(), function()
				if IsValid(self) then
					self:SetLight(self:GetLightStop())
				end
			end)
		end
	end
	timer.Create("TrafficLight_"..self:GetCreationID(), self:GetTimer(), 0, Traffic)
end
 
function ENT:Use(activator, caller)
    return
end

function ENT:OnRemove()
	timer.Stop("TrafficLight_"..self:GetCreationID())
	timer.Destroy("TrafficLight_"..self:GetCreationID())
end