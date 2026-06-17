class_name ResourceAsteroid
extends Asteroid

@export var score_penalty: int = 15

# Sobrescreve apenas a aplicação da penalidade (pontos negativos)
func apply_score() -> void:
	print("chamei apply score", get_parent())
	if get_parent().has_method("asteroid_destroyed"):
		get_parent().asteroid_destroyed(-score_penalty)
