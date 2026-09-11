local FrameW = SCREEN_WIDTH
local FrameH = SCREEN_HEIGHT

local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local DisplayNotefield = false

-- Video/background display
local t = Def.ActorFrame {
    InitCommand=function(self) self:zoom(1):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y) end,

    Def.ActorFrame {
        Name="Back",
		
        Def.Quad {
            Name="Back1",
            InitCommand=function(self)
                self:zoomto(FrameW, FrameH):diffuseleftedge(color("#16EEFF")):diffuserightedge(color("#EE16FF")):fadetop(0.8)
            end
        },

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