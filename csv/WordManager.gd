extends Node

var nouns: Array = []
var verbs: Array = []
var conjunctions: Array = []

var csv_noun: String = "res://csv/nom.csv"
var csv_verb: String = "res://csv/verbe.csv"
var csv_conjunction: String = "res://csv/conjonction.csv"

func _ready():
	nouns = loadCSVAsArray(csv_noun)
	verbs = loadCSVAsArray(csv_verb)
	conjunctions = loadCSVAsArray(csv_conjunction)
	
func get_random_noun() -> String:
	return nouns.pick_random()
	
func get_random_verb() -> String:
	return verbs.pick_random()

func get_random_conjunction() -> String:
	return conjunctions.pick_random()

func loadCSVAsArray(csv_path: String) -> Array:
	var list: Array = []
	var file = FileAccess.open(csv_path, FileAccess.READ)
	if file == null:
		printerr("No CSV found: ", csv_path)
		return list
		
	while not file.eof_reached():
		var line = file.get_line()
		if line != "":
			list.append(line)
		
	file.close()
	return list
