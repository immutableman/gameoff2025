extends Node2D

@export var thrust: float = 700

var external_forces: Vector2 = Vector2.ZERO
var movers: Array[Node] = []

func get_player_position() -> Vector2:
	return $%OneWayPoint.global_position

func add_external_force(force: Vector2):
	external_forces += force

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
	$RigidBody2D.apply_central_force(force * thrust + external_forces)

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
