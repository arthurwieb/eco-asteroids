extends Node2D

const ASTEROID_SCENE = preload("res://scenes/asteroid.tscn")
@onready var upgrade_screen: CanvasLayer = $UpgradeScreen
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud: CanvasLayer = $HUD
@onready var earth: Earth = $earth 
@onready var TRASH_ASTEROID_SCENE: PackedScene = preload("res://scenes/thrash_asteroid.tscn")
@onready var RESOURCE_ASTEROID_SCENE: PackedScene = preload("res://scenes/resource_asteroid.tscn")
@onready var player: CharacterBody2D = $Player
var current_stage: int = 1
var stage_duration: float = 2.0
@onready var stage_timer: Timer = $StageTimer
var last_printed_time: int = -1

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	if earth:
		earth.health_changed.connect(_on_earth_health_changed)
		earth.earth_destroyed.connect(_on_game_over)
	
	if upgrade_screen:
		upgrade_screen.hide() # Começa escondida
		
		# Conecta os sinais dos botões internos diretamente às funções deste script
		var btn_laser = upgrade_screen.get_node_or_null("Control/BtnContainer/BtnSingleshot")
		var btn_shotgun = upgrade_screen.get_node_or_null("Control/BtnContainer/BtnShotgun")
		
		if btn_laser:
			btn_laser.pressed.connect(_on_laser_upgrade_pressed)
		if btn_shotgun:
			btn_shotgun.pressed.connect(_on_shotgun_upgrade_pressed)
		
	stage_timer = Timer.new()
	stage_timer.wait_time = stage_duration
	stage_timer.one_shot = true
	stage_timer.timeout.connect(_on_stage_timeout)
	add_child(stage_timer)
	
	start_stage()

func _process(delta: float) -> void:
	var current_second = ceil(stage_timer.time_left)
	if current_second != last_printed_time and stage_timer.time_left > 0:
		last_printed_time = current_second
		print("Tempo restante do estágio: ", current_second, "s")
	
	if hud and hud.has_method("update_timer_text"):
		hud.update_timer_text(stage_timer.time_left)

func _on_stage_timeout() -> void:
	spawn_timer.stop()
	print("O tempo acabou! Estágio ", current_stage, " concluído.")
	
	# Vitória Absoluta (Passou da fase 10)
	if current_stage >= 10:
		print("Vitória Absoluta! A Terra foi totalmente salva!")
		if hud:
			Global.last_score = hud.current_score
			
		await get_tree().create_timer(2.0).timeout
		# Altere aqui para ir para a tela de Game Over/Resultados
		get_tree().change_scene_to_file("res://scenes/game_over.tscn") 
		return
		
	current_stage += 1
	get_tree().paused = true
	if upgrade_screen:
		upgrade_screen.show()

func start_stage() -> void:
	print("Iniciando Estágio: ", current_stage)
	if hud and hud.has_method("update_stage_text"):
		hud.update_stage_text(current_stage)
		
	# DIFICULDADE PROCEDURAL: Reduz o tempo entre spawns conforme o estágio avança
	spawn_timer.wait_time = max(0.35, 1.8 - (current_stage * 0.15))
	spawn_timer.start()
	stage_timer.start()
	
func _on_spawn_timer_timeout() -> void:
	spawn_asteroid_outside_screen()

func _on_earth_health_changed(new_health: float) -> void:
	if hud:
		hud.update_health_bar(new_health)

func _on_game_over() -> void:
	print("Game Over! Earth was destroyed.")
	spawn_timer.stop()
	stage_timer.stop()
	
	if hud:
		Global.last_score = hud.current_score
	
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

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
		
func _on_laser_upgrade_pressed() -> void:
	if player and "laser_level" in player:
		player.laser_level += 1
		print("Upgrade Aplicado: Nível do Homing do Laser aumentado para ", player.laser_level)
	resume_after_upgrade()

func _on_shotgun_upgrade_pressed() -> void:
	if player and "shotgun_pellet_bonus" in player:
		player.shotgun_pellet_bonus += 1
		print("Upgrade Aplicado: +1 Projétil adicionado na Shotgun!")
	resume_after_upgrade()

func resume_after_upgrade() -> void:
	if upgrade_screen:
		upgrade_screen.hide() # Esconde o menu novamente
	get_tree().paused = false # Descongela a física do jogo
	start_stage() # Inicia o próximo round de 1 minuto
