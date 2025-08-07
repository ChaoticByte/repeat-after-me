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

# represents the order of last played phrases
var last_played_phrases: Array = []

func register_current_phrase_played():
	if current_phrase in last_played_phrases:
		last_played_phrases.erase(current_phrase)
	last_played_phrases.append(current_phrase)
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
	# pick a random non-played phrase, if possible
	var phrases_not_played = []
	for p in PhrasesManager.phrases:
		if not p in last_played_phrases:
			phrases_not_played.append(p)
	if len(phrases_not_played) > 0:
		current_phrase = phrases_not_played.pick_random()
		current_status = STATUS_PLEASE_REPEAT
		return
	# find the half of phrases that were repeated longest ago
	var i_max = max(1, len(last_played_phrases) / 2)
	var phrases_played_longest_ago = last_played_phrases.slice(0, i_max)
	# pick random phrase
	var phrase = phrases_played_longest_ago.pick_random()
	if phrase == null: # this shouldn't happen!
		current_phrase = ""
		current_status = STATUS_NONE_AVAILABLE
	else:
		current_phrase = phrase
		current_status = STATUS_PLEASE_REPEAT

func try_overwrite_next_phrase(p: String):
	if p in PhrasesManager.phrases:
		current_phrase = p
		current_status = STATUS_PLEASE_REPEAT
	else: # if this didn't work, choose one automatically
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
