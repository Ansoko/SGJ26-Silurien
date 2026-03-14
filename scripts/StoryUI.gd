extends Control

@onready var storyLabel = $ScrollContainer/Label
@onready var scrollContainer = $ScrollContainer

func addNewWordToStory(newWord: String) -> void:
	storyLabel.text += " "+newWord;
	scrollToEnd.call_deferred()

func removeLastWord() -> void:
	var mots = storyLabel.text.split(" ")
	mots.resize(mots.size() - 1)
	storyLabel.text = " ".join(mots) 
	scrollToEnd.call_deferred()

func scrollToEnd() -> void:
	var stb := func():
		scrollContainer.scroll_horizontal = scrollContainer.get_h_scroll_bar().max_value
	stb.call_deferred()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			addNewWordToStory("mot")
		if event.keycode == KEY_BACKSPACE:
			removeLastWord()
