extends Building

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destroySprite = load("res://Assets/Houses/Well/Destroyed.png")
	levelHandler.buildings.append(self)
	super._ready()
	pass # Replace with function body.
func destroy():
	super.destroy()
	levelHandler.buildings.remove_at(levelHandler.buildings.find(self))
	#print(get_tree().current_scene.get_node("LevelHandler"))
	levelHandler.spawnGuyFromDestroyedHouse(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
