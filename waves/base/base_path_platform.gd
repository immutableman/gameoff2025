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
	var next_offset = 0
	while next_offset < line.curve.get_baked_length():
		var xform = line.curve.sample_baked_with_rotation(next_offset, true)
		var node = place_node(xform, next_offset + offset)
		line.add_child(node)
		nodes.push_back(node)
		next_offset += line.curve.bake_interval

@abstract func place_node(xform: Transform2D, node_offset: float) -> Node2D
