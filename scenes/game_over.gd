extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton

func _ready() -> void:
	# Garante que o jogo seja despausado ao carregar esta tela
	get_tree().paused = false
	
	# Pega a pontuação final que o world.gd salvou no Global
	score_label.text = "PONTUAÇÃO OBTIDA: " + str(Global.last_score)
	
	restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
