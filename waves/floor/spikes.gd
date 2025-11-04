@tool
extends Node2D

var _line: Path2D
var _spikes: Array = []

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		_render_line()

func _ready() -> void:
	if not Engine.is_editor_hint():
		_render_line()

func _render_line():
	# TODO cache better
	for spike in _spikes:
		spike.queue_free()
	_spikes.clear()
	
	for child in get_children():
		if child is Path2D:
			_line = child
			_line.curve.bake_interval = 64

	var node_scene = load("res://floor/spike.tscn")

	var points = _line.curve.get_baked_points()
	for i in range(points.size() - 1):
		var p0 = points[i]
		var p1 = points[i + 1]
		var pMid = p0.lerp(p1, 0.5)  # create the node at the midpoint
		var spike = node_scene.instantiate()  # TEMP
		spike.position = pMid
		add_child(spike)
		_spikes.push_back(spike)
