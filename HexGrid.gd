extends Spatial

const DEFAULT_TILE_MATERIAL = preload("res://grey.tres")

const TILE_MATERIALS = [
	preload("res://blue.tres"),
	preload("res://green.tres"),
	preload("res://red.tres"),
	preload("res://yellow.tres"),
]

const TILE_SIZE := 1.0
const NORMAL_SPEED := 50
const CELL_TILE = preload("res://CellTile.tscn")
const WALL_TILE = preload("res://WallTile.tscn")

const GAME_UTILS = preload("res://Utils.gd")

var godzila
var kiwi
var fox
var robot
var armed_ufo

export (int, 2, 20) var grid_size := 30
export (float) var run_speed = 50.0
export (int) var enabled_cells_count = 0

var started = false
var start_frame = 0

func _ready() -> void:
	generate_grid()
	
	godzila = get_parent_spatial().get_node("Godzilla")
	kiwi = get_parent_spatial().get_node("Kiwi")
	fox = get_parent_spatial().get_node("Fox")
	robot = get_parent_spatial().get_node("Robot")
	armed_ufo = get_parent_spatial().get_node("ArmedUFO")
	
	set_nodes_positions()
	
func generate_grid():
	var tile_index := 0
	for x in range(grid_size):
		var tile_coordinates := Vector2.ZERO
		tile_coordinates.x = x * TILE_SIZE
		tile_coordinates.y = 0
#		tile_coordinates.y = 0 if x % 2 == 0 else TILE_SIZE / 2
		for y in range(grid_size):
			var tile
			if x == 0 || x == grid_size - 1:
				tile = WALL_TILE.instance()
				if (y == 0 || y == grid_size - 1):
					pass
				else:
					tile.get_node("wall_corner").hide()
					var wall = tile.get_node("wall")
					wall.scale.z = 1.3
					wall.show()
				
				tile.add_to_group("wall")
			elif y == 0 || y == grid_size - 1:
				tile = WALL_TILE.instance()
				if (x == 0 || x == grid_size - 1):
					pass
				else:
					tile.get_node("wall_corner").hide()
					var wall = tile.get_node("wall")
					wall.scale.x = 1.3
					wall.show()
				
				tile.add_to_group("wall")
			else:
				tile = CELL_TILE.instance()
				tile.add_to_group("cell")
			
			add_child(tile)
			tile.translate(Vector3(tile_coordinates.x, 0, tile_coordinates.y))
			tile_coordinates.y += TILE_SIZE
			
#			var node = tile.get_node("unit_tile/tmpParent/tile")
			#			node.material_override = get_tile_material(tile_index)
			
#			var node = tile.get_node("blockSnowRoundedLow/tmpParent/blockSnowRoundedLow")
#			node.material_override = DEFAULT_TILE_MATERIAL
#			tile.get_node("unit_hex/mergedBlocks(Clone)").material_override = get_tile_material(tile_index)
			
			tile_index += 1

func get_tile_material(tile_index: int):
	var index = tile_index % TILE_MATERIALS.size()
	return TILE_MATERIALS[index]

func enabled_disabled_cells():
	var cells = get_children()
	var results = []
	var enabled_cells = []
	var disabled_cells = []
	
	for i in range(len(cells)):
		if cells[i].is_in_group("cell"):
			if cells[i].is_enabled == true:
				enabled_cells.append(cells[i])
			else:
				disabled_cells.append(cells[i])			
	
	results.append(enabled_cells)
	results.append(disabled_cells)
	
	return results
	
func run_game():
	var all_cells = enabled_disabled_cells()
	var enabled_cells = all_cells[0]
	var disabled_cells = all_cells[1]
	
	var dead_cells = []
	var live_cells = []
	
	for i in range(len(enabled_cells)):
		var neighbor_cells_count = neighbor_cells_count(enabled_cells[i])
		if neighbor_cells_count <= 1 || neighbor_cells_count >=4:
			dead_cells.append(enabled_cells[i])
			
	for i in range(len(disabled_cells)):
		var neighbor_cells_count = neighbor_cells_count(disabled_cells[i])
		if neighbor_cells_count >= 3:
			live_cells.append(disabled_cells[i])			
		
	for i in range(len(dead_cells)):
		GAME_UTILS.on_off(dead_cells[i])
		
	for i in range(len(live_cells)):
		GAME_UTILS.on_off(live_cells[i])
		
