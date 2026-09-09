return Def.ActorFrame {
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM - 73):diffusealpha(0)
    end,
    OnCommand=function(self)
        self:easeoutexpo(0.5):y(SCREEN_BOTTOM - 60):diffusealpha(1)
    end,
    OffCommand=function(self)
        self:easeoutexpo(0.5):y(SCREEN_BOTTOM - 73):diffusealpha(0)
    end,

    Def.BitmapText {
        Name="Text",
        Font="inter medium 25px",
        InitCommand=function(self)
            self:zoom(0.7)
        end
    }
}
