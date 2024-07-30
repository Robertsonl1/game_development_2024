extends CharacterBody3D

signal playerdied

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
@onready var weapon_manager = $Head/Hand

func _ready():
	# Captures the mouse so it does not go off the end of the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	window_activity()

func _input(event):
	# Handles the rotation of the player when the mouse is moved
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					weapon_manager.next_weapon()
				MOUSE_BUTTON_WHEEL_DOWN:
					weapon_manager.previous_weapon()

func _physics_process(_delta):
	
	process_weapons()
	process_movement(_delta)
	

func process_movement(_delta):
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
		
	# Firing
	if Input.is_action_just_pressed("fire"):
		weapon_manager.fire()
	if Input.is_action_just_released("fire"):
		weapon_manager.fire_stop()

	# Reloading
	if Input.is_action_just_pressed("reload"):
		weapon_manager.reload()

# To show/hide the cursor
func window_activity():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
