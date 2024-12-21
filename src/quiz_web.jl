module Quiz

using JSON3

struct Question
	id::Int
	domain::String
	category::String
	subcategory::String
	subject::String
	question::String
	right_answers::Vector{String}
	wrong_answers::Vector{String} # at least 3
	difficulty::Int
	funfact::Union{String, Nothing}
	is_verified::Bool
end

function read_question_vector_from_json(filename::String)::Vector{Question}
	file = open(filename, "r")
	data = JSON3.read(file)
	close(file)

	question_vector = Vector{Question}()
	for question in data["questions"]
		question = Question(
			question["id"],
			question["domain"],
			question["category"],
			question["subcategory"],
			question["subject"],
			question["question"],
			question["right_answers"],
			question["wrong_answers"],
			question["difficulty"],
			get(question, "funfact", nothing),
			question["is_verified"]
		)
		push!(question_vector, question)
	end

	return question_vector
end

function add_question_vector!(filename::String, new_questions::Vector{Question})
	# Lese die bestehenden Fragen ein
	existing_questions = []
	if isfile(filename)
		existing_questions = read_question_vector(filename)
	end

	# Füge die neuen Fragen zu den bestehenden Fragen hinzu
	question_vector = vcat(existing_questions, new_questions)

	# Erstelle ein Dictionary für die JSON-Daten
	data = Dict("questions" => [])
	for question in question_vector
		push!(
			data["questions"],
			Dict(
				"id" => question.id,
				"domain" => question.domain,
				"category" => question.category,
				"subcategory" => question.subcategory,
				"subject" => question.subject,
				"question" => question.question,
				"right_answers" => question.right_answers,
				"wrong_answers" => question.wrong_answers,
				"difficulty" => question.difficulty,
				"funfact" => question.funfact,
				"is_verified" => question.is_verified
			)
		)
	end

	# Schreibe die kombinierten Fragen in die Datei
	file = open(filename, "w")
	JSON3.write(file, data)
	close(file)
end

function add_question!(filename::String, new_question::Question)
	# Lese die bestehenden Fragen ein
	existing_questions = []
	if isfile(filename)
		existing_questions = read_question_vector(filename)
	end

	# Füge die neue Frage zu den bestehenden Fragen hinzu
	question_vector = vcat(existing_questions, [new_question])

	# Erstelle ein Dictionary für die JSON-Daten
	data = Dict("questions" => [])
	for question in question_vector
		push!(
			data["questions"],
			Dict(
				"id" => question.id,
				"domain" => question.domain,
				"category" => question.category,
				"subcategory" => question.subcategory,
				"subject" => question.subject,
				"question" => question.question,
				"right_answers" => question.right_answers,
				"wrong_answers" => question.wrong_answers,
				"difficulty" => question.difficulty,
				"funfact" => question.funfact,
				"is_verified" => question.is_verified
			)
		)
	end
end

function delete_question_by_id!(filename::String, question_id::Int)
	# Lese die bestehenden Fragen ein
	questions = read_question_vector_from_json(filename)

	# Filtere die Fragen, um die Frage mit der gegebenen ID zu entfernen
	questions = filter(q -> q.id != question_id, questions)

	# Schreibe die aktualisierten Fragen zurück in die Datei
	write_questions!(filename, questions)
end

function update_question_by_id!(filename::String, updated_question::Question)
	# Lese die bestehenden Fragen ein
	questions = read_question_vector_from_json(filename)

	# Aktualisiere die Frage mit der gegebenen ID
	for i in eachindex(questions)
		if questions[i].id == updated_question.id
			questions[i] = updated_question
			break
		end
	end

	# Schreibe die aktualisierten Fragen zurück in die Datei
	write_questions!(filename, questions)
end

function filter_questions_by_category(filename::String, category::String)::Vector{Question}
	# Lese die bestehenden Fragen ein
	questions = read_question_vector_from_json(filename)

	# Filtere die Fragen nach Kategorie
	filtered_questions = filter(q -> q.category == category, questions)

	return filtered_questions
end

end # module Quiz
