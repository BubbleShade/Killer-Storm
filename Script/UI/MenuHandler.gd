extends Node
var NodeName = []
var back_screen = []
func sceneActive(): return len(back_screen) > 0
# https://forum.godotengine.org/t/change-scene-without-lose-the-previous-scene/17585/3
func genScene(path, nodeName):
	var TheRoot = get_node("/root")  # need this as get_node will stop work once you remove your self from the Tree
	back_screen.append(null)
	NodeName.append(nodeName)
	var NextScene = load(path)
	NextScene = NextScene.instantiate()
	TheRoot.add_child(NextScene)
func switchScene(path, nodeName, hostNodeName):
	var TheRoot = get_node("/root")  # need this as get_node will stop work once you remove your self from the Tree
	var ThisScene = get_node("/root/%s" % hostNodeName)
	ThisScene.visible = false
	back_screen.append(ThisScene)
	NodeName.append(nodeName)
	var NextScene = load(path)
	NextScene = NextScene.instantiate()
	TheRoot.add_child(NextScene)
# https://forum.godotengine.org/t/change-scene-without-lose-the-previous-scene/17585/3
func returnToScene():
	var TheRoot = get_node("/root")
	var ThisScene = get_node("/root/%s" % NodeName.pop_at(-1))
	TheRoot.remove_child(ThisScene)
	ThisScene.call_deferred("free")
	var NextScene = back_screen.pop_at(-1)
	if(NextScene != null): 
		NextScene.visible = true
		print("Revisible")


func clearScenes():
	var TheRoot = get_node("/root")
	for i in range(len(back_screen)):
		var ThisScene = get_node("/root/%s" % NodeName[i])
		TheRoot.remove_child(ThisScene)
		ThisScene.call_deferred("free")
		var NextScene = back_screen[i]
		TheRoot.add_child(NextScene)
	NodeName = []
	back_screen = []
