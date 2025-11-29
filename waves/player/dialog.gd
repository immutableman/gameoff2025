extends CanvasLayer

var _open: bool = false

func _ready() -> void:
	EventBus.show_dialog.connect(_on_show)


func set_text(text) -> void:
	$Panel/Label.text = text

func _on_show(text: String):
	_open = true
	set_text(text)
	visible = true
	get_tree().paused = true
	var tween = create_tween()
	tween.tween_property($Panel, 'modulate', Color.WHITE, 0.1)

func _unhandled_input(event: InputEvent) -> void:
	if _open:
		if event.is_action_pressed("interact"):
			var tween = create_tween()
			tween.tween_property($Panel, 'modulate', Color.TRANSPARENT, 0.1)
			await tween.finished
			visible = false
			get_tree().paused = false
			_open = false
