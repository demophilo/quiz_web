module PlayerModule

export Player, read_player_vector_from_json, write_player_vector!, add_player!, delete_player_by_id!, update_player_by_id!, filter_players_by_score

using JSON3

struct Player
	id::Int
	name::String
	score::Int
	games_played::Int
end

function read_player_vector_from_json(filename::String)::Vector{Player}
	file = open(filename, "r")
	data = JSON3.read(file)
	close(file)

	player_vector = Vector{Player}()
	for player_data in data["players"]
		player = Player(
			player_data["id"],
			player_data["name"],
			player_data["score"],
			player_data["games_played"]
		)
		push!(player_vector, player)
	end

	return player_vector
end

function write_player_vector!(filename::String, player_vector::Vector{Player})
	# Create a dictionary for the JSON data
	data = Dict("players" => [])
	for player in player_vector
		push!(data["players"], Dict(
			"id" => player.id,
			"name" => player.name,
			"score" => player.score,
			"games_played" => player.games_played
		))
	end

	# Write the combined players to the file
	file = open(filename, "w")
	JSON3.write(file, data)
	close(file)
end

function add_player!(filename::String, new_player::Player)
	# Read the existing players
	existing_player_vector = []
	if isfile(filename)
		existing_player_vector = read_player_vector_from_json(filename)
	end

	# Add the new player to the existing players
	player_vector = vcat(existing_player_vector, [new_player])

	# Write the combined players to the file
	write_player_vector!(filename, player_vector)
end

function delete_player_by_id!(filename::String, player_id::Int)
	# Read the existing players
	player_vector = read_player_vector_from_json(filename)

	# Filter the players to remove the player with the given ID
	player_vector = filter(player -> player.id != player_id, player_vector)

	# Write the updated players back to the file
	write_player_vector!(filename, player_vector)
end

function update_player_by_id!(filename::String, updated_player::Player)
	# Read the existing players
	player_vector = read_player_vector_from_json(filename)

	# Update the player with the given ID
	for i in eachindex(player_vector)
		if player_vector[i].id == updated_player.id
			player_vector[i] = updated_player
			break
		end
	end

	# Write the updated players back to the file
	write_player_vector!(filename, player_vector)
end

function filter_players_by_score(filename::String, min_score::Int)::Vector{Player}
	# Read the existing players
	player_vector = read_player_vector_from_json(filename)

	# Filter the players by minimum score
	filtered_player_vector = filter(player -> player.score >= min_score, player_vector)

	return filtered_player_vector
end

end # module PlayerModule
