extends Control

@onready var settings: Control = $Settings

func _ready():
	settings.hide()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	queue_free()

func _on_exit_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	settings.show()
