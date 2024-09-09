extends Node2D

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			print("Mouse Click/Unclick at: ", mouse_pos)
