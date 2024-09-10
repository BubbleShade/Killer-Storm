extends Node2D

var previewScene
var preview

func _ready() -> void:
	LevelInfo.selected_power_changed.connect(on_power_change)
func on_power_change():
	if(LevelInfo.started): return
	if(preview): preview.queue_free()
	if(LevelInfo.selected_power == "none"):
		preview = null
		return
	previewScene = load("res://Scenes/Powers/" + LevelInfo.selected_power + ".tscn")
	preview = previewScene.instantiate()
	preview.preview()
	
	get_tree().current_scene.add_child(preview)
func on_summon():
	if(LevelInfo.selected_power == "none"): return
	var mouse_pos = get_global_mouse_position()
	var newInteractable : Cloud = previewScene.instantiate()
	get_tree().current_scene.add_child(newInteractable)
	newInteractable.position = mouse_pos
	newInteractable.start()
	
	LevelInfo.change_power("none")
	return
func _process(delta: float) -> void:
	if(!preview): return
	preview.position = get_global_mouse_position()

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			#print("Mouse Click/Unclick at: ", mouse_pos)
			if(!LevelInfo.started):
				on_summon()
			else:
				if(LevelInfo.selected_power == "Lightning"):
					for i : Interactable in LevelInfo.get_level_handler().hazards:
						print(i.interactableType == "StormCloud")
						if(i.interactableType == "StormCloud" and i.in_range(get_global_mouse_position())):
							Lightning.summon(get_tree().current_scene, get_global_mouse_position())
							return
