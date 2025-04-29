extends Node

signal mouse_down
signal mouse_up
signal double_click
var time_elapsed : float = 0.0

func _process(delta):
	time_elapsed += delta

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.double_click:
			double_click.emit()
		elif event.pressed:
			mouse_down.emit()
		else:
			mouse_up.emit()

func evaluate_click_rating():
	if time_elapsed >= 0.460 and time_elapsed <= 0.740:
		return Global.Rating.PERFECT
	elif time_elapsed >= 0.300 and time_elapsed <= 1.000:
		return Global.Rating.GOOD
	elif time_elapsed >= 0.200 and time_elapsed <= 1.400:
		return Global.Rating.OK
	else:
		return Global.Rating.BAD
