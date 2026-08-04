extends Camera2D

@export var player: CharacterBody2D
var y_offset: float = 351

func _ready():
	position = player.position - Vector2(0,y_offset)

func _process(delta):
	print(sign(player.velocity.x))
	if sign(player.velocity.x) == sign(player.position.x-position.x):
		position.x = player.position.x
	
	position.y = player.position.y-y_offset