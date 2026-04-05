extends Control
## Game Over Screen — Standalone version if needed.
## Assigned to: Mesa
## STATUS: Currently the HUD handles game over as an overlay.
## Mesa can convert this to a standalone scene if preferred.

func _ready():
	pass

func show_results(stats: Dictionary):
	pass

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
