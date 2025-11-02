extends Node2D

var line: Path2D

var resolution: float = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Path2D:
			line = child

	var offset = 0
	var points = line.curve.get_baked_points()
	for i in range(points.size() - 1):
		var p0 = points[i]
		var p1 = points[i + 1]
		var pMid = p0.lerp(p1, 0.5)
		var angle = p0.angle_to_point(p1)
		var node = WaveNodes.alloc_node()
		node.position = pMid
		node.rotation = angle
		node.offset = p0.distance_to(pMid) + offset
		add_child(node)
		offset += p0.distance_to(p1)
	
	#var offset = 0
	#for i in range(line.points.size() - 1):
		##create_segment(line.points[i], line.points[i + 1])
		#offset = create_segment(line.points[i], line.points[i + 1], offset)

#func create_segment(p0: Vector2, p1: Vector2, offset: float) -> float:
	#var pNext = p0
	#while pNext.x < p1.x:
		#var angle = p0.angle_to_point(p1)
		#var node = WaveNodes.alloc_node()
		#node.offset = p0.distance_to(pNext) + offset
		#node.position = pNext
		#node.rotation = angle
		#line.add_child(node)
		#pNext = pNext.move_toward(p1, 8)
	#return p0.distance_to(pNext)
