if IsGame("pump") or IsGame("piu") then
    return Def.ActorFrame {
        Def.Sprite {
	    Name="PadBase",
            Texture="tg_pad",
            InitCommand=function(self) self:y(12):zoom(0.45) end
        },

        Def.Sprite {
           Texture="tg_centerpad",
            InitCommand=function(self)
                self:y(47):zoom(0):diffusealpha(0)
                :queuecommand("FadeEffect")
            end,
            FadeEffectCommand=function(self)
                self:stoptweening()
                :zoom(0.45):diffusealpha(0.8)
                :smooth(0.5286)
                :zoom(0.8):diffusealpha(0)
                :queuecommand("FadeEffect")
            end
        },

        Def.Sprite {
            Name="Press",
            Texture="tg_press_step",
            InitCommand=function(self) self:zoom(0.45):y(14) end,
            OnCommand=function(self)
                self:bounce():sleep(1.1)
                :effectmagnitude(0, -25, 0)
                :effectperiod(0.5286)
            end
        }
    }
else
    return LoadActor("ButtonPress 5x2") .. {
        Frames=Sprite.LinearFrames(10, .4286),
        InitCommand=function(self) self:y(20) end
    }
end
