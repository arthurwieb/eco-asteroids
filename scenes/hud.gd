extends CanvasLayer
@onready var score_label: Label = $ScorePanel/ScoreLabel
@onready var health_bar: ProgressBar = $ScorePanel/HealthBar
var current_score: int = 0
func _ready() -> void:
	update_score_text()

func add_score(amount: int) -> void:
	current_score += amount
	update_score_text()

func update_score_text() -> void:
	score_label.text = "PONTOS: " + str(current_score)

func update_health_bar(new_health: float) -> void:
	health_bar.value = new_health
