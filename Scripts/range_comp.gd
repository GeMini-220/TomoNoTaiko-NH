extends Node

signal in_range
signal out_range

func _on_area_2d_mouse_entered():
	in_range.emit()


func _on_area_2d_mouse_exited():
	out_range.emit()
