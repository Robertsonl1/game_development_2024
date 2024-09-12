extends Control

func _on_exit_pressed():
	hide()

func _on_option_button_item_selected(index):
	Global.light = index
	print(Global.light)
