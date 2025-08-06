extends Node

var player_level: int = 0:
	set(v):
		player_level = max(0, v)

var loading: bool = false

func update_level():
	var level = 0
	while true: # brute-forcing it bc. of precision problems when calculating it
		if player_xp < get_required_xp(level + 1):
			var old_player_level = player_level
			player_level = level
			if player_level > old_player_level and not loading:
				NotificationQueue.add("Level Up!")
			break
		level += 1

var player_xp: int = 0:
	set(v):
		player_xp = max(0, v)
		update_level()

func add_xp(additional_xp: int):
	player_xp += additional_xp
	SaveManager.save_game() # TODO this might be a bit much...

func get_required_xp(level: int) -> int:
	if level == 0: return 0
	var xp = 3 * pow(level, 1.5)
	return max(0, int(xp))
