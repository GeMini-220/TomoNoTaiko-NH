extends Node2D

signal beat(position)
signal measure(position)

#Global score and combo
var score: int = 0
var combo: int = 0

var standard_score: int

@onready var AudioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(AudioPlayer)

func add_score(points: int):
	score += points
	combo += 1
	#print("Current Score: ", score, " | Combo: x", combo)

# reset score(call when starting level)
func reset_score():
	score = 0
	combo = 0

func reset_combo()-> void:
	combo = 0
