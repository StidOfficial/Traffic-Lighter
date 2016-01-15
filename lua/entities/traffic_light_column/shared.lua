ENT.Base			= "base_entity"
ENT.Type			= "anim"

ENT.PrintName		= "Traffic Light - Column"
ENT.Author			= "StidOfficial"
ENT.Contact			= "http://steamcommunity.com/id/stid"
ENT.Purpose			= "Traffic Lighter Script"
ENT.Instructions	= "Use wisely"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.Category		= "Traffic Lighter"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Light")
	self:NetworkVar("Int", 0, "Timer")
	self:NetworkVar("Int", 1, "TimerWait")
	
	self:NetworkVar("String", 1, "LightStart")
	self:NetworkVar("String", 2, "LightWait")
	self:NetworkVar("String", 3, "LightStop")
end