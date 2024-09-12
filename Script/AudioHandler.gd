extends Node

var LightningExplosion : AudioStream = load("res://Audio/LightningExplosion.wav")
var Rain : AudioStream = load("res://Audio/Rain.wav")


var loops : Dictionary = {}
func createAudioStreamPlayer(audio : AudioStream, volumeAdjust : float = 0, pitch : float = 1) -> AudioStreamPlayer:
	var audioStreamPlayer : AudioStreamPlayer = AudioStreamPlayer.new()
	audioStreamPlayer.stream = audio
	audioStreamPlayer.volume_db = volumeAdjust
	audioStreamPlayer.pitch_scale = pitch
	get_tree().current_scene.add_child(audioStreamPlayer)
	
	return audioStreamPlayer

# Called when the node enters the scene tree for the first time.
func play_audio(audio : AudioStream, volumeAdjust : float = 0, pitch : float = 1):
	var audioStreamPlayer : AudioStreamPlayer = createAudioStreamPlayer(audio, volumeAdjust, pitch)
	
	audioStreamPlayer.finished.connect(func(): audioStreamPlayer.queue_free())
	audioStreamPlayer.play()

func loop_audio(key : String, audio : AudioStream, volumeAdjust : float = 0, pitch : float = 1):
	var audioStreamPlayer : AudioStreamPlayer = createAudioStreamPlayer(audio, volumeAdjust, pitch)
	
	audioStreamPlayer.finished.connect(func(): audioStreamPlayer.play())
	audioStreamPlayer.play()
	loops[key] = audioStreamPlayer
func update_loop(key : String, playing : bool):
	var loop : AudioStreamPlayer = loops[key] 
	loop.playing = playing
func change_loop_audio(key : String, deltaVolume : float):
	var loop : AudioStreamPlayer = loops[key] 
	loop.volume_db += deltaVolume
func kill_loop(key):
	var loop : AudioStreamPlayer = loops[key] 
	loop.queue_free()
	loops.erase(key)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
