extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002
const JOYSTICK_SENSITIVITY = 2.5
const DEADZONE = 0.1

var pitch := 0.0

@onready var camera = $Camera3D

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	if event is InputEventMouseMotion:
		# Rotate player left/right (Y axis)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

		# Rotate camera up/down (X axis)
		#pitch -= event.relative.y * MOUSE_SENSITIVITY
		#pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
		#camera.rotation.x = pitch
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input (WASD / joystick)
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	# Convert to 3D direction relative to where player is facing
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Controller look (right joystick)
	var look_input = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	if abs(look_input) > DEADZONE:
		rotate_y(-look_input * JOYSTICK_SENSITIVITY * delta)

	move_and_slide()
