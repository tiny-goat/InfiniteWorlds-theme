return Def.ActorFrame {
    OnCommand=function(self)
	-- close enough to kpump ig
        self:GetChild("Flash"):diffusealpha(0)
        self:GetChild("Background"):diffusealpha(0)
	self:GetChild("Banner"):diffusealpha(0)
	self:GetChild("Fade"):diffusealpha(0)
    end,
    
    StartTransitioningCommand=function(self)
        if SCREENMAN:GetTopScreen():GetNextScreenName() == "ScreenStageInformation" then
            self:GetChild("Flash"):zoomy(0.3):diffusealpha(1):easeoutexpo(0.3):zoomy(SCREEN_HEIGHT):sleep(1)

	    self:GetChild("Background"):easeoutexpo(0.3):diffusealpha(1)

	    self:GetChild("Banner"):sleep(0.1):diffusealpha(1):y(SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH*3, SCREEN_HEIGHT*3):croptop(1):easeoutexpo(0.9):croptop(0):zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):sleep(0.2):easeinquad(0.2):zoomto(SCREEN_WIDTH*2, SCREEN_HEIGHT*2):rotationz(5):diffusealpha(0):sleep(1.5)

	    self:GetChild("Fade"):sleep(1.4):linear(0.7):diffusealpha(1)

	    self:GetChild("SFX"):sleep(0.2):play()
        else
            self:sleep(0)
        end
    end,

	OffCommand=function(s)
		s:queuecommand("Dim")
	end,
	DimCommand=function(s) SOUND:StopMusic() end,

    Def.Sound {
        Name="SFX",
        File=THEME:GetPathS("", "stage_warp")
    },

    Def.Quad {
        Name="Flash",
	InitCommand=function(self) self:FullScreen():diffuse(Color.White) end
    },

    Def.Sprite {
	Name="Banner",
	InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y) end,
        OnCommand=function(self) self:playcommand("Refresh") end,
        StartTransitioningCommand=function(self) self:playcommand("Refresh") end,

        RefreshCommand=function(self)
            if SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
                if GAMESTATE:GetCurrentSong() then
                    local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
                    if Path and FILEMAN:DoesFileExist(Path) then
                        self:Load(Path):scale_or_crop_background()
                    else
                        self:Load(THEME:GetPathG("Common", "fallback background")):scale_or_crop_background()
                    end
                end
            else
                self:Load(nil)
            end
        end
    },

    LoadActor("SongTransition") .. {
        Name="Background"
    },

    Def.Quad {
    	Name="Fade",
    	InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end

    }


}
