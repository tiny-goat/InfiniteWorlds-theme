local t = LoadActor(THEME:GetPathB("ScreenGameplay", "overlay"))

t[#t+1] = Def.ActorFrame {
	-- left
	Def.BitmapText {
        Font="Strike Fighter 45px",
        InitCommand=function(self)
            self:settext("DEMO PLAY"):diffusetopedge(color("#FFFFFF")):diffusebottomedge(color("#12AAFF")):strokecolor(Color.Black)
            :zoom(0.8):skewx(-0.25):xy(SCREEN_CENTER_X-300, SCREEN_CENTER_Y * 1.93)
            :diffusealpha(1)
        end,
    },
	
	-- right
    Def.BitmapText {
        Font="Strike Fighter 45px",
        InitCommand=function(self)
            self:settext("DEMO PLAY"):diffusetopedge(color("#FFFFFF")):diffusebottomedge(color("#12AAFF")):strokecolor(Color.Black)
            :zoom(0.8):skewx(-0.25):xy(SCREEN_CENTER_X+300, SCREEN_CENTER_Y * 1.93)
            :diffusealpha(1)
        end,
    }
}

return t
