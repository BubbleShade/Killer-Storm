extends Node

var Delete : AudioStream = load("res://Audio/Delete.wav")
var LevelSelect : AudioStream = load("res://Audio/LevelSelect.wav")
var LevelSelectHover : AudioStream = load("res://Audio/LevelSelectHover.wav")
var BigExplosion : AudioStream = load("res://Audio/BigExplosion.wav")

var Rumble : AudioStream = load("res://Audio/Rumble.wav")
var PowerHover : AudioStream = load("res://Audio/PowerHover.wav")
var Start : AudioStream = load("res://Audio/Start.wav")
var Stop : AudioStream = load("res://Audio/Stop.wav")
var Restart : AudioStream = load("res://Audio/Restart.wav")
var NextLevel : AudioStream = load("res://Audio/NextLevel.wav")
var Drag : AudioStream = load("res://Audio/Drag.wav")
var No : AudioStream = load("res://Audio/No.wav")
var Place : AudioStream = load("res://Audio/Place.wav")
var Toggle : AudioStream = load("res://Audio/Toggle.wav")
var Ding : AudioStream = load("res://Audio/Ding.wav")
var LightningExplosion : AudioStream = load("res://Audio/LightningExplosion.wav")
var Rain : AudioStream = load("res://Audio/Rain.wav")
var Destroy : AudioStream = load("res://Audio/Destroy.wav")
var Tornado : AudioStream = load("res://Audio/Tornado.wav")
var SliderChange : AudioStream = load("res://Audio/SliderChange.wav")
var Click : AudioStream = load("res://Audio/ButtonClick.wav")
var Hover : AudioStream = load("res://Audio/ButtonHover.wav")

var loops : Dictionary = {}

func clearLoops():
	loops = {}
func getVolume(): 
	if(LevelInfo.volume == 0): return -100
	return (LevelInfo.volume - 5) * 3
func on_volume_change():
	for i in loops:
		loops[i].volume_db = getVolume()
func _ready():
	LevelInfo.on_volume_changed.connect(on_volume_change)
	SceneTransition.scene_changed.connect(clearLoops)
	
func createAudioStreamPlayer(audio : AudioStream, volumeAdjust : float = 0, pitch : float = 1) -> AudioStreamPlayer:
	var audioStreamPlayer : AudioStreamPlayer = AudioStreamPlayer.new()
	audioStreamPlayer.stream = audio
	audioStreamPlayer.volume_db = volumeAdjust + getVolume()
	audioStreamPlayer.pitch_scale = pitch
	get_tree().current_scene.add_child(audioStreamPlayer)
	
	return audioStreamPlayer

# Called when the node enters the scene tree for the first time.
func play_audio(audio : AudioStream, volumeAdjust : float = 0, pitch : float = 1, process_on_pause : float = true):
	if(LevelInfo.volume == 0): return
	var audioStreamPlayer : AudioStreamPlayer = createAudioStreamPlayer(audio, volumeAdjust, pitch)
	if(process_on_pause): audioStreamPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	audioStreamPlayer.finished.connect(func(): audioStreamPlayer.queue_free())
	audioStreamPlayer.play()

func loop_audio(key : String, audio : AudioStream, volumeAdjust : float = 0, pitch : float = 1, process_on_pause : float = false):
	var audioStreamPlayer : AudioStreamPlayer = createAudioStreamPlayer(audio, volumeAdjust, pitch)
	if(process_on_pause): audioStreamPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	audioStreamPlayer.connect("finished", audioStreamPlayer.play)
	#audioStreamPlayer.finished.connect(audioStreamPlayer.play)
	audioStreamPlayer.play()
	loops[key] = audioStreamPlayer
func update_loop(key : String, playing : bool):
	var loop : AudioStreamPlayer = loops[key] 
	loop.playing = playing
func change_loop_audio(key : String, deltaVolume : float):
	var loop : AudioStreamPlayer = loops[key] 
	loop.volume_db += deltaVolume
func set_loop_audio(key : String, volume : float):
	var loop : AudioStreamPlayer = loops[key] 
	loop.volume_db = volume + getVolume()
func kill_loop(key):
	var loop : AudioStreamPlayer = loops[key] 
	loop.queue_free()
	loops.erase(key)
