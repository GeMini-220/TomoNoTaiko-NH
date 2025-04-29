extends "res://Scripts/basic_note.gd"

var mouse_entered = false

func _on_range_comp_in_range():
	if not mouse_entered:
		Global.AudioPlayer.play()
		sprite.play("On Hit")
		Global.hit(Global.Rating.PERFECT)
		mouse_entered = true
