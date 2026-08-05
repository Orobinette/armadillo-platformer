extends AnimatedSprite2D

func _ready():
	play("idle_L")

func _on_idle(input_direction):
	if input_direction == 1:
		play("idle_R")
	elif input_direction == -1:
		play("idle_L")

func _on_accelerate(input_direction):
	if input_direction == 1:
		play("run_R")
	elif input_direction == -1:
		play("run_L")

func _on_deccelerate(input_direction):
	#print(input_direction)
	if input_direction == 1:
		play("decelerate_R")
	elif input_direction == -1:
		play("decelerate_L")

func _on_jump(input_direction):
	if input_direction == 1:
		play("jump_R")
	elif input_direction == -1:
		play("jump_L")

func _on_fall():
	play("temp")

func _on_air_cancel():
	play("temp")

func _on_rolled():
	play("temp")