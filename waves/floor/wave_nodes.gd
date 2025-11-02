class_name WaveNode
extends Node

@onready var node_scene: PackedScene = preload("res://floor/wave_node.tscn")

func alloc_node() -> WaveNode:
	return node_scene.instantiate()

func release_node(node: WaveNode):
	node.queue_free()
