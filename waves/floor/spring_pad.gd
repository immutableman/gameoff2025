extends Control

@export var speed: float = 1500
@export var seconds_to_max_speed: float = 0.1

var initial_velocity = Vector2()

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
	initial_velocity = Vector2.ZERO
	body.owner.add_mover(self)
	$LockoutTimer.start()
	await $LockoutTimer.timeout
	body.owner.remove_mover(self)
	initial_velocity = Vector2.ZERO

func calc_mover_velocity(velocity: Vector2, delta: float) -> Vector2:
	if initial_velocity.is_zero_approx():
		var dir = Vector2.UP.rotated(rotation)
		var projection_a_on_b = dir * velocity.dot(dir)
		var orthogonal_component = velocity - projection_a_on_b
		initial_velocity = orthogonal_component
	var target_velocity = initial_velocity + speed * Vector2.UP.rotated(rotation)
	#var target_velocity = speed * Vector2.UP.rotated(rotation)
	var elapsed = $LockoutTimer.wait_time - $LockoutTimer.time_left
	var t = clamp(elapsed / seconds_to_max_speed, 0, 1)
	return velocity.lerp(target_velocity, t)
