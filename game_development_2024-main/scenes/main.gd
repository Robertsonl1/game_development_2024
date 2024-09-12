extends Node3D

@onready var LightManager = $LightManager.get_children()

var ener


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.light == 0:
		ener = 1
		
	elif Global.light == 1:
		ener = 10
	
	elif Global.light ==2:
		ener = 10000
		
	lightManage()

func lightManage():
	for light in LightManager:
		light.light_energy = ener
