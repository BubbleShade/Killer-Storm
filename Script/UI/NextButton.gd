extends Button

func _ready():
	pressed.connect(_on_click_sound)
	mouse_entered.connect(_on_hover_sound)
	pass # Replace with function body.

############################# button redirects
############################# https://youtu.be/tmSBGJGDUuQ
func _on_hover_sound(): 
	AudioHandler.play_audio(AudioHandler.Hover, 0, 1, true)
func _on_click_sound(): 
	AudioHandler.play_audio(AudioHandler.NextLevel, 0, 1, true)
