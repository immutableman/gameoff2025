@tool
extends Area2D

@export var text: String = ''

@export var texture = preload("res://assets/sign_info.tres"):
	set(new_value):
		texture = new_value
		$Sprite2D.texture = texture


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('enter_range'):
		body.enter_range(self)
		$Hint.visible = true
		$Hint.scale = Vector2(0.5, 0.5)
		var tween = create_tween()
		tween.tween_property($Hint, 'scale', Vector2.ONE, .1)

func _on_body_exited(body: Node2D) -> void:
	if body.has_method('exit_range'):
		body.exit_range(self)
		var tween = create_tween()
		tween.tween_property($Hint, 'scale', Vector2(.5,.5), .1)
		await tween.finished
		$Hint.visible = false

func get_text() -> String:
	return text
