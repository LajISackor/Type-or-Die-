extends CanvasLayer
## HUD — Displays score, health, and current typed text.
## Assigned to: Joel

@onready var score_label = $ScoreLabel      # TODO: Add Label node
@onready var health_label = $HealthLabel    # TODO: Add Label node
@onready var typing_label = $TypingLabel    # TODO: Add Label node at bottom

func update_score(value: int):
	score_label.text = "Score: " + str(value)

func update_health(value: int):
	# TODO: Could use hearts/icons instead of number
	health_label.text = "HP: " + str(value)

func update_typing(text: String):
	typing_label.text = text
