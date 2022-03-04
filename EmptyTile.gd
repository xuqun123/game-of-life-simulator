extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const TILE_MATERIALS = [
	preload("res://blue.tres"),
	preload("res://green.tres"),
	preload("res://red.tres"),
	preload("res://yellow.tres"),
]

export var is_enabled := false
# Called when the node enters the scene tree for the first time.
func _ready():
	print("the tile is ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StaticBody_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		print(OS.get_unix_time(), ": call me here... ", position)
		var node = self.get_node("unit_tile/tmpParent/tile")
		
		is_enabled = !is_enabled
		if is_enabled:
			node.material_override = get_tile_material(2)
		else:
			node.material_override = null

func _on_StaticBody_mouse_entered():
	pass # Replace with function body.

func get_tile_material(tile_index: int):
	return TILE_MATERIALS[tile_index]
