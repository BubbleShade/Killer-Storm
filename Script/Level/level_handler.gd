extends Node
class_name LevelHandler

var person_scene = load("res://Scenes/Person.tscn")
var houses = []

func spawnGuy():
	var startHouse = houses.pick_random()
	if startHouse.people <= 0: return
	startHouse.people -= 1
	var newGuy = person_scene.instantiate()
	newGuy.position = startHouse.position
	get_tree().current_scene.add_child(newGuy)
func spawnGuyFromDestroyedHouse(startHouse):
	for i in range(startHouse.people):
		var newGuy = person_scene.instantiate()
		newGuy.position = startHouse.position
		get_tree().current_scene.add_child(newGuy)
	startHouse.people = 0
	
var timeTillNextMove = 5

func _process(delta: float) -> void:
	if(!LevelInfo.started):
		timeTillNextMove -= delta
		if(timeTillNextMove <= 0):
			spawnGuy()
			timeTillNextMove = randf_range(3,6)
