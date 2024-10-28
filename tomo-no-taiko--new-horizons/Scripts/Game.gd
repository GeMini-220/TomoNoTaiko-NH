extends Node2D


func _ready():
	Global.beat.connect(_on_conductor_beat)
	Global.measure.connect(_on_conductor_measure)
	$Conductor.play_with_beat_offset(8)


func _on_conductor_measure(song_position_in_measure):
	pass


func _on_conductor_beat(song_position_in_beat):
	# implement here to spawn beats
	pass
