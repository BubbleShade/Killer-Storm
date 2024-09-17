extends Interactable
class_name Cloud

@export var tileMapName : String
@export var RadiusX : float
@export var RadiusY : float
@onready var Zone : Sprite2D = $Zone

func onDrag(): 
	super.onDrag()
	Zone.visible = true
func onDragEnd():
	super.onDragEnd()
	Zone.visible = false
func on_start(): $GPUParticles2D.emitting = true
func on_stop():
	$GPUParticles2D.emitting = false
	while(modulate.a > 0):
		modulate.a -= get_process_delta_time()
		await get_tree().process_frame
	queue_free()
# https://www.redblobgames.com/grids/circle-drawing/
func inside_circle(center : Vector2, tile : Vector2, radiusX : float, radiusY : float) -> bool:
	var yRadiusModifier = radiusX / radiusY
	var dx = center.x - tile.x
	var dy = (center.y - tile.y) * yRadiusModifier;
	var distance = dx*dx + dy*dy;
	
	return distance <= radiusX * radiusX;
func getCircle(center : Vector2i, radiusX : float, radiusY : float):
	var tileMap = LevelInfo.get_tile_map(tileMapName)
	var grassTileMap = LevelInfo.get_tile_map("Grass")
	if(!tileMap): return
	var top    =  floor(center.y - radiusY) -1
	var bottom = ceil(center.y + radiusY) + 1
	var left   =  floor(center.x - radiusX) -1
	var right  = ceil(center.x + radiusX) + 1
	for x in range(left, right):
		for y in range(top, bottom):
			if inside_circle(center, Vector2(x, y), radiusX, radiusY): 
				var grassCell = grassTileMap.get_cell_atlas_coords(Vector2i(x,y))
				if(grassCell.y == 0 && grassCell.x < 4): tileMap.set_cell(Vector2i(x, y), 0, Vector2i(0,1), 0)
				pass
				# draw tile (x, y)

func power_changed():
	if(LevelInfo.started):
		Zone.modulate = Color(0.1,1,0.1, 0.1)
		if(LevelInfo.selected_power == "Lightning"): Zone.visible = true
		else: Zone.visible = false
		return
	if(LevelInfo.selected_power == "StormCloud"): Zone.visible = true
	else: Zone.visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	interactableType = "StormCloud"
	LevelInfo.selected_power_changed.connect(power_changed)

func in_range(point : Vector2):
	return inside_circle(Zone.global_position, point, RadiusX*8, RadiusY*8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	if(LevelInfo.started):
		getCircle(Zone.global_position/8, RadiusX, RadiusY)
		return
	elif(dragging): Zone.visible = true

	
