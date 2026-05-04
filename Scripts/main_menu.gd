extends Control

@onready var OnHoverAudio = $OnHoverAudio

# Variables for implementing Song Selection
var catalogue: int
var current: int = 0
var next: int
var prev: int

func _ready() -> void:
	catalogue = Global.song_list.size()	
	update_indexes()
	var main_theme := preload("res://Assets/Sound Tracks/taiko_main_theme.wav")
	if Global.AudioPlayerMusic.stream != main_theme or not Global.AudioPlayerMusic.playing:
		Global.AudioPlayerMusic.stream = main_theme
		Global.AudioPlayerMusic.bus = "Music"
		Global.AudioPlayerMusic.play()
	if not Global.AudioPlayerMusic.finished.is_connected(self.repeat):
		Global.AudioPlayerMusic.finished.connect(self.repeat)

# Main Menu Implementation
func on_pressed() -> void:
	Global.AudioPlayer.stream = preload("res://Assets/SFX/TNTNH Menu Button Select.wav")
	Global.AudioPlayer.bus = "SFX"
	Global.AudioPlayer.play()

func _on_play_pressed() -> void: # Hides play button and reveals song selection buttons
	play_selected_song()
	get_node("Play").hide()
	get_node("Select").show()
	get_node("Prev").show()
	get_node("Next").show()

func _on_options_pressed() -> void: # Opens options menu
	on_pressed()
	get_tree().change_scene_to_file("res://Scenes/Options Menu.tscn")

func _on_quit_pressed() -> void: # Quits game
	on_pressed()
	get_tree().quit()

func _on_mouse_entered() -> void: # Plays audio when hovering over buttons
	OnHoverAudio.play()

# Song Selection Implementation using Global Variables
# Song Selection Functions
func update_album_covers() -> void: # Shows the covers for prev, current, and next song choices
	$Select.icon = Global.cover_list_200[current]
	$Prev.icon = Global.cover_list_100[prev]
	$Next.icon = Global.cover_list_100[next]

func update_indexes() -> void: # Increment/Decrement indexes, allowing for preview of prev/next
	next = (current + 1) % catalogue
	prev = (current - 1 + catalogue) % catalogue

func play_selected_song() -> void: # Plays music for the current album + click SFX
	on_pressed()
	Global.AudioPlayerMusic.stream = Global.song_list[current]
	Global.AudioPlayerMusic.play()
	if not Global.AudioPlayerMusic.finished.is_connected(self.repeat):
		Global.AudioPlayerMusic.finished.connect(self.repeat)

# Song Selection Button Inputs
func _on_select_pressed() -> void: # Switches to scene: Level 1
	on_pressed()
	Global.song_index = current
	Global.AudioPlayerMusic.stop()
	var level_path = Global.level_scenes[current]
	StaticData.load_beatmap(current)
	SceneLoader.load_scene(level_path)

func _on_next_pressed() -> void: # Increments selected song and updates UI
	current = next
	play_selected_song()
	update_indexes()
	update_album_covers()

func _on_prev_pressed() -> void: # Decrements selected song and updates UI
	current = prev
	play_selected_song()
	update_indexes()
	update_album_covers()

func repeat() -> void:
	Global.AudioPlayerMusic.play()
