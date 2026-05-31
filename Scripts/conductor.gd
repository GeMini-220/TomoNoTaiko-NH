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
var audio_offset_secs := 0.0

var _song_time_begin: float = 0.0
var _is_playing: bool = false
var _cached_output_latency: float = AudioServer.get_output_latency()

signal song_over

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Changes song according to global index set in Main Menu
	stream = Global.song_list[Global.song_index]
	sec_per_beat = 60.0 / bpm

func _process(_delta: float) -> void:
	if not _is_playing:
		return
	var now := Time.get_ticks_usec() / 1_000_000.0
	song_position = (now - _song_time_begin) * pitch_scale

func _physics_process(_delta: float) -> void:
	if not _is_playing:
		return
	song_position_in_beat = int(floor(song_position / sec_per_beat))
	_report_beat()

func _report_beat() -> void:
	if last_reported_beat < song_position_in_beat:
		Global.beat.emit(song_position_in_beat)
		Global.measure.emit(song_position_in_measure)
		last_reported_beat = song_position_in_beat
		song_position_in_measure += 1

func play_with_beat_offset(offset_ms: float) -> void:
	audio_offset_secs = offset_ms / 1000.0
	play()
	_song_time_begin = (
		Time.get_ticks_usec() / 1_000_000.0
		+ audio_offset_secs
		+ AudioServer.get_time_to_next_mix()
		+ _cached_output_latency
	)
	_is_playing = true

func _on_finished() -> void:
	_is_playing = false
	song_over.emit()
	var end := end_screen.instantiate()
	add_child(end)
