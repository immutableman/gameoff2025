extends Node2D

const MAX_SPEED_FOR_ANIM = 500
const MAX_PLAYRATE_FOR_ANIM = 2.5
const MAX_ROTATION_DEGREES = 15
const BOB_HEIGHT: float = 5.0 # How much the sprite bobs up and down
const BOB_DURATION: float = .5 # How long one full bob cycle takes

@export var thrust: float = 500

var external_forces: Dictionary[Node, Vector2] = {}
var net_external_force: Vector2 = Vector2.ZERO
var movers: Array[Node] = []

#var _bob_tween: Tween

func _ready() -> void:
	EventBus.player_damaged.connect(_on_damaged)
	$%FishAnim.play('run')

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

func exit_level_success(endPos: Vector2) -> void:
	Levels.mark_complete()
	$RigidBody2D.set_deferred('freeze', true)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).tween_property($RigidBody2D, 'global_position', endPos, 0.5)
	$Friends/VictorySFX.play()
	await tween.finished
	$EndTimer.start()
	await $EndTimer.timeout
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_damaged():
	set_deferred('process_mode', Node.PROCESS_MODE_DISABLED)
	$RigidBody2D.set_deferred('freeze', true)
	$%EffortVFX.emitting = false
	$%DeathVFX.emitting = true
	$%DropsLeftVFX.emitting = true
	$%DropsRightVFX.emitting = true
	$%DeathSFX.play()
	$RigidBody2D/BallSprite2D.visible = false
	$Friends/BallmarkSprite2D.visible = false
	$Friends/FishAnim.visible = false
	$DeathBody.position = $RigidBody2D.position
	$DeathBody.linear_velocity = $RigidBody2D.linear_velocity
	$DeathBody.angular_velocity = $RigidBody2D.angular_velocity
	$DeathBody.visible = true
	$DeathBody.process_mode = Node.PROCESS_MODE_ALWAYS
	_do_death_restart()

func _do_death_restart() -> void:
	#get_tree().paused = true
	$DeathTimer.start()
	await $DeathTimer.timeout
	
	if is_inside_tree():
		#get_tree().paused = false
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if not $Friends/FishAnim.visible:
		return

	var speed_factor = clamp(abs($RigidBody2D.linear_velocity.x / MAX_SPEED_FOR_ANIM), 0, 1)
	$%FishAnim.speed_scale = lerp(0.0, MAX_PLAYRATE_FOR_ANIM, abs(speed_factor))
	if Input.is_action_pressed('left'):
		$%FishAnim.flip_h = false
	elif Input.is_action_pressed('right'):
		$%FishAnim.flip_h = true
	elif $RigidBody2D.linear_velocity.x > 0:
		$%FishAnim.flip_h = true
	elif $RigidBody2D.linear_velocity.x < 0:
		$%FishAnim.flip_h = false

	var t = clamp(speed_factor*8, 0, 1)
	if $RigidBody2D.linear_velocity.x > 10:
		# alt: fixed rotation over time
		#$%FishAnim.rotation_degrees = move_toward($%FishAnim.rotation_degrees, MAX_ROTATION_DEGREES, speed_factor)
		$%FishAnim.rotation_degrees = lerp(0, MAX_ROTATION_DEGREES, t)  # rotation by speed
	elif $RigidBody2D.linear_velocity.x < -10:
		#$%FishAnim.rotation_degrees = move_toward($%FishAnim.rotation_degrees, -MAX_ROTATION_DEGREES, speed_factor)
		$%FishAnim.rotation_degrees = lerp(0, -MAX_ROTATION_DEGREES, t)  # rotation by speed
	else:
		if not Input.is_action_pressed('left') and not Input.is_action_pressed('right'):
			$%FishAnim.rotation_degrees = move_toward($%FishAnim.rotation_degrees, 0, 1)

	#if speed_factor > 0.01:
		#if not _bob_tween:
			#_bob_tween = create_tween()
			#_bob_tween.tween_property($%FishAnim, "position:y", -BOB_HEIGHT, BOB_DURATION / 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			#_bob_tween.tween_property($%FishAnim, "position:y", 0, BOB_DURATION / 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			#_bob_tween.set_loops()
	#else:
		#if _bob_tween:
			#$%FishAnim.position.y = 0
			#_bob_tween.stop()
			#_bob_tween = null


func _physics_process(delta: float) -> void:
	if not $Friends/FishAnim.visible:
		return

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
	elif event.is_action_pressed("interact"):
		if $RigidBody2D.interactables.size() > 0:
			# TODO maybe make this generalized
			var text = $RigidBody2D.interactables.back().get_text()
			EventBus.show_dialog.emit(text)
