extends Node2D
## Game Manager — Controls the main game loop, state, and visual effects.
## Assigned to: Laji (COMPLETE)

enum GameState { PLAYING, PAUSED, GAME_OVER }

var current_state: GameState = GameState.PLAYING

# Difficulty settings
var base_spawn_interval: float = 2.5
var min_spawn_interval: float = 0.6
var difficulty_timer: float = 0.0
var difficulty_ramp_interval: float = 15.0
var base_fall_speed: float = 60.0
var current_fall_speed: float = 60.0
var fall_speed_increment: float = 8.0
var level: int = 1

# Combo tracking
var combo_count: int = 0
var combo_timer: float = 0.0
var combo_timeout: float = 3.0  # seconds before combo resets

@onready var word_spawner: Node = $WordSpawner
@onready var typing_input: Node = $TypingInput
@onready var score_manager: Node = $ScoreManager
@onready var hud: CanvasLayer = $HUD
@onready var vfx: Node2D = $VFXManager
@onready var background = $BackgroundFX


func _ready():
	# Connect score manager signals
	score_manager.score_changed.connect(_on_score_changed)
	score_manager.health_changed.connect(_on_health_changed)
	score_manager.health_depleted.connect(_on_health_depleted)
	
	# Connect word spawner signals
	word_spawner.word_spawned.connect(_on_word_spawned)
	
	# Give typing input a reference to score manager
	typing_input.score_manager = score_manager
	
	# Connect typing input to HUD for live typing display
	typing_input.typed_text_changed.connect(_on_typed_text_changed)
	
	# Initialize HUD values
	hud.update_score(0)
	hud.update_health(score_manager.health)
	hud.update_typing("")
	hud.update_level(level)
	
	# Connect HUD buttons
	hud.restart_requested.connect(restart_game)
	hud.menu_requested.connect(go_to_main_menu)
	hud.resume_requested.connect(resume_game)
	
	# Start the game
	word_spawner.fall_speed = current_fall_speed
	word_spawner.start_spawning()

func _process(delta):
	if current_state != GameState.PLAYING:
		return
	
	# Pause with Escape
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()
		return
	
	# Combo timeout
	if combo_count > 0:
		combo_timer += delta
		if combo_timer >= combo_timeout:
			combo_count = 0
	
	# Difficulty ramp over time
	difficulty_timer += delta
	if difficulty_timer >= difficulty_ramp_interval:
		difficulty_timer = 0.0
		_increase_difficulty()

func start_game():
	current_state = GameState.PLAYING
	score_manager.reset()
	typing_input.clear_all()
	level = 1
	combo_count = 0
	combo_timer = 0.0
	current_fall_speed = base_fall_speed
	difficulty_timer = 0.0
	word_spawner.fall_speed = current_fall_speed
	word_spawner.spawn_interval = base_spawn_interval
	hud.update_score(0)
	hud.update_health(score_manager.health)
	hud.update_typing("")
	hud.update_level(level)
	hud.hide_overlays()
	word_spawner.start_spawning()

func pause_game():
	current_state = GameState.PAUSED
	word_spawner.stop_spawning()
	hud.show_pause()
	get_tree().paused = true

func resume_game():
	get_tree().paused = false
	current_state = GameState.PLAYING
	word_spawner.start_spawning()
	hud.hide_overlays()

func game_over():
	current_state = GameState.GAME_OVER
	word_spawner.stop_spawning()
	typing_input.clear_all()
	
	# Big screen shake for dramatic game over
	vfx.shake_screen(15.0)
	
	# Add dramatic ending sound effect
	$GameOverSFX.play()
	
	# Explode all remaining words in red
	for word_node in get_tree().get_nodes_in_group("falling_words"):
		vfx.spawn_miss_effect(word_node.global_position)
		word_node.queue_free()
	
	# Show game over via HUD overlay (with slight delay for drama)
	var stats = score_manager.get_stats()
	stats["level"] = level
	
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(func(): hud.show_game_over(stats))

