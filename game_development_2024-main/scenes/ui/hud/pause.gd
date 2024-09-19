extends Control


func _on_return_pressed():
	hide()
	get_tree().paused = false


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu.tscn")

