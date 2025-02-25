extends Node2D

signal beat(position)
signal measure(position)

#Global score and combo
var score: int
var combo: int

var standard_score: int

#Song Selection Variables
var song_index: int
var song_list = [
	preload("res://Assets/Sound Tracks/Taiko Music.mp3"),
	preload("res://Assets/Sound Tracks/One Piece OP 1 - We Are! Lyrics.mp3")
]
var cover_list_200 = [
	preload("res://Assets/Album Covers/Logo-V1.2-Circle200.png"),
	preload("res://Assets/Album Covers/damndaniel200.png")
]
var cover_list_100 = [
	preload("res://Assets/Album Covers/Logo-V1.2-Circle100.png"),
	preload("res://Assets/Album Covers/damndaniel100.png")
]

@onready var AudioPlayerMusic: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var AudioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(AudioPlayer)
	add_child(AudioPlayerMusic)

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
