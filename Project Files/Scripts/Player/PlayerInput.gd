extends Node

@export var player_movement: Node
@export var player_guns: Node
@export var collision_walk: CollisionShape2D
@export var collision_roll: CollisionShape2D

var state
enum states {WALKING, ROLLING}

var input_direction: int = 0
var dir_facing: int = -1

@export_group("Jump Buffer")
@export var jump_buffer_frames: float
@onready var current_jump_buffer_frame = jump_buffer_frames

@export_group("Air Cancel Buffer")
@export var air_cancel_buffer_frames: int
@onready var current_air_cancel_buffer_frame = air_cancel_buffer_frames


signal rolled(input_direction)
signal walked


func _process(_delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("shell"):
		collision_walk.disabled = true
		collision_roll.disabled = false
		state = states.ROLLING
		rolled.emit(input_direction)
		#print("roll")
	elif Input.is_action_just_released("shell"):
		collision_walk.disabled = false
		collision_roll.disabled = true
		state = states.WALKING
		walked.emit()
		#print("walk")

	match state:
		states.WALKING:
			get_input_walking()
		states.ROLLING:
			get_input_rolling()

	if Input.is_action_just_pressed("jump"):
		current_jump_buffer_frame = 0
		player_movement.is_jumping = true
		player_movement.jump()
	elif Input.is_action_just_released("jump") and not player_movement.is_grounded:
		player_movement.is_jumping = false

	if current_jump_buffer_frame < jump_buffer_frames:
		player_movement.jump()
		current_jump_buffer_frame += 1 


	if Input.is_action_just_pressed("select revolver"):
		player_guns.selected_gun = player_guns.guns.REVOLVER
		print("selected_gun")
	if Input.is_action_just_pressed("select shotgun"):
		player_guns.selected_gun = player_guns.guns.SHOTGUN
		print("selected_gun")
	if Input.is_action_just_pressed("select rifle"):
		player_guns.selected_gun = player_guns.guns.RIFLE
		print("selected_gun")

	if Input.is_action_just_pressed("air cancel"):
		player_movement.air_cancel()
		state = states.WALKING
		walked.emit()
		print("air cancel")
	if current_air_cancel_buffer_frame < air_cancel_buffer_frames:
		current_air_cancel_buffer_frame += 1

	
func get_input_walking():
	input_direction = sign(Input.get_axis("move left", "move right"))
	if input_direction != 0:
		dir_facing = input_direction

	#print(dir_facing)

func get_input_rolling():
	input_direction = 0

	if Input.is_action_just_pressed("shoot"):
		player_guns.shoot(player_guns.selected_gun)
	elif Input.is_action_just_pressed("quickfire revolver"):
		player_guns.shoot(player_guns.guns.REVOLVER)
	elif Input.is_action_just_pressed("quickfire shotgun"):
		player_guns.shoot(player_guns.guns.SHOTGUN)
	elif Input.is_action_just_pressed("quickfire rifle"):
		player_guns.shoot(player_guns.guns.RIFLE)