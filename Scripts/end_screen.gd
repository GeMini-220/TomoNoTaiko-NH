extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var ratio: int = floor(100 * Global.score / 999999.0)
	var adjective: String
	if ratio >= 99:
		adjective = "Fully "
	elif ratio >= 80:
		adjective = "Nearly "
	elif ratio >= 50:
		adjective = "Half "
	else:
		adjective = "De"
	$Result.text = "%sSynchronized" % adjective;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
