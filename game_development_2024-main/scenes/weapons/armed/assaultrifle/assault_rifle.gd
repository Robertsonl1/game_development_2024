extends Armed


func _ready():
	player.connect("animation_finish", on_animation_finish)


func on_animation_finish(anim_name):
	on_animation_finish(anim_name)
