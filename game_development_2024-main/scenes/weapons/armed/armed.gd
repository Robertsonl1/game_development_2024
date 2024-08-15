extends Weapon
class_name Armed

# Rigidbody Version
@export var weapon_pickup : PackedScene

# References
var animation_player

# Weapon States
var is_firing = false
var is_reloading = false

# Weapon Parameters
@export var ammo_in_mag = 15
@export var reserve_ammo = 30
@onready var mag_size = ammo_in_mag

@export var damage = 10
@export var fire_rate = 1.0

# The offset of the weapon from the camera
@export var equip_pos = Vector3.ZERO

# Effects
@export var impact_effect: PackedScene
@export var muzzle_flash_path: NodePath
@onready var muzzle_flash = get_node(muzzle_flash_path)

# Optional
@export var equip_speed = 1.0
@export var unequip_speed = 1.0
@export var reload_speed = 1.0



# Fire Cycle
func fire():
	if not is_reloading:
		if ammo_in_mag > 0:
			if not is_firing:
				is_firing = true
				animation_player.get_animation("Fire")
				animation_player.play("Fire", -1.0, fire_rate)
			
			return
		
		elif is_firing:
			fire_stop()

func fire_stop():
	is_firing = false
	animation_player.get_animation("Fire")
	animation_player.play("RESET")


func fire_bullet():    # Will be called from the animation track
	muzzle_flash.emitting = true
	update_ammo("consume")
	
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var impact = Global.instantiate_node(impact_effect, ray.get_collision_point())
		impact.emitting = true




# Reload
func reload():
	if ammo_in_mag < mag_size and reserve_ammo > 0:
		is_firing = false
		
		animation_player.play("Reload", -1.0, reload_speed)
		is_reloading = true





# Equip/Unequip Cycle
func equip():
	animation_player.play("Equip", -1.0, equip_speed)
	is_reloading = false

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
		"Reload":
			is_reloading = false
			update_ammo("Reload")



# Update Ammo
func update_ammo(action = "Refresh", additional_ammo = 0):
	
	match action:
		"consume":
			ammo_in_mag -= 1
		
		"Reload":
			var ammo_needed = mag_size - ammo_in_mag
			
			if reserve_ammo > ammo_needed:
				ammo_in_mag = mag_size
				reserve_ammo -= ammo_needed
			else:
				ammo_in_mag += reserve_ammo
				reserve_ammo = 0
		
		"add":
			reserve_ammo += additional_ammo
	
	
	var weapon_data = {
		"Name" : weapon_name,
		"Image" : weapon_image,
		"Ammo" : str(ammo_in_mag),
		"ReserveAmmo" : str(reserve_ammo)
	}
	
	weapon_manager.update_hud(weapon_data)

# Drops weapon on the ground, by instancing weapon_pickup, and removing itself from the tree
func drop_weapon():
	var pickup = Global.instantiate_node(weapon_pickup, global_transform.origin - player.global_transform.basis.z.normalized())
	pickup.ammo_in_mag = ammo_in_mag
	pickup.reserve_ammo = reserve_ammo
	pickup.mag_size = mag_size
	
	queue_free()
