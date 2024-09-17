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
	AudioHandler.play_audio(AudioHandler.LightningExplosion)
	area.area_entered.connect(on_area_entered)
	area.body_entered.connect(destroy)
	animation_finished.connect(on_animation_end)

func on_animation_end():
	LevelInfo.set_shake(0.5)
	area.monitoring = true
	get_tree().create_timer(0.1).timeout.connect(func(): area.monitoring = false)
	fading = true
	lightningExplosion.emitting = true
	
	remove_child(crater)
	get_tree().current_scene.add_child(crater)
	crater.position = position
	crater.visible = true
	crater.fade_after(1)
	
	var path := LevelInfo.get_tile_map("Path")
	var pos = path.local_to_map(position)
	path.set_cells_terrain_connect([pos], 0, -1)
	path.set_cell(pos, -1)
	
	while(modulate.a > 0):
		modulate.a -= get_process_delta_time()
		await get_tree().process_frame
	queue_free()

func destroy(body):
	body.damage(1)
	
func on_area_entered(area):
	destroy(area.get_parent())
