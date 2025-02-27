extends TileMapLayer

@onready var camera = $"../Camera"

var noise

var zoom = 4

func getTileAtCoord(coord: Vector2):
	return Vector2i(round(coord.x/(16 * zoom)), round(coord.y/(16 * zoom)))

var previous_hover_cell = Vector2i(0,0)
var previously_drawn_cells = []

func handle_hover():
	var cameraPosition = camera.position/(16 * zoom)
	var mousePosition = Vector2(Vector2i(get_viewport().get_mouse_position()) - get_viewport().size/2)/(16*zoom)
	var hover_pos = Vector2i(floor(cameraPosition + mousePosition))
	set_cell(hover_pos, 0, Vector2i(7, 0))

	#If the hover cell is different from the previous hover cell, set the previous hover cell to the noise map value
	if hover_pos != previous_hover_cell:
		set_cell(previous_hover_cell, 0, Vector2i(6, 0))

	previous_hover_cell = hover_pos

#Draw placement grid squares around camera
func redraw():
	var centerCell = getTileAtCoord(camera.position)
	var window_size = get_viewport_rect()
	
	# Pre-calculate grid dimensions
	var gridHeight = ceil((window_size.size.y / (16 * zoom))) + 2
	var gridWidth = ceil((window_size.size.x / (16 * zoom))) + 2
	var half_width = gridWidth / 2
	var half_height = gridHeight / 2
	
	# Calculate bounds once
	var min_x = centerCell.x - half_width
	var max_x = centerCell.x + half_width
	var min_y = centerCell.y - half_height
	var max_y = centerCell.y + half_height
	
	# Convert previously_drawn_cells to a dictionary for O(1) lookup
	var prev_cells_dict = {}
	for cell in previously_drawn_cells:
		prev_cells_dict[cell] = true
		# Erase cells outside bounds in the same loop
		if cell.x < min_x or cell.x > max_x or cell.y < min_y or cell.y > max_y:
			erase_cell(cell)
	
	# Draw new cells
	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			var pos = Vector2i(x, y)
			if not prev_cells_dict.has(pos) or pos == previous_hover_cell:
				set_cell(pos, 0, Vector2i(6, 0))
	
	# Update previously_drawn_cells more efficiently
	previously_drawn_cells = get_used_cells()

func changeZoom(increment : float):
	zoom = round(clamp(zoom + increment, 1, 8) * 10)/10
	scale = Vector2(zoom, zoom)
	redraw()

func _ready():
	noise = get_parent().world_noise
	changeZoom(0)
	camera.redraw_grid.connect(redraw)
	camera.change_zoom.connect(changeZoom)
	camera.handle_hover.connect(handle_hover)
	redraw()
