extends Area2D

func _on_body_entered(body: Node2D) -> void:
	EventBus.pickup_key.emit()
	$SFX_Pickup.play()
	visible = false
	set_deferred("monitoring", false)
