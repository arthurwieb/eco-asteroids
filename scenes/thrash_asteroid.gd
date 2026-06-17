class_name ThrashAsteroid
extends Asteroid

@export var score: int = 10

func apply_score() -> void:
	print("chamei apply score", get_parent())
	if get_parent().has_method("asteroid_destroyed"):
		print("tem method")
		get_parent().asteroid_destroyed(score)
