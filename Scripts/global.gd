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

@onready var AudioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(AudioPlayer)

func add_score(points: int):
	score += points
	combo += 1
	if combo > highest_combo:
		highest_combo = combo
	#print("Current Score: ", score, " | Combo: x", combo)

func add_score_from_rating(rating: int):
	var adjusted_score
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
