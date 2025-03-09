extends Node2D

var last_hit = false

@onready var player = $Player  # Reference to the Player AnimatedSprite2D
@onready var timer = $Player/Timer # Reference to the Timer node under Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
# change poses on mouse mouse click
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		
		if last_hit:
			player.play("hit_left")
		else:
			player.play("hit_right")
		last_hit = !last_hit
		
		timer.start(1)
		
# return to idle pose
func _on_timer_timeout():
	player.play("idle")
	
	
