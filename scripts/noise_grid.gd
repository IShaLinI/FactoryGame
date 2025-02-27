extends TileMapLayer

var noise

@onready var camera = $"../Camera"

var zoom = 4

func getTileAtCoord(coord: Vector2):
	return Vector2i(round(coord.x / (16 * zoom)), round(coord.y / (16 * zoom)))

var previously_drawn_cells = []

var noise_values = {} #Keep track of noise values for each cell to save on calculations    

#Draw placement grid squares around camera
func redraw():
	
	var centerCell = getTileAtCoord(camera.position)
	var window_size = get_viewport_rect()
	
	#Calculate the bounds of the grid
	var gridHeight = ceil((window_size.size.y / (16 * zoom))) + 2
	var gridWidth = ceil((window_size.size.x / (16 * zoom))) + 2
	var half_width = gridWidth / 2
	var half_height = gridHeight / 2
	
	#Calculate the bounds of the grid
	var min_x = centerCell.x - half_width
	var max_x = centerCell.x + half_width
	var min_y = centerCell.y - half_height
	var max_y = centerCell.y + half_height

	#Remove cells outside of the grid
	var prev_cells_dict = {}    
	for cell in previously_drawn_cells:
		prev_cells_dict[cell] = true
		if cell.x < min_x or cell.x > max_x or cell.y < min_y or cell.y > max_y:
			erase_cell(cell)

	#Store noise values for each cell in view
	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			var pos = Vector2i(x, y)
			if not noise_values.has(pos):
				noise_values[pos] = (noise.get_noise_2d(pos.x, pos.y) + 1)/2

	#Draw resource cells if the cell is in view, and if the 9 cells centered around it have on average a noise value of over 0.7
	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			var pos = Vector2i(x, y)
			if not noise_values.has(pos):
				noise_values[pos] = (noise.get_noise_2d(pos.x, pos.y) + 1)/2
			if not prev_cells_dict.has(pos):
				var mag = round(noise_values[pos] * 10)
				set_cell(pos, 0, Vector2i(mag, 2))

	previously_drawn_cells = get_used_cells() #Update the list of drawn cells

func changeZoom(increment: float):
	zoom = round(clamp(zoom + increment, 1, 8) * 10) / 10
	scale = Vector2(zoom, zoom)
	redraw()

func _ready():
	noise = get_parent().world_noise
	changeZoom(0)
	camera.redraw_grid.connect(redraw)
	camera.change_zoom.connect(changeZoom)
	redraw()
