extends Node

@export var level_list: Array[LevelData]

func _ready() -> void:
	EventBus.exit_success.connect(_on_exit_success)
	var i = 0
	for data in level_list:
		i+=1
		data.display_name = "%s) %s" % [i, data.display_name]

func mark_complete():
	var path = get_tree().current_scene.get_scene_file_path()
	for data in level_list:
		if path == data.scene.resource_path:
			data.is_completed = true
			break

func _on_exit_success() -> void:
	var path = get_tree().current_scene.get_scene_file_path()
	var found = false
	var next: LevelData = null
	for data in level_list:
		if found:
			next = data
			break
		if path == data.scene.resource_path:
			found = true
			continue
	
	if next:
		get_tree().change_scene_to_packed(next.scene)
	else:
		get_tree().change_scene_to_file("res://level/final.tscn")

func get_level_description() -> String:
	var path = get_tree().current_scene.get_scene_file_path()
	for data in level_list:
		if path == data.scene.resource_path:
			return data.display_name
	return ''
