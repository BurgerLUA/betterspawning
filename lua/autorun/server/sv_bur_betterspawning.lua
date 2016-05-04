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
	local SelectedSpawn = nil
	local SelectedSpawnDistance = -1
	local Players = BS_GetPlayers()
	local PlayersCount = table.Count(Players)

	for k,v in pairs(ValidSpawns) do
	
		local TotalDistance = 0
		local MinimumDistance = SizeOfBurgersDick

		if Players and PlayersCount > 0 then
		
			for l,b in pairs(Players) do
				local Distance = b:GetPos():Distance(v:GetPos())
				TotalDistance = TotalDistance + Distance
				if (MinimumDistance > Distance) then
					MinimumDistance = Distance
				end
			end
			
		end

		if ( (MinimumDistance > 1024) and (TotalDistance > SelectedSpawnDistance) ) or not SelectedSpawn then
			SelectedSpawn = v
			SelectedSpawnDistance = TotalDistance
		end

	end
	
	if SelectedSpawn then
		ply:SetPos(SelectedSpawn:GetPos())
		ply:SetEyeAngles(SelectedSpawn:GetAngles())
	else
		ply:KillSilent()
		ply:ChatPrint("Tell Burger that he's a fucking dumb piece of shit nigger")
	end
	
end

hook.Add("PlayerSpawn","BS_MovePlayerToBetterSpawn",BS_MovePlayerToBetterSpawn)