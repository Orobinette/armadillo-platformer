extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping: bool = false

@export_group("Horizontal Movement")
static var movement_velocity: Vector2 = Vector2.ZERO
var input_direction: float = 0

@export var max_movement_speed: float
@export var seconds_to_accelerate: float
@export var seconds_to_decelerate: float
@export var seconds_to_stop: float
var acceleration: float
var deceleration: float
var friction: float

func _ready():
	await get_tree().physics_frame
	acceleration = max_movement_speed / (seconds_to_accelerate / get_physics_process_delta_time())
	deceleration = max_movement_speed / (seconds_to_decelerate / get_physics_process_delta_time())
	friction = max_movement_speed / (seconds_to_stop / get_physics_process_delta_time())

func _process(delta):
	get_input()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	calculate_horizontal_movement()
	check_collisions()
	move_and_slide()

func get_input() -> void:
	#Horizontal movement
	input_direction = sign(Input.get_axis("move_left", "move_right"))

#Horizontal Movement
func calculate_horizontal_movement() -> void:
	print(velocity.x)
	if velocity.x == 0:
		thrust()

	elif input_direction == 0:
		apply_friction()

	else:
		if sign(velocity.x) != input_direction:
			decelerate()
		elif sign(velocity.x) == input_direction:
			if velocity.x > max_movement_speed * input_direction:
				slow_down()
			else:
				accelerate()

func thrust() -> void:
	velocity.x = 0.1 * input_direction

func slow_down() -> void:
	velocity.x = move_toward(velocity.x, max_movement_speed * input_direction, acceleration)

func accelerate() -> void:
	velocity.x = move_toward(velocity.x, max_movement_speed * input_direction, acceleration)

func decelerate() -> void:
	velocity.x = move_toward(velocity.x, 0, deceleration)

func apply_friction() -> void:
	velocity.x = move_toward(velocity.x, 0, friction)


func check_collisions() -> void:
	if is_on_ceiling():
		is_jumping = false