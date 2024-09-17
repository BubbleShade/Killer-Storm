extends CanvasLayer

var init = true
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel/VolumeSlider").value = LevelInfo.volume
	#get_node("Panel/VolumeSliderMusic").value = LevelInfo.music_volume
	init = false

func _on_volume_slider_value_changed(value):
	if(init): return
	LevelInfo.volume = value
	LevelInfo.on_volume_changed.emit()
	AudioHandler.play_audio(AudioHandler.SliderChange)
func _on_music_volume_slider_value_changed(value):
	if(init): return
	LevelInfo.music_volume = value
	#AudioHandler.play(self, LevelInfo.slider_change)
