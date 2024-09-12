extends CanvasLayer
@onready var colorRect = $ColorRect
@onready var animPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func load_scene(Scene : String, anim = "Fade"):
	"""if(anim == "DropDown"):
		animPlayer.play(anim)
		await animPlayer.animation_finished
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/%s.tscn" % Scene)
		animPlayer.play(anim + "Reverse")
		return
	if(anim == "FadeWipe"):
		animPlayer.play(anim)
		await animPlayer.animation_finished
		get_tree().change_scene_to_file("res://Scenes/%s.tscn" % Scene)
		animPlayer.play(anim + "Reverse")
		return"""
	animPlayer.play(anim)
	await animPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/%s.tscn" % Scene)
	animPlayer.play_backwards(anim)
func _process(delta): pass
func _ready() -> void:
	colorRect.visible = false
