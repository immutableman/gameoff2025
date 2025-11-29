extends Control

var level_star_scene = preload("res://assets/kenney/new-platformer-pack-1.0/Sprites/star.png")

var _data: LevelData

func set_level_data(data: LevelData) -> void:
	_data = data
	if data.is_completed:
		$Button.text = data.display_name + '    '
		$Button.icon = level_star_scene
	else:
		$Button.text = data.display_name + '        '


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(_data.scene)
