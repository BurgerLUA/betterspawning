

function BS_GetPlayers()

	local Players = player.GetAll()
	
	for k,v in pairs(Players) do
		if not v:Alive() then
			table.remove(k)
		end
	end
	
	return Players

end

function BS_MovePlayerToBetterSpawn(ply)

	local GAMEMODE = gmod.GetGamemode()
	local ValidSpawns = GAMEMODE.SpawnPoints
	local SelectedSpawn = nil
	local SelectedSpawnDistance = -1
	local Players = BS_GetPlayers()
	local PlayersCount = table.Count(Players)

	for k,v in pairs(ValidSpawns) do
	
		local TotalDistance = 0

		if Players and PlayersCount > 0 then
			for l,b in pairs(Players) do
				TotalDistance = TotalDistance + b:GetPos():Distance(v:GetPos())
			end
		end
		
		--print(v,TotalDistance)
		
		if SelectedSpawnDistance < TotalDistance then
			SelectedSpawn = v
			SelectedSpawnDistance = TotalDistance
			print("BETTER!")
		end

	end
	
	ply:SetPos(SelectedSpawn:GetPos())
	ply:SetEyeAngles(SelectedSpawn:GetAngles())

end

hook.Add("PlayerSpawn","BS_MovePlayerToBetterSpawn",BS_MovePlayerToBetterSpawn)