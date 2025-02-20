extends ItemList

@onready var camera = $"../.."
@onready var ui_container = $".."
@onready var item_list = $"."


var tileset = TileSet.new()

func get_tile_texture(coords: Vector2i, source_id: int = 0) -> AtlasTexture:
	
	var source = tileset.get_source(source_id) as TileSetAtlasSource
	var region = source.get_tile_texture_region(coords)
	
	var atlas = AtlasTexture.new()
	atlas.atlas = source.texture
	atlas.region = region
	return atlas

func atlas_to_texture2d(atlas_texture: AtlasTexture) -> ImageTexture:
	# Create an Image from the atlas region
	var image = Image.new()
	var region = atlas_texture.region
	image = atlas_texture.atlas.get_image().get_region(region)
	
	# Convert the Image to ImageTexture
	var texture = ImageTexture.create_from_image(image)
	return texture

func _ready():
	
	var atlas_source = TileSetAtlasSource.new()
	var texture = preload("res://assets/TileMap.png")
	atlas_source.texture = texture
	atlas_source.texture_region_size = Vector2i(16,16)
	atlas_source.create_tile(Vector2i(2,0))
	atlas_source.create_tile(Vector2i(3,0))
	tileset.add_source(atlas_source,0)
	
	
	item_list.focus_mode = FocusMode.FOCUS_NONE
	item_list.add_icon_item(atlas_to_texture2d(get_tile_texture(Vector2i(2,0),0)))
	item_list.add_icon_item(atlas_to_texture2d(get_tile_texture(Vector2i(3,0),0)))
	
	pass
	
func _process(delta):
	
	ui_container.scale = Vector2(4,4) / camera.zoom
	ui_container.position.y = snapped(256 / camera.zoom.x, 0.5)
	
	pass
