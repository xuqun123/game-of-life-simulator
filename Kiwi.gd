extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moving = false
export var moving_frame = 0
export var stopped = false

var rng = 0
var walk_speeds = [0, 0.002, 0.003]
var rotate_degrees = [-180, -90, 0, 90]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !stopped:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Take 001")
			
		if !moving:
			randomize()
			rng = walk_speeds[randi() % walk_speeds.size()]
			moving = true

			var rotate_degree = rotate_degrees[randi() % rotate_degrees.size()]
			rotation.y = deg2rad(int(rotate_degree))
		
		if moving_frame >= 250 || rng == 0:
			moving_frame = 0
			moving = false
		else:
			translate(Vector3(0, 0, rng))
			moving_frame += 1
