extends Camera2D
'''
@export var player: CharacterBody2D

var offset_up: float = -270
var offset_down: float = 270
var offset_left: float = -640
var offset_right: float = 640

func _ready():
	position = Vector2.ZERO

func _process(delta):
	if position.y < offset_up:
		position.y = offset_up

	if position.y < offset_down:
		position.y= offset_down
	if position.x < offset_left:
		position.x = offset_left

	if position.x > offset_right:
		position.x = offset_right

	print(position)
	
	if sign(player.velocity.x) == sign(player.position.x-position.x):
		position.x = player.position.x
	
	position.y = player.position.y-y_offset
	'''