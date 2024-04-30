extends Node3D
class_name Weapon

# References
var weapon_manager = null
var player = null
var animation_player

# Weapon states
var is_equipped = false
var is_firing = false
var is_reloading = false

# Weapon parameters
@export var weapon_name = "Weapon"

# Optional
@export var equip_speed = 1.0
@export var deequip_speed = 1.0



# Equip/DeEquip cycle
func equip():
	animation_player.play("Equip", -1.0, equip_speed)
	update_ammo()

func deequip():
	animation_player.play ("Deequip", -1.0, deequip_speed)
	
func is_equip_finished():
	if is_equipped:
		return true
	else:
		return false

func is_unequip_finished():
	if is_equipped:
		return false
	else:
		return true
		
# Update Ammo
func update_ammo(action = "Refresh"):
	
	var weapon_data = {
		"Name" : weapon_name
	}
	
	#weapon_manager.update_hud(weapon_data)
