extends Node

@export var player_movement: Node
@export var player_input: Node

@onready var selected_gun = guns.REVOLVER
enum guns {REVOLVER, SHOTGUN, RIFLE}

const MAX_AMMO_REVOLVER = 6
const MAX_AMMO_SHOTGUN = 2
const MAX_AMMO_RIFLE = 1

@onready var current_ammo_revolver = MAX_AMMO_REVOLVER
@onready var current_ammo_shotgun = MAX_AMMO_SHOTGUN
@onready var current_ammo_rifle = MAX_AMMO_RIFLE

signal shot


func shoot(gun):
	if not can_shoot(gun):
		return

	match gun:
		guns.REVOLVER:
			HapticManager.shoot("revolver")
			player_movement.apply_gun_velocity(guns.REVOLVER)
			if not player_movement.is_grounded:
				current_ammo_revolver -= 1
		guns.SHOTGUN:
			HapticManager.shoot("shotgun")
			player_movement.apply_gun_velocity(guns.SHOTGUN)
			if not player_movement.is_grounded:
				current_ammo_shotgun -=1 
		guns.RIFLE:
			HapticManager.shoot("rifle")
			player_movement.apply_gun_velocity(guns.RIFLE)
			if not player_movement.is_grounded:
				current_ammo_rifle -= 1

	shot.emit()
				
func can_shoot(gun) -> bool:
	match gun:
		guns.REVOLVER:
			if current_ammo_revolver > 0:
				return true
		guns.SHOTGUN:
			if current_ammo_shotgun > 0:
				return true
		guns.RIFLE:
			if current_ammo_rifle > 0:
				return true

	return false

func _on_grounded():
	if current_ammo_revolver < MAX_AMMO_REVOLVER or current_ammo_shotgun < MAX_AMMO_SHOTGUN or current_ammo_rifle < MAX_AMMO_RIFLE:
		AudioManager._on_reload()

	current_ammo_revolver = MAX_AMMO_REVOLVER
	current_ammo_shotgun = MAX_AMMO_SHOTGUN
	current_ammo_rifle = MAX_AMMO_RIFLE