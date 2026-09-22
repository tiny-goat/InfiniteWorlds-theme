return Def.ActorFrame {
    -- simplified ScreenInit, i have plans to further improve this soon, but when? (tiny)
    -- bro wake up it's 2008
    CodeMessageCommand=function(self, param)
        if param.Name == "Secret" then
            if _G["Secret"] == true then
                _G["Secret"] = false
                MESSAGEMAN:Broadcast("SecretUpdated")
                SCREENMAN:SystemMessage("returning to "..Year())
            else
                _G["Secret"] = true
                MESSAGEMAN:Broadcast("SecretUpdated")
                SCREENMAN:SystemMessage("bro wake up it's 2008")
            end
        end
    end,

    -- Possibly unnecessary but last time I tried this it didn't work without
    -- it for ??? reasons so I'm not taking any risks
    Def.Quad {
      Name="Background",
      InitCommand=function(self)
          self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
          :diffuse(Color.White)
      end
    },
	
	Def.ActorFrame {
		-- AM Style OutFox intro by tiny
		Name="LogoMain",
		OnCommand=function(self) self:sleep(6):linear(0.7):diffusealpha(0) end,
		
		Def.Sprite {
			Name="OutFoxLogo0",
			Texture="OutFox",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(0):zoom(0.6):cropleft(0.29)
			end,
			OnCommand=function(self)
				self:sleep(2.9):linear(0.7):diffusealpha(1)
			end
		},
	
		Def.Sprite {
			Name="OutFoxLogo1",
			Texture="Fox",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(1):zoom(0.4)
			end,
			OnCommand=function(self)
				self:diffusealpha(0):sleep(0.5):linear(0.7):diffusealpha(1):sleep(0.6):linear(1):zoom(0.18):addx(-190)
			end
		}
		
	},

    Def.Quad {
        Name="ShutdownDark",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffuse(0,0,0,0)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(7):linear(0.7):diffuse(0,0,0,1)
        end
    },

    -- Transitions to the next screen after n seconds
    Def.Quad {
        Name="ScreenTransferActor",
        InitCommand=function(self)
               self:diffuse(0,0,0,0):sleep(8):queuecommand("Transfer")
        end,
        TransferCommand=function(self)
               SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }

}
