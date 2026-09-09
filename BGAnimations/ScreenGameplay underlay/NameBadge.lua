local pn = ...
local ShouldReverse = LoadModule("Config.Load.lua")("LifePositionBelow","Save/OutFoxPrefs.ini")

local t = Def.ActorFrame {
    OnCommand=function(self)
        if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
            local IsDouble = (GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides")
            local IsCenter = (IsDouble or Center1Player() or GAMESTATE:GetIsFieldCentered(pn)) and GAMESTATE:GetCoinMode() == "CoinMode_Home"
            local PosX = IsCenter and SCREEN_CENTER_X or THEME:GetMetric(Var "LoadingScreen", "Player" .. ToEnumShortString(pn) .. "OnePlayerOneSideX")

            local IsReverse = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():Reverse() > 0 and ShouldReverse
            local PosY = IsReverse and 20 or SCREEN_BOTTOM - 20
    
            self:xy(PosX, PosY)
            self:GetChild("Username"):settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
        end
    end,

    Def.Sprite { 
        Texture=THEME:GetPathG("", "UI/euv_playername_plate"), 
        OnCommand=function(self)
            self:visible(PROFILEMAN:IsPersistentProfile(pn)):zoomy(0.8):zoomx(0):sleep(0.4):easeoutexpo(0.45):zoomx(0.8) 
        end
    },

    Def.BitmapText {
        Font="Inter medium 25px",
        Name="Username",
        OnCommand=function(self) 
            self:visible(PROFILEMAN:IsPersistentProfile(pn)):y(-6):zoom(0):sleep(0.45):easeoutexpo(0.9):zoom(0.7)
        end
    }
}

return t
