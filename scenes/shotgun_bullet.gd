class_name ShotgunBullet
extends Bullet

func _init() -> void:
	speed = 600.0
	cooldown = 0.9

func spawn_pattern(scene_root: Node, spawn_pos: Vector2, ship_rotation: float, player: CharacterBody2D) -> void:
	var bonus_pellets = player.shotgun_pellet_bonus if "shotgun_pellet_bonus" in player else 0
	var total_pellets = 3 + bonus_pellets
	var spread_angle = deg_to_rad(20.0)
	for i in range(total_pellets):
		var pellet = duplicate() as Area2D
		scene_root.add_child(pellet)
		
		# Projétil 0: Inclina para a esquerda | Projétil 1: Vai reto | Projétil 2: Inclina para a direita
		var offset_factor = i - (total_pellets - 1) / 2.0
		var offset_angle = offset_factor * spread_angle
		var final_angle = ship_rotation + offset_angle
		
		pellet.global_position = spawn_pos
		pellet.rotation = final_angle
		pellet.direction = Vector2.RIGHT.rotated(final_angle)
