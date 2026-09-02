extends Node

@onready var bus_index: int = AudioServer.get_bus_index("sfx")

var sounds = {
	"reload_1": preload("res://Audio/SFX/sfx_reload_1.wav"), 	
	"reload_2": preload("res://Audio/SFX/sfx_reload_2.wav"), 	
	"reload_3": preload("res://Audio/SFX/sfx_reload_3.wav"), 	
}

func play_audio(sound_id: String):
	var stream = AudioStreamPlayer.new()
	add_child(stream)
	stream.bus = "sfx"
	stream.set_stream(sounds[sound_id])
	stream.play()
	await stream.finished
	stream.queue_free()


func _on_reload():
	var i = randi_range(1,3)
	match i:
		1:
			play_audio("reload_1")
		2:
			play_audio("reload_2")
		3:
			play_audio("reload_3")