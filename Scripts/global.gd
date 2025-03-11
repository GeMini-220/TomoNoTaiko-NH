extends Node2D

signal beat(position)
signal measure(position)
signal note_hit

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
	#preload("res://Assets/Sound Tracks/One Piece OP 1 - We Are! Lyrics.mp3"),
	preload("res://Assets/Sound Tracks/cyber-gorgon_180_v1.mp3")
]
var cover_list_200 = [
	preload("res://Assets/Album Covers/Logo-V1.2-Circle200.png"),
	#preload("res://Assets/Album Covers/damndaniel200.png"),
	preload("res://Assets/Album Covers/LEBRONJAMES200.png")
]
var cover_list_100 = [
	preload("res://Assets/Album Covers/Logo-V1.2-Circle100.png"),
	#preload("res://Assets/Album Covers/damndaniel100.png"),
	preload("res://Assets/Album Covers/LEBRONJAMES100.png")
]
var level_scenes = [
	"res://Scenes/Level 1.tscn",
	"res://Scenes/Level 2.tscn"
]
var note_sfx_list = [
	preload("res://Assets/SFX/Oodaiko-1.wav"),
	preload("res://Assets/SFX/Oodaiko-2.wav"),
	preload("res://Assets/SFX/Oodaiko-3.wav"),
	preload("res://Assets/SFX/Oodaiko-4.wav"),
	preload("res://Assets/SFX/Shimedaiko-1.wav")
]

@onready var AudioPlayerMusic: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var AudioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var rate_visual = preload("res://Scenes/Rating Visual.tscn")

func _ready():
	add_child(AudioPlayer)
	add_child(AudioPlayerMusic)

func add_score(points: int):
	score += points
	combo += 1
	if combo > highest_combo:
		highest_combo = combo
	#print("Current Score: ", score, " | Combo: x", combo)

func add_score_from_rating(rating: int) -> void:
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
	
func hit(rating: int) -> void:
	add_score_from_rating(rating)
	note_hit.emit()
	#create_rating_visual(rating, get_global_mouse_position())


func create_rating_visual(rating: int, visual_pos: Vector2) -> void:
	var rv = rate_visual.instantiate()
	get_tree().root.add_child(rv)
	rv.set_rating(rating, visual_pos)

func hit(rating: int) -> void:
	add_score_from_rating(rating)
	create_rating_visual(rating, get_global_mouse_position())

func miss(note_pos: Vector2) -> void:
	add_score_from_rating(Rating.MISS)
	create_rating_visual(Rating.MISS, note_pos)
	reset_combo()


# reset score(call when starting level)
func reset_score():
	score = 0
	combo = 0
	highest_combo = 0

func reset_combo()-> void:
	combo = 0

