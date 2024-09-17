extends Sprite2D

@export var moveToward = Vector2(0,0)
signal end()

# Called when the node enters the scene tree for the first time.
func start() -> void:
	LevelInfo.start()
	visible = true
	var dist = 1000
	AudioHandler.loop_audio("rumble", AudioHandler.Rumble, -300)
	while dist > 1:
		position = position.move_toward(moveToward, get_process_delta_time() * 10)
		dist = position.distance_to(moveToward)
		LevelInfo.set_shake(100/dist)
		AudioHandler.set_loop_audio("rumble", -0.3 * dist)
		await get_tree().process_frame
	AudioHandler.kill_loop("rumble")
	AudioHandler.play_audio(AudioHandler.BigExplosion, -2, 1)
	var particles = $GPUParticles2D
	particles.emitting = true
	remove_child(particles)
	get_tree().current_scene.add_child(particles)
	particles.position = position
	visible = false
	await get_tree().create_timer(1.2).timeout
	get_tree().current_scene.get_node("Grass").queue_free()
	get_tree().current_scene.get_node("Path").queue_free()
	get_tree().current_scene.get_node("Node").queue_free()
	await get_tree().create_timer(3).timeout
	end.emit()
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
