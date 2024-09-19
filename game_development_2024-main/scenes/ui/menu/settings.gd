extends Control

func _on_exit_pressed():
	hide()

func _on_option_button_item_selected(index):
	Global.light = index
	print(Global.light)



func _on_check_box_pressed():
	Global.fog = !Global.fog
