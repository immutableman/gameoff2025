extends CanvasLayer

func _ready() -> void:
	EventBus.pause.connect(_on_pause)

func _on_pause():
	get_tree().paused = true
	visible = true
	$CenterContainer/VBoxContainer/Resume.grab_focus.call_deferred()
	var sfx_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(sfx_index, -10)

func _on_resume_pressed() -> void:
	var sfx_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(sfx_index, 0)
	get_tree().paused = false
	visible = false

func _on_restart_pressed() -> void:
	get_tree().paused = false
	visible = false
	EventBus.player_damaged.emit()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("pause"):
		_on_resume_pressed.call_deferred()
