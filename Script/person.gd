extends CharacterBody2D

@export var speed = 10
@export var runSpeed = 30
@export var target_object : Node2D

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D 
var invulnerability = 0.1
var pathing = false
var randDirection
func AI_game_started():
	var levelHandler : LevelHandler = LevelInfo.get_level_handler()
	var house
	var choseHouse
	var closest = 100
	for i in levelHandler.houses:
		house = levelHandler.houses.pick_random()
		var dist = position.distance_to(house.position) / (1 + (house.hp/10))
		if(dist < closest): choseHouse = house
	if house:
		target_object = house
		make_path()
		return
	else:
		if(!randDirection): randDirection = randf_range(-PI, PI)
		randDirection += randf_range(-1,1)
		path_to(position + (Vector2.from_angle(randDirection) * randi_range(4,14)))
func AI_before_game_start():
	var levelHandler : LevelHandler = LevelInfo.get_level_handler()
	var house
	
	while true: 
		house = levelHandler.houses.pick_random()
		if(position.distance_to(house.position) > 4): break
	print(house)
	target_object = house
	make_path()
func run_AI():
	if(pathing):
		if(target_object and target_object.destroyed):
			target_object = null
		else: return
	if(LevelInfo.started):
		AI_game_started()
		return
	AI_before_game_start()
func enterHouse(house):
	target_object.people += 1
	queue_free()
func on_reach():
	if(!pathing): return
	pathing = false
	if(!target_object):
		return
	if(LevelInfo.started):
		if("people" in target_object): 
			enterHouse(target_object)
			return
	if("people" in target_object):
		if(randf_range(0,3) <= 2):
			enterHouse(target_object)
			return
	target_object = null
	#get_tree().create_timer(randf_range(1,3)).timeout.connect(run_AI)
	
func on_start():
	nav_agent.set_navigation_layer_value(2, true)
	speed = runSpeed
	pathing = false
func _ready() -> void:
	if(LevelInfo.started): 
		on_start()
	else:
		LevelInfo.on_start.connect(on_start)
	make_path()
	nav_agent.target_reached.connect(on_reach)

func _physics_process(_delta:float):
	run_AI()
	_follow_path(_delta)
var time_since_repath = 0.1
func _process(delta: float) -> void:
	invulnerability -= delta
	time_since_repath -= delta
	if(time_since_repath <= 0 and target_object and pathing):
		make_path()
		
func _follow_path(_delta:float):
	if(pathing):
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = velocity.move_toward(dir * speed, _delta * 1000)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, _delta * 1000)
	move_and_slide()
	
func make_path():
	if(not target_object): 
		pathing = false
		return
	nav_agent.target_position = target_object.position
	pathing = true
	
func path_to(pos : Vector2):
	nav_agent.target_position = pos
	pathing = true

func damage(power):
	if(invulnerability <= 0):
		queue_free()
