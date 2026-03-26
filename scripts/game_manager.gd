extends Node2D
## Game Manager — Controls the main game loop and state.
## Assigned to: Laji

enum GameState { PLAYING, PAUSED, GAME_OVER }

var current_state: GameState = GameState.PLAYING

@onready var word_spawner = $WordSpawner  # TODO: Add WordSpawner node
@onready var hud = $HUD                  # TODO: Add HUD node

func _ready():
	# TODO: Initialize game
	# - Reset score and health
	# - Start the word spawner
	# - Connect signals from score_manager (health_depleted → game_over)
	pass

func _process(_delta):
	if current_state != GameState.PLAYING:
		return
	# TODO: Check for pause input (Escape key)

func start_game():
	current_state = GameState.PLAYING
	# TODO: Reset everything and begin spawning words

func pause_game():
	current_state = GameState.PAUSED
	get_tree().paused = true

func resume_game():
	current_state = GameState.PLAYING
	get_tree().paused = false

func game_over():
	current_state = GameState.GAME_OVER
	# TODO: Stop spawning, show game over screen
	# get_tree().change_scene_to_file("res://scenes/game_over.tscn")
