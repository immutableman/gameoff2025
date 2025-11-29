extends CanvasLayer

func _ready() -> void:
	EventBus.pause.connect(_on_pause)


func _on_pause():
	get_tree().paused = true
	visible = true


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_restart_pressed() -> void:
	get_tree().paused = false
	visible = false
	EventBus.player_damaged.emit()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
