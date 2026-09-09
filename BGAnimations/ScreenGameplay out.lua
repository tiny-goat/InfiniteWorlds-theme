return Def.Quad{
    StartTransitioningCommand=function(self)
        self:FullScreen():diffuse(Color.Black):diffusealpha(0)
        :sleep(1):linear(0.7):diffusealpha(1)
    end
}
