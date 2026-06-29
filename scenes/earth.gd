class_name Earth extends Area2D

signal health_changed(new_health: float)
signal earth_destroyed

@export var max_health: float = 100.0
var current_health: float = 100.0

func _ready() -> void:
	current_health = max_health
	print(current_health)
	area_entered.connect(_on_area_entered)

func _on_area_entered(asteroid: Asteroid) -> void:
	print("algo entrou na area da terra")
	
	set_deferred('monitoring', false)
	
	take_damage(5.0, asteroid)
	asteroid.queue_free()
	
	await get_tree().physics_frame
	
	set_deferred('monitoring', true)

func take_damage(amount: float, asteroid: Asteroid) -> void:
	if asteroid is TrashAsteroid:
		current_health -= amount
	else:
		current_health += amount * 2 #facilitar o jogo
	
	current_health = clamp(current_health, 0.0, max_health)
	
	health_changed.emit(current_health)
	print(current_health)
	if current_health <= 0.0:
		earth_destroyed.emit()
		queue_free() 
