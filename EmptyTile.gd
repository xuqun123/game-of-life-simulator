extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("call me 111")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StaticBody_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		print(OS.get_time(), ": call me here...")


func _on_StaticBody_mouse_entered():
	pass # Replace with function body.
