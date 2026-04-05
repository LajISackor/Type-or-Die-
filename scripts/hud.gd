extends CanvasLayer
## HUD — Displays score, health, typed text, pause screen, and game over overlay.
## Assigned to: Joel
## STATUS: Working base — Joel to add visual polish, hearts, animations

signal restart_requested()
signal menu_requested()
signal resume_requested()

var score_label: Label
var health_label: Label
var typing_label: Label
var level_label: Label
var pause_panel: PanelContainer
var game_over_panel: PanelContainer

func _ready():
	_build_hud()

func _build_hud():
	# --- Top bar: Score and Health ---
	var top_bar = HBoxContainer.new()
	top_bar.name = "TopBar"
	top_bar.anchors_preset = Control.PRESET_TOP_WIDE
	top_bar.offset_bottom = 40.0
	top_bar.offset_left = 10.0
	top_bar.offset_right = -10.0
	top_bar.offset_top = 5.0
	add_child(top_bar)
	
	health_label = Label.new()
	health_label.name = "HealthLabel"
	health_label.text = "HP: 5"
	health_label.add_theme_font_size_override("font_size", 22)
	health_label.add_theme_color_override("font_color", Color.TOMATO)
	health_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(health_label)
	
	level_label = Label.new()
	level_label.name = "LevelLabel"
	level_label.text = "Level 1"
	level_label.add_theme_font_size_override("font_size", 22)
	level_label.add_theme_color_override("font_color", Color.GOLD)
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(level_label)
	
	score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.text = "Score: 0"
	score_label.add_theme_font_size_override("font_size", 22)
	score_label.add_theme_color_override("font_color", Color.WHITE)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	score_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(score_label)
	
	# --- Bottom: Typing display ---
	typing_label = Label.new()
	typing_label.name = "TypingLabel"
	typing_label.text = ""
	typing_label.add_theme_font_size_override("font_size", 26)
	typing_label.add_theme_color_override("font_color", Color.CYAN)
	typing_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	typing_label.anchors_preset = Control.PRESET_BOTTOM_WIDE
	typing_label.offset_top = -50.0
	typing_label.offset_bottom = -10.0
	typing_label.offset_left = 10.0
	typing_label.offset_right = -10.0
	add_child(typing_label)
	
	# --- Pause overlay ---
	pause_panel = _create_overlay_panel("PAUSED")
	var pause_vbox = pause_panel.get_child(0)
	var resume_btn = Button.new()
	resume_btn.text = "Resume"
	resume_btn.pressed.connect(func(): resume_requested.emit())
	resume_btn.add_theme_font_size_override("font_size", 20)
	pause_vbox.add_child(resume_btn)
	var pause_quit_btn = Button.new()
	pause_quit_btn.text = "Main Menu"
	pause_quit_btn.pressed.connect(func(): menu_requested.emit())
	pause_quit_btn.add_theme_font_size_override("font_size", 20)
	pause_vbox.add_child(pause_quit_btn)
	pause_panel.visible = false
	pause_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(pause_panel)
	
	# --- Game Over overlay ---
	game_over_panel = _create_overlay_panel("GAME OVER")
	var go_vbox = game_over_panel.get_child(0)
	
	var stats_label = Label.new()
	stats_label.name = "StatsLabel"
	stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats_label.add_theme_font_size_override("font_size", 18)
	go_vbox.add_child(stats_label)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 10)
	go_vbox.add_child(spacer)
	
	var retry_btn = Button.new()
	retry_btn.text = "Play Again"
	retry_btn.pressed.connect(func(): restart_requested.emit())
	retry_btn.add_theme_font_size_override("font_size", 20)
	go_vbox.add_child(retry_btn)
	var menu_btn = Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.pressed.connect(func(): menu_requested.emit())
	menu_btn.add_theme_font_size_override("font_size", 20)
	go_vbox.add_child(menu_btn)
	game_over_panel.visible = false
	add_child(game_over_panel)

func _create_overlay_panel(title_text: String) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.anchors_preset = Control.PRESET_FULL_RECT
	
	# Darken background
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.75)
	panel.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.anchors_preset = Control.PRESET_CENTER
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.add_child(vbox)
	
	var title = Label.new()
	title.name = "TitleLabel"
	title.text = title_text
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.RED)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)
	
	return panel

# --- Public update methods called by game_manager ---

func update_score(value: int):
	if score_label:
		score_label.text = "Score: " + str(value)

func update_health(value: int):
	if health_label:
		# Show hearts instead of number
		var hearts = ""
		for i in range(value):
			hearts += "♥ "
		health_label.text = hearts.strip_edges() if hearts.length() > 0 else "♥ DEAD"

func update_typing(text: String):
	if typing_label:
		if text.length() > 0:
			typing_label.text = "> " + text + "_"
		else:
			typing_label.text = ""

func update_level(value: int):
	if level_label:
		level_label.text = "Level " + str(value)

func show_pause():
	pause_panel.visible = true

func show_game_over(stats: Dictionary):
	game_over_panel.visible = true
	var stats_label = game_over_panel.get_child(0).get_node("StatsLabel")
	if stats_label:
		stats_label.text = "Score: " + str(stats.get("score", 0)) + "\n"
		stats_label.text += "Words Typed: " + str(stats.get("words_typed", 0)) + "\n"
		stats_label.text += "Words Missed: " + str(stats.get("words_missed", 0)) + "\n"
		stats_label.text += "Accuracy: " + str(snapped(stats.get("accuracy", 0), 0.1)) + "%\n"
		stats_label.text += "Level Reached: " + str(stats.get("level", 1))

func hide_overlays():
	pause_panel.visible = false
	game_over_panel.visible = false

func hide_pause():
	pause_panel.visible = false
