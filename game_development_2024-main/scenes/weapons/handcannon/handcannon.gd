extends Weapon


func _ready():
	animation_player = $animation_player
	$animation_player.call("animation_finished", self, "on_animation_finish")
	

func on_animation_finished(anim_name):
	on_animation_finished(anim_name)
