extends Control

@export var speed: float = 1000

func _ready() -> void:
	$Area2D/CollisionShape2D.shape.size = size
	
	# Update the CollisionShape2D's position to stay centered
	# The Control's origin is its TOP-LEFT corner.
	# The RectangleShape2D's origin is its CENTER.
	# We must move the shape by (size / 2) so its center
	# lines up with the visual's center.
	$Area2D/CollisionShape2D.position = size / 2


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.owner.add_mover(self)

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.owner.remove_mover(self)

func lerp(velocity: Vector2, delta: float) -> Vector2:
	var target_velocity = speed * Vector2.UP.rotated(rotation)
	return velocity.lerp(
		target_velocity,
		clamp(speed * delta, 0, 1) # 'state.step' is the delta time here
	)
