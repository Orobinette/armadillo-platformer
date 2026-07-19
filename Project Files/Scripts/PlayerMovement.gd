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

@export_group("Vertical Movement")
var is_grounded: bool = false
@export_subgroup("Jump")
@export var jump_height: float
@export var jump_seconds_to_peak: float
@export var jump_seconds_to_descent: float
@export var max_upward_velocity: float

@onready var jump_velocity = ((2.0 * jump_height) / jump_seconds_to_peak) * -1.0
@onready var jump_gravity = ((-2.0 * jump_height) / (jump_seconds_to_peak * jump_seconds_to_peak)) * -1.0
@onready var fall_gravity = ((-2.0 * jump_height) / (jump_seconds_to_descent * jump_seconds_to_descent)) * -1.0

@export_subgroup("Coyote Time")
@export var coyote_time_frames = 3
@onready var current_coyote_time_frame = 0

@export_subgroup("Jump Buffer")
@export var jump_buffer_frames: float
@onready var current_jump_buffer_frame = jump_buffer_frames

@export_subgroup("Hang Time")
@export  var hang_time_frames: int
@onready var current_hangtime_frame = hang_time_frames


func _ready():
	await get_tree().physics_frame
	acceleration = max_movement_speed / (seconds_to_accelerate / get_physics_process_delta_time())
	deceleration = max_movement_speed / (seconds_to_decelerate / get_physics_process_delta_time())
	friction = max_movement_speed / (seconds_to_stop / get_physics_process_delta_time())

func _process(_delta):
	get_input()

func _physics_process(delta):
	calculate_horizontal_movement()
	calculate_gravity(delta)
	coyote_time()

	check_collisions()
	move_and_slide()

func get_input() -> void:
	#Horizontal movement
	input_direction = sign(Input.get_axis("move_left", "move_right"))
	
	#Vertical movement
	if Input.is_action_just_pressed("jump"):
		current_jump_buffer_frame = 0
		is_jumping = true

	elif Input.is_action_just_released("jump") and not is_grounded:
		is_jumping = false

	if current_jump_buffer_frame < jump_buffer_frames:
		jump()
		current_jump_buffer_frame += 1 


#Horizontal Movement
func calculate_horizontal_movement() -> void:
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

#Vertical Movement
func calculate_gravity(delta) -> void:
	if not is_grounded:
		if velocity.y < 0 and is_jumping: #if rising
			velocity.y = move_toward(velocity.y, 0, jump_gravity * delta)
			
		elif current_hangtime_frame < hang_time_frames and is_jumping: #Hangtime
			current_hangtime_frame += 1

		else: 
			velocity.y = move_toward(velocity.y, fall_gravity, fall_gravity * delta) #Apply gravity

func jump() -> void:
	if is_grounded:
		velocity.y = jump_velocity
		is_grounded = false

func coyote_time() -> void:
	if is_on_floor() and current_coyote_time_frame != 0:
		grounded()

	elif not is_on_floor():
		if current_coyote_time_frame < coyote_time_frames: #Coyote time active
			current_coyote_time_frame += 1

		else: # Fall off ledge
			is_grounded = false
			current_coyote_time_frame = coyote_time_frames

func grounded():
	current_coyote_time_frame = 0
	current_hangtime_frame = 0
	movement_velocity.y = 0
	is_grounded = true

func check_collisions() -> void:
	if is_on_ceiling():
		is_jumping = false