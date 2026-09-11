return Def.ActorFrame {
    -- simplified ScreenInit, i have plans to further improve this soon (tiny)
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

    --[[Def.Sound {
        Name="BackgroundHum",
        File="BackgroundHum",
        OnCommand=function(self) self:play() end
    },]]--

    --[[Def.Sound {
        Name="TVOff",
        File="TVOff",
        OnCommand=function(self)
            self:sleep(4.5)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self)
            self:play()
        end
    },]]--

    Def.Sprite {
        Name="OutFoxLogo",
        Texture="OutFox",
        InitCommand=function(self)
            self:Center()
            :diffusealpha(0):zoom(0.6)
        end,
        OnCommand=function(self)
            self:sleep(0.3):linear(0.7):diffusealpha(1)
        end
    },

    Def.Quad {
        Name="ShutdownDark",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffuse(0,0,0,0)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(6.55)
            :linear(0.7):diffuse(0,0,0,1)
        end
    },

    -- Transitions to the next screen after 7 seconds
    Def.Quad {
        Name="ScreenTransferActor",
        InitCommand=function(self)
               self:diffuse(0,0,0,0):sleep(7):queuecommand("Transfer")
        end,
        TransferCommand=function(self)
               SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }

}
