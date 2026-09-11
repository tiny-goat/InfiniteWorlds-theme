setenv("IsBasicMode", false)
local t = Def.ActorFrame {
	-- Add timer functionality
	InitCommand=function(self)
		self:sleep(0.5):queuecommand("CheckTimer")
	end,
	CheckTimerCommand=function(self)
		if SCREENMAN:GetTopScreen():GetChild("Timer"):GetSeconds() <= 0 then
			self:queuecommand("TimerExpired")
		else
			self:sleep(0.5):queuecommand("CheckTimer")
		end
	end,
	TimerExpiredCommand=function(self)
		-- Set these or else we crash.
        GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")
        GAMESTATE:SetCurrentStyle(GAMESTATE:GetNumSidesJoined() > 1 and "versus" or string.lower(ShortType(GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()))))
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
	end
}

-- background dim!
t[#t+1] = Def.Quad {
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):valign(0.5)
        :zoomx(SCREEN_WIDTH)
        :diffuse(0,0,0,0)
        :zoomy(SCREEN_HEIGHT)
    end,       

	SongChosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.2):diffusealpha(0.8) end,
	SongUnchosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.2):diffusealpha(0) end,
}

-- background dim 2, the one behind musicwheel
t[#t+1] = Def.Quad {
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-150)
        :zoomx(SCREEN_WIDTH)
        :diffuse(0,0,0,0.9)
        :zoomy(280):fadetop(0.2)
    end,       

	SongChosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.2):diffusealpha(0) end,
	SongUnchosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.2):diffusealpha(0.9) end,
}

t[#t+1] = LoadActor("MusicWheel") .. { Name="MusicWheel" }

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.ActorFrame {
        Def.Actor {
            -- If no AV is defined, do it before it causes any issues
            OnCommand=function(self)
                local AV = LoadModule("Config.Load.lua")("AutoVelocity", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
                if not AV then
                    LoadModule("Config.Save.lua")("AutoVelocity", tostring(200), CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
                end
                LoadModule("Player.SetSpeed.lua")(pn)
            end,

            -- Make sure the speed is set relative to the selected song when going to gameplay
            OffCommand=function(self)
                LoadModule("Player.SetSpeed.lua")(pn)
            end
        },

        LoadActor("../ModIcons", pn) .. {
            InitCommand=function(self)
                self:xy(pn == PLAYER_2 and SCREEN_RIGHT + 40 * 2 or -40 * 2, 160)
                :easeoutexpo(1):x(pn == PLAYER_2 and SCREEN_RIGHT - 40 or 40)
            end,
            OffCommand=function(self)
                self:stoptweening():easeoutexpo(1):x(pn == PLAYER_2 and SCREEN_RIGHT + 40 * 2 or -40 * 2)
            end
        },

        Def.ActorFrame {
            InitCommand=function(self)
                self:diffusealpha(0):x(SCREEN_CENTER_X + (pn == PLAYER_2 and 380 or -380)):y(-SCREEN_CENTER_Y)
                :easeoutexpo(1):y(SCREEN_CENTER_Y - 3)
            end,
            OffCommand=function(self)
                self:stoptweening():easeoutexpo(1)
                :y(-SCREEN_CENTER_Y - 100)
            end,

            StepsChosenMessageCommand=function(self, params)
                if params.Player == pn then
                    self:stoptweening():easeoutexpo(0.5)
                    :diffusealpha(1)
                end
            end,
            CurrentChartChangedMessageCommand=function(self, params)
                if params.Player == pn then
                    self:stoptweening():easeoutexpo(0.5):diffusealpha(0)
                end
            end,
            StepsUnchosenMessageCommand=function(self)
                self:stoptweening():diffusealpha(0)
            end,
            SongUnchosenMessageCommand=function(self)
                self:stoptweening():diffusealpha(0)
            end,

            Def.Quad {
                InitCommand=function(self)
                    self:zoomto(190, 32):diffuse(Color.White)

                    if pn == PLAYER_2 then
                        self:faderight(0.2) -- use fadeleft
                    else
                        self:fadeleft(0.2)
                    end
                end
            },

            Def.Sprite {
                Texture=THEME:GetPathG("", "UI/Ready" .. ToEnumShortString(pn)),
                InitCommand=function(self) self:y(1) end
            }
        }
  }
end

--[[t[#t+1] = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, -SCREEN_CENTER_Y):zoom(0.5)
            :easeoutexpo(1):y(SCREEN_CENTER_Y)
        end,
        OffCommand=function(self)
            self:stoptweening():easeoutexpo(1):y(-SCREEN_CENTER_Y)
        end,
        SongChosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y + 95):zoom(1)
        end,
        SongUnchosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.25):y(SCREEN_CENTER_Y):zoom(0.5)
        end,

        Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/InfoPanel"),
            InitCommand=function(self) self:y(85):zoom(0.75) end
        },

        LoadActor("ChartInfo")
    }
}]]--

t[#t+1] = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
        end,
        OffCommand=function(self)
            self:stoptweening():easeoutexpo(1):y(-SCREEN_CENTER_Y)
        end,

        SongChosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y-23):zoom(0.89)
        end,
        SongUnchosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y):zoom(1)
        end,
        
        LoadActor("PadIcons") .. {
            InitCommand=function(self) self:diffusealpha(0) end,
	    SongChosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.3):diffusealpha(1) end,
            SongUnchosenMessageCommand=function(self) self:stoptweening():diffusealpha(0) end
        },

        LoadActor("SongsInfo") .. {
            InitCommand=function(self) self:zoom(2):y(-100):easeoutexpo(1):zoom(0.8) end,
	    SongChosenMessageCommand=function(self) self:stoptweening():y(-110) end,
            SongUnchosenMessageCommand=function(self) self:stoptweening():y(-100) end
        },
        
        Def.ActorFrame {
            InitCommand=function(self) self:y(500):zoom(1.8):sleep(0.1):easeoutexpo(1):zoom(0.77):diffusealpha(1):y(92) end,

            SongChosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.28):y(90):zoom(1.25)
            end,
            SongUnchosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.28):y(92):zoom(0.77)
            end,            

     	    LoadActor("ScoreDisplay") .. {
              InitCommand=function(self) self:zoom(0.8):diffusealpha(0):y(130) end,
	      SongChosenMessageCommand=function(self) self:stoptweening():diffusealpha(1) end,
              SongUnchosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.3):diffusealpha(0) end
      	    },
            LoadActor("BigPreviewBall")..{
              Condition = (LoadModule("Config.Load.lua")("ShowBigBall", "Save/OutFoxPrefs.ini") and GetScreenAspectRatio() >= 1.5)
            },

            LoadActor("ChartDisplay", 12)
        }
    }
}

return t
