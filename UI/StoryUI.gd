extends CanvasLayer

@export var SFXerasure: Array[AudioStream] = []

func _ready() -> void:
	WordManager.add_word.connect(addNewWordToStory)
	WordManager.saveText.connect(saveStoryText)
	dialogPanel.hide()
	hideStory()
	allLignes = load_json("res://csv/dialogues.json")
	SignalManager.start_game.connect(start_intro)
	SignalManager.start_outro.connect(start_outro)
	SignalManager.start_outro.connect(hideStory)
	SignalManager.end_intro.connect(showStory)

func _input(event):
	if event.is_action_pressed("erase"):
		if isInDialogMode:
			skipDialogue()
		else:
			removeLastWord()
	if isInDialogMode && event.is_action_pressed("jump"):
			show_next_line()
	
#region current letter (at the top)
@onready var storyLabel = $Control/ScrollContainer/RichTextLabel
@onready var scrollContainer = $Control/ScrollContainer
@onready var storyPanel = $Control

var list_words: Array = [{0:"Chère",1: false}, {0:"Mamie,", 1:false}] #word + bool barré

func addNewWordToStory(newWord: String):
	if(getLastWord() in [".", "!", "?"]):
		newWord = premiere_majuscule(newWord)
		
	list_words.append({0:newWord, 1:false})
	
	if(newWord not in [".",","]):
		storyLabel.text += " "
	storyLabel.text += newWord

	scrollToEnd.call_deferred()

func premiere_majuscule(texte: String) -> String:
	if texte.is_empty():
		return texte
	return texte[0].to_upper() + texte.substr(1)

func removeLastWord():
	var lastWord = getLastWord()
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
	
	AudioManager.play_SFX.emit(SFXerasure.pick_random())
	scrollToEnd.call_deferred()
	
func getLastWord() -> String:
	var lastWord = "";
	for i in range(list_words.size()-1, -1, -1):
		if not list_words[i][1]:
			list_words[i][1] = true
			lastWord = list_words[i][0]
			break
	return lastWord

func scrollToEnd():
	var stb := func():
		scrollContainer.scroll_horizontal = scrollContainer.get_h_scroll_bar().max_value
	stb.call_deferred()
	
func hideStory():
	storyPanel.hide()
	
func showStory():
	storyPanel.show()

func saveStoryText():
	WordManager.letterText = storyLabel.text
#endregion

#region dialog system
@onready var nameLabel = $Dialog/Panel/nameCharacter
@onready var dialogLabel = $Dialog/Panel/line
@onready var characterDad = $Dialog/Panel/characterArnaud
@onready var characterChild = $Dialog/Panel/characterClaire
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
	show_next_line.call_deferred()
	
func start_outro():
	index_courant = -1
	currentState = "outro"
	isInDialogMode = true
	dialogPanel.show()
	show_next_line()
	
func show_next_line():
	index_courant += 1
	var line = allLignes.get(currentState)
		
	if tween:
		tween.kill()
		
	if speaking:
		speaking = false
		index_courant -= 1
		nameLabel.text = "[b]"+line[index_courant]["character"]+"[/b]"
		dialogLabel.visible_ratio = 1.0
		return
		
	if(index_courant >= line.size()):
		skipDialogue()
		return
	
	AudioManager.play_SFX.emit(load(line[index_courant]["audio"]))
	nameLabel.text = "[b]"+line[index_courant]["character"]+"[/b]"
	dialogLabel.text = "[shake rate=3 level=5]"+line[index_courant]["line"]+"[/shake]"
	dialogLabel.visible_ratio = 0
	match line[index_courant]["character"]:
		"ARNAUD":
			characterChild.hide()
			characterDad.show()
		"CLAIRE":
			characterDad.hide()
			characterChild.show()
		
	speaking = true
	tween = create_tween()
	tween.tween_property(dialogLabel, "visible_ratio", 1.0, line[index_courant]["line"].length()*vitesse_texte)
	tween.tween_callback(endTween)
	
func endTween():
	speaking = false
	
func skipDialogue():
	if tween:
		tween.kill()
	speaking = false
	isInDialogMode = false
	dialogPanel.hide()
	if currentState == "intro":
		SignalManager.end_intro.emit()
	else:
		SignalManager.end_outro.emit()
	
func load_json(chemin: String) -> Dictionary:
	var file = FileAccess.open(chemin, FileAccess.READ)
	if file == null:
		printerr("Dialogue non trouvé : ", chemin)
		return {}
	var json = JSON.new()
	json.parse(file.get_as_text())
	return json.get_data()
#endregion
