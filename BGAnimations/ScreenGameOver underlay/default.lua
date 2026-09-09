return Def.ActorFrame {
    Def.Sound {
	-- music from the4kman on discord, this dude's music is fuckin' awesome, give the man some love
        File=THEME:GetPathS("", "GameOver"),
        OnCommand=function(self)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },
    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Circle"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):queuecommand("Expand")
        end,
        ExpandMessageCommand=function(self)
            self:diffusealpha(0.1):zoom(0)
            :linear(3)
            :diffusealpha(1):zoom(2)
            :queuecommand("Expand")
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Circle"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):sleep(1.5):queuecommand("Expand")
        end,
        ExpandMessageCommand=function(self)
            self:diffusealpha(0.1):zoom(0)
            :linear(3)
            :diffusealpha(1):zoom(2)
            :queuecommand("Expand")
        end
    },
    --[[Def.Sprite{
        Texture="glass-break",
        InitCommand=function(self)
            self:rotationz(90):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):zoom(1.35)
            :sleep(1)
	    :linear(0.05)
            :diffusealpha(0.7)
	    :zoom(1.33)
            :sleep(2.5)
            :accelerate(0.5)
            :diffusealpha(0)
        end
    },]]--
    Def.Sprite{
        Texture="tg_gameover",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):cropbottom(0.3):zoom(5):sleep(0.65)
            :accelerate(0.3)
            :diffusealpha(1)
	    :zoom(0.9)
	    :sleep(0.5)
	    :smooth(0.5)
            :sleep(2.08)
            :accelerate(0.5)
	    :zoom(1.9)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture="tg_gameover",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):croptop(0.7):cropright(1):zoom(5):sleep(0.4)
            :accelerate(0.3)
            :diffusealpha(1)
	    :zoom(0.9)
	    :sleep(0.1)
	    :linear(1.9)
	    :cropright(0)
            :sleep(1.8)
            :accelerate(0.5)
	    :zoom(1.4)
            :diffusealpha(0)
        end
    },

--[[up and down flashes of game and over]]--
    Def.Sprite{
        Texture="tg_gameover",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-190)
            :diffusealpha(0):cropbottom(0.3):cropright(0.475):zoom(0.8):sleep(0)
            :linear(0.3)
            :diffusealpha(1)
            :easeoutexpo(0.5)
            :diffusealpha(1)
	    :zoom(1.3)
            :diffusealpha(0)
        end
    },
    Def.Sprite{
        Texture="tg_gameover",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+190)
            :diffusealpha(0):cropbottom(0.3):cropleft(0.53):zoom(0.8):sleep(0.4)
            :linear(0.3)
            :diffusealpha(1)
            :easeoutexpo(0.5)
            :diffusealpha(1)
	    :zoom(1.3)
            :diffusealpha(0)
        end
    },


    Def.Sprite{
        Texture="tg_gameover",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):cropbottom(0.3):sleep(0.65)
            :accelerate(0.3)
            :diffusealpha(1)
	    :zoom(0.8)
            :easeoutexpo(0.5)
	    :zoom(1.9)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Stars1"),
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.85)
            :Center()
            :diffusealpha(0.5)
            :decelerate(1)
            :zoom(0.4)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Stars2"),
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.85)
            :Center()
            :diffusealpha(0.5)
            :decelerate(1)
            :zoom(0.5)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Stars3"),
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(1)
            :Center()
            :diffusealpha(0.75)
            :decelerate(1)
            :zoom(0.6)
            :diffusealpha(0)
        end
    },
    
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffuse(Color.Black)
            :diffusealpha(0):sleep(4):easeoutexpo(0.5):diffusealpha(1)
            :queuecommand("Transition")
        end,
        TransitionMessageCommand=function(self)
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }
}
