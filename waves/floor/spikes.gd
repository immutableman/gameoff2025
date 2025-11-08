@tool
extends BasePathPlatform

var node_scene = preload('res://floor/spike.tscn')

func place_node(point: Vector2, angle: float, node_offset: float) -> Node2D:
	var node = node_scene.instantiate()
	node.position = point
	node.rotation = angle
	return node

func place_node2(xform: Transform2D, node_offset: float) -> Node2D:
	var node = node_scene.instantiate()
	node.transform = xform
	return node
