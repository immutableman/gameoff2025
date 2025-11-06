extends Control

var _data: LevelData

func set_level_data(data: LevelData) -> void:
	_data = data
	$Button.text = data.display_name


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(_data.scene)
