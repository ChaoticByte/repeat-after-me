extends PanelContainer

var showing_notification: bool = false
var notification_started: int = 0 # in ms
var current_notification_timeout: int = 0 # in ms

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	var t = Time.get_ticks_msec()
	if showing_notification:
		if t - notification_started > current_notification_timeout:
			showing_notification = false
	else:
		var n = NotificationQueue.get_next() # [text, timeout] or null
		if n != null:
			showing_notification = true
			notification_started = t
			$Label.text = n[0]
			current_notification_timeout = n[1]
	#
	if not showing_notification and visible:
		hide()
	elif showing_notification and not visible:
		show()
