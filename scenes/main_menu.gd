extends Control

@onready var last_score_label: Label = $VBoxContainer/LastScore
@onready var start_button: Button = $VBoxContainer/Start

func _ready() -> void:
	get_tree().paused = false
	
	last_score_label.text = "ÚLTIMA PONTUAÇÃO: " + str(Global.last_score)
	
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
