extends Button

var _bus_idx: int
var _off
var _on

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
