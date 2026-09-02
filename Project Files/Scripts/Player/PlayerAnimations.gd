extends AnimatedSprite2D

@export var player_movement: Node
@export var player_input: Node

var rolling: bool = false
var current_fall_time: float = 0
@export var short_fall_time: float

func _ready():
	play("idle_L")

func _process(delta: float) -> void:
	if rolling:
		if player_input.dir_facing == -1:
			play("roll_L")
		else:
			play("roll_R")

		return

	if player_movement.is_grounded:
		if player_input.input_direction == 0 and abs(player_movement.velocity.x) <= 0.1:
			idle(player_input.dir_facing)
		elif sign(player_input.input_direction) == sign(player_movement.velocity.x):
			accelerate(player_input.dir_facing)
		elif sign(player_input.input_direction) != sign(player_movement.velocity.x):
			change_direction(player_input.dir_facing)

		return

	if player_movement.velocity.y < 0 and player_movement.is_jumping:
		jump(player_input.dir_facing)
	elif player_input.current_air_cancel_buffer_frame < player_input.air_cancel_buffer_frames:
		air_cancel(player_input.dir_facing)
	elif current_fall_time < short_fall_time:
		fall_short(player_input.dir_facing)
		current_fall_time += delta
		print(current_fall_time)
	else:
		fall_long(player_input.dir_facing)

func idle(input_direction):
	if input_direction == 1:
		play("idle_R")
	elif input_direction == -1:
		play("idle_L")

func accelerate(input_direction):
	if input_direction == 1:
		play("run_R")
	elif input_direction == -1:
		play("run_L")

func change_direction(input_direction):
	#print(input_direction)
	if input_direction == 1:
		play("decelerate_R")
	elif input_direction == -1:
		play("decelerate_L")

func jump(input_direction):
	if animation == "roll_R" or animation == "roll_L" or animation == "jump_L" or animation == "jump_R":
		return
	
	if input_direction == 1:
		play("jump_R")
	elif input_direction == -1:
		play("jump_L")

func fall_short(input_direction):
	if input_direction == 1:
		play("fall_short_R")
	elif input_direction == -1:
		play("fall_short_L")

func fall_long(input_direction):
	if input_direction == 1:
		play("fall_long_R")
	elif input_direction == -1:
		play("fall_long_L")

func air_cancel(input_direction):
	if input_direction == 1:
		play("air_cancel_R")
	elif input_direction == -1:
		play("air_cancel_L")


func _on_roll_pressed(_input_direction):
	rolling = true

func _on_roll_release():
	rolling = false
	current_fall_time = 0

func _on_shoot(_gun_type):
	if player_input.dir_facing == 1:
		play("roll_R")
	elif player_input.dir_facing == -1:
		play("roll_L")

func _on_grounded():
	current_fall_time = 0