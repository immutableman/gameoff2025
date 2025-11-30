extends Button

const _audioOff = preload("res://assets/kenney/ui-pack/audioOff.png")
const _audioOn = preload("res://assets/kenney/ui-pack/audioOn.png")

var _bus_idx: int
var _off
var _on

func _ready() -> void:
	set_bus('SFX', _audioOff, _audioOn)

# Called when the node enters the scene tree for the first time.
func set_bus(bus: String, off, on) -> void:
	_bus_idx = AudioServer.get_bus_index(bus)
	_off = off
	_on = on
	var vol = AudioServer.get_bus_volume_linear(_bus_idx)
	if vol > 0:
		icon = _on
	else:
		icon = _off
	connect('pressed', _toggle)

func _toggle():
	var vol = AudioServer.get_bus_volume_linear(_bus_idx)
	if vol > 0:
		AudioServer.set_bus_volume_linear(_bus_idx, 0)
		icon = _off
	else:
		AudioServer.set_bus_volume_linear(_bus_idx, 1)
		icon = _on
