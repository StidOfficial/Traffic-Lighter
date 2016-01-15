include("shared.lua");

function ColorToTable(color)
	local ColorOutput = Color(255, 255, 255, 255)
	local TableColor = string.Split(color, " ")
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
		if self:GetLight() == self:GetLightStart() then
			dlight.pos = self:GetPos() + self:GetUp()*106 + self:GetForward()*-7 + self:GetRight()
		elseif self:GetLight() == self:GetLightWait() then
			dlight.pos = self:GetPos() + self:GetUp()*116 + self:GetForward()*-7 + self:GetRight()
		elseif self:GetLight() == self:GetLightStop() then		
			dlight.pos = self:GetPos() + self:GetUp()*126 + self:GetForward()*-7 + self:GetRight()
		end
		
		local ColorTable = ColorToTable(self:GetLight())		
		dlight.r = ColorTable["r"]
		dlight.g = ColorTable["g"]
		dlight.b = ColorTable["b"]
		dlight.brightness = 1
		dlight.Size = 150
		dlight.noworld = false
		dlight.DieTime =CurTime() + 1
	end
end
