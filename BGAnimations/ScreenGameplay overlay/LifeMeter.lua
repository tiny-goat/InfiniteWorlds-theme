local pn = ...
local TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"
local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"
local ShouldReverse = LoadModule("Config.Load.lua")("LifePositionBelow","Save/OutFoxPrefs.ini")

local BarW = math.ceil(GAMESTATE:GetCurrentStyle():GetWidth(pn) * 1.5)
if BarW > SCREEN_WIDTH then BarW = SCREEN_WIDTH - 80 end
if (GAMESTATE:GetNumPlayersEnabled() > 1 or GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerOneSide")
    and BarW > SCREEN_WIDTH / 2 then BarW = BarW / 2 end 
local BarH = 40

-- thing

local MeterHot = false
local MeterHotPro = false
local MeterDanger = false
local MeterFail = false

local SongPos = GAMESTATE:GetPlayerState(pn):GetSongPosition()
local MeterActor
local MeterUpdate = function(self)
    if not MeterActor then return end
    local MeterVelocity = -(SongPos:GetCurBPS() * 0.5)
    if SongPos:GetFreeze() or SongPos:GetDelay() then MeterVelocity = 0 end
    MeterActor:texcoordvelocity(MeterVelocity, 0)
end

local IsReverse = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():Reverse() > 0 and ShouldReverse
local ScoreDisplay = LoadModule("Config.Load.lua")("ScoreDisplay", CheckIfUserOrMachineProfile(string.sub(pn, -1) - 1).."/OutFoxPrefs.ini")
local SongProgress = LoadModule("Config.Load.lua")("SongProgress", CheckIfUserOrMachineProfile(string.sub(pn, -1) - 1).."/OutFoxPrefs.ini")
local ProLifebar = LoadModule("Config.Load.lua")("ProLifebar", CheckIfUserOrMachineProfile(string.sub(pn, -1) - 1).."/OutFoxPrefs.ini") and string.find(TimingMode, "Pump")
local ProLifebarMax = 1
local ProLifebarCrop = 1

local t = Def.ActorFrame {
    InitCommand=function(self)
		self:SetUpdateFunction(MeterUpdate):addy(IsReverse and 100 or -100)

		if ProLifebar then
			local StepData = GAMESTATE:GetCurrentSteps(pn)
			local StepLevel = StepData:GetMeter()
			-- Temporarily raise three decimals for the overflow formula
			ProLifebarMax = 1000
			-- Limit co-op and other level >30 charts
			if StepLevel > 30 then
				ProLifebarMax = ProLifebarMax + 2700
			else
				ProLifebarMax = ProLifebarMax + StepLevel * StepLevel * 3
			end
			-- Bring the value back to our smaller, usable number
			ProLifebarMax = ProLifebarMax / 1000
			-- The Pro lifebar crop should only start to change when life reaches overflow,
			-- so for our calculations we will subtract the normal life limit of 1
			ProLifebarCrop = 1 / (ProLifebarMax - 1)
		end
	end,

    OnCommand=function(self) self:easeoutexpo(1):addy(IsReverse and -100 or 100):playcommand("Refresh", {Player = pn, Life = 0.5}) end,

    -- This message command is only used if the Gameplay.Life module is active. Due to it being able to
    -- manipulate the player's health, it can restore life and break certain fail conditions, so the visible
    -- health has been decoupled from the engine one.
    UpdateLifeMessageCommand=function(self, params) self:playcommand("Refresh", params) end,

    -- This is required only if a Pump timing mode is not being used.
    LifeChangedMessageCommand=function(self, params)
        if not string.find(TimingMode, "Pump") then
            self:playcommand("Refresh", { Player = params.Player, Life = params.LifeMeter:GetLife() })
        end
    end,

    RefreshMessageCommand=function(self, params)
        if params.Player == pn then
            local LifeAmount = params.Life or 0.5

            if LifeAmount <= 0.33 and not MeterDanger then
                self:GetChild("BarBody"):diffusebottomedge(Color.Red)
                self:GetChild("BarEdgeL"):diffusebottomedge(Color.Red)
                self:GetChild("BarEdgeR"):diffusebottomedge(Color.Red) -- this thing aint flipped bruh
		        self:GetChild("Tip"):visible(0)
		        self:GetChild("Tip-Danger"):visible(1)
                MeterDanger = true
            elseif LifeAmount > 0.33 and MeterDanger and not MeterFail then
                self:GetChild("BarBody"):stoptweening():linear(0.5):diffusebottomedge(Color.White)
                self:GetChild("BarEdgeL"):stoptweening():linear(0.5):diffusebottomedge(Color.White)
                self:GetChild("BarEdgeR"):stoptweening():linear(0.5):diffusebottomedge(Color.White)
		        self:GetChild("Tip-Danger"):visible(0)
                MeterDanger = false
            end

			-- Let's branch out this code so that things aren't too messy/hard to understand
			if ProLifebar then
				-- Only show the rainbow meter if the overflow health is full
				if LifeAmount >= ProLifebarMax and not MeterHotPro then
					self:GetChild("RainbowMeter"):stoptweening():linear(0.5):diffusealpha(1)
					MeterHotPro = true
				elseif LifeAmount < ProLifebarMax and MeterHotPro then
					self:GetChild("RainbowMeter"):diffusealpha(0)
					MeterHotPro = false
				end

				if LifeAmount >= 1 and not MeterHot then
					MeterHot = true
				elseif LifeAmount < 1 and MeterHot then
					MeterHot = false
				end

				self:GetChild("Meter"):finishtweening():x(MeterHot and 0 or -20):linear(0.1):cropright(1 - LifeAmount)
				self:GetChild("Pulse"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * LifeAmount)) - 20)

				local ProLifeAmount = ProLifebarCrop * (LifeAmount - 1)
				if ProLifeAmount < 0 then ProLifeAmount = 0 end

				self:GetChild("ProMeter"):finishtweening():x(MeterHotPro and 0 or -20):linear(0.1):cropright(1 - ProLifeAmount)
				self:GetChild("ProPulse"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * ProLifeAmount)) - 20)
				
				-- lifebar tip for the pro meter
				-- make sure the pro tip only appears when you actually have pro lifebar available, and hide it like usual when capped
				-- this could probably be done better but it works so whatever :V
				if ProLifeAmount <= 0 then
					self:GetChild("Tip-Pro"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - (0)))
					self:GetChild("Tip-Pro"):visible(0)
				elseif ProLifeAmount > 0 and ProLifeAmount <= 0.999 and not MeterHotPro then
					self:GetChild("Tip-Pro"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * ProLifeAmount)))
					self:GetChild("Tip-Pro"):visible(1)
				elseif ProLifeAmount >=1 or MeterHotPro then
					self:GetChild("Tip-Pro"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * 1)))
					self:GetChild("Tip-Pro"):visible(0)
				end
			else
				-- Normal lifebar shenanigans
				if LifeAmount >= 1 and not MeterHot then
					self:GetChild("RainbowMeter"):stoptweening():linear(0.3):diffusealpha(1)
					MeterHot = true
				elseif LifeAmount < 1 and MeterHot then
					self:GetChild("RainbowMeter"):diffusealpha(0)
					MeterHot = false
				end

				self:GetChild("Meter"):finishtweening():x(MeterHot and 0 or -20):linear(0.1):cropright(1 - LifeAmount)
				self:GetChild("Pulse"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * LifeAmount)) - 20)
			end
			
			self:GetChild("Tip"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * LifeAmount)))
			self:GetChild("Tip-Danger"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * LifeAmount)))
			
			-- garbage to make sure that the lifebar actually tweens properly and doesn't just run away from the edge of the lifebar
			-- extra tweening despite lifebar being capped out is just to ensure less jank when the lifebar exits a 'hot' state
			if LifeAmount >=1 and MeterHot and not MeterFail then
				self:GetChild("Tip"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * 1)))
				self:GetChild("Pulse"):finishtweening():visible(false)
				self:GetChild("Tip"):visible(0)
		    elseif LifeAmount > 0.33 and not MeterDanger and not MeterFail then
				self:GetChild("Tip"):visible(1)
				self:GetChild("Pulse"):visible(true)
			end
			
			-- gdi i forgot about the danger/fail tip fleeing too if you lose it when failing
			-- this took way too long to figure out for whatever reason aaaaaaaaaa
			if LifeAmount >=1 and MeterFail then
			    self:GetChild("Tip-Danger"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * 1)))
				self:GetChild("Tip-Danger"):visible(0)
		    elseif LifeAmount > 0 and LifeAmount <= 0.999 and MeterFail then
				self:GetChild("Tip-Danger"):visible(1)
			end

            local PlayerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
            if LifeAmount <= 0 and not MeterFail then
                MeterFail = true
            elseif LifeAmount > 0 and MeterFail and (PlayerOptions:FailSetting() == "FailType_Off") then
                MeterFail = false
            end
        end
    end,

    Def.Sprite {
        Name="Avatar",
        Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"],
        InitCommand=function(self)
            self:scaletofit(0, 0, 37, 37):rotationy(pn==PLAYER_1 and 0 or -180)
            :xy(-BarW / 2 - 29, 0)
        end
    },

    Def.Sprite {
        Name="BarBody",
        Texture=THEME:GetPathG("", "UI/euv_center_lifebars"),
        InitCommand=function(self)
            self:setsize(BarW - 5, BarH)
        end
    },

    Def.Sprite {
        Name="BarEdgeL",
        Texture=THEME:GetPathG("", "UI/euv_lifebars_sides"),
        InitCommand=function(self)
            self:x(-BarW / 1.974):halign(0):zoomx(0.83):setsize(9.3 , BarH)
        end
    },

    Def.Sprite {
        Name="BarEdgeR",
        Texture=THEME:GetPathG("", "UI/euv_lifebars_sides"),
        InitCommand=function(self)
            self:x(BarW / 1.974):halign(0):zoomx(-0.83):setsize(9.3 , BarH)
        end
    },

    Def.Quad {
        Name="Mask",
        InitCommand=function(self)
            self:zoomto(BarW - 12, BarH - 12)
            :diffuse(color(1,1,1,1))
            :MaskSource()
        end
    },

    Def.Quad {
        Name="Meter",
        InitCommand=function(self)
            self:zoomto(BarW - 10, BarH - 16):x(-20):cropright(0.5)
            :diffuse(pn == PLAYER_1 and color("#00d7fd") or color("#00d7fd"))
            :diffusebottomedge(pn == PLAYER_1 and color("#007be8") or color("#007be8"))
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end
    },

    Def.Quad {
        Name="Pulse",
        InitCommand=function(self)
            self:zoomto(20, BarH - 16):halign(0)
            :diffuse(pn == PLAYER_1 and color("#00d7fd") or color("#00d7fd"))
            :diffusebottomedge(pn == PLAYER_1 and color("#007be8") or color("#007be8"))

            self:bounce():effectmagnitude(-20,0,0):effectclock("bgm"):effecttiming(1,0,0,0)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end
    },

    Def.Quad {
        Name="ProMeter",
        InitCommand=function(self)
            self:zoomto(BarW - 12, BarH - 12):x(-20):cropright(1)
            :diffuse(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
            :diffusebottomedge(Color.White)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end
    },

    Def.Quad {
        Name="ProPulse",
        InitCommand=function(self)
            self:zoomto(20, BarH - 12):halign(0):x(-20 - BarW / 2)
            :diffuse(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
            :diffusebottomedge(Color.White)
            self:bounce():effectmagnitude(-20,0,0):effectclock("bgm"):effecttiming(1,0,0,0)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end
    },

    Def.Sprite {
        Name="RainbowMeter",
        Texture=THEME:GetPathG("", "UI/RainbowBar"),
        InitCommand=function(self)
            self:zoomto(BarW - 10.5, BarH - 16)
            :texcoordvelocity(-0.9, 0)
            :diffusealpha(0):diffuseblink():effectcolor1(color("#FFFFFF")):effectcolor2(color("#bbbbbb")):effectperiod(0.09)
        end
    },

    Def.Sprite {
        Name="BarBodyShine",
        Texture=THEME:GetPathG("", "UI/euv_shine_lifebars"),
        InitCommand=function(self)
            self:setsize(BarW - 5, BarH):diffusealpha(0.5)
        end
    },

	-- was the oddly specifiic cropping even necessary? i dont know (tiny)
    Def.Sprite {
        Name="Tip",
        Texture=THEME:GetPathG("", "UI/LifeBarTip/normal-tip"),
        InitCommand=function(self)
            self:zoomto(50, 57):croptop(0.275):cropbottom(0.275)
        end
    },

    Def.Sprite {
        Name="Tip-Danger",
        Texture=THEME:GetPathG("", "UI/LifebarTip/danger-tip"),
        InitCommand=function(self)
			self:visible(0)
            self:zoomto(50, 57):croptop(0.275):cropbottom(0.275)
		end
    },
	
    Def.Sprite {
        Name="Tip-Pro",
        Texture=THEME:GetPathG("", "UI/LifebarTip/pro-tip"),
        InitCommand=function(self)
			self:visible(0)
            self:zoomto(50, 57):croptop(0.275):cropbottom(0.275)
		end
    },

    Def.BitmapText{
        Font="inter medium 25px",
        InitCommand=function(self)
            self:y(-2.5):x(BarW / 2 - 15):rotationy(pn==PLAYER_1 and 0 or -180):zoom(0.8):halign(pn==PLAYER_1 and 1 or 0)
            :diffuse(Color.Yellow):shadowlength(1):playcommand("Refresh")
        end,
        JudgmentMessageCommand=function(self, params)
            if pn == params.Player and ScoreDisplay == "Percent" then
                local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                local TotalAcc = PSS:GetCurrentPossibleDancePoints()
                local CurrentAcc = PSS:GetActualDancePoints()

                if TotalAcc ~= 0 then
                    self:settext(math.floor(CurrentAcc / TotalAcc * 10000) / 100 .. "%")
                else
                    self:settext("0%")
                end
            end
        end,
        UpdateScoreMessageCommand=function(self, params)
            if pn == params.Player and ScoreDisplay == "Score" then
                self:settext((Scoring == "New" and FormatScore(params.Score) or params.Score))
            end
        end
    }
}

if SongProgress then
    t[#t+1] = Def.ActorFrame {
        Def.SongMeterDisplay {
            InitCommand=function(self)
                self:SetStreamWidth(BarW - 12):y(-(BarH / 2) - 1)
            end,
            Stream=Def.Quad {
                InitCommand=function(self) self:zoomto(384, 2):diffuse(Color.Yellow) end
            }
        }
    }
end

return t
