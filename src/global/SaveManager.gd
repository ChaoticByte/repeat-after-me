extends Node

const SAVEFILE = "user://save.dat"

func _ready() -> void:
	load_game()

func save_game():
	var data: Dictionary = {
		"player_xp": XpLevelManager.player_xp,
		"phrases": PhrasesManager.phrases,
		"last_played_phrases": CoreGameplayManager.last_played_phrases
	}
	var data_json = JSON.stringify(data)
	var f = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	f.store_string(data_json)
	f.close()

func load_game():
	if FileAccess.file_exists(SAVEFILE):
		var data_json = FileAccess.get_file_as_string(SAVEFILE)
		var data = JSON.parse_string(data_json)
		# set variables
		if "player_xp" in data:
			XpLevelManager.loading = true
			XpLevelManager.player_xp = data["player_xp"]
			XpLevelManager.loading = false
		if "phrases" in data and data["phrases"] is Array:
			PhrasesManager.phrases = []
			for p in data["phrases"]:
				PhrasesManager.phrases.append(p)
		if "last_played_phrases" in data and data["last_played_phrases"] is Dictionary:
			CoreGameplayManager.last_played_phrases = data["last_played_phrases"]
