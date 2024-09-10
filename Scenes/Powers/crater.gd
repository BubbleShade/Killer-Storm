extends Sprite2D
class_name Crater
var fading = false
@export var fadeTime = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func fade_after(time):
	await get_tree().create_timer(fadeTime).timeout
	fading = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(fading):
		modulate.a -= delta * (1/fadeTime)
		if(modulate.a <= 0): self.queue_free()
