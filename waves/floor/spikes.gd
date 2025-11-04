@tool
extends BasePathPlatform

var _line: Path2D
var _spikes: Array = []
var _cached_xform: Transform2D
var _cached_points: PackedVector2Array

func _ready() -> void:
	if not Engine.is_editor_hint():
		_render_line()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_find_line()
		if _has_line_changed():
			for spike in _spikes:
				spike.queue_free()
			_spikes.clear()
			_render_line()

func _has_line_changed() -> bool:
	if not _line:
		return false 
	if _cached_xform != _line.transform:
		return true
	if _cached_points != _line.curve.get_baked_points():
		return true
	return false

func _find_line():
	if _line:
		return
	for child in get_children():
		if child is Path2D:
			_line = child
			_cached_xform = _line.transform
			_line.curve.bake_interval = 64

func _render_line():
	_find_line()
	if not _line:
		return
	_cached_points = _line.curve.get_baked_points()
	_cached_xform = _line.transform
	for i in range(_cached_points.size() - 1):
		var p0 = _cached_points[i]
		var p1 = _cached_points[i + 1]
		var pMid = p0.lerp(p1, 0.5)  # create the node at the midpoint
		var spike = node_scene.instantiate()
		spike.position = pMid
		_line.add_child(spike)
		_spikes.push_back(spike)
