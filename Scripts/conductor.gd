extends AudioStreamPlayer

@export var bpm := 100:
	set(value):
		bpm = value
		sec_per_beat = 60.0 / bpm
@export var measures := 4
@export var end_screen: PackedScene

# Tracking the beat and song position
var song_position := 0.0
var song_position_in_measure := 1
var song_position_in_beat := 1
var sec_per_beat := 60.0 / bpm
var last_reported_beat := -1
var beats_before_start := 0
var audio_offset_secs := 0.0

signal song_over

func _ready():
	stream = Global.song_list[Global.song_index] #Changes song according to global index set in Main Menu
	sec_per_beat = 60.0 / bpm

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position -= audio_offset_secs
		song_position_in_beat = int(floor(song_position / sec_per_beat))
		_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beat:
		if song_position_in_measure > measures:
			song_position_in_measure = 1
		Global.beat.emit(song_position_in_beat)
		Global.measure.emit(song_position_in_measure)
		last_reported_beat = song_position_in_beat
		song_position_in_measure += 1


func play_with_beat_offset(offset: float):
	audio_offset_secs = offset / 1000.0
	play()


func play_from_beat(beat: int, offset: float):
	audio_offset_secs = offset / 1000.0
	seek(beat * sec_per_beat)
	song_position_in_measure = beat % measures
	play()


#func _on_StartTimer_timeout():
	#song_position_in_beat += 1
	#if song_position_in_beat < beats_before_start - 1:
		#$StartTimer.start()
	#elif song_position_in_beat == beats_before_start - 1:
		#$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														#AudioServer.get_output_latency())
		#$StartTimer.start()
	#else:
		#play()
		#$StartTimer.stop()
	#_report_beat()


func _on_finished() -> void:
	song_over.emit()
	var end = end_screen.instantiate()
	add_child(end)
