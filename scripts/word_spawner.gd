extends Node
## Word Spawner — Loads word list and spawns falling words at timed intervals.
## Assigned to: Laji (COMPLETE)

signal word_spawned(word_node: Node2D)

var word_list: Array[String] = []
var falling_word_scene: PackedScene = preload("res://scenes/falling_word.tscn")
var spawn_timer: Timer
var spawn_interval: float = 2.5
var fall_speed: float = 60.0
var screen_width: float = 800.0
var margin: float = 80.0  # keep words away from screen edges

# Track active words to avoid duplicate spawns
var active_word_texts: Array[String] = []

func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	_load_words("res://word_lists/default.txt")
	_setup_timer()

func _load_words(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var word = file.get_line().strip_edges().to_lower()
			if word.length() > 0:
				word_list.append(word)
		file.close()
	
	if word_list.is_empty():
		# Fallback words in case file fails to load
		word_list = ["type", "code", "game", "fire", "hero", "jump", "play",
					 "word", "fast", "dark", "moon", "star", "bold", "rush"]
	
	print("WordSpawner: Loaded ", word_list.size(), " words")

func _setup_timer():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_spawn_word)
	spawn_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(spawn_timer)

func start_spawning():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()
	# Spawn one word immediately so the game doesn't feel empty
	_spawn_word()

func stop_spawning():
	spawn_timer.stop()

func _spawn_word():
	if word_list.is_empty():
		return
	
	# Update timer interval in case difficulty changed it
	spawn_timer.wait_time = spawn_interval
	
	# Pick a random word that isn't already on screen
	var word = _pick_unique_word()
	if word.is_empty():
		return
	
	# Instance the falling word scene
	var word_node = falling_word_scene.instantiate()
	word_node.word_text = word
	word_node.fall_speed = fall_speed
	
	# Random X position within safe margins
	var x_pos = randf_range(margin, screen_width - margin)
	word_node.position = Vector2(x_pos, -20)  # start just above the screen
	
	# Add to the game scene (parent of this spawner)
	get_parent().add_child(word_node)
	
	# Track it
	active_word_texts.append(word)
	word_node.tree_exiting.connect(_on_word_removed.bind(word))
	
	# Notify game manager
	word_spawned.emit(word_node)

func _pick_unique_word() -> String:
	# Try to find a word not currently on screen
	var attempts = 0
	var max_attempts = 20
	while attempts < max_attempts:
		var word = word_list[randi() % word_list.size()]
		if word not in active_word_texts:
			return word
		attempts += 1
	
	# If all else fails, allow duplicates
	return word_list[randi() % word_list.size()]

func _on_word_removed(word: String):
	active_word_texts.erase(word)
