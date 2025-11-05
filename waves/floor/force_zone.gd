extends Control

@export var thrust: float = 1000

func _ready() -> void:
	$Area2D/CollisionShape2D.shape.size = size
	
	# Update the CollisionShape2D's position to stay centered
	# The Control's origin is its TOP-LEFT corner.
	# The RectangleShape2D's origin is its CENTER.
	# We must move the shape by (size / 2) so its center
	# lines up with the visual's center.
	$Area2D/CollisionShape2D.position = size / 2


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.owner.add_external_force(thrust * Vector2.UP)

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.owner.add_external_force(thrust * Vector2.DOWN)
