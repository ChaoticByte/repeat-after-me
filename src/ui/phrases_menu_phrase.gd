extends Control

var text: String:
	set(v):
		$Label.text = v
	get():
		return $Label.text

func _on_remove_button_pressed() -> void:
	PhrasesManager.remove_phrase(text)
