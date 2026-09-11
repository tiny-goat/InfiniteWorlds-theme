local t = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, -128)
        end,
        OnCommand=function(self)
            self:easeoutexpo(0.5):xy(SCREEN_CENTER_X, 0)
        end,
        OffCommand=function(self)
            self:sleep(0.2):easeoutexpo(0.9):xy(SCREEN_CENTER_X, -128)
        end,

        Def.Sprite {
            Texture=THEME:GetPathG("", "UI/euv_header_up"),
            InitCommand=function(self)
                self:scaletofit(0, 0, 1280, 128):xy(0, 0):valign(0)
            end,
        },

        -- Screen name
        Def.BitmapText {
            Name="ScreenName",
            Font="inter extrabold 45px",
            Text=ToUpper(Screen.String("HeaderText")),
            InitCommand=function(self)
                self:xy(-WideScale(255, 230), 0):zoom(0.6):sleep(0.2):diffusealpha(0):easeoutexpo(1):xy(-WideScale(200, 165), 45):halign(1):skewy(0.1)
                :diffuse(Color.White)

                if not IsUsingWideScreen() then
                    local IsSelectMusic = self:GetText() == "SELECTMUSIC"
                    if IsSelectMusic then self:x(-WideScale(170, 170)) end

                    local WidthLimit = (IsSelectMusic and 189 or 160) / self:GetZoom()
                    self:maxwidth(WidthLimit):wrapwidthpixels(WidthLimit):zoom(0.64):vertspacing(2)
                end
            end,
        },

        -- Stage count
        Def.BitmapText {
            Font="inter medium 25px",
            InitCommand=function(self)
		local PosY = IsUsingWideScreen() and 74 or 74
                self:visible(Screen.String("HeaderText") == "Select Music" and true or false)
                self:settext("Round "..string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1))
                self:diffusealpha(0):xy(-WideScale(150, 150), 60):zoom(0.6):sleep(0.3):easeoutexpo(1):xy(-WideScale(0, 0), PosY):diffuse(Color.White)
            end,
        },

        -- Amount of lives left
        Def.ActorFrame {
            InitCommand=function(self)
                self:xy(WideScale(220, 225), 40):zoom(1.1):skewy(-0.1)
            end,
	    OnCommand=function(self) self:xy(WideScale(220,300), 0):sleep(0.2):easeoutexpo(1):xy(WideScale(220, 225), 40) end,

            Def.Sprite {
                Texture=THEME:GetPathG("", "UI/euv_heartbank"),
                InitCommand=function(self)
                    self:cropleft(0.38):zoomx(0.2):zoomy(0.2):y(0):x(-38):diffusealpha(0.8):sleep(0.2):easeoutexpo(1.1):zoomx(0.2):zoomy(0.2):diffusealpha(1)
                end
            },

            Def.BitmapText {
                Font="inter medium 25px",
                InitCommand=function(self)
                    self:x(-5):y(-2):zoom(0):shadowlength(2):halign(0):diffusealpha(0):sleep(0.2):smooth(0.1):zoom(0.9):diffusealpha(1)

                    local Hearts = GAMESTATE:GetNumStagesLeft(PLAYER_1) + GAMESTATE:GetNumStagesLeft(PLAYER_2)
                    self:settext("" .. (GAMESTATE:IsEventMode() and "∞" or Hearts))
                end,
		OffCommand=function(self) self:sleep(0.5):diffusealpha(0) end
            },

            Def.Sprite {
                Texture=THEME:GetPathG("", "UI/euv_hbheart"),
                InitCommand=function(self)
                    self:zoom(0.2):y(-1):x(5):sleep(0.1):easeoutexpo(1.1):zoom(0.2):x(-26)
                end,
                OffCommand=function(self)
                    self:x(-21):zoom(0.2):easeoutexpo(1.1):x(5)
                end
            },
        }
    },

    -- Bottom panel
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/euv_footer_part"),
        InitCommand=function(self)
            self:scaletofit(0, 0, 1280, 140)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128):valign(1)
        end,
        OnCommand=function(self)
            self:sleep(0.1):easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM)
        end,
        OffCommand=function(self)
            self:sleep(0.2):easeoutexpo(0.9)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128)
        end,
    },
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/euv_footer_down"),
        InitCommand=function(self)
            self:scaletofit(0, 0, 1280, 128)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128):valign(1)
        end,
        OnCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 10)
        end,
        OffCommand=function(self)
            self:sleep(0.2):easeoutexpo(0.9)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128)
        end,
    },

}

