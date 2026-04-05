extends Node
## Typing Input — Captures keystrokes, matches words, emits feedback signals.
## Assigned to: Laji (COMPLETE)

signal typed_text_changed(text: String)
signal correct_keystroke()
signal wrong_keystroke()

var current_target: Node2D = null
var typed_text: String = ""
var active_words: Array = []
var score_manager: Node = null

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		# Handle backspace
		if event.keycode == KEY_BACKSPACE:
			_handle_backspace()
			return
		
		# Let game_manager handle Escape
		if event.keycode == KEY_ESCAPE:
			return
		
		# Get typed character
		var character = char(event.unicode)
		if character.length() > 0 and event.unicode >= 32:
			_handle_character(character.to_lower())

func _handle_character(character: String):
	var new_typed = typed_text + character
	
	# No current target — find one
	if current_target == null or not is_instance_valid(current_target):
		current_target = null
		typed_text = character
		_find_target(typed_text)
		
		if current_target == null:
			typed_text = ""
			wrong_keystroke.emit()
			typed_text_changed.emit(typed_text)
			return
		else:
			current_target.set_matched_chars(1)
			correct_keystroke.emit()
			typed_text_changed.emit(typed_text)
			return
	
	# Have a target — match next character
	var expected_index = typed_text.length()
	if expected_index < current_target.word_text.length():
		var expected_char = current_target.word_text[expected_index]
		
		if character == expected_char:
			# Correct
			typed_text = new_typed
			current_target.set_matched_chars(typed_text.length())
			correct_keystroke.emit()
			typed_text_changed.emit(typed_text)
			
			# Check completion
			if typed_text.length() >= current_target.word_text.length():
				current_target.complete_word()
				_reset_input()
		else:
			# Wrong — reset
			wrong_keystroke.emit()
			if current_target and is_instance_valid(current_target):
				current_target.set_matched_chars(0)
			_reset_input()
	else:
		_reset_input()

func _handle_backspace():
	if typed_text.length() > 0:
		typed_text = typed_text.substr(0, typed_text.length() - 1)
		
		if typed_text.length() == 0:
			if current_target and is_instance_valid(current_target):
				current_target.set_matched_chars(0)
				current_target.set_targeted(false)
			current_target = null
		else:
			if current_target and is_instance_valid(current_target):
				current_target.set_matched_chars(typed_text.length())
		
		typed_text_changed.emit(typed_text)

func _find_target(prefix: String):
	## Auto-target the word closest to the bottom (most urgent) that matches
	var best_target: Node2D = null
	var best_y: float = -999.0
	
	for word_node in active_words:
		if not is_instance_valid(word_node):
			continue
		if word_node.word_text.begins_with(prefix):
			if word_node.position.y > best_y:
				best_y = word_node.position.y
				best_target = word_node
	
	if best_target:
		# Deselect old target
		if current_target and is_instance_valid(current_target) and current_target != best_target:
			current_target.set_matched_chars(0)
			current_target.set_targeted(false)
		
		current_target = best_target
		current_target.set_targeted(true)

func _reset_input():
	typed_text = ""
	if current_target and is_instance_valid(current_target):
		current_target.set_targeted(false)
	current_target = null
	typed_text_changed.emit(typed_text)

func register_word(word_node: Node2D):
	active_words.append(word_node)
	word_node.tree_exiting.connect(_on_word_exiting.bind(word_node))

func _on_word_exiting(word_node: Node2D):
	unregister_word(word_node)

func unregister_word(word_node: Node2D):
	active_words.erase(word_node)
	if current_target == word_node:
		_reset_input()

func clear_all():
	typed_text = ""
	current_target = null
	active_words.clear()
	typed_text_changed.emit(typed_text)
