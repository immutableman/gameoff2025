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

func place_node(xform: Transform2D, node_offset: float) -> Node2D:
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
