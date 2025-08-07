extends PanelContainer

var notification_started: int = 0 # in ms
var current_notification_timeout: int = 0 # in ms

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	var t = Time.get_ticks_msec()
	if visible:
		if t - notification_started > current_notification_timeout:
			hide()
	else:
		var n = NotificationQueue.get_next() # [text, timeout] or null
		if n != null:
			notification_started = t
			$Label.text = n[0]
			current_notification_timeout = n[1]
			show()
			grab_focus()
