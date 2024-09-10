extends CanvasLayer

@export var storm = false

@onready var startButton : TextureButton = $StartButton
var visibleButtons = []
var focusedButton : Button
func on_power_change():
	if(focusedButton): 
		focusedButton.button_pressed = false
		focusedButton = null
func add_button(name, powerName):
	var button : Button = $Panel/HBoxContainer.get_node(name)
	if(button.visible): return
	button.visible = true
	button.pressed.connect(set_power.bind(button, powerName))
	visibleButtons.append(button)
func on_start():
	LevelInfo.change_power("none")
	for i in visibleButtons:
		i.visible = false
	for i in LevelInfo.get_level_handler().hazards:
		if i.interactableType == "StormCloud":
			add_button("Lightning", "Lightning")
	
func start_button_pressed():
	LevelInfo.start()
	startButton.visible = false
func set_power(button, power):
	if(LevelInfo.selected_power == power): 
		LevelInfo.change_power("None")
		return
	LevelInfo.change_power(power)
	focusedButton = button
	print(button.button_pressed)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startButton.pressed.connect(start_button_pressed)
	LevelInfo.on_start.connect(on_start)
	if(storm):
		add_button("Storm", "StormCloud")
	LevelInfo.selected_power_changed.connect(on_power_change)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
