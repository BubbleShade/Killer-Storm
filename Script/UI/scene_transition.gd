extends CanvasLayer
@onready var colorRect = $ColorRect
@onready var animPlayer = $AnimationPlayer
signal scene_changed
var loaded = false
var particles = ["Explosion","LightningExplosion","StormCloud","Tornado"]
# Called when the node enters the scene tree for the first time.
func load_scene(Scene : String, anim = "Fade"):
	get_tree().paused = true
	animPlayer.play(anim)
	await animPlayer.animation_finished
	scene_changed.emit()
	get_tree().change_scene_to_file("res://Scenes/%s.tscn" % Scene)
	animPlayer.play_backwards(anim)
	await animPlayer.animation_finished
	get_tree().paused = false
func loadParticles(Scene : String, anim = "DropDown"):
	#get_tree().paused = true
	var meteor = $ColorRect2/TextureRect
	meteor.modulate = Color(1,1,1)
	if(!loaded): meteor.modulate = Color(0,0,0)
	else: meteor.modulate = Color(1,1,1)
	
	animPlayer.play(anim)
	await animPlayer.animation_finished
	
	if(!loaded): 
		var processed : float = 0
		var progress = []
		var lenChildren :float = len(particles) +1
		var totalProgress = 0
		$Node/Particle.emitting = true
		$Node/Particle.visible = true
		var pathS
		for i in particles:
			pathS = "OtherAssets/Particles/%s.tres" % i
			var err = ResourceLoader.load_threaded_request(pathS)
			if err != OK:
				print("Can't start the threaded load.")
			var m_nError
			
			while true:
				m_nError = ResourceLoader.load_threaded_get_status(pathS, progress)
				totalProgress = (processed + progress[0])/lenChildren
				meteor.modulate = Color(totalProgress,totalProgress,totalProgress)
				match m_nError:
					ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
						print("Fail on %s" %i)
						break
					ResourceLoader.THREAD_LOAD_IN_PROGRESS:
						pass
					ResourceLoader.THREAD_LOAD_FAILED:
						print("Fail on %s" %i)
						break
					ResourceLoader.THREAD_LOAD_LOADED:
						print("Success on %s" %i)
						var processMaterial : ParticleProcessMaterial = ResourceLoader.load_threaded_get(pathS)
						$Node/Particle.process_material = processMaterial
						await get_tree().create_timer(0.1).timeout
						break
					_: break
				await get_tree().process_frame
		meteor.modulate = Color(1,1,1)
		$Node/Particle.emitting = false
		$Node/Particle.visible = false
	scene_changed.emit()
	get_tree().change_scene_to_file("res://Scenes/%s.tscn" % Scene)
	animPlayer.play(anim + "Reverse")
func loadParticlesTest(Scene : String, anim = "DropDown"):
	#get_tree().paused = true
	var meteor = $ColorRect2/TextureRect
	meteor.modulate = Color(1,1,1)
	if(!loaded): meteor.modulate = Color(0,0,0)
	else: meteor.modulate = Color(1,1,1)
	
	animPlayer.play(anim)
	await animPlayer.animation_finished
	
	if(!loaded): 
		var processed : float = 0
		var progress = []
		var lenChildren :float = len(particles) +1
		var totalProgress = 0
		var pathS = "Scenes/ParticleScene.tscn"
		var err = ResourceLoader.load_threaded_request(pathS)
		if err != OK:
			print("Can't start the threaded load.")
		var m_nError
			
		while true:
			m_nError = ResourceLoader.load_threaded_get_status(pathS, progress)
			totalProgress = (processed + progress[0])/lenChildren
			meteor.modulate = Color(totalProgress,totalProgress,totalProgress)
			match m_nError:
				ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
					print("Invalid")
					break
				ResourceLoader.THREAD_LOAD_IN_PROGRESS:
					pass
				ResourceLoader.THREAD_LOAD_FAILED:
					print("LoadFailed")
					break
				ResourceLoader.THREAD_LOAD_LOADED:
					print("LoadSuccess")
					var LoadedScene = ResourceLoader.load_threaded_get(pathS)
					
					await get_tree().create_timer(0.1).timeout
					print(LoadedScene)
					var instantiatedScene = LoadedScene.instantiate()
					await get_tree().create_timer(0.1).timeout
					instantiatedScene.queue_free()
					break
				_: break
			await get_tree().process_frame
		meteor.modulate = Color(1,1,1)
	scene_changed.emit()
	get_tree().change_scene_to_file("res://Scenes/%s.tscn" % Scene)
	animPlayer.play(anim + "Reverse")
	#get_tree().paused = false
func _process(delta): pass
func _ready() -> void:
	colorRect.visible = false
