extends AnimatedSprite2D

@export var player_movement: Node
@export var player_input: Node

var rolling: bool = false

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
	else:
		fall(player_input.dir_facing)

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

func fall(input_direction):
	if input_direction == 1:
		play("fall_R")
	elif input_direction == -1:
		play("fall_L")

func air_cancel(input_direction):
	if input_direction == 1:
		play("air_cancel_R")
	elif input_direction == -1:
		play("air_cancel_L")

func _on_roll_pressed(_input_direction):
	rolling = true

func _on_roll_release():
	rolling = false

func _on_shoot():
	if player_input.dir_facing == 1:
		play("roll_R")
	elif player_input.dir_facing == -1:
		play("roll_L")