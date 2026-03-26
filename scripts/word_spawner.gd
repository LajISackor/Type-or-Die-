extends Node
## Word Spawner — Loads words and spawns them at intervals.
## Assigned to: Laji

var word_list: Array[String] = []
var falling_word_scene: PackedScene  # TODO: preload("res://scenes/falling_word.tscn")
var spawn_timer: Timer

func _ready():
	_load_words("res://word_lists/default.txt")
	_setup_timer()

func _load_words(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var word = file.get_line().strip_edges()
			if word.length() > 0:
				word_list.append(word)
		file.close()
	print("Loaded ", word_list.size(), " words")

func _setup_timer():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 2.5  # seconds between spawns
	spawn_timer.timeout.connect(_spawn_word)
	add_child(spawn_timer)
	spawn_timer.start()

func _spawn_word():
	if word_list.is_empty():
		return
	var word = word_list[randi() % word_list.size()]
	# TODO: Instance falling_word_scene
	# - Set the word text
	# - Set random X position within screen bounds
	# - Add as child to the game scene
	print("SPAWN: ", word)  # Placeholder

func stop_spawning():
	spawn_timer.stop()

func increase_difficulty():
	# TODO: Decrease spawn_timer.wait_time over time
	spawn_timer.wait_time = max(0.5, spawn_timer.wait_time - 0.1)
