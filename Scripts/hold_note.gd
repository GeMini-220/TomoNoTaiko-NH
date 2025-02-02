extends Node2D

var time_elapsed : float = 0.0
var held : bool = false
var hold_time : float = 0.0
enum Rating {BAD = 0, OK = 1, GOOD = 2, PERFECT = 3} # TODO: maybe implement this elsewhere so that other scenes can use it
var click_rating := Rating.BAD
var hold_rating := Rating.BAD
@export var duration : float = 1.0 # in seconds
@onready var sprite = $Sprite

func _ready():
	$Area2D.connect("input_event", _note_clicked)

func _process(delta):
	time_elapsed += delta
	if held: # while the note is held, record time held
		hold_time += delta
		# if the note was held for the full duration, hold_rating is perfect
		if hold_time > duration:
			hold_rating = Rating.PERFECT
			note_end()

func _note_clicked(viewport, event, shape):
	if event is InputEventMouseButton and event.pressed:
		evaluate_click_rating()
		held = true # start recording how long the note is held
		sprite.play("On Hit")
		sprite.pause() # pauses the animation so that the note stays while it's held
	elif event is InputEventMouseButton and not event.pressed:
		# if the note was being held but no longer is, evaluate hold_rating
		if held:
			evaluate_hold_rating()
			note_end()

func evaluate_click_rating():
	if time_elapsed >= 0.460 and time_elapsed <= 0.740:
		click_rating = Rating.PERFECT
	elif time_elapsed >= 0.300 and time_elapsed <= 1.000:
		click_rating = Rating.GOOD
	elif time_elapsed >= 0.200 and time_elapsed <= 1.400:
		click_rating = Rating.OK
	else:
		click_rating = Rating.BAD

func evaluate_hold_rating():
	var ratio = hold_time / duration
	if ratio >= 1.0:
		hold_rating = Rating.PERFECT
	elif ratio >= 0.8:
		hold_rating = Rating.GOOD
	elif ratio >= 0.5:
		hold_rating = Rating.OK
	else:
		hold_rating = Rating.BAD

func note_end():
	var overall_rating = min(click_rating, hold_rating)
	add_score_from_rating(overall_rating)
	
	held = false # stop recording how long the note is held
	sprite.play() # finish the "on hit" animation
	
	# debugging
	#print("Click rating: " + str(click_rating))
	#print("Hold rating: " + str(hold_rating))
	#print("Overall rating: " + str(overall_rating))

func add_score_from_rating(rating):
	match rating:
		Rating.PERFECT:
			Global.add_score(Global.standard_score)
		Rating.GOOD:
			Global.add_score(Global.standard_score / 2)
		Rating.OK:
			Global.add_score(Global.standard_score / 5)
		Rating.BAD:
			Global.add_score(0)

func _on_sprite_animation_finished(): # Miss
	if sprite.animation == "Idle":
		Global.reset_combo()
	queue_free()
