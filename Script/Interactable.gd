extends Node2D
class_name Interactable

var dragging = false
var dragOffset = Vector2(0,0)
var interactableType
@onready var drag : Button = $Drag

func on_button_down():
	if(LevelInfo.started): return
	dragging = true
	dragOffset = get_global_mouse_position() - global_position
func on_button_up():
	dragging = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func start():
	drag.button_down.connect(on_button_down)
	drag.button_up.connect(on_button_up)
	LevelInfo.get_level_handler().hazards.append(self)
func preview():
	modulate.a = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(dragging):
		if(LevelInfo.started): dragging = false
		print("Dragging")
		position = get_global_mouse_position() - dragOffset
