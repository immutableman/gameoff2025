@tool
class_name WaveNode
extends Node

@onready var node_scene: PackedScene = preload("res://floor/wave_node.tscn")

var elapsed: float = 0

func _physics_process(delta: float) -> void:
	elapsed += delta

func alloc_node() -> WaveNode:
	return node_scene.instantiate()

func release_node(node: WaveNode):
	node.queue_free()
