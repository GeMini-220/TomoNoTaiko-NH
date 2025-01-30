extends Node2D

var time_elapsed : float = 0.0
var held : bool = false
var hold_time : float = 0.0
enum Rating {BAD = 0, OK = 1, GOOD = 2, PERFECT = 3} # TODO: maybe implement this elsewhere so that other scenes can use it
var click_rating
var hold_rating
@export var duration : float = 1.0
@onready var sprite = $Sprite

func _ready():
	$Area2D.connect("input_event", _note_clicked)

func _process(delta):
	time_elapsed += delta
	if held: # while the note is held, record time held
		hold_time += delta

func _note_clicked(viewport, event, shape):
	if event is InputEventMouseButton and event.pressed:
		if time_elapsed >= 0.460 and time_elapsed <= 0.740:
			click_rating = Rating.PERFECT
		elif time_elapsed >= 0.300 and time_elapsed <= 1.000:
			click_rating = Rating.GOOD
		elif time_elapsed >= 0.200 and time_elapsed <= 1.400:
			click_rating = Rating.OK
		else:
			click_rating = Rating.BAD
		held = true # start recording how long the note is held
		sprite.play("On Hit")
		sprite.pause() # pauses the animation so that the note stays while it's held
	elif event is InputEventMouseButton and not event.pressed:
		var ratio = hold_time / duration # holds the percentage of time the note is held compared to the full duration
		if 0.8 < ratio and ratio <= 1:
			hold_rating = Rating.PERFECT
		elif 0.5 < ratio and ratio <= 0.8:
			hold_rating = Rating.GOOD
		elif 0.2 < ratio and ratio <= 0.5: # slight deviation from GDD because I didn't exactly understand the ranges
			hold_rating = Rating.OK
		else:
			hold_rating = Rating.BAD
		
		var overall_rating = min(click_rating, hold_rating) # takes the lowest between click rating and the hold rating
		match overall_rating:
			Rating.PERFECT:
				Global.add_score(Global.standard_score)
			Rating.GOOD:
				Global.add_score(Global.standard_score / 2)
			Rating.OK:
				Global.add_score(Global.standard_score / 5)
			Rating.BAD:
				Global.add_score(0)
		
		held = false # stop recording how long the note is held
		sprite.play() # finish the "on hit" animation

func _on_sprite_animation_finished(): # Miss
	if sprite.animation == "Idle":
		Global.reset_combo()
	queue_free()
