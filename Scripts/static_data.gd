extends Node

var beatmapData = {}
var standard_score = 0
var current_beatmap_index = 0
# add new beatmaps here
var data_file_path = [
	"res://Assets/Beatmap/Level1.json",
	"res://Assets/Beatmap/Level2Normal.json"
]


func _ready():
	current_beatmap_index = Global.song_index
	load_beatmap(current_beatmap_index)
	
func load_beatmap(index: int):
	if index >= 0 and index < data_file_path.size():
		beatmapData = load_json_file(data_file_path[index])
	else:
		print("Index out of range")
	
func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
			
	else:
		print("File doesn't exist")
