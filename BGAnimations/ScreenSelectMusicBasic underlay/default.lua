setenv("IsBasicMode", true)

-- Not load anything if Preferred Sort is not available, this silly check is done
-- because the game will fallback to all songs present in the game install
if #SONGMAN:GetPreferredSortSongs() == SONGMAN:GetNumSongs() then
    local function InputHandler(event)
        local pn = event.PlayerNumber
        if not pn then return end
        
        if event.type == "InputEventType_Release" then return end

        local button = event.button
        if button == "Back" then
            SCREENMAN:GetTopScreen():Cancel()
        end
    end

    return Def.ActorFrame {
        OnCommand=function(self) 
            SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
        end,
        
        Def.Quad {
            InitCommand=function(self) 
                self:FullScreen():diffuse(Color.Black):diffusealpha(0)
                :decelerate(1):diffusealpha(0.5)
            end
        },
        
        Def.BitmapText {
            Font="Common normal",
            Text=THEME:GetString("BasicMode", "NoSongs"),
            InitCommand=function(self) self:Center() end
        }
    }
else

local t = Def.ActorFrame {
    OnCommand=function(self)
        -- Change timing window to Easy
        LoadModule("Config.Save.lua")("SmartTimings",tostring("Pump Easy"),"Save/OutFoxPrefs.ini")
    end,
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

-- The column thing
t[#t+1] = Def.Quad {
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):valign(0.5)
        :zoomx(SCREEN_WIDTH)
        :diffuse(0,0,0,0)
        :zoomy(SCREEN_HEIGHT)
    end,       

	SongChosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.7):diffusealpha(0.8) end,
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

	SongChosenMessageCommand=function(self) self:stoptweening():diffusealpha(0) end,
	SongUnchosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.2):diffusealpha(0.9) end,
}


t[#t+1] = LoadActor("MusicWheel")..{ Name="MusicWheel" }

t[#t+1] = Def. ActorFrame {
	Def.ActorFrame {
        InitCommand=function(self)
            self:diffusealpha(0):xy(SCREEN_CENTER_X, SCREEN_BOTTOM-164)
            :zoomx(1):zoomy(1.35)
        end,
	OnCommand=function(self) self:diffusealpha(0):zoomx(1):zoomy(1):sleep(0.4):linear(0.2):diffusealpha(1):zoomx(0.8):zoomy(0.8):pulse():effectmagnitude(1,1.05,1) end,
 	SongChosenMessageCommand=function(self)
            self:stoptweening():easeoutquad(0.2):zoomx(1.2):zoomy(0.8):diffusealpha(0)
        end,
        SongUnchosenMessageCommand=function(self)
            self:stoptweening():zoomx(1.2):zoomy(0.8):easeoutquad(0.2):zoomx(0.8):zoomy(0.8):diffusealpha(1)
        end,
	CloseGroupWheelMessageCommand=function(self) self:zoomx(1.2):zoomy(0.8):sleep(0.2):easeoutexpo(1):zoomx(0.8):zoomy(0.8) end,
        ScrollMessageCommand=function(self) self:stoptweening():zoomx(0.8):zoomy(0.8):linear(0.12):zoomx(0.9):zoomy(0.9):linear(0.1):zoomx(0.8):zoomy(0.8) end,

	LoadActor(THEME:GetPathB("", "ScreenSelectMusicFull overlay/tg_frameselect")) .. {},
	}
}

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
    local spacing = (IsUsingWideScreen() and 80 or 15)
    local width = (IsUsingWideScreen() and 200 or 175)
    local posx = (pn == PLAYER_1 and SCREEN_LEFT + spacing or SCREEN_RIGHT - (spacing + width + 10) )
    local title = THEME:GetString("MessageBoxes", "TutorialTitle")
    local body = THEME:GetString("MessageBoxes", "TutorialBody")

    t[#t+1] = Def.ActorFrame {
        Name="TutorialMessage"..pn,
        LoadModule("UI.MessageBox.lua")(posx, SCREEN_CENTER_Y - 125, width, 0, 15, title, body)
    }

    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, -SCREEN_CENTER_Y)
            :easeoutexpo(1):y(SCREEN_CENTER_Y)
        end,

        OffCommand=function(self)
            self:stoptweening()
        end,

        Def.ActorFrame {
            InitCommand=function(self) self:y(160):diffusealpha(0):zoom(1) end,

            StepsChosenMessageCommand=function(self, params)
                if params.Player == pn then
                    self:finishtweening():easeoutexpo(0.4)
                    :x(pn == PLAYER_2 and 340 or -340):diffusealpha(1)
                end
            end,
            UpdateChartDisplayMessageCommand=function(self, params) if params.Player == pn then
                self:finishtweening():easeoutexpo(0.3):diffusealpha(0) end
            end,

            SongChosenMessageCommand=function(self)
                self:finishtweening():easeoutexpo(0.3):y(160):zoom(2):diffusealpha(0)
            end,
            SongUnchosenMessageCommand=function(self)
                self:finishtweening():diffusealpha(0)
            end,

            Def.Quad {
                InitCommand=function(self)
                    self:zoomto(190, 53):diffuse(Color.White)

                    if pn == PLAYER_2 then
                        self:faderight(0.2)
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

        LoadActor("SongsInfo") .. {
            InitCommand=function(self) self:zoom(2):y(-110):easeoutexpo(1):zoom(0.8) end
        },

        Def.ActorFrame {
            InitCommand=function(self) self:y(210):zoom(2):easeoutexpo(1):zoom(1):y(85) end,

            SongChosenMessageCommand=function(self)
                self:finishtweening():easeoutexpo(0.28):y(205):zoom(2)
            end,
            SongUnchosenMessageCommand=function(self)
                self:finishtweening():easeoutexpo(0.28):y(85):zoom(1)
            end,

            Def.Sprite {
                Texture=THEME:GetPathG("", "DifficultyDisplay/ShortBar"),
                InitCommand=function(self) self:zoom(1.2) end
            },

            LoadActor("BasicChartDisplay", 4)
        }
    }
}

t[#t+1] = Def.ActorFrame {
    LoadActor("FullModeAnim"),

    CodeCommand=function(self, params)
        if params.Name == "FullMode" then
            LoadModule("Config.Save.lua")("SmartTimings",tostring("Pump Normal"),"Save/OutFoxPrefs.ini")
            self:GetChild("FullModeSound"):play()
            self:GetChild("FullModeAnim"):playcommand("Animate")
            self:sleep(1):queuecommand("FullModeTransition")
        end
    end,

    FullModeTransitionCommand=function(self)
        LastSongIndex = 0
        setenv("IsBasicMode", false)
        LoadModule("Config.Save.lua")("SmartTimings",tostring("Pump Normal"),"Save/OutFoxPrefs.ini")
        self:GetParent():GetChild("MusicWheel"):easeinexpo(0.25):addy(300)
        SCREENMAN:GetTopScreen():SetNextScreenName(SelectMusicOrCourse())
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end,

    Def.Sound {
        Name="FullModeSound",
        File=THEME:GetPathS("", "FullMode"),
        IsAction=true
    }
}

return t

end
