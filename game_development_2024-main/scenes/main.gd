extends Node3D

@onready var spawns = $Map/Spawns
@onready var navigation_region = $Map/NavigationRegion3D


@onready var player = $Map/NavigationRegion3D/Player

@onready var LightManager = $Map/LightManager.get_children()
var worldenv = preload("res://scenes/worldenvironment.tres")

var shadow

var instance
var enemy = load("res://scenes/entities/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	if Global.light == 0:
		shadow = false
		worldenv.ssil_enabled = false
		
	elif Global.light == 1:
		shadow = true
		worldenv.ssil_enabled = false
		
	elif Global.light ==2:
		shadow = true
		worldenv.ssil_enabled = true
	
	if Global.postprocessing == 0:
		worldenv.glow_enabled = false
		worldenv.ssao_enabled = false
		
	elif Global.postprocessing == 1:
		worldenv.glow_enabled = true
		worldenv.ssao_enabled = false
		
	elif Global.postprocessing ==2:
		worldenv.glow_enabled = true
		worldenv.ssao_enabled = true
	
	worldenv.volumetric_fog_enabled = Global.fog
	lightManage()


func lightManage():
	for light in LightManager:
		light.shadow_enabled = shadow
		

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_enemy_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = enemy.instantiate()
	instance.position = spawn_point
	navigation_region.add_child(instance)
