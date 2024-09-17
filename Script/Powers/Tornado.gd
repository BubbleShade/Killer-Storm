extends Interactable
class_name Tornado

@export var tileMapName : String
@export var RadiusX : float
@export var RadiusY : float
@onready var Zone : Sprite2D = $Zone

func onDrag(): 
	super.onDrag()
	Zone.visible = true
func onDragEnd():
	super.onDragEnd()
	Zone.visible = false
func on_start(): 
	$GPUParticles2D.emitting = true
	var destroyArea : Area2D = $DestroyArea
	destroyArea.area_entered.connect(on_area_entered)
	destroyArea.area_exited.connect(area_exit)
	destroyArea.body_entered.connect(destroy)
	destroyArea.body_exited.connect(body_exit)
	destroyArea.monitoring = true
func damage(body : Node2D):
	if "buildingType" in body && "destroyed" in body && !body.destroyed:
		LevelInfo.set_shake(0.6)
		if "damage" in body: body.damage(1)
		AudioHandler.play_audio(AudioHandler.Destroy, -5, 0.5)
		if body.buildingType == "house":
			var newDebris = $Debris.duplicate()
			newDebris.visible = true
			
			newDebris.position = to_local(body.position)
			add_child(newDebris)
			#await newDebris.ready
			#newDebris.move()
			#newDebris.move()
	if "person" in body:
		if(body.can_destroy()):
			LevelInfo.set_shake(0.3)
			var newDebris = $Debris.duplicate()
			newDebris.visible = true
			newDebris.texture = load("res://Assets/Person.png")
			newDebris.position = to_local(body.position)
			add_child(newDebris)
			body.destroy(1)
			
	

func on_stop():
	$GPUParticles2D.emitting = false
	$GPUParticles2D.visible = false
	while(modulate.a > 0):
		modulate.a -= get_process_delta_time()
		await get_tree().process_frame
	queue_free()
var colliding = []
func destroy(body):
	colliding.append(body)
	damage(body)
func on_area_entered(area): destroy(area.get_parent())
func body_exit(body): colliding.erase(body)
func area_exit(area): body_exit(area.get_parent())
func power_changed():  Zone.visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	interactableType = "Tornado"
	LevelInfo.selected_power_changed.connect(power_changed)
var timeSinceDamage = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(LevelInfo.started): LevelInfo.set_shake(0.1)
	super._process(delta)
	timeSinceDamage -= delta
	if(timeSinceDamage <= 0):
		timeSinceDamage = 0.2
		for i in colliding:
			damage(i)
	
	if(LevelInfo.started): return
	elif(dragging): Zone.visible = true
func move_toward_velocity(delta, vel):
	velocity = velocity.move_toward(vel*3, delta)
	
