extends Control

func _ready() -> void:
	$RigidBody2D/CollisionShape2D.shape.size = size
	
	# Update the CollisionShape2D's position to stay centered
	# The Control's origin is its TOP-LEFT corner.
	# The RectangleShape2D's origin is its CENTER.
	# We must move the shape by (size / 2) so its center
	# lines up with the visual's center.
	$RigidBody2D/CollisionShape2D.position = size / 2

#func _process(delta: float) -> void:
	#var player = get_tree().get_first_node_in_group('player')
	#$RigidBody2D/CollisionShape2D.disabled = (player.get_player_position().y >= global_position.y)

#func _on_rigid_body_2d_body_entered(body: Node) -> void:
	#body.apply_impulse(Vector2.UP * 100)
