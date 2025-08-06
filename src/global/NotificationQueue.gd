extends Node

var _queue: Array = [] # []

func add(n: String, timeout_ms: int = 3000):
	# clamp timeout to 0.5s-30s 
	timeout_ms = clamp(timeout_ms, 500, 30_000)
	if len(n) > 0:
		_queue.append([n, timeout_ms])

func get_next(): # returns either String or Nil
	return _queue.pop_front()
