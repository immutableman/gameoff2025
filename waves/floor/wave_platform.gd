extends Node2D

var line: Line2D

var resolution: float = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Line2D:
			line = child
	
	for i in range(line.points.size() - 1):
		create_segment(line.points[i], line.points[i + 1])

func create_segment(p0: Vector2, p1: Vector2) -> void:
	var node = WaveNodes.alloc_node()
	node.position = p0
	#p0.move_toward(p1, 8)
	add_child(node)
