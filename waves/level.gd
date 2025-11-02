extends Node2D

var node_pool: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(100):
		var node = load('res://floor/wave_node.tscn').instantiate()
		node.position = Vector2(100 + i*8, 300)
		node_pool.push_back(node)
		add_child(node)
