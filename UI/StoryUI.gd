extends CanvasLayer

func _ready() -> void:
	WordManager.add_word.connect(addNewWordToStory)
	WordManager.saveText.connect(saveStoryText)
	dialogPanel.hide()
	allLignes = load_json("res://csv/dialogues.json")
	SignalManager.start_game.connect(start_intro)
	SignalManager.start_outro.connect(start_outro)
	
# --- Story line at the top ---
@onready var storyLabel = $Control/ScrollContainer/RichTextLabel
@onready var scrollContainer = $Control/ScrollContainer

var list_words: Array = [{0:"Chère",1: false}, {0:"Mamie,", 1:false}] #word + bool barré

func addNewWordToStory(newWord: String):
	storyLabel.text += " "+newWord;
	list_words.append({0:newWord, 1:false})
	scrollToEnd.call_deferred()

func removeLastWord():
	var lastWord;
	for i in range(list_words.size()-1, -1, -1):
		if not list_words[i][1]:
			list_words[i][1] = true
			lastWord = list_words[i][0]
			break
	if lastWord == null:
		return
	
	var regex = RegEx.new()
	regex.compile(lastWord)
	var resultats = regex.search_all(storyLabel.text)
	if resultats.is_empty():
		return
		
	var dernier = resultats[resultats.size() - 1]
	var debut = storyLabel.text.substr(0, dernier.get_start())
	var fin = storyLabel.text.substr(dernier.get_end())
	storyLabel.text = debut + "[s]" + dernier.get_string() + "[/s]" + fin
	scrollToEnd.call_deferred()

func scrollToEnd():
	var stb := func():
		scrollContainer.scroll_horizontal = scrollContainer.get_h_scroll_bar().max_value
	stb.call_deferred()

func _input(event):
	if event.is_action_pressed("erase"):
			removeLastWord()
	if isInDialogMode:
		if event.is_action_pressed("jump"):
			show_next_line()

func saveStoryText():
	WordManager.letterText = storyLabel.text

#--- dialog system ---
@onready var nameLabel = $Dialog/Panel/nameCharacter
@onready var dialogLabel = $Dialog/Panel/line
@onready var characterPicture = $Dialog/Panel/characterPicture
@onready var dialogPanel = $Dialog
@export var vitesse_texte = 0.03

var tween: Tween
var speaking: bool = false
var isInDialogMode: bool = false
var allLignes: Dictionary = {}
var index_courant: int = -1
var currentState = "intro"

func start_intro():
	index_courant = -1
	currentState = "intro"
	isInDialogMode = true
	dialogPanel.show()
	show_next_line()
	
func start_outro():
	index_courant = -1
	currentState = "outro"
	isInDialogMode = true
	dialogPanel.show()
	show_next_line()
	
func show_next_line():
	index_courant += 1
	dialogLabel.text = ""
	var line = allLignes.get(currentState)
		
	if tween:
		tween.kill()
		
	if speaking:
		speaking = false
		index_courant -= 1
		nameLabel.text = line[index_courant]["character"]
		dialogLabel.text = line[index_courant]["line"]
		return
		
	if(index_courant >= line.size()):
		isInDialogMode = false
		dialogPanel.hide()
		if currentState == "intro" :
			SignalManager.end_intro.emit()
		else:
			SignalManager.end_outro.emit()
		return
	
	if(line[index_courant]["audio"] != ""):
		AudioManager.play_SFX.emit(load(line[index_courant]["audio"]))
		
	nameLabel.text = line[index_courant]["character"]
	var texte_complet = line[index_courant]["line"]
		
	speaking = true
	tween = create_tween()
	for caractere in texte_complet:
		tween.tween_callback(_ajouter_caractere.bind(caractere)).set_delay(vitesse_texte)
	tween.tween_callback(endTween)

func _ajouter_caractere(caractere: String):
	dialogLabel.text += caractere
	
func endTween():
	speaking = false	
	
func load_json(chemin: String) -> Dictionary:
	var file = FileAccess.open(chemin, FileAccess.READ)
	if file == null:
		printerr("Dialogue non trouvé : ", chemin)
		return {}
	var json = JSON.new()
	json.parse(file.get_as_text())
	return json.get_data()
