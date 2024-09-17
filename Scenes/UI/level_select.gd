extends CanvasLayer
var full_star = load("res://Assets/StarFull.png")
func openLevel(level):
	AudioHandler.play_audio(AudioHandler.LevelSelect,0,1,true)
	SceneTransition.loadParticles("Levels/Level%s" % level)
	get_tree().paused = false
	await get_tree().create_timer(1).timeout
	MenuHandler.clearScenes()
func sum_array(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum
func questionClicked():
	if(sum_array(LevelInfo.levelStars) >= 18):
		AudioHandler.play_audio(AudioHandler.LevelSelect,0,1,true)
		SceneTransition.load_scene("Levels/Final")
		
		get_tree().paused = false
		await get_tree().create_timer(1).timeout
		MenuHandler.clearScenes()
func _ready():
	for i in range(6):
		for j in LevelInfo.levelStars[i]:
			if(get_node("Panel/Level%s" % (i+1))): get_node("Panel/Level%s" % (i+1)).get_node("Star%s" % (j+1)).texture = full_star
