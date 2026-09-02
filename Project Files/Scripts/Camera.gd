extends Camera2D

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0
var shake_fade: float = 0.0
@export var shake_strengths: Array[float]
@export var shake_fades: Array[float]

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _on_shot(gun_type: String):
	var shake_index: int
	match gun_type:
		"revolver":
			shake_index = 0
		"shotgun":
			shake_index = 1
		"rifle":
			shake_index = 2
	shake_strength = shake_strengths[shake_index]
	shake_fade = shake_fades[shake_index]

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