extends Node2D
signal note_deleted(clicked: bool)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the input_event signal of Area2D to handle clicks.
	$Area2D.connect("input_event", _note_clicked)
	_delayed_delete(1.1)


# Function to handle mouse click events.
func _note_clicked(viewport, event, shape) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Note clicked!")
		emit_signal("note_deleted", true)
		queue_free()


func _delayed_delete(delay_time):
	await get_tree().create_timer(delay_time).timeout
	emit_signal("note_deleted", false)
	queue_free()
