extends CanvasLayer

@export var enabledButtons : Dictionary = {}
var buttonBank : Dictionary = {}

@export var star1Threshold : float = 0
@export var star2Threshold : float = 0
@export var star3Threshold : float = 0


@onready var startButton : TextureButton = $Panel/StartButton
@onready var stopButton : TextureButton = $Panel/StopButton

@onready var Display : Panel = $Display
@onready var levelHandler : LevelHandler = LevelInfo.get_level_handler()

var temperCosts : Dictionary = {  
	"StormCloud": 10,
	"Wind1": 2,
	"Lightning": 2,
	"Tornado": 30,
	"Tsunami": 50
}

func changeDestruction(percent):
	Display.get_node("Destruction").text = "Destruction:\n{percent}%".format({"percent":percent} )  

func changeTemper(temper):
	Display.get_node("Temper").text = "Temper:\n{temper}".format({"temper":temper} )  

var visibleButtons = []
var focusedButton : Button
func restart(): levelHandler.restart()
func next_level(): levelHandler.next_level()
func on_power_change():
	if(focusedButton): 
		focusedButton.button_pressed = false
		focusedButton = null
func add_button(name, inf):
	if(!name): return
	var button : Button = $Panel/HBoxContainer.get_node(name)
	if(button.visible): return
	var text : RichTextLabel = button.get_node("Amount")
	var temperText : RichTextLabel = button.get_node("TemperCost")
	
	if(inf): text.text = ""
	else: text.text = str(enabledButtons[name])
	temperText.text = "[right]" + str(temperCosts[name])
	button.visible = true
	button.pressed.connect(set_power.bind(button, name))
	visibleButtons.append(button)
func get_button(name) -> Button:
	var button : Button = $Panel/HBoxContainer.get_node(name)
	return button
func on_start():
	LevelInfo.change_power("none")
	for i : Button in visibleButtons:
		i.disabled = true
		i.visible = false
	for i in LevelInfo.get_level_handler().hazards:
		if "interactableType" in i && i.interactableType == "StormCloud":
			add_button("Lightning", true)
	stopButton.visible = true
func end_screen():
	var endScreen : Panel = $EndScreen
	var score = LevelInfo.get_score()
	$EndScreen/Summary.text = "Score: {score}\n[i]Destruction: {destruction}\nTemper: {temper}".format(
		{"score":score, "destruction": levelHandler.destruction * 10, "temper":levelHandler.temper}
	)
	var emptyStar = load("res://Assets/StarEmpty.png")
	var stars = 3
	if(score < star3Threshold):
		$EndScreen/Star3.texture = emptyStar
		stars = 2
		if(score < star2Threshold):
			$EndScreen/Star2.texture = emptyStar
			stars = 1
			if(score < star1Threshold):
				$EndScreen/Star1.texture = emptyStar
				$EndScreen/Next.visible = false
				stars = 0
	LevelInfo.levelStars[levelHandler.LevelNumber-1] = stars
	endScreen.visible = true
func on_stop():
	$Panel.visible = false
	await get_tree().create_timer(1).timeout
	$Display.visible = false
	end_screen()

func on_power_added(power):
	var button : Button = get_button(power)
	var text : RichTextLabel = button.get_node("Amount")
	levelHandler.temper += temperCosts[power]
	if(text.text == ""): return
	buttonBank[power] -= 1
	text.text = str(buttonBank[power])
	if(buttonBank[power] <= 0):
		button.disabled = true
		LevelInfo.change_power("none")
func on_power_removed(power):
	var button : Button = get_button(power)
	var text : RichTextLabel = button.get_node("Amount")
	if(text.text == ""): return
	levelHandler.temper -= temperCosts[power]
	buttonBank[power] += 1
	text.text = str(buttonBank[power])
	button.disabled = false

func start_button_pressed():
	LevelInfo.start()
	startButton.visible = false
	AudioHandler.play_audio(AudioHandler.Start, 0, 1, true)
func stop_button_pressed():
	LevelInfo.stop()
	stopButton.visible = false
	AudioHandler.play_audio(AudioHandler.Stop, 0, 1, true)
	
func set_power(button, power):
	if(LevelInfo.selected_power == power): 
		LevelInfo.change_power("none")
		return
	LevelInfo.change_power(power)
	focusedButton = button
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startButton.pressed.connect(start_button_pressed)
	LevelInfo.on_start.connect(on_start)
	for key in enabledButtons:
		add_button(key, false)
	buttonBank = enabledButtons.duplicate()
	LevelInfo.selected_power_changed.connect(on_power_change)
	LevelInfo.power_added_to_map.connect(on_power_added)
	LevelInfo.power_removed_from_map.connect(on_power_removed)
	LevelInfo.on_stop.connect(on_stop)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(levelHandler.destruction != 0 && levelHandler.maxDestruction != 0): changeDestruction(round((levelHandler.destruction / levelHandler.maxDestruction) * 100))
	changeTemper(levelHandler.temper)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if !MenuHandler.sceneActive():
			MenuHandler.genScene("res://Scenes/UI/PauseMenu.tscn", "PauseMenu")
