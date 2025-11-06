extends Node2D

@export var thrust: float = 700

var external_forces: Dictionary[Node, Vector2] = {}
var net_external_force: Vector2 = Vector2.ZERO
var movers: Array[Node] = []

func get_player_position() -> Vector2:
	return $%OneWayPoint.global_position

func add_external_force(source: Node, force: Vector2):
	if source in external_forces:
		remove_external_force(source)
	external_forces[source] = force
	net_external_force += force
	$RigidBody2D.gravity_scale = 0

func remove_external_force(source: Node):
	external_forces.erase(source)
	net_external_force = Vector2.ZERO
	$RigidBody2D.gravity_scale = 1
	for remaining_source in external_forces:
		net_external_force += external_forces[remaining_source]
		$RigidBody2D.gravity_scale = 0

func add_mover(mover: Node) -> void:
	movers.push_back(mover)
	
func remove_mover(mover: Node) -> void:
	movers.erase(mover)

func _ready() -> void:
	EventBus.player_damaged.connect(_on_damaged)

func _on_damaged():
	$%EffortVFX.emitting = false
	$%DeathVFX.emitting = true
	$%DeathSFX.play()
	$RigidBody2D/Sprite2D.modulate = Color.TRANSPARENT

func _physics_process(delta: float) -> void:
	var force = Vector2.ZERO
	if Input.is_action_pressed('left'):
		force += Vector2.LEFT
	if Input.is_action_pressed('right'):
		force += Vector2.RIGHT
	$RigidBody2D.apply_central_force(force * thrust + net_external_force)

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

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body.has_method('on_player_collision'):
		body.on_player_collision(self)
