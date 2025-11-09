@tool
extends BasePathPlatform

var node_scene = preload('res://floor/spike.tscn')

func place_node(xform: Transform2D, node_offset: float) -> Node2D:
	var node = node_scene.instantiate()
	node.transform = xform
	return node
