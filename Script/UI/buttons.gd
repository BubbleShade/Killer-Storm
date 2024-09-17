extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_click_sound)
	mouse_entered.connect(_on_hover_sound)
	pass # Replace with function body.

func _on_hover_sound(): 
	AudioHandler.play_audio(AudioHandler.Hover, 0, 1, true)
func _on_click_sound(): 
	AudioHandler.play_audio(AudioHandler.Click, 0, 1, true)
# https://forum.godotengine.org/t/change-scene-without-lose-the-previous-scene/17585/3
func _on_settings_pressed_menu():
	#get_tree().change_scene_to_file("res://Scenes/Menus/settings.tscn")
	MenuHandler.switchScene("res://Scenes/UI/Settings.tscn", "Settings", "MainMenu")
func _on_settings_pressed_pause():
	MenuHandler.switchScene("res://Scenes/UI/Settings.tscn", "Settings", "PauseMenu")
func _unpause():
	get_tree().paused = false
# https://forum.godotengine.org/t/change-scene-without-lose-the-previous-scene/17585/3
func _on_back_pressed():
	print("Back")
	MenuHandler.returnToScene()

func _on_main_menu_pressed():
	get_tree().paused = false
	SceneTransition.load_scene("UI/MainMenu")
	MenuHandler.clearScenes()

func _open_menu(name: String, nodeName: String):
	MenuHandler.genScene("res://Scenes/UI/%s.tscn" % name, nodeName)
func _switch_menu(name: String, nodeName: String, currentNodeName: String):
	MenuHandler.switchScene("res://Scenes/UI/%s.tscn" % name, nodeName, currentNodeName)
func _restart_level():
	get_tree().paused = false
	AudioHandler.play_audio(AudioHandler.Restart, 0, 1, true)
	MenuHandler.clearScenes()
	print(LevelInfo.get_level_handler())
	if(LevelInfo.get_level_handler()): LevelInfo.get_level_handler().restart()





func _on_settings_pressed():
	pass # Replace with function body.


func _on_pressed():
	pass # Replace with function body.
