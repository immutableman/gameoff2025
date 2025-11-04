@tool
extends BasePathPlatform

var node_scene = preload('res://floor/spike.tscn')

func place_node(point, angle) -> Node2D:
	var node = node_scene.instantiate()
	node.position = point
	node.rotation = angle
	return node
