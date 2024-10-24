extends Control


var weapon_ui
var health_ui
var display_ui
var slot_ui


func _enter_tree():
	weapon_ui = $Background/WeaponUI
	health_ui = $Background/HealthUI
	display_ui = $Background/Display/TextureRect
	slot_ui = $Background/Display/Weaponslot

func _ready():
	hide_interaction_prompt()



func update_weapon_ui(weapon_data, weapon_slot):
	slot_ui.text = weapon_slot
	
	if weapon_data["Name"] == "Unarmed":
		weapon_ui.text = weapon_data["Name"]
		return
	weapon_ui.text = weapon_data["Name"] + ": " + weapon_data["Ammo"] + "/" + weapon_data["ReserveAmmo"]
	
# Show/Hide interaction prompt
func show_interaction_prompt(description = "Interact"):
	$InteractionPrompt.visible = true
	$InteractionPrompt/Description.text = description
	$Crosshair.visible = false

func hide_interaction_prompt():
	$InteractionPrompt.visible = false
	$Crosshair.visible = true