-- Avatar display and info on bottom panel
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    if PROFILEMAN:GetProfile(pn) and (PROFILEMAN:IsPersistentProfile(pn) or PROFILEMAN:ProfileWasLoadedFromMemoryCard(pn)) then
        t[#t+1] = Def.ActorFrame {
            Def.ActorFrame {
                InitCommand=function(self) 
			-- very weird aligment, this'll be my fix for now
			local PosP1 = IsUsingWideScreen() and -670 or -510
			local PosP2 = IsUsingWideScreen() and -605 or -450
			self:y(108):x(SCREEN_CENTER_X + (pn == PLAYER_2 and PosP2 or PosP1)) end,
                OnCommand=function(self) self:easeoutexpo(0.5):y(-7) end,
                OffCommand=function(self) self:sleep(0.2):easeoutexpo(0.9):y(128) end,

                Def.Sprite {
                    Texture=THEME:GetPathG("", "UI/euv_maskslot"),
                    InitCommand=function(self)
                        self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 221 or -221), SCREEN_BOTTOM - 22)
                        :rotationy(pn == PLAYER_2 and 180 or 0):zoom(1.5):MaskSource()
                    end
                },
		-- reorder the layering thing of this thing
		Def.Sprite {
                    Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"],
                    InitCommand=function(self)
                        self:scaletocover(0, 0, 289, 289)
                        :xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 222 or -222), SCREEN_BOTTOM - 8)
                        :MaskDest():ztestmode("ZTestMode_WriteOnFail"):diffusealpha(0.8)
                    end
                },

-- what a genius way of making the names and level finally readable /s (tiny)
		Def.Quad {
		    InitCommand=function(self) 
			self:diffuse(Color.Black):diffusealpha(0.6):MaskDest():ztestmode("ZTestMode_WriteOnFail")
			:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 60 or -60), SCREEN_BOTTOM - 43)
			:fadeleft(0.2):faderight(0.2):zoomto(150,44):halign(pn == PLAYER_2 and 0 or 1):valign(0) end
		},

		Def.Sprite {
                    Texture=THEME:GetPathG("", "UI/euv_glow_dock"),
                    InitCommand=function(self)
                        self:zoomy(1.52):xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 184 or -184), SCREEN_BOTTOM - 20)
                        :rotationy(pn == PLAYER_2 and 180 or 0):rotationz(-4):queuecommand("Breathe"):diffusecolor(color(pn==PLAYER_2 and ("#EE16FF") or ("#16EEFF"))):fadetop(0.5)
                    end,
		    BreatheCommand=function(self) self:diffusealpha(0.4):linear(2):diffusealpha(1):linear(2):diffusealpha(0.4):queuecommand("Breathe") end
                },

	 	Def.Sprite {
                    Texture=THEME:GetPathG("", "UI/euv_dock_light"),
                    InitCommand=function(self)
                        self:zoomy(1.52):xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 184 or -184), SCREEN_BOTTOM - 20)
                        :rotationy(pn == PLAYER_2 and 180 or 0):rotationz(-4)
                    end,
                },

                Def.BitmapText {
                    Font="inter medium 25px",
                    Text=PROFILEMAN:GetProfile(pn):GetDisplayName(),
                    InitCommand=function(self)
                        self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 130 or -130), SCREEN_BOTTOM - 45):zoom(0.7):halign(pn == PLAYER_2 and 0 or 1):valign(0)
                        :maxwidth(112 / self:GetZoom())

                        if PROFILEMAN:GetProfile(pn):GetDisplayName() == "" then
                            self:settext(THEME:GetString("ProfileStats", "No Profile"))
                        end
                    end
                },

                Def.BitmapText {
                    Font="inter medium 25px",
                    -- This ingenious level system was made up at 4am
                        InitCommand=function(self)
                        self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 155 or -155), SCREEN_BOTTOM - 13):zoom(0.7)
                        :maxwidth(96 / self:GetZoom())
                        lvl = math.floor(math.sqrt(PROFILEMAN:GetProfile(pn):GetTotalDancePoints() / 500)) + 1
                        -- You can check if a number is "nan" by comparing it to itself
                        -- because "nan" is not equal to anything, not even itself
                        if (lvl < 0) or (lvl ~= lvl) then lvl = 0 end
                        self:settext(THEME:GetString("ProfileStats", "Level") .. " " .. lvl)
                    end
                },
            }
        }
    end
end

return t
