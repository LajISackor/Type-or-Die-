extends Node
## Typing Input — Captures keystrokes and matches them to falling words.
## Assigned to: Laji

var current_target: Node2D = null  # the word currently being typed
var typed_text: String = ""
var active_words: Array = []  # references to all falling word nodes

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var character = char(event.unicode)
		if character.length() > 0 and character.is_valid_identifier() or character == " ":
			_handle_character(character.to_lower())

func _handle_character(character: String):
	typed_text += character

	# If no current target, find one that starts with the typed text
	if current_target == null:
		_find_target()

	# If we have a target, try to match the character
	if current_target != null:
		var matched = current_target.try_match_char(character)
		if not matched:
			# Mismatch — reset
			typed_text = ""
			if current_target:
				current_target.reset_match()
			current_target = null

func _find_target():
	# TODO: Look through active_words for a word that starts with typed_text
	# Auto-target the closest to the bottom (most urgent)
	for word_node in active_words:
		if word_node.word_text.begins_with(typed_text):
			current_target = word_node
			return

func register_word(word_node: Node2D):
	## Called by the spawner when a new word is created
	active_words.append(word_node)

func unregister_word(word_node: Node2D):
	## Called when a word is destroyed or missed
	active_words.erase(word_node)
	if current_target == word_node:
		current_target = null
		typed_text = ""
