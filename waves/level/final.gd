extends Node2D

var startPos: Vector2
var delta = Vector2(240, 110)

func _ready() -> void:
	startPos = $Ocean.position

func recede():
	$Timer.start(2)
	await $Timer.timeout
	var tween = create_tween()
	tween.tween_property($%Ocean, 'position', startPos + delta, 1.6)


func _on_area_2d_body_entered(body: Node2D) -> void:
	recede()
