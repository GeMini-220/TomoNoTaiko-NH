extends Node2D

var last_hit = false

@onready var player = $Player  # Reference to the Player AnimatedSprite2D
@onready var timer = $Player/Timer # Reference to the Timer node under Player

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.note_hit.connect(change_pose)


func _process(delta):
	pass
	
# change poses on mouse mouse click
func change_pose():
		
	if last_hit:
		player.play("hit_left")
	else:
		player.play("hit_right")
	last_hit = !last_hit
		
	timer.start(1)
		
# return to idle pose
func _on_timer_timeout():
	player.play("idle")
	
	
