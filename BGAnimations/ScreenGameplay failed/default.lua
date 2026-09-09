local t = Def.ActorFrame{
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gradient background"),
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center():diffusecolor(Color.Red)
        end,
    },

    Def.Quad {
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
            :Center():diffuse(1,1,1,0.9)
        end,

        OnCommand=function(self)
            self:easeoutexpo(0.3)
            :diffusealpha(0)
        end
    },

Def.Sprite {
        Texture="broken glass",
        InitCommand=function(self)
            self:Center():diffusealpha(0):zoom(3):easeoutexpo(0.05):diffusealpha(0.3):zoom(1.1):linear(5):diffusealpha(0)
        end
	},

    Def.Sprite {
        Texture="fail_hey",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-140)
            :diffusealpha(0)
            :shadowlength(3)
            :shadowcolor(0,0,0,0.25)
            :zoom(0.2)
            :sleep(0.5 + 0.25)
            :easeoutexpo(0.25)
            :diffusealpha(1)
            :zoom(0.7):linear(4.9):rotationz(-2):zoom(0.8):y(SCREEN_CENTER_Y-170)
        end
    },

    Def.Sprite {
        Texture="fail_u_suck",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 10, SCREEN_CENTER_Y+60)
            :diffusealpha(0)
            :shadowlength(3)
            :shadowcolor(0,0,0,0.25)
            :zoom(0.1)
            :sleep(0.5 + 0.85)
            :easeoutexpo(0.25)
            :diffusealpha(1)
            :zoom(0.6):linear(4):rotationz(6):zoom(0.7):y(SCREEN_CENTER_Y+70)
        end
    },

    Def.Sound {
        File="Shatter",
        OnCommand=function(self)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },

    Def.Sound {
        File="Voice",
        OnCommand=function(self)
            self:sleep(0.9)
            :queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },

    Def.Sound {
        File="stage_crash",
        OnCommand=function(self)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },
    
    Def.Quad {
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
            :Center():diffuse(0,0,0,0)
        end,

        OnCommand=function(self)
            self:sleep(3.6)
            :linear(2)
            :diffusealpha(1)
        end
    }
}

return t
