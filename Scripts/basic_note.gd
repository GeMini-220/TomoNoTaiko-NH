extends Node2D

@onready var sprite = $Sprite

func _ready():
	Global.AudioPlayer.bus = "SFX"
	Global.AudioPlayer.stream = Global.note_sfx_list[0]

func _on_animation_finished(): # Miss
	if sprite.animation == "Idle":
		Global.miss(position)
	queue_free()
