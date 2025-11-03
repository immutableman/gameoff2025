extends Node2D

@export var thrust: float = 700

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var force = Vector2.ZERO
	if Input.is_action_pressed('left'):
		force += Vector2.LEFT
	if Input.is_action_pressed('right'):
		force += Vector2.RIGHT
	$RigidBody2D.apply_central_force(force * thrust)

	if force.length() > 0:
		$%EffortVFX.emitting = true
		$%EffortVFX.direction = (-force + Vector2.UP / 2).normalized()
		#$%EffortVFX.initial_velocity_min = -force.x / 2
		#$%EffortVFX.initial_velocity_max = -force.x
		$%EffortVFX.angular_velocity_min = -force.x * 360
		$%EffortVFX.angular_velocity_max = -force.x * 720
		$%EffortVFX.position.x = -force.x * 30
	else:
		$%EffortVFX.emitting = false
