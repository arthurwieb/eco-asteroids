class_name Asteroid extends Area2D

# We define states for Size using an Enumeration
enum Size { LARGE, MEDIUM, SMALL }
@export var current_size: Size = Size.LARGE
const EXPLOSION_SCENE = preload("res://scenes/explosion_particles.tscn")
var speed: float = 150.0
var movement_direction: Vector2 = Vector2.RIGHT
var rotation_speed: float = 1.0
#var score_value: int = 10

func _ready() -> void:
	# Change visual scale and speed parameters based on size tier
	match current_size:
		Size.LARGE:
			scale = Vector2(2.0, 2.0)
			speed = randf_range(80.0, 120.0)
			#score_value = 10
		Size.MEDIUM:
			scale = Vector2(1.2, 1.2)
			speed = randf_range(130.0, 180.0)
			#score_value = 20
		Size.SMALL:
			scale = Vector2(0.6, 0.6)
			speed = randf_range(200.0, 250.0)
			#score_value = 30
			
	# Pick a random spin speed
	rotation_speed = randf_range(-2.0, 2.0)
	
	# Connect hit detection dynamically to avoid editor setup mistakes
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	# Continuous movement and rolling visual spin
	global_position += movement_direction * speed * delta
	rotation += rotation_speed * delta

func _on_area_entered(area: Area2D) -> void:
	#aqui somente a Bullet pode interferir
	#essa função quer saber se a bullet entrou na area e vai destruir o asteroid
	if not area is Bullet:
		return
	#if get_parent().has_method("asteroid_destroyed"):
		#get_parent().asteroid_destroyed(score_value)
	apply_score()
	area.queue_free()
	split_and_destroy()

func split_and_destroy() -> void:
	# If we are not a small asteroid, spawn two downscaled counterparts
	var explosion = EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	match current_size:
		Size.LARGE:
			explosion.amount = 15          # Muito mais pedaços
			explosion.scale = Vector2(1.5, 1.5) # Explosão gigante
		Size.MEDIUM:
			explosion.amount = 8
			explosion.scale = Vector2(0.5, 0.5)
		Size.SMALL:
			explosion.amount = 2          # Poucos pedaços
			explosion.scale = Vector2(0.2, 0.2) # Explosão pequenininha
	get_parent().add_child(explosion)
	
	if current_size != Size.SMALL:
		var next_size = Size.MEDIUM if current_size == Size.LARGE else Size.SMALL
		
		for i in range(2):
			var new_asteroid = duplicate() # Copy ourselves
			new_asteroid.current_size = next_size
			
			# Give split parts clean, divergent angles (+/- 45 degrees relative to original)
			var angle_offset = 0.785 if i == 0 else -0.785 
			new_asteroid.movement_direction = movement_direction.rotated(angle_offset)
			
			# Add child back into the running scene context
			get_parent().call_deferred("add_child", new_asteroid)
			new_asteroid.global_position = global_position
			
	queue_free()

func apply_score():
	print("está merda está sendo chamada")
	pass
