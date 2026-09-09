return Def.ActorFrame {
    --[[LoadActor("SongTransition") .. {
        OnCommand=function(self)
            self:sleep(0.15):linear(0.1):diffusealpha(0)
        end
    }]]--
    Def.Quad {
	InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end,
	OnCommand=function(self) self:sleep(0.2):linear(0.7):diffusealpha(0) end
    }
}
