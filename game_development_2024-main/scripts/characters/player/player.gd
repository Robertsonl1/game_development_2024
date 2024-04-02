extends CharacterBody3D

var walkspeed = 10

var horizontal_acceleration = 6
var air_acceleration = 2
var gravity = 9.8

var direction = Vector3()

var mouse_sensitivity = 0.03

var horizontal_velocity = Vector3()

@onready var head: = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(_delta):
		
	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))


