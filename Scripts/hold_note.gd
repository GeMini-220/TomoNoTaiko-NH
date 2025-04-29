extends "res://Scripts/basic_note.gd"

var time_held : float = 0.0
var note_held : bool = false
var click_rating
@export var duration : float = 1.0 # in seconds
@onready var progress = $TextureProgressBar

const degrees_per_second = -720.0

func _process(delta):
	if note_held: # while the note is held, record time held
		time_held += delta
		spin(delta)
		# if the note was held for the full duration, hold_rating is perfect
		if time_held >= duration:
			end_hold(Global.Rating.PERFECT)

func spin(delta):
	progress.value = 100 * time_held / duration
	sprite.rotate(delta * deg_to_rad(degrees_per_second * time_held / duration))

func _on_click_comp_mouse_down():
	if sprite.animation == "Idle":
		Global.AudioPlayer.play()
		sprite.play("On Hold")
		click_rating = $ClickComp.evaluate_click_rating()
		note_held = true # start recording how long the note is held
		sprite.pause() # pauses the animation so that the note stays while it's held
		progress.visible = true

func _on_click_comp_mouse_up():
	cancel_hold()

func _on_range_comp_out_range():
	cancel_hold()

func cancel_hold():
	if note_held:
		var hold_rating = evaluate_hold_rating()
		end_hold(hold_rating)

func evaluate_hold_rating():
	var ratio = time_held / duration
	if ratio >= 0.95:
		return Global.Rating.PERFECT
	elif ratio >= 0.8:
		return Global.Rating.GOOD
	elif ratio >= 0.5:
		return Global.Rating.OK
	else:
		return Global.Rating.BAD

func end_hold(hold_rating):
	var overall_rating = min(click_rating, hold_rating)
	Global.hit(overall_rating)
	
	note_held = false # stop recording how long the note is held
	progress.visible = false
	sprite.rotation = 0
	sprite.play() # finish the "on hit" animation
	
	# debugging
	#print("Click rating: " + str(click_rating))
	#print("Hold rating: " + str(hold_rating))
	#print("Overall rating: " + str(overall_rating))
	#print()
