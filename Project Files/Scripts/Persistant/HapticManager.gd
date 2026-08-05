extends Node

func _ready():
	print(Input.get_connected_joypads())

func shoot(gun_name):
	pass
	'''
	match gun_name:
		"revolver":
			Input.start_joy_vibration(0, 0.5, 0.5)
		"shotgun":
			Input.start_joy_vibration(0, 0.5, 0.5)
		"rifle":
			Input.start_joy_vibration(0, 0.5, 0.5)
	'''