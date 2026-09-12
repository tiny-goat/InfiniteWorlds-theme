local t = Def.ActorFrame {
    OnCommand=function(self)
        -- Reset machine profile mods
        ResetLuaMods(PLAYER_1)
        ResetLuaMods(PLAYER_2)

        GAMESTATE:UpdateDiscordGameMode(GAMESTATE:GetCurrentGame():GetName())
        GAMESTATE:UpdateDiscordScreenInfo("Title Menu", "", 1)
    end,

    
	-- woah suspense bg
    Def.Quad {
		InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end,
		OnCommand=function(self) self:diffusealpha(1):sleep(1.45):easeoutexpo(0.9):diffusealpha(0) end
	},
	
    Def.ActorFrame {
        OnCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREENMAN:GetTopScreen():GetName() == "ScreenLogo" and SCREEN_CENTER_Y or SCREEN_CENTER_Y - 20)
            :queuecommand("ZoomY")
        end,

        OffCommand=function(self)
            self:stoptweening()
            :easeoutexpo(0.5)
            :zoom(1.5):diffusealpha(0)
        end,

        ZoomYCommand=function(self)
            self:accelerate(3.4288)
            :zoom(0.96)
            :decelerate(3.4288)
            :zoom(1)
            :queuecommand("ZoomY")
        end,

        LoadActor(THEME:GetPathG("", "Logo/Parts"))..{
            InitCommand=function(self)
                self:zoom(0.8)
            end
        }
},

    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, 20):zoom(0.6)
        end,

        OffCommand=function(self)
            self:stoptweening():easeoutexpo(1):xy(SCREEN_CENTER_X, -80)
        end,

        Def.BitmapText {
            Font="inter light 22px",
            InitCommand=function(self)
                local InstalledSongs, Groups, InstalledCourses = 0
                if SONGMAN:GetRandomSong() then
                    InstalledSongs, Groups, InstalledCourses =
                        SONGMAN:GetNumSongs() + SONGMAN:GetNumAdditionalSongs() + SONGMAN:GetNumUnlockedSongs(),
                        SONGMAN:GetNumSongGroups(),
                        SONGMAN:GetNumCourses() + SONGMAN:GetNumAdditionalCourses()
                else
                    return
                end

                self:settextf(THEME:GetString("ScreenTitleMenu", "%i Songs (%i Groups), %i Courses"), InstalledSongs, Groups, InstalledCourses)
            end
        },

        Def.BitmapText {
            Font="inter light 22px",
            Text=string.format("OutFox %s - %s", ProductVersion(), VersionDate()),
            AltText="OutFox",
            InitCommand=function(self) self:y(20) end
        }
    }
}

if not IsHome() and GAMESTATE:EnoughCreditsToJoin() then
    t[#t+1] = Def.ActorFrame {
        OnCommand=function(self)
            -- Hide "Press Center Step" icons if we're on ScreenLogo
            self:visible(SCREENMAN:GetTopScreen():GetName() ~= "ScreenLogo" and true or false)
        end,

        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X - SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.75):queuecommand("Refresh") end,
	    OnCommand=function(self) self:diffusealpha(0):zoom(1.8):sleep(0.4):easeoutexpo(0.2):zoom(1):diffusealpha(1) end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(.5):zoom(0):diffusealpha(0) end,
            StorageDevicesChangedMessageCommand=function(self)self:queuecommand("Refresh")end,
            RefreshCommand=function(self)
    			CardState = MEMCARDMAN:GetCardState(PLAYER_1)
    			if CardState == "MemoryCardState_none" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/tg_press_step"))
    			elseif CardState == "MemoryCardState_ready" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/euv_usb1"))
    			elseif CardState == "MemoryCardState_error" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/euv_usb2"))
    			end
    		end
        },

        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X + SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.75):queuecommand("Refresh") end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(.5):zoom(0):diffusealpha(0) end,
	    OnCommand=function(self) self:diffusealpha(0):zoom(1.8):sleep(0.4):easeoutexpo(0.2):zoom(1):diffusealpha(1) end,
            StorageDevicesChangedMessageCommand=function(self)self:queuecommand("Refresh")end,
            RefreshCommand=function(self)
    			CardState = MEMCARDMAN:GetCardState(PLAYER_2)
    			if CardState == "MemoryCardState_none" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/tg_press_step"))
    			elseif CardState == "MemoryCardState_ready" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/euv_usb1"))
    			elseif CardState == "MemoryCardState_error" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/euv_usb2"))
    			end
    		end
        }
    }
end

return t
