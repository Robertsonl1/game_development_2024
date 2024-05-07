extends CharacterBody3D

signal playerdied

var speed = 10
var walkspeed = 10
var crouchspeed = 5
var sprintspeed = 15
var truespeed = walkspeed

var horizontal_acceleration = 6
var air_acceleration = 2
var normal_acceleration = 12

var gravity = 20
var jump = 10
var full_contact = false

var mouse_sensitivity = 0.03

var direction = Vector3()
var horizontal_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

@onready var head = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var grapplecast: RayCast3D = $Head/GrappleCast

@onready var weapon_manager = $Head/Hand

func _ready():
	# Captures the mouse so it does not go off the end of the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handles the rotation of the player when the mouse is moved
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func grapple():
	if Input.is_action_just_pressed("grapple"):
		if grapplecast.is_colliding():
			pass

func _physics_process(_delta):
	
	process_weapons()
	
	# Stops all vertical momentum when the player's head hits a ceiling
	if is_on_ceiling():
		gravity_vec = Vector3.ZERO
	
	# Applys gravity to the player when they are not on the ground
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * _delta
		horizontal_acceleration = air_acceleration
	else:
		gravity_vec = -get_floor_normal()
		horizontal_acceleration = normal_acceleration
	
	# Jumping when the jump key is pressed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * jump
		
	# Handles the movement direction
	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	horizontal_velocity = horizontal_velocity.lerp(direction * truespeed, horizontal_acceleration * _delta)
	movement.z = horizontal_velocity.z + gravity_vec.z
	movement.x = horizontal_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
		
	velocity = movement
	
	move_and_slide()

func process_weapons():
	if Input.is_action_just_pressed("empty"):
		weapon_manager.change_weapon("Empty")
		
	if Input.is_action_just_pressed("primary"):
		weapon_manager.change_weapon("Primary")
		
	if Input.is_action_just_pressed("secondary"):
		weapon_manager.change_weapon("Secondary")



