extends Node2D

# Preload the Note scene
var BasicNoteScene = preload("res://Scenes/BasicNote.tscn")
# Reference to the score display
@onready var score_display = $ScoreDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	# Call the function to instance and position the note
	while true:
		await get_tree().create_timer(1.0).timeout
		spawn_note(Vector2(randi() % 1600, randi() % 900))  # Adjust position as needed

func _process(delta: float) -> void:
	# Update the score display every frame
	score_display.text = "Score: " + str(Score.score) + " Combo: " + str(Score.combo)
	
func spawn_note(position: Vector2) -> void:
	# Create an instance of the Note scene
	var note_instance = BasicNoteScene.instantiate()
	# Set the position of the instance
	note_instance.position = position
	# Add the note instance as a child to the main scene
	add_child(note_instance)
