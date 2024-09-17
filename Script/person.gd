extends CharacterBody2D

@export var speed = 10
@export var runSpeed = 30
@export var target_object : Node2D
@export var loitering  = 0.5

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D 
var person = true
var invulnerability = 0.1
var pathing = false
var paused = false
var randDirection

func AI_game_started():
	var levelHandler : LevelHandler = LevelInfo.get_level_handler()
	var choseHouse
	var closest = 100
	for house in levelHandler.houses:
		var dist = position.distance_to(house.position) / (1 + (house.hp/10))
		if(dist < closest): 
			choseHouse = house
			closest = dist
	if choseHouse:
		target_object = choseHouse
		make_path()
		return
	else:
		if(!randDirection): randDirection = randf_range(-PI, PI)
		randDirection += randf_range(-1,1)
		path_to(position + (Vector2.from_angle(randDirection) * randi_range(4,14)))
func AI_before_game_start():
	var levelHandler : LevelHandler = LevelInfo.get_level_handler()
	var house
	if(len(levelHandler.buildings) <= 0): return
	while true: 
		house = levelHandler.buildings.pick_random()
		if(position.distance_to(house.position) > 4): break
	target_object = house
	make_path()
	if(nav_agent.is_target_reachable()):return
	var closest = 100
	for newHouse in levelHandler.buildings:
		var dist = position.distance_to(newHouse.position)
		if(dist < closest): 
			house = newHouse
			closest = dist
		if(dist > 4): break
	target_object = house
	make_path()
	if(nav_agent.is_target_reachable()):return
	closest = 100
	for newHouse in levelHandler.buildings:
		var dist = position.distance_to(newHouse.position)
		if(dist < closest): 
			house = newHouse
			closest = dist
	target_object = house
	make_path()
	
	
var walk_anim_time = 0
func run_AI(delta):
	if(pathing):
		walk_anim_time += delta
		rotation = sin(walk_anim_time*speed*0.5)/4
		if(target_object and target_object.destroyed):
			target_object = null
		else: return
	walk_anim_time = 0
	rotation = 0
	if(LevelInfo.started):
		AI_game_started()
		return
	if(loitering > 0):
		loitering -= delta
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
	
	if("inhabitable" in target_object && target_object.inhabitable == true):
		if(LevelInfo.started):
			enterHouse(target_object)
			return
		if(randf_range(0,3) <= 2):
			enterHouse(target_object)
			return
	loitering = randf_range(3,5)
	target_object = null
	#get_tree().create_timer(randf_range(1,3)).timeout.connect(run_AI)
	
func on_start():
	loitering = 0
	nav_agent.set_navigation_layer_value(2, true)
	speed = runSpeed + randi_range(-10,10)
	pathing = false
func _ready() -> void:
	if(LevelInfo.started): 
		on_start()
	else:
		LevelInfo.on_start.connect(on_start)
	make_path()
	nav_agent.target_reached.connect(on_reach)

func _physics_process(_delta:float):
	if(paused): return
	run_AI(_delta)
	_follow_path(_delta)
var time_since_repath = 0.1
func _process(delta: float) -> void:
	if(paused): return
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

func blast():
	var levelHandler : LevelHandler = LevelInfo.get_level_handler()
	velocity = Vector2.from_angle(randf() * TAU) * randf_range(40,50)/2
	var delta
	var timePassed = 0
	paused = true
	var rotateDir = 1
	if(velocity.x < 0): rotateDir = -1
	levelHandler.destruction += 1
	while timePassed < 1:
		
		invulnerability = 1
		delta = get_physics_process_delta_time()
		timePassed += delta
		velocity = velocity.move_toward(Vector2(0,0), delta*50)
		rotation = move_toward(rotation, (PI/2) * rotateDir, delta*10)
		modulate.a -= delta
		move_and_slide()
		await get_tree().physics_frame
	queue_free()

func damage(power):
	if(invulnerability <= 0):
		invulnerability = 0.5
		blast()
func can_destroy():
	if(invulnerability <= 0):
		return true
	return false
func destroy(power):
	invulnerability = 0.5
	var levelHandler : LevelHandler = LevelInfo.get_level_handler()
	levelHandler.destruction += 1
	queue_free()
	return true
