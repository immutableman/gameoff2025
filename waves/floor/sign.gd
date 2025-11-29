@tool

extends Area2D

@export var texture = preload("res://assets/sign_info.tres"):
	set(new_value):
		texture = new_value
		$Sprite2D.texture = texture


func _on_body_entered(body: Node2D) -> void:
	print('enter')

func _on_body_exited(body: Node2D) -> void:
	print('exit')
