extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moving = false
export var moving_frame = 0
export var stopped = false
export var speed_factor = 1
export var gravity = Vector3.DOWN * 9
var velocity = Vector3.UP

var rng = 0
var walk_speeds = [0, 0.01, 0.02]
var rotate_degrees = [-180, -90, 0, 90]

var robot
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	robot = get_parent_spatial().get_node("Robot")
	grid = get_parent_spatial().get_node("HexGrid")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !stopped:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Take 001")
		
		velocity = gravity * delta
		if !moving:
			randomize()
			rng = speed_factor * walk_speeds[randi() % walk_speeds.size()]
			moving = true

			var rotate_degree = rotate_degrees[randi() % rotate_degrees.size()]
			rotation.y = deg2rad(int(rotate_degree))
		
		if moving_frame >= (250 / speed_factor) || rng == 0:
			moving_frame = 0
			moving = false
		else:
#			translate(Vector3(0, 0, rng))
			velocity += transform.basis.z * rng
			var collision = move_and_collide(velocity)
			moving_frame += 1
			
			detect_collision(collision)
	
		velocity = Vector3.DOWN

func detect_collision(collison):
	if collison and grid.started:
		var collider = collison.get_collider()
		var collison_pos = collison.get_position()

		if collider.name == "Robot":
			print(collison.get_collider_shape().get_name())
			if collison.get_local_shape().get_name() == 'HeadCollisionShape':
				print("Kiwi head hits Robot at: ", collison_pos)
				robot.kill_robot()
		
