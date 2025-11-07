extends Area2D


func _on_body_entered(body: Node2D) -> void:
	# TODO move this into the player
	body.set_collision_layer_value(1, false)
	body.gravity_scale = 0
	$EndTimer.start()
	await $EndTimer.timeout
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
