extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_click_sound)
	mouse_entered.connect(_on_hover_sound)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



############################# button redirects
############################# https://youtu.be/tmSBGJGDUuQ
func _on_hover_sound(): pass
	#if(get_tree()):
		#AudioHandler.play(get_tree().get_root(), LevelInfo.button_hover)
func _on_click_sound(): pass
	#if(get_tree()):
		#AudioHandler.play(get_tree().get_root(), LevelInfo.button_click)
# https://forum.godotengine.org/t/change-scene-without-lose-the-previous-scene/17585/3
func _on_settings_pressed_menu():
	#get_tree().change_scene_to_file("res://Scenes/Menus/settings.tscn")
	MenuHandler.switchScene("res://Scenes/Menus/settings.tscn", "Settings", "MainMenu")
func _on_settings_pressed_pause():
	MenuHandler.switchScene("res://Scenes/Menus/settings.tscn", "Settings", "PauseMenu")
func _unpause():
	get_tree().paused = false
# https://forum.godotengine.org/t/change-scene-without-lose-the-previous-scene/17585/3
func _on_back_pressed():
	print("Back")
	MenuHandler.returnToScene()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/main menu.tscn")
	MenuHandler.clearScenes()

func _open_menu(name: String, nodeName: String):
	MenuHandler.genScene("res://Scenes/Menus/%s.tscn" % name, nodeName)
func _switch_menu(name: String, nodeName: String, currentNodeName: String):
	MenuHandler.switchScene("res://Scenes/Menus/%s.tscn" % name, nodeName, currentNodeName)
func _restart_level():
	get_tree().paused = false
	MenuHandler.clearScenes()
	print(LevelInfo.get_level_handler())
	if(LevelInfo.get_level_handler()): LevelInfo.get_level_handler().restart()





func _on_settings_pressed():
	pass # Replace with function body.


func _on_pressed():
	pass # Replace with function body.
