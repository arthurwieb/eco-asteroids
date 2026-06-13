class_name Bullet extends Area2D

@export var speed: float = 500.0
@export var cooldown: float = 0.2
var direction: Vector2 = Vector2.UP

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
