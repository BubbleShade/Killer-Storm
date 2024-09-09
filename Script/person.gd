extends CharacterBody2D

@export var speed = 10
@export var runSpeed = 30
@export var target_object : Node2D

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D 

func on_reach():
	if("people" in target_object):
		target_object.people += 1
		queue_free()

func _ready() -> void:
	make_path()
	nav_agent.target_reached.connect(on_reach)

func _physics_process(_delta:float):
	if(LevelInfo.started): speed = runSpeed
	_follow_path(_delta)
	
func _follow_path(_delta:float):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = velocity.move_toward(dir * speed, _delta * 1000)
	move_and_slide()
	
func make_path():
	print(target_object)
	nav_agent.target_position = target_object.position
func damage(power):
	queue_free()
