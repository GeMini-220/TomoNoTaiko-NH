extends Node2D

# Preload the Note scene
var BasicNoteScene = preload("res://Scenes/BasicNote.tscn")
var current_x = 0
var current_y = 0
var current_beat = 0
var note_index = 0
var beatmap = {}
@onready var conductor = $Conductor
@onready var Global = $"/root/Global"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Conductor.play_with_beat_offset(8)		# can change offset
	Global.beat.connect(_on_Conductor_beat)
	#Global.measure.connect(_on_Conductor_measure)
	
	
func _on_Conductor_beat(position):
	var beatmap = StaticData.beatmapData["notes"]
	#print("Loaded beatmap:", beatmap)	# debugging: confirm beatmap data loaded correctly
	var song_position_in_beats = position
	for note in beatmap:
		current_x = note["x"]
		current_y = note["y"]
		current_beat = note["beat"]
		
		if current_beat == song_position_in_beats:
			spawn_note(Vector2(current_x,current_y))  # Adjust position as needed
			print("Current beat:", current_beat, "\nSong Position:", song_position_in_beats)
	
	
func spawn_note(position: Vector2) -> void:
	# Create an instance of the Note scene
	var note_instance = BasicNoteScene.instantiate()
	# Set the position of the instance
	note_instance.position = position
	# Add the note instance as a child to the notes node
	$notes.add_child(note_instance)
	print("Note spawned at position:", position)	# Debugging: Confirm position
