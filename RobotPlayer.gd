extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var jumping = false 
export var dead = false
export (int) var jump_height = 5
export (int) var dance_frame = 0
export (int) var speed = 5

export var gravity = Vector3.DOWN * 9
var velocity = Vector3.ZERO


var score = 0
var highest_score = 0
var score_frame = 0

var hex_grid
var score_board

# Called when the node enters the scene tree for the first time.
func _ready():
	hex_grid = get_parent_spatial().get_node("HexGrid")
	score_board = get_parent_spatial().get_node("ScoreBoard")
	set_score(score, highest_score)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(not $AnimationPlayer.is_playing()):
		if dance_frame >= 2:
			$AnimationPlayer.play("Robot_Dance")
			dance_frame = 0
		else:
			$AnimationPlayer.play("Robot_Idle")
			dance_frame += 1
		print()
			
	velocity += gravity * delta
	get_input_keyboard(delta)	
	
	if (velocity.z != 0):
		walk_the_robot()
	velocity = Vector3.DOWN
	
	if hex_grid.started && !dead && score_frame >= hex_grid.run_speed:
		score += 1 + hex_grid.enabled_cells_count * 0.1 
		set_score(score, highest_score)
		score_frame = 0

	score_frame += 1
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
			
			velocity += transform.basis.y * speed * 1.4
			move_and_collide(velocity, false)
			
			yield(get_tree().create_timer(0.5), "timeout")
			
			velocity -= transform.basis.y * speed * 1.4
			move_and_collide(velocity, false)
			jumping = false

		velocity.y = vy

func set_velocity_with_rotate(degree):
	if $Camera.enabled:
		$Camera.make_current()
	var current_rotation_deg = int(round(rad2deg(rotation.y)))	
	if current_rotation_deg != degree:
		rotation.y = deg2rad(int(degree))
#		$Camera.set_rota
		
	velocity += transform.basis.z * speed * (50.0 / hex_grid.run_speed )
		
func walk_the_robot():
	if not $WalkingPlayer.playing: 
		$WalkingPlayer.play()
	$AnimationPlayer.play("Robot_Walking")
	
	var collison = move_and_collide(velocity, false)
	detect_collision(collison)
	
func is_robot_dead():
	if !dead && !jumping:
		if hex_grid.started:
			var cells = hex_grid.get_children()
			
			for i in range(len(cells)):
				if cells[i].is_enabled == true:

					if round(translation.x) == round(cells[i].translation.x) and \
						round(translation.y) == round(cells[i].translation.y) and \
						round(translation.z) == round(cells[i].translation.z):
							kill_robot()
					
func detect_collision(collision):
	if collision and hex_grid.started:
		var collider = collision.get_collider()
		var collision_pos = collision.get_position()
		
		if collider.name == "Fox":
			if collision.get_collider_shape().get_name() == 'HeadCollisionShape':
				print("Robot hits Fox head at: ", collision_pos)
				kill_robot()
		elif collider.name == "Kiwi":
			if collision.get_collider_shape().get_name() == 'HeadCollisionShape':
				print("Robot hits Kiwi head at: ", collision_pos)
				kill_robot()
		elif collider.name == "Godzilla":
			print("Robot hits Godzilla at: ", collision_pos)
			kill_robot()
		elif collider.name == "FiringArea":
			print("Robot hits Godzilla fire at: ", collision_pos)
			kill_robot()
		
func reset():
	self.visible = true
	self.dead = false
	set_physics_process(true)
	$CollisionShape.disabled = false
	
	score = 0
	set_score(score, highest_score)
	
func kill_robot():
	if !dead && !jumping:
		hex_grid.started = false
		if not $DeathPlayer.playing:
			$DeathPlayer.play()
		$AnimationPlayer.play("Robot_Death")
		
		$Explosion.get_node("AnimationPlayer").play("Animation")
			
		dead = true
		yield(get_tree().create_timer(0.5), "timeout")
		
		self.visible = false
		set_physics_process(false)
		$CollisionShape.disabled = true
		if highest_score < score:
			set_score(score, score)
		
		hex_grid.started = true
		
func set_score(new_score, new_highest_score):
	score = new_score
	highest_score = new_highest_score
	
	score_board.text = "Score: {score}\nHighest Score: {highest_score}".format({"score": score, "highest_score": highest_score})
