local FrameW = SCREEN_WIDTH
local FrameH = SCREEN_HEIGHT

local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local DisplayNotefield = false

-- Video/background display
local t = Def.ActorFrame {
    InitCommand=function(self) self:zoom(1):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y) end,
    OnCommand=function(self)
        self:zoom(1.8):accelerate(0.5):zoom(1)
    end,

    Def.ActorFrame {
        Name="Noise",

        Def.Sprite {
            Texture=THEME:GetPathG("", "Noise"),
            InitCommand=function(self)
                self:zoomto(FrameW, FrameH):diffusebottomedge(color("#16EEFF")):diffusetopedge(color("#EE16FF"))
                :texcoordvelocity(10,5)
            end
        }

    },

    Def.Sprite {
        InitCommand=function(self) self:Load(nil):queuecommand("Refresh") end,
        CurrentSongChangedMessageCommand=function(self) self:Load(nil):queuecommand("Refresh") end,

        RefreshCommand=function(self)
            self:stoptweening():diffusealpha(0):sleep(PreviewDelay)
            Song = GAMESTATE:GetCurrentSong()
            if Song then
                if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil or LoadModule("Config.Load.lua")("ImagePreviewOnly", "Save/OutFoxPrefs.ini") then
                    self:queuecommand("LoadBG")
                else
                    self:queuecommand("LoadAnimated")
                end
            end
        end,

        LoadBGCommand=function(self)
            local Path = Song:GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
                self:LoadFromCached("Background", Path):zoomto(FrameW, FrameH)
                :diffusealpha(0):decelerate(PreviewDelay):diffusealpha(1)
            else
                self:LoadFromCached("Banner", Song:GetBannerPath()):zoomto(FrameW, FrameH)
                :diffusealpha(0):decelerate(PreviewDelay):diffusealpha(1)
            end
        end,

        LoadAnimatedCommand=function(self)
            local Path = Song:GetPreviewVidPath()
            if Path and FILEMAN:DoesFileExist(Path) then
                self:Load(Path):zoomto(FrameW, FrameH)
                :diffusealpha(0):decelerate(PreviewDelay):diffusealpha(1)
            else
                self:queuecommand("LoadBG")
            end
        end
    }
}

return t