extends TileMapLayer

@onready var camera = $"../../Camera"
@onready var ui_selector = $"../../Camera/UI/Placables"
@onready var ui = $"../../Camera/UI"
@onready var world_grid = $".."
@onready var player_tiles = $"."

var ui_rect = Rect2(440,632, 400,112)

var bend_id = Vector2i(3,0)
var conveyor_id = Vector2i(2,0)
var tile_ids = [conveyor_id, bend_id]

func getMouseTile():
	var cameraPosition = camera.position/(16 * world_grid.scale.x)
	var mousePosition = Vector2(Vector2i(get_viewport().get_mouse_position()) - get_viewport().size/2)/(16*world_grid.scale.x)
	return Vector2i(floor(cameraPosition + mousePosition))

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and not ui_rect.has_point(event.position):
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not getMouseTile() in player_tiles.get_used_cells():
				player_tiles.set_cell(getMouseTile(), 0, tile_ids[ui_selector.get_selected_items()[0]])
				
		if event.button_index == MOUSE_BUTTON_RIGHT:
			player_tiles.erase_cell(getMouseTile())
	
