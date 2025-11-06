@tool
@abstract class_name BasePathPlatform
extends Node2D

## Offset into the sine wave to start at. Set non-zero to line up with other platforms
@export var offset: float = 0

var line: Path2D
var nodes: Array = []
var cached_xform: Transform2D
var cached_points: PackedVector2Array

func _ready() -> void:
	if not Engine.is_editor_hint():
		_render_line()
	else:
		_find_line()
		for child in line.get_children():
			child.queue_free()
		line.curve = line.curve.duplicate()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_find_line()
		if _has_line_changed():
			for node in nodes:
				node.queue_free()
			nodes.clear()
			_render_line()

func _has_line_changed() -> bool:
	if not line:
		return false 
	if cached_xform != line.transform:
		return true
	if cached_points != line.curve.get_baked_points():
		return true
	return false

func _find_line():
	if line:
		return
	for child in get_children():
		if child is Path2D:
			line = child
			cached_xform = line.transform

func _render_line():
	_find_line()
	if not line:
		return
	cached_points = line.curve.get_baked_points()
	cached_xform = line.transform
	var next_offset = offset
	for i in range(cached_points.size() - 1):
		var p0 = cached_points[i]
		var p1 = cached_points[i + 1]
		var pMid = p0.lerp(p1, 0.5)  # create the node at the midpoint
		var angle = p0.angle_to_point(p1)  # node should face the next point
		var node_offset = p0.distance_to(pMid) + next_offset  # distance along the wave
		var node = place_node(pMid, angle, node_offset)
		line.add_child(node)
		nodes.push_back(node)
		next_offset += p0.distance_to(p1)

@abstract func place_node(point: Vector2, angle: float, node_offset: float) -> Node2D
