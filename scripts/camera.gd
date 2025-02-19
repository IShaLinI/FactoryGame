extends Camera2D

signal redraw_grid()
signal change_grid_zoom(increment : float)

@onready var mousePos = get_viewport().get_mouse_position()
@onready var newMousePos = get_viewport().get_mouse_position()
@onready var camera = $"."

var dragging = false
var scrolling = false

func _input(event):
	
	#Handle Zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom
			emit_signal("change_grid_zoom", 0.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			emit_signal("change_grid_zoom", -0.1)
		
	#Handle Camera Pan
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if not dragging and event.pressed:
			mousePos = get_viewport().get_mouse_position()
			newMousePos = mousePos
			dragging = true
		if dragging and not event.pressed:
			dragging = false
	if (dragging):
		newMousePos = get_viewport().get_mouse_position()
		var mouseDelta = newMousePos - mousePos
		camera.position = camera.position - (mouseDelta)/zoom.x
		
	mousePos = newMousePos
	
	emit_signal("redraw_grid")
	pass

func _process(delta):
	
	pass
