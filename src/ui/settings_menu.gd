extends Panel

func _ready() -> void:
	hide()

func _on_close_settings_button_pressed() -> void:
	hide()

func _on_reset_xp_button_pressed() -> void:
	XpLevelManager.player_xp = 0
	SaveManager.save_game()
	NotificationQueue.add("Reset XP.")
