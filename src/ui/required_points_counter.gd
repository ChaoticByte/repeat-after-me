extends Label

var last_level: int = -1

func _process(_delta: float) -> void:
	var l = XpLevelManager.player_level
	if last_level != l:
		self.text = str(XpLevelManager.get_required_xp(l+1))
		last_level = l
