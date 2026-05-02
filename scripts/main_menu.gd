extends Control

var _title_full = "TYPE OR DIE"
var _title_index = 0
var _title_label: Label
var _words = ["fast", "type", "speed", "word", "fall", "die", "run", "key", "press", "rush"]
var _falling_labels = []

func _ready():
	_build_menu()
	_start_title_animation()
	_spawn_background_words()

func _build_menu():
	# Dark background
	var bg = ColorRect.new()
	bg.color = Color(0.04, 0.04, 0.12)
	bg.anchors_preset = Control.PRESET_FULL_RECT
	add_child(bg)

	# Starfield
	var star_layer = Node2D.new()
	star_layer.name = "Stars"
	add_child(star_layer)
	for i in range(80):
		var star = ColorRect.new()
		var size = randf_range(1.0, 3.0)
		star.size = Vector2(size, size)
		star.color = Color(1, 1, 1, randf_range(0.3, 1.0))
		star.position = Vector2(randf_range(0, 800), randf_range(0, 600))
		star_layer.add_child(star)

	# Center container
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.set_anchor(SIDE_LEFT, 0.5)
	vbox.set_anchor(SIDE_RIGHT, 0.5)
	vbox.set_anchor(SIDE_TOP, 0.5)
	vbox.set_anchor(SIDE_BOTTOM, 0.5)
	vbox.offset_left = -250.0
	vbox.offset_right = 250.0
	vbox.offset_top = -150.0
	vbox.offset_bottom = 150.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 18)
	add_child(vbox)

	# Title label
	_title_label = Label.new()
	_title_label.text = ""
	_title_label.add_theme_font_size_override("font_size", 72)
	_title_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.custom_minimum_size = Vector2(500, 0)
	vbox.add_child(_title_label)

	# Subtitle
	var subtitle = Label.new()
	subtitle.text = "type the words before they hit the ground"
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.6, 0.8))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)

	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(spacer)

	# Start button
	var start_btn = ButtonCreator._make_button("▶  Start Game", Color(0.1, 0.6, 0.2))
	start_btn.pressed.connect(_on_start_pressed)
	vbox.add_child(start_btn)

	# Quit button
	var quit_btn = ButtonCreator._make_button("✕  Quit", Color(0.5, 0.1, 0.1))
	quit_btn.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_btn)

func _start_title_animation():
	_title_index = 0
	_type_next_letter()

func _type_next_letter():
	if _title_index <= _title_full.length():
		_title_label.text = _title_full.substr(0, _title_index)
		_title_index += 1
		await get_tree().create_timer(0.1).timeout
		_type_next_letter()
	else:
		# Pulse the title once it's done typing
		var tween = create_tween().set_loops()
		tween.tween_property(_title_label, "modulate", Color(1.0, 0.5, 0.5), 0.8)
		tween.tween_property(_title_label, "modulate", Color(1.0, 1.0, 1.0), 0.8)

func _spawn_background_words():
	for i in range(6):
		await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
		_create_falling_word()

func _create_falling_word():
	var word = _words[randi() % _words.size()]
	var lbl = Label.new()
	lbl.text = word
	lbl.add_theme_font_size_override("font_size", 20)
	lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.15))
	lbl.position = Vector2(randf_range(20, 760), -30)
	add_child(lbl)
	_falling_labels.append(lbl)

func _process(delta):
	for lbl in _falling_labels:
		if is_instance_valid(lbl):
			lbl.position.y += 40 * delta
			if lbl.position.y > 650:
				lbl.queue_free()
				_falling_labels.erase(lbl)
				_create_falling_word()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	get_tree().quit()
