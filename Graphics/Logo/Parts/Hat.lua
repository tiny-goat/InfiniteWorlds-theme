return Def.ActorFrame {
    -- repositioned for the nfinity logo
    Def.Sprite {
        Name="PartyHat",
        Texture="PartyHat",
        InitCommand=function(self)
            self:xy(420, -500):rotationz(32):diffusealpha(0)
        end,
        OnCommand=function(self)
            self:sleep(1)
            :easeoutexpo(0.5)
            :diffusealpha(1)
            :y(-300)
        end
    },

    Def.BitmapText {
        Font="inter extrabold 40px",
        InitCommand=function(self)
            self:settext(string.format("%d YEAR ANNIVERSARY!", (Year() - 2020)))
            :y(-500)
            :shadowlength(2)
            :diffusealpha(0)
        end,
        OnCommand=function(self)
            self:sleep(1)
            :easeoutexpo(0.5)
            :diffusealpha(1)
            :y(-380)
        end
    }

}
