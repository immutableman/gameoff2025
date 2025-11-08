@tool
extends BasePathPlatform

@export var speed: float = 300
@export var wavelength: float = 200
@export var amplitude: float = 40
@export var amplitude_curve: Curve

func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint() and amplitude_curve:
		amplitude_curve = amplitude_curve.duplicate(true)

func place_node2(xform: Transform2D, node_offset: float) -> Node2D:
	var node = WaveNodes.alloc_node()
	node.transform = xform
	node.speed = speed
	node.wavelength = wavelength
	node.offset = node_offset

	var t = (node_offset - offset) / line.curve.get_baked_length()
	if amplitude_curve:
		node.amplitude = amplitude * amplitude_curve.sample(t)
	else:
		node.amplitude = amplitude
	return node

func place_node(point: Vector2, angle: float, node_offset: float) -> Node2D:
	var node = WaveNodes.alloc_node()
	node.position = point
	node.rotation = angle
	node.speed = speed
	node.wavelength = wavelength
	node.offset = node_offset

	var t = (node_offset - offset) / line.curve.get_baked_length()
	if amplitude_curve:
		node.amplitude = amplitude * amplitude_curve.sample(t)
	else:
		node.amplitude = amplitude
	return node


#var line: Path2D
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for child in get_children():
		#if child is Path2D:
			#line = child
#
	#var length = line.curve.get_baked_length()
#
	#var points = line.curve.get_baked_points()
	#for i in range(points.size() - 1):
		#var p0 = points[i]
		#var p1 = points[i + 1]
		#var pMid = p0.lerp(p1, 0.5)  # create the node at the midpoint
		#var angle = p0.angle_to_point(p1)  # node should face the next point
		#var node = WaveNodes.alloc_node()
		#node.position = pMid
		#node.rotation = angle
		#node.speed = speed
		#node.wavelength = wavelength
		#var t = offset / length
		#if amplitude_curve:
			#node.amplitude = amplitude * amplitude_curve.sample(t)
		#else:
			#node.amplitude = amplitude
		#node.offset = p0.distance_to(pMid) + offset  # distance along the wave
		#add_child(node)
		#offset += p0.distance_to(p1)  # update the cumulative offset
