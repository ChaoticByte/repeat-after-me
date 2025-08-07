extends Control

func _ready() -> void:
	CoreGameplayManager.next_phrase()
	%AnswerInput.hide()

func _on_settings_button_pressed() -> void:
	%SettingsMenu.show()

func _on_show_phrases_button_pressed() -> void:
	PhrasesManager.update_phrases_list_node()
	%PhrasesMenu.show()

var last_known_phrase: String = ""
var last_known_status: String = ""

func _process(_delta: float) -> void:
	if last_known_phrase != CoreGameplayManager.current_phrase:
		last_known_phrase = CoreGameplayManager.current_phrase
		if len(last_known_phrase) > 0:
			%CurrentPhrase.text = '"' + last_known_phrase + '"'
			%AnswerInput.show()
		else:
			%CurrentPhrase.text = ""
			%AnswerInput.hide()
	if last_known_status != CoreGameplayManager.current_status:
		last_known_status = CoreGameplayManager.current_status
		%CurrentStatus.text = last_known_status

func _on_answer_input_text_changed(new_text: String) -> void:
	if CoreGameplayManager.answer(new_text):
		%AnswerInput.clear()
