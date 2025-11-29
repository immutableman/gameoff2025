extends Control

@export var thrust: float = 500


func _ready() -> void:
	if Engine.is_editor_hint():
		$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate(true)
	
	$Area2D/CollisionShape2D.shape.size = size
	
	# Update the CollisionShape2D's position to stay centered
	# The Control's origin is its TOP-LEFT corner.
	# The RectangleShape2D's origin is its CENTER.
	# We must move the shape by (size / 2) so its center
	# lines up with the visual's center.
	$Area2D/CollisionShape2D.position = size / 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.owner.add_external_force(self, thrust * Vector2.UP.rotated(rotation))


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.owner.remove_external_force(self)
