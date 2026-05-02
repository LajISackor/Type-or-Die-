extends Node

@onready var game_over_sfx: AudioStreamPlayer = $GameOverSFX
@onready var opening_song: AudioStreamPlayer = $OpeningSong

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_game_over():
	game_over_sfx.play()
	
func play_opening():
	opening_song.play()
	
func stop_opening():
	opening_song.stop()

		
