local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/vkzpeep/open-source/main/gui_vkz')))()
local Window = OrionLib:MakeWindow({Name = "Neurasthenia Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "Universal",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Aimbot",
	Callback = function()
		local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()
Aimbot.Load()
  	end    
})

Tab:AddButton({
	Name = "Esp",
	Callback = function()
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/cool83birdcarfly02six/UNIVERSALESPLTX/main/README.md'),true))()
Aimbot.Load()
  	end    
})

Tab:AddButton({
	Name = "Fps Boost",
	Callback = function()
		local ToDisable = {
            Textures = true,
            VisualEffects = true,
            Parts = true,
            Particles = true,
            Sky = true
        }
        
        local ToEnable = {
            FullBright = false
        }
        
        local Stuff = {}
        
        for _, v in next, game:GetDescendants() do
            if ToDisable.Parts then
                if v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Particles then
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.VisualEffects then
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Textures then
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Texture = ""
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Sky then
                if v:IsA("Sky") then
                    v.Parent = nil
                    table.insert(Stuff, 1, v)
                end
            end
        end
        
        game:GetService("TestService"):Message("Effects Disabler Script : Successfully disabled "..#Stuff.." assets / effects. Settings :")
        
        for i, v in next, ToDisable do
            print(tostring(i)..": "..tostring(v))
        end
        
        if ToEnable.FullBright then
            local Lighting = game:GetService("Lighting")
            
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Lighting.FogEnd = math.huge
            Lighting.FogStart = math.huge
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 5
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Outlines = true
        end
Aimbot.Load()
  	end    
})

Tab:AddButton({
	Name = "Chat Bypass",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Synergy-Networks/products/main/BetterBypasser/loader.lua",true))()
  	end    
})

Tab:AddButton({
	Name = "Reverse",
	Callback = function()
		local key = "E" --key to intiate the flashback. see https://create.roblox.com/docs/reference/engine/enums/KeyCode for an exhaustive list
local flashbacklength = 60 --how long the flashback should be stored in approx seconds
local flashbackspeed = 0.1 --how many frames to skip during flashback (set to 0 to disable)

local name = game:GetService("RbxAnalyticsService"):GetSessionId() --unique id that games cannot access but does not change on subsequent executions (used for the name of the binded function)
local frames,uis,LP,RS = {},game:GetService("UserInputService"),game:GetService("Players").LocalPlayer,game:GetService("RunService") --set some vars

pcall(RS.UnbindFromRenderStep,RS,name) --unbind the function if previously binded

local function getchar()
   return LP.Character or LP.CharacterAdded:Wait()
end

function gethrp(c) --gethrp ripped from my env script and stripped of arguments
return c:FindFirstChild("HumanoidRootPart") or c.RootPart or c.PrimaryPart or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") or c:FindFirstChildWhichIsA("BasePart")
end

local flashback = {lastinput=false,canrevert=true}

function flashback:Advance(char,hrp,hum,allowinput)
   
   if #frames>flashbacklength*60 then --make sure we don't have too much history
       table.remove(frames,1)
   end
   
   if allowinput and not self.canrevert then
       self.canrevert = true
   end
   
   if self.lastinput then --make sure platformstand goes back to normal
       hum.PlatformStand = false
       self.lastinput = false
   end
   
   table.insert(frames,{
       hrp.CFrame,
       hrp.Velocity,
       hum:GetState(),
       hum.PlatformStand,
       char:FindFirstChildOfClass("Tool")
   })
end

function flashback:Revert(char,hrp,hum)
   local num = #frames
   if num==0 or not self.canrevert then --add to history and return if no history is present
       self.canrevert = false
       self:Advance(char,hrp,hum)
       return
   end
   for i=1,flashbackspeed do --skip frames (if enabled)
       table.remove(frames,num)
       num=num-1
   end
   self.lastinput = true
   local lastframe = frames[num]
   table.remove(frames,num)
   hrp.CFrame = lastframe[1]
   hrp.Velocity = -lastframe[2]
   hum:ChangeState(lastframe[3])
   hum.PlatformStand = lastframe[4] --platformstand to make flying look normal again
   local currenttool = char:FindFirstChildOfClass("Tool")
   if lastframe[5] then --equip/unequip tools
       if not currenttool then
           hum:EquipTool(lastframe[5])
       end
   else
       hum:UnequipTools()
   end
end

local function step() --function that runs every frame
   local char = getchar()
   local hrp = gethrp(char)
   local hum = char:FindFirstChildWhichIsA("Humanoid")
   if uis:IsKeyDown(Enum.KeyCode[key]) then --begin flashback
       flashback:Revert(char,hrp,hum)
   else
       flashback:Advance(char,hrp,hum,true)
   end
end
RS:BindToRenderStep(name,1,step) --finally, bind our function
Aimbot.Load()
  	end    
})

Tab:AddButton({
	Name = "Simples spy",
	Callback = function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpyBeta.lua"))()
  	end    
})


Tab:AddButton({
	Name = "Hamster Boll",
	Callback = function()
		loadstring(game:HttpGet(("https://pastebin.com/raw/xJ9gMV2E"), true))()
  	end    
})

Tab:AddButton({
	Name = "Parkour",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperKayMan364/Fe-Parkour-V2/main/Script"))()
  	end    
})

Tab:AddButton({
	Name = "Infinity Yield",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  	end    
})

Tab:AddButton({
	Name = "Nameless",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
  	end    
})

Tab:AddButton({
	Name = "System Broken",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
  	end    
})

Tab:AddButton({
	Name = "Ghost Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
  	end    
})

Tab:AddButton({
	Name = "Game Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerScripter/Game-Hub/main/loader"))()
  	end    
})

