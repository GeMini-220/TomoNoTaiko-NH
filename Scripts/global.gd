extends Node2D

signal beat(position)
signal measure(position)

#Global score and combo
var score: int
var combo: int
var standard_score: int
var highest_combo: int

enum Rating { MISS, BAD, OK, GOOD, PERFECT }
var rating_name = {"Miss": Rating.MISS,
					"Bad" : Rating.BAD,
					"OK": Rating.OK,
					"Good": Rating.GOOD,
					"Perfect": Rating.PERFECT
					}
var rating_count = {Rating.MISS: 0,
					Rating.BAD: 0,
					Rating.OK: 0,
					Rating.GOOD: 0,
					Rating.PERFECT: 0
					}

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
	if combo > highest_combo:
		highest_combo = combo
	#print("Current Score: ", score, " | Combo: x", combo)

func add_score_from_rating(rating: int):
	match rating:
		Rating.PERFECT:
			add_score(standard_score)
		Rating.GOOD:
			add_score(standard_score / 2)
		Rating.OK:
			add_score(standard_score / 5)
		Rating.BAD:
			add_score(0)
	rating_count[rating] += 1

# reset score(call when starting level)
func reset_score():
	score = 0
	combo = 0
	highest_combo = 0

func reset_combo()-> void:
	combo = 0
	rating_count[Rating.MISS] += 1
