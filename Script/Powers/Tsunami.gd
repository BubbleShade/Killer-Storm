extends Interactable
class_name Tsunami

@export var tileMapName : String
@export var RadiusX : float
@export var RadiusY : float
@onready var ground : TileMapLayer = LevelInfo.get_tile_map("Grass")
var crossedLand = false
func grass_under():
	return ground.get_cell_source_id(ground.local_to_map(position)) != -1

func on_start(): 
	$GPUParticles2D.emitting = true
	var destroyArea : Area2D = $DestroyArea
	destroyArea.area_entered.connect(on_area_entered)
	destroyArea.area_exited.connect(area_exit)
	destroyArea.body_entered.connect(destroy)
	destroyArea.body_exited.connect(body_exit)
	destroyArea.monitoring = true
func debrisPos(body): 
	var pos = to_local(body.position)
	pos.y = 0 + randi_range(-6,6)
	return pos
func damage(body : Node2D):
	if(!visible): return
	if "buildingType" in body && "destroyed" in body && !body.destroyed:
		LevelInfo.set_shake(0.6)
		if "damage" in body: body.damage(1)
		AudioHandler.play_audio(AudioHandler.Destroy, -5, 0.5)
		if body.buildingType == "house":
			var newDebris = $Debris.duplicate()
			newDebris.visible = true
			
			newDebris.position = debrisPos(body)
			add_child(newDebris)
			
	if "person" in body:
		LevelInfo.set_shake(0.3)
		var newDebris = $Debris.duplicate()
		newDebris.visible = true
		newDebris.texture = load("res://Assets/Person.png")
		newDebris.position = debrisPos(body)
		add_child(newDebris)
		body.destroy(1)
			
	
func fade():
	$GPUParticles2D.emitting = false
	$GPUParticles2D.visible = false
	while(modulate.a > 0):
		modulate.a -= get_process_delta_time()
		await get_tree().process_frame
	visible = false
func on_stop():
	queue_free()
var colliding = []
func destroy(body):
	colliding.append(body)
	damage(body)
func on_area_entered(area): destroy(area.get_parent())
func body_exit(body): colliding.erase(body)
func area_exit(area): body_exit(area.get_parent())
func power_changed():  pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	interactableType = "Tsunami"
	LevelInfo.selected_power_changed.connect(power_changed)
var timeSinceDamage = 0
var lastValidPos = Vector2(0,0)
func onDragEnd():
	if(position != lastValidPos): AudioHandler.play_audio(AudioHandler.No, 0, 1, true)
	else: AudioHandler.play_audio(AudioHandler.Drag, 0, 0.75, true)
	position = lastValidPos
	modulate.b = 1
	modulate.r = 1
	modulate.g = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!visible): return
	velocity = Vector2.from_angle(rotation - PI/2) * 40		
	if(LevelInfo.started):
		#print(velocity * delta)
		LevelInfo.set_shake(0.1)
		if(crossedLand && !grass_under()): fade()
		if(grass_under()): crossedLand = true
		
		position += velocity * delta
		velocity.move_toward(Vector2(0,0), delta)
	elif(dragging):
		if(LevelInfo.started): dragging = false
		position = get_global_mouse_position() - dragOffset
		if(grass_under()):
			modulate.b = 0
			modulate.r = 1
			modulate.g = 0
		else:
			lastValidPos = position
			modulate.b = 1
			modulate.r = 1
			modulate.g = 1
		
		
	super._process(delta)
	timeSinceDamage -= delta
	if(timeSinceDamage <= 0):
		timeSinceDamage = 0.2
		for i in colliding:
			damage(i)
	
func move_toward_velocity(delta, vel): return
	
