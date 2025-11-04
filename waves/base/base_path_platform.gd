@tool
extends Node2D
class_name BasePathPlatform

@export var node_scene: PackedScene

var line: Path2D
var nodes: Array = []
var cached_xform: Transform2D
var cached_points: PackedVector2Array

func _ready() -> void:
	if not Engine.is_editor_hint():
		_render_line()

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
	for i in range(cached_points.size() - 1):
		var p0 = cached_points[i]
		var p1 = cached_points[i + 1]
		var pMid = p0.lerp(p1, 0.5)  # create the node at the midpoint
		var angle = p0.angle_to_point(p1)  # node should face the next point
		var node = node_scene.instantiate()
		node.position = pMid
		node.rotation = angle
		line.add_child(node)
		nodes.push_back(node)
