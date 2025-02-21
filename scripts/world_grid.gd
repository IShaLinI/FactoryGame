extends TileMapLayer

@onready var camera = $"../../Camera"
@onready var grid = $"."

var zoom = 4

func getTileAtCoord(coord: Vector2):
	return Vector2i(floor(coord.x/(16 * zoom)), floor(coord.y/(16 * zoom)))

#Draw placement grid squares around camera
func redraw():
	grid.clear()
	var centerCell = getTileAtCoord(camera.position)
	var window_size = get_viewport_rect()
	
	var gridHeight = ceil((window_size.size.y / (16 * zoom))) + 2
	var gridWidth = ceil((window_size.size.x / (16 * zoom))) + 2
	
	for x in range(centerCell.x - gridWidth/2, centerCell.x + gridWidth/2):
		for y in range(centerCell.y - gridHeight/2, centerCell.y + gridHeight/2):
			grid.set_cell(Vector2i(x,y), 0, Vector2i(0,1))
	
	#Hover Highlight
	var cameraPosition = camera.position/(16 * zoom)
	var mousePosition = Vector2(Vector2i(get_viewport().get_mouse_position()) - get_viewport().size/2)/(16*zoom)
	grid.set_cell(floor(cameraPosition + mousePosition), 0, Vector2i(1,1))
	
	pass

func changeZoom(increment : float):
	zoom = round(clamp(zoom + increment, 1, 8) * 10)/10
	grid.scale = Vector2(zoom, zoom)
	redraw()

func _on_ready():
	camera.redraw_grid.connect(redraw)
	camera.change_grid_zoom.connect(changeZoom)
	redraw()
