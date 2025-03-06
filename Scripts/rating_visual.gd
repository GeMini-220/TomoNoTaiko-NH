extends Control

var color_dict = {Global.Rating.PERFECT: Color("b29e64"),
					Global.Rating.GOOD: Color.DARK_RED,
					Global.Rating.OK: Color.DARK_BLUE,
					Global.Rating.BAD: Color.DARK_GREEN,
					Global.Rating.MISS: Color.BLACK
					}

@onready var label = $Label
@onready var anim_player = $AnimationPlayer

func set_rating(rating: int, visual_pos: Vector2):
	position = visual_pos
	#visible = true
	label.text = Global.Rating.keys()[rating]
	label.add_theme_color_override("font_color", color_dict[rating])
	anim_player.play("fade")
