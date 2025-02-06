extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.score == 1000000:
		$Result.text = "You Win!"
	else:
		$Result.text = "You Lose!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
