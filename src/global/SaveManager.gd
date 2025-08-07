extends Node

const SAVEFILE = "user://save.dat"

func _ready() -> void:
	load_game()

func _to_dict() -> Dictionary:
	return {
		"player_xp": XpLevelManager.player_xp,
		"phrases": PhrasesManager.phrases,
		"last_played_phrases": CoreGameplayManager.last_played_phrases
	}

func _from_dict(data: Dictionary) -> int:
	var successfully_set = 0
	# set variables
	if "player_xp" in data:
		XpLevelManager.loading = true
		XpLevelManager.player_xp = data["player_xp"]
		XpLevelManager.loading = false
		successfully_set += 1 #!
	if "phrases" in data and data["phrases"] is Array:
		PhrasesManager.phrases = []
		for p in data["phrases"]:
			PhrasesManager.phrases.append(p)
		successfully_set += 1 #!
	if "last_played_phrases" in data and data["last_played_phrases"] is Array:
		CoreGameplayManager.last_played_phrases = data["last_played_phrases"]
		successfully_set += 1 #!
	return successfully_set

func save_game():
	var data_json = JSON.stringify(_to_dict())
	var f = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	f.store_string(data_json)
	f.close()

func load_game():
	if FileAccess.file_exists(SAVEFILE):
		var data_json = FileAccess.get_file_as_string(SAVEFILE)
		var data = JSON.parse_string(data_json)
		_from_dict(data)

func export_to_base64() -> String:
	var data_json = JSON.stringify(_to_dict())
	return Marshalls.utf8_to_base64(data_json)

func import_from_base64(encoded_data: String) -> bool:
	var data_json = Marshalls.base64_to_utf8(encoded_data)
	var data_dict = JSON.parse_string(data_json)
	if data_dict == null:
		return false
	var n_successful: int = _from_dict(data_dict) > 0
	if n_successful > 0:
		save_game()
		return true
	else: return false
