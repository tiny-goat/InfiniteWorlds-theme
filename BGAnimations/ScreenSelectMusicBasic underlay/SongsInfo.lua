local FrameW = 640
local FrameH = 360

local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local DisplayNotefield = false

local t = Def.ActorFrame {}

-- Portion dedicated to song stats
t[#t+1] = Def.ActorFrame {
    InitCommand=function(self) self:playcommand("Refresh") end,
    CurrentSongChangedMessageCommand=function(self) self:playcommand("Refresh") end,

    RefreshCommand=function(self)
        if GAMESTATE:GetCurrentSong() then
            local Song = GAMESTATE:GetCurrentSong()

            local TitleText = Song:GetDisplayFullTitle()
            if TitleText == "" then TitleText = "Unknown" end

            local AuthorText = Song:GetDisplayArtist()
            if AuthorText == "" then AuthorText = "Unknown" end

            local BPMRaw = Song:GetDisplayBpms()
            local BPMLow = math.ceil(BPMRaw[1])
            local BPMHigh = math.ceil(BPMRaw[2])
            local BPMDisplay = (BPMLow == BPMHigh and BPMHigh or BPMLow .. "-" .. BPMHigh)

            if Song:IsDisplayBpmRandom() or BPMDisplay == 0 then BPMDisplay = "???" end

            self:GetChild("Title"):settext(TitleText)
	    self:GetChild("Artist"):settext(AuthorText)
            self:GetChild("BPM"):settext("BPM " .. BPMDisplay)

            if GAMESTATE:IsEventMode() then
                self:GetChild("HeartsIcon"):visible(false)
                self:GetChild("Hearts"):visible(false)
            else
                self:GetChild("HeartsIcon"):visible(true)
                self:GetChild("Hearts"):visible(true):settext("" .. Song:GetStageCost() * GAMESTATE:GetNumPlayersEnabled())
            end
        else
            self:GetChild("Title"):settext("")
            self:GetChild("Artist"):settext("")
            self:GetChild("BPM"):settext("")
        end
    end,

	-- thing (tiny)
	
		Def.BitmapText {
			Name="NextPrevText",
			Font="Strike Fighter 45px",
			Text="",
			InitCommand=function(self)
				self:zoom(2):x(0):y(-20)
				--:shadowcolor(0,0,0)
			end,
		
			ScrollMessageCommand=function(self, params) if params.Direction == 1 then
				self:stoptweening()
				:settext("NEXT")
				:x(90)
				:diffusealpha(1)
				:zoom(3)
				:decelerate(PreviewDelay)
				:diffusealpha(0)
				:x(0)
				else
				self:stoptweening()
				:settext("PREV")
				:x(-90)
				:diffusealpha(1)
				:zoom(3)
				:decelerate(PreviewDelay)
				:diffusealpha(0)
				:x(0)
				end
			end,
		
		},
		
    Def.Quad {
        InitCommand=function(self)
            self:zoomto(FrameW, 50):y(FrameH / 2):valign(1)
            :diffuse(Color.Black):diffusealpha(0.5):fadeleft(0.2):faderight(0.2)
        end,
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():zoomto(30, 67):y(FrameH / 1.84):diffusealpha(0.8):easeoutquad(0.4):zoomto(FrameW, 67):diffusealpha(0.9)
        end
    },

    Def.BitmapText {
        Font="inter medium 25px",
        Name="Title",
        InitCommand=function(self)
            self:zoom(1)
            :maxwidth(FrameW * 0.5 / self:GetZoom())
            :x(0)
            :y(142)
        end,
	ScrollMessageCommand=function(self, params) if params.Direction == 1 then
            self:stoptweening():x(80):easeoutexpo(0.8):x(0)
	else
            self:stoptweening():x(-80):easeoutexpo(0.8):x(0) end
	end
    },

    Def.BitmapText {
        Font="inter medium 25px",
        Name="Artist",
        InitCommand=function(self)
            self:zoom(0.7):valign(1)
            :maxwidth(FrameW * 0.39 / self:GetZoom())
            :x(0)
            :y(174):diffuse(color("#CCEE00"))
        end,
	ScrollMessageCommand=function(self, params) if params.Direction == 1 then
            self:stoptweening():x(80):diffusealpha(0):sleep(0.1):easeoutexpo(0.8):diffusealpha(1):x(0)
	else
            self:stoptweening():x(-80):diffusealpha(0):sleep(0.1):easeoutexpo(0.8):diffusealpha(1):x(0) end
	end
    },

    Def.BitmapText {
        Font="inter medium 25px",
        Name="BPM",
        InitCommand=function(self)
            self:zoom(0.7):valign(1)
            :maxwidth(FrameW * 0.2 / self:GetZoom())
            :x(0)
            :y(192):diffuse(color("#00CCEE"))
        end,
	ScrollMessageCommand=function(self, params) if params.Direction == 1 then
            self:stoptweening():x(80):diffusealpha(0):sleep(0.2):easeoutexpo(0.8):diffusealpha(1):x(0)
	else
            self:stoptweening():x(-80):diffusealpha(0):sleep(0.2):easeoutexpo(0.8):diffusealpha(1):x(0) end
	end
    },

    Def.BitmapText {
        Font="inter medium 25px",
        Name="Hearts",
        InitCommand=function(self)
            self:zoom(1):halign(0)
            :x(-265)
            :y(142)

            local Hearts = GAMESTATE:GetNumStagesLeft(PLAYER_1) + GAMESTATE:GetNumStagesLeft(PLAYER_2)
            self:settext(" " .. (GAMESTATE:IsEventMode() and "∞" or Hearts))
        end,
	CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():x(-300):diffusealpha(0):sleep(0.4):diffusealpha(1):easeoutquad(0.2):x(-280) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/euv_hbheart"),
        Name="HeartsIcon",
        InitCommand=function(self)
            self:zoom(0.2):halign(0)
            :x(-315)
            :y(144)
	end,
	CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():x(-244):diffusealpha(0):sleep(0.18):easeoutexpo(0.6):diffusealpha(1):x(-315) end
    }
}

return t