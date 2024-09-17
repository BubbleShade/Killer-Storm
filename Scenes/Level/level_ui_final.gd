extends CanvasLayer

func setVis(): $EndScreen.visible = true

func on_press():
	$Panel.visible = false
	get_tree().current_scene.get_node("Meteor").start()
	get_tree().current_scene.get_node("Meteor").end.connect( setVis )
