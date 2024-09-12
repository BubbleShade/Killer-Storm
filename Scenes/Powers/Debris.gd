extends Sprite2D
var endAnimate = false
func move():
	var start = position
	var end = Vector2(14, -20) + Vector2(randf_range(-2,3),randf_range(-8,8))
	while position.distance_to(end) > 1:
		position = position.move_toward(end, get_process_delta_time() * 50)
		await get_tree().process_frame
		if(endAnimate): return
	z_index = -1
	end = Vector2(-20, -20) + Vector2(randf_range(-3,2),randf_range(-8,8))
	while position.distance_to(end) > 1:
		position = position.move_toward(end, get_process_delta_time() * 50)
		await get_tree().process_frame
		if(endAnimate): return
	z_index = 1
	move()
func on_end():
	endAnimate = true
	var end = Vector2(position.x, 0)
	var time = 0
	while position.distance_to(end) > 1:
		time += get_process_delta_time()
		position = position.move_toward(end, time * 2)
		await get_tree().process_frame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(randi_range(1,2) == 1): flip_h = true
	if(visible): move()
	LevelInfo.on_stop.connect(on_end)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
