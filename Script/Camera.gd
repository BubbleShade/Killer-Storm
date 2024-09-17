extends Camera2D
@export var speed = 100
@export var randomStrength: float = 30.0
@export var shakeFade : float = 5.0
var shake_strength : float = 0.0


var maxXDif = 200
var maxYDif = 150

func set_shake(shake):
	shake_strength = max(shake,shake_strength)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x = get_viewport().get_visible_rect().size.x/2
	var y = get_viewport().get_visible_rect().size.y/2

	limit_right = position.x + maxXDif# + x
	limit_left = position.x - maxXDif# - x
	limit_bottom = position.y + maxYDif# + y
	limit_top = position.y - maxYDif# - y

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move = Input.get_vector("left","right","up","down") * speed * delta
	position = Vector2(clamp(position.x + move.x, limit_left, limit_right), clamp(position.y + move.y, limit_top, limit_bottom))
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()

func randomOffset():
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	
