extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(100):
		var node = WaveNodes.alloc_node()
		node.position = Vector2(100 + i*8, 300)
		add_child(node)
