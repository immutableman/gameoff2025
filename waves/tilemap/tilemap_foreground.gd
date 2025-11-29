extends TileMapLayer

func _ready() -> void:
	EventBus.pickup_key.connect(_on_pickup_key)

func _on_pickup_key() -> void:
	erase_all_tiles(Vector2i(11, 4))

func erase_all_tiles(atlas_coords: Vector2i):
	# Get all cells that use the specific old tile type
	var cells_to_change = get_used_cells_by_id(-1, atlas_coords)

	# Iterate through the list of cell coordinates
	for cell_coords in cells_to_change:
		erase_cell(cell_coords)

	# Force a visual update if necessary (usually automatic at end of frame)
	# update_internals() # Uncomment if changes don't appear immediately
