extends Node2D

const ASTEROID_SCENE = preload("res://scenes/asteroid.tscn")
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud: CanvasLayer = $HUD
@onready var earth: Earth = $earth 
@onready var TRASH_ASTEROID_SCENE: PackedScene = preload("res://scenes/thrash_asteroid.tscn")
@onready var RESOURCE_ASTEROID_SCENE: PackedScene = preload("res://scenes/resource_asteroid.tscn")

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	if earth:
		earth.health_changed.connect(_on_earth_health_changed)
		earth.earth_destroyed.connect(_on_game_over)

func _on_spawn_timer_timeout() -> void:
	spawn_asteroid_outside_screen()

func _on_earth_health_changed(new_health: float) -> void:
	if hud:
		hud.update_health_bar(new_health)

# What happens when Earth hits 0 HP
func _on_game_over() -> void:
	print("Game Over! Earth was destroyed.")
	spawn_timer.stop() # Stop generating threats
	
	# Optional simple game over action: Reload the scene after 3 seconds
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()

func spawn_asteroid_outside_screen() -> void:
	var screen_rect = get_viewport_rect()
	var center = screen_rect.size / 2
	var spawn_radius = max(screen_rect.size.x, screen_rect.size.y) * 0.7
	
	var random_angle = randf_range(0, 2 * PI)
	var spawn_position = center + Vector2.RIGHT.rotated(random_angle) * spawn_radius
	
	# Sorteia o tipo de asteroide que vai nascer
	var asteroid: Asteroid
	if randf() > 0.25:
		asteroid = TRASH_ASTEROID_SCENE.instantiate()
	else:
		asteroid = RESOURCE_ASTEROID_SCENE.instantiate()
		
	asteroid.global_position = spawn_position
	
	var target_position = center + Vector2(randf_range(-200, 200), randf_range(-200, 200))
	asteroid.movement_direction = (target_position - spawn_position).normalized()
	
	add_child(asteroid)

func asteroid_destroyed(points: int) -> void:
	print("pontos", points)
	if hud:
		hud.add_score(points)
