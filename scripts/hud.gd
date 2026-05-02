extends CanvasLayer

signal restart_requested()
signal menu_requested()
signal resume_requested()

var score_label: Label
var health_label: Label
var typing_label: Label
var level_label: Label
var pause_panel: PanelContainer
var game_over_panel: PanelContainer

var _last_health: int = 5

func _ready():
	_build_hud()

func _build_hud():
	# --- Top bar ---
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
	health_label.text = "♥ ♥ ♥ ♥ ♥"
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

	# --- Typing bar background panel ---
	var typing_panel = PanelContainer.new()
	typing_panel.anchors_preset = Control.PRESET_BOTTOM_WIDE
	typing_panel.offset_top = -60.0
	typing_panel.offset_bottom = -8.0
	typing_panel.offset_left = 40.0
	typing_panel.offset_right = -40.0
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.0, 0.0, 0.0, 0.6)
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.corner_radius_bottom_right = 8
	panel_style.border_width_bottom = 2
	panel_style.border_width_top = 2
	panel_style.border_width_left = 2
	panel_style.border_width_right = 2
	panel_style.border_color = Color.CYAN
	typing_panel.add_theme_stylebox_override("panel", panel_style)
	add_child(typing_panel)

	typing_label = Label.new()
	typing_label.name = "TypingLabel"
	typing_label.text = ""
	typing_label.add_theme_font_size_override("font_size", 24)
	typing_label.add_theme_color_override("font_color", Color.CYAN)
	typing_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	typing_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	typing_panel.add_child(typing_label)

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

func _create_overlay_panel(title_text: String) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.anchors_preset = Control.PRESET_FULL_RECT
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

# --- Public update methods ---

func update_score(value: int):
	if score_label:
		score_label.text = "Score: " + str(value)
		_pulse(score_label, Color.YELLOW)

func update_health(value: int):
	if health_label:
		var hearts = ""
		for i in range(value):
			hearts += "♥ "
		health_label.text = hearts.strip_edges() if hearts.length() > 0 else "DEAD"
		if value < _last_health:
			_flash(health_label, Color.RED)
		_last_health = value

func update_typing(text: String):
	if typing_label:
		if text.length() > 0:
			typing_label.text = "> " + text + "_"
		else:
			typing_label.text = ""

func update_level(value: int):
	if level_label:
		level_label.text = "Level " + str(value)
		_pulse(level_label, Color.GOLD)

func show_pause():
	pause_panel.visible = true

func hide_overlays():
	pause_panel.visible = false
	game_over_panel.visible = false

func hide_pause():
	pause_panel.visible = false

# --- Animation helpers ---

func _pulse(node: Label, color: Color):
	var tween = create_tween()
	tween.tween_property(node, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.1)
	node.add_theme_color_override("font_color", color)
	await get_tree().create_timer(0.2).timeout
	node.add_theme_color_override("font_color", Color.WHITE)

func _flash(node: Label, color: Color):
	var tween = create_tween()
	tween.tween_property(node, "modulate", color, 0.05)
	tween.tween_property(node, "modulate", Color.WHITE, 0.3)
