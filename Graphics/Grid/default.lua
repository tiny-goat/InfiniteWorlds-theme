-- 3D synthwave-style grids require the actor they're contained in
-- to have an FOV value set, 90 seems to work well
return Def.ActorFrame {
    Name="GridFrame",
    FOV=90,
    Def.Sprite {
        Name="GridTop",
        Texture="_carbonline",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, 0)
            :zoomx(-2.6)
            :halign(0.5):valign(0)
            :rotationx(84)
            :texcoordvelocity(0, 0.34)
            :diffuse(color("#FFFFFF"))
            :diffusealpha(0.5)
            :fadebottom(1)
            if IsAnniversary() then self:queuecommand("Rainbow") else self:queuecommand("Refresh") end
        end,
        ScreenChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
        RefreshCommand=function(self)
            local BasicMode = getenv("IsBasicMode")
            local NoSongs = #SONGMAN:GetPreferredSortSongs() == SONGMAN:GetNumSongs()
            
            self:linear(1):diffuse(BasicMode and (NoSongs and color("#f36b4f") or color("#5086f3")) or color("#FFFFFF")):diffusealpha(0.3)
        end,
        RainbowCommand=function(self) self:rainbow():effectperiod(10) end
    },


    Def.Sprite {
        Name="GridBottom",
        Texture="_carbonline",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM)
            :zoomx(2.6)
            :halign(0.5):valign(0)
            :rotationx(98)
            :texcoordvelocity(0, 0.34)
            :diffuse(color("#FFFFFF"))
            :diffusealpha(0.5)
            :fadebottom(1)
            if IsAnniversary() then self:queuecommand("Rainbow") else self:queuecommand("Refresh") end
        end,
        ScreenChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
        RefreshCommand=function(self)
            local BasicMode = getenv("IsBasicMode")
            local NoSongs = #SONGMAN:GetPreferredSortSongs() == SONGMAN:GetNumSongs()
            
            self:linear(1):diffuse(BasicMode and (NoSongs and color("#f34f76") or color("#50c8f3")) or color("#FFFFFF")):diffusealpha(0.3)
        end,
        RainbowCommand=function(self) self:rainbow():effectperiod(10) end
    },

}
