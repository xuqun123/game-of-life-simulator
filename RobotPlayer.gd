extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var jumping = false 
export var dead = false
export (int) var jump_height = 5
export (float) var walk_speed = 0.2
export (int) var dance_frame = 0

export var gravity = Vector3.DOWN * 9
var velocity = Vector3.ZERO
export var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	print(int(179.99))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(not $AnimationPlayer.is_playing()):
		if dance_frame >= 2:
			$AnimationPlayer.play("Robot_Dance")
			dance_frame = 0
		else:
			$AnimationPlayer.play("Robot_Idle")
			dance_frame += 1
			
	velocity += gravity * delta
	get_input_keyboard(delta)	
	
	if (velocity.z != 0):
		walk_the_robot()
	velocity = Vector3.DOWN

	is_robot_dead()

func get_input_keyboard(delta):
	var vy = velocity.y

	if !dead:
		if Input.is_action_pressed("robot_move_forward"):
			set_velocity_with_rotate(-180)
		if Input.is_action_pressed("robot_move_backward"):
			set_velocity_with_rotate(0)
		if Input.is_action_pressed("robot_move_right"):
			set_velocity_with_rotate(90)
		if Input.is_action_pressed("robot_move_left"):
			set_velocity_with_rotate(-90)
			
		if jumping == false and Input.is_action_pressed("robot_jump"):
			print("robot location: ", self.translation)
			jumping = true
			$JumpingPlayer.play()
			$AnimationPlayer.play("Robot_Jump")
			
			velocity += transform.basis.y * speed * 1.5
			move_and_collide(velocity, false)
			
			yield(get_tree().create_timer(0.5), "timeout")
			
			velocity -= transform.basis.y * speed * 1.5
			move_and_collide(velocity, false)
			jumping = false

		velocity.y = vy

func set_velocity_with_rotate(degree):
	var current_rotation_deg = int(round(rad2deg(rotation.y)))	
	if current_rotation_deg != degree:
		rotation.y = deg2rad(int(degree))
#		$Camera.rotation.y = deg2rad(int(degree))
		
	velocity += transform.basis.z * speed
		
func walk_the_robot():
	if not $WalkingPlayer.playing: 
		$WalkingPlayer.play()
#	translate(Vector3(0, 0, walk_speed))
	move_and_collide(velocity, false)
	$AnimationPlayer.play("Robot_Walking")
	
func is_robot_dead():
	if !dead && !jumping:
		var hex_grid = get_parent_spatial().get_node("HexGrid")
		if hex_grid.started:
			var cells = hex_grid.get_children()
			
			for i in range(len(cells)):
				if cells[i].is_enabled == true:

					if round(translation.x) == round(cells[i].translation.x) and \
						round(translation.y) == round(cells[i].translation.y) and \
						round(translation.z) == round(cells[i].translation.z):
							hex_grid.started = false
							$AnimationPlayer.play("Robot_Death")
							if not $DeathPlayer.playing: 
								$DeathPlayer.play()
							dead = true
							yield(get_tree().create_timer(0.5), "timeout")
							self.hide()
							hex_grid.started = true
					
