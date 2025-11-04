@tool
extends Node2D

@export var spike_scene: PackedScene = preload("res://floor/spike.tscn")

var _line: Path2D
var _spikes: Array = []
var _cached_points: PackedVector2Array

func _ready() -> void:
	_find_line()
	if not Engine.is_editor_hint():
		_render_line()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if _cached_points != _line.curve.get_baked_points():
			for spike in _spikes:
				spike.queue_free()
			_spikes.clear()
			_render_line()

func _find_line():
	for child in get_children():
		if child is Path2D:
			_line = child
			_line.curve.bake_interval = 64

func _render_line():
	_cached_points = _line.curve.get_baked_points()
	for i in range(_cached_points.size() - 1):
		var p0 = _cached_points[i]
		var p1 = _cached_points[i + 1]
		var pMid = p0.lerp(p1, 0.5)  # create the node at the midpoint
		var spike = spike_scene.instantiate()
		spike.position = pMid
		add_child(spike)
		_spikes.push_back(spike)
