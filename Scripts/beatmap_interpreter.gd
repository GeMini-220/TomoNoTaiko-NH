extends Node2D

var ClickNoteScene = preload("res://Scenes/Click Note.tscn")
var HoldNoteScene = preload("res://Scenes/Hold Note.tscn")
var PassiveNoteScene = preload("res://Scenes/Passive Note.tscn")

var beat_offset = 2 # audio starts after 2 beats
var time_before_very_perfect = 0.6
var very_perfect_frame = 30 # 31 is the perfect frame
var current_x = 0
var current_y = 0
var current_beat = 0
var current_type

var song_is_over = false

@onready var conductor = $Conductor
@onready var score_display = $ScoreDisplay
@onready var health_bar = $HealthBar


func _ready():
	Global.score = 0
	Global.combo = 0
	Global.standard_score = 999999 / StaticData.beatmapData["notes"].size()
	conductor.bpm = StaticData.beatmapData["bpm"]
	conductor.play_with_beat_offset(StaticData.beatmapData["offset"])
	Global.beat.connect(_on_Conductor_beat)
	#Global.measure.connect(_on_Conductor_measure)

func _process(_delta):
	if not song_is_over:
		score_display.text = str(Global.score)
		health_bar.value = 999999 - Global.score
		if Global.combo != 0:
			score_display.text += "\n" + str(Global.combo) + "x Combo"
			
		
func _on_Conductor_beat(song_position_in_beats):
	var beatmap = StaticData.beatmapData["notes"]
	#print("Loaded beatmap:", beatmap)	# debugging: confirm beatmap data loaded correctly
	for note in beatmap:
		current_x = note["location"][0] #/ 9 * 16 * 0.8
		current_y = note["location"][1] #/ 16 * 9 * 0.8 #Temporary Solution; TODO: Fix beatmap generating location
		current_beat = note["beat"]
		current_type = note.get("type", "basic")	# default to basic note
		
		if current_beat == song_position_in_beats:
			var timer = Timer.new()
			timer.wait_time = conductor.sec_per_beat * beat_offset - time_before_very_perfect # delay for 2 beats - 300ms before spawn
			timer.one_shot = true
			if current_type == "hold":
				var duration = note["duration"]
				timer.connect("timeout", Callable(self.spawn_hold_note).bind(Vector2(current_x,current_y), duration))
			else:
				timer.connect("timeout", Callable(self.spawn_note).bind(Vector2(current_x,current_y)))
				
			add_child(timer)
			timer.start()
			#print("Current beat:", current_beat, "\nSong Position:", song_position_in_beats)


func _on_Conductor_measure(_song_position_in_measure):
	pass


func spawn_note(n_position: Vector2):
	var note_instance = ClickNoteScene.instantiate()

	var fps = very_perfect_frame / time_before_very_perfect # the 31st frame should be on beat
	note_instance.get_node("Sprite").speed_scale = fps / 20 # 20 is default fps

	note_instance.position = n_position
	add_child(note_instance)
	#print("Note spawned at position:", position)	# Debugging: Confirm position


func spawn_hold_note(n_position: Vector2, duration: float):
	var hold_note_instance = HoldNoteScene.instantiate()
	var fps = very_perfect_frame / time_before_very_perfect # the 31st frame should be on beat
	hold_note_instance.get_node("Sprite").speed_scale = fps / 20 # 20 is default fps

	hold_note_instance.position = n_position
	hold_note_instance.duration = duration
	add_child(hold_note_instance)
	

func _on_conductor_song_over():
	song_is_over = true
	score_display.text = ""
