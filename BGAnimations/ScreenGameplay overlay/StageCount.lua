local pn = GAMESTATE:GetMasterPlayerNumber()
local IsTwoPlayer = (GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersTwoSides")
local IsDouble = (GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides")
local IsCenter = (IsDouble or Center1Player() or GAMESTATE:GetIsFieldCentered(pn))
local FieldWidth = math.ceil(GAMESTATE:GetCurrentStyle():GetWidth(pn) * 0.75) + 48

return Def.ActorFrame {
    InitCommand=function(self)
        self:y(SCREEN_TOP + 24)
        if IsCenter and not IsTwoPlayer then
            
            self:x(SCREEN_CENTER_X + (GAMESTATE:IsPlayerEnabled(PLAYER_2) and -FieldWidth or FieldWidth))
        else
            self:x(SCREEN_CENTER_X)
        end
    end,
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/euv_stageindicator_base"),
        InitCommand=function(self) self:zoom(0.8):y(8) end
    },
	-- pulse to the beat, i know noteskins already do this, but why not (tiny)
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/euv_glow_stageindicator"),
        InitCommand=function(self) self:diffusealpha(0):zoom(1):y(8):easeoutexpo(1):diffusealpha(1):zoom(0.8):diffuseramp():effectcolor1(color("1,1,1,0.2"))
				:effectcolor2(color("1,1,1,0.8")):effectclock('beat') end
    },

    Def.BitmapText {
        Font="Strike Fighter 45px",
        Text=string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1),
        InitCommand=function(self)
            self:y(14):zoom(0.56)
        end
    }
}
