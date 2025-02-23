extends Node2D

var time_elapsed : float = 0.0
@onready var sprite = $Sprite

func _ready():
	$Area2D.connect("input_event", _note_clicked)

func _process(delta):
	time_elapsed += delta

func _note_clicked(viewport, event, shape):
	if event is InputEventMouseButton and event.pressed:
		if time_elapsed >= 0.460 and time_elapsed <= 0.740: # Perfect
			Global.add_score_from_rating(Global.Rating.PERFECT)
		elif time_elapsed >= 0.300 and time_elapsed <= 1.000: # Good
			Global.add_score_from_rating(Global.Rating.GOOD)
		elif time_elapsed >= 0.200 and time_elapsed <= 1.400: # Ok
			Global.add_score_from_rating(Global.Rating.OK)
		else: # Bad
			Global.add_score_from_rating(Global.Rating.BAD)
		sprite.play("On Hit")

func _on_animation_finished(): # Miss
	if sprite.animation == "Idle":
		Global.reset_combo()
	queue_free()
