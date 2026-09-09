local t = LoadActor(THEME:GetPathB("ScreenGameplay", "overlay"))

t[#t+1] = Def.ActorFrame {
    Def.Quad {
        Name="DemoTextBox",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y * 1.75):zoomto(0, 70)
            :diffuse(0,0,0,0.9):sleep(0.3):easeoutexpo(0.7):zoomto(330, 70)

        end
    },

    Def.BitmapText {
        Font="Strike Fighter 45px",
        InitCommand=function(self)
            self:settext("DEMO PLAY"):shadowlength(1)
            :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y * 1.75)
            :queuecommand("Flicker")
            :visible(0)
        end,
        FlickerCommand=function(self)
            self:sleep(0.5)
            :visible(not self:GetVisible())
            :queuecommand("Flicker")
        end
    }
}

return t
