module WordlistGenerator

using FileIO

function apply_affix_rules(word::String, affix_rules::Dict{String, Vector{String}})::Vector{String}
	words = [word]
	for (rule, replacements) in affix_rules
		for replacement in replacements
			if occursin(rule, word)
				new_word = replace(word, rule => replacement)
				push!(words, new_word)
			end
		end
	end
	return words
end

function parse_aff_file(aff_path::String)::Dict{String, Vector{String}}
	affix_rules = Dict{String, Vector{String}}()
	aff_file = open(aff_path, "r")
	for line in eachline(aff_file)
		if startswith(line, "SFX") || startswith(line, "PFX")
			parts = split(line)
			rule = parts[2]
			replacement = parts[end]
			if !haskey(affix_rules, rule)
				affix_rules[rule] = Vector{String}()
			end
			push!(affix_rules[rule], replacement)
		end
	end
	close(aff_file)
	return affix_rules
end

function create_wordlist(dic_path::String, aff_path::String, output_path::String = "wortliste.txt")
	# Lese die .dic Datei ein
	dic_file = open(dic_path, "r")
	words = readlines(dic_file)
	close(dic_file)

	# Entferne die erste Zeile, die die Anzahl der Wörter enthält
	words = words[2:end]

	# Lese die .aff Datei ein und parse die Regeln
	affix_rules = parse_aff_file(aff_path)

	# Erstelle eine Liste aller Wörter mit angewandten Affix-Regeln
	all_words = Set{String}()
	for word in words
		variants = apply_affix_rules(word, affix_rules)
		for variant in variants
			push!(all_words, variant)
		end
	end

	# Schreibe die Wortliste in die Ausgabedatei
	output_file = open(output_path, "w")
	for word in all_words
		println(output_file, word)
	end
	close(output_file)
end

end # module WordlistGenerator
