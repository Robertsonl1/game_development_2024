extends CharacterBody3D

signal playerdied

const HIT_STAGGER = 8.0

var health = 100

var bob_freq = 0
var bob_amp = 0
var t_bob = 0.0

var walkspeed = 15
var crouchspeed = 5
var sprintspeed = 15
var truespeed = walkspeed

var iscrouching = false

var horizontal_acceleration = 6
var air_acceleration = 6
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
@onready var crouch_cast = $CrouchCast3D
@onready var pause = $Pause
@onready var hud = $HUD

func _ready():
	# Captures the mouse so it does not go off the end of the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause.hide()
	
	if Global.difficulty == 0:
		health = 150
		
	elif Global.difficulty == 1:
		health = 100
		
	elif Global.difficulty == 2:
		health = 50
		
	if Global.bob == false:
		bob_freq = 1.4
		bob_amp = 0.08
	else:
		bob_freq = 0
		bob_amp = 0

func _process(_delta):
	window_activity()
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/ui/menu/death_screen.tscn")

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
	
	# Head bob
	t_bob += _delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
		# Crouching when the crouch key is pressed
	if Input.is_action_just_pressed("crouch"):
		if iscrouching == false:
			movementStateChange("crouch")
			truespeed = crouchspeed
	
	# Uncrouches when the crouch key is released
	if !Input.is_action_pressed("crouch"):
		if iscrouching == true and !crouch_cast.is_colliding():
			movementStateChange("uncrouch")
			truespeed = walkspeed
		
	
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause.show()
		

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
	
	# Drop Weapon	
	if Input.is_action_just_pressed("drop"):
		weapon_manager.drop_weapon()
		
	# Pickup Weapon
	weapon_manager.process_weapon_pickup()
	

func hit(dir):
	horizontal_velocity += dir * HIT_STAGGER
	health = health - 10
	print(health)

func die():
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/ui/menu/death_screen.tscn")

# To show/hide the cursor
func window_activity():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos

func movementStateChange(changetype):
	match changetype:
		"crouch":
			$AnimationPlayer.play("crouch")
			changeCollisionShape("crouching")
			iscrouching = true
		
		"uncrouch":
			$AnimationPlayer.play_backwards("crouch")
			changeCollisionShape("standing")
			iscrouching = false

func changeCollisionShape(shape):
	match shape:
		"crouching":
			$CrouchCollisionShape3D.disabled = false
			$CollisionShape3D.disabled = true
			
		"standing":
			$CrouchCollisionShape3D.disabled = true
			$CollisionShape3D.disabled = false
