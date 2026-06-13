extends Node2D

const ASTEROID_SCENE = preload("res://scenes/asteroid.tscn")
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud: CanvasLayer = $HUD
@onready var earth: Earth = $earth 

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
	
	# Determine a spawn radius that safely sits completely outside visual edges
	var spawn_radius = max(screen_rect.size.x, screen_rect.size.y) * 0.7
	
	# 1. Pick a random angle along an imaginary compass perimeter
	var random_angle = randf_range(0, 2 * PI)
	var spawn_position = center + Vector2.RIGHT.rotated(random_angle) * spawn_radius
	
	# 2. Instance and locate the new threat
	var asteroid = ASTEROID_SCENE.instantiate()
	asteroid.global_position = spawn_position
	
	# 3. Point the asteroid roughly toward the center of the screen
	var target_position = center + Vector2(randf_range(-100, 100), randf_range(-100, 100))
	asteroid.movement_direction = (target_position - spawn_position).normalized()
	
	add_child(asteroid)

func asteroid_destroyed(points: int) -> void:
	if hud:
		hud.add_score(points)
