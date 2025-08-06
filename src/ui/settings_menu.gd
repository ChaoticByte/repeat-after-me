extends Panel

func _ready() -> void:
	hide()

func _on_close_settings_button_pressed() -> void:
	hide()

func _on_reset_xp_button_pressed() -> void:
	XpLevelManager.player_xp = 0
	SaveManager.save_game()
	NotificationQueue.add("Reset XP.")

func _on_import_button_pressed() -> void:
	var data = DisplayServer.clipboard_get()
	if SaveManager.import_from_base64(data):
		NotificationQueue.add("Import successful", 4000)
	else:
		NotificationQueue.add("Import failed", 4000)

func _on_export_button_pressed() -> void:
	var data = SaveManager.export_to_base64()
	DisplayServer.clipboard_set(data)
	NotificationQueue.add("Exported to clipboard", 4000)
