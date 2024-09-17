extends Building

var toHouse = "res://Assets/Houses/LargeHouse/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destroySprite = load("res://Assets/Houses/LargeHouse/FireDamage_destroyed.png")
	spriteTable = {
		"Fire2": load("res://Assets/Houses/LargeHouse/FireDamage_2hp.png"),
		"Fire1": load("res://Assets/Houses/LargeHouse/FireDamage_1hp.png"),
		"Fire0": load("res://Assets/Houses/LargeHouse/FireDamage_destroyed.png")
	}
	levelHandler.houses.append(self)
	levelHandler.buildings.append(self)
	super._ready()
	pass # Replace with function body.
func destroy():
	super.destroy()
	levelHandler.houses.remove_at(levelHandler.houses.find(self))
	levelHandler.buildings.remove_at(levelHandler.buildings.find(self))

	#print(get_tree().current_scene.get_node("LevelHandler"))
	levelHandler.spawnGuyFromDestroyedHouse(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
