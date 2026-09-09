local t = Def.ActorFrame {}

-- Solid Background
t[#t+1] = Def.Quad {
    Name="Background",
    InitCommand=function(self)
        self:Center()
        :zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
        :diffuse(color("#000000"))
    end
}

-- Gradient overlay
t[#t+1] = Def.Sprite {
    Name="Gradient",
    Texture="gradient",
    InitCommand=function(self)
        self:Center():diffuse(color("#16EEFF"))
        :queuecommand("Refresh")
    end,
    ScreenChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
    RefreshCommand=function(self)
            self:diffusebottomedge(color("#16EEFF")):diffusetopedge(color("#EE16FF"))
    end
}

-- Squiggly Things (with random speed!)
for i=1,4 do
    t[#t+1] = Def.Sprite {
        Name="Squiggle" .. i,
        Texture="Squiggles/" .. i,
        InitCommand=function(self)
            self:Center()
            :zoom(1 + i / 8)
            :texcoordvelocity((math.random(-3, 3) / 10) + 0.05, 0) -- bad hack to make sure the X velocity is 0 less often
            :diffusealpha(0.15)
        end
    }
end

-- Top/Bottom Grids
t[#t+1] = LoadActor(THEME:GetPathG("", "Grid"))

-- Circles (not the kind you click)
t[#t+1] = Def.Sprite {
    Name="Circle1",
    Texture="Circle",
    InitCommand=function(self)
        self:Center():zoom(0)
        :blend("BlendMode_Add")
        :queuecommand("Grow")
    end,
    GrowCommand=function(self)
        self:stoptweening()
	:diffusealpha(1)
        :zoom(0)
        :linear(3.4288)
        :zoom(1.85)
	:diffusealpha(0)
        :queuecommand("Grow")
    end
}

-- Circles (not the kind you click)
t[#t+1] = Def.Sprite {
    Name="Circle1",
    Texture="Core",
    InitCommand=function(self)
        self:Center():zoom(0):sleep(0.5):easeoutexpo(0.5):zoom(1)
        :blend("BlendMode_Add")
    end
}

t[#t+1] = Def.Sprite {
    Name="OtherCircle",
    Texture="Dashcircle",
    InitCommand=function(self)
        self:visible(true)
        :Center():zoom(0)
        :blend("BlendMode_Add")
        :sleep(1)
        :queuecommand("Grow")
    end,
    GrowCommand=function(self)
        self:diffusealpha(1):stoptweening()
        :zoom(0)
	:rotationz(-100)
        :linear(3.4288)
	:rotationz(78)
        :zoom(0.95)
	:diffusealpha(0)
        :queuecommand("Grow")
    end
}

t[#t+1] = Def.Sprite {
    Name="Circle2",
    Texture="Circle",
    InitCommand=function(self)
        self:visible(false)
        :Center():zoom(0)
        :blend("BlendMode_Add")
        :sleep(1.7144)
        :queuecommand("Grow2")
    end,
    Grow2Command=function(self)
        self:visible(true):stoptweening()
        :zoom(0)
        :linear(3.4288)
        :zoom(3)
        :queuecommand("Grow2")
    end
}
t[#t+1] = LoadActor("confetti")..{
    Condition=IsAnniversary()
}

return t
