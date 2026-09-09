t = Def.ActorFrame {}

local isSelectingDifficulty = false

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

    -- Larger stationary difficulty icons
    t[#t+1] = Def.ActorFrame {
        Name="BigPreviewBallContainer",

    CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    SongChosenMessageCommand=function(self) isSelectingDifficulty = true self:playcommand("Refresh") end,
    SongUnchosenMessageCommand=function(self) isSelectingDifficulty = false self:playcommand("Refresh") end,

    RefreshCommand=function(self)
      if isSelectingDifficulty then
        local Chart = GAMESTATE:GetCurrentSteps(pn)
        local ChartMeter = Chart:GetMeter()
        if ChartMeter == 99 then ChartMeter = "??" end
        self:GetChild("BigPreviewBallContainer_"..pn):GetChild("BigPreviewBall"):diffuse(ChartTypeToColor(Chart))
        self:GetChild("BigPreviewBallContainer_"..pn):GetChild("BallGlow"):diffuse(ChartTypeToColor(Chart))
        self:GetChild("BigPreviewBallContainer_"..pn):GetChild("MeterText"):settext(ChartMeter)
        self:GetChild("BigPreviewBallContainer_"..pn):GetChild("Difficulty"):settext(FullModeChartLabel(Chart))
      end
    end,

    Def.ActorFrame {
      Name="BigPreviewBallContainer_"..pn,

      InitCommand=function(self)
        self:zoom(1)
        :xy(0, 105)
      end,

      OnCommand=function(self)
        self:diffusealpha(0):xy(0, 105):skewx(pn==PLAYER_1 and 0.2 or -0.2)
      end,

      SongChosenMessageCommand=function(self)
        self:stoptweening()
        :easeoutexpo(0.5)
        :diffusealpha(1)
        :x(pn == PLAYER_1 and -95 or 95):zoom(2)
      end,

      SongUnchosenMessageCommand=function(self)
        self:stoptweening()
        :easeoutexpo(0.25)
        :diffusealpha(0)
        :x(0):zoom(0)
      end,

      Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/euv_ball"),
            Name="BigPreviewBall",
      	InitCommand=function(self) self:zoom(0.723) end
      },

      Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/euv_trim_glow"),
            Name="BallGlow",
      InitCommand=function(self) self:zoom(0.21):spin():effectmagnitude(0,0,pn==PLAYER_1 and 240 or -240):effectperiod(0.4) end
      },

      Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/euv_eval_trim"),
     	    Name="BallLine",
      InitCommand=function(self) self:zoom(0.21) end
      },

      -- new addition to BigPreviewBall (jkob)
      Def.Quad {
        Name="DifficultyBG",
        InitCommand=function(self)
            self:diffuse(0,0,0,0.6):x(-3):y(20):zoomto(90,11):fadeleft(0.2):faderight(0.2)
        end
      },
      Def.BitmapText {
        Font="strike fighter 45px",
        Name="Difficulty",
        InitCommand=function(self) -- to counter the skew, we must skew the skew that skewed the skew (jkob)
          self:zoom(0.2):x(-3):y(20):skewx(pn==PLAYER_1 and -0.2 or 0.2)
        end
      },

      Def.BitmapText {
        Font="Strike Fighter 45px",
        Name="MeterText",
        InitCommand=function(self) -- to counter the skew, we must skew the skew that skewed the skew (jkob)
          self:zoom(0.58):shadowlength(1):skewx(pn==PLAYER_1 and -0.2 or 0.2)
        end
      }
    }
    }

end

return t
