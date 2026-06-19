extends CanvasLayer

@onready var score_label: Label = $ScorePanel/ScoreLabel
@onready var health_bar: ProgressBar = $ScorePanel/HealthBar

var current_score: int = 0

func _ready() -> void:
	update_score_text()
	update_stage_text(1)

func add_score(amount: int) -> void:
	current_score += amount
	update_score_text()

func update_score_text() -> void:
	score_label.text = "PONTOS: " + str(current_score)

func update_health_bar(new_health: float) -> void:
	health_bar.value = new_health

# Atualiza dinamicamente o texto do estágio se o nó visual existir
func update_stage_text(stage: int) -> void:
	var stage_label = get_node_or_null("ScorePanel/StageLabel")
	if stage_label:
		stage_label.text = "ESTÁGIO: " + str(stage)

# Atualiza dinamicamente o contador regressivo na tela
func update_timer_text(time_left: float) -> void:
	var timer_label = get_node_or_null("ScorePanel/TimerLabel")
	if timer_label:
		# Usa o ceil() para arredondar para cima (ex: 59.1s vira 60s na tela)
		timer_label.text = "DEFENDA A TERRA. TEMPO RESTANTE: " + str(ceil(time_left)) + "s"
