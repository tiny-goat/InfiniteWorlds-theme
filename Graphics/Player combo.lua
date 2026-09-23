local c
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local Pulse = THEME:GetMetric("Combo", "PulseCommand")
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand")

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom")
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom")

local t = Def.ActorFrame {

    Def.BitmapText {
        Font="Combo Numbers",
        Name="Number",
        OnCommand = function(self) self:zoom(0.8) end
    },

    Def.Sprite {
        Texture="combo_label",
        Name="ComboLabel",
        OnCommand = function(self) self:zoom(0.3) end
    },

    InitCommand = function(self)
        -- We'll have to deal with this later
        --self:draworder(notefield_draw_order.over_field)
        c = self:GetChildren()
        c.Number:visible(false)
        c.ComboLabel:visible(false)
    end,

    ComboCommand=function(self, params)
        local iCombo = params.Misses or params.Combo
        if not iCombo or iCombo < ShowComboAt then
            c.Number:visible(false)
            c.ComboLabel:visible(false)
            return
        end

        local Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom )
        local Zoom = clamp( Zoom, NumberMinZoom, NumberMaxZoom )

        c.ComboLabel:visible(true)
        c.Number:visible(true)
        c.Number:settext(string.rep("0",3-string.len(iCombo))..iCombo)

        c.ComboLabel:stoptweening():diffuse(params.Misses and Color.Red or Color.White)
        :glow(1,1,1,0):diffusealpha(1):y(-22):zoomx(1.7):zoomy(1.7):decelerate(0.15):zoom(1.1)
        :sleep(0.4):decelerate(0.24):glow(1,1,1,0.8):diffusealpha(0):y(-19):zoomx(1.7):zoomy(0)
		
        c.Number:stoptweening():diffuse(params.Misses and Color.Red or Color.White)
        :zoom(0.8):diffusealpha(1):y(7):decelerate(0.15):y(1):zoom(0.8)
        :sleep(0.4):smooth(0.24):diffusealpha(0)
        
    end
}

return t
