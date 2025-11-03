extends Node2D

@export var speed: float = 300
@export var wavelength: float = 200
@export var amplitude: float = 40
@export var offset: float = 0

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
		node.speed = speed
		node.wavelength = wavelength
		node.amplitude = amplitude
		node.offset = p0.distance_to(pMid) + offset
		add_child(node)
		offset += p0.distance_to(p1)
