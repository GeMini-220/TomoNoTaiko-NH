extends Control

@onready var OnHoverAudio = $OnHoverAudio

func on_pressed():
	Global.AudioPlayer.stream = preload("res://SFX/TNTNH Menu Button Select.wav")
	Global.AudioPlayer.play()

func _on_play_pressed() -> void:
	on_pressed()
	get_tree().change_scene_to_file("res://Scenes/Level 1.tscn")

func _on_options_pressed() -> void:
	on_pressed()
	get_tree().change_scene_to_file("res://Scenes/Options Menu.tscn")

func _on_quit_pressed() -> void:
	on_pressed()
	get_tree().quit()

func _on_mouse_entered() -> void:
	OnHoverAudio.play()