Tab:AddButton({
	Name = "Tela Esticada",
	Callback = function()
		getgenv().Resolution = {
			[".gg/scripters"] = 0.7
		}
		 
		local Camera = workspace.CurrentCamera
		if getgenv().gg_scripters == nil then
			game:GetService("RunService").RenderStepped:Connect(
				function()
					Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
				end
			)
		end
		getgenv().gg_scripters = "Aori0001"
  	end    
})

Tab:AddButton({
	Name = "Leg Admin",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/leg1337/legadmv2/main/legadminv2.lua'))()
  	end    
})

local Section = Tab:AddSection({
	Name = "Velocidade e Pulo"
})

Tab:AddSlider({
	Name = "velocidade",
	Min = 16,
	Max = 500,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

Tab:AddSlider({
	Name = "Pulo",
	Min = 50,
	Max = 500,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Pulo",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end    
})


local Section = Tab:AddSection({
	Name = "Fly Mobile"
})

Tab:AddButton({
	Name = "Fly Mobile",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
  	end    
})

local Section = Tab:AddSection({
	Name = "Jogos com colissão"
})

Tab:AddButton({
	Name = "Fling all",
	Callback = function()
		print("Before the while loop")



local Targets = {"All"} -- "All", "Target Name", "Target name can be shortened"
 
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
 
local AllBool = falseasa
 
local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^"..Name) then
                    return x;
                elseif x.DisplayName:lower():match("^"..Name) then
                    return x;
                end
            end
        end
    else
        return
    end
end
 
local Message = function(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end
 
local SkidFling = function(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
 
    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle
 
    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessoy and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end
 
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit and not AllBool then
            return Message("Error Occurred", "Targeting is sitting", 5) -- u can remove dis part if u want lol
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
 
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
 
        local SFBasePart = function(BasePart)
            local TimeToWait = 0.1
            local Time = tick()
            local Angle = 0
 
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
 
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
 
        workspace.FallenPartsDestroyHeight = 0/0
 
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
 
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
 
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return Message("Error Occurred", "Target is missing everything", 5)
        end
 
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
 
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Occurred", "Random error", 5)
    end
end
 
if not Welcome then Message("Script by DranghetaSm0ke", "Enjoy!", 5) end
getgenv().Welcome = true
if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
 
if AllBool then
    for _,x in next, Players:GetPlayers() do
        SkidFling(x)
    end
end
 
for _,x in next, Targets do
    if GetPlayer(x) and GetPlayer(x) ~= Player then
        if GetPlayer(x).UserId ~= 1414978355 then
            local TPlayer = GetPlayer(x)
            if TPlayer then
                SkidFling(TPlayer)
            end
        else
            Message("Error Occurred", "This user is whitelisted! (Owner)", 5)
        end
    elseif not GetPlayer(x) and not AllBool then
        Message("Error Occurred", "Username Invalid", 5)
    end
end
local WhitelistedPlayers = {
    [123456789] = true, -- Replace with the actual UserId of whitelisted players
    [987654321] = true,
}

local function IsPlayerWhitelisted(player)
    local userId = player.UserId
    return WhitelistedPlayers[userId] or false
end

return IsPlayerWhitelisted
  	end    
})

Tab:AddButton({
	Name = "Fe Bring",
	Callback = function()
		local plrs=game:FindFirstChildOfClass("Players")
		local lp=plrs.LocalPlayer
		local ws=game:FindFirstChildOfClass("Workspace")
		local uis=game:FindFirstChildOfClass("UserInputService")
		local rs=game:FindFirstChildOfClass("RunService")
		local heartbeat=rs.Heartbeat
		local renderstepped=rs.RenderStepped
		local angles=CFrame.Angles
		local cf=CFrame.new
		local v3=Vector3.new
		local v3_010=v3(0,1,0)
		local v3_0=v3(0,0,0)
		local osclock=os.clock
		local twait=task.wait
		local slower=string.lower
		local ssub=string.sub
		
		local speeding=32
		local maxspeed=75
		local off=angles(-1.5707963267948966,0,0)
		
		local function gp(p,n,cl)
			if typeof(p)=="Instance" then
				local c=p:GetChildren()
				for i=1,#c do
					local v=c[i]
					if (v.Name==n) and v:IsA(cl) then
						return v
					end
				end
			end
			return nil
		end
		
		local i=Instance.new 
		local v2=Vector2.new 
		local bc=BrickColor.new 
		local c3=Color3.new 
		local u2=UDim2.new 
		local sc,mr=string.char,math.random 
		local function rs(l) 
			l=l or mr(8,15) 
			local s="" 
			for i=1,l do 
				if mr(1,2)==1 then 
					s=s..sc(mr(65,90)) 
				else 
					s=s..sc(mr(97,122)) 
				end 
			end 
			return s 
		end 
		local e=Enum 
		local i1=i("Frame") 
		local i2=i("TextLabel") 
		local i3=i("Frame") 
		local i4=i("TextBox") 
		local i5=i("TextButton") 
		local i6=i("TextLabel") 
		local i7=i("TextLabel") 
		local i8=i("ScreenGui") 
		i1.AnchorPoint=v2(0.5,0.5) 
		i1.BackgroundColor=bc(149) 
		i1.BackgroundColor3=c3(0.129412,0.129412,0.129412) 
		i1.BorderColor=bc(1003) 
		i1.BorderColor3=c3(0,0,0) 
		i1.BorderSizePixel=0 
		i1.Position=u2(0.5,0,0.5,0) 
		i1.Size=u2(0,250,0,140) 
		i1.Name=rs() 
		i1.Parent=i8 
		i2.Font=e.Font.SourceSans 
		i2.FontSize=e.FontSize.Size24 
		i2.Text="FE bring gui" 
		i2.TextColor=bc(1002) 
		i2.TextColor3=c3(0.815686,0.815686,0.815686) 
		i2.TextSize=20 
		i2.BackgroundColor=bc(1001) 
		i2.BackgroundColor3=c3(1,1,1) 
		i2.BackgroundTransparency=1 
		i2.BorderColor=bc(1003) 
		i2.BorderColor3=c3(0,0,0) 
		i2.BorderSizePixel=0 
		i2.Size=u2(1,0,0,25) 
		i2.Name=rs() 
		i2.Parent=i1 
		i3.BackgroundColor=bc(26) 
		i3.BackgroundColor3=c3(0.192157,0.192157,0.192157) 
		i3.BorderColor=bc(1003) 
		i3.BorderColor3=c3(0,0,0) 
		i3.BorderSizePixel=0 
		i3.ClipsDescendants=true 
		i3.Position=u2(0,5,0,25) 
		i3.Size=u2(1,-10,1,-30) 
		i3.Name=rs() 
		i3.Parent=i1 
		i4.CursorPosition=-1 
		i4.Font=e.Font.SourceSans 
		i4.FontSize=e.FontSize.Size24 
		i4.PlaceholderColor3=c3(0.509804,0.509804,0.509804) 
		i4.PlaceholderText="✅сюда ник✅" 
		i4.Text="" 
		i4.TextColor=bc(1) 
		i4.TextColor3=c3(0.952941,0.952941,0.952941) 
		i4.TextSize=20 
		i4.TextWrap=true 
		i4.AnchorPoint=v2(0.5,0) 
		i4.BackgroundColor=bc(364) 
		i4.BackgroundColor3=c3(0.266667,0.266667,0.266667) 
		i4.BorderColor=bc(1003) 
		i4.BorderColor3=c3(0,0,0) 
		i4.BorderSizePixel=0 
		i4.ClipsDescendants=true 
		i4.Position=u2(0.5,0,0,13) 
		i4.Size=u2(1,-30,0,32) 
		i4.Name=rs() 
		i4.Parent=i3 
		i5.AnchorPoint=v2(0.5,0) 
		i5.BackgroundColor=bc(364) 
		i5.BackgroundColor3=c3(0.266667,0.266667,0.266667) 
		i5.BorderColor=bc(1003) 
		i5.BorderColor3=c3(0,0,0) 
		i5.BorderSizePixel=0 
		i5.Position=u2(0.5,0,0,64) 
		i5.Size=u2(1,-30,0,32) 
		i5.Name=rs() 
		i5.Parent=i3 
		i5.Font=e.Font.FredokaOne 
		i5.FontSize=e.FontSize.Size24 
		i5.Text="BRING BY AVTOR SCRIPTS" 
		i5.TextColor3=c3(0.55,0.55,0.55) 
		i5.TextSize=23 
		i6.Font=e.Font.SourceSans 
		i6.FontSize=e.FontSize.Size14 
		i6.Text="by MyWorld" 
		i6.TextColor=bc(2) 
		i6.TextColor3=c3(0.635294,0.635294,0.635294) 
		i6.AnchorPoint=v2(1,1) 
		i6.AutomaticSize=e.AutomaticSize.XY 
		i6.BackgroundColor=bc(1001) 
		i6.BackgroundColor3=c3(1,1,1) 
		i6.BackgroundTransparency=1 
		i6.BorderColor=bc(1003) 
		i6.BorderColor3=c3(0,0,0) 
		i6.BorderSizePixel=0 
		i6.Position=u2(1,0,1,0) 
		i6.Name=rs() 
		i6.Parent=i3 
		i7.Font=e.Font.SourceSans 
		i7.FontSize=e.FontSize.Size14 
		i7.Text="" 
		i7.TextColor=bc(2) 
		i7.TextColor3=c3(0.635294,0.635294,0.635294) 
		i7.AnchorPoint=v2(0.5,0) 
		i7.AutomaticSize=e.AutomaticSize.XY 
		i7.BackgroundColor=bc(1001) 
		i7.BackgroundColor3=c3(1,1,1) 
		i7.BackgroundTransparency=1 
		i7.BorderColor=bc(1003) 
		i7.BorderColor3=c3(0,0,0) 
		i7.BorderSizePixel=0 
		i7.Position=u2(0.5,0,0,47) 
		i7.Name=rs() 
		i7.Parent=i3 
		i8.ZIndexBehavior=e.ZIndexBehavior.Sibling 
		i8.Name=rs() 
		
		local function Draggable(window,obj)
			local MB1enum = e.UserInputType.MouseButton1
			local TOUCHenum = e.UserInputType.Touch
			obj = obj or window
			local activeEntered = 0
			local mouseStart = nil
			local dragStart = nil
			local inputbegancon = nil
			local rendersteppedcon = nil
			local inputendedcon = nil
			local function inputendedf(a)
				a=a.UserInputType
				if (a==MB1enum) or (a==TOUCHenum) then
					rendersteppedcon:Disconnect()
					inputendedcon:Disconnect()
				end
			end
			local function rendersteppedf()
				local off = uis:GetMouseLocation()-mouseStart
				window.Position=dragStart+u2(0,off.X,0,off.Y)
			end
			local function inputbeganf(a)
				a=a.UserInputType
				if ((a==MB1enum) or (a==TOUCHenum)) and (activeEntered==0) and not uis:GetFocusedTextBox() then
					mouseStart=uis:GetMouseLocation()
					dragStart=window.Position
					if rendersteppedcon then rendersteppedcon:Disconnect() end
					rendersteppedcon = renderstepped:Connect(rendersteppedf)
					if inputendedcon then inputendedcon:Disconnect() end
					inputendedcon = uis.InputEnded:Connect(inputendedf)
				end
			end
			obj.MouseEnter:Connect(function()
				if inputbegancon then inputbegancon:Disconnect() end
				inputbegancon = uis.InputBegan:Connect(inputbeganf)
			end)
			obj.MouseLeave:Connect(function()
				inputbegancon:Disconnect()
			end)
			local function ondes(d)
				if d:IsA("GuiObject") then
					local thisEntered = false
					local thisAdded = false
					local con0 = d.MouseEnter:Connect(function()
						thisEntered = true
						if (not thisAdded) and d.Active then
							activeEntered = activeEntered + 1
							thisAdded = true
						end
					end)
					local con1 = d.MouseLeave:Connect(function()
						thisEntered = false
						if thisAdded then
							activeEntered = activeEntered - 1
							thisAdded = false
						end
					end)
					local con2 = d:GetPropertyChangedSignal("Active"):Connect(function()
						if thisEntered then
							if thisAdded and not d.Active then
								activeEntered = activeEntered - 1
								thisAdded = false
							elseif d.Active and not thisAdded then
								activeEntered = activeEntered + 1
								thisAdded = true
							end
						end
					end)
					local con3 = nil
					con3 = d.AncestryChanged:Connect(function()
						if not d:IsDescendantOf(window) then
							if thisEntered then
								activeEntered = activeEntered - 1
							end
							con0:Disconnect()
							con1:Disconnect()
							con2:Disconnect()
							con3:Disconnect()
						end
					end)
				end
			end
			window.DescendantAdded:Connect(ondes)
			local des=window:GetDescendants()
			for i=1,#des do 
				ondes(des[i])
			end
		end
		Draggable(i1)
		
		local others={}
		for i,v in pairs(plrs:GetPlayers()) do
			if v~=lp then
				others[v]=true
			end
		end
		plrs.PlayerAdded:Connect(function(plr)
			others[plr]=true
		end)
		local function findplr(txt)
			if txt=="" then
				return nil
			end
			for v,_ in pairs(others) do
				if v.DisplayName==txt then
					return v
				end
			end
			for v,_ in pairs(others) do
				if v.Name==txt then
					return v
				end
			end
			local lower=slower(txt)
			for v,_ in pairs(others) do
				if slower(v.DisplayName)==lower then
					return v
				end
			end
			for v,_ in pairs(others) do
				if slower(v.Name)==lower then
					return v
				end
			end
			local l=#txt
			for v,_ in pairs(others) do
				if ssub(v.DisplayName,l,l)==txt then
					return v
				end
			end
			for v,_ in pairs(others) do
				if ssub(v.Name,l,l)==txt then
					return v
				end
			end
			for v,_ in pairs(others) do
				if slower(ssub(v.DisplayName,l,l))==lower then
					return v
				end
			end
			for v,_ in pairs(others) do
				if slower(ssub(v.Name,l,l))==lower then
					return v
				end
			end
			return nil
		end
		local target=nil
		i4:GetPropertyChangedSignal("Text"):Connect(function()
			local txt=i4.Text
			target=findplr(txt)
			if target then
				if (target.DisplayName) and (target.DisplayName~="") and (target.DisplayName~=target.Name) then
					i7.Text=target.DisplayName.." @"..target.Name
				else
					i7.Text="@"..target.Name
				end
				i5.TextColor3=c3(0.301961,1,0) 
			else
				i7.Text=""
				i5.TextColor3=c3(0.55,0.55,0.55) 
			end
		end)
		plrs.PlayerRemoving:Connect(function(plr)
			others[plr]=nil
			if plr==target then
				target=nil
				i7.Text=""
				i5.TextColor3=c3(0.55,0.55,0.55) 
			end
		end)
		local notifyid=0
		local function notify(txt)
			notifyid=notifyid+1
			local thisid=notifyid
			i6.Text=txt
			twait(2)
			if notifyid==thisid then
				i6.Text="by Avtor1zaTion"
			end
		end
		local bringing=false
		i5.MouseButton1Click:Connect(function()
			if bringing then
				bringing=false
				i5.Text="BRING BY AVTOR SCRIPTS"
				return
			end
			if not target then
				return
			end
			local c=lp.Character
			local c1=target.Character
			if not (c and c1) then
				return notify("no character")
			end
			if not (c:IsDescendantOf(ws) and c1:IsDescendantOf(ws)) then
				return notify("character not in workspace")
			end
			local hrp=gp(c,"HumanoidRootPart","BasePart")
			local hrp1=gp(c1,"HumanoidRootPart","BasePart")
			if not (hrp and hrp1) then
				return notify("no humanoidrootpart")
			end
			bringing=true
			i5.Text="bringing" 
			local from=hrp1.CFrame
			local fromP=from.Position
			local to=hrp.CFrame
			local toP=to.Position
			local mag=(fromP-toP).Magnitude-3
			local lv=cf(fromP,toP).LookVector
			local vel=0
			local pos=from.Position-v3_010*2
			toP=toP-v3_010*2
		
			local sine=osclock()
			local lastsine=sine
			local way=0
			local reachedmaxspeed=false
			while bringing and c:IsDescendantOf(ws) and c1:IsDescendantOf(ws) do
				sine=osclock()
				local deltaTime=sine-lastsine
				lastsine=sine
				if reachedmaxspeed then
					if mag-way<reachedmaxspeed then
						vel=vel-deltaTime*speeding
						if vel<0 then
							break
						end
					end
				else
					if way>mag/2 then
						vel=vel-deltaTime*speeding
						if vel<0 then
							break
						end
					else
						vel=vel+deltaTime*speeding
						if vel>maxspeed then
							reachedmaxspeed=way
							vel=maxspeed
						end
					end
				end
				way=way+vel*deltaTime
				if not hrp:IsGrounded() then
					hrp.CFrame=cf(pos+lv*way,toP)*off
					hrp.Velocity=lv*(vel+1)
					hrp.RotVelocity=v3_0
				end
				twait()
			end
			hrp.CFrame=to
			hrp.Velocity=v3_0
			hrp.RotVelocity=v3_0
			bringing=false
			i5.Text="BRING BY AVTOR SCRIPTS"
		end)
		local iscg,_=pcall(function()
			i8.Parent=game:FindFirstChildOfClass("CoreGui")
		end)
		if not iscg then
			i8.Parent=lp:FindFirstChildOfClass("PlayerGui")
		end
  	end    
})

local Tab = Window:MakeTab({
	Name = "Ro-chat",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Imune a luva",
	Callback = function()
		local function Do()
			game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(child)
				if child:IsA("BodyVelocity") and child.Name == "BodyVelocity" and child.MaxForce == Vector3.new(1000000000, 1000000000, 1000000000) then
					game.Players.LocalPlayer.Character.Humanoid.Sit = false
					child.MaxForce = Vector3.new(0, 0, 0)
					spawn(function()
						child:Destroy()
					end)
				end
			end)
		end
		Do()
		game.Players.LocalPlayer.CharacterAdded:Connect(function()
			Do()
		end)
  	end    
})

Tab:AddButton({
	Name = "Sem tempo da luva",
	Callback = function()
		-- Script que executa o comando no HD Admin quando a tecla 'v' é pressionada

local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Função para invocar o comando
local function invokeCommand()
    local args = {
        [1] = ";re"  -- Comando que deseja executar
    }

    -- Encontrando o objeto necessário e invocando o servidor
    local signals = replicatedStorage:WaitForChild("HDAdminClient"):WaitForChild("Signals")
    local requestCommand = signals:WaitForChild("RequestCommand")
    requestCommand:InvokeServer(unpack(args))
end

-- Conectar a função ao pressionar a tecla 'v'
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        invokeCommand()
    end
end)

  	end    
})

local Section = Tab:AddSection({
	Name = "Necessario admin"
})

Tab:AddButton({
	Name = "Cmdbar mobile",
	Callback = function()
		local args = {
			[1] = ";cmdbar"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "Re",
	Callback = function()
		local args = {
			[1] = ";re"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
  	end    
})

Tab:AddButton({
	Name = "Carro da barbie",
	Callback = function()
		local args = {
			[1] = ";morph me Chair "
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";invisible"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 7486821346"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";smoke"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 70

  	end    
})

Tab:AddButton({
	Name = "Carro do pai do guss",
	Callback = function()
		local args = {
			[1] = ";morph me Chair "
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";invisible"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 18292284058"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";smoke"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 3

  	end    
})

Tab:AddButton({
	Name = "Privada",
	Callback = function()
		local args = {
			[1] = ";morph me Chair "
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";invisible"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 13910578491"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		

  	end    
})

Tab:AddButton({
	Name = "Tank",
	Callback = function()
		local args = {
			[1] = ";morph me Chair "
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";invisible"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 12971083503"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";smoke"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 5

  	end    
})

Tab:AddButton({
	Name = "Relampago marquinhos",
	Callback = function()
		local args = {
			[1] = ";morph me Chair "
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";invisible"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 15154876779"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";smoke"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100

  	end    
})

Tab:AddButton({
	Name = "Morte vem te buscar",
	Callback = function()
		local args = {
			[1] = ";morph me Chair "
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";invisible"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 12314485671"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
  	end    
})

Tab:AddButton({
	Name = "Skin ELITE RO-CHAT",
	Callback = function()
		local args = {
			[1] = ";shirt me 18351055713"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";pants me 12623832394"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 15834759362"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
  	end    
})

Tab:AddButton({
	Name = "KKK",
	Callback = function()
	local args = {
			[1] = ";char me Jalim_Rabei234"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

		local args = {
			[1] = ";hat me 17240999372"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";shirt me 8518174830"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";hat me 11547068239"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";pants me 9420798626"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
  	end    
})

local Section = Tab:AddSection({
	Name = "Item Gigantes"
})

Tab:AddButton({
	Name = "Bob esponja gigante",
	Callback = function()
		local args = {
			[1] = ";hat me 18100795481"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "Patrick gorducho",
	Callback = function()
		local args = {
			[1] = ";hat me 18102096668"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "Peixe",
	Callback = function()
		local args = {
			[1] = ";hat me 17900412562"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "Casa gigante",
	Callback = function()
		local args = {
			[1] = ";hat me 18101787305"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "Gigante",
	Callback = function()
		local args = {
			[1] = ";hat me 18100684824"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "LOLOLOLOLO",
	Callback = function()
		local args = {
			[1] = ";hat me 18100881047"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "Martelo",
	Callback = function()
		local args = {
			[1] = ";hat me 18100314801"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
  	end    
})

Tab:AddButton({
	Name = "Grupo de Toad",
	Callback = function()
		local args = {
    [1] = ";hat me 18100228850"
}

game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

  	end    
})

Tab:AddButton({
	Name = "Cara feliz gigante",
	Callback = function()
		local args = {
    [1] = ";hat me 18100348824"
}

game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

  	end    
})

Tab:AddButton({
	Name = "Coliseu",
	Callback = function()
		local args = {
    [1] = ";hat me 18100716346"
}

game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

  	end    
})


local Section = Tab:AddSection({
	Name = "Item random"
})

Tab:AddButton({
	Name = "Ban Hammer",
	Callback = function()
		local args = {
    [1] = ";hat me 18100160879"
}

game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

  	end    
})

local Section = Tab:AddSection({
	Name = "Tampar a visão"
})

Tab:AddButton({
	Name = "Tampar a visão",
	Callback = function()
		local args = {
    [1] = ";spin me 99"
}

game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))

local args = {
    [1] = ";hat me 18100522261"
}

game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))


  	end    
})

local Section = Tab:AddSection({
	Name = "Impossivel de mutar"
})

Tab:AddButton({
	Name = "Impossivel de mutar",
	Callback = function()
		local args = {
			[1] = ";hat me 17900412562"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local args = {
			[1] = ";invisible"
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("HDAdminClient"):WaitForChild("Signals"):WaitForChild("RequestCommand"):InvokeServer(unpack(args))
		
		local lp = game:GetService("Players").LocalPlayer
		local c = lp.Character
		local hrp0 = c:FindFirstChild("HumanoidRootPart")
		local hrp1 = hrp0:Clone()
		c.Parent = nil
		hrp0.Parent = hrp1
		hrp0.RootJoint.Part0 = nil
		hrp1.Parent = c
		c.Parent = workspace
		local h = game:GetService("RunService").Heartbeat
		hrp0.Transparency = 0.5
		while h:Wait() and c and c.Parent do
			hrp0.CFrame = hrp1.CFrame
			hrp0.Orientation += Vector3.new(0, 0, 180)
			hrp0.Position -= Vector3.new(0, 1, 0)
			hrp0.Velocity = hrp1.Velocity
		end
  	end    
})

local Tab = Window:MakeTab({
	Name = "Dahood",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "TPO OP",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/cool5013/TBO/main/TBOscript'))()
  	end    
})

Tab:AddButton({
	Name = "Faded",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NighterEpic/Faded/main/YesEpic", true))()
  	end    
})

local Section = Tab:AddSection({
	Name = "Lock"
})

Tab:AddButton({
	Name = "Lock Legit",
	Callback = function()
		getgenv().RecurringPoint = "UpperTorso"
		getgenv().Hitbox = "UpperTorso"
		getgenv().Keybind = "c"
		getgenv().AimbotStrengthAmount = 1
		getgenv().PredictionAmount = 7
		getgenv().Radius = 25
		getgenv().UsePrediction = true
		getgenv().AimbotStrength = true
		getgenv().FirstPerson = true
		getgenv().ThirdPerson = true
		getgenv().TeamCheck = false
		getgenv().Enabled = true
		 
		 
		-- // main script  / / -- 
		 
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tenaaki/GenericAimbot/main/v1.0.0"))
  	end    
})

Tab:AddButton({
	Name = "Neurasthenia Lock",
	Callback = function()
		loadstring(game:HttpGet(("https://raw.githubusercontent.com/vkzpeep/WeepScript/main/aimlock.lua"), true))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Prison life",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Crash server",
	Callback = function()
		warn("@nikymetaa, hmm crash? way too easy!")

wait(1)

local Gun = "Remington 870"
 
local Player = game.Players.LocalPlayer.Name
local Plr = game:GetService("Players").LocalPlayer

function GetGun(Item, Ignore)
    task.spawn(function()
        workspace:FindFirstChild("Remote")['ItemHandler']:InvokeServer({
            Position = Plr.Character.Head.Position,
            Parent = workspace.Prison_ITEMS:FindFirstChild(Item, true)
        })
    end)
end
GetGun("Remington 870")

for i,v in pairs(game.Players[Player].Backpack:GetChildren()) do
    if v.Name == (Gun) then
        v.Parent = game.Players.LocalPlayer.Character
    end
end
 
Gun = game.Players[Player].Character[Gun]
 
game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
 
function FireGun(target)
        coroutine.resume(coroutine.create(function()
                  local bulletTable = {}
                  table.insert(bulletTable, {
                  Hit = target,
                  Distance = 100,
                  Cframe = CFrame.new(0,1,1),
                  RayObject = Ray.new(Vector3.new(0.1,0.2), Vector3.new(0.3,0.4))
                   })
                  game.ReplicatedStorage.ShootEvent:FireServer(bulletTable, Gun)
                  wait()
        end))
end
 
while game:GetService("RunService").Stepped:Wait() do
        for count = 0, 10, 10 do
                FireGun()
        end
end
  	end    
})

Tab:AddButton({
	Name = "Tiger admin",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/dalloc2/Roblox/main/TigerAdmin.lua"))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Flee the Facility",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Arctic",
	Callback = function()
		loadstring(game:HttpGet("https://polarsblade.xyz/Hub/FleeTheFacility.txt"))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Gym league",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Speed hub (Sem key)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Script-Games/main/Gym%20League.lua"))()
  	end    
})

Tab:AddButton({
	Name = "Lightux (Com key)",
	Callback = function()
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/cool83birdcarfly02six/Lightux/main/README.md'),true))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Blox Fruit",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Redz Hub (Sem key)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
  	end    
})

Tab:AddButton({
	Name = "Cokka Hub (Com key)",
	Callback = function()
		loadstring(game:HttpGet"https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua")()
  	end    
})

Tab:AddButton({
	Name = "Speed hub (Sem key)",
	Callback = function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ahmadsgamer2/Script--Game/main/Script%20Game"))()
  	end    
})

local Section = Tab:AddSection({
	Name = "Bounty"
})

Tab:AddButton({
	Name = "Auto bounty",
	Callback = function()
		getgenv().Setting = {
            ["Team"] = "Pirates",
            ["Chat"] = {},
            ["Skip Race V4"] = true,
            ["Misc"] = {
                ["Enable Lock Bounty"] = false,
                ["Lock Bounty"] = {0, 300000000},
                ["Hide Health"] = {4500,5000},
                ["Lock Camera"] = false,
                ["Enable Cam Farm"] = false,
                ["White Screen"] = false,
                ["FPS Boost"] = false,
                ["Bypass TP"] = true,
                ["Random & Store Fruit"] = true
            },
            ["Item"] = {
                ["Melee"] = {["Enable"] = true,
                    ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.5},
                    ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1},
                    ["C"] = {["Enable"] = true, ["Hold Time"] = 0.1}
                },
                ["Blox Fruit"] = {["Enable"] = false,
                    ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.5},
                    ["X"] = {["Enable"] = true, ["Hold Time"] = 0},
                    ["C"] = {["Enable"] = true, ["Hold Time"] = 0},
                    ["V"] = {["Enable"] = true, ["Hold Time"] = 0},
                    ["F"] = {["Enable"] = true, ["Hold Time"] = 0}
                },
                ["Sword"] = {["Enable"] = true,
                    ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.1},
                    ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1}
                },
                ["Gun"] = {["Enable"] = false,
                    ["Z"] = {["Enable"] = false, ["Hold Time"] = 0.1},
                    ["X"] = {["Enable"] = false, ["Hold Time"] = 0.1}
                }
            }
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/daviduts1/rua-hub/main/auto%20bouty"))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Fe",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Honored",
	Callback = function()
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/Cortzalno666/NectoVerse-Industries-Data/master/Scripts%20Folder/Honored.lua'),true))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Skyblock",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Comprar bloco",
	Callback = function()
		local args = {
			[1] = "Blacksmith",
			[2] = 0
		}
		
		game:GetService("ReplicatedStorage"):WaitForChild("8Jd"):WaitForChild("538e4f78-60c2-4ed2-a807-f978197cc4ca"):FireServer(unpack(args))
		
  	end    
})
