extends Button

func _ready():
	mouse_entered.connect(_on_hover_sound)

func _on_hover_sound(): 
	AudioHandler.play_audio(AudioHandler.Hover, 0, 1, true)

func _on_pressed() -> void:
	SceneTransition.loadParticles("Levels/Level1")
	AudioHandler.play_audio(AudioHandler.Ding, 0, 1, true)
