extends Label

var last_level: int = -1

func _process(_delta: float) -> void:
	var l = XpLevelManager.player_level
	if last_level != l:
		self.text = str(l)
		last_level = l
