extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	var button = get_node(".")
#	button.set("custom_colors/font_color", Color.green)
	add_color_override("font_color", Color.yellow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_MuteButton_pressed():
	pass # Replace with function body.
