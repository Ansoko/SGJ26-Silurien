extends Button

@export var son_hover: AudioStream
@export var son_click: AudioStream

func _ready():
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_click)

func _on_hover():
	AudioManager.play_SFX.emit(son_hover)

func _on_click():
	AudioManager.play_SFX.emit(son_click)
	var texte = WordManager.letterText
	texte = remplacer_balises_barre(texte)
	DisplayServer.clipboard_set(texte)
	text = "Copié !" 
	await get_tree().create_timer(2.0).timeout
	text = "Copier dans le presse-papier"
	
func remplacer_balises_barre(texte: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[s\\](.*?)\\[/s\\]")
	var resultats = regex.search_all(texte)
	
	for i in range(resultats.size() - 1, -1, -1):
		var r = resultats[i]
		var mot_barre = barrer_texte(r.get_string(1))
		texte = texte.substr(0, r.get_start()) + mot_barre + texte.substr(r.get_end())
	
	return texte
	
func barrer_texte(texte: String) -> String:
	var resultat = ""
	for caractere in texte:
		resultat += caractere + "\u0336"
	return resultat
