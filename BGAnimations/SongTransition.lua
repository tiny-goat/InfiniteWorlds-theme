local BasicMode = getenv("IsBasicMode")

local ChartLabels = {
    "NEW",
    "ANOTHER",
    "PRO",
    "TRAIN",
    "QUEST",
    "UCS",
    "HIDDEN",
    "INFINITY",
    "JUMP",
}

local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local PlayerDirection = (pn == PLAYER_2 and 1 or -1)

    t[#t+1] = Def.ActorFrame {
        Def.ActorFrame {
            OnCommand=function(self)
                self:xy(pn == PLAYER_2 and SCREEN_RIGHT - 144 or 144, SCREEN_BOTTOM - 64):playcommand("Refresh")
            end,

            StartTransitioningCommand=function(self) self:playcommand("Refresh") end,

            RefreshCommand=function(self)
                if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) and
                SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
                    self:visible(true)

                    local Song = GAMESTATE:GetCurrentSong()
                    local Chart = GAMESTATE:GetCurrentSteps(pn)
                    local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))
                    local ChartMeter = Chart:GetMeter()
                    
                    if ChartMeter == 99 then ChartMeter = "??" end

                    local ChartAuthor = Chart:GetAuthorCredit()
                    if ChartAuthor == "" then ChartAuthor = "Unknown" end

                    self:GetChild("Ball"):diffuse(ChartTypeToColor(Chart))
                    self:GetChild("Meter"):settext(ChartMeter)
                    self:GetChild("Credit"):settext(ChartAuthor)

                    local ChartLabelIndex = 0
                    for Index, String in pairs(ChartLabels) do
                        if string.find(ToUpper(Chart:GetDescription()), String) then
                            ChartLabelIndex = Index
                        end
                    end

                    if ChartLabelIndex ~= 0 then
                        self:GetChild("Label"):visible(not BasicMode):setstate(ChartLabelIndex - 1)
                    else
                        self:GetChild("Label"):visible(false)
                    end
                else
                    self:visible(false)
                end
            end,

            Def.Sprite {
                Name="Frame",
                Texture=THEME:GetPathG("", "UI/StepArtist" .. (pn == PLAYER_2 and "R" or "L")),
		InitCommand=function(self) self:zoom(0.5) end,
            },

            Def.Sprite {
                Name="Ball",
                Texture=THEME:GetPathG("", "DifficultyDisplay/euv_ball"),
                InitCommand=function(self)
                    self:xy(79.25 * PlayerDirection, 0.25):zoom(1.1)
                end
            },

            Def.Sprite {
                Name="BallTrim",
                Texture=THEME:GetPathG("", "DifficultyDisplay/ThickTrim"),
                InitCommand=function(self)
                    self:xy(79.25 * PlayerDirection, 0.25):zoom(0.33)
                end
            },

            Def.BitmapText {
                Name="Meter",
                Font="inter extrabold 45px",
                InitCommand=function(self)
                    self:xy(80.5 * PlayerDirection, 1):zoom(0.9):shadowlength(2)
                end
            },

            Def.Sprite {
                Name="Label",
                Texture=THEME:GetPathG("", "DifficultyDisplay/Labels"),
                InitCommand=function(self)
                    self:xy(79.25 * PlayerDirection, 23.25):visible(false):animate(false)
                end
            },

            Def.BitmapText {
                Name="Credit",
                Font="inter light 22px",
                InitCommand=function(self)
                    self:xy(-41 * PlayerDirection, 22.5)
                    :vertspacing(-8)
                    :wrapwidthpixels(150)
                    :maxheight(40)
                    :maxwidth(150)
                end
            }
        }
   }
end

-- If the screen is transitioning in attract mode, we don't need to show all of this
return (GAMESTATE:IsDemonstration() and Def.Actor{} or t)
