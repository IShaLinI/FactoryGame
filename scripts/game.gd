extends Node2D

var tileset: TileSet

var world_noise = FastNoiseLite.new()

#Sets up the camera
func setup_camera(node: Node2D):
	#Create Camera
	var camera = Camera2D.new()
	var camera_script = preload("res://scripts/camera.gd")
	camera.script = camera_script
	camera.name = "Camera"
	camera.position = Vector2(0, 0)
	camera.zoom = Vector2(1, 1)
	node.add_child(camera)
	camera.make_current()


func load_tileset():
	var tiles = 30 #The number of tiles in the tileset
	var atlas_source = TileSetAtlasSource.new()
	var texture = preload("res://assets/TileSet.png")
	atlas_source.texture = texture
	atlas_source.texture_region_size = Vector2(16,16)
	
	#Loop through the tiles and create them
	for i in tiles:
		var column = i % 10
		var row = int(float(i) / 10)
		print("Col:", column, "Row", row)
		atlas_source.create_tile(Vector2i(column, row))

	var tile_set = TileSet.new()
	tile_set.add_source(atlas_source, 0)
	return tile_set

#Sets up the world grid
func setup_world_grid(node: Node2D):
	var tilemap_layer = TileMapLayer.new()
	tilemap_layer.name = "WorldGrid"
	tilemap_layer.tile_set = tileset
	tilemap_layer.script = preload("res://scripts/world_grid.gd")
	tilemap_layer.set_cell(Vector2i(0,0), 0, Vector2i(0,0))
	tilemap_layer.z_index = 1
	node.add_child(tilemap_layer)

func setup_resource_grid(node: Node2D):
	var resource_grid = TileMapLayer.new()
	resource_grid.name = "ResourceGrid"
	resource_grid.tile_set = tileset
	resource_grid.script = preload("res://scripts/resource_grid.gd")
	resource_grid.z_index = 0
	node.add_child(resource_grid)

func setup_noise_grid(node: Node2D):
	var noise_grid = TileMapLayer.new()
	noise_grid.name = "NoiseGrid"
	noise_grid.tile_set = tileset
	noise_grid.script = preload("res://scripts/noise_grid.gd")
	noise_grid.z_index = -1
	node.add_child(noise_grid)

func setup_world_noise():
	world_noise.seed = 0
	world_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	world_noise.frequency = 0.1

#Setups up the game with the camera and grids
func game_start(node: Node2D):
	tileset = load_tileset()
	setup_world_noise()
	setup_camera(node)
	setup_world_grid(node)
	setup_resource_grid(node)
	#setup_noise_grid(node)
	pass

func _ready():
	game_start(self)
	pass

func _process(_delta):
	#print("FPS:",Engine.get_frames_per_second())
	pass
