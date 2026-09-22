local t = Def.ActorFrame {
    InitCommand=function(self)
        -- only reason why this exists is because i want the thing to be silent
        PREFSMAN:SetPreference("MuteActions", true)
    end,
    OffCommand=function(self)
        PREFSMAN:SetPreference("MuteActions", false)
    end
}

return t