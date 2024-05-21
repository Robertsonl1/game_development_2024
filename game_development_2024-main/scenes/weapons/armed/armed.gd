extends Weapon
class_name Armed

# References
var animation_player

# Weapon States
var is_firing = false
var is_reloading = false

# Weapon Parameters
@export var damage = 10
@export var firrate = 1.0

@export var magammo = 15
@export var reserveammo = 30
@onready var magsize = magammo


# Effects
@export var impact_effect: PackedScene


# Optional
@export var equip_speed = 1.0
@export var unequip_speed = 1.0



# Equip/Unequip Cycle
func equip():
	animation_player.play("Equip", -1.0, equip_speed)

func unequip():
	animation_player.play("Unequip", -1.0, unequip_speed)

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


# Show/Hide Weapon
func show_weapon():
	visible = true

func hide_weapon():
	visible = false

# Animation Finished
func on_animation_finish(anim_name):
	match anim_name:
		"Unequip":
			is_equipped = false
		"Equip":
			is_equipped = true

# Update Ammo
func update_ammo(_action = "Refresh", additionalammo = 0):
	
	match action:
		"consume":
			magammo -= 1
			
		"reload":
			var ammo_needed = magsize - magammo
			
			if reserveammo > ammo_needed:
				magammo = magsize
				reserveammo -= ammo_needed
			else:
				magammo += reserveammo
				reserveammo = 0
				
		"add":
			reserveammo += additionalammo
			
	var weapon_data = {
		"Name" : weapon_name,
		"Image" : weapon_image,
		"Ammo" : str(magammo),
		"ReserveAmmo" : str(reserveammo)
	}
	
	weapon_manager.update_hud(weapon_data)
