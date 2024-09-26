extends Node3D


@onready var player = $Player

@onready var LightManager = $LightManager.get_children()
var worldenv = preload("res://scenes/worldenvironment.tres")

var shadow

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.light == 0:
		shadow = false
		worldenv.ssil_enabled = false
		
	elif Global.light == 1:
		shadow = true
		worldenv.ssil_enabled = false
		
	elif Global.light ==2:
		shadow = true
		worldenv.ssil_enabled = true
	
	worldenv.volumetric_fog_enabled = Global.fog
	lightManage()

func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)

func lightManage():
	for light in LightManager:
		light.shadow_enabled = shadow
		
