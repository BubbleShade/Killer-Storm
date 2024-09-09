extends Node
var person_scene = load("res://Scenes/Person.tscn")

var houses = []
var clouds = []
var started = false

signal on_start

func start():
	started = true
	on_start.emit()
func get_tile_map(name : String) -> TileMapLayer:
	return get_tree().current_scene.get_node(name)
