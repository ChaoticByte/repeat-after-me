extends Label

var last_xp: int = -1

func _process(_delta: float) -> void:
	var xp = XpLevelManager.player_xp
	if last_xp != xp:
		self.text = str(xp)
		last_xp = xp
