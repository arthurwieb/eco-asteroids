extends CharacterBody2D

@export var rotation_speed: float = 4.0
@export var acceleration: float = 300.0
@export var max_speed: float = 400.0
@export var friction: float = 100.0

@export var BULLET_SCENE = preload("res://scenes/bullet.tscn")
@onready var muzzle: Marker2D = $Muzzle
@onready var thruster_particles: CPUParticles2D = $ThrusterParticle
@onready var thruster_particles2: CPUParticles2D = $ThrusterParticle2
@onready var weapon_timer: Timer = $WeaponTimer

@export var weapon_inventory: Array[PackedScene] = []
var current_weapon_idx: int = 0

func _physics_process(delta: float) -> void:
	var rotation_dir = Input.get_axis("turn_left", "turn_right")
	rotation += rotation_dir * rotation_speed * delta

	if Input.is_action_pressed("move_forward"):
		var forward_vector = Vector2.RIGHT.rotated(rotation)
		velocity += forward_vector * acceleration * delta
		velocity = velocity.limit_length(max_speed)
		thruster_particles.emitting = true
		thruster_particles2.emitting = true
	else:
		thruster_particles.emitting = false
		thruster_particles2.emitting = false
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if Input.is_action_just_pressed("shoot") and weapon_timer.is_stopped():
		shoot_bullet()
	
	if Input.is_action_just_pressed("change_weapon"):
		cycle_weapon()

func cycle_weapon() -> void:
	if weapon_inventory.is_empty():
		return
	current_weapon_idx = (current_weapon_idx + 1) % weapon_inventory.size()
	print("Arma alterada para o slot: ", current_weapon_idx)

func shoot_bullet() -> void:
	if weapon_inventory.is_empty() or not weapon_inventory[current_weapon_idx]:
			return

	var active_weapon_scene = weapon_inventory[current_weapon_idx]
	var b = active_weapon_scene.instantiate()

	var weapon_cooldown = b.cooldown
	weapon_timer.start(weapon_cooldown)

	if b.has_method("spawn_pattern"):
		b.spawn_pattern(get_tree().current_scene, muzzle.global_position, rotation)
		b.queue_free()
	else:
		get_tree().current_scene.add_child(b)
		b.global_position = muzzle.global_position
		b.rotation = rotation
		b.direction = Vector2.RIGHT.rotated(rotation)
