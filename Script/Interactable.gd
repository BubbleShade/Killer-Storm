extends Node2D
class_name Interactable

var dragging = false
var dragOffset = Vector2(0,0)

@onready var button : Button = $Button

func on_button_down():
	if(LevelInfo.started): return
	dragging = true
	dragOffset = get_global_mouse_position() - global_position
func on_button_up():
	dragging = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.button_down.connect(on_button_down)
	button.button_up.connect(on_button_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(dragging):
		if(LevelInfo.started): dragging = false
		print("Dragging")
		position = get_global_mouse_position() - dragOffset
