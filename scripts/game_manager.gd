extends Node2D
## Game Manager — Controls the main game loop and state.
## Assigned to: Laji (COMPLETE)

enum GameState { PLAYING, PAUSED, GAME_OVER }

var current_state: GameState = GameState.PLAYING

# Difficulty settings
var base_spawn_interval: float = 2.5
var min_spawn_interval: float = 0.6
var difficulty_timer: float = 0.0
var difficulty_ramp_interval: float = 15.0  # ramp up every 15 seconds
var base_fall_speed: float = 60.0
var current_fall_speed: float = 60.0
var fall_speed_increment: float = 8.0
var level: int = 1

@onready var word_spawner: Node = $WordSpawner
@onready var typing_input: Node = $TypingInput
@onready var score_manager: Node = $ScoreManager
@onready var hud: CanvasLayer = $HUD

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
	
	# Remove all remaining falling words
	for word_node in get_tree().get_nodes_in_group("falling_words"):
		word_node.queue_free()
	
	# Show game over via HUD overlay
	var stats = score_manager.get_stats()
	stats["level"] = level
	hud.show_game_over(stats)

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

# --- Signal Callbacks ---

func _on_word_spawned(word_node: Node2D):
	typing_input.register_word(word_node)
	word_node.word_destroyed.connect(_on_word_destroyed)
	word_node.word_missed.connect(_on_word_missed)

func _on_word_destroyed(word_text: String, points: int):
	score_manager.add_score(points)

func _on_word_missed(word_text: String):
	score_manager.take_damage(1)

func _on_score_changed(new_score: int):
	hud.update_score(new_score)

func _on_health_changed(new_health: int):
	hud.update_health(new_health)

func _on_health_depleted():
	game_over()

func _on_typed_text_changed(text: String):
	hud.update_typing(text)