func restart_game():
	get_tree().paused = false
	for word_node in get_tree().get_nodes_in_group("falling_words"):
		word_node.queue_free()
	start_game()

func go_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _increase_difficulty():
	level += 1
	
	# Speed up spawn rate
	var new_interval = word_spawner.spawn_interval - 0.2
	word_spawner.spawn_interval = max(min_spawn_interval, new_interval)
	
	# Speed up word falling
	current_fall_speed += fall_speed_increment
	word_spawner.fall_speed = current_fall_speed
	
	# Update HUD
	hud.update_level(level)
	
	# Level up visual effect
	vfx.spawn_level_up_effect()
	vfx.shake_screen(4.0)

# --- Signal Callbacks ---

func _on_word_spawned(word_node: Node2D):
	typing_input.register_word(word_node)
	word_node.word_destroyed.connect(_on_word_destroyed)
	word_node.word_missed.connect(_on_word_missed)

func _on_word_destroyed(word_text: String, points: int):
	# Combo system
	combo_count += 1
	combo_timer = 0.0
	
	# Bonus points for combos
	var combo_multiplier = 1.0
	if combo_count >= 3:
		combo_multiplier = 1.5
	if combo_count >= 5:
		combo_multiplier = 2.0
	if combo_count >= 10:
		combo_multiplier = 3.0
	
	var final_points = int(points * combo_multiplier)
	score_manager.add_score(final_points)
	
	# VFX — find where the word was and spawn effects there
	# The word will have been freed, so we use last known position
	var effect_pos = _get_last_word_position(word_text)
	
	# Green explosion with size based on word length
	var particle_count = 12 + word_text.length() * 2
	var colors = [
		Color(0.0, 1.0, 0.5),    # green
		Color(0.2, 1.0, 0.8),    # cyan-green
		Color(0.0, 0.9, 0.3),    # bright green
	]
	var explosion_color = colors[randi() % colors.size()]
	
	if combo_count >= 5:
		explosion_color = Color(1.0, 0.85, 0.0)  # gold for big combos
		particle_count += 10
	
	vfx.spawn_explosion(effect_pos, explosion_color, particle_count)
	
	# Score popup
	var popup_text = "+" + str(final_points)
	if combo_count >= 3:
		popup_text += " x" + str(combo_count)
	vfx.spawn_score_popup(effect_pos, popup_text, explosion_color)
	
	# Small screen shake for satisfying feedback
	vfx.shake_screen(2.0 + word_text.length() * 0.3)
	
	# Positive sound effect
	$CompleteSFX.play()

func _on_word_missed(_word_text: String):
	combo_count = 0  # reset combo on miss
	score_manager.take_damage(1)
	
	# Red miss effect at the bottom of screen
	var screen_w = get_viewport_rect().size.x
	var screen_h = get_viewport_rect().size.y
	var miss_pos = Vector2(randf() * screen_w, screen_h - 20)
	vfx.spawn_miss_effect(miss_pos)

func _on_score_changed(new_score: int):
	hud.update_score(new_score)

func _on_health_changed(new_health: int):
	hud.update_health(new_health)
	
	# Flash red when taking damage
	if new_health <= 2:
		vfx.shake_screen(10.0)
	
	# Negative sound effect when game not over
	if new_health > 0:
		$DamageSFX.play()
	
func _on_health_depleted():
	game_over()

func _on_typed_text_changed(text: String):
	hud.update_typing(text)
	
	# Play type or click sound effect, except when resetting
	if text != "":
		$TypeSFX.play()

# --- Helpers ---

var _last_word_positions: Dictionary = {}

func _track_word_position(word_node: Node2D):
	## Called each frame to track word positions for VFX after they're freed
	if is_instance_valid(word_node):
		_last_word_positions[word_node.word_text] = word_node.global_position

func _get_last_word_position(word_text: String) -> Vector2:
	if word_text in _last_word_positions:
		var pos = _last_word_positions[word_text]
		_last_word_positions.erase(word_text)
		return pos
	return Vector2(400, 300)  # fallback center
