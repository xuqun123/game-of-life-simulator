extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var jumping = false 
export var dead = false
export (int) var jump_height = 5
export (float) var walk_speed = 0.2
export (int) var dance_frame = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(int(179.99))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not $AnimationPlayer.is_playing()):
		if dance_frame >= 2:
			$AnimationPlayer.play("Robot_Dance")
			dance_frame = 0
		else:
			$AnimationPlayer.play("Robot_Idle")
			dance_frame += 1

	get_input_keyboard(delta)	
	is_robot_dead()


func get_input_keyboard(delta):
	var current_rotation_deg = int(round(rad2deg(rotation.y)))
	
	if !dead:
		if Input.is_action_pressed("robot_move_forward"):
			if current_rotation_deg != -180:
				rotation.y = deg2rad(int(-180))
			walk_the_robot()
		if Input.is_action_pressed("robot_move_backward"):
			if current_rotation_deg != 0:
				rotation.y = deg2rad(int(0))
			walk_the_robot()
		if Input.is_action_pressed("robot_move_right"):
			if current_rotation_deg != 90:
				rotation.y = deg2rad(int(90))
			walk_the_robot()
		if Input.is_action_pressed("robot_move_left"):
			if current_rotation_deg != -90:
				rotation.y = deg2rad(int(-90))
			walk_the_robot()
		if jumping == false and Input.is_action_pressed("robot_jump"):
			print("robot loc: ", self.translation)
			jumping = true
			$JumpingPlayer.play()
			translate(Vector3(0, jump_height, 0))
			$AnimationPlayer.play("Robot_Jump")

			yield(get_tree().create_timer(0.55), "timeout")

			jumping = false
			translate(Vector3(0, -jump_height, 0))
			
func walk_the_robot():
	if not $WalkingPlayer.playing: 
		$WalkingPlayer.play()
	translate(Vector3(0, 0, walk_speed))
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
					
