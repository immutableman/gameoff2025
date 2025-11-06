extends CanvasLayer

@export var level_list: Array[LevelData]

const level_button_scene = preload("res://main_menu/level_button.tscn")

func _ready() -> void:
	for node in $%Levels.get_children():
		node.queue_free()
		
	for level in level_list:
		var btn = level_button_scene.instantiate()
		btn.set_level_data(level)
		$%Levels.add_child(btn)
