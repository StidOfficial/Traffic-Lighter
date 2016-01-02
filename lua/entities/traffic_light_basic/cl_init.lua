include("shared.lua");

function ENT:GetLight()
	local ColorOutput = Color(255, 255, 255, 255)
	local TableColor = string.Split(self:GetNWString("Light"), " ")
	if table.Count(TableColor) == 4 then
		ColorOutput = Color(TableColor[1], TableColor[2], TableColor[3], TableColor[4])
	end
	return ColorOutput
end

function ENT:Draw()
	self:DrawModel()
end	

function ENT:Think()	
	local dlight = DynamicLight(self:EntIndex())
	if (dlight) then
		if self:GetLight() == TRAFFIC_LIGHT_START then
			dlight.pos = self:GetPos() + self:GetUp()*-12.5 + self:GetForward()*4 + self:GetRight()*0
		elseif self:GetLight() == TRAFFIC_LIGHT_WAIT then
			dlight.pos = self:GetPos() + self:GetUp()*-0.5 + self:GetForward()*4 + self:GetRight()*0
		elseif self:GetLight() == TRAFFIC_LIGHT_STOP then		
			dlight.pos = self:GetPos() + self:GetUp()*12.5 + self:GetForward()*4 + self:GetRight()*0
		end
		
		dlight.r = self:GetLight()["r"]
		dlight.g = self:GetLight()["g"]
		dlight.b = self:GetLight()["b"]
		dlight.brightness = 1
		dlight.Size = 150
		dlight.noworld = false
		dlight.DieTime =CurTime() + 1
	end
end
