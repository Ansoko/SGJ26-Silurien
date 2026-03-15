extends Node

var nouns: Array = []
var verbs: Array = []
var conjunctions: Array = []
var adjectives: Array = []
var punctuation: Array = []
var expression: Array = []

var csv_noun: String = "res://csv/nom.csv"
var csv_verb: String = "res://csv/verbe.csv"
var csv_conjunction: String = "res://csv/conjonction.csv"
var csv_adjectifs: String = "res://csv/adjectiv.csv"
var csv_punctuation: String = "res://csv/ponctuation.csv"
var csv_expression: String = "res://csv/expression.csv"

signal add_word(word: String)
var letterText = ""
signal saveText()


func _ready():
	nouns = loadCSVAsArray(csv_noun)
	verbs = loadCSVAsArray(csv_verb)
	conjunctions = loadCSVAsArray(csv_conjunction)
	adjectives = loadCSVAsArray(csv_adjectifs)
	punctuation = loadCSVAsArray(csv_punctuation)
	expression = loadCSVAsArray(csv_expression)
	
func get_random_noun() -> String:
	return nouns.pick_random()
	
func get_random_verb() -> String:
	return verbs.pick_random()

func get_random_conjunction() -> String:
	return conjunctions.pick_random()

func get_random_adjective() -> String:
	return adjectives.pick_random()

func get_random_expression() -> String:
	return expression.pick_random()

func get_random_punctuation() -> String:
	var regex_guillemets = RegEx.new()
	regex_guillemets.compile("\"")
	var texte = regex_guillemets.sub(punctuation.pick_random(), "", true)
	return texte

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
