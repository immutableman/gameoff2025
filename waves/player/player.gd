extends Node2D

@export var thrust: float = 500

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

func exit_level(endPos: Vector2) -> void:
	$RigidBody2D.set_deferred('freeze', true)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).tween_property($RigidBody2D, 'global_position', endPos, 0.5)
	$Friends/VictorySFX.play()
	await tween.finished
	$EndTimer.start()
	await $EndTimer.timeout
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _ready() -> void:
	EventBus.player_damaged.connect(_on_damaged)

func _on_damaged():
	$%EffortVFX.emitting = false
	$%DeathVFX.emitting = true
	$%DeathSFX.play()
	$RigidBody2D/Sprite2D.modulate = Color.TRANSPARENT
	_do_death_restart()

func _do_death_restart() -> void:
	get_tree().paused = true
	$DeathTimer.start()
	await $DeathTimer.timeout
	
	if is_inside_tree():
		get_tree().paused = false
		get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	var force = Vector2.ZERO
	if movers.size() == 0 and not $RigidBody2D.freeze:
		if Input.is_action_pressed('left'):
			force += Vector2.LEFT
		if Input.is_action_pressed('right'):
			force += Vector2.RIGHT
	$RigidBody2D.apply_central_force(net_external_force)
	$RigidBody2D.apply_force(force * thrust, $%RollTouchPoint.position)

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

	if body.name == 'Hazards':
		EventBus.player_damaged.emit()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		EventBus.pause.emit()
