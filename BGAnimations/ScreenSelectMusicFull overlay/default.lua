local MenuButtonsOnly = PREFSMAN:GetPreference("OnlyDedicatedMenuButtons")

local t = Def.ActorFrame {
    OnCommand=function(self)
        local pn = GAMESTATE:GetMasterPlayerNumber()
        GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(pn))
        if GAMESTATE:IsCourseMode() then
            GAMESTATE:UpdateDiscordScreenInfo("Selecting Course", "", 1)
        else
            local StageIndex = GAMESTATE:GetCurrentStageIndex()
            GAMESTATE:UpdateDiscordScreenInfo("Selecting Song (Stage " .. StageIndex+1 .. ")", "", 1)
        end
    end,
}

if GAMESTATE:GetNumSidesJoined() < 2 then
    local PosX = SCREEN_CENTER_X + SCREEN_WIDTH * (GAMESTATE:IsSideJoined(PLAYER_1) and 0.35 or -0.35)
    local PosY = (IsUsingWideScreen() and (SCREEN_HEIGHT * 0.4) or SCREEN_HEIGHT * 0.35)

    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self)
            self:xy((IsUsingWideScreen() and PosX or (PosX * 1.045)), PosY)
            :playcommand('Refresh')
        end,

        SongChosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(PosY - 40)
        end,
        SongUnchosenMessageCommand=function(self)
            self:stoptweening():easeoutexpo(0.5):y(PosY)
        end,

        CoinInsertedMessageCommand=function(self) self:playcommand('Refresh') end,

        RefreshCommand=function(self)
            self:GetChild("CenterStep"):visible(NoSongs or GAMESTATE:GetCoins() >= GAMESTATE:GetCoinsNeededToJoin())
            self:GetChild("InsertCredit"):visible(NoSongs or GAMESTATE:GetCoinsNeededToJoin() > GAMESTATE:GetCoins())
        end,

        OffCommand=function(self)
            self:GetChild("CenterStep"):visible(true)
            self:GetChild("InsertCredit"):visible(false)
            self:stoptweening():easeoutexpo(0.25):zoom(2):diffusealpha(0)
        end,

        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            Name="CenterStep",
        },

        LoadActor(THEME:GetPathG("", "InsertCredit")) .. {
            Name="InsertCredit",
        }
    }
end


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

	LoadActor("tg_frameselect") .. {},
	}
}


t[#t+1] = Def.ActorFrame {
    -- Background for the group select wheel
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffusetopedge(Color.Black):diffusebottomedge(color("#00BBDD")):diffusealpha(0)
        end,
        CloseGroupWheelMessageCommand=function(self) self:stoptweening():sleep(0.25):diffusealpha(0) end,
        OpenGroupWheelMessageCommand=function(self) self:stoptweening():easeoutexpo(0.4):diffusealpha(1) end,
    },

    Def.BitmapText {
        Font="Strike Fighter 45px",
        Name="ChanText",
        InitCommand=function(self)
            self:diffusealpha(0)
            :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 200):zoom(0.7)
            :settext("CHANNEL SELECT")
        end,
        CloseGroupWheelMessageCommand=function(self) self:stoptweening():sleep(0.25):diffusealpha(0) end,
        OpenGroupWheelMessageCommand=function(self) self:stoptweening():easeoutexpo(0.4):diffusealpha(1) end
    },

    LoadActor("GroupSelect") .. {
        -- Zoom doesn't center things so we need to recenter them
        InitCommand=function(self)
            self:zoom(1.25):xy(-SCREEN_WIDTH / 8, -SCREEN_HEIGHT / 8)
        end,
    },

 -- here bro, have a flashbang (jkob)
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffuse(Color.White):diffusealpha(0)
        end,
        CloseGroupWheelMessageCommand=function(self) self:stoptweening():diffusealpha(1):sleep(0.3):linear(0.5):diffusealpha(0) end,
    },
   
    LoadActor("../HudPanels"),

    LoadActor("../CornerArrows"),
    
    LoadActor("OptionsList"),

    Def.Sound {
        File=THEME:GetPathS("", "euv_start"),
        IsAction=true,
        PlayerJoinedMessageCommand=function(self)
            self:play()
            SOUND:DimMusic(0, 1)
            SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectProfile")
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.Quad {
        InitCommand=function(self)
            local side = (pn == PLAYER_1 and SCREEN_LEFT or SCREEN_RIGHT)
            local alignment = (pn == PLAYER_1 and 0 or 1)

            if pn == PLAYER_1 then self:faderight(50) else self:fadeleft(75) end

            self:diffuse(1,1,1,1):halign(alignment):xy(side, SCREEN_CENTER_Y-70):zoomto(0, 360)
        end,
        CodeMessageCommand=function(self, params)
            if ((params.Name == "OpenOpList" and not MenuButtonsOnly) or
                params.Name == "OpenOpListButton") and params.PlayerNumber == pn then
                self:diffusealpha(100):zoomto(0, 360)
                :linear(0.25)
                :diffusealpha(0):zoomto(60, 360)
            end
        end
    }
end

return t
