extends Sprite2D
class_name Lightning
static var lightningScene = load("res://Scenes/Powers/Lightning.tscn")
@onready var area : Area2D = $Area2D


static func summon(current_scene : Node, Pos : Vector2) -> Lightning:
	var newLightning : Lightning = lightningScene.instantiate()
	current_scene.add_child(newLightning)
	newLightning.position = Pos
	newLightning.ready()
	return newLightning

func destroy(body):
	body.damage(1)
	
func on_area_entered(area):
	destroy(area.get_parent())
	
# Called when the node enters the scene tree for the first time.
func ready() -> void:
	var path := LevelInfo.get_tile_map("Path")
	path.set_cell(path.local_to_map(position), 0, Vector2(0,3))
	print(position, " - ", path.local_to_map(position))
	
	area.area_entered.connect(on_area_entered)
	area.body_entered.connect(destroy)
	area.monitoring = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