func reset_game():
	var cells = get_children()
	
	for i in range(len(cells)):
		if cells[i].is_in_group("cell"):
			cells[i].is_enabled = false
			cells[i].get_node("unit_tile/tmpParent/tile").material_override = null
		
func neighbor_cells_count(cell):
	var cells_count = 0
	var index = cell.get_index()
	var prev_row = index - grid_size
	var next_row = index + grid_size
	
	if index + 1 >=0 and index + 1 <= grid_size * grid_size - 1 and get_child(index + 1).is_enabled == true:
		cells_count += 1
	if index - 1 >= 0 and get_child(index - 1).is_enabled == true:
		cells_count += 1

	if prev_row >= 0:
		if get_child(prev_row).is_enabled == true:
			cells_count += 1
		if prev_row - 1 >=0 and get_child(prev_row - 1).is_enabled == true:
			cells_count += 1				
		if get_child(prev_row + 1).is_enabled == true:
			cells_count += 1						
	
	if next_row <= grid_size * grid_size - 1:
		if get_child(next_row).is_enabled == true:
			cells_count += 1				
		if prev_row - 1>= 0 and get_child(next_row - 1).is_enabled == true:
			cells_count += 1
		if next_row + 1 <= grid_size * grid_size - 1 and get_child(next_row + 1).is_enabled == true:
			cells_count += 1
	
	return cells_count
	
func _on_StartButton_pressed():
	print("The start button is pressed.")
	started = true
	set_enabled_cells_count()
	
	godzila.stopped = false
	kiwi.stopped = false
	fox.stopped = false
	armed_ufo.stopped = false
	fox.get_node("AnimationPlayer").stop()

func _on_ResetButton_pressed():
	print("The reset button is pressed.")
	started = false
	
	reset_game()
	set_nodes_positions()
	
	robot.reset()
	godzila.stopped = true
	godzila.stop_fire()
	
	kiwi.stopped = true
	
	fox.stopped = true
	fox.get_node("AnimationPlayer").stop()
	
	armed_ufo.stopped = true
	armed_ufo.reset_bow()
	
func _on_StopButton_pressed():
	print("The stop button is pressed.")
	started = false
	
	godzila.stopped = true
	kiwi.stopped = true
	fox.stopped = true
	armed_ufo.stopped = true

func _process(delta):
	if started and start_frame >= run_speed:
		run_game()
		start_frame = 0
		
	start_frame += 1

func _on_PlaySpeedButotn1_pressed():
	run_speed = NORMAL_SPEED
	set_npc_speeds(1)

func _on_PlaySpeedButotn2_pressed():
	run_speed = NORMAL_SPEED / 2.0
	set_npc_speeds(3)

func _on_PlaySpeedButotn3_pressed():
	run_speed = NORMAL_SPEED / 3.0
	set_npc_speeds(5)
	
func set_npc_speeds(factor):
	godzila.moving = false
	godzila.speed_factor = factor
	
	fox.moving = false
	fox.speed_factor = factor	
	
	kiwi.moving = false
	kiwi.speed_factor = factor
	
	armed_ufo.moving = false
	armed_ufo.speed_factor = factor
	
func set_enabled_cells_count():
	var cells = get_children()
	var results = []

	for i in range(len(cells)):
		if cells[i].is_in_group("cell") && cells[i].is_enabled == true:
			results.append(cells[i])
	
	enabled_cells_count = len(results)
	print("{count} cells have been enabled!".format({"count": enabled_cells_count}))

func get_random_position():
	randomize()
	return Vector3(randi() % (grid_size - 10) + 5, 0, randi() % (grid_size - 10) + 5)
	
func set_nodes_positions():
	godzila.transform.origin = get_random_position()
	kiwi.transform.origin = get_random_position()
	fox.transform.origin = get_random_position() + Vector3.UP
	robot.transform.origin = get_random_position()
	armed_ufo.transform.origin = get_random_position() + Vector3(0, 5, 0)
