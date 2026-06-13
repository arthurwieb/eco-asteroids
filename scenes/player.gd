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

func shoot_bullet() -> void:
	var b = BULLET_SCENE.instantiate()
	var weapon_cooldown = b.cooldown
	weapon_timer.start(0.2)

	get_tree().current_scene.add_child(b)
	b.global_position = muzzle.global_position
	b.rotation = rotation
	b.direction = Vector2.RIGHT.rotated(rotation)
