extends Node
class_name LevelHandler

@export var thisLevel : String
@export var nextLevel : String
@export var LevelNumber : int

var person_scene = load("res://Scenes/Person.tscn")

var maxDestruction : float = 0
var destruction : float = 0

var temper : float = 0


var houses = []
var buildings = []
var hazards = []

func restart():
	SceneTransition.load_scene(thisLevel)
	LevelInfo.started = false
	LevelInfo.selected_power = "none"
func next_level():
	SceneTransition.load_scene(nextLevel)

func on_start():
	LevelInfo.change_power("none")

	for i in hazards:
		if "interactableType" in i && i.interactableType == "StormCloud":
			if(!"rain" in AudioHandler.loops): AudioHandler.loop_audio("rain", AudioHandler.Rain)
		if "interactableType" in i && i.interactableType == "Tornado":
			if(!"tornado" in AudioHandler.loops): AudioHandler.loop_audio("tornado", AudioHandler.Tornado)
		if "interactableType" in i && i.interactableType == "Tsunami":
			if(!"tsunami" in AudioHandler.loops): AudioHandler.loop_audio("tornado", AudioHandler.Rain, 0 , 0.3)
func on_stop():
	LevelInfo.change_power("none")
	var time = 0
	var delta
	while time < 1:
		delta = get_process_delta_time()
		time += delta
		if("rain" in AudioHandler.loops): AudioHandler.change_loop_audio("rain", delta * -10)
		if("tornado" in AudioHandler.loops): AudioHandler.change_loop_audio("tornado", delta * -10)
		if("tsunami" in AudioHandler.loops): AudioHandler.change_loop_audio("tornado", delta * -10)
		await get_tree().process_frame
	if("rain" in AudioHandler.loops): AudioHandler.kill_loop("rain")
	if("tornado" in AudioHandler.loops): AudioHandler.kill_loop("tornado")
	if("tsunami" in AudioHandler.loops): AudioHandler.change_loop_audio("tsunami", delta * -10)
func _ready() -> void:
	LevelInfo.on_start.connect(on_start)
	LevelInfo.on_stop.connect(on_stop)
func spawnGuy():
	if(len(houses) < 2): return
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
