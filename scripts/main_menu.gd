extends Control
## Main Menu — Title screen with Start and Quit buttons.
## Assigned to: Joel
## STATUS: Working base — Joel to add visual style, animations, background

func _ready():
	_build_menu()

func _build_menu():
	# Background color
	var bg = ColorRect.new()
	bg.color = Color(0.05, 0.05, 0.12)
	bg.anchors_preset = Control.PRESET_FULL_RECT
	add_child(bg)
	
	var vbox = VBoxContainer.new()
	vbox.anchors_preset = Control.PRESET_CENTER
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 15)
	add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "TYPE OR DIE"
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color.RED)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Subtitle
	var subtitle = Label.new()
	subtitle.text = "Type the words before they hit the ground!"
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color.GRAY)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)
	
	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 30)
	vbox.add_child(spacer)
	
	# Start button
	var start_btn = Button.new()
	start_btn.text = "Start Game"
	start_btn.pressed.connect(_on_start_pressed)
	start_btn.add_theme_font_size_override("font_size", 24)
	start_btn.custom_minimum_size = Vector2(250, 50)
	vbox.add_child(start_btn)
	
	# Quit button
	var quit_btn = Button.new()
	quit_btn.text = "Quit"
	quit_btn.pressed.connect(_on_quit_pressed)
	quit_btn.add_theme_font_size_override("font_size", 24)
	quit_btn.custom_minimum_size = Vector2(250, 50)
	vbox.add_child(quit_btn)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	get_tree().quit()
