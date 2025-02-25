extends Control

@onready var OnHoverAudio = $OnHoverAudio

#Variables for implementing Song Selection
var catalogue = Global.song_list.size()
var current = 0
var next = (current + 1) % catalogue
var prev = (current - 1) % catalogue

#Main Menu Implementation
func on_pressed():
	Global.AudioPlayer.stream = preload("res://Assets/SFX/TNTNH Menu Button Select.wav")
	Global.AudioPlayer.bus = "SFX"
	Global.AudioPlayer.play()

func _on_play_pressed() -> void: #Hides play button and reveals song selection buttons
	be_annoying()
	get_node("Play").hide()
	get_node("Select").show()
	get_node("Prev").show()
	get_node("Next").show()

func _on_options_pressed() -> void: #Opens option menu
	on_pressed()
	get_tree().change_scene_to_file("res://Scenes/Options Menu.tscn")

func _on_quit_pressed() -> void: #Quits game
	on_pressed()
	get_tree().quit()

func _on_mouse_entered() -> void: #Plays audio when hovering over buttons
	OnHoverAudio.play()

#Song Selection Implementation using Global Variables
#Song Selection Functions
func update_album_covers(): #Shows the covers for prev,current, and next song choices
	$Select.icon = Global.cover_list_200[current]
	$Prev.icon = Global.cover_list_100[prev]
	$Next.icon = Global.cover_list_100[next]
	
func update_indexes(): #Increment/Decrement indexes, allowing for preview of prev/next
	next = (current + 1) % catalogue
	prev = (current - 1) % catalogue
	
func be_annoying(): #Plays music for current album + click SFX
	on_pressed()
	#await get_tree().create_timer(0.93).timeout
	Global.AudioPlayerMusic.stream = Global.song_list[current]
	Global.AudioPlayerMusic.play()
	Global.AudioPlayerMusic.finished.connect(self.repeat)

#Song Selection Button Inputs
func _on_select_pressed() -> void: #Switches to scene: Level 1
	on_pressed()
	Global.song_index = current
	Global.AudioPlayerMusic.stop()
	get_tree().change_scene_to_file("res://Scenes/Level 1.tscn")

func _on_next_pressed() -> void: #Increments selected song and calls various functions
	current = next
	be_annoying()
	update_indexes()
	update_album_covers()

func _on_prev_pressed() -> void: #Decrements selected song and calls various functions
	current = prev
	be_annoying()
	update_indexes()
	update_album_covers()

func _ready() -> void:
	Global.AudioPlayerMusic.stream = preload("res://Assets/Sound Tracks/taiko_main_theme.wav")
	Global.AudioPlayerMusic.play()
	Global.AudioPlayerMusic.finished.connect(self.repeat)
	
func repeat() -> void:
	Global.AudioPlayerMusic.play()
