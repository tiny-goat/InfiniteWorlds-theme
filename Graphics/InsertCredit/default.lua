return Def.ActorFrame {
    OnCommand=function(self)
        self:diffusealpha(0):sleep(0.3):linear(0.5):diffusealpha(1):pulse():effectmagnitude(1.25, 1.3, 0):effectperiod(0.6)
    end,
            
    Def.Sprite {
        Texture="InsertCredit",
    },
    
    Def.Sprite {
        Texture="InsertCredit",
        InitCommand=function(self)
            self:zoom(1):diffusealpha(0)
            :blend("add"):queuecommand("FadeEffect")
        end,
        FadeEffectCommand=function(self)
            self:stoptweening()
            :zoom(1):diffusealpha(0.75)
            :decelerate(0.6)
            :zoom(1.25):diffusealpha(0)
            :queuecommand("FadeEffect")
        end
    }
}