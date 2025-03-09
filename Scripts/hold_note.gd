extends Node2D

var time_elapsed : float = 0.0
var time_held : float = 0.0
var note_held : bool = false
var click_rating := Global.Rating.BAD
var hold_rating := Global.Rating.BAD
@export var duration : float = 1.0 # in seconds
@onready var sprite = $Sprite
@onready var progress = $TextureProgressBar

const degrees_per_second = -720.0

func _process(delta):
	time_elapsed += delta
	if note_held: # while the note is held, record time held
		time_held += delta
		progress.value = 100 * time_held / duration
		sprite.rotate(delta * deg_to_rad(degrees_per_second * hold_time / duration))
		# if the note was held for the full duration, hold_rating is perfect
		if time_held > duration:
			hold_rating = Global.Rating.PERFECT
			note_end()

func _note_clicked(_viewport, event, _shape):
	if event is InputEventMouseButton and event.pressed:
		evaluate_click_rating()
		note_held = true # start recording how long the note is held
		sprite.play("On Hold")
		sprite.pause() # pauses the animation so that the note stays while it's held
		progress.visible = true
	elif event is InputEventMouseButton and not event.pressed:
		# if the note was being held but no longer is, evaluate hold_rating
		if note_held:
			evaluate_hold_rating()
			note_end()


#func _on_area_2d_mouse_exited():
	#if note_held:
		#print("Mouse Exited!")
		#evaluate_hold_rating()
		#note_end()

func evaluate_click_rating():
	if time_elapsed >= 0.460 and time_elapsed <= 0.740:
		click_rating = Global.Rating.PERFECT
	elif time_elapsed >= 0.300 and time_elapsed <= 1.000:
		click_rating = Global.Rating.GOOD
	elif time_elapsed >= 0.200 and time_elapsed <= 1.400:
		click_rating = Global.Rating.OK
	else:
		click_rating = Global.Rating.BAD

func evaluate_hold_rating():
	var ratio = time_held / duration
	if ratio >= 0.95:
		hold_rating = Global.Rating.PERFECT
	elif ratio >= 0.8:
		hold_rating = Global.Rating.GOOD
	elif ratio >= 0.5:
		hold_rating = Global.Rating.OK
	else:
		hold_rating = Global.Rating.BAD

func note_end():
	var overall_rating = min(click_rating, hold_rating)
	Global.add_score_from_rating(overall_rating)
	
	note_held = false # stop recording how long the note is held
	progress.visible = false
	sprite.rotation = 0
	sprite.play() # finish the "on hit" animation
	
	# debugging
	#print("Click rating: " + str(click_rating))
	#print("Hold rating: " + str(hold_rating))
	#print("Overall rating: " + str(overall_rating))
	#print()

func _on_sprite_animation_finished(): # Miss
	if sprite.animation == "Idle":
		Global.reset_combo()
	queue_free()
