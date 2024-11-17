extends Node

#Global score and combo
var score: int = 0
var combo: int = 0


# Function to add points
func add_score(points: int) -> void:
	if combo == 0:
		score += points
	else:
		score += points * combo
	if combo <= 10:
		combo += 1
	print("Current Score: ", score, " | Combo: x", combo)

#reset score(call when starting level)
func reset_score() -> void:
	score = 0
	combo = 0

func reset_combo()-> void:
	combo = 0
