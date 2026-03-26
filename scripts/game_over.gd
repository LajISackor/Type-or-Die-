extends Control
## Game Over Screen — Shows final stats and replay options.
## Assigned to: Mesa

func _ready():
	# TODO: Connect button signals
	# TODO: Display final score and stats passed from game_manager
	pass

func show_results(stats: Dictionary):
	# TODO: Update labels with stats
	# $ScoreValue.text = str(stats.score)
	# $AccuracyValue.text = str(snapped(stats.accuracy, 0.1)) + "%"
	# $WordsTyped.text = str(stats.words_typed)
	pass

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
