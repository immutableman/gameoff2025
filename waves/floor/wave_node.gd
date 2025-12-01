extends AnimatableBody2D

@export var speed: float = 3
@export var wavelength: float = 200
@export var amplitude: float = 40
@export var offset: float = 0

var _start_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_position = position

func _physics_process(delta: float) -> void:
	var up = transform.basis_xform(Vector2.UP)
	var wave_delta = amplitude * sin((offset - WaveNodes.elapsed * speed) * PI / wavelength)
	position = _start_position + up * wave_delta
