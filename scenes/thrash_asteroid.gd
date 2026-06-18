class_name TrashAsteroid
extends Asteroid

@export var score_value: int = 10

func _ready() -> void:
	super._ready() # Executa a escala e rotação do pai (asteroid.gd)
	add_to_group("trash") # Registra no grupo para o tiro Homing te encontrar

func apply_score() -> void:
	if get_parent().has_method("asteroid_destroyed"):
		get_parent().asteroid_destroyed(score_value)
