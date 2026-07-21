extends Node

@export var player_movement: Node

var state
enum states {WALKING, ROLLING}

@onready var selected_gun = guns.REVOLVER
enum guns {REVOLVER, SHOTGUN, RIFLE}

var input_direction: float = 0

@export_group("Jump Buffer")
@export var jump_buffer_frames: float
@onready var current_jump_buffer_frame = jump_buffer_frames

@export_group("Air Cancel Buffer")
@export var air_cancel_buffer_frames: int
@onready var current_air_cancel_buffer_frame = air_cancel_buffer_frames


signal rolled


func _process(_delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("shell"):
		state = states.ROLLING
		rolled.emit()
		#print("roll")
	elif Input.is_action_just_released("shell"):
		state = states.WALKING
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
		selected_gun = guns.REVOLVER
		print("selected_gun")
	if Input.is_action_just_pressed("select shotgun"):
		selected_gun = guns.SHOTGUN
		print("selected_gun")
	if Input.is_action_just_pressed("select rifle"):
		selected_gun = guns.RIFLE
		print("selected_gun")

	if Input.is_action_just_pressed("air cancel"):
		player_movement.air_cancel()
		state = states.WALKING
		print("air cancel")
	if current_air_cancel_buffer_frame < air_cancel_buffer_frames:
		current_air_cancel_buffer_frame += 1

	
func get_input_walking():
	input_direction = sign(Input.get_axis("move left", "move right"))

func get_input_rolling():
	input_direction = 0

	if Input.is_action_just_pressed("shoot"):
		match selected_gun:
			guns.REVOLVER:
				print("Fire: Revolver")
			guns.SHOTGUN:
				print("Fire: Shotgun")
			guns.RIFLE:
				print("Fire: Rifle")
	elif Input.is_action_just_pressed("quickfire revolver"):
		print("Fire: Revolver")
	elif Input.is_action_just_pressed("quickfire shotgun"):
		print("Fire: Shotgun")
	elif Input.is_action_just_pressed("quickfire rifle"):
		print("Fire: Rifle")