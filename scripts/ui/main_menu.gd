extends Node2D

func _ready() -> void:
	$CanvasLayer/Control/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$CanvasLayer/Control/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	GameManager.start_new_run()
	get_tree().change_scene_to_file("res://scenes/battle/battle_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
