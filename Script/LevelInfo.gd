extends Node
var person_scene = load("res://Scenes/Person.tscn")

var houses = []
var clouds = []
var started = false

func spawnGuy():
	print("Guy")
	if(len(houses) <= 1): return
	get_tree().create_timer(randf_range(3,5)).timeout.connect(spawnGuy)
	var startHouse = houses.pick_random()
	if startHouse.people <= 0: return
	startHouse.people -= 1
	var newGuy = person_scene.instantiate()
	var endHouse = houses.pick_random()
	while endHouse == startHouse:
		endHouse = houses.pick_random()
	newGuy.target_object = endHouse
	newGuy.position = startHouse.position
	get_tree().current_scene.add_child(newGuy)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(spawnGuy)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
