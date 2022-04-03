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
	var nodes = cell.get_children()
	var node = cell.get_node("tile/tmpParent/tile")
	
	for i in range(len(nodes)):
		if nodes[i].is_visible() && nodes[i].name != "CollisionShape":
			var node_name = "tmpParent/{tile_name}".format({"tile_name": nodes[i].name})
#			print(node_name)
			node = nodes[i].get_node(node_name)
	
	if cell.is_enabled:
		node.material_override = get_tile_material(2)
	else:
		node.material_override = null	

static func get_tile_material(tile_index: int):
	return TILE_MATERIALS[tile_index]

	
