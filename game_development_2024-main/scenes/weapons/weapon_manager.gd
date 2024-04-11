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
var unequiped_weapon = false



func _ready():
	
	hud = owner.get_node("HUD")
	
	all_weapons = {
		"Unarmed" : preload("res://scenes/weapons/unarmed/unarmed.tscn"),
		"Handcannon" : preload("res://scenes/weapons/handcannon/handcannon.tscn"),
		"AssaultRifle" : preload("res://scenes/weapons/assaultrifle/assault_rifle.tscn")
	}

	weapons = {
		"Empty" : $Unarmed,
		"Primary" : $Handcannon,
		"Secondary" : $AssaultRifle
	}
