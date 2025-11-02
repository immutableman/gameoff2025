extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var force = Vector2.ZERO
	if Input.is_action_pressed('left'):
		force += Vector2.LEFT * 200
	if Input.is_action_pressed('right'):
		force += Vector2.RIGHT * 200
	$RigidBody2D.apply_central_force(force)

	if force.length() > 0:
		$%EffortVFX.emitting = true
		$%EffortVFX.initial_velocity_min = -force.x
		$%EffortVFX.initial_velocity_max = -force.x
		$%EffortVFX.position.x = -force.x / 5
	else:
		$%EffortVFX.emitting = false
