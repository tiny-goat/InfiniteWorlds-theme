return Def.ActorFrame {
    Def.Sprite {
        InitCommand=function(self)
            local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
                self:Load(Path):scale_or_crop_background():diffusealpha(1)
            end
        end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "Gradient background"),
        OnCommand=function(self)
            self:Center():scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM):diffusealpha(0.8)
        end
    },

}
