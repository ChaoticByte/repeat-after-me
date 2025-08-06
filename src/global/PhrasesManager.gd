extends Node

var phrase_scene = preload("uid://b6hmd8gv7m2tv")

var phrases: Array[String] = []
var phrases_list_node: Control = null

func add_phrase(p: String) -> bool:
	if len(p) > 0:
		if not p in phrases:
			phrases.append(p)
			update_phrases_list_node()
			SaveManager.save_game()
			if len(phrases) == 1:
				# show new phrase if there was none before
				CoreGameplayManager.next_phrase()
			return true
	return false

func remove_phrase(p: String):
	phrases.erase(p)
	update_phrases_list_node()
	SaveManager.save_game()
	if CoreGameplayManager.current_phrase == p:
		CoreGameplayManager.next_phrase()

func update_phrases_list_node():
	if phrases_list_node != null:
		for c in phrases_list_node.get_children():
			c.queue_free()
		for p in phrases:
			var p_node = phrase_scene.instantiate()
			p_node.text = p
			phrases_list_node.add_child(p_node)
