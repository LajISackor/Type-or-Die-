extends Control
## Main Menu — Title screen with start and quit buttons.
## Assigned to: Joel

func _ready():
	# TODO: Connect button signals
	# $StartButton.pressed.connect(_on_start_pressed)
	# $QuitButton.pressed.connect(_on_quit_pressed)
	pass

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	get_tree().quit()
