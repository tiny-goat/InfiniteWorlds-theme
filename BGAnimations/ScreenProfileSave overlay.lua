return Def.ActorFrame {
	
	Def.Sprite{
		Name="Icon",
		Texture=THEME:GetPathG("", "Logo/Parts/iw_logo_3"),
		InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):diffusealpha(0):zoom(0.8):croptop(1):sleep(0.25):diffusealpha(1):linear(0.4):croptop(0):linear(0.4):cropbottom(1) end,
	},
	
    LoadActor("LoadingIcon")..{
        InitCommand=function(self)
            self:GetChild("Text"):settext("SAVE PROFILE DATA...")
        end
    },

    Def.Actor {
        BeginCommand=function(self)
            if SCREENMAN:GetTopScreen():HaveProfileToSave() then self:sleep(1) end
            self:queuecommand("Load")
        end,
        LoadCommand=function() SCREENMAN:GetTopScreen():Continue() end
    }
}
