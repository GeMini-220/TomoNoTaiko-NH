extends Control

@onready var OnHoverAudio = $OnHoverAudio

func on_pressed():
	Global.AudioPlayer.stream = preload("res://Assets/SFX/TNTNH Menu Button Select.wav")
	Global.AudioPlayer.bus = "SFX"
	Global.AudioPlayer.play()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn") # Replace with function body.

func _on_mouse_entered() -> void:
	OnHoverAudio.play()
