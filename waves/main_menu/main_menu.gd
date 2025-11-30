extends CanvasLayer

const level_button_scene = preload("res://main_menu/level_button.tscn")

const _audioOff = preload("res://assets/kenney/ui-pack/audioOff.png")
const _audioOn = preload("res://assets/kenney/ui-pack/audioOn.png")
	#_musicOff = preload("res://art/kenny/musicOff.png")
	#_musicOn = preload("res://art/kenny/musicOn.png")

func _ready() -> void:
	#$BGMButton.set_bus('BGM', _musicOff, _musicOn)
	$SFXButton.set_bus('SFX', _audioOff, _audioOn)

	for node in $%Levels.get_children():
		node.queue_free()
		
	for level in Levels.level_list:
		var btn = level_button_scene.instantiate()
		btn.set_level_data(level)
		$%Levels.add_child(btn)

	$%Levels.get_children()[1].set_focus()
