extends Area

#var robot
#var grid
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	robot = get_parent_spatial().get_node("Robot")
#	grid = get_parent_spatial().get_node("Grid")
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	if !stopped:
#		if not $AnimationPlayer.is_playing():
#			$AnimationPlayer.play("Armature miaxmo")
#
#		velocity = gravity * delta
#		if !moving:
#			randomize()
#			rng = speed_factor * walk_speeds[randi() % walk_speeds.size()]
#			moving = true
#
#			var rotate_degree = rotate_degrees[randi() % rotate_degrees.size()]
#			rotation.y = deg2rad(int(rotate_degree))
#
#		if moving_frame >= 100:
#			make_fire()
#
#		if moving_frame >= 250 || rng == 0:
#			moving_frame = 0
#			moving = false
#		else:
#			if firing:
#				if firing_frame >= 150:
#					stop_fire()
#				else:
#					firing_frame += 1
#
#			velocity += transform.basis.z * rng
#			var collision = move_and_collide(velocity)
#			moving_frame += 1
#
#			detect_collision(collision)
#
#		velocity = Vector3.DOWN
#
#func detect_collision(collison):
#	if collison and grid.started:
#		var collider = collison.get_collider()
#		var collison_pos = collison.get_position()
#
#		if collider.name == "Robot":
#			print("Godzilla hits Robot at: ", collison_pos)
#			robot.kill_robot()
#
#func make_fire():
#	$Fire.get_node("Particles").emitting = true
#	firing = true
#	if not $FireAudioPlayer.playing:
#		$FireAudioPlayer.play()
#
#
#func stop_fire():
##	print($Fire.get_node("Particles").translation)
#	$Fire.get_node("Particles").emitting = false
#	firing = false
#	firing_frame = 0


	
