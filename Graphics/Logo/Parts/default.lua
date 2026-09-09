return Def.ActorFrame {

    LoadActor("AnimatedLoop")..{
        Name="Loop",
        OnCommand=function(self)
            self:zoom(0.95):queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:GetChild("PlainLoop"):diffusealpha(1)
            self:GetChild("ArrowPatternTop"):croptop(1):fadebottom(0.6)
            :sleep(0.2)
            :easeoutexpo(0.9)
            :croptop(0)
	    self:GetChild("ArrowPatternBottom"):cropbottom(1):fadebottom(0.6)
            :sleep(0.2)
            :easeoutexpo(0.9)
            :cropbottom(0)
        end
    },

    Def.Sprite {
        Texture="iw_logo_4",
        Name="Text_Mask",
        InitCommand=function(self)
            self:MaskSource():zoom(0.9)
        end
    },

    Def.Quad {
        Name="Text_Shine",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:zoomto(70, 900)
            :diffuse(1,1,1,0.8)
            :skewx(-1)
            :x(-535)
            :sleep(0.5)
            :linear(0.5)
            :x(535):MaskDest():ztestmode("ZTestMode_WriteOnFail"):queuecommand("Shine")
        end,
	ShineCommand=function(self)
	    self:x(-535):sleep(3.5):linear(0.8):x(535):queuecommand("Shine") end
    },

    Def.Sprite {
        Texture="iw_logo_1",
        Name="Text",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:diffusealpha(0)
            :zoom(1.5):y(150):cropright(1):rotationz(-40):rotationy(90)
            :sleep(0.4)
            :diffusealpha(1)
            :glow(1,1,1,1)
            :easeoutexpo(1)
            :zoom(0.9):y(0):cropright(0):rotationz(0):rotationy(0)
            :glow(1,1,1,0)
        end
    },

    Def.Sprite {
        Texture="iw_logo_2",
        Name="Text",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:diffusealpha(0)
            :zoom(0.9):x(-200):y(0)
            :sleep(0.5)
            :diffusealpha(1)
            :glow(1,1,1,1)
            :easeoutexpo(1)
            :zoom(0.9):x(130)
            :glow(1,1,1,0)
        end
    },

}
