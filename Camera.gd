extends Camera

export var lerp_speed = 1.0
export (NodePath) var target_path = null
export (Vector3) var offset = Vector3(0, 20, 30)
export (bool) var enabled = false

var target = null

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(_delta):
	if !target || !enabled:
		return

	var rotate_degree = round(rad2deg(target.rotation.y))
		
	var target_pos = target.global_transform.translated(offset)
	global_transform = target_pos
	
	look_at(target.global_transform.origin, Vector3.UP)
	rotate_y(-target.rotation.y)
	
	if rotate_degree == 0:
		translation.x = 0
	elif rotate_degree == 180:
		translation.z = -30
	elif rotate_degree == -90:
		translation.z = 0
		translation.x = 30
	elif rotate_degree == 90:
		translation.z = 0
		translation.x = -30

