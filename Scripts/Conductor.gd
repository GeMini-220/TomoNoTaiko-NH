extends AudioStreamPlayer

@export var bpm := 100
@export var measures := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_measure = 1
var song_position_in_beat = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0


func _ready():
	sec_per_beat = 60.0 / bpm


func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beat = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beat:
		if song_position_in_measure > measures:
			song_position_in_measure = 1
		Global.beat.emit(song_position_in_beat)
		Global.measure.emit(song_position_in_measure)
		last_reported_beat = song_position_in_beat
		song_position_in_measure += 1


func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	song_position_in_measure = beat % measures


func _on_StartTimer_timeout():
	song_position_in_beat += 1
	if song_position_in_beat < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beat == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
