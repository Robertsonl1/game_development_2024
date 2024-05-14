extends Node3D


# All the weapons in the game
var all_weapons = {}

# Weapons the player is carrying
var weapons = {}

# HUD
var hud

var current_weapon # Reference to the current weapon equipped
var current_weapon_slot = "Empty" # The current weapon slot

var changing_weapon = false
var deequiped_weapon = false



func _ready():
	
	hud = owner.get_node("HUD")
	
	all_weapons = {
		"Unarmed" : preload("res://scenes/weapons/unarmed/unarmed.tscn"),
		"Handcannon" : preload("res://scenes/weapons/armed/handcannon/handcannon.tscn"),
		"AssaultRifle" : preload("res://scenes/weapons/armed/assaultrifle/assault_rifle.tscn")
	}

	weapons = {
		"Empty" : $Unarmed,
		"Primary" : $Handcannon,
		"Secondary" : $AssaultRifle
	}
	
	# Initialize references for each weapon
	for w in weapons:
		if weapons[w] != null:
			weapons[w].weapon_manager = self
			weapons[w].player = owner
			weapons[w].visible = false
	
	# Set current weapon to unarmed
	current_weapon = weapons["Empty"]
	change_weapon("Empty")

	# Disable process
	set_process(false)


# Process will be called when changing weapons
func _process(_delta):
	
	if deequiped_weapon == false:
		if current_weapon.is_deequip_finished() == false:
			return
			
		
		deequiped_weapon = true
		
		current_weapon = weapons[current_weapon_slot]
		current_weapon.equip()
		
	if current_weapon.is_equip_finished() == false:
		return
	
	changing_weapon = false
	set_process(false)



func change_weapon(new_weapon_slot):
	
	if new_weapon_slot == current_weapon_slot:
		current_weapon.update_ammo() # Referesh
		return
	
	if weapons[new_weapon_slot] == null:
		return
		
	current_weapon_slot = new_weapon_slot
	changing_weapon = true
	
	weapons[current_weapon_slot].update_ammo() # Updates the weapon data on UI, as soon as we change a weapon
	
	# Change Weapons
	if current_weapon != null:
		deequiped_weapon = false
		current_weapon.deequip()
		
	
	set_process(true)


# Update HUD
func update_hud(weapon_data):
	var weapon_slot = "1"
	
	match current_weapon_slot:
		"Empty":
			weapon_slot = "1"
		"Primary":
			weapon_slot = "2"
		"Secondary":
			weapon_slot = "3"
	
	hud.update_weapon_ui(weapon_data, weapon_slot)
