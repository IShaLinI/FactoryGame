extends Camera2D

@onready var mousePos = get_viewport().get_mouse_position()
@onready var newMousePos = get_viewport().get_mouse_position()

var dragging = false
var scrolling = false

signal redraw_grid()
signal handle_hover()
signal change_zoom(amount: float)

var accum_pivot = Vector2(0,0)
var zoom_value = 4

func _input(event):

	#Handle Zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_value = round(clamp(zoom_value + 0.1, 1, 8) * 10)/10
			change_zoom.emit(0.1)
			print("Zoom:", zoom_value)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_value = round(clamp(zoom_value - 0.1, 1, 8) * 10)/10
			change_zoom.emit(-0.1)
			print("Zoom:", zoom_value)
		
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
		position = position - mouseDelta
		var distance_to_pivot = accum_pivot - position

		if (abs(distance_to_pivot.x) > 16 * zoom_value || abs(distance_to_pivot.y) > 16 * zoom_value):
			accum_pivot = position
			redraw_grid.emit()

	mousePos = newMousePos

	handle_hover.emit()
	
	pass
