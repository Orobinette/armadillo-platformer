extends AnimatedSprite2D

func _ready():
	play("idle")

func _on_idle():
	play("idle")

func _on_accelerate(input_direction):
	if input_direction == 1:
		play("run_right")
	elif input_direction == -1:
		play("run_left")

func _on_deccelerate(input_direction):
	play("temp")

func _on_jump():
	play("temp")

func _on_fall():
	play("temp")

func _on_air_cancel():
	play("temp")