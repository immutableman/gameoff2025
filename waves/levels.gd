extends Node

@export var level_list: Array[LevelData]

func mark_complete():
	var path = get_tree().current_scene.get_scene_file_path()
	for data in level_list:
		if path == data.scene.resource_path:
			data.is_completed = true
			break
