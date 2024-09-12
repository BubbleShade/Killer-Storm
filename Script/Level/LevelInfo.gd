extends Node

var started = false
signal selected_power_changed()
var selected_power = "none"
signal on_start()
signal on_stop()

signal power_added_to_map(power : String)
signal power_removed_from_map(power : String)
func get_score():
	var levelHandler : LevelHandler = get_level_handler()
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
