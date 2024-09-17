extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_on_hover_sound)
	pass # Replace with function body.

func _on_hover_sound(): 
	AudioHandler.play_audio(AudioHandler.LevelSelectHover, 0, 1, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
