return Def.ActorFrame {
	FOV = 90,
    Def.Sprite {
        Name="PlainLoop",
        Texture="iw_logo_4",
	InitCommand=function(self) self:zoom(1.3):croptop(1):diffuse(1,1,1,1):smooth(0.5):croptop(0):sleep(0.2)
	:easeoutexpo(1):diffusetopedge(color("#16EEFF")):diffusebottomedge(color("#FF16EE")):zoom(1) end
    },

    Def.Sprite {
        Name="InnerLoop",
        Texture="iw_logo_3",
        InitCommand=function(self)
          self:MaskSource()
        end
    },

-- duped the grid animation to here, looks awesome af
    Def.Sprite {
        Name="ArrowPatternTop",
        Texture="ArrowPattern",
        InitCommand=function(self)
            self:blend("BlendMode_Add"):diffusealpha(0.3):y(90):diffusecolor(color("#FFFFFF"))
            :zoomto(1125,1125):rotationx(97)
            :customtexturerect(0,0,4,2.4)
            :texcoordvelocity(0.3,1)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end,
	OnCommand=function(self) self:diffusealpha(0):sleep(0.8):diffusealpha(0.3) end
    },
    Def.Sprite {
        Name="ArrowPatternBottom",
        Texture="ArrowPattern",
        InitCommand=function(self)
            self:blend("BlendMode_Add"):diffusealpha(0.3):y(-95):diffusecolor(color("#FFFFFF"))
            :zoomto(1125,1125):rotationx(87)
            :customtexturerect(0,0,4,2.4)
            :texcoordvelocity(-0.3,1)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end,
	OnCommand=function(self) self:diffusealpha(0):sleep(0.8):diffusealpha(0.3) end
    },

    LoadActor("Hat")..{
        Condition = IsAnniversary()
    }

}
