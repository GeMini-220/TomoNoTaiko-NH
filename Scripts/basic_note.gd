extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the input_event signal of Area2D to handle clicks.
	$Area2D.connect("input_event", _note_clicked)

# Function to handle mouse click events.
func _note_clicked(viewport, event, shape) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Note clicked!")
