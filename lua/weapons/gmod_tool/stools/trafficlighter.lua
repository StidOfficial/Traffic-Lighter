TOOL.Category = "Construction"
TOOL.Name = "Traffic Lighter"

if CLIENT then
	language.Add("tool.trafficlighter.name", "Traffic Lighter")
	language.Add("tool.trafficlighter.desc", "Create Traffic Lighter.")
	language.Add("tool.trafficlighter.0", "Left-click: Create Traffic Lighter. Right-click: Edit Traffic Lighter.")
	language.Add("Undone_TrafficLight", "Undone Traffic Light")
end
	
local TimerLight = CreateClientConVar("timer", "20", false, false)
local TimerLight_Wait = CreateClientConVar("timer_wait", "5", false, false)

local TrafficLight_Model = CreateClientConVar("trafficlight_model", "traffic_light_basic", false, false)

local color_light_stop_r = CreateClientConVar("color_light_stop_r", "255", false, false)
local color_light_stop_g = CreateClientConVar("color_light_stop_g", "0", false, false)
local color_light_stop_b = CreateClientConVar("color_light_stop_b", "0", false, false)
local color_light_stop_a = CreateClientConVar("color_light_stop_a", "255", false, false)

local color_light_wait_r = CreateClientConVar("color_light_wait_r", "255", false, false)
local color_light_wait_g = CreateClientConVar("color_light_wait_g", "128", false, false)
local color_light_wait_b = CreateClientConVar("color_light_wait_b", "0", false, false)
local color_light_wait_a = CreateClientConVar("color_light_wait_a", "255", false, false)

local color_light_start_r = CreateClientConVar("color_light_start_r", "0", false, false)
local color_light_start_g = CreateClientConVar("color_light_start_g", "150", false, false)
local color_light_start_b = CreateClientConVar("color_light_start_b", "0", false, false)
local color_light_start_a = CreateClientConVar("color_light_start_a", "255", false, false)

function TOOL:LeftClick(trace, attach)
	if (IsValid(trace.Entity) && trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return true end
	
	if (SERVER && !util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone)) then
		return false
	end
	
	local ply = self:GetOwner()
	local TrafficLight = ents.Create(TrafficLight_Model:GetString())
	
	if (!IsValid(TrafficLight)) then return end
	TrafficLight.Owner = ply
	
	TrafficLight:SetPos(trace.HitPos)
	TrafficLight:Spawn()
	
	TrafficLight:SetTimer(TimerLight:GetFloat())
	TrafficLight:SetTimerWait(TimerLight_Wait:GetFloat())
	
	TrafficLight:SetLightStop(tostring(Color(color_light_stop_r:GetFloat(), color_light_stop_g:GetFloat(), color_light_stop_b:GetFloat(), color_light_stop_a:GetFloat())))
	TrafficLight:SetLightWait(tostring(Color(color_light_wait_r:GetFloat(), color_light_wait_g:GetFloat(), color_light_wait_b:GetFloat(), color_light_wait_a:GetFloat())))
	TrafficLight:SetLightStart(tostring(Color(color_light_start_r:GetFloat(), color_light_start_g:GetFloat(), color_light_start_b:GetFloat(), color_light_start_a:GetFloat())))
	
	TrafficLight:SetLight(TrafficLight:GetLightStart())
	
	undo.Create("TrafficLight")
		undo.AddEntity(TrafficLight)	
	undo.SetPlayer(ply)
	undo.Finish()
	
	ply:AddCleanup("traffic_light_basic", TrafficLight)
	
	return true
end

function TOOL:RightClick(trace)
	if IsValid(trace.Entity) && (trace.Entity:GetClass() == "traffic_light_column" || trace.Entity:GetClass() == "traffic_light_basic") && trace.Entity.Owner == self:GetOwner() then
		timer.Stop("TrafficLight_"..trace.Entity:GetCreationID())
		timer.Destroy("TrafficLight_"..trace.Entity:GetCreationID())
	
		trace.Entity:SetTimer(TimerLight:GetFloat())
		trace.Entity:SetTimerWait(TimerLight_Wait:GetFloat())
		
		trace.Entity:SetLightStop(tostring(Color(color_light_stop_r:GetFloat(), color_light_stop_g:GetFloat(), color_light_stop_b:GetFloat(), color_light_stop_a:GetFloat())))
		trace.Entity:SetLightWait(tostring(Color(color_light_wait_r:GetFloat(), color_light_wait_g:GetFloat(), color_light_wait_b:GetFloat(), color_light_wait_a:GetFloat())))
		trace.Entity:SetLightStart(tostring(Color(color_light_start_r:GetFloat(), color_light_start_g:GetFloat(), color_light_start_b:GetFloat(), color_light_start_a:GetFloat())))
		
		trace.Entity:SetLight(trace.Entity:GetLightStart())
		
		local function Traffic()
			if trace.Entity:GetLight() == trace.Entity:GetLightStop() then
				trace.Entity:SetLight(trace.Entity:GetLightStart())
			elseif trace.Entity:GetLight() == trace.Entity:GetLightStart() then
				trace.Entity:SetLight(trace.Entity:GetLightWait())
				timer.Simple(trace.Entity:GetTimerWait(), function()
					if IsValid(trace.Entity) then
						trace.Entity:SetLight(trace.Entity:GetLightStop())
					end
				end)
			end
		end
		timer.Create("TrafficLight_"..trace.Entity:GetCreationID(), trace.Entity:GetTimer(), 0, Traffic)
		
		return true
	end
	
	return false
end

function TOOL:Reload(trace)
	if (!IsValid(trace.Entity) || trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return true end

	return constraint.RemoveAll(trace.Entity)
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", { Text = "Traffic Lighter", Description = "Create Custom Traffic Lighter" })
	
	CPanel:AddControl("Slider", {
	    Label = "Timer Light :",
	    Type = "Float",
	    Min = "0",
	    Max = "1000",
	    Command = "timer"
	})
	
	CPanel:AddControl("Slider", {
	    Label = "Timer Light Wait :",
	    Type = "Float",
	    Min = "0",
	    Max = "1000",
	    Command = "timer_wait"
	})
	
	CPanel:AddControl("Color", {
	    Label = "Color Light Stop :",
	    Red = "color_light_stop_r",
	    Blue = "color_light_stop_b",
	    Green = "color_light_stop_g",
	    Alpha = "color_light_stop_a",
	    ShowHSV = 1,
	    ShowRGB = 1,
	    Multiplier = 255
	})
	
	CPanel:AddControl("Color", {
	    Label = "Color Light Wait :",
	    Red = "color_light_wait_r",
	    Blue = "color_light_wait_b",
	    Green = "color_light_wait_g",
	    Alpha = "color_light_wait_a",
	    ShowHSV = 1,
	    ShowRGB = 1,
	    Multiplier = 255
	})
	
	CPanel:AddControl("Color", {
	    Label = "Color Light Start :",
	    Red = "color_light_start_r",
	    Blue = "color_light_start_b",
	    Green = "color_light_start_g",
	    Alpha = "color_light_start_a",
	    ShowHSV = 1,
	    ShowRGB = 1,
	    Multiplier = 255
	})
	
	CPanel:AddControl("PropSelect", {
		Label = "Model :",
		ConVar = "trafficlight_model",
		Height = 4,
		ModelsTable = list.Get("TrafficLightModels")
	})
end

list.Set("TrafficLightModels", "traffic_light_basic", {model = "models/props_c17/traffic_light001a.mdl", skin = 0})
list.Set("TrafficLightModels", "traffic_light_column", {model = "models/props/cs_assault/stoplight.mdl", skin = 0})