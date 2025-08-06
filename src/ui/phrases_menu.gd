extends Control

func _ready() -> void:
	PhrasesManager.phrases_list_node = %PhrasesList
	hide()

func _on_add_phrase_button_pressed() -> void:
	var phrase = $LineEdit.text
	if PhrasesManager.add_phrase(phrase):
		$LineEdit.clear()

func _on_close_phrases_button_pressed() -> void:
	hide()
