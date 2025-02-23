extends Control

@onready var grade = $Result/Grade
@onready var sync = $Result/Sync
@onready var score = $Stats/Damage/Score
@onready var combo = $"Stats/Max Combo/Combo"
@onready var ratings = $Stats/Ratings

# Called when the node enters the scene tree for the first time.
func _ready():
	var ratio: int = floor(100 * Global.score / 999999.0)
	var letter: String
	var color: Color
	var adjective: String
	if ratio >= 99:
		letter = "S"
		color = Color("b29e64")
		adjective = "Fully "
	elif ratio >= 80:
		letter = "A"
		color = Color.DARK_RED
		adjective = "Nearly "
	elif ratio >= 50:
		letter = "B"
		color = Color.DARK_BLUE
		adjective = "Half "
	elif ratio >= 30:
		letter = "C"
		color = Color.DARK_GREEN
		adjective = "Poorly "
	else:
		letter = "D"
		color = Color.BLACK
		adjective = "De"
	grade.text = letter
	grade.add_theme_color_override("font_color", color)
	sync.text = "%sSynchronized" % adjective;
	
	score.text = str(Global.score)
	combo.text = str(Global.highest_combo) + "x"
	
	for rating in ratings.get_children():
		var num_ratings = Global.rating_count[Global.rating_name[rating.name]]
		rating.text = str(num_ratings)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
