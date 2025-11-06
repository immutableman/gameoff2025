extends Control

@export var level_list: Array[LevelData]



func _ready() -> void:
	for node in $%Levels.get_children():
		node.queue_free()
	for level in level_list:
		pass
