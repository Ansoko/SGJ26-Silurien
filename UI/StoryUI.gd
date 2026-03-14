extends CanvasLayer

@onready var storyLabel = $Control/ScrollContainer/RichTextLabel
@onready var scrollContainer = $Control/ScrollContainer

var list_words: Array = [{0:"Chère",1: false}, {0:"Mamie,", 1:false}] #word + bool barré

func _ready() -> void:
	WordManager.add_word.connect(addNewWordToStory)

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
