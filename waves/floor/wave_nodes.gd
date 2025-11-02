extends Node

@onready var node_scene: PackedScene = preload("res://floor/wave_node.tscn")

func alloc_node():
	return node_scene.instantiate()

func release_node(node: Node):
	node.queue_free()
