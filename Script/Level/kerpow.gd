extends Node2D

var previewScene
var preview : Node2D

func _ready() -> void:
	LevelInfo.selected_power_changed.connect(on_power_change)
func on_power_change():
	if(preview): preview.queue_free()
	if(LevelInfo.selected_power == "none"):
		preview = null
		return
	if(LevelInfo.started): 
		if LevelInfo.selected_power == "Lightning":
			previewScene = load("res://Scenes/Powers/" + "Crosshair" + ".tscn")
			preview = previewScene.instantiate()
			preview.preview()
			get_tree().current_scene.add_child(preview)
		return
	previewScene = load("res://Scenes/Powers/" + LevelInfo.selected_power + ".tscn")
	preview = previewScene.instantiate()
	preview.preview()
	
	get_tree().current_scene.add_child(preview)
func on_summon():
	if(LevelInfo.selected_power == "none"): return
	if(LevelInfo.selected_power == "Tsunami" && preview.grass_under()): 
		AudioHandler.play_audio(AudioHandler.No, 0, 1, true)
		return
	AudioHandler.play_audio(AudioHandler.Place, 0, 1, true)
	var mouse_pos = get_global_mouse_position()
	var newInteractable : Interactable = previewScene.instantiate()
	get_tree().current_scene.add_child(newInteractable)
	newInteractable.position = preview.position
	newInteractable.rotation = preview.rotation
	newInteractable.start()
	LevelInfo.power_added_to_map.emit(LevelInfo.selected_power)
	
	LevelInfo.change_power("none")
	return
func _process(delta: float) -> void:
	if(!preview): return
	preview.position = get_global_mouse_position()
	if(LevelInfo.selected_power == "Tsunami"):
		if(preview.grass_under()):
			preview.modulate.b = 0
			preview.modulate.g = 0
		else:
			preview.modulate.b = 255
			preview.modulate.g = 255
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				print(event.position.y)
				if(event.position.y > (550)): return
				var mouse_pos = get_global_mouse_position()
				#print("Mouse Click/Unclick at: ", mouse_pos)
				if(!LevelInfo.started):
					on_summon()
				else:
					if(LevelInfo.selected_power == "Lightning"):
						for i : Interactable in LevelInfo.get_level_handler().hazards:
							if(i.interactableType == "StormCloud" and i.in_range(get_global_mouse_position())):
								LevelInfo.power_added_to_map.emit(LevelInfo.selected_power)
								Lightning.summon(get_tree().current_scene, get_global_mouse_position())
								return
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var mouse_pos = get_global_mouse_position()
				#print("Mouse Click/Unclick at: ", mouse_pos)
				LevelInfo.change_power("none")
				
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if(preview && preview.rotatable):
					preview.rotate(-PI/20)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if(preview && preview.rotatable):
					preview.rotate(PI/20)
