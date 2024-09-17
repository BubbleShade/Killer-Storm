extends Button

func toggled_func(toggled_on):
	if(toggled_on): AudioHandler.play_audio(AudioHandler.Toggle, 0, 1, true)
	elif(!disabled && visible): AudioHandler.play_audio(AudioHandler.Toggle, 0, 0.75, true)
func on_hover():
	if(!disabled && visible): AudioHandler.play_audio(AudioHandler.PowerHover, 0, 1, true)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggled.connect(toggled_func)
	mouse_entered.connect(on_hover)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
