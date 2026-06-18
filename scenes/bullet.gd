class_name Bullet extends Area2D

@export var speed: float = 600.0
@export var cooldown: float = 0.25

var direction: Vector2 = Vector2.RIGHT
var laser_level: int = 1

func _physics_process(delta: float) -> void:
	# O efeito homing só liga a partir do nível 2
	if laser_level > 1:
		var target = find_closest_trash()
		if target and is_instance_valid(target):
			var target_dir = (target.global_position - global_position).normalized()
			
			
			var turn_speed = (laser_level - 1) * 0.4
			direction = direction.move_toward(target_dir, turn_speed * delta).normalized()
			rotation = direction.angle()

	global_position += direction * speed * delta	

func find_closest_trash() -> Node2D:
	# Coleta apenas os nós que se registraram no grupo "trash"
	var targets = get_tree().get_nodes_in_group("trash")
	var closest: Node2D = null
	var min_dist = INF
	
	for target in targets:
		if is_instance_valid(target):
			var dist = global_position.distance_to(target.global_position)
			if dist < min_dist:
				min_dist = dist
				closest = target
	return closest

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
