extends Node2D

var startPos: Vector2
const delta = Vector2(220, 110)

var signPos: Vector2
const signDelta: float = 256

func _ready() -> void:
	startPos = $Ocean.position
	signPos = $%FinalSign.position
	$%FinalSign.position = signPos + delta * $FinalSign.transform.y

func recede():
	$Timer.start(2)
	await $Timer.timeout
	var tween = create_tween()
	tween.tween_property($%Ocean, 'position', startPos + delta, 1.6)
	await tween.finished
	$Label2.modulate = Color.TRANSPARENT
	$Label2.visible = true
	tween = create_tween()
	tween.tween_property($Label2, 'modulate', Color.WHITE, 0.8)
	await tween.finished
	tween = create_tween()
	tween.tween_property($%FinalSign, 'position', signPos, 2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Area2D.call_deferred('queue_free')
	recede()
