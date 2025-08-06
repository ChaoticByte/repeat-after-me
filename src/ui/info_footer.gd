extends Label

func _ready() -> void:
	text = "Repeat After Me " + ProjectSettings.get_setting("application/config/version") + " by ChaoticByte"
