extends Weapon


# Equip/DeEquip cycle
func equip():
	update_ammo()

func deequip():
	pass
	
func is_equip_finished():
	return true

func is_unequip_finished():
	return true
		
# Update Ammo
func update_ammo(_action = "Refresh"):
	
	var weapon_data = {
		"Name" : weapon_name
	}
	
	weapon_manager.update_hud(weapon_data)
