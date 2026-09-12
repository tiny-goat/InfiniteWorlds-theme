return Def.ActorFrame {
    OnCommand=function(self)
	-- close enough to kpump ig
        self:GetChild("Flash"):diffusealpha(0)
		self:GetChild("ChartStats"):diffusealpha(0)
		self:GetChild("Banner"):diffusealpha(0)
		self:GetChild("Fade"):diffusealpha(0)
    end,
    
    StartTransitioningCommand=function(self)
        if SCREENMAN:GetTopScreen():GetNextScreenName() == "ScreenStageInformation" then
	    self:GetChild("ChartStats"):diffusealpha(1)

	    self:GetChild("Banner"):diffusealpha(1)

        self:GetChild("Flash"):diffusealpha(1):sleep(0.14):easeoutexpo(0.7):diffusealpha(0)
		
	    self:GetChild("Fade"):sleep(3.5):linear(0.7):diffusealpha(1)

	    self:GetChild("SFX"):sleep(0.1):play()
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

    Def.Quad {
        Name="Flash",
		InitCommand=function(self) self:FullScreen():diffuse(Color.White) end
    },

    LoadActor("SongTransition") .. {
        Name="ChartStats"
    },

    Def.Quad {
    	Name="Fade",
    	InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end

    }


}
