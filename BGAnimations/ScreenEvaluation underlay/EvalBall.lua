local pn = ...
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

return Def.ActorFrame {
    InitCommand=function(self)
        if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) then
            local Song = GAMESTATE:GetCurrentSong()
            local Chart = GAMESTATE:GetCurrentSteps(pn)
            local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))
            local ChartMeter = Chart:GetMeter()
            
            if ChartMeter == 99 then ChartMeter = "??" end
            
            self:GetChild("Ball"):diffuse(ChartTypeToColor(Chart))
            self:GetChild("BallTrimGlow"):diffuse(ChartTypeToColor(Chart))
            self:GetChild("Meter"):settext(ChartMeter)
            self:GetChild("Difficulty"):settext(BasicMode and BasicChartLabel(Chart) or FullModeChartLabel(Chart))
            
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
        end
    end,

    OnCommand=function(self) self:skewx(pn==PLAYER_1 and 0.2 or -0.2) end,
    
    Def.Sprite {
        Name="Ball",
        Texture=THEME:GetPathG("", "DifficultyDisplay/euv_ball"),
        InitCommand=function(self) 
            self:zoom(1)
        end
    },
    
    Def.Sprite {
        Name="BallTrimGlow",
        Texture=THEME:GetPathG("", "DifficultyDisplay/euv_trim_glow"),
        InitCommand=function(self) 
            self:zoom(0.3):spin():effectmagnitude(0,0,pn==PLAYER_1 and 180 or -180):effectperiod(0.4)
        end
    },

    Def.Sprite {
        Name="BallTrim",
        Texture=THEME:GetPathG("", "DifficultyDisplay/euv_eval_trim"),
        InitCommand=function(self) 
            self:zoom(0.3)
        end
    },
    
    Def.BitmapText {
        Name="Meter",
        Font="Strike Fighter 45px",
        InitCommand=function(self)
            self:zoom(0.73):y(0):x(0):skewx(pn==PLAYER_1 and -0.2 or 0.2)
        end
    },
    

    Def.Quad {
        Name="DifficultyBG",
        InitCommand=function(self)
            self:diffuse(0,0,0,0.6):y(34):x(-3):zoomto(140,13):fadeleft(0.4):faderight(0.4)
        end
    },
    Def.BitmapText {
        Font="Strike Fighter 45px",
        Name="Difficulty",
        InitCommand=function(self)
            self:y(34):x(-3):visible(true):zoom(0.3):strokecolor(Color.Black):skewx(pn==PLAYER_1 and -0.2 or 0.2)
        end
    },
    
    Def.Sprite {
        Name="Label",
        Texture=THEME:GetPathG("", "DifficultyDisplay/Labels"),
        InitCommand=function(self)
            self:y(24):visible(false):animate(false)
        end
    }
}
