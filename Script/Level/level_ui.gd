extends CanvasLayer

@onready var startButton : TextureButton = $StartButton

func start_button_pressed():
	LevelInfo.start()
	startButton.visible = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startButton.pressed.connect(start_button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
