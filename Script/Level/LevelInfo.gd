extends Node

var started = false
signal selected_power_changed()
var selected_power = "none"
signal on_start()

func start():
	started = true
	on_start.emit()
func change_power(new_power):
	selected_power = new_power
	selected_power_changed.emit()
func get_tile_map(name : String) -> TileMapLayer:
	return get_tree().current_scene.get_node(name)
func get_level_handler() -> LevelHandler: return get_tree().current_scene.get_node("LevelHandler")
