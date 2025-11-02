extends AnimatableBody2D

@export var speed: float = 300
@export var wavelength: float = 200
@export var amplitude: float = 20

var _elapsed: float = 0
var _start_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_position = position


func _physics_process(delta: float) -> void:
	_elapsed += delta
	position.y = _start_position.y + amplitude * sin((_start_position.x - _elapsed * speed) * PI / wavelength)
