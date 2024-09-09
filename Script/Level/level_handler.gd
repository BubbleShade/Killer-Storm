extends Node
var person_scene = load("res://Scenes/Person.tscn")

func spawnGuy():
	if(len(LevelInfo.houses) <= 1): return
	var startHouse = LevelInfo.houses.pick_random()
	if startHouse.people <= 0: return
	startHouse.people -= 1
	var newGuy = person_scene.instantiate()
	var endHouse = LevelInfo.houses.pick_random()
	while endHouse == startHouse:
		endHouse = LevelInfo.houses.pick_random()
	newGuy.target_object = endHouse
	newGuy.position = startHouse.position
	get_tree().current_scene.add_child(newGuy)
var timeTillNextMove = 5

func _process(delta: float) -> void:
	if(!LevelInfo.started):
		timeTillNextMove -= delta
		if(timeTillNextMove <= 0):
			spawnGuy()
			timeTillNextMove = randf_range(3,6)
