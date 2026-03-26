extends Node2D
## Falling Word — A single word that falls from the top of the screen.
## Assigned to: Joel

signal word_destroyed(word: String, points: int)
signal word_missed(word: String)

@export var fall_speed: float = 80.0  # pixels per second
@export var word_text: String = "hello"

var matched_chars: int = 0  # how many characters have been typed correctly

@onready var label = $Label  # TODO: Add a Label node in the scene

func _ready():
	# TODO: Set the label text to word_text
	# TODO: Use RichTextLabel for colored letter highlighting
	pass

func _process(delta):
	# Move downward
	position.y += fall_speed * delta

	# Check if word reached the bottom of the screen
	if position.y > get_viewport_rect().size.y:
		word_missed.emit(word_text)
		queue_free()

func try_match_char(character: String) -> bool:
	## Call this when the player types a character.
	## Returns true if the character matches the next expected letter.
	if matched_chars < word_text.length():
		if word_text[matched_chars] == character:
			matched_chars += 1
			_update_highlight()
			if matched_chars >= word_text.length():
				_on_word_completed()
			return true
	return false

func _update_highlight():
	# TODO: Update visual to show which letters have been typed
	# e.g., matched letters in green, remaining in white
	pass

func _on_word_completed():
	var points = word_text.length() * 10  # longer words = more points
	word_destroyed.emit(word_text, points)
	# TODO: Play destruction animation/particles
	queue_free()

func reset_match():
	## Reset matching progress (called when player switches to a different word)
	matched_chars = 0
	_update_highlight()
