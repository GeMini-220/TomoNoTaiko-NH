extends Node2D

# Preload the Note scene
var BasicNoteScene = preload("res://Scenes/Basic Note.tscn")

var beat_offset = 2 # audio starts after 2 beats
var current_x = 0
var current_y = 0
var current_beat = 0
var note_index = 0
var beatmap = {}

@onready var conductor = $Conductor
@onready var Global = $"/root/Global"
@onready var score_display = $ScoreDisplay


# Called when the node enters the scene tree for the first time.
func _ready():
	conductor.play_with_beat_offset(beat_offset)		# can change offset
	Global.beat.connect(_on_Conductor_beat)
	#Global.measure.connect(_on_Conductor_measure)
	
func _process(delta: float) -> void:
	# Update the score display every frame
	score_display.text = "Score: " + str(Global.score) + " Combo: " + str(Global.combo)
	
func _on_Conductor_beat(song_position_in_beats):
	var beatmap = StaticData.beatmapData["notes"]
	#print("Loaded beatmap:", beatmap)	# debugging: confirm beatmap data loaded correctly
	for note in beatmap:
		current_x = note["x"]
		current_y = note["y"]
		current_beat = note["beat"]
		
		if current_beat == song_position_in_beats:
			var timer = Timer.new()
			timer.wait_time = conductor.sec_per_beat * beat_offset - 0.3 # delay for 2 beats - 300ms before spawn
			timer.one_shot = true
			timer.connect("timeout", Callable(self.spawn_note).bind(Vector2(current_x,current_y)))
			add_child(timer)
			timer.start()
			#spawn_note(Vector2(current_x,current_y))  # Adjust position as needed
			print("Current beat:", current_beat, "\nSong Position:", song_position_in_beats)


func _on_conductor_measure(song_position_in_measure):
	pass


func spawn_note(position: Vector2):
	var note_instance = BasicNoteScene.instantiate()
	
	var fps = 30 / (conductor.sec_per_beat * beat_offset) # the 31st frame should be on beat
	note_instance.get_node("AnimatedSprite2D").speed_scale = fps / 20 # 20 is default fps
	
	note_instance.position = position
	add_child(note_instance)
	print("Note spawned at position:", position)	# Debugging: Confirm position
