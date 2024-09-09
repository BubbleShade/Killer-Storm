extends Sprite2D

@export var hp = 1
@export var people : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelInfo.houses.append(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
