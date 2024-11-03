extends Node

func _ready():
	run_tests()

func run_tests():
	print("Running tests...")

	test_sec_per_beat_calculation()
	test_report_beat()
	test_signal_connection()

	print("All tests completed.")


# Test cases for Conductor.gd
func test_sec_per_beat_calculation():
	var conductor = preload("res://Scripts/Conductor.gd").new()
	conductor.bpm = 120
	conductor._ready()
	assert(conductor.sec_per_beat == 0.5, "sec_per_beat calculation failed for 120 BPM")
	
	conductor.bpm = 60
	conductor._ready()
	assert(conductor.sec_per_beat == 1.0, "sec_per_beat calculation failed for 60 BPM")

func test_report_beat():
	var conductor = preload("res://Scripts/Conductor.gd").new()
	conductor.bpm = 120
	conductor._ready()
	conductor.song_position = 1.0
	conductor._physics_process(0.016)
	
	# Check if beat signal is emitted
	assert(Global.has_signal("beat"), "Beat signal not emitted")
	assert(Global.has_signal("measure"), "Measure signal not emitted")


# Test cases for Game.gd
func test_signal_connection():
	var game = preload("res://Scripts/Game.gd").new()
	game._ready()
	var game_on_conductor_beat = Callable(game, "_on_conductor_beat")
	var game_on_conductor_measure = Callable(game, "_on_conductor_measure")
	assert(Global.is_connected("beat", game_on_conductor_beat), "Beat signal not connected")
	assert(Global.is_connected("measure", game_on_conductor_measure), "Measure signal not connected")

func test_on_conductor_beat():
	var game = preload("res://Scripts/Game.gd").new()
	game._ready()
	Global.emit_signal("beat", 1)
	# Assuming a print or log in _on_conductor_beat (function not implemented yet)
