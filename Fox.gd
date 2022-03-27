extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moving = false
export var moving_frame = 0
export var stopping_frame = 0
export var stopped = false

var rng = 0
var walk_speeds = [0, 10, 20]
var rotate_degrees = [-180, -90, 0, 90]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !stopped:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Armature|Cinematic001")
				
		if stopping_frame >= 150:
			stopping_frame = 0
			moving_frame = 0
			moving = false
		
		if !moving:
			randomize()
			rng = walk_speeds[randi() % walk_speeds.size()]
			moving = true

			var rotate_degree = rotate_degrees[randi() % rotate_degrees.size()]
			rotation.y = deg2rad(int(rotate_degree))
		
		if moving_frame >= 250 || rng == 0:
			$AnimationPlayer.play("Armature|Cinematic001")	
			stopping_frame += 1
		else:
			translate(Vector3(0, 0, rng))
			$AnimationPlayer.play("Armature|walk_cycle")
			moving_frame += 1
