class_name Earth extends Area2D

signal health_changed(new_health: float)
signal earth_destroyed

@export var max_health: float = 100.0
var current_health: float = 100.0

func _ready() -> void:
	current_health = max_health
	print(current_health)
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Asteroid) -> void:
# 1. Instantly turn off monitoring so no other frames/asteroids register right now
	print("algo entrou na area da terra")
	
	set_deferred('monitoring', false)
	
	# 2. Apply your damage and delete the threat
	take_damage(20.0)
	area.queue_free()
	
	# 3. Wait exactly one physics frame for the engine to safely delete the asteroid
	await get_tree().physics_frame
	
	# 4. Turn the collision listeners back on for the next asteroid
	set_deferred('monitoring', true)

func take_damage(amount: float) -> void:
	print('tomando dan1o')
	current_health -= amount
	current_health = clamp(current_health, 0.0, max_health)
	
	health_changed.emit(current_health)
	print(current_health)
	if current_health <= 0.0:
		earth_destroyed.emit()
		queue_free() 
