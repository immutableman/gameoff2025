extends AnimatableBody2D

var elapsed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	elapsed += delta
	position.y = 300 + 100 * sin((position.x - elapsed * 100) * PI / 200)
