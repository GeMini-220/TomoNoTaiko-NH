extends Node2D

var time_elapsed : float = 0.0
@onready var sprite = $Sprite
@onready var rate_visual = preload("res://Scenes/Rating Visual.tscn")

func _ready():
	$Area2D.connect("input_event", _note_clicked)

func _process(delta):
	time_elapsed += delta

func _note_clicked(viewport, event, shape):
	if event is InputEventMouseButton and event.pressed:
		var rating
		if time_elapsed >= 0.460 and time_elapsed <= 0.740: # Perfect
			rating = Global.Rating.PERFECT
		elif time_elapsed >= 0.300 and time_elapsed <= 1.000: # Good
			rating = Global.Rating.GOOD
		elif time_elapsed >= 0.200 and time_elapsed <= 1.400: # Ok
			rating = Global.Rating.OK
		else: # Bad
			rating = Global.Rating.BAD
		sprite.play("On Hit")
		Global.hit(rating)

func _on_animation_finished(): # Miss
	if sprite.animation == "Idle":
		Global.miss(position)
	queue_free()
