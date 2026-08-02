extends Node2D

@export var player_movement: Node
@export var player_input: Node

var radians = 0
@onready var radian_step = PI / 50
var offset = 150

var dir = 1

func _ready():
	position = Vector2(0,0)

func _process(delta):
	if radians == 2 * PI:
		radians = 0

	radians += radian_step * dir

	position = Vector2(cos(radians), sin(radians)) * offset
	
func get_trajectory() -> Vector2:
	dir = -sign(cos(radians))
	return -Vector2(cos(radians), sin(radians))#.normalized()


func _on_walked():
	hide()
func _on_rolled():
	show()
	dir = sign(player_input.dir_facing)
	#position = Vector2(150*dir,0)