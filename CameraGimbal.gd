extends Spatial

export (NodePath) var target

export (float, 0.0, 2.0) var rotation_speed = PI/2

# mouse properties
export (bool) var mouse_control = false
export (float, 0.001, 0.1) var mouse_sensitivity = 0.005
export (bool) var invert_y = false
export (bool) var invert_x = false

# movement settings
export (float) var move_rate = 0.2

# zoom settings
export (float) var max_zoom = 4
export (float) var min_zoom = 0.1
export (float, 0.05, 1.0) var zoom_speed = 0.09

var zoom = 1.5

func _unhandled_input(event):
	if !event is InputEventMouseButton || event.button_index != BUTTON_RIGHT:
		return
	print("Mouse right click event", event.as_text())
	
	var x_rotation = 0
	if event.is_action_pressed("cam_up"):
		x_rotation += 1
		x_rotation = -x_rotation if invert_y else x_rotation
		$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed)
	if event.is_action_pressed("cam_zoom_in"):
		zoom += zoom_speed
	if event.is_action_pressed("cam_zoom_out"):
		zoom -= zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
	if mouse_control and event is InputEventMouseMotion:
		if event.relative.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var dir = 1 if invert_y else -1
			var y_rotation = clamp(event.relative.y, -30, 30)
			$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)

func get_input_keyboard(delta):
	# Rotate outer gimbal around y axis
	var y_rotation = 0
	if Input.is_action_pressed("cam_right"):
		$InnerGimbal/Camera.make_current()
		y_rotation += -1
	if Input.is_action_pressed("cam_left"):
		$InnerGimbal/Camera.make_current()
		y_rotation += +1
	rotate(Vector3.RIGHT, y_rotation * rotation_speed * delta)
	
	if Input.is_action_pressed("move_right"):
		$InnerGimbal/Camera.make_current()
		global_translate(Vector3(move_rate, 0, 0))
		
	if Input.is_action_pressed("move_left"):
		$InnerGimbal/Camera.make_current()
		global_translate(Vector3(-move_rate, 0, 0))
		
	# Rotate inner gimbal around local x axis
	var x_rotation = 0
	if Input.is_action_pressed("move_forward"):
		$InnerGimbal/Camera.make_current()
		global_translate(Vector3(0, 0, -move_rate))
	if Input.is_action_pressed("move_backward"):
		$InnerGimbal/Camera.make_current()
		global_translate(Vector3(0, 0, move_rate))
	
	if Input.is_action_pressed("cam_zoom_in"):
		$InnerGimbal/Camera.make_current()
		zoom -= zoom_speed
	if Input.is_action_pressed("cam_zoom_out"):
		$InnerGimbal/Camera.make_current()
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)

func _process(delta):
	get_input_keyboard(delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -0.7, 0.6)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	if target:
		global_transform.origin = get_node(target).global_transform.origin
