extends Node2D
signal note_deleted(clicked: bool)

var timer: Timer
var delay_time = 1.1

@onready var OnClickAudio = $OnClickAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the input_event signal of Area2D to handle clicks.
	$Area2D.connect("input_event", _note_clicked)
	#_delayed_delete()


# Function to handle mouse click events.
func _note_clicked(viewport, event, shape) -> void:
	if event is InputEventMouseButton and event.pressed:
		OnClickAudio.play()
		#if timer.time_left >= delay_time * 0.8:
			#Global.add_score(100)
			#print("Perfect")
		#elif timer.time_left >= delay_time * 0.5:
			#Global.add_score(80)
			#print("Good")
		#elif timer.time_left >= delay_time * 0.3:
			#Global.add_score(50)
			#print("Ok")
		#else:
			#Global.add_score(10)
			#print("Bad")
		emit_signal("note_deleted", true)
		queue_free()


#func _delayed_delete():
	#timer = Timer.new()
	#timer.wait_time = delay_time
	#timer.one_shot = true
	#add_child(timer)
	#timer.start()
	#timer.connect("timeout", Callable(self._timer_timeout))
#
#func _timer_timeout() -> void:
	#emit_signal("note_deleted", false)
	#queue_free()
	#print("Miss")
	#Global.reset_combo()

#func _timer_time() -> float:
	#if timer and timer.is_stopped() == false:
		#return timer.time_left
	#return 0.0

	#await get_tree().create_timer(delay_time).timeout
	#emit_signal("note_deleted", false)
	#queue_free()
	#Score.reset_combo()


func _on_animation_finished() -> void:
	emit_signal("note_deleted", false)
	queue_free()
	print("Miss")
	Global.reset_combo()
