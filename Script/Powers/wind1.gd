extends Interactable

@export var wind_speed = 6
@export var accel = 10

@onready var area : Area2D = $Area2D
var colliding : Array = []


func on_area_enter(area : Area2D):
	colliding.append(area.get_parent())
func on_area_exit(area : Area2D):
	colliding.erase(area.get_parent())
func on_start():
	visible = false
	area.monitoring = true
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	interactableType = "Wind1"
	LevelInfo.on_start.connect(on_start)
	area.area_entered.connect(on_area_enter)
	area.area_exited.connect(on_area_exit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	for i in colliding:
		if "move_toward_velocity" in i:
			#print(rotation - PI/2)
			i.move_toward_velocity(delta*accel, Vector2.from_angle(rotation - PI/2) * wind_speed)
