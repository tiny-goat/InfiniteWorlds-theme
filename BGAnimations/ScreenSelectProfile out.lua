return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:FullScreen():diffusecolor(Color.Black) end,
		StartTransitioningCommand=function(self) self:diffusealpha(0):sleep(0.2):linear(0.3):diffusealpha(1):sleep(0.1) end
	},
	
	Def.Sprite{
		Texture=THEME:GetPathG("", "Logo/Parts/iw_logo_3"),
		InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):diffusealpha(0):zoom(0.8) end,
		StartTransitioningCommand=function(self) self:croptop(1):sleep(0.25):diffusealpha(1):linear(0.4):croptop(0):linear(0.4):cropbottom(1) end,
	}
}

