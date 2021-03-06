local TeamMode = false

function BS_GetPlayers()

	local Players = player.GetAll()
	
	for k,v in pairs(Players) do
		if not v:Alive() then
			table.remove(Players,k)
		end
	end
	
	return Players

end

local SizeOfBurgersDick = math.huge

function BS_MovePlayerToBetterSpawn(ply)

	local GAMEMODE = gmod.GetGamemode()
	local ValidSpawns = table.Copy(GAMEMODE.SpawnPoints)

	if TeamMode then
	
		local ActualValidSpawns = {}
	
		for k,v in pairs(ValidSpawns) do
			if ply:Team() == 2001 then
				if v:GetClass() == "info_player_terrorist" then
					table.Add(ActualValidSpawns,{v})
				end
			else
				if v:GetClass() == "info_player_counterterrorist" then
					table.Add(ActualValidSpawns,{v})
				end
			end
		end
		
		--PrintTable(ActualValidSpawns)

		local SelectedSpawn = ActualValidSpawns[ math.random(#ActualValidSpawns) ]
		ply:SetPos(SelectedSpawn:GetPos())
		ply:SetEyeAngles(SelectedSpawn:GetAngles())
		
		return
	end


	local GAMEMODE = gmod.GetGamemode()
	local ValidSpawns = table.Copy(GAMEMODE.SpawnPoints)
	local SelectedSpawn = nil
	local SelectedSpawnDistance = -1
	local Players = BS_GetPlayers()
	local PlayersCount = table.Count(Players)

	for k,v in pairs(ValidSpawns) do
	
		local TotalDistance = 0
		local MinimumDistance = SizeOfBurgersDick
		local Override = false
		
		if ply.BS_LastSpawns and table.HasValue(ply.BS_LastSpawns,v) then
			Override = true 
		end
		
		if (Override == false) or (not SelectedSpawn) then
			if Players and PlayersCount > 0 then
			
				for l,b in pairs(Players) do
					local Distance = b:GetPos():Distance(v:GetPos())
					TotalDistance = TotalDistance + Distance
					if (MinimumDistance > Distance) then
						MinimumDistance = Distance
					end
				end
				
			end

			if ( (MinimumDistance > 1024) and (TotalDistance > SelectedSpawnDistance) ) or (not SelectedSpawn) or (ply.BS_LastSpawns and table.HasValue(ply.BS_LastSpawns,SelectedSpawn) and not table.HasValue(ply.BS_LastSpawns,v)) then
				SelectedSpawn = v
				SelectedSpawnDistance = TotalDistance
			end
			
		end

	end
	
	if SelectedSpawn then
		ply:SetPos(SelectedSpawn:GetPos())
		ply:SetEyeAngles(SelectedSpawn:GetAngles())
		BS_AddSpawnToList(ply,SelectedSpawn)
	else
		ply:KillSilent()
		ply:ChatPrint("Tell Burger that he's a fucking dumb piece of shit")
	end
	
end

function BS_AddSpawnToList(ply,SelectedSpawn)

	if not ply.BS_LastSpawns then
		ply.BS_LastSpawns = {}
	end

	table.Add(ply.BS_LastSpawns,{SelectedSpawn})

	if table.Count(ply.BS_LastSpawns) > 5 then
		table.remove(ply.BS_LastSpawns,1)
	end

end

hook.Add("PlayerSpawn","BS_MovePlayerToBetterSpawn",BS_MovePlayerToBetterSpawn)

function BS_EnableSpawnProtection(ply)
	timer.Simple(0, function()
		if ply:Alive() then
			ply:SetMaterial("debug/env_cubemap_model")
			ply:GodEnable()
			ply.SpawnImmunityTime = CurTime() + 3
			ply.SpawnProtectionEnabled = true
		end
	end)
end

hook.Add( "PlayerSpawn", "BS_EnableSpawnProtection", BS_EnableSpawnProtection )

function BS_SpawnProtectionThink()
	for k,ply in pairs(player.GetAll()) do
		if ply:Alive() == true then
			if ply.SpawnProtectionEnabled then
				if ply.SpawnImmunityTime <= CurTime() then
					ply:ChatPrint("Your spawn protection has worn off.")
					ply.SpawnProtectionEnabled = false
					ply:GodDisable()
				end
				if ply.SpawnImmunityTime - 1 <= CurTime() then
					ply:ChatPrint("Your spawn protection has worn off.")
					ply.SpawnProtectionEnabled = false
					ply:GodDisable()
				end	
			elseif not ply.SpawnProtectionEnabled then
				ply:SetMaterial("")
			end
		end
	end
end

hook.Add( "Think", "BS_SpawnProtectionThink", BS_SpawnProtectionThink )


