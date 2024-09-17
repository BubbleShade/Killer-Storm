extends Node

var started = false
var selected_power = "none"

var volume = 5
signal on_volume_changed
signal selected_power_changed()
signal on_start()
signal on_stop()

signal power_added_to_map(power : String)
signal power_removed_from_map(power : String)
var levelStars = [0,0,0,0,0,0,0]

func get_score():
	var levelHandler : LevelHandler = get_level_handler()
	if(!levelHandler): return 0
	if(levelHandler.destruction == 0): return 0
	return round((levelHandler.destruction * 10) - log(levelHandler.temper) / log(1.5))
func stop():
	started = false
	on_stop.emit()
func start():
	started = true
	on_start.emit()
func change_power(new_power):
	selected_power = new_power
	selected_power_changed.emit()
func get_tile_map(name : String) -> TileMapLayer:
	return get_tree().current_scene.get_node(name)
func get_level_handler() -> LevelHandler: return get_tree().current_scene.get_node("LevelHandler")
func set_shake(shake): if (get_tree().current_scene.get_node("Camera2D")): get_tree().current_scene.get_node("Camera2D").set_shake(shake)
