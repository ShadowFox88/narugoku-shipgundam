--|| Services ||--
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

--|| Directories ||--
local Modules = ReplicatedStorage.Modules

local Models = ReplicatedStorage.Assets.Models

local Metadata = Modules.Metadata
local Utility = Modules.Utility
local Effects = Modules.Effects
local Shared = Modules.Shared

--|| Modules ||--
local SoundManager = require(Shared.SoundManager)

local GlobalFunctions = require(ReplicatedStorage.GlobalFunctions)

local CameraShaker = require(Effects.CameraShaker)
local LightningExplosion = require(Effects.LightningBolt.LightningExplosion)
local VfxHandler = require(Effects.VfxHandler)

local CurrentCamera = workspace.CurrentCamera

local CameraShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	CurrentCamera.CFrame = CurrentCamera.CFrame * shakeCFrame
end)	

--|| Variables ||--
local Effects = ReplicatedStorage.Assets.Effects.Meshes
local Particles = ReplicatedStorage.Assets.Effects.Particles

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {workspace.World.Visuals}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local RingTween = TweenInfo.new(.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)

return function(Data)
	local Character = Data.Character
	local Result = Data.RaycastResult
	local Spear = Data.Spear

	local Player = Players:GetPlayerFromCharacter(Character)

	local Root,Humanoid = Character:FindFirstChild("HumanoidRootPart"), Character:FindFirstChild("Humanoid")
	
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.Position = Result.Position
	Part.Transparency = 1
	Part.Orientation = Vector3.new(3.87, -4.36, -2.25)
	Part.Parent = workspace.World.Visuals

	Debris:AddItem(Part,2)

	local Calculation = Part.CFrame - Part.CFrame.Position

	coroutine.resume(coroutine.create(function()
		for _ = 1,2 do			
			local Ring = ReplicatedStorage.Assets.Effects.Meshes.Ring2:Clone()
			Ring.Size = Vector3.new(35,3,35)
			Ring.Material = Enum.Material.Neon
			Ring.Color = Color3.fromRGB(255,255,255)
			Ring.CanCollide = false
			Ring.CFrame = CFrame.new(Result.Position) * Calculation
			Ring.Anchored = true
			Ring.Parent = workspace.World.Visuals

			Debris:AddItem(Ring,.4)

			local Tween = TweenService:Create(Ring,RingTween,{CFrame = Ring.CFrame * CFrame.new(0,25,0) ,Size = Vector3.new(0,0,0)})
			Tween:Play()
			Tween:Destroy()

			wait(.2)
		end
	end))
	
	local _ = Data.Type == nil and LightningExplosion.new(Result.Position, .15, 1, ColorSequence.new(Color3.fromRGB(255, 232, 140)), ColorSequence.new(Color3.fromRGB(255, 241, 33)), nil)
	if Data.Type == "Punishment" then
		local Ball = ReplicatedStorage.Assets.Effects.Meshes.regball:Clone()
		Ball.Material = Enum.Material.Neon
		Ball.Transparency = 0
		Ball.CFrame = CFrame.new(Result.Position)
		Ball.Size = Vector3.new(.5,.5,.5)
		Ball.Color = Color3.fromRGB(255, 250, 79)
		Ball.Parent = workspace.World.Visuals

		local Tween = TweenService:Create(Ball, TweenInfo.new(.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {["Size"] = Vector3.new(8.5,8.5,8.5), ["Transparency"] = 1})
		Tween:Play()
		Tween:Destroy()

		local Tween = TweenService:Create(Ball, TweenInfo.new(.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {["Transparency"] = 1})
		Tween:Play()
		Tween:Destroy()

		Debris:AddItem(Ball,3)
	end
	
	for _ = 1,math.random(4,10) do
		local x,y,z = math.cos(math.rad(math.random(1,6) * 60)),math.cos(math.rad(math.random(1,6 ) * 60)),math.sin(math.rad(math.random(1,6) * 60))
		local Start = Result.Position
		local End = Start + Vector3.new(x,y,z)

		local Orbie = Effects.MeshOribe:Clone()
		Orbie.CFrame = CFrame.new(Start,End)
		Orbie.Size = Vector3.new(1,2,1)

		local OrbieTweenInfo = TweenInfo.new(.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)

		local Tween = TweenService:Create(Orbie,OrbieTweenInfo,{CFrame = CFrame.new(Start,End)*CFrame.new(0,0,-(math.random(2,5) * 10)),Size = Vector3.new(0,0,24)})
		Tween:Play()
		Tween:Destroy()

		Debris:AddItem(Orbie,.2)
		Orbie.Parent = workspace.World.Visuals
	end
	
	local GroundEffect = Particles.GroundSlamThing:Clone()
	GroundEffect.CFrame = CFrame.new(Result.Position,Result.Position - Result.Normal) * CFrame.Angles(math.pi/2,0,0)
	GroundEffect.ParticleEmitter.Color = ColorSequence.new(Result.Instance.Color)
	GroundEffect.Rocks.Color = ColorSequence.new(Result.Instance.Color)

	GroundEffect.Parent = workspace.World.Visuals

	GroundEffect.ParticleEmitter:Emit(18)
	GroundEffect.Rocks:Emit(20)

	if GlobalFunctions.CheckDistance(Player, Data.Distance) then
		CameraShake:Start()
		CameraShake:ShakeOnce(3, 5, 0, 1.5)
	end

	for _ = 1,math.random(4,10) do
		local x,y,z = math.cos(math.rad(math.random(1,6) * 60)),math.cos(math.rad(math.random(1,6 ) * 60)),math.sin(math.rad(math.random(1,6) * 60))
		local Start = Result.Position
		local End = Start + Vector3.new(x,y,z)

		local Orbie = Effects.MeshOribe:Clone()
		Orbie.CFrame = CFrame.new(Start,End)
		Orbie.Size = Vector3.new(1,2,1)

		local OrbieTweenInfo = TweenInfo.new(.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)

		local Tween = TweenService:Create(Orbie,OrbieTweenInfo,{CFrame = CFrame.new(Start,End)*CFrame.new(0,0,-(math.random(2,5) * 10)),Size = Vector3.new(0,0,24)})
		Tween:Play()
		Tween:Destroy()

		Debris:AddItem(Orbie,.2)
		Orbie.Parent = workspace.World.Visuals
	end

	coroutine.resume(coroutine.create(function()
		wait(2)
		if Spear then
			local Tween = TweenService:Create(Spear,TweenInfo.new(.75,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(0,0,0)})
			Tween:Play()
			Tween:Destroy()
		end
	end))

	Debris:AddItem(GroundEffect,3)
	
	if Data.Index and Data.Index == 7 then
		VfxHandler.RockExplosion({
			Pos = Result.Position, 
			Quantity = 8, 
			Radius = 10,
			Size = Vector3.new(2.35,2.35,2.35), 
			Duration = 2, 
		})	
		
		for _ = 1, 6 do
			local Rock = Effects.Rock:Clone()
			Rock.Position = Result.Position
			Rock.Material = Result.Material;
			Rock.Color = Result.Instance.Color;
			Rock.CanCollide = false
			Rock.Size = Vector3.new(2, 2, 2)
			Rock.Orientation = Vector3.new(math.random(-100,100), math.random(-100,100), math.random(-100,100))
			Rock.Velocity = Vector3.new(math.random(-100,100),math.random(100,100),math.random(-100,100))
			Rock.Parent = workspace.World.Visuals

			local BodyVelocity = Instance.new("BodyVelocity")
			BodyVelocity.Velocity = Vector3.new(math.random(-40,40),math.random(40,75),math.random(-40,40))
			BodyVelocity.MaxForce = Vector3.new(100000,100000,100000)
			BodyVelocity.Parent = Rock

			local BlockTrail = Particles.BlockSmoke:Clone()
			BlockTrail.Color = ColorSequence.new(Result.Instance.Color)
			BlockTrail.Enabled = true
			BlockTrail.Parent = Rock

			Debris:AddItem(Rock,3)
			Debris:AddItem(BodyVelocity,.1)
		end
	end
end	