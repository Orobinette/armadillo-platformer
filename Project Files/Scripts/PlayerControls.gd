extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input() -> void:
	#Horizontal movement
	input_direction = sign(Input.get_axis("move_left", "move_right"))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func check_collisions() -> void:
	if is_on_ceiling():
		movement_velocity.y = 0
		is_jumping = false