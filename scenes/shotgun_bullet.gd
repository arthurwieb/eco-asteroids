class_name ShotgunBullet
extends Bullet

func _init() -> void:
	speed = 600.0
	cooldown = 0.5

func spawn_pattern(scene_root: Node, spawn_pos: Vector2, ship_rotation: float) -> void:
	var total_pellets = 3
	var spread_angle = deg_to_rad(20.0)
	for i in range(total_pellets):
		var pellet = duplicate() as Area2D
		scene_root.add_child(pellet)
		
		# Projétil 0: Inclina para a esquerda | Projétil 1: Vai reto | Projétil 2: Inclina para a direita
		var offset_angle = (i - 1) * spread_angle
		var final_angle = ship_rotation + offset_angle
		
		pellet.global_position = spawn_pos
		pellet.rotation = final_angle
		pellet.direction = Vector2.RIGHT.rotated(final_angle)
