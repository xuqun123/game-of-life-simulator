extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var moving = false
export var moving_frame = 0
export var stopped = false
export var speed_factor = 1
export var gravity = Vector3.FORWARD * 2

export var arrow_rotate_x = -20
export var arrow_velocities_x = [2.5, 5]
export var arrow_speed = 5

var velocity = Vector3.UP
var rotation_degree = 0

var rng = 0
var walk_speeds = [0.05, 0.1]
var rotate_degrees = [-180, -90, 0, 90]
var last_rotate_degree = rotate_degrees[randi() % rotate_degrees.size()]

var shooting_frame = 0
var shooting = false
var shooting_velocity = Vector3.ZERO

var robot
var grid
var shooting_arrow

# Called when the node enters the scene tree for the first time.
func _ready():	
	robot = get_parent_spatial().get_node("Robot")
	grid = get_parent_spatial().get_node("Grid")
	shooting_arrow = $ShootingArrow

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !stopped:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Rotate")
		
		if shooting:
			if shooting_frame >= (2 / speed_factor):
				shoot(delta)
				shooting_frame = 0

			shooting_frame += 1
			
		else:
			velocity = gravity * delta
			if !moving:
				randomize()
				rng = speed_factor * walk_speeds[randi() % walk_speeds.size()]
				moving = true

				var rotate_degrees_list = rotate_degrees.duplicate()
				rotate_degrees_list.erase(last_rotate_degree)
				var rotate_degree = rotate_degrees_list[randi() % rotate_degrees_list.size()]
				rotation.y = deg2rad(int(rotate_degree))
				last_rotate_degree = rotate_degree
			
			if (moving_frame >= (250 / speed_factor) || rng == 0):
				moving_frame = 0
				moving = false
				
				$AnimationPlayer.stop()
				shoot(delta)
			else:
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
			if collison.get_local_shape().get_name() == 'HeadCollisionShape':
				print("Kiwi head hits Robot at: ", collison_pos)
				robot.kill_robot()
		
func shoot(delta):
	if !shooting:
		shooting = true
		$AnimationPlayer.play("Fire")
		
		shooting_arrow.global_transform = global_transform
		shooting_arrow.translation.y += 0.3
		shooting_arrow.rotation.x = deg2rad(arrow_rotate_x)
		shooting_arrow.visible = true
	
		rotation_degree = round(rad2deg(rotation.y))
		var arrow_velocity_x = arrow_velocities_x[randi() % arrow_velocities_x.size()]
		
		if rotation_degree == -180:
			shooting_velocity = Vector3(arrow_velocity_x, -1, 0) * delta * arrow_speed
		elif rotation_degree == 0:
			shooting_velocity = Vector3(0, -1, -arrow_velocity_x) * delta * arrow_speed
		elif rotation_degree == 180:
			shooting_velocity = Vector3(0, -1, arrow_velocity_x) * delta * arrow_speed
		elif rotation_degree == -90:
			shooting_velocity = Vector3(arrow_velocity_x, -1, 0) * delta * arrow_speed
		elif rotation_degree == 90:
			shooting_velocity = Vector3(-arrow_velocity_x, -1, 0) * delta * arrow_speed
		
	var collision = shooting_arrow.move_and_collide(shooting_velocity)
	arrow_detect_collision(collision)
	
func arrow_detect_collision(collision):
	if collision:
		var collider = collision.get_collider()
		var collision_pos = collision.get_position()
		
		if collider.name == "Robot":
			print(collision.get_collider_shape().get_name())
			print("Arrow hits Robot at: ", collision_pos)
			reset_bow()
			
			if grid.started:
				robot.kill_robot()
		elif collider.name && collider.name != "ArmedUFO":
			reset_bow()

func reset_bow():
	shooting = false
	shooting_arrow.visible = false
