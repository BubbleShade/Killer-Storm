extends AnimatedSprite2D
class_name Lightning
static var lightningScene = load("res://Scenes/Powers/Lightning.tscn")
@onready var area : Area2D = $Area2D
@onready var lightningExplosion : GPUParticles2D = $LightningExplosion
@onready var crater : Sprite2D = $Crater

var fading = false


static func summon(current_scene : Node, Pos : Vector2) -> Lightning:
	var newLightning : Lightning = lightningScene.instantiate()
	current_scene.add_child(newLightning)
	newLightning.position = Pos
	newLightning.ready()
	return newLightning

# Called when the node enters the scene tree for the first time.
func ready() -> void:
	#print(position, " - ", path.local_to_map(position))
	
	area.area_entered.connect(on_area_entered)
	area.body_entered.connect(destroy)
	animation_finished.connect(on_animation_end)

func on_animation_end():
	area.monitoring = true
	fading = true
	lightningExplosion.emitting = true
	
	remove_child(crater)
	get_tree().current_scene.add_child(crater)
	crater.position = position
	crater.visible = true
	crater.fade_after(1)
	
	var path := LevelInfo.get_tile_map("Path")
	path.set_cell(path.local_to_map(position), -1)
	
	#remove_child(lightningExplosion)
	#get_tree().current_scene.add_child(lightningExplosion)

func destroy(body):
	body.damage(1)
	area.monitoring = false
	print("Killed")
func on_area_entered(area):
	destroy(area.get_parent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(fading):
		modulate.a -= delta
		if(modulate.a <= 0):
			queue_free()

	


	
