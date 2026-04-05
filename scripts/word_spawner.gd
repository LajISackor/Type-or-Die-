extends Node
## Word Spawner — Loads words, spawns them with visual flair.
## Assigned to: Laji (COMPLETE)

signal word_spawned(word_node: Node2D)

var word_list: Array[String] = []
var easy_words: Array[String] = []
var medium_words: Array[String] = []
var hard_words: Array[String] = []
var falling_word_scene: PackedScene = preload("res://scenes/falling_word.tscn")
var spawn_timer: Timer
var spawn_interval: float = 2.5
var fall_speed: float = 60.0
var screen_width: float = 800.0
var margin: float = 100.0

# Track active words to avoid duplicates
var active_word_texts: Array[String] = []

# Difficulty-based word selection
var hard_word_chance: float = 0.0  # increases over time

func _ready():
	screen_width = get_viewport_rect().size.x
	_load_words("res://word_lists/default.txt")
	_setup_timer()

func _load_words(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var word = file.get_line().strip_edges().to_lower()
			if word.length() > 0:
				word_list.append(word)
				# Sort into difficulty buckets
				if word.length() <= 4:
					easy_words.append(word)
				elif word.length() <= 6:
					medium_words.append(word)
				else:
					hard_words.append(word)
		file.close()
	
	if word_list.is_empty():
		word_list = ["type", "code", "game", "fire", "hero", "jump", "play",
					 "word", "fast", "dark", "moon", "star", "bold", "rush"]
		easy_words = word_list.duplicate()
	
	print("WordSpawner: Loaded ", word_list.size(), " words (",
		  easy_words.size(), " easy, ",
		  medium_words.size(), " medium, ",
		  hard_words.size(), " hard)")

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
	_spawn_word()

func stop_spawning():
	spawn_timer.stop()

func _spawn_word():
	if word_list.is_empty():
		return
	
	spawn_timer.wait_time = spawn_interval
	
	var word = _pick_word_by_difficulty()
	if word.is_empty():
		return
	
	# Instance the falling word
	var word_node = falling_word_scene.instantiate()
	word_node.word_text = word
	word_node.fall_speed = fall_speed
	
	# Smart X positioning — avoid overlapping with existing words
	var x_pos = _find_safe_x_position()
	word_node.position = Vector2(x_pos, -30)
	
	# Spawn with a subtle scale-in animation
	word_node.scale = Vector2(0.3, 0.3)
	var tween = get_tree().create_tween()
	tween.tween_property(word_node, "scale", Vector2(1.0, 1.0), 0.25)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Slight fade in
	word_node.modulate.a = 0.0
	tween.parallel().tween_property(word_node, "modulate:a", 1.0, 0.2)
	
	get_parent().add_child(word_node)
	
	# Track it
	active_word_texts.append(word)
	word_node.tree_exiting.connect(_on_word_removed.bind(word))
	
	# Track position for VFX manager
	word_node.tree_exiting.connect(func():
		var gm = get_parent()
		if gm.has_method("_track_word_position"):
			gm._track_word_position(word_node)
	)
	# Also track position each frame via game manager
	_start_position_tracking(word_node)
	
	word_spawned.emit(word_node)

func _pick_word_by_difficulty() -> String:
	var roll = randf()
	var pool: Array[String]
	
	# Gradually introduce harder words
	if roll < hard_word_chance and hard_words.size() > 0:
		pool = hard_words
	elif roll < hard_word_chance + 0.3 and medium_words.size() > 0:
		pool = medium_words
	else:
		pool = easy_words if easy_words.size() > 0 else word_list
	
	# Try to pick a unique word
	var attempts = 0
	while attempts < 20:
		var word = pool[randi() % pool.size()]
		if word not in active_word_texts:
			return word
		attempts += 1
	
	return pool[randi() % pool.size()]

func _find_safe_x_position() -> float:
	## Try to avoid placing words too close to existing ones
	var best_x = randf_range(margin, screen_width - margin)
	var best_min_dist = 0.0
	
	# Try several random positions and pick the one most spread out
	for _attempt in range(8):
		var test_x = randf_range(margin, screen_width - margin)
		var min_dist = 999.0
		
		for word_node in get_tree().get_nodes_in_group("falling_words"):
			if is_instance_valid(word_node) and word_node.position.y < 100:
				var dist = abs(test_x - word_node.position.x)
				min_dist = min(min_dist, dist)
		
		if min_dist > best_min_dist:
			best_min_dist = min_dist
			best_x = test_x
	
	return best_x

func increase_hard_word_chance(amount: float = 0.05):
	hard_word_chance = min(0.5, hard_word_chance + amount)

func _on_word_removed(word: String):
	active_word_texts.erase(word)

func _start_position_tracking(word_node: Node2D):
	## Periodically update the game manager with this word's position
	## so VFX can be spawned at the right spot after the word is freed
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = false
	timer.timeout.connect(func():
		if is_instance_valid(word_node):
			var gm = get_parent()
			if gm and "_last_word_positions" in gm:
				gm._last_word_positions[word_node.word_text] = word_node.global_position
		else:
			timer.queue_free()
	)
	word_node.add_child(timer)
	timer.start()
