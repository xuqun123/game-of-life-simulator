extends Node

const TILE_MATERIALS = [
	preload("res://blue.tres"),
	preload("res://green.tres"),
	preload("res://red.tres"),
	preload("res://yellow.tres"),
]

static func plus(x, y):
	return x + y
		
static func on_off(cell):
	cell.is_enabled = !cell.is_enabled
	var node = cell.get_node("unit_tile/tmpParent/tile")
	
	if cell.is_enabled:
		node.material_override = get_tile_material(2)
	else:
		node.material_override = null	

static func get_tile_material(tile_index: int):
	return TILE_MATERIALS[tile_index]

	
