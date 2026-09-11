return Def.Quad{
    OnCommand=function(self)
        self:FullScreen():diffuse(Color.Black)
        :diffusealpha(1):easeinexpo(0.1):diffusealpha(0)
    end
}
