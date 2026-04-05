extends Node2D
## Falling Word — A single word that falls from the top of the screen.
## Assigned to: Joel
## STATUS: Working base — Joel to add visual polish, particles, animations

signal word_destroyed(word_text: String, points: int)
signal word_missed(word_text: String)

@export var fall_speed: float = 60.0
@export var word_text: String = "hello"

var matched_chars: int = 0
var is_targeted: bool = false

@onready var label: RichTextLabel = $RichTextLabel

func _ready():
	add_to_group("falling_words")
	_update_display()

func _process(delta):
	position.y += fall_speed * delta
	
	# Word hit the ground
	if position.y > get_viewport_rect().size.y + 10:
		word_missed.emit(word_text)
		queue_free()

func set_matched_chars(count: int):
	matched_chars = count
	_update_display()

func set_targeted(targeted: bool):
	is_targeted = targeted
	_update_display()

func complete_word():
	var points = word_text.length() * 10
	word_destroyed.emit(word_text, points)
	queue_free()

func _update_display():
	if not label:
		return
	
	var bbcode = ""
	
	# Show matched characters in green, rest in white
	if matched_chars > 0:
		var matched_part = word_text.substr(0, matched_chars)
		var remaining_part = word_text.substr(matched_chars)
		bbcode = "[color=#00ff88]" + matched_part + "[/color]"
		if is_targeted:
			bbcode += "[color=#ffffff]" + remaining_part + "[/color]"
		else:
			bbcode += "[color=#cccccc]" + remaining_part + "[/color]"
	else:
		if is_targeted:
			bbcode = "[color=#ffffff]" + word_text + "[/color]"
		else:
			bbcode = "[color=#cccccc]" + word_text + "[/color]"
	
	label.text = ""
	label.bbcode_enabled = true
	label.text = "[center][font_size=28]" + bbcode + "[/font_size][/center]"
