extends Building



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destroySprite = load("res://Assets/SmallHouseDestroyFire.png")
	LevelInfo.get_level_handler().houses.append(self)
	pass # Replace with function body.
func destroy():
	super.destroy()
	var levelHandler = LevelInfo.get_level_handler()
	levelHandler.houses.remove_at(levelHandler.houses.find(self))
	#print(get_tree().current_scene.get_node("LevelHandler"))
	levelHandler.spawnGuyFromDestroyedHouse(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
