extends Node2D

# Preload the Note scene
var BasicNoteScene = preload("res://Scenes/BasicNote.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Call the function to instance and position the note
	spawn_note(Vector2(400, 300))  # Adjust position as needed
	
func spawn_note(position: Vector2) -> void:
	# Create an instance of the Note scene
	var note_instance = BasicNoteScene.instantiate()
		
	# Set the position of the instance
	note_instance.position = position
		
	# Add the note instance as a child to the main scene
	add_child(note_instance)
