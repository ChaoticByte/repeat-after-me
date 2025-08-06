extends Node

const XP_PER_ANSWER = 2

# interval for automatically cleaning
# the last_played_phrases dictionary
const AUTOCLEAN_INTERVAL = 2000 # in ms

const STATUS_PLEASE_REPEAT = "please repeat the above phrase"
const STATUS_NONE_AVAILABLE = "no phrase available"

var _last_autocleanup: int = 0 # ms since engine start

var current_phrase: String = ""
var current_status: String = ""

var last_played_phrases: Dictionary = {} # p: [timestamp1, timestamp2, ...]


func register_current_phrase_played():
	var t = Time.get_unix_time_from_system()
	if current_phrase in last_played_phrases:
		last_played_phrases[current_phrase].append(t)
	else:
		last_played_phrases[current_phrase] = [t]
	SaveManager.save_game()

func answer(p_in: String) -> bool:
	if p_in.to_lower() == current_phrase.to_lower():
		XpLevelManager.add_xp(XP_PER_ANSWER)
		register_current_phrase_played()
		next_phrase()
		return true
	return false

func next_phrase() -> void:
	if len(PhrasesManager.phrases) < 1:
		current_phrase = ""
		current_status = STATUS_NONE_AVAILABLE
		return
	# search for a non played phrase
	for p in PhrasesManager.phrases:
		if not p in last_played_phrases:
			current_phrase = p
			current_status = STATUS_PLEASE_REPEAT
			return
	# find the phrase that was played the longest ago
	var phrases_last_ts: Dictionary = {} # timestamp: phrase
	var phrases_last_ts_keys: Array[float] = []
	for p in last_played_phrases:
		if p in PhrasesManager.phrases:
			var t_max = last_played_phrases[p].max()
			phrases_last_ts[t_max] = p
			phrases_last_ts_keys.append(t_max)
	# return the phrase with the smallest timestamp (-> longest ago)
	current_phrase = phrases_last_ts[phrases_last_ts_keys.min()]
	current_status = STATUS_PLEASE_REPEAT

func try_overwrite_next_phrase(p: String):
	if p in PhrasesManager.phrases:
		current_phrase = p
		current_status = STATUS_PLEASE_REPEAT
	else:
		# if this didn't work, choose one automatically
		next_phrase()

func cleanup_last_played_phrases():
	var changed = false
	# remove phrases that don't exist anymore
	for p in last_played_phrases:
		if not p in PhrasesManager.phrases:
			last_played_phrases.erase(p)
			changed = true
	if changed:
		SaveManager.save_game()

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - _last_autocleanup > AUTOCLEAN_INTERVAL:
		cleanup_last_played_phrases()
		_last_autocleanup = Time.get_ticks_msec()
