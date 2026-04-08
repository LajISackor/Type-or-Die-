extends Node2D

signal word_destroyed(word_text: String, points: int)
signal word_missed(word_text: String)

@export var fall_speed: float = 60.0
@export var word_text: String = "hello"

var matched_chars: int = 0
var is_targeted: bool = false

@onready var label: RichTextLabel = $RichTextLabel

func _ready():
	add_to_group("falling_words")
	# Pop-in animation: start small and scale up
	scale = Vector2(0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_update_display()

func _process(delta):
	position.y += fall_speed * delta
	if position.y > get_viewport_rect().size.y + 10:
		word_missed.emit(word_text)
		queue_free()

func set_matched_chars(count: int):
	matched_chars = count
	_update_display()

func set_targeted(targeted: bool):
	is_targeted = targeted
	_update_display()
	# Glow effect: scale up slightly when targeted
	var tween = create_tween()
	if targeted:
		tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.1)
	else:
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func complete_word():
	var points = word_text.length() * 10
	word_destroyed.emit(word_text, points)
	queue_free()

func _update_display():
	if not label:
		return

	var bbcode = ""

	if matched_chars > 0:
		var matched_part = word_text.substr(0, matched_chars)
		# Current next letter highlighted in yellow
		var next_char = ""
		var remaining_part = ""
		if matched_chars < word_text.length():
			next_char = word_text.substr(matched_chars, 1)
			remaining_part = word_text.substr(matched_chars + 1)
		bbcode = "[color=#00ff88]" + matched_part + "[/color]"
		bbcode += "[color=#ffdd00]" + next_char + "[/color]"
		if is_targeted:
			bbcode += "[color=#ffffff]" + remaining_part + "[/color]"
		else:
			bbcode += "[color=#aaaaaa]" + remaining_part + "[/color]"
	else:
		if is_targeted:
			bbcode = "[color=#ffffff]" + word_text + "[/color]"
		else:
			bbcode = "[color=#aaaaaa]" + word_text + "[/color]"

	label.bbcode_enabled = true
	label.text = "[center][font_size=28]" + bbcode + "[/font_size][/center]"