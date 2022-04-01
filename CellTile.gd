extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GAME_UTILS = preload("res://Utils.gd")

export var is_enabled := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_CellTile_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		print(OS.get_unix_time(), ": call me here... ", position)
		print("tile loc: ", self.translation)
		
		GAME_UTILS.on_off(self)
		
