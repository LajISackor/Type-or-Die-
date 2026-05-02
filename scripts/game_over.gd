extends Control
## Game Over Screen — Standalone version
## Assigned to: Sarah

var stats = StatsManager.get_stats()
var duration = 0
var interval = 0
@onready var background = $BackgroundFX

func _ready():
	show_results(stats)

func show_results(stats: Dictionary):
	# Background color
	var bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.04, 0.04, 0.12)
	bg.anchors_preset = Control.PRESET_FULL_RECT
	add_child(bg)

	# Center container
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.offset_left = 165
	vbox.offset_right = -165
	vbox.offset_top = 50
	vbox.offset_bottom = -100
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 18)
	add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "GAME OVER"
	title.add_theme_font_size_override("font_size", 80)
	title.add_theme_color_override("font_color", Color(0.531, 0.0, 0.05, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Get colors for filling stats
	var score_hex = get_score_color()
	var combo_hex = get_combo_color()
	
	# Make grid for stats and fill out
	var stats_grid = GridContainer.new()
	stats_grid.columns = 2 # Column 1 for Name, Column 2 for Value
	stats_grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	stats_grid.custom_minimum_size = Vector2(250, 0) 
	vbox.add_child(stats_grid)
	
	add_stat_row(stats_grid, "Score", str(stats.get("score", 0)), score_hex, interval)
	add_stat_row(stats_grid, "Level", str(stats.get("level", 1)), score_hex, interval)
	add_stat_row(stats_grid, "Words Typed", str(stats.get("words_typed", 0)), score_hex, interval)
	add_stat_row(stats_grid, "Words Missed", str(stats.get("words_missed", 0)), Color.CRIMSON, interval)
	add_stat_row(stats_grid, "Accuracy", str(snapped(stats.get("accuracy", 0), 0.1)), score_hex, interval)
	add_stat_row(stats_grid, "Highest Combo", str(stats.get("highest_combo", 0)), combo_hex, interval)
	
	# Play Again button
	var play_again_btn = Button.new()
	play_again_btn.text = "Play Again"
	play_again_btn.pressed.connect(_on_play_again_pressed)
	play_again_btn.add_theme_font_size_override("font_size", 24)
	play_again_btn.custom_minimum_size = Vector2(250, 50)
	vbox.add_child(play_again_btn)
	
	# Main Menu button
	var menu_btn = Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.pressed.connect(_on_main_menu_pressed)
	menu_btn.add_theme_font_size_override("font_size", 24)
	menu_btn.custom_minimum_size = Vector2(250, 50)
	vbox.add_child(menu_btn)
	
func add_stat_row(grid: GridContainer, label_name: String, value: String, start_color: Color, start_delay: float):
	# The static label
	var label = Label.new()
	label.text = label_name + ": "
	label.add_theme_color_override("font_color", Color.GRAY)
	label.add_theme_font_size_override("font_size", 24)
	label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	grid.add_child(label)
	
	# The animating number label
	var num = Label.new()
	num.text = value
	num.visible_characters = 0
	# Apply the "active" color during typing
	num.add_theme_color_override("font_color", start_color) 
	num.add_theme_font_size_override("font_size", 24)
	num.size_flags_horizontal = Control.SIZE_SHRINK_END
	grid.add_child(num)
	
	# Set duration, add to inetrval to delay next
	var char_speed = 0.12 
	duration = num.text.length() * char_speed
	interval += duration
	
	# Animate reveal
	var tween = create_tween()
	tween.tween_property(num, "visible_characters", num.text.length(), duration).set_delay(start_delay)
	
	# When done, switch to gray
	tween.tween_callback(func():
		num.add_theme_color_override("font_color", Color.GRAY)
	)
	
func get_score_color():
	var score = stats.get("score", 0)
	if score < 4000:
		return Color(0.0, 1.0, 0.5)
	elif score < 5500:
		return Color(0.0, 0.9, 0.3)
	elif score < 7500:
		return Color(0.05, 0.7, 0.2)
	else: 
		return Color(0.1, 0.6, 0.2)
	
func get_combo_color():
	var combo = stats.get("highest_combo", 0)
	if combo < 30:
		return Color(0.0, 1.0, 0.5)
	elif combo < 50:
		return Color(0.0, 0.9, 0.3)
	elif combo < 70:
		return Color(1.0, 0.85, 0.0)
	else:
		return Color(1.0, 0.7, 0.0)
	
	
func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
