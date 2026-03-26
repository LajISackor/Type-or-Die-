extends Node
## Score & Health Manager — Tracks points and player health.
## Assigned to: Mesa

signal score_changed(new_score: int)
signal health_changed(new_health: int)
signal health_depleted()

var score: int = 0
var health: int = 5
var max_health: int = 5
var words_typed: int = 0
var words_missed: int = 0

func _ready():
	reset()

func reset():
	score = 0
	health = max_health
	words_typed = 0
	words_missed = 0

func add_score(points: int):
	score += points
	words_typed += 1
	score_changed.emit(score)

func take_damage(amount: int = 1):
	health -= amount
	words_missed += 1
	health_changed.emit(health)
	if health <= 0:
		health = 0
		health_depleted.emit()

func get_accuracy() -> float:
	var total = words_typed + words_missed
	if total == 0:
		return 100.0
	return (float(words_typed) / float(total)) * 100.0

func get_stats() -> Dictionary:
	return {
		"score": score,
		"words_typed": words_typed,
		"words_missed": words_missed,
		"accuracy": get_accuracy()
	}
