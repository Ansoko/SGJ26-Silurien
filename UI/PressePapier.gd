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
	if OS.get_name() == "Web":
		#texte = JSON.stringify(texte)
		#texte = remplacer_balises_barre(texte)
		#
		#JavaScriptBridge.eval("window._texteToCopy = %s;" %texte)
		#JavaScriptBridge.eval("""
			#navigator.clipboard.writeText(window._texteToCopy).catch(console.error);
		#""")
		
		texte = remplacer_balises_barre(texte)
		var bytes = texte.to_utf8_buffer()
		var b64 = Marshalls.raw_to_base64(bytes)
		JavaScriptBridge.eval("""
            (function() {
                var binary = atob('%s');
                var bytes = new Uint8Array(binary.length);
                for (var i = 0; i < binary.length; i++) {
                    bytes[i] = binary.charCodeAt(i);
                }
                var text = new TextDecoder('utf-8').decode(bytes);
                
                function fallbackCopy(t) {
                    var ta = document.createElement('textarea');
                    ta.value = t;
                    ta.style.position = 'fixed';
                    ta.style.opacity = '0';
                    document.body.appendChild(ta);
                    ta.focus();
                    ta.select();
                    document.execCommand('copy');
                    document.body.removeChild(ta);
                }
                
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(text).catch(function() {
                        fallbackCopy(text);
                    });
                } else {
                    fallbackCopy(text);
                }
            })();
		""" % b64)
	else:
		DisplayServer.clipboard_set(remplacer_balises_barre(texte))
		
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
