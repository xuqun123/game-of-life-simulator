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
const game_utils = preload("res://Utils.gd")

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
		
		game_utils.on_off(self)
		

