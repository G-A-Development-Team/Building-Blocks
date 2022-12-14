function getDPIScale()
    return 0.75 + (gui.GetValue("adv.dpi") * 0.25);
end

-- Script Global Variables {#ffba19, 6}
local GlobalFont = draw.CreateFont("Bahnschrift", 28*getDPIScale())
local GlobalBiggerFont = draw.CreateFont("Bahnschrift", 35*getDPIScale())
local SmallGlobalFont = draw.CreateFont("Bahnschrift", 15*getDPIScale())
local currentBlocks = {}
local abortDrag = false
local bool_AvailableBlocks = true
local frame_rate = 0.0

-- GUIAPI Custom Controller {#f2aeae, 272}
function gui._Custom(ref, varname, name, x, y, w, h, paint, custom_vars)
	local tbl = {val = 0}

	local function read(v)
		tbl.val = v
	end

	local function write()
		return tbl.val
	end
	
	local function is_in_rect(x, y, x1, y1, x2, y2)
		return x >= x1 and x < x2 and y >= y1 and y < y2;
	end
	
	local GuiObject = {
		element = nil,
		custom_vars = custom_vars or {},
		name = name,
		_element_pos_x = x,
		_element_pos_y = y,
		selected = false,
		dragging = false,
		_element_width = w,
		_element_height = h,
		MoveRestraintx = 0,
		MoveRestrainty = 0,
		MoveRestraintw = 0,
		MoveRestrainth = 0,
		maxdragx = 0,
		maxdragy = 0,
		maxdragwidth = 0,
		maxdragheight = 0,
		text = "",
		_parent = ref,
		_mouse_left_released = true,
		_old_mouse_left_released = true,	
		_mouse_hovering = false,
		_old_mouse_hovering = false,
		customvalue,
		using = false,
		CustomOptions = {
			LastChangeX = 0,
		},
		
		SetUsing = function(self, v)
			self.using = v
		end,
		
		GetUsing = function(self)
			return self.using
		end,
		
		GetCustomValue = function(self)
			return self.customvalue
		end,
		
		SetCustomValue = function(self, v)
			self.customvalue = v
		end,

		GetDragStatus = function(self)
			return self.dragging
		end,
		
		SetDragStatus = function(self, bool)
			self.dragging = bool
		end,
		
		GetSelected = function(self)
			return self.selected
		end,
		
		SetSelected = function(self, bool)
			self.selected = bool
		end,
		
		GetMoveRestraintX = function(self)
			return self.MoveRestraintx
		end,

		GetMoveRestraintY = function(self)
			return self.MoveRestrainty
		end,

		GetMoveRestraintWidth = function(self)
			return self.MoveRestraintw
		end,

		GetMoveRestraintHeight = function(self)
			return self.MoveRestrainth
		end,
		
		SetMoveRestraintX = function(self, x)
			self.MoveRestraintx = x
		end,

		SetMoveRestraintY = function(self, y)
			self.MoveRestrainty = y
		end,

		SetMoveRestraintWidth = function(self, w)
			self.MoveRestraintw = w
		end,

		SetMoveRestraintHeight = function(self, h)
			self.MoveRestrainth = h
		end,
			
		GetValue = function(self)
			return self.element:GetValue()
		end,
		
		GetText = function(self)
			return self.text
		end,

		SetText = function(self, text)
			self.text = text
		end,
		
		SetValue = function(self, value)
			return self.element:SetValue(value)
		end,
		
		GetName = function(self)
			return self.name
		end,
		
		SetName = function(self, name)
			self.name = name
		end,
		
		SetPosX = function(self, x)
			self.element:SetPosX(x)
			self._element_pos_x = x
		end,
		
		SetPosY = function(self, y)
			self.element:SetPosY(y)
			self._element_pos_y = y
		end,
		
		SetPos = function(self, x, y)
			self.element:SetPosX(x)
			self.element:SetPosY(y)
			self._element_pos_x = x
			self._element_pos_y = y
		end,
		
		GetPos = function(self)
			return self._element_pos_x, self._element_pos_y
		end,
		
		GetX = function(self)
			return self._element_pos_x
		end,
		
		GetY = function(self)
			return self._element_pos_y
		end,
		
		SetWidth = function(self, width)
			self.element:SetWidth(width)
			self._element_width = width
		end,
		
		SetHeight = function(self, height)
			self.element:SetHeight(height)
			self._element_height = height
		end,
		
		SetSize = function(self, w, h)
			self.element:SetWidth(w)
			self.element:SetHeight(h)
			self._element_width = w
			self._element_height = h
		end,
		
		GetSize = function(self)
			return self._element_width, self._element_height 
		end,
		
		GetHeight = function(self)
			return self._element_height 
		end,
		
		GetWidth = function(self)
			return self._element_width 
		end,
		
		SetVisible = function(self, b)
			self.element:SetInvisible(not b)
		end,
		
		SetInvisible = function(self, b)
			self.element:SetInvisible(b)
		end,
		
		GetParent = function(self)
			return self._parent
		end,
		
		SetMaxDragX = function(self, x)
			self.maxdragx = x
		end,
		
		SetMaxDragY = function(self, y)
			self.maxdragy = y
		end,
		
		GetMaxDragX = function(self)
			return self.maxdragx
		end,
		
		GetMaxDragY = function(self)
			return self.maxdragy
		end,
		
		GetMaxDragWidth = function(self)
			return self.maxdragwidth
		end,
		
		GetMaxDragHeight = function(self)
			return self.maxdragheight
		end,
		
		SetMaxDragWidth = function(self, width)
			self.maxdragwidth = width
		end,
		
		SetMaxDragHeight = function(self, height)
			self.maxdragheight = height
		end,
		
		OnClick = function(self) -- you rewrite this function when creating elements
			
		end,
				
		hovering = function(x, y, x2, y2)
			local mx, my = input.GetMousePos()
			return is_in_rect(mx, my, x, y, x2, y2)
		end,

		OnHovered = function(self)
			
		end,	
	}
	
	local meta = {__index = custom_vars}
	setmetatable(GuiObject, meta)
	
	local function _paint(x, y, x2, y2, active)
		local mx, my = input.GetMousePos()
		local hovering = GuiObject.hovering(x, y, x2, y2)
		
		if hovering then
			GuiObject._mouse_hovering = true		
			if input.IsButtonReleased(1) then
				GuiObject._mouse_left_released = true
			end
		
			if input.IsButtonDown(1) then
				GuiObject._mouse_left_released = false
			end
		
			if GuiObject._mouse_left_released ~= GuiObject._old_mouse_left_released then
				if not GuiObject._mouse_left_released then -- Clicked
					GuiObject:OnClick()
				end
				GuiObject._old_mouse_left_released = GuiObject._mouse_left_released
			end
		else
			GuiObject._mouse_hovering = false
		end

		if GuiObject._old_mouse_hovering ~= GuiObject._mouse_hovering then
			-- print(GuiObject._mouse_hovering)
---@diagnostic disable-next-line: redundant-parameter
			GuiObject:OnHovered(GuiObject._mouse_hovering)
			GuiObject._old_mouse_hovering = GuiObject._mouse_hovering
		end
		
		local width = x2 - x
		local height = y2 - y
		paint(x, y, x2, y2, active, GuiObject, width, height)
	end
	
	local custom = gui.Custom(ref, varname, x, y, w, h, _paint, write, read)
	GuiObject.element = custom
	
	return GuiObject
end

-- Script DPI Conversion {#a8f582, 14}
local dpis, dpi_scales = 0, {0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3}
dpis = dpi_scales[gui.GetValue("adv.dpi")+1]

local function convertDpi(number)
    if dpis == 0.75 then
        local s = dpis/100
        return number * (number * s)
    else
        if dpis == 1 then
            return number
        end
        return number * dpis
    end
end

function center(itemW, itemH, W, H)
	return (W/2)-(itemW/2), (H/2)-(itemH/2)
end

-- GUIAPI Base64 Decoder {#f2aeae, 15}
local function decode(data)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- GUIAPI draw FilledRect {#f2aeae, 7}
function draw._FilledRect(x, y, x2, y2, rounded)
	if rounded ~= nil and rounded then
		draw.RoundedRectFill(x, y, x2, y2, 20)
	else
		draw.FilledRect(x, y, x2, y2)
	end
end

-- GUIAPI draw Rect {#f2aeae, 8}
function draw._Rect(x, y, x2, y2, rounded)
	if rounded ~= nil and rounded then
---@diagnostic disable-next-line: missing-parameter
		draw.RoundedRect(x, y, x2, y2, 20)
	else
		draw.OutlinedRect(x, y, x2, y2)
	end
end

-- GUIAPI draw Color {#f2aeae, 7}
function draw._Color(default, modified, key)
	if modified[key] ~= nil then
		draw.Color(unpack(modified[key]))
	else
		draw.Color(unpack(default[key]))
	end
end

-- GUIAPI GetExist{#f2aeae, 7}
local function GetExist(key, default)
	if key ~= nil then
		return key
	else
		return default
	end
	if key() == nil or key == nil then
		return default
	end
end

-- GUIAPI Control Effects {#f2aeae, 4}
gui.Effects = {
	Hover = function(x, y, x2, y2)
	end
}

--GUIAPI TextBox Control {#f2aeae, 22}
function gui.TextBox(ref, varname, name, tbl, x, y, w, h)
	return gui._Custom(ref, varname, name, x, y, w, h, function(x, y, x2, y2, active, self)
		local Options = self.custom_vars["Options"]
		local DefaultColors = {
			Text = {90, 90, 90, 255},
		}
		if self:GetText() == nil or self:GetText() == "" then
			self:SetText(Options["Text"])
		end
		
		draw.SetFont(SmallGlobalFont)
		draw._Color(DefaultColors, GetExist(Options["Colors"], {}), "Text")
		draw.TextShadow(x, y, self:GetText())
		
		if self._mouse_hovering then
			--print(Options["Effects"]["Hover"])
			if Options["Effects"]["Hover"] ~= nil then gui.Effects["Hover"](x, y, x2, y2) end
		end
	end, {
		Options = tbl["Options"],
	})
end

--GUIAPI PictreBox Control {#f2aeae, 37}
function gui.PictureBox(ref, varname, name, tbl, x, y, w, h)
	local iconRGBA, iconWidth, iconHeight = common.DecodePNG(http.Get(tbl["Image"]["URL"]))
	tbl["Image"]["URL"] = draw.CreateTexture(iconRGBA, iconWidth, iconHeight)

	return gui._Custom(ref, varname, name, x, y, w, h, function(x, y, x2, y2, active, self)
		local Image = self.custom_vars["Image"]
		local Options = self.custom_vars["Options"]
		local DefaultColors = {
			Background = {13, 13, 13, 150},
			Border = {230, 62, 185, 150}
		}
		--print(self._mouse_hovering)
		--Background
		draw._Color(DefaultColors, Options["Colors"], "Background")
		draw._FilledRect(x, y, x2, y2, Options["Rounded"])
		
		--Border
		if Options["Border"] then
			draw._Color(DefaultColors, Options["Colors"], "Border")
			draw._Rect(x, y, x2, y2, Options["Rounded"])
		end
		
		--Image
		draw.Color(255, 255, 255, Image["Brightness"])
		draw.SetTexture(Image["URL"])
		draw.FilledRect(x + GetExist(Image["OffsetX"], 0), y + GetExist(Image["OffsetY"], 0), x + Image["Width"], y + Image["Height"])
		draw.SetTexture(nil)
		
		if self._mouse_hovering then
			--print(Options["Effects"]["Hover"])
			if Options["Effects"]["Hover"] ~= nil then gui.Effects["Hover"](x, y, x2, y2) end
		end
	end, {
		Image = tbl["Image"],
		Options = tbl["Options"],
	})
end

--GUIAPI FilledControl Control {#f2aeae, 216}
function gui.FilledControl(ref, varname, name, tbl, x, y, w, h)
	if tbl["Options"]["Drag"] then
		tbl["Options"]["DragStatus"] = false
		tbl["Options"]["dx"] = 0
		tbl["Options"]["dy"] = 0
	end
	if tbl["Options"]["InverseDrag"] then
		tbl["Options"]["DragStatus"] = false
		tbl["Options"]["AddedX"] = 0
		tbl["Options"]["AddedY"] = 0
		tbl["Options"]["dx"] = 0
		tbl["Options"]["dy"] = 0
	end
	if tbl["Options"]["Selected"] == nil then
		tbl["Options"]["Selected"] = true
	end
	if tbl["Options"]["ScrollAffective"] ~= nil then
		tbl["Options"]["ScrollFactor"] = 0
		tbl["Options"]["ScrollUp"] = 0
		tbl["Options"]["ScrollDown"] = 0
	end
	tbl["Options"]["Init"] = false
	return gui._Custom(ref, varname, name, x, y, w, h, function(x, y, x2, y2, active, self)
		local Options = self.custom_vars["Options"]
		local DefaultColors = {
			Background = {13, 13, 13, 150},
			Border = {0, 0, 0, 255},
			Header = {30, 30, 30, 255},
			Shadow = {10, 10, 10, 200},
			SelectedOverlay = {255, 255, 255, 255},
			HeaderFontColor = {153, 153, 153, 255},
			HeaderFontColorSelected = {255, 255, 255, 255},
			StatusCircle = {74, 74, 74, 255},
		}
		if Options["Init"] == false then
			if Options["MoveRestraint"] ~= nil then
				if Options["MoveRestraint"]["X"] ~= nil then
					self:SetMoveRestraintX(Options["MoveRestraint"]["X"])
				end
				if Options["MoveRestraint"]["Y"] ~= nil then
					self:SetMoveRestraintY(Options["MoveRestraint"]["Y"])
				end
				if Options["MoveRestraint"]["Width"] ~= nil then
					self:SetMoveRestraintWidth(Options["MoveRestraint"]["Width"])
				end
				if Options["MoveRestraint"]["Height"] ~= nil then
					self:SetMoveRestraintHeight(Options["MoveRestraint"]["Height"])
				end
			end
			Options["Init"] = true
		end
		if Options["MoveRestraint"] ~= nil then
			draw.SetScissorRect(self:GetMoveRestraintX(),self:GetMoveRestraintY(), self:GetMoveRestraintWidth()*getDPIScale(), self:GetMoveRestraintHeight()*getDPIScale());
		end
		
		draw._Color(DefaultColors, Options["Colors"], "Shadow")
		
		if Options["Shadow"] ~= nil then
			draw.ShadowRect(x, y, x2, y2, Options["Shadow"]["Intensity"]);
		end
		--print(self._mouse_hovering)
		--Background
		draw._Color(DefaultColors, Options["Colors"], "Background")
		draw._FilledRect(x, y, x2, y2, Options["Rounded"])
		
		--Border
		if Options["Border"] then
			draw._Color(DefaultColors, Options["Colors"], "Border")
			draw._Rect(x, y, x2, y2, Options["Rounded"])
		end
		
		if Options["Header"] ~= nil then
			draw._Color(DefaultColors, Options["Colors"], "Header")
			if Options["Rounded"] then
				draw.RoundedRectFill(x, y, x2, y + Options["Header"]["Height"] + GetExist(Options["ScrollFactor"], 0), 16*getDPIScale(), 16*getDPIScale(), 16*getDPIScale(), 0, 0)
			else
				draw._FilledRect(x, y, x2, y + Options["Header"]["Height"] + GetExist(Options["ScrollFactor"], 0), Options["Rounded"])
			end
			if Options["SelectedOverlay"] and Options["Selected"] then
				draw._Color(DefaultColors, Options["Colors"], "HeaderFontColorSelected")
			else
				draw._Color(DefaultColors, Options["Colors"], "HeaderFontColor")
			end
			draw.SetFont(GlobalFont)
			draw.TextShadow(x + 40*getDPIScale(), y + 15*getDPIScale(), Options["Header"]["Text"])
			
			if Options["Header"]["StatusCircle"] ~= nil then
				draw._Color(DefaultColors, Options["Colors"], "StatusCircle")
				draw.FilledCircle(x + 20*getDPIScale(), y + 25*getDPIScale(), 8*getDPIScale())
			end
		end
		
		if Options["MaxDragOffsetX"] and Options["Drag"] or Options["MaxDragOffsetY"] and Options["Drag"] then
			local px, py = self:GetParent():GetValue()
			self:SetMaxDragX(GetExist(Options["MaxDragOffsetX"]))
			self:SetMaxDragY(GetExist(Options["MaxDragOffsetY"]))
			self:SetMaxDragWidth(GetExist(Options["MaxDragOffsetWidth"]))
			self:SetMaxDragHeight(GetExist(Options["MaxDragOffsetHeight"]))
		end
		
		if Options["SelectedOverlay"] and Options["Selected"] then
			draw._Color(DefaultColors, Options["Colors"], "SelectedOverlay")
---@diagnostic disable-next-line: missing-parameter
			draw.RoundedRect(x - 10, y - 10, x2 + 10, y2 + 10, 25*getDPIScale())
		end
		
		if Options["InverseDrag"] and not self:GetUsing() then
			if input.IsButtonDown(1) then
				local mouseX, mouseY = input.GetMousePos()
				if Options["DragStatus"] then
					Options["Effects"]["InverseAdd"](mouseX - Options["dx"], mouseY - Options["dy"])
					Options["DragStatus"] = false
				end
				if mouseX >= x and mouseX <= x+self:GetWidth()*getDPIScale() and mouseY >= y and mouseY <= y + self:GetHeight()*getDPIScale() then
					if mouseX >= x and mouseX <= x+self:GetWidth()*getDPIScale() and mouseY >= y and mouseY <= y + self:GetHeight()*getDPIScale() then
						Options["DragStatus"] = true
						Options["dx"] = mouseX
						Options["dy"] = mouseY
					end
				end
			else
				Options["DragStatus"] = false
			end
		end
		
		if Options["Drag"] and not self:GetUsing() then
			if input.IsButtonDown(1) then
				local mouseX, mouseY = input.GetMousePos()
				local px, py = self:GetParent():GetValue()
				if Options["DragStatus"] then
					local newx = mouseX - Options["dx"]
					local newy = mouseY - Options["dy"]
					if newx <= self:GetMaxDragX() then
						newx = self:GetMaxDragX()
						
					end
					if newy <= self:GetMaxDragY() then
						newy = self:GetMaxDragY()
					end
					
					if newx >= self:GetMaxDragWidth() - self:GetWidth() then
						newx = self:GetMaxDragWidth() - self:GetWidth()
					end
					
					if newy >= self:GetMaxDragHeight() - self:GetHeight() then
						newy = self:GetMaxDragHeight() - self:GetHeight()
					end
					
					self:SetPosX(newx)
					self:SetPosY(newy)
				end
				if mouseX >= x and mouseX <= x+self:GetWidth()*getDPIScale() and mouseY >= y and mouseY <= y + self:GetHeight()*getDPIScale() and not self:GetUsing() then
					if Options["BoundsHeight"] ~= nil then
						if mouseX >= x and mouseX <= x+self:GetWidth()*getDPIScale() and mouseY >= y and mouseY <= y + Options["BoundsHeight"]*getDPIScale() then
							Options["DragStatus"] = true
							Options["dx"] = mouseX - self:GetX()
							Options["dy"] = mouseY - self:GetY()
						end
					end
				end
			else
				Options["DragStatus"] = false
			end
		end
		
		if self._mouse_hovering then
			--print(Options["Effects"]["Hover"])
			if Options["Effects"]["Hover"] ~= nil then gui.Effects["Hover"](x, y, x2, y2) end
		end
		if self._mouse_hovering and input.IsButtonDown(1) then
			Options["Selected"] = true
			self:SetSelected(true)
			
			
		elseif self._mouse_hovering and input.IsButtonReleased(1) then
			Options["Selected"] = true
			self:SetSelected(true)
		end
		
		if not self._mouse_hovering and input.IsButtonDown(1) then
			Options["Selected"] = false
			self:SetSelected(false)
		end
		
		if not self._mouse_hovering and input.IsButtonReleased(1) then
			Options["Selected"] = false
			self:SetSelected(false)
		end
		
		local delta = input.GetMouseWheelDelta();
		
		if delta ~= 0 and Options["ScrollAffective"] then
			print(Options["ScrollFactor"])
			if delta > 0 then
				Options["ScrollUp"] = Options["ScrollUp"] + 1
				Options["ScrollDown"] = Options["ScrollDown"] - 1
				Options["ScrollFactor"] = 2*Options["ScrollUp"]
			else
				Options["ScrollUp"] = Options["ScrollUp"] - 1
				Options["ScrollDown"] = Options["ScrollDown"] + 1
				Options["ScrollFactor"] = math.abs(2*Options["ScrollDown"]*-1)
			end
			self:SetWidth(self:GetWidth() + GetExist(Options["ScrollFactor"], 0))
			self:SetHeight(self:GetHeight() + GetExist(Options["ScrollFactor"], 0))
			--GlobalFont = draw.CreateFont("Bahnschrift", 28 + delta * 5)
		end
		
		if self._mouse_hovering and input.IsButtonReleased(1) then
			if Options["Effects"]["Click"] ~= nil then 
				Options["Effects"]["Click"]()
			end
		end
		if Options["Effects"]["DrawExtra"] ~= nil then
			Options["Effects"]["DrawExtra"](x, y, x2, y2, self, active)
		end
		draw.SetScissorRect(0, 0, draw.GetScreenSize())
		if Options["DragStatus"] ~= nil then
			self:SetDragStatus(Options["DragStatus"])
		end
	end, {
		Options = tbl["Options"],
	})
end

--GUIAPI Base64Control Control {#f2aeae, 58}
function gui.Base64Control(ref, varname, name, tbl, x, y, w, h)
	local iconRGBA, iconWidth, iconHeight = common.DecodePNG(decode(tbl["Image"]["Base64"]))
	tbl["Image"]["Base64"] = draw.CreateTexture(iconRGBA, iconWidth, iconHeight)
	tbl["Image"]["SequenceLoaded"] = {}
	
	if tbl["Image"]["Sequence"] ~= nil then
		for i = 1,#tbl["Image"]["Sequence"] do
			local frame = tbl["Image"]["Sequence"][i]
			local frame_dat = decode(frame)
			local frame_rgba, frame_w, frame_h = common.DecodePNG(frame_dat)
			local frame_texture = draw.CreateTexture(frame_rgba, frame_w, frame_h)
			
			tbl["Image"]["SequenceLoaded"][i] = frame_texture
		end
	end

	return gui._Custom(ref, varname, name, x, y, w, h, function(x, y, x2, y2, active, self)
		local Image = self.custom_vars["Image"]
		local Options = self.custom_vars["Options"]
		local DefaultColors = {
			Background = {13, 13, 13, 150},
			Border = {0, 0, 0, 255}
		}
		
		--Image
		draw.Color(255, 255, 255, Image["Brightness"])
		draw.SetTexture(Image["Base64"])
		draw.FilledRect(x + GetExist(Image["OffsetX"], 0), y + GetExist(Image["OffsetY"], 0), x + Image["Width"], y + Image["Height"])
		draw.SetTexture(nil)
		
		--Border
		if Options["Border"] then
			draw._Color(DefaultColors, Options["Colors"], "Border")
			draw._Rect(x, y, x2, y2, Options["Rounded"])
		end
		
		if self._mouse_hovering and not input.IsButtonDown(1) then
			--print(Options["Effects"]["Hover"])
			if Options["Effects"]["Hover"] ~= nil then 
				--gui.Effects["Hover"](x, y, x2, y2)
				for i = 1,#Image["SequenceLoaded"] do
					draw.Color(255, 255, 255, Image["Brightness"])
					draw.SetTexture(Image["SequenceLoaded"][i])
					draw.FilledRect(x + GetExist(Image["OffsetX"], 0), y + GetExist(Image["OffsetY"], 0), x + Image["Width"], y + Image["Height"])
					draw.SetTexture(nil)
				end
			end
		end
		if self._mouse_hovering and input.IsButtonReleased(1) then
			if Options["Effects"]["Click"] ~= nil then 
				Options["Effects"]["Click"]()
			end
		end
	end, {
		Image = tbl["Image"],
		Options = tbl["Options"],
	})
end

-- Script GUI Parents {#5e99ff, 3}
local Tab = gui.Tab(gui.Reference("Settings"), "customtest", "Code Blocks")

local window_VisualBlocks = gui.Window("block_window", "Visual Blocking", 100, 100, 1000, 800)
window_VisualBlocks:SetActive(true)

-- Script GUI Components {#5eefff, 127}
local background_BlockWindow = gui.FilledControl(window_VisualBlocks, "background_BlockWindow", "background_BlockWindow", { 
	Options = {
		Border = true,
		InverseDrag = true,
		Colors = {
			Background = {25, 25, 25, 255},
		},
		Effects = {
			Hover = true,
			Click = function()
				
			end,
			InverseAdd = function(x, y)
				for _,v in ipairs(currentBlocks) do
					if v:GetDragStatus() ~= nil then
						if v:GetDragStatus() then
							abortDrag = true
							break
						elseif v:GetUsing() ~= nil then
							if v:GetUsing() then
								abortDrag = true
								break
							end
						end
					end
					abortDrag = false
				end
				if not abortDrag then
					for i = 1, #currentBlocks do
						local block = currentBlocks[i]
						--[[
						if block:GetDragStatus() ~= nil then
							local amt = 0
							if block:GetDragStatus() then
								dragging =  1
								amt = amt + 1
							end
						end
						print(dragging)
						if dragging > 0 then
							return
						end]]

						block:SetPosX(block:GetX() + x*getDPIScale())
						block:SetPosY(block:GetY() + y*getDPIScale())
						
						if block:GetX() < 0 then
							--block:SetInvisible(true)
						else
							--block:SetInvisible(false)
						end
					end
				end
			end,
		},
	}
}, 10, 40, 980, 718)
--0, 40, 980, 718)
local window_AvailableBlocks = gui.Window("window_AvailableBlocks", "Available Blocks", 100, 100, 200, 300)
window_AvailableBlocks:SetInvisible(true)

local textbox_devSpecX = gui.TextBox(window_VisualBlocks, "textbox_devSpecX", "textbox_devSpecX", { 
	Options = {
		Text = "X: ",
		Effects = {
			Hover = true,
			Click = function()
				
			end,
		},
	}
}, 25, 700, 50, 10)

local textbox_devSpecY = gui.TextBox(window_VisualBlocks, "textbox_devSpecY", "textbox_devSpecY", { 
	Options = {
		Text = "Y: ",
		Effects = {
			Hover = true,
			Click = function()
				
			end,
		},
	}
}, 25, 714, 50, 10)

local textbox_devSpecFPS = gui.TextBox(window_VisualBlocks, "textbox_devSpecFPS", "textbox_devSpecFPS", { 
	Options = {
		Text = "FPS: ",
		Effects = {
			Hover = true,
			Click = function()
				
			end,
		},
	}
}, 25, 728, 50, 10)

local block_FilledRectangle = gui.Button(window_AvailableBlocks, "Filled Rectangle", function()
end)
block_FilledRectangle:SetWidth(167)

local button_ViewBlocks = gui.Button(window_VisualBlocks, "Show Available Blocks", function()
	bool_AvailableBlocks = not bool_AvailableBlocks
end)
button_ViewBlocks:SetPosY(5)
button_ViewBlocks:SetPosX(10)

--[[
local example = gui.Base64Control(Tab, "teste", "1", { 
	Image = {
		Base64 = "iVBORw0KGgoAAAANSUhEUgAAAQgAAAAgCAYAAADufuYQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAY6SURBVHhe7Z1rbBRVFMdPt/iBlgSTVjCUtiZgQBRpoSVK2yC0peH9EFEoBKSAn4QCUXl8EBNKhagUkBCevgo2yKMYASnFaAoaLdjyprwLKQmvRBJsIbas8z/MlO0yMzutoB/8/5LJ7r137rl3Tu/933NndrthYtArKdnvC28lfr8fSULI/5iwsDBpaKiXC+fO+MIgDn5RnSCEkAD84kPkQAghwYQb2uDjtoIQYge0wWe+J4SQh6BAEEIcoUAQQhyhQBBCHKFAEEIcoUAQQhyhQBBCHKFAEEIcCe8Q03EBPyzlnfi4OHkmPl6ebt9erl692piX3r+f1NbWyq1btzTvUePWhlvZgMxM6dSpk5w7f97MeYBbWUtp27atdO3SRf1z584duXv3rlnSPHBNTxq2Aq8HtmH3cfmYNAXfyWAE4ZGYmBjZvm2LbNv6jWxYv1aPTYVf6qDt3v0FmT9vrr4+LtzacCpD3yZNnKAH3gfiVtZSFuUtlB9KSxr9s7lok/qtJczMnSFrVq9qrI8+rlq5QvIXLdQ0+XegQHhkzOhXJS42VpYWLJPJOVP1WLzko4dWM6fJhnysio+C4Da+27lL+4NXC5yDFdiOUGXB9i2c8kHv5GRJS02VqqqqRv+8+95cuX37tnnG/fpOPgi2XV1dLdHR0ZKY0EPTbdq0kaioKLl27bqmgZu9YNz6TpyhQDSTyMhIOXzkSOMRyAcL3tcV9FD5rzJzxnTNw8BcXrBU8xF9lP30o06mgk8+lj27d+oK2b9fPynetrWxDsoQndhh18aQwYN0xcYr2kNdq70uRrhvEarM6icOREvoG2yirZLvdz3UbiDt2j0lERGtZdPXRU38AwF18oGb7QM//2Jsmerk2c6dNQ2hgGBAOKx6lr3gvq5bs1rbQPr5bt203LJv+Zx4gwLhEWvATps6RQcaBjwGXyDFxTukYNlyuXHjhiQnJ+nESEtNkZSUPlJYuFHmzJ1v2PhTxo19Qwd6RESkxHToID1e7C6xsR0lPj5e62CyBa6Ugdi1EQjaw8THeW9Pz5VLly+bJaHL0E9ESOhndFS0vDN7llkqUla237VdayLb4eQDCzvbNVeu6HnwCYB9+B9/h7L9BxqjlDVr12lkZ0UaANeISObChYsyIDNDrwXn5S3Kl9Vr1jaJaog7FAiP/FZeLkOGDZeFefk6sTDg58+b02SiVFRWylfGJDh58pSGwwiLMbAx8Ddv2Sp7S0u17LnnuupABxADaxIgHzf4UBcCYoddG4FYE2lPyV45fuKE1NXWmiXeyl7p21eGDh1s5j4gVLtuOPnAws52TU2NpuEf+Bg+gmBAOEB6en/JyXlTxmdnazqQxUuWyJRpb+k1AkQ2OG/QwIGC+/G8yekdCkQzwMDaXlwsI0eN1knmdaJYkUIg1gqZmJCgk6B4x7d617hnYoKef+bsWfPM/4aKygo5eeqUmQpNqP7a+SAUEMnY2DjdjsBHEAwIx+RJEyV73Fi5eLFaSkpKzLPt2fD5FyrqiCgSDd/Ompmr9og3KBAewXZi1MgRekwYn91kBXQDEwcrWEqflyUzI0PrYaAjzL1586akpaXq3vrYseP6/fusrCyt57TFCIXV3ogRw2XY0CHSOiLCLPFWVn7woKxf/5kUFW2W/UYo7xX0FxFITs5k9Q/8hMeoWP2dfBAKq97rY15TobCiKkQTiEiOHj0m1667+6ljTIwhvCK7du9WUSfNgwLhEaw+eJSII3fGdN3Xrvh0pa5obuDJAgbmeGPSfJifJ7V1dXojD9EIJhWiEAjD6dOnVTBwLyIwlG4uFZWHdQuUNSBT+4n9uYVbGfb1WGVxjwU3PFcsL9D9u1ewBSvcuFH9Atvw0+xZuRphOfkgFOgvhAC+h1BAMEDpvn1GOlJtWVuMjPR0fQ0G12D93XDdFRUVUmX4mngjLKn3S/579+6ZSRIKrIh4RFh96ZKZ4x08kmtJvZbg1pZb2T+5PgvY/8MQQLu9/qP0QXNsufWJ2OPz+SgQhBB7IBDcYhBCHKFAEEIcoUAQQhyhQBBCHKFAEEIcoUAQQhzx4eO9hBASjP7DmIb6v8wkIYQ8oKG+/v7PevfsleQPb/UEf/6fEHL/5/8Ncfj9UHnY3yWUR+LqiCNoAAAAAElFTkSuQmCC",
		Width = 264,
		Height = 32,
		OffsetX = 0,
		OffsetY = 0,
		Brightness = 255,
		Sequence = {
			"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"
		},
	},
	Options = {
		Rounded = true,
		Border = true,
		Colors = {
			Background = {13, 13, 13, 215},
		},
		Effects = {
			Hover = true,
			Click = function()
				
			end,
		},
	}
}, 10, 10, 264, 32)
]]--

local keybox_graph_window = gui.Keybox(Tab, "keybox_graph_window", "Open Graph Window Key", 0)
keybox_graph_window:SetWidth(260)
keybox_graph_window:SetDescription("Edit code blocks visually.")
local keybox_graph_window_value = keybox_graph_window:GetValue();

-- Script Global Functions {#ffba19, 49}
local function AddBlock(ref, varname, name, tbl)
	local block =  gui.FilledControl(ref, varname, name, { 
		Options = {
			Border = true,
			Rounded = true,
			Drag = true,
			Shadow = {
				Intensity = 20,
			},
			MoveRestraint = {
				X = 0,
				Y = 0,
				Width = 0,
				Height = 0,
			},
			BoundsHeight = GetExist(tbl["BoundsHeight"], 200)*getDPIScale(),
			MaxDragOffsetX = 14*getDPIScale(),
			MaxDragOffsetY = 44*getDPIScale(),
			MaxDragOffsetWidth = 987,
			MaxDragOffsetHeight = 754,
			SelectedOverlay = true,
			ScrollAffective = false,
			Colors = {
				Background = {53, 53, 53, 255},
				Border = {51, 51, 51, 255}
			},
			Header = {
				Height = 50*getDPIScale(),
				Text = tbl["HeaderTitle"],
				StatusCircle = {
				
				},
			},
			Effects = {
				Hover = true,
				Click = function()
					
				end,
				DrawExtra = tbl["Draw"],
			},
		}
	}, background_BlockWindow:GetX() + 10 + GetExist(tbl["X"], 0), background_BlockWindow:GetY() + 10 + GetExist(tbl["Y"], 0), tbl["Width"], tbl["Height"])
	table.insert(currentBlocks, block)
	return currentBlocks[#currentBlocks]
end

local get_abs_fps = function()  
	frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime();
	return math.floor((1.0 / frame_rate) + 0.5); 
end

--Script GUI Components {#5eefff, 13}
local block_blank = AddBlock(window_VisualBlocks, "block_start_inactive", "Beginning", {
	Width = 400,
	Height = 200,
	X = 100,
	Y = 300,
	HeaderTitle = "Beginning",
})

local nodes = {
	Knob = function(name)
		local node = AddBlock(window_VisualBlocks, name, name, {
			Width = 120,
			Height = 200,
			BoundsHeight = 60,
			HeaderTitle = "Knob",
			Draw = function(x, y, x2, y2, self, active)
				local mouseX, mouseY = input.GetMousePos()
	
				if self:GetUsing() then
					if self.CustomOptions["LastChangeX"] ~= x then
						if self.CustomOptions["LastChangeX"] > x then
							self:SetCustomValue(self:GetCustomValue() - (self.CustomOptions["LastChangeX"] - mouseX))
						else
							self:SetCustomValue(self:GetCustomValue() + (self.CustomOptions["LastChangeX"] + mouseX))
						end
					end
				end

				draw.Color(26, 26, 26, 255)
				draw.FilledCircle(x + (60*getDPIScale()), y + (120*getDPIScale()), 53*getDPIScale())
				
				draw.Color(119, 170, 255, 255)
				draw.FilledCircle(x + (60*getDPIScale()), y + (120*getDPIScale()), 10*getDPIScale())
				
				--draw.Color(53, 53, 53, 255)
				--draw.FilledRect(x + 105, y + 155, x2 - 110, y2 - 10)
				--draw.FilledRect(x + (10*getDPIScale()), y + (150*getDPIScale()), x+(115*getDPIScale()), y+(190*getDPIScale()))
				
				draw.Color(15, 15, 15, 120)
				--draw.FilledCircle(x + 60, y + 120, 40)
				draw.FilledCircle(x + (60*getDPIScale()), y + (120*getDPIScale()), 40 * getDPIScale())

				if self:GetCustomValue() ~= nil then
					if self:GetSelected() or self._mouse_hovering then
						draw.Color(255, 255, 255, 255)
					else
						draw.Color(153, 153, 153, 255)
					end
					draw.SetFont(GlobalFont)
					local Tw, Th = draw.GetTextSize(self:GetCustomValue())
					local centerX, centerY = center(Tw, Th, 120*getDPIScale(), 235*getDPIScale())
					draw.TextShadow(x + centerX, y + centerY, self:GetCustomValue())
				end
				
				draw.Color(0, 0, 0, 255)
				draw.FilledCircle(x + 80*getDPIScale(), y + 185*getDPIScale(), 10*getDPIScale())
				
				draw.Color(153, 153, 153, 255)
				draw.SetFont(GlobalBiggerFont)
				draw.TextShadow(x + 72.5*getDPIScale(), y + 172.8*getDPIScale(), "+")
				
				draw.Color(0, 0, 0, 255)
				draw.FilledCircle(x + 43*getDPIScale(), y + 185*getDPIScale(), 10*getDPIScale())
				
				draw.Color(153, 153, 153, 255)
				draw.SetFont(GlobalBiggerFont)
				draw.TextShadow(x + 36.25*getDPIScale(), y + 170.8*getDPIScale(), "-")
				
				if self:hovering(x + 80*getDPIScale(), y + 185*getDPIScale(), x + 80*getDPIScale()+20, y + 185*getDPIScale()+20) then
					print("on")
				end
				
				if input.IsButtonReleased(1) and not self:GetDragStatus() and self:GetUsing() then
					--self:SetUsing(false)
				end
				
				if self._mouse_hovering and input.IsButtonDown(1) and not self:GetDragStatus() and not self:GetUsing() then
					--self:SetUsing(true)
					--self.CustomOptions["LastChangeX"] = mouseX
				end
			end,
		})
		node:SetCustomValue(14800.00)
		return {
			nodeData = node,
			SetValue = function(self, value)
				self.nodeData:SetCustomValue(value)
			end,
			GetValue = function(self)
				return self.nodeData:GetCustomValue()
			end,
		}
	end,
}

local block_knob = nodes.Knob("knob")

-- Script Callbacks {#ff7519, 31}
callbacks.Register("Draw", function()
	window_VisualBlocks:SetOpenKey(keybox_graph_window:GetValue())
	
	for i = 1, #currentBlocks do
		local block = currentBlocks[i]
		local windowX, windowY = window_VisualBlocks:GetValue()
		block:SetMoveRestraintX(windowX + background_BlockWindow:GetX() + (1*getDPIScale()))
		block:SetMoveRestraintY(windowY + background_BlockWindow:GetY() + (25*getDPIScale()))
		block:SetMoveRestraintWidth(background_BlockWindow:GetWidth() - (2*getDPIScale()))
		block:SetMoveRestraintHeight(background_BlockWindow:GetHeight() - (2*getDPIScale()))
	end
	
	local mouseX, mouseY = input.GetMousePos()
	local windowX, windowY = window_VisualBlocks:GetValue()
	
	if (mouseX - windowX - (10*getDPIScale())) < 0 or (mouseX - windowX - (10*getDPIScale())) > (980*getDPIScale()) or (mouseY - windowY - (10*getDPIScale())) > (770*getDPIScale()) or (mouseY - windowY - (64*getDPIScale())) < 0 then
		textbox_devSpecX:SetText("X: Unlocated")
		textbox_devSpecY:SetText("Y: Unlocated")
	else
		textbox_devSpecX:SetText("X: " .. mouseX - windowX - (10*getDPIScale()))
		textbox_devSpecY:SetText("Y: " .. mouseY - windowY - (10*getDPIScale()))
	end

	textbox_devSpecFPS:SetText("FPS: " .. tostring(get_abs_fps()))

	if bool_AvailableBlocks then
		button_ViewBlocks:SetName("Show Available Blocks")
		window_AvailableBlocks:SetInvisible(true)
	else
		button_ViewBlocks:SetName("Hide Available Blocks")
		window_AvailableBlocks:SetInvisible(false)
	end
end)
