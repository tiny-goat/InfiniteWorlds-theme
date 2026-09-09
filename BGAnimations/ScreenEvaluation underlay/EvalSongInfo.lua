local FrameW = 620
local FrameH = 76

return Def.ActorFrame {
    InitCommand=function(self)
        local Song = GAMESTATE:GetCurrentSong()
        if Song then
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
            self:GetChild("Length"):settext(SecondsToMMSS(Song:MusicLengthSeconds()))
            self:GetChild("BPM"):settext(BPMDisplay .. " BPM")
        else
            self:GetChild("Title"):settext("")
            self:GetChild("Artist"):settext("")
            self:GetChild("Length"):settext("")
            self:GetChild("BPM"):settext("")
        end
    end,

    Def.Sprite {
        Texture=THEME:GetPathG("", "Evaluation/tg_songinfo"),
	InitCommand=function(self) self:zoomx(0):zoomy(0.5):sleep(0.3):easeoutexpo(0.3):zoomx(0.5) end
    },

    Def.BitmapText {
        Font="inter extrabold 40px",
        Name="Title",
        InitCommand=function(self)
            self:zoom(0.3):valign(0)
            :diffuse(Color.Black)
	    :diffusealpha(0)
            :y(-30)
	    :sleep(0.4)
	    :easeoutexpo(0.3)
	    :zoom(0.7)
	    :maxwidth(FrameW * 0.79 / self:GetZoom())
	    :diffusealpha(1)
        end
    },

    Def.BitmapText {
        Font="inter medium 25px",
        Name="Artist",
        InitCommand=function(self)
            self:zoom(0.1):valign(1)
            :maxwidth(FrameW * 0.5 / self:GetZoom())
            :diffuse(Color.Black)
   	    :diffusealpha(0)
            :y(24)
	    :sleep(0.45)
	    :easeoutexpo(0.3)
	    :diffusealpha(1)
	    :zoom(0.7)
        end
    },

    Def.BitmapText {
        Font="inter medium 25px",
        Name="Length",
        InitCommand=function(self)
            self:zoom(0):sleep(0.50):easeoutexpo(0.35):zoom(0.7):halign(1):valign(1)
            :maxwidth(FrameW * 0.2 / self:GetZoom())
            :diffuse(Color.Black)
            :xy(FrameW / 2 - 36, 24)
        end
    },

    Def.BitmapText {
        Font="inter medium 25px",
        Name="BPM",
        InitCommand=function(self)
            self:zoom(0):sleep(0.50):easeoutexpo(0.35):zoom(0.7):halign(0):valign(1)
            :maxwidth(FrameW * 0.175 / self:GetZoom())
            :diffuse(Color.Black)
            :xy(-FrameW / 2 + 36, 24)
        end
    }
}
