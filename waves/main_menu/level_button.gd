extends Control

var _data: LevelData

func set_level_data(data: LevelData) -> void:
	_data = data
	$Button.text = data.display_name
