return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:FullScreen():diffusecolor(Color.Black) end,
		StartTransitioningCommand=function(self) self:diffusealpha(0):sleep(0.2):linear(0.3):diffusealpha(1):sleep(0.1) end
	}
}

