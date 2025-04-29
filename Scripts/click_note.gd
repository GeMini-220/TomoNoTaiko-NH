extends "res://Scripts/basic_note.gd"

func _on_click_comp_mouse_down():
	Global.AudioPlayer.play()
	sprite.play("On Hit")
	var rating = $ClickComp.evaluate_click_rating()
	Global.hit(rating)
