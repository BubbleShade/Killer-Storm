extends Node2D
class_name Interactable

var dragging = false
var dragOffset = Vector2(0,0)
var interactableType : String
var velocity : Vector2 = Vector2(0,0)
@onready var drag : Button = $Drag
@export var rotatable = false
func onDrag(): pass
func onDragEnd(): pass

func _input(event):
	if not (rotatable && dragging): return
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				rotate(-PI/20)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				rotate(PI/20)
func clear():
	LevelInfo.power_removed_from_map.emit(interactableType)
	queue_free()
func on_start(): pass
func on_stop(): pass
func on_button_press(event : InputEvent):
	if(LevelInfo.started): return
	if event is not InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			onDrag()
			dragOffset = get_global_mouse_position() - global_position
		else:
			dragging = false
			onDragEnd()
	elif event.pressed && event.button_index == MOUSE_BUTTON_RIGHT:
		clear()
	
func on_button_up():
	dragging = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelInfo.on_start.connect(on_start)
	LevelInfo.on_stop.connect(on_stop)
	pass
func start():
	drag.gui_input.connect(on_button_press)
	#drag.button_down.connect(on_button_down)
	#drag.button_up.connect(on_button_up)
	LevelInfo.get_level_handler().hazards.append(self)
func preview():
	modulate.a = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(LevelInfo.started):
		#print(velocity * delta)
		position += velocity * delta
		velocity.move_toward(Vector2(0,0), delta)
	elif(dragging):
		if(LevelInfo.started): dragging = false
		position = get_global_mouse_position() - dragOffset

func move_toward_velocity(delta, vel):
	velocity = velocity.move_toward(vel, delta)
	#print(velocity)
