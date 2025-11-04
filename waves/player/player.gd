extends Node2D

@export var thrust: float = 700

func _ready() -> void:
	EventBus.player_damaged.connect(_on_damaged)

func _on_damaged():
	$%EffortVFX.emitting = false
	$%DeathVFX.emitting = true
	$RigidBody2D/Sprite2D.modulate = Color.TRANSPARENT

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
